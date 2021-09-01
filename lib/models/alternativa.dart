import 'package:flutter/cupertino.dart';

class Alternativa extends ChangeNotifier {
  Alternativa({this.descricao, this.correta, this.pontuacao, this.images}) {
    images = images ?? [];
    correta = correta ?? true;
    respostaCorreta = false;
    selecionada = false;
  }
  Alternativa.fromMap(Map<String, dynamic> map) {
    descricao = map['descricao'] as String;
    correta = map['correta'] as bool;
    pontuacao = map['pontuacao'] as num;
    images = List<dynamic>.from(map['images'] as List<dynamic>);
  }

  String descricao;
  List<dynamic> images;
  List<dynamic> newImages;
  bool correta = true;
  bool selecionada = false;
  num pontuacao = 1;

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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'correta': correta,
      'pontuacao': pontuacao,
      'images': List.from(images),
    };
  }

  @override
  String toString() {
    return 'Alternativa{descricao: $descricao, correta: $correta, pontuacao: $pontuacao, imagem: $images, newImages: $newImages}';
  }
}
