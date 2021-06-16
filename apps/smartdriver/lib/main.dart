import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartdriver/blocs/authentication/authentication_bloc.dart';
import 'package:smartdriver/blocs/location/location_bloc.dart';
import 'package:smartdriver/blocs/order/order_bloc.dart';
import 'package:smartdriver/data/repositories/authentication_repository.dart';
import 'package:smartdriver/data/repositories/order_repository.dart';

import 'package:smartdriver/pages/home.dart';
import 'package:smartdriver/pages/login.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SmartDriver());
}

class SmartDriver extends StatelessWidget {
  final authenticationRepository = AuthenticationRepository();
  final orderRepository = OrderRepository();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
          BlocProvider<AuthenticationBloc>(
              create: (context) => AuthenticationBloc(
                  authRepository: authenticationRepository,
                  locationBloc: BlocProvider.of<LocationBloc>(context))),
          BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(
                authenticationRepository: authenticationRepository,
                orderRepository: orderRepository),
          ),
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
                  case AuthenticationLoggedOutState:
                    // return Login();
                    return Home(title: 'bruhhh');
                  case AuthenticationLoggedInState:
                    return Home(
                        title:
                            (state as AuthenticationLoggedInState).user.name);
                  case AuthenticationFailureState:
                    return Container(
                      child: Text(
                          (state as AuthenticationFailureState).errorMessage),
                    );
                  default:
                    return Container(
                      child: Text('AUTH BLOC ERROR'),
                    );
                }
              },
            ),
          );
        }));
  }
}
