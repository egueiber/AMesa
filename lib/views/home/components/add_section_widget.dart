import 'package:flutter/material.dart';
import 'package:amesaadm/models/home_manager.dart';
import 'package:amesaadm/models/section.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget(this.homeManager);

  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'List'));
            },
            //textColor: Colors.white,
            child: const Text('Adicionar Lista'),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              homeManager.addSection(Section(type: 'Staggered'));
            },
            //textColor: Colors.white,
            child: const Text('Adicionar Grade'),
          ),
        ),
      ],
    );
  }
}
