//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionarioTurma extends ChangeNotifier {
  QuestionarioTurma({this.turma, this.datainicio, this.datafim}) {
    turma = turma ?? "";
    datainicio ?? DateTime.now().toLocal();

    datafim ?? DateTime.now().toLocal();
  }
  QuestionarioTurma.fromMap(Map<String, dynamic> map) {
    turma = map['turma'] as String;
    datainicio = map['datainicio']
        .toDate(); //as DateTime.toLocal().parse("yyyy-MM-dd hh:mm:ss");
    datafim = map['datafim'].toDate(); // as DateTime;
  }

  String turma;
  DateTime datainicio;
  DateTime datafim;

  QuestionarioTurma clone() {
    return QuestionarioTurma(
        turma: turma, datainicio: datainicio, datafim: datafim);
  }

  Map<String, dynamic> toMap() {
    return {'turma': turma, 'datainicio': datainicio, 'datafim': datafim};
  }

  @override
  String toString() {
    return 'QuestionarioTurma{turma: $turma, datainicio: $datainicio, datafim: $datafim}';
  }
}
