// ignore_for_file: prefer_const_constructors

import 'package:admin/qrcode/qrcode.dart';
import 'package:admin/screens/basehome.dart';
import 'package:admin/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class addlec extends StatefulWidget {
  addlec({Key? key}) : super(key: key);
  @override
  State<addlec> createState() => _editState();
}

class _editState extends State<addlec> {
  final formkey = GlobalKey<FormState>();
  Lecture lecture = new Lecture();
  bool isloading = true;
  String? email = FirebaseAuth.instance.currentUser!.email;
  String? _currentSelectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    // width: MediaQuery.of(context).size.width * 0.7,
                    color: Colors.white70,
                    // child: Card(
                    //   child: MyStatefulWidget(),
                    // ),

                    child: TextFormField(
                      onChanged: (ValueKey) {
                        setState(() {
                          lecture.subject = ValueKey;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Subject',
                        hintText: 'Enter Subject',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    // width: MediaQuery.of(context).size.width * 0.7,
                    // child: Card(
                    //   child: MyStatefulWidget(),
                    // ),
                    child: TextFormField(
                      onChanged: (ValueKey) {
                        setState(() {
                          lecture.sem = ValueKey;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Semester',
                        hintText: 'Enter Semester',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    onChanged: (ValueKey) {
                      setState(() {
                        lecture.time = ValueKey;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Lecture Time',
                      hintText: 'Enter Time of Lecture in HH:MM formate',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        UpdateMe(
                          sub: lecture.subject,
                          time: lecture.time,
                          sem: lecture.sem,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TicketPage(
                                    lecture: lecture,
                                  )),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> UpdateMe({
    String? sub,
    String? sem,
    String? time,
  }) async {
    DateTime now = new DateTime.now();
    await FirebaseFirestore.instance
        .collection('admin')
        .doc(email)
        .collection('lecture')
        .doc(now.day.toString() +
            ":" +
            now.month.toString() +
            ":" +
            now.year.toString() +
            ":" +
            now.hour.toString() +
            ":" +
            lecture.sem! +
            ":" +
            lecture.subject!)
        .set(
      {
        'Email': email,
        'Subject': sub,
        'Semester': sem,
        'Date': now.day.toString() +
            ":" +
            now.month.toString() +
            ":" +
            now.year.toString(),
        'Time': time,
        'Key': now.hour.toString()
      },
    );
    isloading = false;
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isError = true;
  String dropdownValue = 'One';
  String? email = FirebaseAuth.instance.currentUser!.email;
  List<Subject> subject = [];
  @override
  void initState() {
    getsubject()
        .then((value) => {
              setState(() {
                subject = value;
                isLoading = false;
              })
            })
        .onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      setState(() {
        isError = true;
      });
      throw error!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Future<List<Subject>> getsubject() async {
    List<Subject> events = [];
    final snapShot = await FirebaseFirestore.instance
        .collection('admin')
        .doc(email)
        .collection('subject')
        .get();
    for (final doc in snapShot.docs) {
      events.add(Subject.fromDocumentsubject(doc));
    }
    return events;
  }
}
