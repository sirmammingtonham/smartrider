// import * as moment from "moment";
import * as Hypertrack from "hypertrack";
import * as keys from "../setup/keys.json";
import { DocumentSnapshot } from "@google-cloud/firestore";
import { Change, EventContext } from "firebase-functions";
// import { Base64 } from "js-base64";

// const AUTHORIZATION =
//   "Basic " +
//   Base64.encode(`${keys.hypertrack_id}:${keys.hypertrack_secret}`);

// const DATE_FORMAT = "YYYY-MM-DD[T]HH:mm:ss[Z]";
const hypertrack = Hypertrack(keys.hypertrack_id, keys.hypertrack_secret);

export async function acceptOrder(
  change: Change<DocumentSnapshot>,
  _context: EventContext
) {
  // const beforeValue = change.before.data();
  const afterValue = change.after.data();

  if (!afterValue) return;

  const parsedBody = await createTrip(
    afterValue.driver.device_id,
    afterValue.pickups
  );

  if (parsedBody["trip_id"]) {
    // const updatedAt = moment().format(DATE_FORMAT);
    return change.after.ref.set(
      {
        updated_at: Date.now(),
        status: "PICKING_UP",
        trip_id: parsedBody["trip_id"],
      },
      { merge: true }
    );
  } else {
    console.error(`malformed request: ${parsedBody}`);
    return;
  }
}

// updateOrderStatus(require('./testData.json').startRide)
export async function startRide(
  change: Change<DocumentSnapshot>,
  _context: EventContext
) {
  const beforeValue = change.before.data();
  const afterValue = change.after.data();

  if (!beforeValue || !afterValue) return;

  await completeTrip(beforeValue.trip_id);
  const parsedBody = await createTrip(
    afterValue.driver.device_id,
    afterValue.dropoff
  );

  if (parsedBody["trip_id"]) {
    // const updatedAt = moment().format(DATE_FORMAT);
    return change.after.ref.set(
      {
        updated_at: Date.now(),
        status: "DROPPING_OFF",
        trip_id: parsedBody["trip_id"],
      },
      { merge: true }
    );
  } else {
    console.error(`malformed request: ${parsedBody}`);
    return;
  }
}

// updateOrderStatus(require('./testData.json').rejectRide)
export async function rejectRide(
  change: Change<DocumentSnapshot>,
  _context: EventContext
) {
  const beforeValue = change.before.data();
  if (!beforeValue) return;

  await completeTrip(beforeValue.trip_id);

  // const updatedAt = moment().format(DATE_FORMAT);
  return change.after.ref.delete();
}

// updateOrderStatus(require('./testData.json').endRide)
export async function endRide(
  change: Change<DocumentSnapshot>,
  _context: EventContext
) {
  const beforeValue = change.before.data();
  if (!beforeValue) return;

  await completeTrip(beforeValue.trip_id);

  // const updatedAt = moment().format(DATE_FORMAT);
  return change.after.ref.delete();
}

//Creates a trip using the hypertrack api trip object
/* @param String deviceId, Any coordinates
 *  @modifies none
 *  @effects Creates a trip object with the specified data
 */
export async function createTrip(deviceId: string, coordinates: any) {
  try {
    let tripData = {
      device_id: deviceId,
      destination: {
        geometry: {
          type: "Point",
          coordinates: [coordinates.longitude, coordinates.latitude],
        },
        radius: 100,
      },
    };

    const trip = await hypertrack.trips.create(tripData);
    console.log("createTrip: " + JSON.stringify(trip));

    return trip;
  } catch (err) {
    console.error(err.message);
    console.trace();
  }
}

//If the trip exists and was completed, the hypertrack trip will be switched to completed
/* @param String tripId
 *  @modifies If the tripId exists, the trip is changed to completed, and also changes the order that
 *  the trip was associated with to completed
 */
export async function completeTrip(tripId: string) {
  if (tripId) {
    try {
      const trip = await hypertrack.trips.complete(tripId);
      console.log("completeTrip: " + JSON.stringify(trip));
      return trip;
    } catch (err) {
      console.error(err.message);
      console.trace();
    }
  }
}
