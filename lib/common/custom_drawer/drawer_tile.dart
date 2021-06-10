import 'package:flutter/material.dart';
import 'package:amesaadm/models/page_manager.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(this.iconData, this.titulo, this.page);
  final IconData iconData;
  final String titulo;
  final int page;
  @override
  Widget build(BuildContext context) {
    final int curpage = context.watch<PageManager>().page;
    final Color primaryColor = Theme.of(context).primaryColor;
    return InkWell(
        onTap: () {
          context.read<PageManager>().setPage(page);
        },
        child: SizedBox(
            height: 60,
            child: Row(
              children: <Widget>[
                const SizedBox(width: 32),
                Icon(iconData,
                    size: 32,
                    color: curpage == page ? Colors.red : Colors.grey[700]),
                const SizedBox(width: 32),
                Text(
                  titulo,
                  style: TextStyle(
                      fontSize: 16,
                      // color: curpage == page ? Colors.red : Colors.grey[700]),
                      color: curpage == page ? primaryColor : Colors.grey[700]),
                )
              ],
            )));
  }
}
