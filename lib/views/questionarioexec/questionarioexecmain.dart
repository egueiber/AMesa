//import 'package:amesaadm/models/turmasalunos.dart';
import 'package:amesaadm/helpers/msgtextovoz.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/questionario.dart';
//import 'package:amesaadm/models/user_manager.dart';
import 'package:provider/provider.dart';
//import 'edit/componentes/questaowidget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuestionarioScreenExecMain extends StatelessWidget {
  const QuestionarioScreenExecMain(this.questionario);

  final Questionario questionario;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    questionario.tentativas();
    String msgbt = questionario.ativo
        ? (questionario.qtdetentativas + 1 - questionario.nrtentativa)
                .toString() +
            ' tentativas restantes'
        : ' Não há mais tentativas restantes';
    if (!questionario.usarvideos ?? false)
      /*  setStartHandler(
          questionario.titulo + ' e ' + questionario.descricao + ' ' + msgbt,
          0.3); */
      setStartHandler(
          questionario.titulo + ' e ' + questionario.descricao, 0.3);

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
            (questionario.usarvideos)
                ? Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: YoutubePlayer(
                      controller: YoutubePlayerController(
                          initialVideoId: YoutubePlayer.convertUrlToId(
                              questionario.youtubeLink),
                          flags: YoutubePlayerFlags(
                            autoPlay: true,
                          )),
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blue,
                      progressColors: ProgressBarColors(
                          playedColor: Colors.blue,
                          handleColor: Colors.blueAccent),
                    ),
                  )
                : /* Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Imagem Atividade',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),*/
                //  SizedBox(

                AspectRatio(
                    aspectRatio: 3,
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
                      onImageTap: (index) {
                        Navigator.of(context).pushNamed('/questaoformexec',
                            arguments: questionario);
                      },
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
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 20),
                          backgroundColor: Colors.blueGrey,
                          elevation: 5,
                          shadowColor: Colors.yellow),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/questaoformexec',
                            arguments: questionario);
                      },
                      label: Text(questionario.ativo
                          ? 'Participar'
                          : 'Verificar respostas'),
                      icon: const Icon(Icons.arrow_forward),
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
                  /* Text(questionario.ativo
                      ? (questionario.qtdetentativas +
                                  1 -
                                  questionario.nrtentativa)
                              .toString() +
                          ' tentativas restantes'
                      : ' Não há mais tentativas restantes'), */
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
