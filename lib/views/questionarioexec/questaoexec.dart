import 'package:amesaadm/helpers/msgtextovoz.dart';
import 'package:amesaadm/models/avaliacoesmanager.dart';
import 'package:amesaadm/views/questionarioexec/alternativawidgetexec.dart';
import 'package:flutter/material.dart';
//import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/models/questionariomanager.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuestaoFormExec extends StatelessWidget {
  QuestaoFormExec(this.questionario);
  final Questionario questionario;
  final QuestionarioManager questionariomanager = QuestionarioManager();
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    //final primaryColor = Theme.of(context).primaryColor;
    questionario.questaocorrente = 0;
    String msgbt;
    return ChangeNotifierProvider.value(
        value: questionario,
        child: Scaffold(
            appBar: AppBar(
              title: Text(questionario.titulo),
              centerTitle: true,
              actions: <Widget>[],
            ),
            backgroundColor: Colors.white,
            body: Consumer2<Questionario, AvaliacoesManager>(
                builder: (_, questionario, avaliacoesmanager, __) {
              final bool respondida = ((questionario
                      .questoes[questionario.questaocorrente].respondida) ||
                  (!questionario.ativo));
              final int corr = questionario.questaocorrente;
              final int qtde = questionario.questoes.length;
              msgbt = fmsgBt(respondida, corr, qtde);
              if ((respondida) &&
                  ((questionario == null) ? false : questionario.gamificar)) {
                String msgvoz;
                String msgponto;

                if (questionario.questoes[corr].pontos > 0) {
                  msgponto = (questionario.questoes[corr].pontos == 1)
                      ? ' ponto'
                      : 'pontos';
                  msgvoz = 'Você conquistou ' +
                      questionario.questoes[corr].pontos.toString() +
                      msgponto;

                  if (questionario.questoes[corr].pontosperdidos > 0) {
                    msgponto = (questionario.questoes[corr].pontosperdidos == 1)
                        ? ' ponto'
                        : 'pontos';
                    msgvoz = msgvoz +
                        ' mas perdeu ' +
                        questionario.questoes[corr].pontosperdidos.toString() +
                        msgponto;
                  }
                  setStartHandler(msgvoz, 0.3);
                } else
                  setStartHandler(
                      'Você não conquistou pontos nesta questão, mas mesmo assim aprendeu!',
                      0.3);
              }

              return ListView(
                children: <Widget>[
                  (questionario.questoes[questionario.questaocorrente]
                              .youtubeLink ==
                          null)
                      ? Container(
                          //color: color,
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Text(
                            questionario.questoes[questionario.questaocorrente]
                                .descricao,
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w600),
                          ),
                        )
                      : Container(
                          height: 180,
                          padding: const EdgeInsets.only(top: 8, bottom: 2),
                          child: YoutubePlayer(
                            controller: YoutubePlayerController(
                                initialVideoId: YoutubePlayer.convertUrlToId(
                                    questionario
                                            .questoes[
                                                questionario.questaocorrente]
                                            .youtubeLink ??
                                        ''),
                                flags: YoutubePlayerFlags(
                                  autoPlay: true,
                                )),
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.blue,
                            progressColors: ProgressBarColors(
                                playedColor: Colors.blue,
                                handleColor: Colors.blueAccent),
                          ),
                        ),
                  Wrap(
                    //spacing: 28,
                    //runSpacing: 8,
                    //spacing: 40,
                    children: questionario
                        .questoes[questionario.questaocorrente].alternativas
                        .map((a) {
                      return AlternativaWidgetExec(a, questionario,
                          questionario.questoes[questionario.questaocorrente]);
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 20),
                          backgroundColor: Colors.blueGrey,
                          elevation: 5,
                          shadowColor: Colors.yellow),
                      onPressed: () {
                        if (msgbt == 'Finalizar') {
                          // questionario.questoes[corr].exportRespostaList();
                          questionario.updateQuestoes();
                          questionario.tentativas();
                          questionariomanager.aprovaVerificaDependencia(
                              questionario, avaliacoesmanager);
                          Navigator.of(context).pushReplacementNamed(
                              '/base_screen',
                              arguments: questionario);
                          //Navigator.of(context).pop();
                        } else if (msgbt == 'Continuar') {
                          if (questionario.questaocorrente + 1 <
                              questionario.questoes.length) {
                            questionario.questaocorrente++;
                          }
                        } else {
                          //confirmar
                          if (!questionario.questoes[corr].corrigir(
                              questionario.idUsuario,
                              questionario.id,
                              questionario.emailUsuario,
                              questionario.nrtentativa)) {
                            setStartHandler(
                                'Escolha pelo menos uma alternativa', 0.3);
                          }
                        }
                        questionario.refresh();
                      },
                      child: Text(msgbt),
                    ),
                  ),
                  Container(
                      //color: color,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Text(
                        'Pontos: ' +
                            questionario.questoes[corr].pontos.toString(),
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color:
                                respondida ? Colors.blueAccent : Colors.white),
                      )),
                  Container(
                      //color: color,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Text(
                        'Pontos Perdidos: ' +
                            questionario.questoes[corr].pontosperdidos
                                .toString(),
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: (respondida &&
                                    questionario.questoes[corr].pontosperdidos >
                                        0)
                                ? Colors.blueAccent
                                : Colors.white),
                      )),
                ],
              );
            })));
  }

  String fmsgBt(bool respondida, int corr, int qtde) {
    String msg = 'Continuar';
    if (respondida) {
      if (corr + 1 >= qtde) {
        msg = 'Finalizar';
      } else
        msg = 'Continuar';
    } else {
      msg = 'Confirmar';
    }
    return msg;
  }
}
