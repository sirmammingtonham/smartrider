// ignore: camel_case_types
class time extends Comparable<time> {
  time({this.str, this.isMilitary = true}) {
    // default constructor
    final first = str!.indexOf(':');
    final second = str!.lastIndexOf(':');
    hour = int.parse(str!.substring(0, first));
    minute = int.parse(str!.substring(first + 1, second));
    this.second = int.parse(str!.substring(second + 1));
  }

  time.copyContructor({this.hour, this.minute, this.second, this.isMilitary}) {
    str = '${hour.toString().padLeft(2, '0')}'
        ':${minute.toString().padLeft(2, '0')}'
        ':${second.toString().padLeft(2, '0')}';
  }

  bool? isMilitary; //if time is military time (default is true)
  int? hour;
  int? minute;
  int? second;
  String? str;

  @override
  int compareTo(time other) {
    // return positive if current is larger than other can be used with .sort
    return (hour! * 3600 + minute! * 60 + second!) -
        (other.hour! * 3600 + other.minute! * 60 + other.second!);
  }

  time operator +(time other) {
    return time.copyContructor(
        hour: hour! + other.hour!,
        minute: minute! + other.minute!,
        second: second! + other.second!,
        isMilitary: isMilitary);
  }

  time operator -(time other) {
    return time.copyContructor(
        hour: hour! - other.hour!,
        minute: minute! - other.minute!,
        second: second! - other.second!,
        isMilitary: isMilitary);
  }

  @override
  String toString() => str!;
}
