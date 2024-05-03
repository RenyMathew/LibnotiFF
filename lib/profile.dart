import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  final String loggedInEmail;

  const Profile({Key? key, required this.loggedInEmail}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int indexNum = 2;
  DateTime _lastBackButtonPressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ignore: unnecessary_null_comparison
        if (_lastBackButtonPressTime == null ||
            DateTime.now().difference(_lastBackButtonPressTime) >
                Duration(seconds: 2)) {
          _lastBackButtonPressTime = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xff99baff),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'SignOut'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          iconSize: 20,
          unselectedFontSize: 10,
          selectedFontSize: 12,
          showSelectedLabels: true,
          selectedItemColor: Colors.indigo,
          currentIndex: indexNum,
          onTap: (int index) {
            if (index == 0) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Login()));
            } else if (index == 1) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) =>
                      HomePage(loggedInEmail: widget.loggedInEmail)));
            }
            setState(() {
              indexNum = index;
            });
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
              color: Colors.white,
              height: 60,
              width: 500,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, top: 7),
                child: Text(
                  "Profile",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to fetch data from Firestore
  Future<DocumentSnapshot> fetchData() async {
    return FirebaseFirestore.instance
        .collection('entries')
        .doc(widget.loggedInEmail)
        .get();
  }
}
