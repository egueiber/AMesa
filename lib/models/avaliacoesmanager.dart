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
  List<AvaliacaoResult> allAlunoAvaliacoesResult = [];
  List<AvaliacaoResult> allAvaliacoesResult = [];
  List<Avaliacao> allAvaliacoes = [];
  List<Avaliacao> avaliacoesAlunoCorrente = [];
  //List<String> acertosAlunoAtividadePeriodo = [];
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
    allAlunoAvaliacoesResult = [];
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

  void totalizaAlunoAtividadePeriodo(
      String titulo,
      int nrtentativas,
      nralternativasapresentadas,
      totalacertos,
      totalerros,
      nrsubjacentes,
      AvaliacaoResult avaliacaoResult) {
    avaliacaoResult.titulo = titulo;
    avaliacaoResult.numerotentativas =
        'Nr. Tentativas: ' + nrtentativas.toString();
    if (nrtentativas > 0) {
      num mediaacertos = 0;
      num mediaerros = 0;
      mediaacertos = (totalacertos / nrtentativas);
      mediaerros = (totalerros / nrtentativas);
      avaliacaoResult.mediaAcertos =
          'Média de Acertos: ' + mediaacertos.toString();
      avaliacaoResult.mediaErros = 'Média de Erros: ' + mediaerros.toString();
      avaliacaoResult.totalAcertos =
          'Total Acertos: ' + totalacertos.toString();
      avaliacaoResult.totalErros = 'Total de Erros: ' + totalerros.toString();
      if (nrsubjacentes > 0) {
        avaliacaoResult.atividadesubjacente =
            'Executou a atividade subjacente por: ' +
                nrsubjacentes.toString() +
                ' vez(es)!';
      } else {
        avaliacaoResult.atividadesubjacente =
            'Não executou atividade subjacente a esta atividade!';
      }
    }
  }

  List<AvaliacaoResult> getAllAtividadePeriodoTrilha(List alunos) {
    //avaliacoesAlunoCorrente.clear();
    allAvaliacoesResult.clear();
    if ((allAvaliacoes.isEmpty) || (alunos.isEmpty)) {
      return [];
    }
    allAvaliacoes.sort((a, b) => a.email.compareTo(b.email));
    alunos.sort((a, b) => a.nome.compareTo(b.nome));
    String email = allAvaliacoes.first.email;
    //  allAlunoAvaliacoesResult.add(new AvaliacaoResult());
    List<AvaliacaoResult> lAluno = getAcertosAlunoAtividadePeriodoTrilha(
        alunos.first.nome, alunos.first.email, DateTime.now(), DateTime.now());
    if (lAluno.isNotEmpty) {
      allAvaliacoesResult.addAll(lAluno);
    }
    alunos.forEach((av) {
      if ((av.email != email)) {
        email = av.email;
        //inserir o filtro de datai e dataf
        lAluno = getAcertosAlunoAtividadePeriodoTrilha(
            av.nome, av.email, DateTime.now(), DateTime.now());
        if (lAluno.isNotEmpty) {
          allAvaliacoesResult.addAll(lAluno);
        }
      }
    });
    return allAvaliacoesResult;
  }

  List<AvaliacaoResult> getAcertosAlunoAtividadePeriodoTrilha(
      String nome, email, DateTime datai, DateTime dataf) {
    int i = 0;
    avaliacoesAlunoCorrente.clear();
    allAlunoAvaliacoesResult.clear();
    //  allAlunoAvaliacoesResult.add(new AvaliacaoResult());
    allAvaliacoes.forEach((av) {
      if ((av.email == email) && (av.situacao != 'Aberta')) {
        //inserir o filtro de datai e dataf
        avaliacoesAlunoCorrente.add(av);
      }
    });
    if (avaliacoesAlunoCorrente.isNotEmpty) {
      avaliacoesAlunoCorrente
          .sort((a, b) => a.dataexecucao.compareTo(b.dataexecucao));
      int totalacertos = 0;
      int totalerros = 0;
      avaliacoesAlunoCorrente.forEach((ava) {
        allAlunoAvaliacoesResult.add(new AvaliacaoResult());
        allAlunoAvaliacoesResult[i].idAvaliacao = ava.id;
        allAlunoAvaliacoesResult[i].email = ava.titulo;
        allAlunoAvaliacoesResult[i].aluno = nome;
        allAlunoAvaliacoesResult[i].email = email;
        allAlunoAvaliacoesResult[i].periodo =
            DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
        allAlunoAvaliacoesResult[i].dataExecucao =
            DateFormat('dd/MM/yyyy HH:mm:ss').format(ava.dataexecucao);
        allAlunoAvaliacoesResult[i].titulo = ava.titulo;
        allAlunoAvaliacoesResult[i].situacao = ava.situacao;
        allAlunoAvaliacoesResult[i].totalAcertos = ava.nracertos.toString();
        allAlunoAvaliacoesResult[i].totalErros = ava.nrerros.toString();

        i++;
        totalacertos = totalacertos + ava.nracertos;
        totalerros = totalerros + ava.nrerros;
      });
    }
    return allAlunoAvaliacoesResult;
  }

  List<AvaliacaoResult> getAcertosAlunoAtividadePeriodo(
      String nome, email, DateTime datai, DateTime dataf) {
    int i = 0;

    avaliacoesAlunoCorrente.clear();
    allAlunoAvaliacoesResult.clear();
    allAlunoAvaliacoesResult.add(new AvaliacaoResult());
    allAvaliacoes.forEach((av) {
      if ((av.email == email) && (av.situacao != 'Aberta')) {
        //inserir o filtro de datai e dataf
        avaliacoesAlunoCorrente.add(av);
      }
    });
    if (avaliacoesAlunoCorrente.isNotEmpty) {
      allAlunoAvaliacoesResult[i].aluno = 'Avaliações do aluno: ' + nome;
      allAlunoAvaliacoesResult[i].email = email;
      allAlunoAvaliacoesResult[i].periodo =
          'Data emissão: ' + DateFormat('dd/MM/yyyy').format(DateTime.now());

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
              nrsubjacentes,
              allAlunoAvaliacoesResult[i]);
          idquestcorr = ava.idQuestionario;
          totalacertos = 0;
          melhorresultado = 0;
          piorresultado = 0;
          totalerros = 0;
          nrtentativas = 0;
          nralternativasapresentadas = ava.nracertos + ava.nrerros;
          i++;
          allAlunoAvaliacoesResult.add(new AvaliacaoResult());
        }
        if (ava.situacao == 'Refazer Subjacente') {
          nrsubjacentes++;
        }
        titulo = ava.titulo;
        totalacertos = totalacertos + ava.nracertos;
        totalerros = totalerros + ava.nrerros;
        nrtentativas++;
      });
      totalizaAlunoAtividadePeriodo(
          titulo,
          nrtentativas,
          nralternativasapresentadas,
          totalacertos,
          totalerros,
          nrsubjacentes,
          allAlunoAvaliacoesResult[i]);
    }
    return allAlunoAvaliacoesResult;
  }
}
