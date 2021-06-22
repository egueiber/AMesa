import 'package:flutter/material.dart';
import 'package:amesaadm/models/alternativa.dart';
import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/views/questionario/edit/componentes/editalternativa.dart';
import 'package:amesaadm/common/custom_icon_button.dart';

class AlternativaForm extends StatelessWidget {
  const AlternativaForm(this.questao);

  final Questao questao;

  @override
  Widget build(BuildContext context) {
    return FormField<List<Alternativa>>(
      initialValue: questao.alternativas,
      validator: (alternativas) {
        if (alternativas.isEmpty) return 'Insira ao menos uma alterantiva!';
        return null;
      },
      builder: (state) {
        return Card(
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.blueGrey, width: 2.0),
                borderRadius: BorderRadius.circular(4.0)),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Alternativas',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    CustomIconButton(
                      iconData: Icons.add,
                      color: Colors.black,
                      onTap: () {
                        state.value.add(Alternativa());
                        state.didChange(state.value);
                      },
                    )
                  ],
                ),
                Wrap(
                  children: state.value.map((alternativa) {
                    return EditAlternativa(
                      key: ObjectKey(alternativa),
                      alternativa: alternativa,
                      onRemove: () {
                        state.value.remove(alternativa);
                        state.didChange(state.value);
                      },
                      onMoveUp: alternativa != state.value.first
                          ? () {
                              final index = state.value.indexOf(alternativa);
                              state.value.remove(alternativa);
                              state.value.insert(index - 1, alternativa);
                              state.didChange(state.value);
                            }
                          : null,
                      onMoveDown: alternativa != state.value.last
                          ? () {
                              final index = state.value.indexOf(alternativa);
                              state.value.remove(alternativa);
                              state.value.insert(index + 1, alternativa);
                              state.didChange(state.value);
                            }
                          : null,
                    );
                  }).toList(),
                ),
                if (state.hasError)
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      state.errorText,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  )
              ],
            )); //
      },
    );
  }
}
