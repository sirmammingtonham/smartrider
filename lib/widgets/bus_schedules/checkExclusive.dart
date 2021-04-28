import 'package:intl/intl.dart';
import 'package:smartrider/data/models/bus/bus_timetable.dart';

bool checkExclusiveDates(BusTimetable timetable) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat.yMMMMd('en_US');
  final String today = formatter.format(now);
  if (timetable.excludeDates.contains(today)) {
    return true;
  } else {
    return false;
  }
}
