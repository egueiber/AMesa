import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:amesaadm/models/tipoaprendizagem.dart';

class TipoAprendizagemManager extends ChangeNotifier {
  TipoAprendizagemManager() {
    _loadAllTipoAprendizagem();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<TipoAprendizagem> allTipoAprendizagem = [];

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<TipoAprendizagem> get filteredTipoAprendizagemAtivaByTipo {
    List<TipoAprendizagem> topicoAtivasbyTipoAprendizagem = [];
    topicoAtivasbyTipoAprendizagem
        .addAll(allTipoAprendizagem.where((a) => a.ativo));
    topicoAtivasbyTipoAprendizagem.sort((a, b) =>
        a.descricao.toLowerCase().compareTo(b.descricao.toLowerCase()));

    return topicoAtivasbyTipoAprendizagem;
  }

  List<TipoAprendizagem> get filteredTipoAprendizagem {
    final List<TipoAprendizagem> filteredTipoAprendizagem = [];
    if (search.isEmpty) {
      filteredTipoAprendizagem.addAll(allTipoAprendizagem);
    } else {
      filteredTipoAprendizagem.addAll(allTipoAprendizagem.where(
          (a) => a.descricao.toLowerCase().contains(search.toLowerCase())));
    }
    filteredTipoAprendizagem.sort((a, b) =>
        a.descricao.toLowerCase().compareTo(b.descricao.toLowerCase()));
    return filteredTipoAprendizagem;
  }

  Future<void> _loadAllTipoAprendizagem() async {
    final QuerySnapshot snapTiposAprendizagem =
        await firestore.collection('tipoaprendizagem').get();
    allTipoAprendizagem = snapTiposAprendizagem.docs
        .map((d) => TipoAprendizagem.fromDocument(d))
        .toList();
    if (allTipoAprendizagem.isNotEmpty) {
      allTipoAprendizagem.sort((a, b) =>
          a.descricao.toLowerCase().compareTo(b.descricao.toLowerCase()));
    }
    notifyListeners();
  }

  TipoAprendizagem findTipoAprendizagemById(String id) {
    try {
      return allTipoAprendizagem.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(TipoAprendizagem tipoAprendizagem) {
    allTipoAprendizagem.removeWhere((p) => p.id == tipoAprendizagem.id);
    allTipoAprendizagem.add(tipoAprendizagem);
    notifyListeners();
  }
}
