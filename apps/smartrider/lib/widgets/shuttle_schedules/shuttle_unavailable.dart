import 'package:flutter/material.dart';

class ShuttleUnavailable extends StatelessWidget {
  const ShuttleUnavailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No paper schedules this semester.'),
    );
  }
}
