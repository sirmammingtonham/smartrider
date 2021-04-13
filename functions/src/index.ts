import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import * as saferide from "./saferide_exports";
import * as db from "./firestore/update_firestore";

// admin.initializeApp();

// util functions
// export const refreshDataBase = db.refreshDataBase;

// saferide functions
// export const srUpdateOrderStatus = saferide.srUpdateOrderStatus;
// export const srDelOrder = saferide.srDelOrder;
export const srOnTripUpdate = saferide.srOnTripUpdate;
export const srOnCreate = saferide.srOnCreate;
export const srOnOrderUpdate = saferide.srOnOrderUpdate;
export const srOnDriverUpdate = saferide.srOnDriverUpdate;
export const setDriver = saferide.setDriver;
export const createTest = saferide.createTest;