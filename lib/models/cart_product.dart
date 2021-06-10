import 'package:amesaadm/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:amesaadm/models/item_size/itemsize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this.product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    var item = document.data() as Map;
    id = document.id;
    productId = item['pid'] as String;
    quantity = item['quantity'] as int;
    size = item['size'] as String;

    firestore.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
      notifyListeners();
    });
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String productId;
  int quantity;
  String size;
  String id;

  Product product;

  ItemSize get itemSize {
    if (product == null) return null;
    return product.findSize(size);
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  bool get hasStock {
    final size = itemSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }
}
