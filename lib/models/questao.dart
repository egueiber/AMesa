import 'package:amesaadm/models/alternativa.dart';
import 'package:amesaadm/models/resposta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Questao extends ChangeNotifier {
  Questao(
      {this.descricao,
      this.imagem,
      this.youtubeLink,
      this.alternativas,
      this.respostas}) {
    alternativas = alternativas ?? [];
    respondida = false;
  }
  Questao.fromMap(Map<String, dynamic> map) {
    descricao = map['descricao'] as String;
    imagem = map['imagem'] as String;
    youtubeLink = map['youtubeLink'] as String;
    alternativas = (map['alternativas'] as List<dynamic> ?? [])
        .map((s) => Alternativa.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  String descricao;
  String imagem;
  String youtubeLink;
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
      youtubeLink: youtubeLink,
      alternativas:
          alternativas.map((alternativa) => alternativa.clone()).toList(),
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

  bool corrigir(
      String idUsuario, String idQuestionario, String email, int nrtentativa) {
    bool respondido = false;
    pontos = 0;
    pontosperdidos = 0;
    for (int i = 0; i < alternativas.length; i++) {
      alternativas[i].recuperaSelecao(idUsuario, nrtentativa);
      if (alternativas[i].selecionada) {
        if (alternativas[i].correta)
          pontos = pontos + alternativas[i].pontuacao;
        else
          pontosperdidos = pontosperdidos + alternativas[i].pontuacao;
        respondido = true;
      }
    }
    respondida = respondido;
    return respondido;
  }

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'imagem': imagem,
      'youtubeLink': youtubeLink,
      'alternativas': exportAlternativaList(),
    };
  }

  @override
  String toString() {
    return 'Questao{descricao: $descricao, imagem: $imagem, youtubeLink: $youtubeLink, questoes: $alternativas}';
  }
}
