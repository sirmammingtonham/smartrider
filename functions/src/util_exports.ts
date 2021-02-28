
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as serviceAccount from "./setup/smartrider-4e9e8-service.json";
import { isNumber } from "lodash";
// 1. pull data from firestore
// 2. get earliest expiration date
// 3. if earliest < today then update
// Note: this function will be run at 12:01 am everyday
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
  });

  console.log("initialized");
  
function convertcrontab(date: number){ // convert number date to crontab format
    
}

export const refreshDataBaseDemo = functions.https.onRequest(async (req,res) =>{
    const db = admin.firestore();

    var enddates: number[];
    enddates = [];
    
    db.collection("calendar").get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            var end_date = doc.get('end_date');
            if (isNumber(end_date)){
                enddates.push(end_date);
            }
            else{
                console.log("error bruh");
            }
        });

        enddates.sort();

        var currentDate = new Date();
        var dd = String(currentDate.getDate()).padStart(2,'0');
        var mm = String(currentDate.getMonth()+1).padStart(2,'0');
        var yyyy = currentDate.getFullYear();
        var today: number = +(yyyy+mm+dd); 

        if (enddates[0] <= today){
            res.status(200).json({ earliest: enddates[0], update:"needed" });
        }
        else{
            res.status(200).json({ earliest: enddates[0], update: "not needed" });
        }

        
    });

} );


// Actual Function will require cloud scheduler, which is not cheap
// export const RefreshDataBase = functions.pubsub.schedule('every 5 seconds').onRun((context) => { 
//     console.log('This will be run every 5 minutes!');
//     return null;
//   });








//export const testfunct = functions.pubsub.schedule('5 11 * * *');

