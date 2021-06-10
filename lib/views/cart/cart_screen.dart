import 'package:flutter/material.dart';
import 'package:amesaadm/models/cart_manager.dart';
import 'package:amesaadm/views/cart/components/cart_tile.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/common/price_card.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items
                    .map((cartProduct) => CartTile(cartProduct))
                    .toList(),
              ),
              PriceCard(
                buttonText: 'Continuar para Entrega',
                onPressed: cartManager.isCartValid ? () {} : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
