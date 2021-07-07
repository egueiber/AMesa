import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:amesaadm/models/turma.dart';

class TurmaManager extends ChangeNotifier {
  TurmaManager() {
    _loadAllTurmas();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Turma> allTurmas = [];

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Turma> get filteredProducts {
    final List<Turma> filteredTurmas = [];

    if (search.isEmpty) {
      filteredTurmas.addAll(allTurmas);
    } else {
      filteredTurmas.addAll(allTurmas
          .where((a) => a.sigla.toLowerCase().contains(search.toLowerCase())));
    }

    return filteredTurmas;
  }

  Future<void> _loadAllTurmas() async {
    final QuerySnapshot snapTurmas = await firestore.collection('turmas').get();
    allTurmas = snapTurmas.docs.map((d) => Turma.fromDocument(d)).toList();

    notifyListeners();
  }

  Turma findTurmaById(String id) {
    try {
      return allTurmas.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Turma turma) {
    allTurmas.removeWhere((p) => p.id == turma.id);
    allTurmas.add(turma);
    notifyListeners();
  }
}
