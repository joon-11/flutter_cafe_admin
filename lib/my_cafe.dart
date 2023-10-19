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

  Future<dynamic> get({
    required String collectionName,
    required String? id, //고유아이디
    required String? filedName, //이름
    required String? filedValue,
  }) async {
    try {
      //전체찾기
      if (id == null && filedName == null) {
        return db.collection(collectionName).get();
      } else if (id != null) {
        //고유아이디로 찾아서 리턴
        return db.collection(collectionName).doc(id).get();
      } else if (filedName != null) {
        //필드값을 가지고 찾기
        return db
            .collection(collectionName)
            .where(filedName, isEqualTo: filedValue);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> delete({required String collectionName, required id}) async {
    try {
      var result = await db.collection(collectionName).doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
