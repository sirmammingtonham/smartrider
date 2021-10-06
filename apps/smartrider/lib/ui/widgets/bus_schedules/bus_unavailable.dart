import 'package:flutter/material.dart';

class BusUnavailable extends StatelessWidget {
  const BusUnavailable({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Route not running today.'),
    );
  }
}
