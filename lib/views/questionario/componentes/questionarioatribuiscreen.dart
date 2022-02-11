import 'package:amesaadm/models/turmasalunos.dart';
import 'package:amesaadm/views/questionario/componentes/questionarioatribuitile.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/models/user_manager.dart';
//import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class QuestionarioAtribuiScreen extends StatelessWidget {
  const QuestionarioAtribuiScreen(this.questionario);

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
                  ]);
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
                    questionario.ativo ? 'Ativo' : 'Inativo',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Turmas',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Consumer<TurmasAlunos>(
                    builder: (_, turmasalunos, __) {
                      context.read<TurmasAlunos>();
                      // turmasalunos.filteredAlunosAtivoByTurma;
                      return Wrap(
                        children: turmasalunos.strTurma.map((at) {
                          context.read<TurmasAlunos>();
                          return QuestionarioAtribuiTile(at, questionario);
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
