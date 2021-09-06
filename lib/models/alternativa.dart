import 'package:amesaadm/models/resposta.dart';
import 'package:flutter/cupertino.dart';

class Alternativa extends ChangeNotifier {
  Alternativa(
      {this.descricao,
      this.correta,
      this.pontuacao,
      this.respostas,
      this.images}) {
    images = images ?? [];
    respostas = respostas ?? [];
    correta = correta ?? true;
    respostaCorreta = false;
    selecionada = false;
  }
  Alternativa.fromMap(Map<String, dynamic> map) {
    descricao = map['descricao'] as String;
    correta = map['correta'] as bool;
    pontuacao = map['pontuacao'] as num;
    images = List<dynamic>.from(map['images'] as List<dynamic>);
    respostas = (map['respostas'] as List<dynamic> ?? [])
        .map((s) => Resposta.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  String descricao;
  List<dynamic> images;
  List<dynamic> newImages;
  bool correta = true;
  bool selecionada = false;
  num pontuacao = 1;
  List<Resposta> respostas;

  //String newImagem;

  bool _aCorreta;
  bool get aCorreta => _aCorreta;

  set qCorreta(bool valor) {
    _aCorreta = valor;
    correta = valor;
    notifyListeners();
  }

  bool respostaCorreta = false;
//  bool get respostaCorreta => _respostaCorreta;
  /*  set respostaCorreta(bool valor) {
    _respostaCorreta = valor;
    // notifyListeners();
  }
 */
  bool _aselecionada;
  bool get aselecionada => _aselecionada;
  set qsetSelecionada(bool valor) {
    _aselecionada = valor;
    selecionada = valor;
  }

  Alternativa clone() {
    return Alternativa(
      descricao: descricao,
      images: List.from(images),
      correta: correta,
      pontuacao: pontuacao,
      respostas: respostas.map((resposta) => resposta.clone()).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'correta': correta,
      'pontuacao': pontuacao,
      'images': List.from(images),
      'respostas': exportRespostaList(),
    };
  }

  List<Map<String, dynamic>> exportRespostaList() {
    return respostas.map((resposta) => resposta.toMap()).toList();
  }

  bool findRespostaAluno(String idUsuario, int nrtentativa) {
    bool existe = false;
    if (respostas.isNotEmpty) {
      respostas.forEach((r) {
        if ((r.idUsuario == idUsuario) && (r.nrtentativa == nrtentativa)) {
          existe = true;
          respostaCorreta = correta;
        }
      });
    }
    return existe;
  }

  void removeResposta(String idUsuario, int nrTentativa) {
    respostas.removeWhere(
        (r) => ((r.idUsuario == idUsuario) && (r.nrtentativa == nrTentativa)));
  }

  void addResposta(
      String idUsuario, String idQuestionario, String email, int nrtentativa) {
    if (!findRespostaAluno(email, nrtentativa)) {
      final Resposta resposta = (Resposta(
          idQuestionario: idQuestionario,
          idUsuario: idUsuario,
          email: email,
          dataexecucao: DateTime.now(),
          correta: correta,
          pontuacao: pontuacao,
          nrtentativa: nrtentativa));
      respostas.add(resposta);
      selecionada = true;
    }
  }

  void recuperaSelecao(String idUsuario, int nrtentativa) {
    selecionada = findRespostaAluno(idUsuario, nrtentativa);
  }

  @override
  String toString() {
    return 'Alternativa{descricao: $descricao, correta: $correta, pontuacao: $pontuacao, respostas: $respostas,imagem: $images, newImages: $newImages}';
  }
}
