import 'package:amesaadm/common/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/tipoaprendizagemmanager.dart';
import 'package:amesaadm/views/tipoaprendizagem_lista/componentes/tipoaprendizagem_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/views/questionariomanager/componentes/pesquisa.dart';
import 'package:amesaadm/models/user_manager.dart';

class TiposAprendizagemsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<TipoAprendizagemManager>(
          builder: (_, tiposaprendizagemsManager, __) {
            if (tiposaprendizagemsManager.search.isEmpty) {
              return const Text('Tipos Aprendizagem');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) => PesquisaDialogo(
                              tiposaprendizagemsManager.search));
                      if (search != null) {
                        tiposaprendizagemsManager.search = search;
                      }
                    },
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                          tiposaprendizagemsManager.search,
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
          Consumer<TipoAprendizagemManager>(
            builder: (_, tiposaprendizagemsManager, __) {
              if (tiposaprendizagemsManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) =>
                            PesquisaDialogo(tiposaprendizagemsManager.search));
                    if (search != null) {
                      tiposaprendizagemsManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    tiposaprendizagemsManager.search = '';
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
                      '/edit_tiposaprendizagem',
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
      body: Consumer<TipoAprendizagemManager>(
        builder: (_, tiposaprendizagemsManager, __) {
          final filteredTiposAprendizagems =
              tiposaprendizagemsManager.filteredTipoAprendizagem;
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredTiposAprendizagems.length,
              itemBuilder: (_, index) {
                return TipoAprendizagemListTile(
                    filteredTiposAprendizagems[index]);
              });
        },
      ),
    );
  }
}
