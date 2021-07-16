import 'package:flutter/material.dart';
import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/common/custom_icon_button.dart';
import 'package:amesaadm/views/questionario/edit/componentes/alternativaform.dart';

class EditQuestao extends StatelessWidget {
  EditQuestao(
      {Key key,
      this.questao,
      this.indice,
      this.onRemove,
      this.onMoveUp,
      this.onMoveDown})
      : super(key: key);

  final Questao questao;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final int indice;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 30,
        shadowColor: Colors.yellow[200],
        color: Colors.yellow[170],
        margin: const EdgeInsets.only(top: 10, left: 8),
        child: Wrap(children: <Widget>[
          Row(children: <Widget>[
            SizedBox(
              width: 20,
              child: Text(indice.toString() + '. '),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                autofocus: true,
                minLines: 1,
                maxLines: 4,
                initialValue: questao.descricao,
                decoration: const InputDecoration(
                  labelText: 'Descrição item',
                  isDense: true,
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                validator: (descricao) {
                  if (descricao.isEmpty) return 'Inválido';
                  return null;
                },
                onChanged: (descricao) => questao.descricao = descricao,
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
            ),
          ]),
          AlternativaForm(questao),
        ]));
  }
}
