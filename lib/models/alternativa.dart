class Alternativa {
  Alternativa({this.descricao, this.imagem, this.correta, this.pontuacao});
  Alternativa.fromMap(Map<String, dynamic> map) {
    descricao = map['descricao'] as String;
    imagem = map['imagem'] as String;
    correta = map['correta'] as bool;
    pontuacao = map['pontuacao'] as num;
  }

  String descricao;

  String imagem = 'Link';
  bool correta = true;
  num pontuacao = 1;

  Alternativa clone() {
    return Alternativa(
      descricao: descricao,
      imagem: imagem,
      correta: correta,
      pontuacao: pontuacao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'imagem': imagem,
      'correta': correta,
      'pontuacao': pontuacao,
    };
  }

  @override
  String toString() {
    return 'Alternativa{descricao: $descricao, imagem: $imagem, correta: $correta, pontuacao: $pontuacao}';
  }
}
