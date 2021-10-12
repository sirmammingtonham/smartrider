import * as admin from 'firebase-admin';
admin.initializeApp(); // needs to go before other imports: https://github.com/firebase/firebase-functions-test/issues/6#issuecomment-496021884
import * as functions from "firebase-functions";
/// bus functions
import * as db from './bus/update_firestore_gtfs';
export const refreshDataBase = db.refreshDataBase;
import * as sfcu from './saferide/saferide_cleanup';
export const saferideCleanup = sfcu.saferideOrderFlush;
import * as cors_proxy from 'cors-anywhere';

const runtimeOpts: functions.RuntimeOptions = {
    timeoutSeconds: 3, // timeout function after 2 secs
    memory: "256MB", // allocate 256MB of mem per function
};

/// saferide functions
// import * as saferide from "./saferide/saferide_listeners";
// import * as saferide_webhooks from "./saferide/saferide_webhooks";
// export const saferideOnOrderUpdate = saferide.onOrderUpdate;
// export const saferideOnDriverUpdate = saferide.onDriverUpdate;

// export const hypertrackTripWebhook = saferide_webhooks.hypertrackTripWebhook;

/// test functions
// import * as db_tests from './bus/bus_test_funcs';
import * as saferide_tests from "./saferide/saferide_test_funcs";
export const createTest = saferide_tests.createTest;
export const addTestDriver = saferide_tests.addTestDriver;
// export const testDB = db_tests.testDB;
const proxy = cors_proxy.createServer({
    // requireHeader: ['origin', 'x-requested-with'],
    removeHeaders: [
        'cookie',
        'cookie2',
    ],
});

export const proxyWithCorsAnywhere = functions
    .runWith(runtimeOpts)
    .https.onRequest((req, res) => {
    proxy.emit('request', req, res);
});