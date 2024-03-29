import 'package:equatable/equatable.dart';

// ignore: camel_case_types
class time extends Comparable<time> {
  bool isMilitary; //if time is military time (default is true)
  int hour;
  int minute;
  int second;
  String str;
  time({this.str, this.isMilitary = true}) {
    // default constructor
    int first = str.indexOf(":");
    int second = str.lastIndexOf(":");
    this.hour = int.parse(str.substring(0, first));
    this.minute = int.parse(str.substring(first + 1, second));
    this.second = int.parse(str.substring(second + 1));
  }

  time.copyContructor({this.hour, this.minute, this.second, this.isMilitary}) {
    this.str = 
    "${this.hour.toString().padLeft(2,"0")}:${this.minute.toString().padLeft(2,"0")}:${this.second.toString().padLeft(2,"0")}";
  }

  @override
  int compareTo(time other) {
    // return positive if current is larger than other can be used with .sort
    return (this.hour * 3600 + this.minute * 60 + this.second) -
        (other.hour * 3600 + other.minute * 60 + other.second);
  }

  time operator +(time other) {
    return time.copyContructor(
        hour: this.hour + other.hour,
        minute: this.minute + other.minute,
        second: this.second + other.second,
        isMilitary: this.isMilitary);
  }

  time operator -(time other) {
    return time.copyContructor(
        hour: this.hour - other.hour,
        minute: this.minute - other.minute,
        second: this.second - other.second,
        isMilitary: this.isMilitary);
  }

  @override
  String toString() => this.str;
}
