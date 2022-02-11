//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/topico.dart';
import 'package:amesaadm/models/topicosmanager.dart';
import 'package:provider/provider.dart';
//import 'dart:convert';

class EditTopicoScreen extends StatelessWidget {
  EditTopicoScreen(Topico p)
      : editing = p != null,
        topico = p != null ? p.clone() : Topico();

  final Topico topico;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: topico,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Topico' : 'Criar Topico'),
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
                        'Objetivo',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: topico.objetivo,
                      decoration: const InputDecoration(
                        hintText: 'Objetivo do Topico',
                        //border: InputBorder.none,
                      ),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      validator: (objetivo) {
                        if (objetivo.length < 3) return 'Objetivo muito curto';
                        return null;
                      },
                      onSaved: (objetivo) => topico.objetivo = objetivo,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Topico',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: topico.descricao,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'descricao',
                        //border: InputBorder.none
                      ),
                      maxLines: null,
                      validator: (descricao) {
                        if (descricao.length < 1)
                          return 'Descrição muito curta';
                        return null;
                      },
                      onSaved: (descricao) => topico.descricao = descricao,
                    ),
                    Consumer<Topico>(builder: (_, turma, __) {
                      return (CheckboxListTile(
                        title: Text("Ativo", textAlign: TextAlign.left),
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
                    Consumer<Topico>(
                      builder: (_, topico, __) {
                        return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: !topico.loading
                                ? () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      await topico.save();

                                      context
                                          .read<TopicosManager>()
                                          .update(topico);

                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                primary: primaryColor, // background
                                onPrimary: Colors.white),
                            child: topico.loading
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
