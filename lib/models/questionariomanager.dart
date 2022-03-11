import 'package:amesaadm/models/avaliacao.dart';
import 'package:amesaadm/models/avaliacoesmanager.dart';
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

  Future<bool> aprovaVerificaDependencia(Questionario atividadecorrente,
      AvaliacoesManager avaliacoesmanager) async {
    num qtdetentativas = avaliacoesmanager?.qtdeTentativas(
            atividadecorrente.id, atividadecorrente.emailUsuario) ??
        0;
    Avaliacao avaliacaocorrente;
    if (qtdetentativas == 0) {
      // é a primeira tentativa e a atividade estava atribuida somente a turma
      // cria uma nova avaliacao para registrar o desempenho da avaliacao em curso para o aluno corrente.
      avaliacaocorrente = Avaliacao();
      avaliacaocorrente.idQuestionario = atividadecorrente.id;
      avaliacaocorrente.email = atividadecorrente.emailUsuario;
      avaliacaocorrente.idUsuario = atividadecorrente.idUsuario;
      avaliacaocorrente.nracertos = atividadecorrente.totalpontosganhos;
      avaliacaocorrente.nrerros = atividadecorrente.totalpontosperdidos;
      avaliacaocorrente.origem = atividadecorrente.titulo;
      avaliacaocorrente.destino = atividadecorrente.atividadeposterior;
      avaliacaocorrente.dataexecucao = DateTime.now().toLocal();
      avaliacaocorrente.nrtentativa = 1;
    } else {
      //está executando uma avaliação já atribuida  ao aluno corrente e apenas atualiza a pontução e status;
      //obtem a última tentativa do questionario corrente.
      avaliacaocorrente = avaliacoesmanager.ultimaAvaliacaoQuestionarioAluno(
          atividadecorrente.id, atividadecorrente.emailUsuario);
      avaliacaocorrente.nracertos = atividadecorrente.totalpontosganhos;
      avaliacaocorrente.nrerros = atividadecorrente.totalpontosperdidos;
      avaliacaocorrente.dataexecucao = DateTime.now().toLocal();
    }
    bool aprovado = false;
    final Questionario atividadesubjacente =
        findQuestionarioBytitulo(atividadecorrente.atividadesubjacente);
    final Questionario atividadeposterior =
        findQuestionarioBytitulo(atividadecorrente.atividadeposterior);
    if ((atividadecorrente.totalpontosperdidos >=
            atividadecorrente.nrerrosrefazer) &&
        (atividadecorrente.totalpontosperdidos <
            atividadecorrente.nrerrosativanterior)) {
      aprovado = false;
      avaliacaocorrente.situacao =
          'Necessario Refazer Atividade'; //representa a situação final desta avaliacao
      await avaliacaocorrente
          .save(); //salva a avaliacao corrente com a pontuacao estabelecida.
      //refazer: atribui mais uma tentativa para o aluno refazer a atividade
      Avaliacao novaAvaliacao = avaliacaocorrente.clone();
      novaAvaliacao.id =
          null; //será gravada como uma nova avaliação pendente para o aluno.
      novaAvaliacao.nracertos = 0;
      novaAvaliacao.nrerros = 0;
      novaAvaliacao.situacao = 'Aberta';
      await novaAvaliacao.save();
    } else {
      if ((atividadecorrente.totalpontosperdidos >=
              atividadecorrente.nrerrosativanterior) &&
          (atividadecorrente.nrtentativa >= atividadecorrente.qtdetentativas) &&
          (atividadesubjacente != null)) {
        //pelo número de erros se faz necessário a realização da atividade subjacente
        //cria a atividade subjacente .
        aprovado = false;
        Avaliacao avaliacaoSubjacente = Avaliacao();

        avaliacaoSubjacente.idQuestionario = atividadesubjacente.id;
        avaliacaoSubjacente.email = atividadecorrente.emailUsuario;
        avaliacaoSubjacente.idUsuario = atividadecorrente.idUsuario;
        avaliacaoSubjacente.nracertos = 0;
        avaliacaoSubjacente.nrerros = 0;
        avaliacaoSubjacente.origem = atividadecorrente.titulo;
        avaliacaoSubjacente.destino = atividadesubjacente.atividadeposterior;
        avaliacaoSubjacente.dataexecucao = DateTime.now().toLocal();
        avaliacaoSubjacente.nrtentativa = 1;
        avaliacaoSubjacente.situacao = 'Aberta';
        await avaliacaoSubjacente.save();
        //avaliacaocorrente.nrtentativa; //esta comprometido calcular esta informação, fazer um método para calcular quantas tentativas para este mesmo questionario e do mesmo usuario foram feitas

      } else {
        //aprovado, habilitar a próxima atividade e pensar se deve encerrar as tentativas restantes
        if (atividadeposterior != null) {
          atividadeposterior
                  .findQuestionarioTurma(atividadecorrente.emailUsuario) ??
              atividadeposterior
                  .addQuestionarioTurma(atividadecorrente.emailUsuario);
        }
        aprovado = true;
        avaliacaocorrente.situacao = 'Aprovado';
      }
    }
    await avaliacaocorrente.save();
    avaliacoesmanager.recarregar();
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
