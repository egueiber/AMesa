import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Aluno extends ChangeNotifier {
  Aluno({this.id, this.nome, this.turma, this.email}) {
    turma = turma ?? '';
  }

  Aluno.fromDocument(DocumentSnapshot document) {
    id = document.id;
    var item = document.data() as Map;
    nome = item['nome'] as String;
    turma = item['turma'] as String;
    email = item['email'] as String;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference get firestoreRef => firestore.doc('alunos/$id');

  String id;
  String nome;
  String turma;
  String email;

  Aluno clone() {
    return Aluno(nome: nome, turma: turma, email: email);
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'turma': turma,
      'email': email,
    };
  }

  Future<void> save() async {
    //loading = true;

    final Map<String, dynamic> data = {
      'nome': nome,
      'turma': turma,
      'email': email,
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
    return 'Aluno{nome: $nome, turma: $turma, email: $email}';
  }
}
