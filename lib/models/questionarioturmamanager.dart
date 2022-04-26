import 'package:amesaadm/models/aluno.dart';
import 'package:amesaadm/models/avaliacao.dart';
//import 'package:amesaadm/models/avaliacoesmanager.dart';
//import 'package:amesaadm/models/avaliacao.dart';
//import 'avaliacoesmanager.dart';
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
      final QuerySnapshot snapAvaliacoes = await firestore
          .collection('avaliacao')
          .where('email', isEqualTo: user.email)
          .get();
      final List<Questionario> allQuestionarioTurma = snapQuestionario.docs
          .map((d) => Questionario.fromDocument(d))
          .toList();
      final List<Avaliacao> allAvaliacoesAluno =
          snapAvaliacoes.docs.map((d) => Avaliacao.fromDocument(d)).toList();

      List<Questionario> lf = [];
      allAvaliacoesAluno.forEach((av) {
        if (av.situacao == 'Aberta') {
          final Questionario atv = allQuestionarioTurma
              .firstWhere((e) => (e.id == av.idQuestionario));
          if (atv != null) {
            lf.add(atv);
          }
        }
      });

      allQuestionarioTurma.forEach((at) {
        at.questionarioturma.forEach((qt) {
          if ((qt.turma == allAlunos.first.turma) ||
              (qt.turma == allAlunos.first.email)) {
            //se o questionario estiver atribuito a turma ou ao email do aluno será listado
            bool existe = false;
            if (lf.isNotEmpty)
              lf.forEach((p) {
                if ((p.titulo == at.titulo)) {
                  existe =
                      true; //já existe na lista e não deve adicionar novamente
                }
              });
            final Avaliacao uav = allAvaliacoesAluno.lastWhere(
                (e) => (e.idQuestionario == at.id),
                orElse: () =>
                    null); //procura pela última avaliacao de um questionario para um aluno
            if (uav != null) {
              if (uav.situacao != 'Aberta') {
                existe =
                    true; //não adicionará a lista pois já tem a última avaliação finalizada para este questionario.
              }
            }
            if (!existe) {
              lf.add(at);
            }
          }
        });
      });
      //adiciona questionarios abertos na lista de avaliacao.

      items = lf;
      //verifica se o questionario tem aprovação na última avaliação, caso afirmativo remove da lista
      /* items.forEach((p) {
        AvaliacoesManager avaliacoesManager = AvaliacoesManager();
        Avaliacao av = avaliacoesManager.ultimaAvaliacaoQuestionarioAluno(
            p.id, p.emailUsuario);
        if (av != null) {
          if (av.situacao == 'Aprovado') {
            items.remove(p);
          }
        }
      }); */
    } else {
      items.clear();
    }
    notifyListeners();
  }

  Future<void> recarregar() async {
    await _loadQuestionarioTurma();
  }
}
