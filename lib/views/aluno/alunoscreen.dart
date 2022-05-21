import 'package:flutter/material.dart';
import 'package:amesaadm/models/aluno.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/models/avaliacoesmanager.dart';
//import 'edit/componentes/questaowidget.dart';

class AlunoScreen extends StatelessWidget {
  const AlunoScreen(this.aluno);

  final Aluno aluno;

  @override
  Widget build(BuildContext context) {
    //final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: aluno,
      child: Scaffold(
        appBar: AppBar(
          title: Text(aluno.nome),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/edit_aluno',
                          arguments: aluno);
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
            Consumer2<UserManager, AvaliacoesManager>(
              builder: (_, userManager, avaliacoesManager, __) {
                if (userManager.adminEnabled) {
                  return IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/alunoavaliacao',
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
        body: ListView(
          children: <Widget>[
            //  SizedBox(

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Nome',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    aluno.nome,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Turma',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    aluno.turma,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'e-mail',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    aluno.email.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
