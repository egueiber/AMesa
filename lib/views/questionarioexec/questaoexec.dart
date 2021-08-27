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
                Container(
                  //color: color,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    questionario.questoes[0].descricao,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                ),
                Wrap(
                  //spacing: 8,
                  //runSpacing: 8,
                  children: questionario.questoes[0].alternativas.map((a) {
                    return AlternativaWidgetExec(
                        a, questionario, questionario.questoes[0]);
                  }).toList(),
                ),
              ],
            )));
  }
}
