import 'package:equatable/equatable.dart';

class Time extends Comparable<Time> {
  bool isMilitary; //if time is military time (default is true)
  int hour;
  int minute;
  int second;
  String str;
  Time({this.str, this.isMilitary = true}) {
    // default constructor
    int first = str.indexOf(":");
    int second = str.lastIndexOf(":");
    this.hour = int.parse(str.substring(0, first));
    this.minute = int.parse(str.substring(first + 1, second));
    this.second = int.parse(str.substring(second + 1));
  }

  Time.copyContructor({this.hour, this.minute, this.second, this.isMilitary}) {
    this.str = null;
  }

  @override
  int compareTo(Time other) {
    // return positive if current is larger than other can be used with .sort
    return (this.hour * 3600 + this.minute * 60 + this.second) -
        (other.hour * 3600 + other.minute * 60 + other.second);
  }

  Time operator +(Time other) {
    return Time.copyContructor(
        hour: this.hour + other.hour,
        minute: this.minute + other.minute,
        second: this.second + other.second,
        isMilitary: this.isMilitary);
  }

  Time operator -(Time other) {
    return Time.copyContructor(
        hour: this.hour - other.hour,
        minute: this.minute - other.minute,
        second: this.second - other.second,
        isMilitary: this.isMilitary);
  }

  @override
  String toString() => this.str;
}
