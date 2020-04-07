import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartrider/backend/database.dart';

class QueueService{
  final String usid;

  final CollectionReference _Qcollection = Firestore.instance.collection(anything we want here);
  QueueService({this.usid});

  //function to see the top of the queue (only drivers should be able to do this)

  //function to see how many people are ahead of you in the queue(student)

  //function to remove top from queue(only drivers should be able to this)

  //function to remove self from queue
}