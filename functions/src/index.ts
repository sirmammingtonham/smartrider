// import * as bus from "./bus_exports";
import * as saferide from "./saferide_exports";
import * as bus from "./bus_exports";
import * as utils from "./test/util_exports";
import * as db from "./firestore/update_firestore";
//import * as saferide from "./saferide_exports";

// bus functions
// export const helloWorld = bus.helloWorld;
// export const busRoutes = bus.busRoutes;
// export const busTrips = bus.busTrips;
// export const busStops = bus.busStops;
// export const busShapes = bus.busShapes;
// export const busTimetables = bus.busTimetables;

// util functions
 export const refreshDataBase = db.refreshDataBase;
 //export const testenddate2 = utils.refreshDataBaseDemo;

// // saferide functions
// // export const srUpdateOrderStatus = saferide.srUpdateOrderStatus;
// // export const srDelOrder = saferide.srDelOrder;
// export const srOnTripUpdate = saferide.srOnTripUpdate;
// export const srOnCreate = saferide.srOnCreate;
// export const srOnOrderUpdate = saferide.srOnOrderUpdate;
// export const srOnDriverUpdate = saferide.srOnDriverUpdate;
// export const setDriver = saferide.setDriver;
// export const createTest = saferide.createTest;

// import * as t from "./firestore/create_fs"

// export const test = t.test;