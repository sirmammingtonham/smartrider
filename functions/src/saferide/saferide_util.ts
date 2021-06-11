import * as Hypertrack from "hypertrack";
import * as keys from "../setup/keys.json";
// import { Base64 } from "js-base64";

// const AUTHORIZATION =
//   "Basic " +
//   Base64.encode(`${keys.hypertrack_id}:${keys.hypertrack_secret}`);
// const DATE_FORMAT = "YYYY-MM-DD[T]HH:mm:ss[Z]";

const hypertrack = Hypertrack(keys.hypertrack_id, keys.hypertrack_secret);

/** Creates a trip using the hypertrack api trip object
 *  @param String deviceId, Any coordinates
 *  @modifies none
 *  @effects Creates a trip object with the specified data
 */
export async function createTrip(deviceId: string, coordinates: any) {
  try {
    const tripData = {
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

/** If the trip exists and was completed, the hypertrack trip will be switched to completed
 *  @param String tripId
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
