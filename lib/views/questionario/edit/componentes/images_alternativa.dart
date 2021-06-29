import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amesaadm/models/alternativa.dart';
import 'package:amesaadm/views/questionario/edit/componentes/images_source_sheet_alt.dart';

class ImagesAlternativa extends StatelessWidget {
  const ImagesAlternativa(this.alternativa);

  final Alternativa alternativa;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(alternativa.images),
      validator: (images) {
        if (images.isEmpty) return 'Insira ao menos uma imagem';
        return null;
      },
      onSaved: (images) => alternativa.newImages = images,
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Wrap(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 3,
              child: Carousel(
                images: state.value.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.loose,
                    children: <Widget>[
                      if (image is String)
                        Image.network(
                          image,
                          fit: BoxFit.contain,
                        )
                      else
                        Image.file(
                          image as File,
                          fit: BoxFit.cover,
                        ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(Icons.remove_circle),
                          color: Colors.red,
                          onPressed: () {
                            state.value.remove(image);
                            state.didChange(state.value);
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.add_circle),
                          color: Colors.blue,
                          onPressed: () {
                            if (Platform.isAndroid)
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) => ImageSourceSheetAlt(
                                        onImageSelected: onImageSelected,
                                      ));
                            else
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (_) => ImageSourceSheetAlt(
                                        onImageSelected: onImageSelected,
                                      ));
                          },
                        ),
                      ),
                    ],
                  );
                }).toList()
                  ..add(Material(
                    color: Colors.grey[100],
                    child: IconButton(
                      alignment: Alignment.topRight,
                      icon: Icon(Icons.add_a_photo),
                      color: Theme.of(context).primaryColor,
                      iconSize: 50,
                      onPressed: () {
                        if (Platform.isAndroid)
                          showModalBottomSheet(
                              context: context,
                              builder: (_) => ImageSourceSheetAlt(
                                    onImageSelected: onImageSelected,
                                  ));
                        else
                          showCupertinoModalPopup(
                              context: context,
                              builder: (_) => ImageSourceSheetAlt(
                                    onImageSelected: onImageSelected,
                                  ));
                      },
                    ),
                  )),
                dotSize: 5,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: Theme.of(context).primaryColor,
                autoplay: false,
              ),
            ),
            if (state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16),
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
        );
      },
    );
  }
}
