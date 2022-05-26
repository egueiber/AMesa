import 'package:flutter/material.dart';
import 'package:amesaadm/models/aluno.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/models/avaliacoesmanager.dart';
import 'package:intl/intl.dart';

class AlunoAvaliacaoPercursoScreen extends StatelessWidget {
  const AlunoAvaliacaoPercursoScreen(this.aluno);

  final Aluno aluno;

  @override
  Widget build(BuildContext context) {
    //final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: aluno,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Percurso: ' + aluno.nome),
          centerTitle: true,
          actions: <Widget>[
            Consumer2<UserManager, AvaliacoesManager>(
              builder: (_, userManager, avaliacoesManager, __) {
                if (userManager.adminEnabled) {
                  return IconButton(
                    icon: Icon(Icons.email),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/edit_aluno',
                          arguments: aluno);
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Consumer<AvaliacoesManager>(builder: (_, avaliacaoManager, __) {
          final avaliacoesAluno =
              avaliacaoManager.getAcertosAlunoAtividadePeriodoTrilha(
                  aluno.nome, aluno.email, DateTime.now(), DateTime.now());
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: avaliacoesAluno.length,
              itemBuilder: (_, index) {
                return Card(
                    shadowColor: Colors.green,
                    elevation: 10,
                    margin: const EdgeInsets.only(top: 10, left: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              verticalDirection: VerticalDirection.up,
                              children: <Widget>[
                            Text('Acertos: ' +
                                    avaliacoesAluno[index].totalAcertos ??
                                ' '),
                            Text(
                                'Erros: ' + avaliacoesAluno[index].totalErros ??
                                    ' '),
                            Text('Data Execução: ' +
                                    DateFormat('dd/MM/yyyy HH:mm:ss').format(
                                        avaliacoesAluno[index].dataExecucao) ??
                                ' '),
                            Text(avaliacoesAluno[index].titulo ?? ' '),
                          ]))
                    ]));
              });
        }),
      ),
    );
  }
}
