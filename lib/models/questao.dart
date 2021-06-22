import 'package:amesaadm/models/alternativa.dart';
import 'package:flutter/cupertino.dart';

class Questao extends ChangeNotifier {
  Questao({this.descricao, this.imagem, this.alternativas}) {
    alternativas = alternativas ?? [];
  }
  Questao.fromMap(Map<String, dynamic> map) {
    descricao = map['descricao'] as String;
    imagem = map['imagem'] as String;
    alternativas = (map['alternativas'] as List<dynamic> ?? [])
        .map((s) => Alternativa.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  String descricao;
  String imagem;
  List<Alternativa> alternativas;

  Questao clone() {
    return Questao(
      descricao: descricao,
      imagem: imagem,
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

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'imagem': imagem,
      'alternativas': exportAlternativaList(),
    };
  }

  @override
  String toString() {
    return 'Questao{descricao: $descricao, imagem: $imagem, questoes: $alternativas}';
  }
}
