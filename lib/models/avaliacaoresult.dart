import 'package:flutter/cupertino.dart';

class AvaliacaoResult extends ChangeNotifier {
  AvaliacaoResult(
      [this.titulo,
      this.aluno,
      this.email,
      this.periodo,
      this.numerotentativas,
      this.mediaAcertos,
      this.mediaErros,
      this.totalAcertos,
      this.totalErros,
      this.atividadesubjacente,
      this.dataExecucao,
      this.situacao]) {
    titulo = titulo ?? '';
    aluno = aluno ?? '';
    numerotentativas = numerotentativas ?? '';
    mediaAcertos = mediaAcertos ?? '';
    totalAcertos = totalAcertos ?? '';
    mediaErros = mediaErros ?? '';
    totalErros = totalErros ?? '';
    situacao = situacao ?? '';
    dataExecucao = dataExecucao ?? DateTime.now();
    atividadesubjacente = atividadesubjacente;
  }

  String titulo = 'Titulo';
  String situacao = 'Situação';
  String aluno = 'Aluno';
  String email = 'email';
  String periodo = 'Periodo';
  String numerotentativas = 'Tentativas';
  String mediaAcertos = 'Media Acertos';
  String mediaErros = 'Media Erros';
  String totalAcertos = 'Acertos';
  String totalErros = 'Erros';
  String atividadesubjacente = 'Atividade Subjacente';
  String dataexecucaoStr = 'Execução';
  DateTime dataExecucao;
  List<String> getFields() => [
        dataexecucaoStr,
        titulo,
        situacao,
        aluno,
        email,
        periodo,
        totalAcertos,
        totalErros
      ];
  Map<String, dynamic> toMap() {
    return {
      'dataexecucaoStr': dataexecucaoStr,
      'titulo': titulo,
      'situacao': situacao,
      'aluno': aluno,
      'email': email,
      'periodo': periodo,
      'totalAcertos': totalAcertos,
      'totalErros': totalErros
    };
  }
}
