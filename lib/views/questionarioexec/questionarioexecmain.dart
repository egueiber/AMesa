//import 'package:amesaadm/models/turmasalunos.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/questionario.dart';
//import 'package:amesaadm/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
//import 'edit/componentes/questaowidget.dart';

class QuestionarioScreenExecMain extends StatelessWidget {
  const QuestionarioScreenExecMain(this.questionario);

  final Questionario questionario;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    // setStartHandler(questionario.titulo);
    // setStartHandler(questionario.descricao);

    return ChangeNotifierProvider.value(
      value: questionario,
      child: Scaffold(
        appBar: AppBar(
          title: Text(questionario.titulo),
          centerTitle: true,
          actions: <Widget>[],
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
                      'Itens',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  /* Wrap(
                    //spacing: 8,
                    //runSpacing: 8,
                    children: questionario.questoes.map((q) {
                      return QuestaoWidget(questao: q);
                    }).toList(),
                  ),*/
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

Future<void> setStartHandler(String msg) async {
  //var flutterTts = FlutterTts();
  //var result = await flutterTts.speak(msg);
}
