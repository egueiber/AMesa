import 'package:amesaadm/models/alternativa.dart';
import 'package:amesaadm/models/resposta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Questao extends ChangeNotifier {
  Questao({this.descricao, this.imagem, this.alternativas, this.respostas}) {
    alternativas = alternativas ?? [];
    respostas = respostas ?? [];
    respondida = false;
  }
  Questao.fromMap(Map<String, dynamic> map) {
    descricao = map['descricao'] as String;
    imagem = map['imagem'] as String;
    alternativas = (map['alternativas'] as List<dynamic> ?? [])
        .map((s) => Alternativa.fromMap(s as Map<String, dynamic>))
        .toList();
    respostas = (map['respostas'] as List<dynamic> ?? [])
        .map((s) => Resposta.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  String descricao;
  String imagem;
  bool lido = false;
  bool respondida = false;
  List<Alternativa> alternativas;
  List<Resposta> respostas;
  num pontos = 0;
  num pontosperdidos = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Questao clone() {
    return Questao(
      descricao: descricao,
      imagem: imagem,
      alternativas:
          alternativas.map((alternativa) => alternativa.clone()).toList(),
      respostas: respostas.map((resposta) => resposta.clone()).toList(),
    );
  }

  Alternativa _selectedAlternativa;
  Alternativa get selectedAlternativa => _selectedAlternativa;
  set selectedAlternativa(Alternativa value) {
    _selectedAlternativa = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> exportAlternativaList() {
    return alternativas.map((alternativa) => alternativa.toMap()).toList();
  }

  List<Map<String, dynamic>> exportRespostaList() {
    return respostas.map((resposta) => resposta.toMap()).toList();
  }

  bool findRespostaAluno(String email, int nrtentativa) {
    bool existe = false;
    if (respostas.isNotEmpty) {
      respostas.forEach((r) {
        if ((r.email == email) && (r.nrtentativa == nrtentativa)) {
          existe = true;
        }
      });
    }

    return existe;
  }

  bool corrigir(String idQuestionario, String email, int nrtentativa) {
    bool valido = false;
    pontos = 0;
    pontosperdidos = 0;
    for (int i = 0; i < alternativas.length; i++) {
      if (alternativas[i].selecionada) {
        valido = true;
        alternativas[i].respostaCorreta = (alternativas[i].correta);
        if (alternativas[i].respostaCorreta) {
          pontos = pontos + alternativas[i].pontuacao;
        } else {
          pontosperdidos = pontosperdidos + alternativas[i].pontuacao;
        }
        addRespostaQuestionario(
            idQuestionario,
            email,
            alternativas[i].respostaCorreta,
            alternativas[i].pontuacao,
            nrtentativa);
      }
    }
    respondida = valido;
    return valido;
  }

  bool addRespostaQuestionario(String idQuestionario, String email,
      bool correta, num pontuacao, int nrtentativa) {
    final existe = findRespostaAluno(email, nrtentativa);
    final Resposta resposta = (Resposta(
        idQuestionario: idQuestionario,
        email: email,
        dataexecucao: DateTime.now(),
        correta: correta,
        pontuacao: pontuacao,
        nrtentativa: nrtentativa));
/*     if (existe) {
      respostas.removeWhere((r) => r.email == email);
    } */
    respostas.add(resposta);
    //updateRespostaAluno();
    return existe;
  }

  /* Future<void> updateRespostaAluno() async {
    if (id != null) {
      await firestoreRef.update({'respostas': exportRespostaList()});
    }
    notifyListeners();
  } */

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'imagem': imagem,
      'alternativas': exportAlternativaList(),
      'respostas': exportRespostaList(),
    };
  }

  @override
  String toString() {
    return 'Questao{descricao: $descricao, imagem: $imagem, questoes: $alternativas, respostas: $respostas}';
  }
}
