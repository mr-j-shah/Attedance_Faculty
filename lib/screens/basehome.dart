import 'package:admin/addLecture/addlec.dart';
import 'package:admin/authentication/signin.dart';
import 'package:admin/screens/aboutus.dart';

import 'package:admin/screens/homepage.dart';
import 'package:admin/screens/profile.dart';
import 'package:admin/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

int currentScreen = 0;
user _userdata = new user();
bool isLoading = false;

class basehome extends StatefulWidget {
  basehome({Key? key}) : super(key: key);

  @override
  State<basehome> createState() => _basehomeState();
}

class _basehomeState extends State<basehome> {
  List<Widget> screen = [
    hoempage(),
    addlec(),
    profilepage(userdata: _userdata)
  ];

  fetchDetails() async {
    setNameDetails();
    setState(() {
      isLoading = false;
    });
  }

  final auth = FirebaseAuth.instance;
  Future<void> setNameDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    final snapShot = FirebaseFirestore.instance
        .collection('admin')
        .doc(user!.email!)
        .get()
        .then((snapShot) {
      final data = snapShot.data();
      if (data != null) {
        _userdata.name = data['Name'] ?? "";
        _userdata.email = data['email'] ?? "";
        _userdata.department = data['Department'] ?? "";
        _userdata.doj = data['Doj'] ?? "";
        _userdata.phone = data['Phone'] ?? "";
        _userdata.blood = data['blood'] ?? "";
        _userdata.location = data['location'] ?? "";
        _userdata.dob = data['Dob'] ?? "";
        // if (_userdata.name != null &&
        //     _userdata.email != null &&
        //     _userdata.department != null &&
        //     _userdata.number != null &&
        //     _userdata.phone != null &&
        //     _userdata.blood != null &&
        //     _userdata.location != null &&
        //     _userdata.dob != null) {
        //   isloading = false;
        // }
      }
    });
  }

  void initState() {
    fetchDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
      ),
      drawer: Drawer(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(0),
            child: DrawerHeader(
                child: Center(
              child: Text(
                "Online Id",
                style: TextStyle(fontSize: 30, color: Colors.black54),
              ),
            )),
          ),
          // Padding(
          //   padding: EdgeInsets.all(20),
          //   child: InkWell(
          //     child: Text('Edit'),
          //     onTap: () {
          //       auth.signOut();
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => edit()),
          //       );
          //     },
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(20),
            child: InkWell(
              child: Text('Devloper'),
              onTap: () {
                auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => aboutus(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: InkWell(
              child: Text('LogOut'),
              onTap: () {
                auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => signin(),
                  ),
                );
              },
            ),
          )
        ]),
      ),
      body: SafeArea(
          child: Column(
        children: [
          isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(child: screen[currentScreen]),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bottomNavigationBar(
                      Icons.qr_code_scanner_sharp, 'QR Scanner', 0),
                  _middelbar(Icons.manage_accounts, 'Edit', 1),
                  _bottomNavigationBar(Icons.home_filled, 'Profile', 2),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _middelbar(IconData icon, String title, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          isLoading = false;
          currentScreen = index;
        });
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
        child: CircleAvatar(
          backgroundColor: Colors.amber,
          child: Icon(
            icon,
            size: 40,
          ),
          radius: 30,
        ),
      ),
    );
  }

  Widget _bottomNavigationBar(IconData icon, String titile, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          isLoading = false;
          currentScreen = index;
        });
      },
      child: Padding(
        padding: index == 0
            ? EdgeInsets.fromLTRB(25, 8, 8, 8)
            : index == screen.length - 1
                ? EdgeInsets.fromLTRB(8, 8, 25, 8)
                : EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            // Text('$titile'),
            Text(titile, style: TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
