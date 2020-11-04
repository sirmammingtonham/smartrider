import * as moment from "moment";
// trying to convert to axios becaues requests is deprecated
import axios from "axios";
import * as config from "./keys.json";
import { Base64 } from "js-base64";

const AUTHORIZATION =
  "Basic " +
  Base64.encode(`${config.hypertrack_id}:${config.hypertrack_secret}`);
const DATE_FORMAT = "YYYY-MM-DD[T]HH:mm:ss[Z]";

export async function acceptOrder(change: any, _: any) {
  // const beforeValue = change.before.data();
  const afterValue = change.after.data();

  const parsedBody = await createTrip(
    afterValue.driver.device_id,
    afterValue.pickup
  );

  if (parsedBody["trip_id"]) {
    const updatedAt = moment().format(DATE_FORMAT);
    return change.after.ref.set(
      {
        updated_at: updatedAt,
        status: "PICKING_UP",
        trip_id: parsedBody["trip_id"],
      },
      { merge: true }
    );
  }
}

// updateOrderStatus(require('./testData.json').startRide)
export async function startRide(change: any, _: any) {
  const beforeValue = change.before.data();
  const afterValue = change.after.data();

  await completeTrip(beforeValue.trip_id);
  const parsedBody = await createTrip(
    afterValue.driver.device_id,
    afterValue.dropoff
  );

  if (parsedBody["trip_id"]) {
    const updatedAt = moment().format(DATE_FORMAT);
    return change.after.ref.set(
      {
        updated_at: updatedAt,
        status: "DROPPING_OFF",
        trip_id: parsedBody["trip_id"],
      },
      { merge: true }
    );
  }
}

// updateOrderStatus(require('./testData.json').rejectRide)
export async function rejectRide(change: any, _: any) {
  const beforeValue = change.before.data();

  await completeTrip(beforeValue.trip_id);

  const updatedAt = moment().format(DATE_FORMAT);
  return change.after.ref.set(
    {
      updated_at: updatedAt,
      trip_id: null,
      driver: null,
    },
    { merge: true }
  );
}

// updateOrderStatus(require('./testData.json').endRide)
export async function endRide(change: any, _: any) {
  const beforeValue = change.before.data();

  await completeTrip(beforeValue.trip_id);

  const updatedAt = moment().format(DATE_FORMAT);
  return change.after.ref.set(
    {
      updated_at: updatedAt,
    },
    { merge: true }
  );
}

export async function createTrip(deviceId: string, coordinates: any) {
  try {
    const data: any = {};
    data["device_id"] = deviceId;
    data["destination"] = {
      radius: 100,
      geometry: {
        type: "Point",
        coordinates: [coordinates.longitude, coordinates.latitude],
      },
    };

    // const parsedBody_ = await request({
    //   method: "POST",
    //   uri: "https://v3.api.hypertrack.com/trips/",
    //   headers: {
    //     Authorization: AUTHORIZATION,
    //   },
    //   body: data,
    //   json: true, // Automatically stringifies the body to JSON
    // });

    const parsedBody = (
      await axios.post("https://v3.api.hypertrack.com/trips/", data, {
        headers: {
          Authorization: AUTHORIZATION,
        },
      })
    ).data;

    console.log("createTrip: " + JSON.stringify(parsedBody));
    console.log("createTrip:trip_id: " + parsedBody["trip_id"]);

    return parsedBody;
  } catch (err) {
    console.error(err.message);
    console.trace();
  }
}

export async function completeTrip(tripId: string) {
  if (tripId) {
    try {
      // const parsedBody = await request({
      //   method: "POST",
      //   uri: `https://v3.api.hypertrack.com/trips/${tripId}/complete`,
      //   headers: {
      //     Authorization: AUTHORIZATION,
      //   },
      //   body: null,
      // });
      
      const parsedBody = (
        await axios.post(
          `https://v3.api.hypertrack.com/trips/${tripId}/complete`,
          null,
          {
            headers: {
              Authorization: AUTHORIZATION,
            },
          }
        )
      ).data;

      console.log("completeTrip: " + JSON.stringify(parsedBody));

      return parsedBody;
    } catch (err) {
      console.error(err.message);
      console.trace();
    }
  }
}
