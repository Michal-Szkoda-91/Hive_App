import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:wireless_hive/models/apiary.dart';
import 'package:wireless_hive/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // colection reference\
  final DatabaseReference apiaryReference =
      FirebaseDatabase.instance.reference().child('apiary');
  final CollectionReference apiaryCollection =
      FirebaseFirestore.instance.collection('apiary');

  Future updateUserData(String apiaryName, String address, String uid) async {
    return await apiaryReference.push().set({
      'apiaryName': apiaryName,
      'address': address,
      'uid': uid,
    });
  }

  Future deleteUserData(String apiaryName, String address) async {
    return await apiaryCollection.doc(uid).delete();
  }

  //brew list from snapshot
  List<Apiary> _apiaryListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Apiary(
          apiaryName: doc['apiaryName'] ?? '',
          address: doc['address'] ?? '');
    }).toList();
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      apiaryName: snapshot['apiaryName'],
      address: snapshot['address'],
    );
  }

  //get brews stream
  Stream<List<Apiary>> get apiary {
    return apiaryCollection.snapshots().map(_apiaryListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return apiaryCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
