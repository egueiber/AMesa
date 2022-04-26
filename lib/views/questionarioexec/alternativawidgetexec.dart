import 'package:amesaadm/helpers/msgtextovoz.dart';
import 'package:amesaadm/models/questao.dart';
import 'package:amesaadm/models/questionario.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/alternativa.dart';
import 'package:provider/provider.dart';

class AlternativaWidgetExec extends StatelessWidget {
  const AlternativaWidgetExec(
      this.alternativa, this.questionario, this.questao);
  final Alternativa alternativa;
  final Questionario questionario;
  final Questao questao;

  @override
  Widget build(BuildContext context) {
    //final selected = questao == questionario.selectedQuestao;

    //Color color;
    // color = Colors.black;
    String texto = '';
    if ((!questao.lido) && (questao.youtubeLink == null)) {
      setStartHandler(questao.descricao, 0.3);
      questao.lido = true;
    }
    return GestureDetector(onTap: () {
      if ((questao.respondida) || (!questionario.ativo)) {
        setStartHandler(
            'Você já respondeu esta questão! Veja o resultado!', 0.3);
      } else {
        alternativa.selecionada = !alternativa.selecionada;
        //questionario.exportQuestaoList();
        questionario.refresh();
        if (alternativa.selecionada) {
          texto = 'Você marcou a opção ';
          alternativa.addResposta(questionario.idUsuario, questionario.id,
              questionario.emailUsuario, questionario.nrtentativa);
        } else {
          texto = 'Você desmarcou a opção ';
          alternativa.removeResposta(
              questionario.idUsuario, questionario.nrtentativa);
        }
        setStartHandler(texto + alternativa.descricao, 0.3);
      }
    }, child: Consumer<Questionario>(builder: (_, questionario, __) {
      final bool selecionada = alternativa.selecionada;

      return Card(
        color: selecionada
            ? ((questao.respondida)
                ? (alternativa.respostaCorreta
                    ? Colors.green[100]
                    : Color.fromARGB(255, 233, 224, 225))
                : Colors.yellow[100])
            : ((questao.respondida)
                ? (alternativa.correta ? Colors.green[50] : Colors.white)
                : Colors.white),
        clipBehavior: Clip.none,
        borderOnForeground: false,
        elevation: 10,
        shadowColor: selecionada
            ? ((questao.respondida)
                ? (alternativa.respostaCorreta
                    ? Color.fromRGBO(76, 175, 80, 1)
                    : Colors.red[200])
                : Color.fromRGBO(255, 245, 157, 1))
            : ((questao.respondida)
                ? (alternativa.correta ? Colors.green[100] : Colors.white)
                : Colors.grey[200]),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              AspectRatio(
                  aspectRatio: 2,
                  child: selecionada
                      ? ((questao.respondida)
                          ? (alternativa.respostaCorreta
                              ? Image.network(alternativa.images.first,
                                  color: Color.fromRGBO(188, 236, 190, 1),
                                  colorBlendMode: BlendMode.modulate)
                              : Image.network(alternativa.images.first,
                                  color: Color.fromARGB(255, 233, 224, 225),
                                  colorBlendMode: BlendMode.modulate))
                          : ((questao.respondida)
                              ? (alternativa.correta
                                  ? Image.network(alternativa.images.first,
                                      color: Color.fromRGBO(188, 236, 190, 1),
                                      colorBlendMode: BlendMode.modulate)
                                  : Image.network(alternativa.images.first))
                              : Image.network(alternativa.images.first,
                                  color: Color.fromRGBO(255, 245, 157, 1),
                                  colorBlendMode: BlendMode.modulate)))
                      : ((questao.respondida)
                          ? (alternativa.correta
                              ? Image.network(alternativa.images.first,
                                  color: Color.fromRGBO(188, 236, 190, 1),
                                  colorBlendMode: BlendMode.modulate)
                              : Image.network(alternativa.images.first,
                                  color: Colors.white,
                                  colorBlendMode: BlendMode.modulate))
                          : Image.network(alternativa.images.first))),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      alternativa.descricao,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: selecionada
                            ? ((questao.respondida)
                                ? (alternativa.respostaCorreta
                                    ? Colors.black
                                    : Color.fromARGB(227, 201, 199, 199))
                                : Colors.black)
                            : ((questao.respondida)
                                ? (alternativa.correta
                                    ? Colors.black
                                    : Color.fromARGB(227, 201, 199, 199))
                                : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }
}
