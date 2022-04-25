import 'package:flutter/material.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:amesaadm/models/questionariomanager.dart';
import 'package:amesaadm/models/topicosmanager.dart';
import 'package:amesaadm/models/tipoaprendizagemmanager.dart';
import 'package:amesaadm/views/questionario/edit/componentes/images_questionario.dart';
import 'package:amesaadm/views/questionario/edit/componentes/questaoform.dart';
import 'package:provider/provider.dart';

class EditQuestionarioScreen extends StatelessWidget {
  EditQuestionarioScreen(Questionario p)
      : editing = p != null,
        questionario = p != null ? p.clone() : Questionario();

  final Questionario questionario;
  final bool editing;
  //final List<String> aprendizagemTipos = ["E-R","Associação Verbal","Cadeia"];

  final utube =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");

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
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Tópico',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Consumer<TopicosManager>(builder: (_, topicomanager, __) {
                      return (DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text('Escolha um tópico'),
                          value: questionario.topico == ''
                              ? 'nd'
                              : questionario.topico,
                          items: topicomanager.allTopicos.map((dynamic val) {
                            return DropdownMenuItem<dynamic>(
                              value: val.descricao,
                              child: new Text(
                                val.descricao,
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            questionario.topico = newValue;
                            questionario.qAtivo = true;
                          },
                          onSaved: (value) => questionario.topico = value));
                    }),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Tipos Aprendizagem',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Consumer<TipoAprendizagemManager>(
                        builder: (_, tipoaprendizagemmanager, __) {
                      return (DropdownButtonFormField(
                          hint: Text('Escolha um tipo aprendizagem'),
                          value: questionario.tipoaprendizagem == ''
                              ? 'nd'
                              : questionario.tipoaprendizagem,
                          items: tipoaprendizagemmanager.allTipoAprendizagem
                              .map((dynamic val) {
                            return DropdownMenuItem<dynamic>(
                              value: val.descricao,
                              child: new Text(
                                val.descricao,
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            questionario.tipoaprendizagem = newValue;
                            questionario.qAtivo = true;
                          },
                          onSaved: (value) =>
                              questionario.tipoaprendizagem = value));
                    }),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Tópico subjacente',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Consumer<TopicosManager>(
                        builder: (_, topicomanagerant, __) {
                      return (DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text('Escolha o tópico subjacente'),
                          value: questionario.topicoanterior == ""
                              ? 'nd'
                              : questionario.topicoanterior,
                          items: topicomanagerant.allTopicos.map((dynamic val) {
                            return DropdownMenuItem<dynamic>(
                              value: val.descricao,
                              child: new Text(
                                val.descricao,
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            questionario.topicoanterior = newValue;
                            questionario.qAtivo = true;
                          },
                          onSaved: (value) =>
                              questionario.topicoanterior = value));
                    }),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Qtde tentativas para responder',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: questionario.qtdetentativas?.toString(),
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Qtde de tentativas',
                        //border: InputBorder.none
                      ),
                      keyboardType: TextInputType.number,
                      validator: (qtde) {
                        if (int.tryParse(qtde) == null)
                          return 'Numero inválido';
                        if (int.tryParse(qtde) < 1)
                          return 'Informe uma qtde maior ou igual a um!';
                        return null;
                      },
                      onSaved: (qtde) =>
                          questionario.qtdetentativas = int.parse(qtde),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Qtde erros implica em refazer atividade',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: questionario.nrerrosrefazer?.toString(),
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText:
                            'Qtde erros implica em refazer esta atividade. Digite 0 quando não for o caso!',
                        //border: InputBorder.none
                      ),
                      keyboardType: TextInputType.number,
                      validator: (nrerros) {
                        if (int.tryParse(nrerros) == null)
                          return 'Numero inválido';
                        if (int.tryParse(nrerros) < 0)
                          return 'Informe uma qtde maior ou igual a zero!';
                        return null;
                      },
                      onSaved: (nrerros) =>
                          questionario.nrerrosrefazer = int.parse(nrerros),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Qtde erros implica refazer atividade subjacente',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue:
                          questionario.nrerrosativanterior?.toString(),
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText:
                            'Qtde erros implica em refazer a atividade subjacente. Digite 0 quando não for o caso!',
                        //border: InputBorder.none
                      ),
                      keyboardType: TextInputType.number,
                      validator: (nrerrossub) {
                        if (int.tryParse(nrerrossub) == null)
                          return 'Numero inválido';
                        if (int.tryParse(nrerrossub) < 0)
                          return 'Informe uma qtde maior ou igual a zero!';
                        return null;
                      },
                      onSaved: (nrerrossub) => questionario
                          .nrerrosativanterior = int.parse(nrerrossub),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Atividade subjacente',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Consumer<QuestionarioManager>(
                        builder: (_, questionariomanager, __) {
                      return (DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text('Escolha a atividade subjacente'),
                          value: questionario.atividadesubjacente == ''
                              ? 'nd'
                              : questionario.atividadesubjacente,
                          items: questionariomanager.allQuestionarios
                              .map((dynamic val) {
                            return DropdownMenuItem<dynamic>(
                              value: val.titulo,
                              child: new Text(
                                val.titulo,
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            questionario.atividadesubjacente = newValue;
                            questionario.qAtivo = true;
                          },
                          onSaved: (value) =>
                              questionario.atividadesubjacente = value));
                    }),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Atividade posterior',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Consumer<QuestionarioManager>(
                        builder: (_, questionariomanager, __) {
                      return (DropdownButtonFormField(
                          isExpanded: true,
                          hint: Text('Escolha a atividade posterior'),
                          value: questionario.atividadeposterior == ''
                              ? 'nd'
                              : questionario.atividadeposterior,
                          items: questionariomanager.allQuestionarios
                              .map((dynamic val) {
                            return DropdownMenuItem<dynamic>(
                              value: val.titulo,
                              child: new Text(
                                val.titulo,
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            questionario.atividadeposterior = newValue;
                            questionario.qAtivo = true;
                          },
                          onSaved: (value) =>
                              questionario.atividadeposterior = value));
                    }),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Link Video Youtube',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextFormField(
                      initialValue: questionario.youtubeLink,
                      decoration: const InputDecoration(
                        hintText: 'Informe o link do video YouTube',
                        //border: InputBorder.none,
                      ),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      validator: (youtubeLink) {
                        if (youtubeLink.length < 3) return 'link inválido';

                        /*if (!utube.hasMatch(youtubeLink)) {
                          return 'Link inválido';
                        }*/
                        return null;
                      },
                      onSaved: (youtubeLink) =>
                          questionario.youtubeLink = youtubeLink,
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
                    Consumer<Questionario>(builder: (_, questionario, __) {
                      return (CheckboxListTile(
                        title: Text("Gamificar", textAlign: TextAlign.left),
                        // key: Key('questionarioativo'),
                        value: questionario.gamificar,
                        onChanged: (valor) {
                          questionario.qGamificar = valor;
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ));
                    }),
                    Consumer<Questionario>(builder: (_, questionario, __) {
                      return (CheckboxListTile(
                        title: Text("Usar vídeos", textAlign: TextAlign.left),
                        // key: Key('questionarioativo'),
                        value: questionario.usarvideos,
                        onChanged: (valor) {
                          questionario.qUsarvideos = valor;
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
