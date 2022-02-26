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

  List<Turma> get filteredTurmaAtivaByTurma {
    List<Turma> turmaAtivasbyTurma = [];
    turmaAtivasbyTurma.addAll(allTurmas.where((a) => a.ativo));
    turmaAtivasbyTurma
        .sort((a, b) => a.sigla.toLowerCase().compareTo(b.sigla.toLowerCase()));

    return turmaAtivasbyTurma;
  }

  List<Turma> get filteredTurmas {
    final List<Turma> filteredTurmas = [];
    if (search.isEmpty) {
      filteredTurmas.addAll(allTurmas);
    } else {
      filteredTurmas.addAll(allTurmas
          .where((a) => a.sigla.toLowerCase().contains(search.toLowerCase())));
    }
    filteredTurmas.sort((a, b) =>
        a.descricao.toLowerCase().compareTo(b.descricao.toLowerCase()));
    return filteredTurmas;
  }

  Future<void> _loadAllTurmas() async {
    final QuerySnapshot snapTurmas = await firestore.collection('turmas').get();
    allTurmas = snapTurmas.docs.map((d) => Turma.fromDocument(d)).toList();
    // turmasInativas = allTurmas.where((t) => (!t.ativo));
    notifyListeners();
  }

  Turma findTurmaById(String id) {
    try {
      return allTurmas.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Turma findTurmaBySigla(String sigla) {
    try {
      return allTurmas
          .firstWhere((p) => p.sigla.toLowerCase() == sigla.toLowerCase());
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
