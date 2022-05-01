import 'package:admin/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profilepage extends StatefulWidget {
  profilepage({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  student userdata = new student();
  fetchDetails() async {
    setNameDetails();
    setState(() {
      isloading = false;
    });
  }

  Future<void> setNameDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    final snapShot = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.email)
        .get()
        .then((snapShot) {
      final data = snapShot.data();
      if (data != null) {
        userdata.name = data['Name'] ?? "";
        userdata.email = data['email'] ?? "";
        userdata.department = data['Department'] ?? "";
        userdata.number = data['Enrollment'] ?? "";
        userdata.phone = data['Phone'] ?? "";
        userdata.blood = data['blood'] ?? "";
        userdata.location = data['location'] ?? "";
        userdata.dob = data['Dob'] ?? "";
      }
    });
  }

  void initState() {
    fetchDetails();
    super.initState();
  }

  bool isloading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: Column(
                children: <Widget>[
                  // const CircleAvatar(
                  //   radius: 50,
                  //   // backgroundImage: AssetImage('assets/avatar.jpg'),
                  //   backgroundImage: NetworkImage(
                  //       'https://firebasestorage.googleapis.com/v0/b/hackathon-86123.appspot.com/o/Images%2FDevloper%2Fjinayshah.jpeg?alt=media&token=789aa394-baaa-49ad-b220-b70845d5b27f'),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      userdata.name.toString(),
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Pacifico",
                      ),
                    ),
                  ),
                  Text(
                    userdata.department.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blueGrey[200],
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Source Sans Pro"),
                  ),
                  const SizedBox(
                    height: 20,
                    width: 200,
                    child: Divider(
                      color: Colors.white,
                    ),
                  ),

                  // we will be creating a new widget name info carrd

                  InfoCard(
                      text: userdata.number.toString(),
                      icon: Icons.trip_origin,
                      onPressed: () async {}),
                  InfoCard(
                      text: userdata.dob.toString(),
                      icon: Icons.date_range,
                      onPressed: () async {}),
                  InfoCard(
                      text: userdata.blood.toString(),
                      icon: Icons.bloodtype,
                      onPressed: () async {}),
                  InfoCard(
                      text: userdata.phone.toString(),
                      icon: Icons.phone,
                      onPressed: () async {}),
                  InfoCard(
                      text: userdata.email.toString(),
                      icon: Icons.email,
                      onPressed: () async {}),
                  InfoCard(
                      text: userdata.location.toString(),
                      icon: Icons.location_city,
                      onPressed: () async {}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard(
      {Key? key,
      required this.text,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.blueAccent,
          ),
          title: InkWell(
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                  fontFamily: "Source Sans Pro"),
            ),
          ),
        ),
      ),
    );
  }
}
