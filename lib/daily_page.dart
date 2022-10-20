import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class DailyPage extends StatelessWidget {
  DailyPage(this.date);
  DateTime date;
  String? taskName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Stack(children: [
        TextField(
          maxLength: 8,
          decoration: InputDecoration(
            labelText: 'Task',
            hintText: '入力してください',
            icon: Icon(Icons.done),
          ),
          autofocus: true,
          onChanged: (value) {
            taskName = value;
          },
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(30),
          child: FloatingActionButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('goodthing')
                  .doc()
                  .set({
                'content': taskName,
                'date': Timestamp.fromDate(date)
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
            child: const Icon(
              Icons.done,
            ),
          )
        ),
      ],),
    );
  }
}