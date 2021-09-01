import 'package:flutter/cupertino.dart';

class Resposta extends ChangeNotifier {
  Resposta(
      {this.email,
      this.correta,
      this.pontuacao,
      this.nrtentativa,
      this.dataexecucao}) {
    email = email;
    pontuacao = pontuacao ?? 0;
    correta = correta ?? true;
    dataexecucao = dataexecucao ?? DateTime.now().toLocal();
  }
  Resposta.fromMap(Map<String, dynamic> map) {
    email = map['email'] as String;
    correta = map['correta'] as bool;
    pontuacao = map['pontuacao'] as num;
    dataexecucao = map['dataexecucao'].toDate();
    nrtentativa = map['nrtentativa'] as int;
  }

  String descricao;
  bool correta = true;
  num pontuacao = 1;
  String email;
  DateTime dataexecucao;
  int nrtentativa;

  bool _aCorreta;
  bool get aCorreta => _aCorreta;
  set qCorreta(bool valor) {
    _aCorreta = valor;
    correta = valor;
    notifyListeners();
  }

  Resposta clone() {
    return Resposta(
        email: email,
        correta: correta,
        pontuacao: pontuacao,
        dataexecucao: dataexecucao,
        nrtentativa: nrtentativa);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'correta': correta,
      'pontuacao': pontuacao,
      'dataexecucao': dataexecucao,
      'nrtentativa': nrtentativa
    };
  }

  @override
  String toString() {
    return 'Resposta{email: $email, correta: $correta, pontuacao: $pontuacao, dataexecucao: $dataexecucao}';
  }
}
