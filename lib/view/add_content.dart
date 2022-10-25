import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class AddContent extends StatelessWidget {
  AddContent(this.date, {super.key});
  final DateTime date;
  String? content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      body: Stack(children: [
        TextField(
          maxLength: 8,
          decoration: const InputDecoration(
            labelText: 'Task',
            hintText: '入力してください',
            icon: Icon(Icons.done),
          ),
          autofocus: true,
          onChanged: (value) {
            content = value;
          },
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.all(30),
          child: FloatingActionButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('goodthing')
                  .doc()
                  .set({
                'content': content,
                'date': Timestamp.fromDate(date)
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
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