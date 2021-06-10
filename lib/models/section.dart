import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amesaadm/models/section_item.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  Section({this.id, this.name, this.type, this.items}) {
    items = items ?? [];
    originalItems = List.from(items);
  }

  Section.fromDocument(DocumentSnapshot document) {
    var item = document.data() as Map;
    id = document.id;
    name = item['name'] as String;
    type = item['type'] as String;
    items = (item['items'] as List)
        .map((i) => SectionItem.fromMap(i as Map<String, dynamic>))
        .toList();
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('home/$id');
  Reference get storageRef => storage.ref().child('home/$id');

  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  String _error;
  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  Future<void> save(int pos) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    if (id == null) {
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final UploadTask task =
            storageRef.child(Uuid().v1()).putFile(item.image as File);
        final TaskSnapshot snapshot = await task;
        final String url = await snapshot.ref.getDownloadURL();
        item.image = url;
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original)) {
        try {
          final ref = storage.refFromURL(original.image as String);
          await ref.delete();
          // ignore: empty_catches
        } catch (e) {}
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList()
    };

    await firestoreRef.update(itemsData);
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      try {
        final ref = storage.refFromURL(item.image as String);
        await ref.delete();
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  bool valid() {
    if (name == null || name.isEmpty) {
      error = 'Título inválido';
    } else if (items.isEmpty) {
      error = 'Insira ao menos uma imagem';
    } else {
      error = null;
    }
    return error == null;
  }

  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
