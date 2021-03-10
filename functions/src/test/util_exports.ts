import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as serviceAccount from "../setup/smartrider-4e9e8-service.json";
import { isNumber } from "lodash";
//import { generateDB } from "./firestore/update_firestore";

// 1. pull data from firestore
// 2. get earliest expiration date
// 3. if earliest < today then update
// Note: this function will be run at 12:01 am everyday
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
  });

export const refreshDataBaseDemo = functions.https.onRequest(async (req, res) => {
    const db = admin.firestore();

    const enddates: number[] = [];

    db.collection('routes').get().then((querySnapshot) => {
        if (!querySnapshot.empty) {
            querySnapshot.forEach((doc) => {
                console.log("doc exits");
                const end_date = doc.get('end_date');
                if (isNumber(end_date)) {
                    enddates.push(end_date);
                    console.log(end_date);
                }
                else {
                    console.log("error bruh");
                }
            });
        }
        else{
            console.log("Error: collection is empty");
        }


        enddates.sort();

        const currentDate = new Date();
        const dd = String(currentDate.getDate()).padStart(2, '0');
        const mm = String(currentDate.getMonth() + 1).padStart(2, '0');
        const yyyy = currentDate.getFullYear();
        const today: number = +(yyyy + mm + dd);

        if (enddates[0] <= today) { //update needed
            res.status(200).json({ earliest: enddates[0], update: "needed" });
        }
        else {  //update not needed
            res.status(200).json({ earliest: enddates[0], update: "not needed" });
        }

    }).catch((error) => console.log(error));

});

