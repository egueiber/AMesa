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

        /* decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 3.0, color: Colors.lightBlue.shade900),
            // bottom: BorderSide(width: 3.0, color: Colors.lightBlue.shade900),
          ),
        ),*/
        /*shape: StadiumBorder(
          side: BorderSide.none,
          /* (
            color: Colors.black,
            width: 2.0,
          ),*/
        ),*/

        child: Row(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
              child: Text(
                alternativa.ordem.toStringAsFixed(0),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              //color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                alternativa.descricao,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
