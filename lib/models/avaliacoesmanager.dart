import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:amesaadm/models/avaliacao.dart';

class AvaliacoesManager extends ChangeNotifier {
  AvaliacoesManager() {
    _loadAllAvaliacoes();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Avaliacao> allAvaliacoes = [];
  List<Avaliacao> avaliacoesAlunoCorrente = [];
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
    List<Avaliacao> avaliacaoQuestionarioAluno;
    List<Avaliacao> avaliacaoAluno;
    avaliacaoAluno = getAvaliacoesAlunoCorrente(email);
    avaliacaoAluno.forEach((av) {
      if (av.idQuestionario == idquestionario) {
        avaliacaoQuestionarioAluno.add(av);
      }
    });
    return avaliacaoQuestionarioAluno.last;
  }

  void recarregar() {
    _loadAllAvaliacoes();
  }

  List<Avaliacao> getAvaliacoesAlunoCorrente(String email) {
    allAvaliacoes.forEach((av) {
      if (av.email == email) {
        avaliacoesAlunoCorrente.add(av);
      }
    });
    if (avaliacoesAlunoCorrente.isNotEmpty) {
      avaliacoesAlunoCorrente
          .sort((a, b) => a.nrtentativa.compareTo(b.nrtentativa));
      getUltimaAvaliacaoAluno();
    }
    return avaliacoesAlunoCorrente;
  }

  List<Avaliacao> getAvaliacoesAbertaAlunoCorrente(String email) {
    allAvaliacoes.forEach((av) {
      if ((av.email == email) && (av.situacao == 'Aberta')) {
        avaliacoesAlunoCorrente.add(av);
      }
    });
    if (avaliacoesAlunoCorrente.isNotEmpty) {
      avaliacoesAlunoCorrente
          .sort((a, b) => a.nrtentativa.compareTo(b.nrtentativa));
      getUltimaAvaliacaoAluno();
    }
    return avaliacoesAlunoCorrente;
  }

  Avaliacao getUltimaAvaliacaoAluno() {
    ultimaAvaliacaoAluno = null;
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
}
