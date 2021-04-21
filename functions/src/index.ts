import * as admin from 'firebase-admin';
admin.initializeApp(); // needs to go before other imports: https://github.com/firebase/firebase-functions-test/issues/6#issuecomment-496021884

import * as db from './bus/update_firestore_gtfs';
import * as db_tests from './bus/bus_test_funcs';
import * as saferide from "./saferide/saferide_listeners";
import * as saferide_tests from "./saferide/saferide_test_funcs";
import * as saferide_webhooks from "./saferide/saferide_webhooks";

// util functions
export const refreshDataBase = db.refreshDataBase;

// saferide functions
export const saferideOnOrderUpdate = saferide.onOrderUpdate;
export const saferideOnDriverUpdate = saferide.onDriverUpdate;

export const hypertrackTripWebhook = saferide_webhooks.hypertrackTripWebhook;

// export const createTest = saferide_tests.createTest;
// export const addTestDriver = saferide_tests.addTestDriver;
// export const testDB = db_tests.testDB;
