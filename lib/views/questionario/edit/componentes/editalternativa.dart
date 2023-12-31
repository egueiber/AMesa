import 'package:amesaadm/views/questionario/edit/componentes/images_alternativa.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/alternativa.dart';
import 'package:amesaadm/common/custom_icon_button.dart';
import 'package:provider/provider.dart';

class EditAlternativa extends StatelessWidget {
  EditAlternativa(
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
    return ChangeNotifierProvider.value(
        value: alternativa,
        child: Card(
            margin: const EdgeInsets.only(top: 10, left: 4),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                    child: Row(children: <Widget>[
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
                ])),
                Container(
                  child: TextFormField(
                    autofocus: true,
                    initialValue: alternativa.descricao,
                    decoration: const InputDecoration(
                        labelText: 'Descrição alternativa:',
                        isDense: true,
                        labelStyle: TextStyle(fontSize: 18)),
                    validator: (descricao) {
                      if (descricao.isEmpty) return 'Inválido';
                      return null;
                    },
                    onChanged: (descricao) => alternativa.descricao = descricao,
                  ),
                ),
                Container(
                  //flex: 4,
                  child: TextFormField(
                    textAlign: TextAlign.left,
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
                Container(
                  alignment: Alignment.centerLeft,
                  child: Consumer<Alternativa>(builder: (_, alternativa, __) {
                    return (CheckboxListTile(
                      // autofocus: true,
                      title: Text("Correto", textAlign: TextAlign.left),
                      // key: Key('questionarioativo'),
                      value: alternativa.correta,
                      onChanged: (valor) {
                        alternativa.qCorreta = valor;
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ));
                  }),
                ),
                const SizedBox(
                  width: 4,
                ),
                Wrap(children: <Widget>[ImagesAlternativa(alternativa)]),
              ],
            )));
  }
}
