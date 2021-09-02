import 'package:amesaadm/models/alternativa.dart';
import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/models/questionarioturmas.dart';
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
      this.qtdetentativas,
      this.questoes,
      this.questionarioturma,
      this.idUsuario}) {
    images = images ?? [];
    questoes = questoes ?? [];
    ativo = ativo ?? true;
    questionarioturma = questionarioturma ?? [];
  }
  Questionario.fromDocument(DocumentSnapshot document) {
    id = document.id;
    var item = document.data() as Map;
    titulo = item['titulo'] as String;
    descricao = item['descricao'] as String;
    ativo = item['ativo'] as bool;
    qtdetentativas = item['qtdetentativas'] as num;
    // images = List<String>.from(item['images']);
    images = List<String>.from(item['images'] as List<dynamic>);
    questoes = (item['questoes'] as List<dynamic> ?? [])
        .map((s) => Questao.fromMap(s as Map<String, dynamic>))
        .toList();
    questionarioturma = (item['questionarioturma'] as List<dynamic> ?? {})
        .map((s) => QuestionarioTurma.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  DocumentReference get firestoreRef => firestore.doc('questionarios/$id');
  Reference get storageRef => storage.ref().child('questionarios').child(id);
  Reference get storageRefAlt =>
      storage.ref().child('questionarios/alternativas').child(id);

  String id;
  String idUsuario;
  String titulo;
  String descricao;
  bool ativo;
  List<String> images;
  List<Questao> questoes;
  List<QuestionarioTurma> questionarioturma;
  num questaocorrente;
  String emailUsuario;
  num qtdetentativas;
  num nrtentativa;

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

  // bool get questionarioativo => _ativo;
  bool _qativo;
  bool get qAtivo => _qativo;
  set qAtivo(bool valor) {
    _qativo = valor;
    ativo = valor;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  List<Map<String, dynamic>> exportQuestaoList() {
    return questoes.map((questao) => questao.toMap()).toList();
  }

  List<Map<String, dynamic>> exportQuestionarioTurmaList() {
    if (questionarioturma != null)
      return questionarioturma.map((qt) => qt.toMap()).toList();
    else
      return null;
  }

  void tentativas() {
    num ultima = 0;
    for (final resp in questoes[0].respostas) {
      if ((emailUsuario == resp.email) && (resp.nrtentativa > ultima))
        ultima = resp.nrtentativa;
    }
    nrtentativa = ultima;
  }

  QuestionarioTurma findQuestionarioTurma(String sigla) {
    try {
      return questionarioturma.firstWhere((s) => s.turma == sigla);
    } catch (e) {
      return null;
    }
  }

  bool addQuestionarioTurma(String turma) {
    final existe = !(findQuestionarioTurma(turma) == null);
    if (!existe) {
      final QuestionarioTurma qt = (QuestionarioTurma(
          turma: turma,
          datainicio: DateTime.now(),
          datafim: DateTime.now().add(const Duration(days: 50))));
      questionarioturma.add(qt);
    } else
      questionarioturma.removeWhere((qt) => qt.turma == turma);
    updateQuestionarioTurma();
    return existe;
  }

  Future<void> updateQuestionarioTurma() async {
    if (id != null) {
      await firestoreRef
          .update({'questionarioturma': exportQuestionarioTurmaList()});
    }
    notifyListeners();
  }

  Future<void> updateQuestoes() async {
    if (id != null) {
      await firestoreRef.update({'questoes': exportQuestaoList()});
    }
    notifyListeners();
  }

  Future<void> updateAlternativa(Alternativa alternativaselecionada) async {
    /*  if (id != null) {
      await firestoreRef
          .update({'questionarioturma': exportQuestionarioTurmaList()});
    } */
    alternativaselecionada.selecionada = !alternativaselecionada.selecionada;
    notifyListeners();
  }

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'titulo': titulo,
      'descricao': descricao,
      'ativo': ativo,
      'qtdetentativas': qtdetentativas,
      'questoes': exportQuestaoList(),
      'questionarioturma': exportQuestionarioTurmaList() ?? [],
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
    await atzImg(); //para atualizar as imagens das alternativas.
    await firestoreRef.update({'images': updateImages});
    await firestoreRef.update({'questoes': exportQuestaoList()});

    images = updateImages;

    //atualiza as imagens das alternativas

    loading = false;
  }

  Future<void> atzImg() async {
    List<String> updateImagesAlt = [];
    for (final q in this.questoes) {
      for (final alter in q.alternativas) {
        for (final newImage in alter.newImages) {
          if (alter.images.contains(newImage)) {
            updateImagesAlt.add(newImage as String);
          } else {
            final UploadTask task =
                storageRefAlt.child(Uuid().v1()).putFile(newImage as File);
            final TaskSnapshot snapshot = await task;
            final String url = await snapshot.ref.getDownloadURL();
            updateImagesAlt.add(url);
          }
        }

        for (final image in alter.images) {
          if (!alter.newImages.contains(image)) {
            try {
              final ref = storage.refFromURL(image);
              await ref.delete();
            } catch (e) {
              debugPrint('Falha ao deletar $image');
            }
          }
        }
        alter.images = updateImagesAlt;
        updateImagesAlt = [];
      }
    }
  }

  Questionario clone() {
    return Questionario(
      id: id,
      titulo: titulo,
      ativo: ativo,
      descricao: descricao,
      qtdetentativas: qtdetentativas,
      idUsuario: idUsuario,
      images: List.from(images),
      questoes: questoes.map((questao) => questao.clone()).toList(),
      questionarioturma: questionarioturma.map((qt) => qt.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Questionario{id: $id, name: $titulo, description: $descricao, ativo: $ativo, idUsuario: $idUsuario ,qtdetentativas:$qtdetentativas, images: $images, questoes: $questoes, questionarioturma: $questionarioturma, newImages: $newImages}';
  }
}
