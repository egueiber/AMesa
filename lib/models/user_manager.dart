//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:amesaadm/models/user.dart';
import 'package:amesaadm/helpers/firebase_erros.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  UserApp user;
  bool _loading = false;
  bool get loading => _loading;

  bool get isLoggedIn => auth.currentUser != null;

  Future<void> signUp(
      {UserApp user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = result.user.uid;
      this.user = user;

      await user.saveData();

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signIn(
      {UserApp user, Function onFail, Function onSucess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      if (!result.user.emailVerified) print('Credenciais inválidas!');
      print(result.user.uid);
      //this.user = result.user;

      await _loadCurrentUser(firebaseUser: result.user);
      onSucess();
    } on FirebaseAuthException catch (e) {
      //print(getErrorString(e.code));
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  /*void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }*/

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final User currentUser = firebaseUser ?? auth.currentUser;
    // final User currentUser = auth.currentUser;
    if (currentUser != null) {
      // user = currentUser;

      final doc = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots();
      var documents = await doc.first;

      // await firestore.collection('users').document(currentUser.uid).get();

      user = UserApp.fromDocument(documents);
      final docAdmin = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.id)
          .get();
      if (docAdmin.exists) {
        user.admin = true;
      }

      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user.admin;
}
