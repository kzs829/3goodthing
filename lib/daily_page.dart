import 'package:flutter/material.dart';

class DailyPage extends StatelessWidget {
  DailyPage(this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Column(
        children: [
          Center(
           child: Text(name),
          )
        ],
      ),
    );
  }
}