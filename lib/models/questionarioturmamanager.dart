import 'package:amesaadm/models/aluno.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/models/user.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class QuestionarioTurmaManager extends ChangeNotifier {
  List<Questionario> items = [];
  UserApp user;
  num productsPrice = 0.0;

  void updateUser(UserManager userManager) {
    user = userManager.user;

    items.clear();

    if (user != null) {
      _loadQuestionarioTurma();
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> _loadQuestionarioTurma() async {
    final QuerySnapshot snapAlunos = await firestore
        .collection('alunos')
        .where('email', isEqualTo: user.email)
        .get();
    final List<Aluno> allAlunos =
        snapAlunos.docs.map((d) => Aluno.fromDocument(d)).toList();
    if (allAlunos.isNotEmpty) {
      final QuerySnapshot snapQuestionario =
          await firestore.collection('questionarios').get();
      //  arrayContains: {'turma': allAlunos.first.turma}).get();
      final List<Questionario> allQuestionarioTurma = snapQuestionario.docs
          .map((d) => Questionario.fromDocument(d))
          .toList();
      List<Questionario> lf = [];

      allQuestionarioTurma.forEach((at) {
        at.questionarioturma.forEach((qt) {
          if ((qt.turma == allAlunos.first.turma) ||
              (qt.turma == allAlunos.first.email)) {
            //se o questionario estiver atribuito a turma ou ao email do aluno será listado
            if (lf.isEmpty) {
              lf.add(at);
            } else {
              bool existe = false;
              lf.forEach((p) {
                if ((p.titulo == at.titulo)) {
                  existe = true;
                }
              });
              if (!existe) {
                //senão existir adiciona a lista
                lf.add(at);
              }
            }
          }
        });
      });
      items = lf;
    } else {
      items.clear();
    }
    notifyListeners();
  }
}
