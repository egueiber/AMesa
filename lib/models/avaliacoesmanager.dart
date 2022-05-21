import 'package:amesaadm/models/avaliacaoresult.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/models/questionariomanager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:amesaadm/models/avaliacao.dart';
import 'package:intl/intl.dart';

class AvaliacoesManager extends ChangeNotifier {
  AvaliacoesManager() {
    _loadAllAvaliacoes();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<AvaliacaoResult> allAvaliacoesResult = [];
  List<Avaliacao> allAvaliacoes = [];
  List<Avaliacao> avaliacoesAlunoCorrente = [];
  List<String> acertosAlunoAtividadePeriodo = [];
  Avaliacao ultimaAvaliacaoAluno;
  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Avaliacao> get filteredAvaliacoes {
    List<Avaliacao> filteredAvaliacoes = [];
    if (search.isEmpty) {
      filteredAvaliacoes.addAll(allAvaliacoes);
    } else {
      filteredAvaliacoes.addAll(allAvaliacoes
          .where((a) => a.email.toLowerCase().contains(search.toLowerCase())));
    }
    filteredAvaliacoes
        .sort((a, b) => a.email.toLowerCase().compareTo(b.email.toLowerCase()));
    return filteredAvaliacoes;
  }

  Future<void> _loadAllAvaliacoes() async {
    final QuerySnapshot snapAvaliacoes =
        await firestore.collection('avaliacao').get();
    allAvaliacoes =
        snapAvaliacoes.docs.map((d) => Avaliacao.fromDocument(d)).toList();
    notifyListeners();
  }

  int qtdeTentativas(String idquestionario, String email) {
    int qtde = 0;
    getAvaliacoesAlunoCorrente(email).forEach((av) {
      if (av.idQuestionario == idquestionario) {
        qtde++;
      }
    });
    return qtde;
  }

  Avaliacao ultimaAvaliacaoQuestionarioAluno(
      String idquestionario, String email) {
    List<Avaliacao> avaliacaoQuestionarioAluno = [];
    List<Avaliacao> avaliacaoAluno = [];
    avaliacaoAluno = getAvaliacoesAlunoCorrente(email);
    if (avaliacaoAluno != null) {
      avaliacaoAluno.forEach((av) {
        if (av.idQuestionario == idquestionario) {
          avaliacaoQuestionarioAluno.add(av);
        }
      });
    }
    //ordernar por data avaliacaoQuestionarioAluno
    if (avaliacaoQuestionarioAluno.isNotEmpty) {
      avaliacaoQuestionarioAluno.sort((a, b) {
        return a.dataexecucao.compareTo(b.dataexecucao);
      });
    }
    try {
      return avaliacaoQuestionarioAluno.last;
    } catch (e) {
      return null;
    }
  }

  Future<void> recarregar() {
    _loadAllAvaliacoes();
  }

  List<Avaliacao> getAvaliacoesAlunoCorrente(String email) {
    avaliacoesAlunoCorrente = [];
    allAvaliacoesResult = [];
    allAvaliacoes.forEach((av) {
      if (av.email == email) {
        avaliacoesAlunoCorrente.add(av);
      }
    });
    if (avaliacoesAlunoCorrente.isNotEmpty) {
      avaliacoesAlunoCorrente
          .sort((a, b) => a.nrtentativa.compareTo(b.nrtentativa));
      //   getUltimaAvaliacaoAluno(email);
    }
    return avaliacoesAlunoCorrente;
  }

  List<Avaliacao> getAvaliacoesAbertaAlunoCorrente(String email) {
    avaliacoesAlunoCorrente = [];
    allAvaliacoes.forEach((av) {
      if ((av.email == email) && (av.situacao == 'Aberta')) {
        avaliacoesAlunoCorrente.add(av);
      }
    });
    if (avaliacoesAlunoCorrente.isNotEmpty) {
      avaliacoesAlunoCorrente
          .sort((a, b) => a.nrtentativa.compareTo(b.nrtentativa));
      getUltimaAvaliacaoAluno(email);
    }
    return avaliacoesAlunoCorrente;
  }

  List<Questionario> questionarioAbertoAlunoCorrente(
      String email, QuestionarioManager lQA) {
    List<Avaliacao> lAval = getAvaliacoesAbertaAlunoCorrente(email);
    List<Questionario> lQuest = [];
    Questionario aux;
    lAval.forEach((l) {
      aux = lQA.findQuestionarioById(l.idQuestionario);
      if (aux != null) {
        lQuest.add(aux);
      }
    });
    return lQuest;
  }

  Avaliacao getUltimaAvaliacaoAluno(String email) {
    ultimaAvaliacaoAluno = null;
    avaliacoesAlunoCorrente = getAvaliacoesAbertaAlunoCorrente(email);
    if (avaliacoesAlunoCorrente.isNotEmpty) {
      ultimaAvaliacaoAluno = avaliacoesAlunoCorrente.last;
    }
    return ultimaAvaliacaoAluno;
  }

  Avaliacao findAlunoById(String id) {
    try {
      return allAvaliacoes.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Avaliacao findAlunoByEmail(String email) {
    try {
      return allAvaliacoes.firstWhere((p) => p.email == email);
    } catch (e) {
      return null;
    }
  }

  void update(Avaliacao avaliacao) {
    allAvaliacoes.removeWhere((p) => p.id == avaliacao.id);
    allAvaliacoes.add(avaliacao);
    notifyListeners();
  }

  void totalizaAlunoAtividadePeriodo(String titulo, int nrtentativas,
      nralternativasapresentadas, totalacertos, totalerros, nrsubjacentes) {
    acertosAlunoAtividadePeriodo.add('Questionario: ' + titulo);
    acertosAlunoAtividadePeriodo
        .add('Total Tentativas:' + nrtentativas.toString());
    /*  acertosAlunoAtividadePeriodo.add('Total alternativas presentes:' +
        nralternativasapresentadas.toString()); */
    if (nrtentativas > 0) {
      num mediaacertos = 0;
      num mediaerros = 0;
      mediaacertos = (totalacertos / nrtentativas);
      mediaerros = (totalerros / nrtentativas);
      acertosAlunoAtividadePeriodo.add('Média de Acertos: ' +
          mediaacertos.toString() +
          ' e Erros: ' +
          mediaerros.toString());
      acertosAlunoAtividadePeriodo.add('Total Acertos: ' +
          totalacertos.toString() +
          ' e Erros: ' +
          totalerros.toString());
      /*  acertosAlunoAtividadePeriodo.add('Melhor resultado: ' +
          melhorresultado.toString() +
          ', na tentativa de nr.: ' +
          nrtentmelhorresult.toString());
      acertosAlunoAtividadePeriodo.add('Pior resultado: ' +
          piorresultado.toString() +
          ', na tentativa de nr.: ' +
          nrtentpiorresult.toString()); */
      if (nrsubjacentes > 0) {
        acertosAlunoAtividadePeriodo.add(
            'Executou a atividade subjacente por: ' +
                nrsubjacentes.toString() +
                ' vez(es)');
      } else {
        acertosAlunoAtividadePeriodo
            .add('Não executou atividade subjacente a esta');
      }
    }
    acertosAlunoAtividadePeriodo.add(
        '-----------------------------------------------------------------------------------------');
  }

  List<String> getAcertosAlunoAtividadePeriodo(
      String nome, email, DateTime datai, DateTime dataf) {
    print(DateFormat.yMMMd().format(DateTime.now()));
    acertosAlunoAtividadePeriodo = [];
    avaliacoesAlunoCorrente.clear();
    acertosAlunoAtividadePeriodo.clear();
    allAvaliacoes.forEach((av) {
      if ((av.email == email) && (av.situacao != 'Aberta')) {
        //inserir o filtro de datai e dataf
        avaliacoesAlunoCorrente.add(av);
      }
    });
    if (avaliacoesAlunoCorrente.isNotEmpty) {
      acertosAlunoAtividadePeriodo.add('Avaliações do aluno: ' + nome);
      acertosAlunoAtividadePeriodo.add('e-mail: ' + email);

      acertosAlunoAtividadePeriodo.add(
          'Data emissão: ' + DateFormat('dd/MM/yyyy').format(DateTime.now()));
      acertosAlunoAtividadePeriodo.add(
          '-----------------------------------------------------------------------------------------');

      /*Q1: Qual a quantidade de acertos de cada aluno por atividade?
        A média nas execuções, a maior e a menor
        ex: 1. Conhecer Kaki, kiwi e mamão
            Média: 2 acertos, Maior 2 acertos e menor 0	acertos
            */
      avaliacoesAlunoCorrente.sort((a, b) => a.titulo.compareTo(b.titulo));
      String idquestcorr = avaliacoesAlunoCorrente.first.idQuestionario;
      int totalacertos = 0;
      int melhorresultado = 0;
      // int nrtentmelhorresult = 0;
      // int nrtentpiorresult = 0;
      int piorresultado = 0;
      int totalerros = 0;
      int nrtentativas = 0;
      int nrsubjacentes = 0;
      String titulo = '';
      int nralternativasapresentadas = avaliacoesAlunoCorrente.first.nracertos +
          avaliacoesAlunoCorrente.first.nrerros;

      avaliacoesAlunoCorrente.forEach((ava) {
        if (idquestcorr !=
            ava.idQuestionario) //mudou o questinario efetua as totalizações
        {
          totalizaAlunoAtividadePeriodo(
              titulo,
              nrtentativas,
              nralternativasapresentadas,
              totalacertos,
              totalerros,
              nrsubjacentes);
          idquestcorr = ava.idQuestionario;
          totalacertos = 0;
          melhorresultado = 0;
          piorresultado = 0;
          totalerros = 0;
          nrtentativas = 0;
          nralternativasapresentadas = ava.nracertos + ava.nrerros;
        }
        if (ava.situacao == 'Refazer Subjacente') {
          nrsubjacentes++;
        }
        titulo = ava.titulo;
        totalacertos = totalacertos + ava.nracertos;
        totalerros = totalerros + ava.nrerros;
        nrtentativas++;
      });
      totalizaAlunoAtividadePeriodo(titulo, nrtentativas,
          nralternativasapresentadas, totalacertos, totalerros, nrsubjacentes);
    }
    return acertosAlunoAtividadePeriodo;
  }
}
