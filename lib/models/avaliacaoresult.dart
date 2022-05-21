import 'package:flutter/cupertino.dart';

class AvaliacaoResult extends ChangeNotifier {
  AvaliacaoResult(this.titulo, this.aluno, this.numerotentativas,
      this.mediaAcertos, this.totalAcertos, this.atividadesubjacente) {
    titulo = titulo ?? '';
    aluno = aluno ?? '';
    numerotentativas = numerotentativas ?? '';
    mediaAcertos = mediaAcertos ?? '';
    totalAcertos = totalAcertos;
    atividadesubjacente = atividadesubjacente;
  }

  String titulo;
  String aluno;
  String numerotentativas;
  String mediaAcertos;
  String totalAcertos;
  String atividadesubjacente;
}
