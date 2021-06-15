import 'package:flutter/material.dart';
import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:provider/provider.dart';

class QuestaoWidget extends StatelessWidget {
  const QuestaoWidget({this.questao});
  final Questao questao;

  @override
  Widget build(BuildContext context) {
    final product = context.watch<Questionario>();
    //final selected = questao == questionario.selectedQuestao;

    Color color;
    color = Colors.red.withAlpha(50);
    return GestureDetector(
      onTap: () {
        product.selectedQuestao = questao;
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                questao.descricao,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                questao.numero.toStringAsFixed(0),
                style: TextStyle(
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
