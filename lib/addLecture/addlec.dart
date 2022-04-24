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
                // Padding(
                //   padding: EdgeInsets.all(20),
                //   child: TextFormField(
                //     onChanged: (ValueKey) {
                //       setState(() {
                //         uservalue.name = ValueKey;
                //       });
                //     },
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: 'Name',
                //       hintText: 'Enter Full Name',
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.all(20),
                //   child: TextFormField(
                //     onChanged: (ValueKey) {
                //       setState(() {
                //         uservalue.dob = ValueKey;
                //       });
                //     },
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: 'Date of Birth',
                //       hintText: 'Enter DOB in dd/mm/yyyy formate',
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.all(20),
                //   child: TextFormField(
                //     onChanged: (ValueKey) {
                //       setState(() {
                //         uservalue.blood = ValueKey;
                //       });
                //     },
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: 'Blood Group',
                //       hintText: 'Enter Blood Group',
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.all(20),
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
                Padding(
                  padding: EdgeInsets.all(20),
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
                // Padding(
                //   padding: EdgeInsets.all(20),
                //   child: TextFormField(
                //     onChanged: (ValueKey) {
                //       setState(() {
                //         uservalue.department = ValueKey;
                //       });
                //     },
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: 'Department',
                //       hintText: 'Enter Department',
                //     ),
                //   ),
                // ),

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
      },
    );
    isloading = false;
  }
}
