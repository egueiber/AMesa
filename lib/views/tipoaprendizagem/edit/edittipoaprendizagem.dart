//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/tipoaprendizagem.dart';
import 'package:amesaadm/models/tipoaprendizagemmanager.dart';
import 'package:provider/provider.dart';
//import 'dart:convert';

class EditTipoAprendizagemScreen extends StatelessWidget {
  EditTipoAprendizagemScreen(TipoAprendizagem p)
      : editing = p != null,
        tipoaprendizagem = p != null ? p.clone() : TipoAprendizagem();

  final TipoAprendizagem tipoaprendizagem;
  final bool editing;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: tipoaprendizagem,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              editing ? 'Editar Tipo Aprendizagem' : 'Criar Tipo Aprendizagem'),
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
                        'Tipo Aprendizagem',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: tipoaprendizagem.descricao,
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
                      onSaved: (descricao) =>
                          tipoaprendizagem.descricao = descricao,
                    ),
                    Consumer<TipoAprendizagem>(builder: (_, turma, __) {
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
                    Consumer<TipoAprendizagem>(
                      builder: (_, tipoaprendizagem, __) {
                        return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: !tipoaprendizagem.loading
                                ? () async {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      await tipoaprendizagem.save();

                                      context
                                          .read<TipoAprendizagemManager>()
                                          .update(tipoaprendizagem);

                                      Navigator.of(context).pop();
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                primary: primaryColor, // background
                                onPrimary: Colors.white),
                            child: tipoaprendizagem.loading
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
