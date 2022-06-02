import 'package:amesaadm/common/custom_drawer/custom_drawer.dart';
import 'package:amesaadm/models/avaliacoesmanager.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/alunosmanager.dart';
import 'package:amesaadm/views/aluno_lista/componentes/aluno_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/views/questionariomanager/componentes/pesquisa.dart';
import 'package:amesaadm/models/user_manager.dart';

import '../../models/exportacaminho.dart';

class AlunosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<AlunoManager>(
          builder: (_, alunoManager, __) {
            if (alunoManager.search.isEmpty) {
              return const Text('Alunos');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) => PesquisaDialogo(alunoManager.search));
                      if (search != null) {
                        alunoManager.search = search;
                      }
                    },
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                          alunoManager.search,
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
          Consumer<AlunoManager>(
            builder: (_, alunoManager, __) {
              if (alunoManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) => PesquisaDialogo(alunoManager.search));
                    if (search != null) {
                      alunoManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    alunoManager.search = '';
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
                      '/edit_aluno',
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          Consumer3<UserManager, AvaliacoesManager, AlunoManager>(
            builder: (_, userManager, avaliacoesManager, alunoManager, __) {
              if (userManager.adminEnabled) {
                return IconButton(
                  icon: Icon(Icons.cloud_upload),
                  onPressed: () {
                    final avaliacoesAluno = avaliacoesManager
                        .getAllAtividadePeriodoTrilha(alunoManager.allAlunos);
                    if (avaliacoesAluno.isNotEmpty) {
                      ExportaCaminho(avaliacoesAluno);
                    }
                    return Container();
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Consumer<AlunoManager>(
        builder: (_, alunoManager, __) {
          final filteredAlunos = alunoManager.filteredAlunos;
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredAlunos.length,
              itemBuilder: (_, index) {
                return AlunoListTile(filteredAlunos[index]);
              });
        },
      ),
      /*  floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: Icon(Icons.shopping_cart),
      ), */
    );
  }
}
