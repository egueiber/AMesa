import 'package:cloud_firestore/cloud_firestore.dart';

class UserApp {
  // UserApp({this.email, this.password});
  UserApp({this.email, this.password, this.name, this.id});

  UserApp.fromDocument(DocumentSnapshot document) {
    id = document.id;
    var item = document.data() as Map;
    name = item["name"].toString();
    email = item['email'].toString();
  }
  String id;
  String email;
  String password;
  String name;
  String confirmPassword;
  bool admin = false;
  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  //Stream<QuerySnapshot> get cartReference =>  firestoreRef.collection('cart').snapshots();
  // Future<QuerySnapshot> get cartReference =>      firestoreRef.collection('cart').get();
  CollectionReference get cartReference => firestoreRef.collection('cart');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
