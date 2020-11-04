import * as bus from "./bus_exports";
import * as saferide from "./saferide_exports";

// bus functions
export const helloWorld = bus.helloWorld;
export const busRoutes = bus.busRoutes;
export const busTrips = bus.busTrips;
export const busStops = bus.busStops;
export const busShapes = bus.busShapes;
export const busTimetables = bus.busTimetables;

// saferide functions
// export const srUpdateOrderStatus = saferide.srUpdateOrderStatus;
// export const srDelOrder = saferide.srDelOrder;
export const srOnTripUpdate = saferide.srOnTripUpdate;