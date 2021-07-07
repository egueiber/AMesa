import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Turma extends ChangeNotifier {
  Turma({this.id, this.sigla, this.descricao, this.ano, this.ativo}) {
    sigla = sigla ?? '';
    descricao = descricao ?? '';
    ano = ano;
    ativo = ativo ?? true;
  }

  Turma.fromDocument(DocumentSnapshot document) {
    id = document.id;
    var item = document.data() as Map;
    sigla = item['sigla'] as String;
    descricao = item['descricao'] as String;
    ano = item['ano'] as num;
    ativo = item['ativo'] as bool;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.doc('turmas/$id');

  String id;
  String sigla;
  String descricao;
  num ano;
  bool ativo;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _qativo;
  bool get qAtivo => _qativo;
  set qAtivo(bool valor) {
    _qativo = valor;
    ativo = valor;
    notifyListeners();
  }

  Turma clone() {
    return Turma(
        id: id, sigla: sigla, descricao: descricao, ano: ano, ativo: ativo);
  }

  Map<String, dynamic> toMap() {
    return {'sigla': sigla, 'descricao': descricao, 'ano': ano, 'ativo': ativo};
  }

  Future<void> save() async {
    //loading = true;

    final Map<String, dynamic> data = {
      'sigla': sigla,
      'descricao': descricao,
      'ano': ano,
      'ativo': ativo
    };

    if (id == null) {
      final doc = await firestore.collection('turmas').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }
  }

  @override
  String toString() {
    return 'Turma{id: $id, sigla: $sigla, descricao: $descricao, ano: $ano, ativo: $ativo}';
  }
}
