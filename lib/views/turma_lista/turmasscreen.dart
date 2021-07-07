import 'package:amesaadm/common/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/turmasmanager.dart';
import 'package:amesaadm/views/turma_lista/componentes/turma_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/views/questionariomanager/componentes/pesquisa.dart';
import 'package:amesaadm/models/user_manager.dart';

class TurmasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<TurmaManager>(
          builder: (_, turmaManager, __) {
            if (turmaManager.search.isEmpty) {
              return const Text('Turmas');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) => PesquisaDialogo(turmaManager.search));
                      if (search != null) {
                        turmaManager.search = search;
                      }
                    },
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                          turmaManager.search,
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
          Consumer<TurmaManager>(
            builder: (_, turmaManager, __) {
              if (turmaManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) => PesquisaDialogo(turmaManager.search));
                    if (search != null) {
                      turmaManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    turmaManager.search = '';
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
                      '/edit_turma',
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
      body: Consumer<TurmaManager>(
        builder: (_, turmaManager, __) {
          final filteredTurmas = turmaManager.filteredProducts;
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredTurmas.length,
              itemBuilder: (_, index) {
                return TurmaListTile(filteredTurmas[index]);
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
