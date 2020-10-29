import * as moment from "moment";
import * as request from "request-promise";
import { Base64 } from "js-base64";

const AUTHORIZATION = "Basic " + Base64.encode("AccountId:SecretKey");

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

    const parsedBody = await request({
      method: "POST",
      uri: "https://v3.api.hypertrack.com/trips/",
      headers: {
        Authorization: AUTHORIZATION,
      },
      body: data,
      json: true, // Automatically stringifies the body to JSON
    });
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
      const parsedBody = await request({
        method: "POST",
        uri: `https://v3.api.hypertrack.com/trips/${tripId}/complete`,
        headers: {
          Authorization: AUTHORIZATION,
        },
        body: null,
      });
      console.log("completeTrip: " + JSON.stringify(parsedBody));

      return parsedBody;
    } catch (err) {
      console.error(err.message);
      console.trace();
    }
  }
}
