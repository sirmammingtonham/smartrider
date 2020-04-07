import 'package:mock_cloud_firestore/mock_types.dart';
import 'package:test/test.dart';
import 'package:smartrider/backend/mock_database.dart';
import 'package:mock_cloud_firestore/mock_cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_test/flutter_test.dart';
//import 'package:provider/provider.dart';

void main() {
  String src = r"""
  {
    "users": {
      "1": {
        "Rin": "Goal",
        "id": "1",
        "name": "1"
      }
    }
  }
    """;
  test('database adding', () async{
    //setup

    //run
    final firestore = MockCloudFirestore(src);
    await firestore.collection("users").add({
      'message': 'yo'
    });

  });

  test('Recieve database data', () {
    //need to have a


    //runApp();
    //WidgetsFlutterBinding.ensureInitialized();
    //print("hello world");
    DatabaseService dataBase = DatabaseService(usid: "test");
    print(dataBase);
    print(dataBase.updateUserData("Name", "rin"));
    dataBase.debug();

    //print(DatabaseService(usid: "test3").updateUserData("Shirley Ann Jackson", "123456", "student") );
  });

  test('firestore mock usage', () async{
    String source = r"""
    {
      "goals": {
        "1": {
          "$": "Goal",
          "id": "1",
          "taskId": "1",
          "projectId": "1",
          "profileId": "1",
          "state": "ASSIGNED"
        }
      },
      "projects": {
        "1": {
          "id": "1",
          "$": "Project",
          "title": "test title",
          "description": "description",
          "contributors": [
            "2"
          ],
          "creatorProfileId": "3",
          "state": "INCOMPLETE"
        },
        "__where__": {
          "id == 1": {
            "1": {
              "id": "1",
              "$": "Project",
              "title": "test title",
              "description": "description",
              "contributors": [
                "2"
              ],
              "creatorProfileId": "3",
              "state": "INCOMPLETE"
            }
          }
        }
      },
      "tasks": {
        "1": {
          "id": "1",
          "$": "Task",
          "projectId": "123",
          "description": "test desc",
          "closeReason": "",
          "closeReasonDescription": "",
          "creatorProfileId": "123",
          "assigneeProfileId": "123",
          "state": "INCOMPLETE"
        }
      }
    }
    """;
    MockCloudFirestore mcf = MockCloudFirestore(source);
    MockCollectionReference col = mcf.collection("projects");
    MockDocumentReference doc = col.document("1");
    MockDocumentSnapshot docSnapshot = await doc.get();
    expect(docSnapshot.data["id"], "1");
    expect(docSnapshot.data["title"], "test project 1");
  });

  test('testing database adding to mock firestore', () async{
    const MessagesCollection = "messages";
    final firestore = MockFirestoreInstance();
    await firestore.collection(MessagesCollection).add({
      'message': 'Hello world!'
    });

  });

}