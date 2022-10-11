import 'package:flutter/material.dart';

class DailyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Column(
        children: [
          TextField(
            maxLength: 8,
            decoration: InputDecoration(
              labelText: 'Task',
              hintText: '入力してください',
              icon: Icon(Icons.done),
            ),
            autofocus: true,
          ),
        ],
      ),
    );
  }
}