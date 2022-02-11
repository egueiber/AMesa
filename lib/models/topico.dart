import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Topico extends ChangeNotifier {
  Topico({this.id, this.objetivo, this.descricao, this.ativo}) {
    objetivo = objetivo ?? '';
    descricao = descricao ?? '';
    ativo = ativo ?? true;
  }

  Topico.fromDocument(DocumentSnapshot document) {
    id = document.id;
    var item = document.data() as Map;
    objetivo = item['objetivo'] as String;
    descricao = item['descricao'] as String;

    ativo = item['ativo'] as bool;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.doc('topicos/$id');

  String id;
  String objetivo;
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

  Topico clone() {
    return Topico(
        id: id, objetivo: objetivo, descricao: descricao, ativo: ativo);
  }

  Map<String, dynamic> toMap() {
    return {'objetivo': objetivo, 'descricao': descricao, 'ativo': ativo};
  }

  Future<void> save() async {
    //loading = true;

    final Map<String, dynamic> data = {
      'objetivo': objetivo,
      'descricao': descricao,
      'ativo': ativo
    };

    if (id == null) {
      final doc = await firestore.collection('topicos').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }
  }

  @override
  String toString() {
    return 'Topico{id: $id, objetivo: $objetivo, descricao: $descricao, ativo: $ativo}';
  }
}
