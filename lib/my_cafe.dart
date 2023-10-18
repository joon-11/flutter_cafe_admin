import 'package:cloud_firestore/cloud_firestore.dart';

class MyCafe {
  var db = FirebaseFirestore.instance;

  Future<bool> insert(
      {required String collectionName,
      required Map<String, dynamic> data}) async {
    try {
      var result = await db.collection(collectionName).add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> get(
      {required String collectionName}) async {
    try {
      return db.collection(collectionName).get();
    } catch (e) {
      return null;
    }
  }
}
