import 'package:flutter/material.dart';

class Choice {
  const Choice({required this.name, required this.icon, required this.url});
  final String name;
  final IconData icon;
  final String url;
}

const List<Choice> choices = <Choice>[
  Choice(name: "Fehler melden", icon: Icons.bug_report, url: "https://github.com/TheLeCrafter/buw-app/issues"),
  Choice(name: "Source Code", icon: Icons.code, url: "https://github.com/TheLeCrafter/buw-app/issues"),
  Choice(name: "Lizenz", icon: Icons.assignment, url: "https://github.com/TheLeCrafter/buw-app/blob/master/LICENSE")
];