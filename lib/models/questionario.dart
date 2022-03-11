import 'package:amesaadm/models/alternativa.dart';
import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/models/questionarioturmas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Questionario extends ChangeNotifier {
  Questionario(
      {this.id,
      this.titulo,
      this.descricao,
      this.images,
      this.youtubeLink,
      this.ativo,
      this.usarvideos,
      this.gamificar,
      this.qtdetentativas,
      this.questoes,
      this.questionarioturma,
      this.idUsuario,
      this.nrtentativa,
      this.topico,
      this.topicoanterior,
      this.nrerrosrefazer,
      this.nrerrosativanterior,
      this.atividadesubjacente,
      this.atividadeposterior,
      this.tipoaprendizagem,
     }) {
    images = images ?? [];
    questoes = questoes ?? [];
    ativo = ativo ?? true;
 
    usarvideos = usarvideos ?? false;
    gamificar = gamificar ?? false;
    nrerrosrefazer = nrerrosrefazer ?? 0;
    nrerrosativanterior = nrerrosativanterior ?? 0;
    questionarioturma = questionarioturma ?? [];
    //tipoaprendizagem = tipoaprendizagem ?? '';
  }
  Questionario.fromDocument(DocumentSnapshot document) {
    id = document.id;
    var item = document.data() as Map;
    titulo = item['titulo'] as String;
    descricao = item['descricao'] as String;
    youtubeLink = item['youtubeLink'] as String;
    topico = item['topico'] as String;
    topicoanterior = item['topicoanterior'] as String;
    nrerrosrefazer = item['nrerrosrefazer'] as num;
    nrerrosativanterior = item['nrerrosativanterior'] as num;
    atividadesubjacente = item['atividadesubjacente'] as String;
    atividadeposterior = item['atividadeposterior'] as String;
    tipoaprendizagem = item['tipoaprendizagem'] as String;
    ativo = item['ativo'] as bool;
    usarvideos = item['usarvideos'] as bool;
    gamificar = item['gamificar'] as bool;
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
  String topico;
  bool ativo;
  bool gamificar;
  bool usarvideos;
  String topicoanterior;
  num nrerrosrefazer;
  num nrerrosativanterior;
  List<String> images;
  List<Questao> questoes;
  List<QuestionarioTurma> questionarioturma;
  num questaocorrente;
  String emailUsuario;
  num qtdetentativas;
  num nrtentativa;
  num totalpontosperdidos;
  num totalpontosganhos;
  String atividadesubjacente;
  String atividadeposterior;
  String tipoaprendizagem;
  String youtubeLink;

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

  bool _qgamificar;
  bool get qGamificar => _qgamificar;
  set qGamificar(bool valor) {
    _qgamificar = gamificar;
    gamificar = valor;
    notifyListeners();
  }

  bool _usarvideos;
  bool get qUsarvideos => _usarvideos;
  set qUsarvideos(bool valor) {
    _usarvideos = valor;
    usarvideos = valor;
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

//verificar a última resposta de cada usuario
  void tentativas() {
    num ultima = 0;
    totalpontosperdidos = 0;
    totalpontosganhos = 0;
    if (questoes[0].alternativas.isNotEmpty) {
      questoes[0].alternativas.forEach((alt) {
        if (alt.respostas.isNotEmpty) {
          alt.respostas.forEach((r) {
            if ((r.idUsuario == idUsuario) && (r.nrtentativa > ultima)) {
              ultima = r.nrtentativa;
            }
          });
        }
      });
    }
    nrtentativa = ultima;
    ativo = (qtdetentativas > nrtentativa);
    if (ativo) {
      if (questoes[0].alternativas.isNotEmpty) {
        questoes.forEach((q) {
          q.respondida = false;
          q.alternativas.forEach((alt) {
            alt.selecionada = false;
          });
        });
        nrtentativa++;
      }
    } else {
      //verificar se na última tentativa aquela alternativa foi selecionada e atribui
      totalpontosganhos = 0;
      totalpontosperdidos = 0;
      questoes.forEach((q) {
        q.respondida = true;
        q.corrigir(idUsuario, id, emailUsuario, nrtentativa);
        totalpontosganhos = totalpontosganhos + q.pontos;
        totalpontosperdidos = totalpontosperdidos + q.pontosperdidos;
      });
    }
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
    alternativaselecionada.selecionada = !alternativaselecionada.selecionada;
    notifyListeners();
  }

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'titulo': titulo,
      'descricao': descricao,
      'ativo': ativo,
      'usarvideos': usarvideos,
      'gamificar': gamificar,
      'qtdetentativas': qtdetentativas,
      'topico': topico,
      'topicoanterior': topicoanterior,
      'atividadesubjacente': atividadesubjacente,
      'atividadeposterior': atividadeposterior,
      'nrerrosrefazer': nrerrosrefazer,
      'nrerrosativanterior': nrerrosativanterior,
      'tipoaprendizagem': tipoaprendizagem,
      'youtubeLink': youtubeLink,
      'totalpontosganhos': totalpontosganhos,
      'totalpontosperdidos': totalpontosperdidos,
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
      gamificar: gamificar,
      usarvideos: usarvideos,
      descricao: descricao,
      topico: topico,
      qtdetentativas: qtdetentativas,
      nrtentativa: nrtentativa,
      nrerrosrefazer: nrerrosrefazer,
      nrerrosativanterior: nrerrosativanterior,
      topicoanterior: topicoanterior,
      idUsuario: idUsuario,
      atividadesubjacente: atividadesubjacente,
      atividadeposterior: atividadeposterior,
      tipoaprendizagem: tipoaprendizagem,
      youtubeLink: youtubeLink,
      images: List.from(images),
      questoes: questoes.map((questao) => questao.clone()).toList(),
      questionarioturma: questionarioturma.map((qt) => qt.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Questionario{id: $id, name: $titulo, description: $descricao, youtubeLink: $youtubeLink,ativo: $ativo, usarvideos: $usarvideos, gamificar: $gamificar, idUsuario: $idUsuario ,qtdetentativas:$qtdetentativas,topico:$topico, topicoanterior:$topicoanterior, nrerrosrefazer: $nrerrosrefazer, nrerrosativanterior: $nrerrosativanterior,atividadesubjacente: $atividadesubjacente, atividadeposterior: $atividadeposterior, tipoaprendizagem: $tipoaprendizagem, images: $images, questoes: $questoes, questionarioturma: $questionarioturma, newImages: $newImages}';
  }
}
