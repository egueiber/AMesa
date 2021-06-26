class Alternativa {
  Alternativa({this.descricao, this.correta, this.pontuacao, this.images}) {
    images = images ?? [];
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
  num pontuacao = 1;
  //String newImagem;

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
