import 'package:amesaadm/views/aluno_lista/alunosscreen.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/page_manager.dart';
//import 'package:amesaadm/views/Login/login_screen.dart';
import 'package:amesaadm/common/custom_drawer/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/views/Products/products_screen.dart';
import 'package:amesaadm/views/home/home_screen.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:amesaadm/views/admin_users/admin_users_screen.dart';
import 'package:amesaadm/views/questionariomanager/questionariopesquisa.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomeScreen(),
              ProductsScreen(),
              QuestionarioPesquisa(),
              AlunosScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home3'),
                ),
              ),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home4'),
                ),
              ),
              if (userManager.adminEnabled) ...[
                AdminUsersScreen(),
                Scaffold(
                  drawer: CustomDrawer(),
                  appBar: AppBar(
                    title: const Text('Pedidos'),
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
