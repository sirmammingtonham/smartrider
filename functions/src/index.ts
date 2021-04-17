// import * as admin from 'firebase-admin';
import * as saferide from "./saferide/saferide_listeners";
import * as saferide_tests from "./saferide/saferide_testfuncs";

// admin.initializeApp();

// util functions
// export const refreshDataBase = db.refreshDataBase;

// saferide functions
// export const srUpdateOrderStatus = saferide.srUpdateOrderStatus;
// export const srDelOrder = saferide.srDelOrder;
// export const srOnTripUpdate = saferide.srOnTripUpdate;
export const srOnOrderUpdate = saferide.onOrderUpdate;
export const srOnDriverUpdate = saferide.onDriverUpdate;
export const createTest = saferide_tests.createTest;
export const addTestDriver = saferide_tests.addTestDriver;
