import 'package:flutter/material.dart';
//import 'package:amesaadm/models/questao.dart';
//import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/models/alternativa.dart';
//import 'package:provider/provider.dart';

class AlternativaWidget extends StatelessWidget {
  const AlternativaWidget({this.alternativa});
  final Alternativa alternativa;

  @override
  Widget build(BuildContext context) {
    //final questionarioao = context.watch<Questao>();
    //final selected = questao == questionario.selectedQuestao;

    //Color color;
    // color = Colors.black;
    return GestureDetector(
      onTap: () {
        //questao.selectedAlternativa = alternativa;
      },
      child: Card(
        elevation: 0,
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              //color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                alternativa.descricao,
                style: TextStyle(
                    fontSize: 18,
                    color: alternativa.correta ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
