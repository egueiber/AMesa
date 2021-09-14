import 'package:amesaadm/helpers/msgtextovoz.dart';
import 'package:amesaadm/models/questionarioturmamanager.dart';
import 'package:amesaadm/views/questionarioexec/questionariolisttileexec.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/common/custom_drawer/custom_drawer.dart';
import 'package:amesaadm/models/home_manager.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/models/user_manager.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: const [
              Color.fromARGB(175, 211, 118, 130),
              Color.fromARGB(175, 253, 181, 168)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                snap: true,
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('AMESA'),
                  centerTitle: true,
                ),
                actions: <Widget>[
                  /* IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  ), */
                  Consumer2<UserManager, HomeManager>(
                    builder: (_, userManager, homeManager, __) {
                      if (userManager.adminEnabled && !homeManager.loading) {
                        if (homeManager.editing) {
                          return PopupMenuButton(
                            onSelected: (e) {
                              if (e == 'Salvar') {
                                homeManager.saveEditing();
                              } else {
                                homeManager.discardEditing();
                              }
                            },
                            itemBuilder: (_) {
                              return ['Salvar', 'Descartar'].map((e) {
                                return PopupMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList();
                            },
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.voice_chat_sharp),
                            onPressed: () => setStartHandler(
                                'Escolha uma atividade para executar!', 0.3),
                          );
                        }
                      } else
                        return Container();
                    },
                  ),
                ],
              ),
              Consumer2<QuestionarioTurmaManager, UserManager>(
                  builder: (_, questionarioTurmaManager, usermanager, __) {
                List<Widget> children;
                if (questionarioTurmaManager == null) {
                  return SliverToBoxAdapter(
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      backgroundColor: Colors.transparent,
                    ),
                  );
                } else {
                  if (questionarioTurmaManager.items.isNotEmpty) {
                    children = [];

                    questionarioTurmaManager.items.forEach((tm) {
                      tm.emailUsuario = usermanager.user.email;
                      tm.idUsuario = usermanager.user.id;
                      children.add(QuestionarioListTileExec(tm));
                    });
                  } else {
                    children = {Text('Carregando..')}.toList();
                  }
                  return SliverList(
                      delegate: SliverChildListDelegate(children));
                }
              })
            ],
          ),
        ],
      ),
    );
  }
}
