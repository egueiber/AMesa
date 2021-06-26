import 'package:amesaadm/models/questao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Questionario extends ChangeNotifier {
  Questionario(
      {this.id,
      this.titulo,
      this.descricao,
      this.images,
      this.ativo,
      this.questoes}) {
    images = images ?? [];
    questoes = questoes ?? [];
  }
  Questionario.fromDocument(DocumentSnapshot document) {
    id = document.id;
    var item = document.data() as Map;
    titulo = item['titulo'] as String;
    descricao = item['descricao'] as String;
    ativo = item['ativo'] as bool;
    // images = List<String>.from(item['images']);
    images = List<String>.from(item['images'] as List<dynamic>);
    questoes = (item['questoes'] as List<dynamic> ?? [])
        .map((s) => Questao.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  DocumentReference get firestoreRef => firestore.doc('questionarios/$id');
  Reference get storageRef => storage.ref().child('questionarios').child(id);
  String id;
  String titulo;
  String descricao;
  bool ativo;
  List<String> images;
  List<Questao> questoes;

  List<dynamic> newImages;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Questao _selectedQuestao;
  Questao get selectedQuestao => _selectedQuestao;
  set selectedQuestao(Questao value) {
    _selectedQuestao = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> exportQuestaoList() {
    return questoes.map((questao) => questao.toMap()).toList();
  }

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'titulo': titulo,
      'descricao': descricao,
      'ativo': ativo,
      'questoes': exportQuestaoList(),
      // 'images': List.from(images)
    };

    if (id == null) {
      final doc = await firestore.collection('questionarios').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    /* Questao findQuestao(String descricao) {
      try {
        return questoes.firstWhere((s) => s.descricao == descricao);
      } catch (e) {
        return null;
      }
    }*/

    final List<String> updateImages = [];

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final UploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImage as File);
        final TaskSnapshot snapshot = await task;
        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }

    for (final image in images) {
      if (!newImages.contains(image)) {
        try {
          final ref = storage.refFromURL(image);
          await ref.delete();
        } catch (e) {
          debugPrint('Falha ao deletar $image');
        }
      }
    }

    await firestoreRef.update({'images': updateImages});

    images = updateImages;

    loading = false;
  }

  Questionario clone() {
    return Questionario(
      id: id,
      titulo: titulo,
      ativo: ativo,
      descricao: descricao,
      images: List.from(images),
      questoes: questoes.map((questao) => questao.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Questionario{id: $id, name: $titulo, description: $descricao, ativo: $ativo, images: $images, questoes: $questoes, newImages: $newImages}';
  }
}
