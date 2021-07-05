import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:amesaadm/models/aluno.dart';

class AlunoManager extends ChangeNotifier {
  AlunoManager() {
    _loadAllAlunos();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Aluno> allAlunos = [];

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Aluno> get filteredProducts {
    final List<Aluno> filteredAlunos = [];

    if (search.isEmpty) {
      filteredAlunos.addAll(allAlunos);
    } else {
      filteredAlunos.addAll(allAlunos
          .where((a) => a.nome.toLowerCase().contains(search.toLowerCase())));
    }

    return filteredAlunos;
  }

  Future<void> _loadAllAlunos() async {
    final QuerySnapshot snapAlunos = await firestore.collection('alunos').get();
    allAlunos = snapAlunos.docs.map((d) => Aluno.fromDocument(d)).toList();

    notifyListeners();
  }

  Aluno findAlunoById(String id) {
    try {
      return allAlunos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Aluno aluno) {
    allAlunos.removeWhere((p) => p.id == aluno.id);
    allAlunos.add(aluno);
    notifyListeners();
  }
}
