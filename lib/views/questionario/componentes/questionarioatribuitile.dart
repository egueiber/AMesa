import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/models/questionarioturmamanager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:amesaadm/models/aluno.dart';

class QuestionarioAtribuiTile extends StatelessWidget {
  const QuestionarioAtribuiTile(
      this.turmaaluno, this.questionario, this.questionarioturmamanager);

  final String turmaaluno;
  final Questionario questionario;
  final QuestionarioTurmaManager questionarioturmamanager;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        questionario.addQuestionarioTurma(
            turmaaluno.substring(0, turmaaluno.indexOf(':')));
        Future.delayed(const Duration(seconds: 3), () {
          questionarioturmamanager.recarregar();
        });

        //Navigator.of(context).pushNamed('/aluno', arguments: turmaaluno);
      },
      child: Consumer<Questionario>(builder: (_, questionario, __) {
        final bool turmaassociada = (questionario.findQuestionarioTurma(
                turmaaluno.substring(0, turmaaluno.indexOf(':'))) !=
            null);
        return Card(
          color: turmaassociada ? Colors.green : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        turmaaluno,
                        style: TextStyle(
                          fontSize: 16,
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
      }),
    );
  }
}
