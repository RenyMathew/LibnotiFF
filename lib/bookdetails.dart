import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'profile.dart';

class BookDetails extends StatefulWidget {
  final Map<String, String> book;
  final String loggedInEmail;

  const BookDetails({Key? key, required this.book, required this.loggedInEmail})
      : super(key: key);

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  int indexNum = 1;
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
            } else if (index == 2) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) =>
                      Profile(loggedInEmail: widget.loggedInEmail)));
            }
            setState(() {
              indexNum = index;
            });
          },
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  color: Colors.white,
                  height: 60,
                  width: 500,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40, top: 7),
                    child: Text(
                      "Book Details",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Container(
                  height: 430,
                  width: 300,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              'Assets/book.png',
                              height: 150,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${widget.book['name'] ?? 'Noname'}',
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Author: ${widget.book['author'] ?? 'Unknown'}',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Taken Date: ${widget.book['takenDate'] ?? 'Unknown'}',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Return Date: ${widget.book['returnDate'] ?? 'Unknown'}',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Unique Id: ${widget.book['uniqueId'] ?? 'Unknown'}',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Fine: ${widget.book['fine'] ?? 'No Fines'}',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
