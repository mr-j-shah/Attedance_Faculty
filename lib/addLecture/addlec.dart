import 'package:admin/qrcode/qrcode.dart';
import 'package:admin/screens/basehome.dart';
import 'package:admin/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

class addlec extends StatefulWidget {
  addlec({Key? key}) : super(key: key);
  @override
  State<addlec> createState() => _editState();
}

TimeOfDay initialTime = new TimeOfDay(hour: 00, minute: 00);

class _editState extends State<addlec> {
  final formkey = GlobalKey<FormState>();
  Lecture lecture = new Lecture();
  bool isloading = true;
  String? email = FirebaseAuth.instance.currentUser!.email;
  String? _currentSelectedValue;
  String dropdownvalue = '1';
  List<String> items = ['1', '2', '3', '4', '5', '6', '7', '8'];
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
                    color: Colors.white70,
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
                    child: Column(
                      children: [
                        DropdownButton(
                          value: dropdownvalue,
                          hint: Text('Select Semester'),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              lecture.sem = newValue;
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                        Text('*click on time to set Semster')
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                      child: Center(
                          child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Starting Time  :  ',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: initialTime,
                              );
                              if (pickedTime == null) {
                                pickedTime = initialTime;
                              }
                              print(pickedTime.toString());
                              setState(() {
                                initialTime = pickedTime!;
                              });
                            },
                            child: Text(
                              initialTime.hour.toString() +
                                  ' : ' +
                                  initialTime.minute.toString(),
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Pacifico",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text('*click on time to set')
                    ],
                  ))),
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
                        if (lecture.subject != null &&
                            lecture.sem != null &&
                            lecture.time != '0 : 0') {
                          UpdateMe(
                              sub: lecture.subject,
                              sem: lecture.sem,
                              time: lecture.time);
                          setState(() {
                            initialTime = TimeOfDay(hour: 0, minute: 0);
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TicketPage(
                                      lecture: lecture,
                                    )),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Aleart!'),
                              content: Text('Please select value'),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok'))
                              ],
                            ),
                          );
                        }
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
        'Time':
            initialTime.hour.toString() + ':' + initialTime.minute.toString(),
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
