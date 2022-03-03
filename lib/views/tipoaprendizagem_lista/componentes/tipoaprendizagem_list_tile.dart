import 'package:flutter/material.dart';
import 'package:amesaadm/models/tipoaprendizagem.dart';

class TipoAprendizagemListTile extends StatelessWidget {
  const TipoAprendizagemListTile(this.tipoAprendizagem);

  final TipoAprendizagem tipoAprendizagem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/edit_tipoaprendizagem', arguments: tipoAprendizagem);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalDirection: VerticalDirection.up,
                  children: <Widget>[
                    Text(
                      'Descrição: ' + tipoAprendizagem.descricao,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Situação: ' +
                          (tipoAprendizagem.ativo ? 'Ativo' : 'Inativo'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
