import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'content_list.dart';

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
              final goodthing = FirebaseFirestore.instance
                  .collection('goodthing')
                  .doc();

              goodthing.set({
                'content': content,
                'date': Timestamp.fromDate(date),
                'id': goodthing.id
              });

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContentList(title: 'Flutter Demo',)),
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