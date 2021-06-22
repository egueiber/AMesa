import 'package:flutter/material.dart';
import 'package:amesaadm/models/alternativa.dart';
import 'package:amesaadm/common/custom_icon_button.dart';

class EditAlternativa extends StatelessWidget {
  const EditAlternativa(
      {Key key,
      this.alternativa,
      this.onRemove,
      this.onMoveUp,
      this.onMoveDown})
      : super(key: key);

  final Alternativa alternativa;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(top: 10, left: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 10,
              child: TextFormField(
                initialValue: alternativa.descricao,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  isDense: true,
                ),
                validator: (descricao) {
                  if (descricao.isEmpty) return 'Inválido';
                  return null;
                },
                onChanged: (descricao) => alternativa.descricao = descricao,
              ),
            ),
            /*const SizedBox(
          width: 4,
        ),*/
            Expanded(
              flex: 4,
              child: TextFormField(
                textAlign: TextAlign.right,
                initialValue: alternativa.pontuacao?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Pontuação',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                validator: (pontuacao) {
                  if (int.tryParse(pontuacao) == null) return 'Inválido';
                  return null;
                },
                onChanged: (pontuacao) =>
                    alternativa.pontuacao = int.tryParse(pontuacao),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            CustomIconButton(
              iconData: Icons.remove,
              color: Colors.red,
              onTap: onRemove,
            ),
            CustomIconButton(
              iconData: Icons.arrow_drop_up,
              color: Colors.black,
              onTap: onMoveUp,
            ),
            CustomIconButton(
              iconData: Icons.arrow_drop_down,
              color: Colors.black,
              onTap: onMoveDown,
            )
          ],
        ));
  }
}
