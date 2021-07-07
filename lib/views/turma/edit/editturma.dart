//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/turma.dart';
import 'package:amesaadm/models/turmasmanager.dart';
import 'package:provider/provider.dart';
//import 'dart:convert';

class EditTurmaScreen extends StatelessWidget {
  EditTurmaScreen(Turma p)
      : editing = p != null,
        turma = p != null ? p.clone() : Turma();

  final Turma turma;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: turma,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Turma' : 'Criar Turma'),
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
                        'Sigla',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: turma.sigla,
                      decoration: const InputDecoration(
                        hintText: 'Sigla turma',
                        //border: InputBorder.none,
                      ),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      validator: (sigla) {
                        if (sigla.length < 3) return 'Sigla muito curta';
                        return null;
                      },
                      onSaved: (sigla) => turma.sigla = sigla,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Turma',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: turma.descricao,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'descricao',
                        //border: InputBorder.none
                      ),
                      maxLines: null,
                      validator: (turma) {
                        if (turma.length < 1) return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (descricao) => turma.descricao = descricao,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Ano',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      autocorrect: false,
                      initialValue: turma.ano.toString(),
                      style: const TextStyle(fontSize: 16),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Ano da turma',
                        //border: InputBorder.none
                      ),
                      maxLines: null,
                      validator: (ano) {
                        if ((int.parse(ano) < 2020))
                          return 'Ano deve ser maior que 2020!';
                        return null;
                      },
                      onSaved: (ano) => turma.ano = int.parse(ano),
                    ),
                    Consumer<Turma>(builder: (_, turma, __) {
                      return (CheckboxListTile(
                        title: Text("Ativa", textAlign: TextAlign.left),
                        // key: Key('questionarioativo'),
                        value: turma.ativo,
                        onChanged: (valor) {
                          turma.qAtivo = valor;
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ));
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<Turma>(
                      builder: (_, turma, __) {
                        return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: !turma.loading
                                ? () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      await turma.save();

                                      context
                                          .read<TurmaManager>()
                                          .update(turma);

                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                primary: primaryColor, // background
                                onPrimary: Colors.white),
                            child: turma.loading
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
