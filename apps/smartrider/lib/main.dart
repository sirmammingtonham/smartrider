import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smartrider/blocs/auth/auth_bloc.dart';
import 'package:smartrider/blocs/auth/data/auth_repository.dart';
import 'package:smartrider/blocs/map/data/bus_repository.dart';
import 'package:smartrider/blocs/map/data/shuttle_repository.dart';
import 'package:smartrider/blocs/map/map_bloc.dart';
import 'package:smartrider/blocs/preferences/prefs_bloc.dart';
import 'package:smartrider/blocs/saferide/data/saferide_repository.dart';
import 'package:smartrider/blocs/saferide/saferide_bloc.dart';
import 'package:smartrider/blocs/schedule/schedule_bloc.dart';
import 'package:smartrider/blocs/showcase/showcase_bloc.dart';
import 'package:smartrider/ui/home.dart';
import 'package:smartrider/ui/welcome.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // crashlytics not supported on web
  if (!kIsWeb) {
    if (kDebugMode) {
      // avoid generating crash reports when the app is in debug mode.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  if (const bool.hasEnvironment('EMULATORS')) {
    await FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
    FirebaseFunctions.instance.useFunctionsEmulator('10.0.2.2', 5001);
    FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);
  }
  final app = SmartRider(
    authRepo: await AuthRepository.create(),
    busRepo: await BusRepository.create(),
    shuttleRepo: ShuttleRepository.create(),
    saferideRepo: SaferideRepository.create(),
  );

  if (!kIsWeb) {
    //catch async errors as well
    await runZonedGuarded(
      () async {
        runApp(app);
      },
      FirebaseCrashlytics.instance.recordError,
    );
  } else {
    runApp(app);
  }
}

class SmartRider extends StatefulWidget {
  const SmartRider({
    Key? key,
    required this.authRepo,
    required this.busRepo,
    required this.shuttleRepo,
    required this.saferideRepo,
  }) : super(key: key);
  final AuthRepository authRepo;
  final BusRepository busRepo;
  final ShuttleRepository shuttleRepo;
  final SaferideRepository saferideRepo;

  @override
  SmartRiderState createState() => SmartRiderState();
}

class SmartRiderState extends State<SmartRider> with WidgetsBindingObserver {
  late final FlutterLocalNotificationsPlugin _notifications;
  late final AuthBloc _authBloc;
  late final PrefsBloc _prefsBloc;
  late final MapBloc _mapBloc;
  late final SaferideBloc _saferideBloc;
  late final ScheduleBloc _scheduleBloc;
  late final ShowcaseBloc _showcaseBloc;
  static const FlexScheme colorScheme = FlexScheme.redWine;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/New_York'));

    // init notifications
    _notifications = FlutterLocalNotificationsPlugin();
    _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
        iOS: IOSInitializationSettings(),
      ),
      onSelectNotification: (String? payload) {
        if (payload != null) {
          final params = jsonDecode(payload) as Map<String, dynamic>;
          _mapBloc.scrollToLatLng(
            LatLng(
              params['latitude'] as double,
              params['longitude'] as double,
            ),
          );
        }
      },
    );

    // verify api version for shuttle tracker

    setupInteractedMessage();

    // init blocs
    _prefsBloc = PrefsBloc()..add(const LoadPrefsEvent());
    _authBloc = AuthBloc(authRepository: widget.authRepo)..add(AuthInitEvent());
    _saferideBloc = SaferideBloc(
      prefsBloc: _prefsBloc,
      saferideRepo: widget.saferideRepo,
      authRepo: widget.authRepo,
      notifications: _notifications,
    );
    _mapBloc = MapBloc(
      saferideBloc: _saferideBloc,
      prefsBloc: _prefsBloc,
      busRepo: widget.busRepo,
      shuttleRepo: widget.shuttleRepo,
      saferideRepo: widget.saferideRepo,
    );
    _scheduleBloc = ScheduleBloc(
      mapBloc: _mapBloc,
      busRepo: widget.busRepo,
      notifications: _notifications,
    );
    _showcaseBloc = ShowcaseBloc(
      prefsBloc: _prefsBloc,
    );

    // init theme change
    final window = WidgetsBinding.instance!.window;
    window.onPlatformBrightnessChanged = () {
      // This callback is called every time the brightness changes.
      _mapBloc.add(
        MapThemeChangeEvent(
          theme: window.platformBrightness == Brightness.light
              ? FlexColorScheme.light(scheme: colorScheme).toTheme
              : FlexColorScheme.dark(scheme: colorScheme).toTheme,
        ),
      );
      setState(() {});
    };

    // dynamic links (for auth)
    initDynamicLinks();
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null && !kIsWeb) {
      _notifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'cloud_message',
            'Cloud Alerts',
            channelDescription:
                'Important notifications from service providers',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: IOSNotificationDetails(),
        ),
      );
    }
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData? dynamicLink) async {
      final deepLink = dynamicLink?.link;
      if (deepLink != null) {
        await _handleDeepLink(deepLink);
      }
    }).onError((dynamic e) {
      _authBloc.add(
        AuthFailedEvent(
          exception: e as Exception,
          message: 'Auth redirect failed!',
        ),
      );
    });

    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
      await _handleDeepLink(deepLink);
    }
  }

  Future<void> _handleDeepLink(Uri link) async {
    final params = link.queryParameters;
    if (params.containsKey('token')) {
      _authBloc.add(AuthSignInEvent(token: params['token']!));
    } else if (params.containsKey('code')) {
      _authBloc.add(
        AuthFailedEvent(
          message: "Authentication failed! Code: ${params['code']!}",
        ),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // monitor if the app is in the background (might not be needed but ¯\_(ツ)_/¯)
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        break;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PrefsBloc>(create: (context) => _prefsBloc),
        BlocProvider<AuthBloc>(create: (context) => _authBloc),
        BlocProvider<SaferideBloc>(create: (context) => _saferideBloc),
        BlocProvider<MapBloc>(create: (context) => _mapBloc),
        BlocProvider<ScheduleBloc>(create: (context) => _scheduleBloc),
        BlocProvider<ShowcaseBloc>(create: (context) => _showcaseBloc),
      ],
      child: MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ],
        ),
        debugShowCheckedModeBanner: false,
        title: 'smartrider Prototype',
        theme: FlexColorScheme.light(scheme: colorScheme).toTheme,
        darkTheme: FlexColorScheme.dark(scheme: colorScheme).toTheme,
        home: ShowCaseWidget(
          builder: Builder(
            builder: (context) => const WelcomeScreen(homePage: HomePage()),
          ),
          autoPlay: true,
          autoPlayDelay: const Duration(seconds: 10),
        ),
      ),
    );
  }
}
