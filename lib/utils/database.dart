import 'package:cloud_firestore/cloud_firestore.dart';



class Database {

  final CollectionReference _mainCollection = FirebaseFirestore.instance.collection('Map');

  Stream<QuerySnapshot> getStream() {
    return _mainCollection.snapshots();
  }
}