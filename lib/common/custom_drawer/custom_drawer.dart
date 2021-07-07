import 'package:flutter/material.dart';
import 'package:amesaadm/common/custom_drawer/drawer_tile.dart';
import 'package:amesaadm/common/custom_drawer_header.dart';
//import 'package:provider/provider.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 203, 236, 241),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              DrawerTile(Icons.home, 'Inicio', 0),
              DrawerTile(Icons.list, 'Produtos', 1),
              DrawerTile(Icons.question_answer_sharp, 'Questionários', 2),
              DrawerTile(Icons.person, 'Alunos', 3),
              DrawerTile(Icons.group, 'Turmas', 4),
              Consumer<UserManager>(
                builder: (_, userManager, __) {
                  if (userManager.adminEnabled) {
                    return Column(
                      children: <Widget>[
                        const Divider(),
                        DrawerTile(
                          Icons.settings,
                          'Usuários',
                          4,
                        ),
                        DrawerTile(
                          Icons.settings,
                          'PeTurma',
                          5,
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
