import 'package:flutter/material.dart';
import 'package:amesaadm/models/aluno.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/models/avaliacoesmanager.dart';
//import 'edit/componentes/questaowidget.dart';

class AlunoAvaliacaoScreen extends StatelessWidget {
  const AlunoAvaliacaoScreen(this.aluno);

  final Aluno aluno;

  @override
  Widget build(BuildContext context) {
    //final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: aluno,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Avaliação: ' + aluno.nome),
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
              avaliacaoManager.getAcertosAlunoAtividadePeriodo(
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
                            Text(avaliacoesAluno[index].atividadesubjacente ??
                                ' '),
                            Text(avaliacoesAluno[index].mediaAcertos ?? ' '),
                            Text(avaliacoesAluno[index].mediaErros ?? ' '),
                            Text(avaliacoesAluno[index].totalAcertos ?? ' '),
                            Text(avaliacoesAluno[index].totalErros ?? ' '),
                            Text(
                                avaliacoesAluno[index].numerotentativas ?? ' '),
                            Text(avaliacoesAluno[index].titulo ?? ' '),
                          ]))
                    ]));
              });
        }),
      ),
    );
  }
}
