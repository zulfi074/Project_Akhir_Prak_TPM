import 'package:flutter/material.dart';
import 'package:final_project/views/PageEvents.dart';
import 'package:final_project/views/ProfilePage.dart';

class MainPage extends StatefulWidget {
  final VoidCallback signOut;

  const MainPage({super.key, required this.signOut});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    PageEvents(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _showFeedbackDialog();
    } else if (index == 3) {
      widget.signOut();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kesan dan Pesan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Kesan: Selama pembelajaran cukup membuat kita untuk menggali potensi diri lebih dalam lagi.'),
              SizedBox(height: 10),
              Text('Pesan: Tetap semangat dalam membimbing mahasiswa.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
    );
  }
}
