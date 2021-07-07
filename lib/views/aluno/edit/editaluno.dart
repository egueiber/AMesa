import 'package:amesaadm/helpers/validators.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/aluno.dart';
import 'package:amesaadm/models/alunosmanager.dart';
import 'package:provider/provider.dart';
import 'package:amesaadm/models/turmasmanager.dart';

class EditAlunoScreen extends StatelessWidget {
  EditAlunoScreen(Aluno p)
      : editing = p != null,
        aluno = p != null ? p.clone() : Aluno();

  final Aluno aluno;
  final bool editing;
  String siglasel;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: aluno,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Aluno' : 'Criar Aluno'),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Nome',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: aluno.nome,
                      decoration: const InputDecoration(
                        hintText: 'Nome completo',
                        //border: InputBorder.none,
                      ),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      validator: (nome) {
                        if (nome.length < 4) return 'Nome muito curto';
                        return null;
                      },
                      onSaved: (nome) => aluno.nome = nome,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'E-mail',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      autocorrect: false,
                      initialValue: aluno.email,
                      style: const TextStyle(fontSize: 16),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'e-mail',
                        //border: InputBorder.none
                      ),
                      maxLines: null,
                      validator: (email) {
                        if (!emailValid(email)) return 'E-mail inválido!';
                        return null;
                      },
                      onSaved: (email) => aluno.email = email,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Turma',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Consumer<TurmaManager>(builder: (_, turmasmanager, __) {
                      return (DropdownButtonFormField(
                          hint: Text('Escolha uma turma'),
                          value: aluno.turma == '' ? 'S1TB21' : aluno.turma,
                          items: turmasmanager.allTurmas.map((dynamic val) {
                            return DropdownMenuItem<dynamic>(
                              value: val.sigla,
                              child: new Text(
                                val.sigla,
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            aluno.turma = newValue;
                            aluno.qAtivo = true;
                          },
                          onSaved: (value) => aluno.turma = value));
                    }),
                    Consumer<Aluno>(builder: (_, aluno, __) {
                      return (CheckboxListTile(
                        title: Text("Ativo", textAlign: TextAlign.left),
                        // key: Key('questionarioativo'),
                        value: aluno.ativo,
                        onChanged: (valor) {
                          aluno.qAtivo = valor;
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ));
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Aluno>(
                      builder: (_, aluno, __) {
                        return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: !aluno.loading
                                ? () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      await aluno.save();

                                      context
                                          .read<AlunoManager>()
                                          .update(aluno);

                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                primary: primaryColor, // background
                                onPrimary: Colors.white),
                            child: aluno.loading
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
