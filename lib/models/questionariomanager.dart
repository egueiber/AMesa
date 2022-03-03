import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:amesaadm/models/questionario.dart';
//import 'turmasmanager.dart';
//import 'turma.dart';

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

  Future<bool> aprovaVerificaDependencia(Questionario atividadecorrente) async {
    // verifica se o número de erros exige que o aluno refaça a atividade
    // ou faça uma outra atividade subjacente
    bool aprovado = false;
    final Questionario atividadesubjacente =
        findQuestionarioBytitulo(atividadecorrente.atividadesubjacente);
    if ((atividadecorrente.totalpontosperdidos >=
            atividadecorrente.nrerrosrefazer) &&
        (atividadecorrente.totalpontosperdidos <
            atividadecorrente.nrerrosativanterior)) {
      //refazer: atribui mais uma tentativa, caso não existam mais tentativas
      if (atividadecorrente.nrtentativa >= atividadecorrente.qtdetentativas) {
        atividadecorrente.qtdetentativas++;
        await atividadecorrente.save();
        aprovado = false;
      }
    } else {
      if ((atividadecorrente.totalpontosperdidos >=
              atividadecorrente.nrerrosativanterior) &&
          (atividadecorrente.nrtentativa >= atividadecorrente.qtdetentativas) &&
          (atividadesubjacente != null)) {
        //pelo número de erros se faz necessário a realização da atividade subjacente
        //cria, caso não exista, uma turma  exclusiva para o aluno.
        aprovado = false;
        if (atividadecorrente.emailUsuario.isNotEmpty) {
          //cria a turma exclusiva para o aluno caso não exista
          if (atividadesubjacente
                  .findQuestionarioTurma(atividadecorrente.emailUsuario) ==
              null) {
            /*  TurmaManager turmamanager = TurmaManager();
            Turma turma = (turmamanager
                    .findTurmaBySigla(atividadecorrente.emailUsuario)) ??
                Turma();
            turma.ano = 0;
            turma.ativo = true;
            turma.descricao = atividadecorrente.emailUsuario;
            turma.sigla = atividadecorrente.emailUsuario;
            await turma.save(); */
            //adiciona a turma exclusiva deste aluno a atividade subjacente
            //desta forma o aluno terá a atividade subjacente para ser feita
            // localizar a atividade subjacente

            if (atividadesubjacente != null) {
              atividadesubjacente
                      .findQuestionarioTurma(atividadecorrente.emailUsuario) ??
                  atividadesubjacente
                      .addQuestionarioTurma(atividadecorrente.emailUsuario);
            }
          } else {
            // a atividade já existe para este usuário (turma)
            bool comTentativas = false;
            try {
              comTentativas = (atividadesubjacente.qtdetentativas <=
                  atividadesubjacente
                      .questoes[0].alternativas[0].respostas.length);
            } catch (e) {
              comTentativas = false;
            }
            if (!comTentativas) {
              atividadesubjacente.qtdetentativas++;
              await atividadesubjacente.save();
            }
          }
        }
      } else {
        //aprovado, habilitar a próxima atividade e pensar se deve encerrar as tentativas restantes
        aprovado = true;
      }
    }
    return aprovado;
  }

  Questionario findQuestionarioBytitulo(String titulo) {
    try {
      return allQuestionarios
          .firstWhere((p) => p.titulo.toLowerCase() == titulo.toLowerCase());
    } catch (e) {
      return null;
    }
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
