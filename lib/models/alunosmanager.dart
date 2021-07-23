import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:amesaadm/models/aluno.dart';

class AlunoManager extends ChangeNotifier {
  AlunoManager() {
    _loadAllAlunos();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Aluno> allAlunos = [];
  //List<Aluno> alunosAtivos = [];

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  /*  List<Aluno> get filteredAlunosAtivoByTurma {
    List<Aluno> alunosAtivosbyTurma = [];
    alunosAtivosbyTurma.addAll(allAlunos.where((a) => a.ativo));
    alunosAtivosbyTurma
        .sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
    alunosAtivosbyTurma
        .sort((a, b) => a.turma.toLowerCase().compareTo(b.turma.toLowerCase()));
    notifyListeners();
    return alunosAtivosbyTurma;
  } */

  List<Aluno> get filteredAlunos {
    List<Aluno> filteredAlunos = [];

    if (search.isEmpty) {
      filteredAlunos.addAll(allAlunos);
    } else {
      filteredAlunos.addAll(allAlunos
          .where((a) => a.nome.toLowerCase().contains(search.toLowerCase())));
    }
    filteredAlunos
        .sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
    return filteredAlunos;
  }

  Future<void> _loadAllAlunos() async {
    final QuerySnapshot snapAlunos = await firestore.collection('alunos').get();
    allAlunos = snapAlunos.docs.map((d) => Aluno.fromDocument(d)).toList();
    //alunosAtivos = allAlunos.where((a) => a.ativo);
    notifyListeners();
  }

  Aluno findAlunoById(String id) {
    try {
      return allAlunos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Aluno findAlunoByEmail(String email) {
    try {
      return allAlunos.firstWhere((p) => p.email == email);
    } catch (e) {
      return null;
    }
  }

  void update(Aluno aluno) {
    allAlunos.removeWhere((p) => p.id == aluno.id);
    allAlunos.add(aluno);
/*     alunosAtivos.removeWhere((p) => p.id == aluno.id);
    if (aluno.ativo) alunosAtivos.add(aluno); */
    notifyListeners();
  }
}
