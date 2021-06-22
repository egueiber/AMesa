import 'package:flutter/material.dart';
import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/common/custom_icon_button.dart';
import 'package:amesaadm/views/questionario/edit/componentes/alternativaform.dart';

class EditQuestao extends StatelessWidget {
  const EditQuestao(
      {Key key, this.questao, this.onRemove, this.onMoveUp, this.onMoveDown})
      : super(key: key);

  final Questao questao;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Wrap(children: <Widget>[
      Row(children: <Widget>[
        Expanded(
          flex: 1,
          child: TextFormField(
            initialValue: questao.descricao,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              isDense: true,
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
        /*
      Expanded(
        flex: 10,
        child: TextFormField(
          textAlign: TextAlign.right,
          initialValue: questao.numero?.toString(),
          decoration: const InputDecoration(
            labelText: 'Número',
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          validator: (numero) {
            if (int.tryParse(numero) == null) return 'Inválido';
            return null;
          },
          onChanged: (numero) => questao.numero = int.tryParse(numero),
        ),
      ),*/
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

        /*Expanded(
        flex: 10,
        child: AlternativaForm(questao),
      )*/
      ]),
      AlternativaForm(questao),
    ]);
  }
}
