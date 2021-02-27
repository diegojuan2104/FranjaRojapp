import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  	
  final String uid;
  DatabaseService({this.uid});

  //Collection reference
  final CollectionReference profile = FirebaseFirestore.instance.collection('profiles');

  Future updateUserData(int franjas,String name) async{
    return await profile.doc(uid).set({
      'franjas': franjas,
      'name:': name,
    });
  }
}