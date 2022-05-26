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

  String titulo;
  String situacao;
  String aluno;
  String email;
  String periodo;
  String numerotentativas;
  String mediaAcertos;
  String mediaErros;
  String totalAcertos;
  String totalErros;
  String atividadesubjacente;
  DateTime dataExecucao;
}
