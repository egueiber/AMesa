//import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:amesaadm/models/user.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUsersManager extends ChangeNotifier {
  List<UserApp> users = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription _subscription;

  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    _subscription =
        firestore.collection('users').snapshots().listen((snapshot) {
      users = snapshot.docs.map((d) => UserApp.fromDocument(d)).toList();
      users
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.name).toList();
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
