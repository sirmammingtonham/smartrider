// we should have an account associated with each saferide car
// that they need to use to log in
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:smartdriver/blocs/authentication/authentication_bloc.dart';

class Login extends StatelessWidget {
  Login({
    Key? key,
    String? driverName,
    String? phoneNumber,
    String? vehicleId,
  }) : super(key: key) {
    _nameController.text = driverName ?? '';
    _phoneController.text = phoneNumber ?? '';
    _vehicleController.text = vehicleId ?? '';
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('smartdriver'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.h),
          child: Column(
            children: <Widget>[
              // Container(
              //   child: Text('LOGIN'),
              // ),
              Container(height: 5.h),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Name that will be displayed to users'),
              ),
              Container(height: 3.h),
              TextFormField(
                controller: _phoneController,
                obscureText: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone #',
                    hintText: 'Your phone number'),
              ),
              Container(height: 3.h),
              TextFormField(
                controller: _vehicleController,
                obscureText: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Vehicle ID'),
              ),
              Container(height: 3.h),
              TextFormField(
                controller: _passwordController,
                obscureText: false,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
              Container(height: 3.h),
              Container(
                height: 7.h,
                width: 60.w,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(AuthenticationLoginEvent(
                      driverName: _nameController.text.trim(),
                      vehicleId: _vehicleController.text.trim(),
                      phoneNumber: _phoneController.text.trim(),
                      password: _passwordController.text.trim(),
                    ));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
