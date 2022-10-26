import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_content.dart';

class ContentList extends StatefulWidget {
  const ContentList({super.key, required this.title});
  final String title;

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selected = DateTime.now();
  Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('goodthing')
      .orderBy('date')
      .startAt([Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))])
      .endAt([Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: 1)))])
      .snapshots();
  int? _index;
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _selected = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(children: [
          TableCalendar(
            firstDay: DateTime.utc(2022, 4, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            selectedDayPredicate: (day) {
              return isSameDay(_selected, day);
            },
            onDaySelected: (selected, focused) {
              if (!isSameDay(_selected, selected)) {
                setState(() {
                  _selected = selected;
                  _focusedDay = focused;
                  _usersStream = FirebaseFirestore.instance
                      .collection('goodthing')
                      .orderBy('date')
                      .startAt([Timestamp.fromDate(_selected)])
                      .endAt([Timestamp.fromDate(_selected.add(Duration(days: 1,minutes: -1)))])
                      .snapshots();
                });
              }
            },
            focusedDay: _focusedDay,
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              defaultDecoration: const BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              weekendDecoration: const BoxDecoration(
                shape: BoxShape.rectangle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.pinkAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              todayDecoration: BoxDecoration(
                color: Colors.pinkAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    key: Key(data['id']),
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const <Widget>[
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      )
                    ),
                    child: ListTile(
                        leading: const Icon(Icons.favorite),
                        title: Text(data['content']),
                        selected: _index == data['id'],
                        onTap: () {
                          _index = data['id'];
                        }
                    ),
                    confirmDismiss: (direction) async {
                      final bool res = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text("Are you sure you want to delete?"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ],
                            );
                          });
                        return res;
                        },
                    onDismissed: (DismissDirection direction) {
                      // TODO: Delete the item from DB
                    },
                  );
                }).toList(),
              );
            },
          ),
          Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(30),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddContent(_selected)),
                  );
                },
                child: const Icon(
                  Icons.add,
                ),
              )),
        ])
    );
  }
}