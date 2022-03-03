import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TipoAprendizagem extends ChangeNotifier {
  TipoAprendizagem({this.id, this.descricao, this.ativo}) {
    descricao = descricao ?? '';
    ativo = ativo ?? true;
  }

  TipoAprendizagem.fromDocument(DocumentSnapshot document) {
    id = document.id;
    var item = document.data() as Map;
    descricao = item['descricao'] as String;
    ativo = item['ativo'] as bool;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.doc('tipoaprendizagem/$id');

  String id;

  String descricao;

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

  TipoAprendizagem clone() {
    return TipoAprendizagem(id: id, descricao: descricao, ativo: ativo);
  }

  Map<String, dynamic> toMap() {
    return {'descricao': descricao, 'ativo': ativo};
  }

  Future<void> save() async {
    //loading = true;

    final Map<String, dynamic> data = {'descricao': descricao, 'ativo': ativo};

    if (id == null) {
      final doc = await firestore.collection('tipoaprendizagem').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }
  }

  @override
  String toString() {
    return 'TipoAprendizagem{id: $id, descricao: $descricao, ativo: $ativo}';
  }
}
