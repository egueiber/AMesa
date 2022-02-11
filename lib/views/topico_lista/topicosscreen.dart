import 'package:amesaadm/common/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/topicosmanager.dart';
import 'package:amesaadm/views/topico_lista/componentes/topico_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/views/questionariomanager/componentes/pesquisa.dart';
import 'package:amesaadm/models/user_manager.dart';

class TopicosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<TopicosManager>(
          builder: (_, topicosManager, __) {
            if (topicosManager.search.isEmpty) {
              return const Text('Topicos');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) =>
                              PesquisaDialogo(topicosManager.search));
                      if (search != null) {
                        topicosManager.search = search;
                      }
                    },
                    child: Container(
                        width: constraints.biggest.width,
                        child: Text(
                          topicosManager.search,
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
          Consumer<TopicosManager>(
            builder: (_, topicosManager, __) {
              if (topicosManager.search.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) => PesquisaDialogo(topicosManager.search));
                    if (search != null) {
                      topicosManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    topicosManager.search = '';
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
                      '/edit_topico',
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
      body: Consumer<TopicosManager>(
        builder: (_, topicosManager, __) {
          final filteredTopicos = topicosManager.filteredProducts;
          return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: filteredTopicos.length,
              itemBuilder: (_, index) {
                return TopicoListTile(filteredTopicos[index]);
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
