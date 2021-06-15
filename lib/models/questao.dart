class Questao {
  Questao({this.numero, this.descricao, this.imagem});
  Questao.fromMap(Map<String, dynamic> map) {
    numero = map['numero'] as num;
    descricao = map['descricao'] as String;
    imagem = map['imagem'] as String;
  }

  String descricao;
  num numero;
  String imagem;

  Questao clone() {
    return Questao(
      descricao: descricao,
      numero: numero,
      imagem: imagem,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'descricao': descricao,
      'imagem': imagem,
    };
  }

  @override
  String toString() {
    return 'ItemSize{numero: $numero, descricao: $descricao, imagem: $imagem}';
  }
}
