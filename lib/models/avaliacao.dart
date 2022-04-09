import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Avaliacao extends ChangeNotifier {
  Avaliacao(
      {this.id,
      this.situacao,
      this.origem,
      this.destino,
      this.nracertos,
      this.nrerros,
      this.dataexecucao,
      this.nrtentativa,
      this.idUsuario,
      this.email,
      this.idQuestionario,
      this.titulo}) {
    dataexecucao ?? DateTime.now().toLocal();
  }
  Avaliacao.fromDocument(DocumentSnapshot document) {
    id = document.id;
    var item = document.data() as Map;
    situacao = item['situacao'] as String;
    origem = item['origem'] as String;
    destino = item['destino'] as String;
    nracertos = item['nracertos'] as num;
    nrerros = item['nrerros'] as num;
    dataexecucao = item['dataexecucao'].toDate();
    nrtentativa = item['nrtentativa'] as num;
    idUsuario = item['idUsuario'] as String;
    idQuestionario = item['idQuestionario'] as String;
    titulo = item['titulo'] as String;
    email = item['email'] as String;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.doc('avaliacao/$id');

  String id;
  String idUsuario;
  String idQuestionario;
  String titulo;
  num nrtentativa;
  String email;
  DateTime dataexecucao;
  String situacao;
  String origem;
  String destino;
  num nracertos;
  num nrerros;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Avaliacao clone() {
    return Avaliacao(
        id: id,
        idUsuario: idUsuario,
        idQuestionario: idQuestionario,
        titulo: titulo,
        nrtentativa: nrtentativa,
        email: email,
        dataexecucao: dataexecucao,
        situacao: situacao,
        origem: origem,
        destino: destino,
        nracertos: nracertos,
        nrerros: nrerros);
  }

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'idQuestionario': idQuestionario,
      'titulo': titulo,
      'nrtentativa': nrtentativa,
      'email': email,
      'dataexecucao': dataexecucao,
      'situacao': situacao,
      'origem': origem,
      'destino': destino,
      'nracertos': nracertos,
      'nrerros': nrerros
    };
  }

  Future<void> save() async {
    //loading = true;

    final Map<String, dynamic> data = {
      'idUsuario': idUsuario,
      'idQuestionario': idQuestionario,
      'titulo': titulo,
      'nrtentativa': nrtentativa,
      'email': email,
      'dataexecucao': dataexecucao,
      'situacao': situacao,
      'origem': origem,
      'destino': destino,
      'nracertos': nracertos,
      'nrerros': nrerros
    };

    if (id == null) {
      final doc = await firestore.collection('avaliacao').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }
  }

  @override
  String toString() {
    return 'Avaliacao{idUsuario: $idUsuario, idQuestionario: $idQuestionario, titulo: $titulo, nrtentativa: $nrtentativa, email: $email, dataexecucao: $dataexecucao,situacao: $situacao,origem: $origem,destino: $destino, nracertos: $nracertos,nrerros: $nrerros}';
  }
}
