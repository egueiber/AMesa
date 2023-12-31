import 'package:flutter/material.dart';
import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/views/questionario/edit/componentes/alternativawidget.dart';

class QuestaoWidget extends StatelessWidget {
  const QuestaoWidget({this.questao});
  final Questao questao;

  @override
  Widget build(BuildContext context) {
    final questionario = context.watch<Questionario>();
    return GestureDetector(
      onTap: () {
        questionario.selectedQuestao = questao;
      },
      child: Card(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Wrap(
          children: <Widget>[
            Container(
              //color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                questao.descricao,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Wrap(
              //spacing: 8,
              //runSpacing: 8,
              children: questao.alternativas.map((q) {
                return AlternativaWidget(alternativa: q);
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
