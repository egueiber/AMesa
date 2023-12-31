import 'package:flutter/material.dart';
import 'package:amesaadm/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/models/page_manager.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 180,
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('A MESA',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text(
                'Bem vindo  ${userManager.user?.name ?? ''}',
                // ' ${userManager.isLoggedIn ? 'Bem vindo,' + userManager.user.name ? : ''}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (userManager.isLoggedIn) {
                    context.read<PageManager>().setPage(0);
                    userManager.signOut();
                  } else {
                    Navigator.of(context).pushNamed('/login');
                  }
                },
                child: Text(
                  userManager.isLoggedIn ? 'Sair' : 'Entre ou Cadastre-se',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
