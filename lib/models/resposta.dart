import 'package:flutter/cupertino.dart';

class Resposta extends ChangeNotifier {
  Resposta({this.idaluno, this.correta, this.pontuacao, this.dataexecucao}) {
    idaluno = idaluno ?? 0;
    pontuacao = pontuacao ?? 0;
    correta = correta ?? true;
    dataexecucao = dataexecucao ?? DateTime.now().toLocal();
  }
  Resposta.fromMap(Map<String, dynamic> map) {
    idaluno = map['idaluno'] as num;
    correta = map['correta'] as bool;
    pontuacao = map['pontuacao'] as num;
    dataexecucao = map['dataexecucao'].toDate();
  }

  String descricao;
  bool correta = true;
  num pontuacao = 1;
  num idaluno = 0;
  DateTime dataexecucao;

  bool _aCorreta;
  bool get aCorreta => _aCorreta;
  set qCorreta(bool valor) {
    _aCorreta = valor;
    correta = valor;
    notifyListeners();
  }

  Resposta clone() {
    return Resposta(
        idaluno: idaluno,
        correta: correta,
        pontuacao: pontuacao,
        dataexecucao: dataexecucao);
  }

  Map<String, dynamic> toMap() {
    return {
      'idaluno': idaluno,
      'correta': correta,
      'pontuacao': pontuacao,
      'dataexecucao': dataexecucao
    };
  }

  @override
  String toString() {
    return 'Resposta{idaluno: $idaluno, correta: $correta, pontuacao: $pontuacao, dataexecucao: $dataexecucao}';
  }
}
