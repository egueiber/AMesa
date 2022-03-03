import 'package:flutter/material.dart';
import 'package:amesaadm/models/tipoaprendizagem.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:provider/provider.dart';
//import 'edit/componentes/questaowidget.dart';

class TipoAprendizagemScreen extends StatelessWidget {
  const TipoAprendizagemScreen(this.tipoaprendizagem);

  final TipoAprendizagem tipoaprendizagem;

  @override
  Widget build(BuildContext context) {
    //final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: tipoaprendizagem,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tipoaprendizagem.descricao),
          centerTitle: true,
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/edit_tipoaprendizagem',
                          arguments: tipoaprendizagem);
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
                      'Descrição',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    tipoaprendizagem.descricao,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    tipoaprendizagem.ativo ? 'Ativo' : 'Inativo',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
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
