import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartdriver/blocs/authentication/authentication_bloc.dart';
import 'package:smartdriver/blocs/location/location_bloc.dart';
import 'package:smartdriver/blocs/order/order_bloc.dart';
import 'package:smartdriver/blocs/authentication/data/authentication_repository.dart';
import 'package:smartdriver/blocs/order/data/order_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'package:smartdriver/ui/home.dart';
import 'package:smartdriver/ui/login.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
  runZonedGuarded(() {
    //catch async errors as well
    runApp(const SmartDriver());
  }, FirebaseCrashlytics.instance.recordError);
}

class SmartDriver extends StatefulWidget {
  const SmartDriver({Key? key}) : super(key: key);

  @override
  _SmartDriverState createState() => _SmartDriverState();
}

class _SmartDriverState extends State<SmartDriver> with WidgetsBindingObserver {
  final authenticationRepository = AuthenticationRepository();
  final orderRepository = OrderRepository();
  late final LocationBloc locationBloc;
  late final AuthenticationBloc authenticationBloc;
  late final OrderBloc orderBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    locationBloc = LocationBloc();
    authenticationBloc = AuthenticationBloc(
        authRepository: authenticationRepository, locationBloc: locationBloc);
    orderBloc = OrderBloc(
        authenticationRepository: authenticationRepository,
        orderRepository: orderRepository);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        await orderBloc.updateAvailibility(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        // switch driver to unavailable if app is detached
        // since we need to make sure we don't assign
        // riders to unavailable drivers
        await orderBloc.updateAvailibility(false);
        break;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LocationBloc>(create: (context) => locationBloc),
          BlocProvider<AuthenticationBloc>(
              create: (context) => authenticationBloc),
          BlocProvider<OrderBloc>(create: (context) => orderBloc),
        ],
        child: Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'smartdriver',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case AuthenticationSignedOutState:
                    return Login(
                      driverName:
                          (state as AuthenticationSignedOutState).driverName,
                      phoneNumber: state.phoneNumber,
                      vehicleId: state.vehicleId,
                    );
                  case AuthenticationSignedInState:
                    return Home(
                        title:
                            (state as AuthenticationSignedInState).user.name);
                  case AuthenticationFailureState:
                    return Text(
                        (state as AuthenticationFailureState).errorMessage);
                  default:
                    return const Text('AUTH BLOC ERROR');
                }
              },
            ),
          );
        }));
  }
}
