import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartrider/backend/database.dart';
import 'dart:collection';

class QueueService{
  final String usid;

  /*
  void main() {
  List<String> other = ["a","b","c"];
  Queue<String> queue = new Queue<String>();
  queue.addAll(other);
  print(queue); // prints "{a, b, c}"
}
   */ //THis looks like it will be good for populating the queue

  // final CollectionReference _Qcollection = Firestore.instance.collection(anything we want here);
  QueueService({this.usid});
  Queue<String> queue = new Queue<String>();

  //queue.add("string");

  //function to see the top of the queue (only drivers should be able to do this)

      //String qTop = queue.first()
      //print(qTop) this will be to test

  //function to see how many people are ahead of you in the queue(student)

      //First see if queue is empty
      // if queue.isEmpty() return 0
      //

  //function to remove self from queue
    //first ensure they are in the queue
    /*bool contains(Object element) {
    for (E e in this) {
      if (e == element) return true;
      }
      return false;
    }*/
    //bool remove(Object value);
}