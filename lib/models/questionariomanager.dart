import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:amesaadm/models/questionario.dart';

class QuestionarioManager extends ChangeNotifier {
  QuestionarioManager() {
    _loadAllQuestionarios();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Questionario> allQuestionarios = [];

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Questionario> get filteredQuestionarios {
    final List<Questionario> filteredQuestionarios = [];

    if (search.isEmpty) {
      filteredQuestionarios.addAll(allQuestionarios);
    } else {
      filteredQuestionarios.addAll(allQuestionarios
          .where((p) => p.titulo.toLowerCase().contains(search.toLowerCase())));
    }
    filteredQuestionarios.sort(
        (a, b) => a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase()));

    return filteredQuestionarios;
  }

  List<Questionario> filteredQuestionariosTurma(String turma) {
    List<Questionario> questionariosTurma = [];
    if (questionariosTurma.isNotEmpty) {
      if (turma.isNotEmpty) {
        questionariosTurma.addAll(allQuestionarios);
        //.where(
        //  (q) => q.questionarioturma.contains((qt) => qt.turma == turma)));
      }
    }
    return questionariosTurma;
  }

  Future<void> _loadAllQuestionarios() async {
    final QuerySnapshot snapQuestionarios =
        await firestore.collection('questionarios').get();
    allQuestionarios = snapQuestionarios.docs
        .map((d) => Questionario.fromDocument(d))
        .toList();
    allQuestionarios.sort(
        (a, b) => a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase()));
    notifyListeners();
  }

  Questionario findQuestionarioById(String id) {
    try {
      return allQuestionarios.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Questionario questionario) {
    allQuestionarios.removeWhere((p) => p.id == questionario.id);
    allQuestionarios.add(questionario);
    notifyListeners();
  }
}
