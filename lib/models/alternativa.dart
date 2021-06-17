class Alternativa {
  Alternativa(
      {this.ordem, this.descricao, this.imagem, this.correta, this.pontuacao});
  Alternativa.fromMap(Map<String, dynamic> map) {
    ordem = map['ordem'] as num;
    descricao = map['descricao'] as String;
    imagem = map['imagem'] as String;
    correta = map['correta'] as bool;
    pontuacao = map['pontuacao'] as num;
  }

  String descricao;
  num ordem;
  String imagem;
  bool correta = true;
  num pontuacao = 1;

  Alternativa clone() {
    return Alternativa(
      descricao: descricao,
      ordem: ordem,
      imagem: imagem,
      correta: correta,
      pontuacao: pontuacao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ordem': ordem,
      'descricao': descricao,
      'imagem': imagem,
      'correta': correta,
      'pontuacao': pontuacao,
    };
  }

  @override
  String toString() {
    return 'Alternativa{ordem: $ordem, descricao: $descricao, imagem: $imagem, correta: $correta, pontuacao: $pontuacao}';
  }
}
