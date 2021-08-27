import 'package:amesaadm/helpers/msgtextovoz.dart';
import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/alternativa.dart';
import 'package:provider/provider.dart';

class AlternativaWidgetExec extends StatelessWidget {
  const AlternativaWidgetExec(
      this.alternativa, this.questionario, this.questao);
  final Alternativa alternativa;
  final Questionario questionario;
  final Questao questao;

  @override
  Widget build(BuildContext context) {
    //final selected = questao == questionario.selectedQuestao;

    //Color color;
    // color = Colors.black;
    String texto = '';
    setStartHandler(questao.descricao, 0.3);
    return GestureDetector(onTap: () {
      alternativa.selecionada = !alternativa.selecionada;
      //questionario.exportQuestaoList();
      questionario.refresh();
      if (alternativa.selecionada)
        texto = 'Você marcou a opção ';
      else
        texto = 'Você desmarcou a opção ';
      setStartHandler(texto + alternativa.descricao, 0.3);
      // alternativa.selecionada = !alternativa.selecionada;
      //(questionario.findQuestionarioTurma(
      //      turmaaluno.substring(0, turmaaluno.indexOf(':'))) !=
      // null);
      //  Navigator.of(context).pop();
      //   .pushNamed('/questionarioexec', arguments: alternativa);
    }, child: Consumer<Questionario>(builder: (_, questionario, __) {
      final bool selecionada = alternativa.selecionada;

      return Card(
        color: selecionada ? Colors.yellow : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 2,
                child: Image.network(alternativa.images.first),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      alternativa.descricao,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }));
  }
}
