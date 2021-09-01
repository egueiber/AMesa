import 'package:amesaadm/helpers/msgtextovoz.dart';
import 'package:amesaadm/views/questionarioexec/alternativawidgetexec.dart';
import 'package:flutter/material.dart';
//import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:provider/provider.dart';

class QuestaoFormExec extends StatelessWidget {
  QuestaoFormExec(this.questionario);
  final Questionario questionario;
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    //final primaryColor = Theme.of(context).primaryColor;
    // setStartHandler(questionario.titulo + ' e ' + questionario.descricao, 0.3);
    questionario.questaocorrente = 0;
    /*  setStartHandler(
        questionario.questoes[questionario.questaocorrente].descricao, 0.3);
 */
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
            body: Consumer<Questionario>(builder: (_, questionario, __) {
              final bool respondida = questionario
                  .questoes[questionario.questaocorrente].respondida;
              final int corr = questionario.questaocorrente;
              final int qtde = questionario.questoes.length;
              msgbt = fmsgBt(respondida, corr, qtde);
              if (respondida) {
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
                  Container(
                    //color: color,

                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      questionario
                          .questoes[questionario.questaocorrente].descricao,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
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
                          questionario.questoes[corr].exportRespostaList();
                        } else if (msgbt == 'Continuar') {
                          if (questionario.questaocorrente + 1 <
                              questionario.questoes.length) {
                            questionario.questaocorrente++;
                          }
                        } else {
                          //confirmar
                          if (!questionario.questoes[corr].corrigir(
                              questionario.emailUsuario,
                              questionario.nrtentativa + 1)) {
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
      if (corr + 1 >= qtde)
        msg = 'Finalizar';
      else
        msg = 'Continuar';
    } else {
      msg = 'Confirmar';
    }
    return msg;
  }
}
