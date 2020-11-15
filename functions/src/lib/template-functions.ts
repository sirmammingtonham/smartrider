// @ts-expect-error ts-migrate(2451) FIXME: Cannot redeclare block-scoped variable 'every'.
const { every } = require('lodash');

/*
 * Format an id to be used as an HTML attribute.
 */
exports.formatHtmlId = (id: any) => id.replace(/([^\w[\]{}.:-])\s?/g, '');

/*
 * Discern if a day list should be shown for a specific timetable (if some
 * trips happen on different days).
 */
exports.timetableHasDifferentDays = (timetable: any) => {
  return !every(timetable.orderedTrips, (trip: any, idx: any) => {
    if (idx === 0) {
      return true;
    }

    return trip.dayList === timetable.orderedTrips[idx - 1].dayList;
  });
};

/*
 * Discern if a day list should be shown for a specific timetable page's menu (if some
 * timetables are for different days).
 */
exports.timetablePageHasDifferentDays = (timetablePage: any) => {
  return !every(timetablePage.consolidatedTimetables, (timetable: any, idx: any) => {
    if (idx === 0) {
      return true;
    }

    return timetable.dayListLong === timetablePage.consolidatedTimetables[idx - 1].dayListLong;
  });
};

/*
 * Discern if individual timetable labels should be shown (if some
 * timetables have different labels).
 */
exports.timetablePageHasDifferentLabels = (timetablePage: any) => {
  return !every(timetablePage.consolidatedTimetables, (timetable: any, idx: any) => {
    if (idx === 0) {
      return true;
    }

    return timetable.timetable_label === timetablePage.consolidatedTimetables[idx - 1].timetable_label;
  });
};

/*
 * Discern if a timetable has any notes or notices to display.
 */
exports.hasNotesOrNotices = (timetable: any) => {
  return timetable.requestPickupSymbolUsed ||
    timetable.noPickupSymbolUsed ||
    timetable.requestDropoffSymbolUsed ||
    timetable.noDropoffSymbolUsed ||
    timetable.noServiceSymbolUsed ||
    timetable.interpolatedStopSymbolUsed ||
    timetable.notes.length > 0;
};

/*
 * Return an array of all timetable notes that relate to the entire timetable or route.
 */
exports.getNotesForTimetableLabel = (notes: any) => {
  return notes.filter((note: any) => {
    return !note.stop_id && !note.trip_id;
  });
};

/*
 * Return an array of all timetable notes for a specific stop and stop_sequence.
 */
exports.getNotesForStop = (notes: any, stop: any) => {
  return notes.filter((note: any) => {
    // Don't show if note applies only to a specific trip.
    if (note.trip_id) {
      return false;
    }

    // Don't show if note applies only to a specific stop_sequence that is not found.
    if (note.stop_sequence && !stop.trips.find((trip: any) => trip.stop_sequence === note.stop_sequence)) {
      return false;
    }

    return note.stop_id === stop.stop_id;
  });
};

/*
 * Return an array of all timetable notes for a specific trip.
 */
exports.getNotesForTrip = (notes: any, trip: any) => {
  return notes.filter((note: any) => {
    // Don't show if note applies only to a specific stop.
    if (note.stop_id) {
      return false;
    }

    return note.trip_id === trip.trip_id;
  });
};

/*
 * Return an array of all timetable notes for a specific stoptime.
 */
exports.getNotesForStoptime = (notes: any, stoptime: any) => {
  return notes.filter((note: any) => {
    // Show notes that apply to all trips at this stop if `show_on_stoptime` is true.
    if (!note.trip_id && note.stop_id === stoptime.stop_id && note.show_on_stoptime === 1) {
      return true;
    }

    // Show notes that apply to all stops of this trip if `show_on_stoptime` is true.
    if (!note.stop_id && note.trip_id === stoptime.trip_id && note.show_on_stoptime === 1) {
      return true;
    }

    return note.trip_id === stoptime.trip_id && note.stop_id === stoptime.stop_id;
  });
};
