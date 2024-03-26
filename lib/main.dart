import 'package:flutter/material.dart';
import './Title.dart';

void main() {
  runApp(const GoodHelpers());
}

class _HomePage extends State<GoodHelpers> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Perguntas'),
        ),
        body: const Column(
          children: <Widget>[Text('dale')],
        ),
      ),
    );
  }
}

class GoodHelpers extends StatefulWidget {
  const GoodHelpers({super.key});

  @override
  _HomePage createState() {
    return _HomePage();
  }
}
