import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:amesaadm/models/topico.dart';

class TopicosManager extends ChangeNotifier {
  TopicosManager() {
    _loadAllTopicos();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Topico> allTopicos = [];

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Topico> get filteredTopicoAtivaByTopico {
    List<Topico> topicoAtivasbyTopico = [];
    topicoAtivasbyTopico.addAll(allTopicos.where((a) => a.ativo));
    topicoAtivasbyTopico.sort(
        (a, b) => a.objetivo.toLowerCase().compareTo(b.objetivo.toLowerCase()));

    return topicoAtivasbyTopico;
  }

  List<Topico> get filteredProducts {
    final List<Topico> filteredTopicos = [];
    if (search.isEmpty) {
      filteredTopicos.addAll(allTopicos);
    } else {
      filteredTopicos.addAll(allTopicos.where(
          (a) => a.objetivo.toLowerCase().contains(search.toLowerCase())));
    }
    filteredTopicos.sort((a, b) =>
        a.descricao.toLowerCase().compareTo(b.descricao.toLowerCase()));
    return filteredTopicos;
  }

  Future<void> _loadAllTopicos() async {
    final QuerySnapshot snapTopicos =
        await firestore.collection('topicos').get();
    allTopicos = snapTopicos.docs.map((d) => Topico.fromDocument(d)).toList();
    // topicosInativas = allTopicos.where((t) => (!t.ativo));

    notifyListeners();
  }

  Topico findTopicoById(String id) {
    try {
      return allTopicos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Topico topico) {
    allTopicos.removeWhere((p) => p.id == topico.id);
    allTopicos.add(topico);
    notifyListeners();
  }
}
