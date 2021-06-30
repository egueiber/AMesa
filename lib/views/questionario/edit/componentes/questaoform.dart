import 'package:flutter/material.dart';
import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/views/questionario/edit/componentes/editquestao.dart';
import 'package:amesaadm/common/custom_icon_button.dart';

class QuestaoForm extends StatelessWidget {
  QuestaoForm(this.questionario);
  final Questionario questionario;
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return FormField<List<Questao>>(
      initialValue: questionario.questoes,
      validator: (questoes) {
        if (questoes.isEmpty) return 'Insira ao menos uma questão!';
        return null;
      },
      builder: (state) {
        return Column(
          children: <Widget>[
            Row(
              // verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Questoes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value.add(Questao());
                    state.didChange(state.value);

                    FocusScopeNode ultimo =
                        node.ancestors.elementAt(node.children.length);
                    ultimo.nextFocus();
                    //node.nextFocus();
                    //Focus.of(context)
                    // FocusScope.of(state.context).nextFocus();
                    // controller.jumpTo(controller.position.maxScrollExtent);
                  },
                )
              ],
            ),
            Wrap(
              children: state.value.map((questao) {
                return Card(
                    //color: Colors.green[170],
                    //elevation: 30,
                    // shadowColor:Colors.yellow[200], //Color.fromARGB(10, 20, 30, 40),

                    child: EditQuestao(
                  key: ObjectKey(questao),
                  questao: questao,
                  onRemove: () {
                    state.value.remove(questao);
                    state.didChange(state.value);
                  },
                  onMoveUp: questao != state.value.first
                      ? () {
                          final index = state.value.indexOf(questao);
                          state.value.remove(questao);
                          state.value.insert(index - 1, questao);
                          state.didChange(state.value);
                        }
                      : null,
                  onMoveDown: questao != state.value.last
                      ? () {
                          final index = state.value.indexOf(questao);
                          state.value.remove(questao);
                          state.value.insert(index + 1, questao);
                          state.didChange(state.value);
                        }
                      : null,
                ));
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
              ),
          ],
        );
      },
    );
  }
}
