import 'package:amesaadm/common/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/views/questionariomanager/componentes/questionariolisttile.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/views/questionariomanager/componentes/pesquisa.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:amesaadm/models/questionariomanager.dart';

class QuestionarioPesquisa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<QuestionarioManager>(
          builder: (_, questionarioManager, __) {
            if (questionarioManager.search.isEmpty) {
              return const Text('Atividades');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) =>
                              PesquisaDialogo(questionarioManager.search));
                      if (search != null) {
                        questionarioManager.search = search;
                      }
                    },
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                          questionarioManager.search,
                          textAlign: TextAlign.center,
                        )),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<QuestionarioManager>(
            builder: (_, questionarioManager, __) {
              if (questionarioManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) =>
                            PesquisaDialogo(questionarioManager.search));
                    if (search != null) {
                      questionarioManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    questionarioManager.search = '';
                  },
                );
              }
            },
          ),
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/edit_questionarios',
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      body: Consumer<QuestionarioManager>(
        builder: (_, questionarioManager, __) {
          final filteredQuestionarios =
              questionarioManager.filteredQuestionarios;
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredQuestionarios.length,
              itemBuilder: (_, index) {
                return QuestionarioListTile(filteredQuestionarios[index]);
              });
        },
      ),
      /* floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/atribui');
        },
        child: Icon(Icons.shopping_cart),
      ),*/
    );
  }
}
