import 'package:flutter/material.dart';
import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:provider/provider.dart';

class QuestaoWidget extends StatelessWidget {
  const QuestaoWidget({this.questao});
  final Questao questao;

  @override
  Widget build(BuildContext context) {
    final questionario = context.watch<Questionario>();
    //final selected = questao == questionario.selectedQuestao;

    Color color;
    color = Colors.black;
    return GestureDetector(
      onTap: () {
        questionario.selectedQuestao = questao;
      },
      child: Card(
        /* decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 3.0, color: Colors.lightBlue.shade900),
            // bottom: BorderSide(width: 3.0, color: Colors.lightBlue.shade900),
          ),
        ),*/
        shape: StadiumBorder(
          side: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                questao.numero.toStringAsFixed(0),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              //color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                questao.descricao,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
