import 'package:flutter/material.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/models/questionariomanager.dart';
import 'package:amesaadm/views/questionario/edit/componentes/images_questionario.dart';
import 'package:amesaadm/views/questionario/edit/componentes/questaoform.dart';
import 'package:provider/provider.dart';

class EditQuestionarioScreen extends StatelessWidget {
  EditQuestionarioScreen(Questionario p)
      : editing = p != null,
        questionario = p != null ? p.clone() : Questionario();

  final Questionario questionario;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: questionario,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Atividade' : 'Criar Atividade'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            reverse: false,
            // reverse: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  'Imagem Atividade',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // images form estava aqui e o método on save não funcionava
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ImagesForm(questionario),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Título',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: questionario.titulo,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        //border: InputBorder.none,
                      ),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      validator: (titulo) {
                        if (titulo.length < 6) return 'Título muito curto';
                        return null;
                      },
                      onSaved: (titulo) => questionario.titulo = titulo,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: questionario.descricao,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        //border: InputBorder.none
                      ),
                      maxLines: null,
                      validator: (desc) {
                        if (desc.length < 8) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (desc) => questionario.descricao = desc,
                    ),
                    Consumer<Questionario>(builder: (_, questionario, __) {
                      return (CheckboxListTile(
                        title: Text("Ativo", textAlign: TextAlign.left),
                        // key: Key('questionarioativo'),
                        value: questionario.ativo,
                        onChanged: (valor) {
                          questionario.qAtivo = valor;
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ));
                    }),
                    QuestaoForm(questionario),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Questionario>(
                      builder: (_, questionario, __) {
                        return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: !questionario.loading
                                ? () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      await questionario.save();

                                      context
                                          .read<QuestionarioManager>()
                                          .update(questionario);

                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                primary: primaryColor, // background
                                onPrimary: Colors.white),
                            child: questionario.loading
                                ? CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : const Text(
                                    'Salvar',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                          ),
                        );
                      },
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
