// @ts-expect-error ts-migrate(2451) FIXME: Cannot redeclare block-scoped variable 'moment'.
const moment = require('moment');

/*
 * Convert a GTFS formatted time string into a moment less than 24 hours.
 */
exports.fromGTFSTime = (timeString: any) => {
  const duration = moment.duration(timeString);

  return moment({
    hour: duration.hours(),
    minute: duration.minutes(),
    second: duration.seconds()
  });
};

/*
 * Convert a moment into a GTFS formatted time string.
 */
exports.toGTFSTime = (time: any) => {
  return time.format('HH:mm:ss');
};

/*
 * Convert a GTFS formatted date string into a moment.
 */
exports.fromGTFSDate = (gtfsDate: any) => moment(gtfsDate, 'YYYYMMDD');

/*
 * Convert a moment date into a GTFS formatted date string.
 */
exports.toGTFSDate = (date: any) => moment(date).format('YYYYMMDD');

/*
 * Convert a object of weekdays into a a string containing 1s and 0s.
 */
exports.calendarToCalendarCode = (c: any) => {
  if (c.service_id) {
    return c.service_id;
  }

  return `${c.monday}${c.tuesday}${c.wednesday}${c.thursday}${c.friday}${c.saturday}${c.sunday}`;
};

/*
 * Convert a string of 1s and 0s representing a weekday to an object.
 */
exports.calendarCodeToCalendar = (code: any) => {
  const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
  const calendar = {};

  // @ts-expect-error ts-migrate(2569) FIXME: Type 'IterableIterator<[number, string]>' is not a... Remove this comment to see the full error message
  for (const [index, day] of days.entries()) {
    // @ts-expect-error ts-migrate(7053) FIXME: Element implicitly has an 'any' type because expre... Remove this comment to see the full error message
    calendar[day] = code[index];
  }

  return calendar;
};

/*
 * Get number of seconds after midnight of a GTFS formatted time string.
 */
exports.secondsAfterMidnight = (timeString: any) => {
  return moment.duration(timeString).asSeconds();
};

/*
 * Get number of minutes after midnight of a GTFS formatted time string.
 */
exports.minutesAfterMidnight = (timeString: any) => {
  return moment.duration(timeString).asMinutes();
};

/*
 * Add specified number of seconds to a GTFS formatted time string.
 */
exports.updateTimeByOffset = (timeString: any, offsetSeconds: any) => {
  const newTime = exports.fromGTFSTime(timeString);
  return exports.toGTFSTime(newTime.add(offsetSeconds, 'seconds'));
};
