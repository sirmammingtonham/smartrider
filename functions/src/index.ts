import * as admin from 'firebase-admin';
admin.initializeApp(); // needs to go before other imports: https://github.com/firebase/firebase-functions-test/issues/6#issuecomment-496021884

/// bus functions
import * as db from './bus/update_firestore_gtfs';
export const refreshDataBase = db.refreshDataBase;

/// saferide functions
// import * as saferide from "./saferide/saferide_listeners";
// import * as saferide_webhooks from "./saferide/saferide_webhooks";
// export const saferideOnOrderUpdate = saferide.onOrderUpdate;
// export const saferideOnDriverUpdate = saferide.onDriverUpdate;

// export const hypertrackTripWebhook = saferide_webhooks.hypertrackTripWebhook;

/// test functions
// import * as db_tests from './bus/bus_test_funcs';
// import * as saferide_tests from "./saferide/saferide_test_funcs";
// export const createTest = saferide_tests.createTest;
// export const addTestDriver = saferide_tests.addTestDriver;
// export const testDB = db_tests.testDB;
