import 'package:amesaadm/models/aluno.dart';
import 'package:amesaadm/models/turma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TurmasAlunos extends ChangeNotifier {
  TurmasAlunos() {
    turmasInativas = turmasInativas;
    alunosAtivos = alunosAtivos;
    alunosAtivosByTurma = alunosAtivosByTurma;
    strTurma = strTurma;
    _loadAllTurmasAlunos();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Turma> turmasInativas;
  List<Aluno> alunosAtivos;
  List<Aluno> alunosAtivosByTurma;
  List<String> strTurma;

  List<Aluno> get filteredAlunosAtivoByTurma {
    _loadAllTurmasAlunos();
    return alunosAtivosByTurma;
  }

  Future<void> _loadAllTurmasAlunos() async {
    final QuerySnapshot snapTurmasInativas = await firestore
        .collection('turmas')
        .where("ativo", isEqualTo: false)
        .get();
    final QuerySnapshot snapAlunosAtivos = await firestore
        .collection('alunos')
        .where("ativo", isEqualTo: true)
        .get();

    turmasInativas =
        snapTurmasInativas.docs.map((d) => Turma.fromDocument(d)).toList();

    alunosAtivos =
        snapAlunosAtivos.docs.map((a) => Aluno.fromDocument(a)).toList();
    alunosAtivosByTurma = [];
    alunosAtivosByTurma.addAll(alunosAtivos);
    turmasInativas.forEach((ta) {
      alunosAtivosByTurma.removeWhere((at) => ta.sigla == at.turma);
    });

    String turma = '';
    strTurma = [];
    String linha = '';
    alunosAtivosByTurma.forEach((at) {
      if (at.turma == turma) {
        linha = linha + at.nome + ', ';
      } else {
        if (linha.length > 0) {
          strTurma.add(linha);
        }
        linha = at.turma + ':' + at.nome + ', ';
        turma = at.turma;
      }
    });
    if (linha.length > 0) {
      strTurma.add(linha);
    }

    // notifyListeners();
  }
}
