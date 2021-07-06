import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Aluno extends ChangeNotifier {
  Aluno({this.id, this.nome, this.turma, this.email, this.ativo}) {
    nome = nome ?? '';
    email = email ?? '';
    turma = turma ?? '';
    ativo = ativo ?? true;
  }

  Aluno.fromDocument(DocumentSnapshot document) {
    id = document.id;
    var item = document.data() as Map;
    nome = item['nome'] as String;
    turma = item['turma'] as String;
    email = item['email'] as String;
    ativo = item['ativo'] as bool;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.doc('alunos/$id');

  String id;
  String nome;
  String turma;
  String email;
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

  Aluno clone() {
    return Aluno(id: id, nome: nome, turma: turma, email: email, ativo: ativo);
  }

  Map<String, dynamic> toMap() {
    return {'nome': nome, 'turma': turma, 'email': email, 'ativo': ativo};
  }

  Future<void> save() async {
    //loading = true;

    final Map<String, dynamic> data = {
      'nome': nome,
      'turma': turma,
      'email': email,
      'ativo': ativo
    };

    if (id == null) {
      final doc = await firestore.collection('alunos').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }
  }

  @override
  String toString() {
    return 'Aluno{id: $id, nome: $nome, turma: $turma, email: $email, ativo: $ativo}';
  }
}
