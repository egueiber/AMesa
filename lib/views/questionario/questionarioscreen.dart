import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:provider/provider.dart';

class QuestionarioScreen extends StatelessWidget {
  const QuestionarioScreen(this.questionario);

  final Questionario questionario;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: questionario,
      child: Scaffold(
        appBar: AppBar(
          title: Text(questionario.descricao),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/edit_questionario',
                          arguments: questionario);
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: questionario.images.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    questionario.titulo,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Título',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    questionario.titulo,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Questões',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  // TODO: verificar se aproveito para as questões
                  /*Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes.map((s) {
                      return SizeWidget(size: s);
                    }).toList(),
                  ),*/
                  const SizedBox(
                    height: 20,
                  ),
                  /*
                  if (product.hasStock)
                    Consumer2<UserManager, Product>(
                      builder: (_, userManager, product, __) {
                        return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: product.selectedSize != null
                                ? () {
                                    if (userManager.isLoggedIn) {
                                      context
                                          .read<CartManager>()
                                          .addToCart(product);
                                      Navigator.of(context).pushNamed('/cart');
                                    } else {
                                      Navigator.of(context).pushNamed('/login');
                                    }
                                  }
                                : null,
                            // color: primaryColor,
                            // textColor: Colors.white,
                            child: Text(
                              userManager.isLoggedIn
                                  ? 'Adicionar ao Carrinho'
                                  : 'Entre para Comprar',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    )*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
