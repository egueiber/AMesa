import 'package:amesaadm/models/turmasalunos.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'edit/componentes/questaowidget.dart';

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
          title: Text(questionario.titulo),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return Row(children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                            '/edit_questionarios',
                            arguments: questionario);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.group_add),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                            '/atribui_questionarios',
                            arguments: questionario);
                      },
                    )
                  ]);
                } else {
                  return Container();
                }
              },
            ),
            Consumer<TurmasAlunos>(
              builder: (_, turmasalunos, __) {
                context.read<TurmasAlunos>();
                turmasalunos.filteredAlunosAtivoByTurma;
                return Container();
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                'Imagem Atividade',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            //  SizedBox(

            AspectRatio(
              aspectRatio: 2,
              child: Carousel(
                images: questionario.images.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
                boxFit: BoxFit.contain,
                borderRadius: true,
                radius: Radius.circular(2),
              ),
            ),
            // ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Título',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    questionario.titulo,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    questionario.descricao,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Ativo',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    questionario.ativo.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Itens',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    //spacing: 8,
                    //runSpacing: 8,
                    children: questionario.questoes.map((q) {
                      return QuestaoWidget(questao: q);
                    }).toList(),
                  ),
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
