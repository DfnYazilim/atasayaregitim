import 'package:atasayaregitim/Helper/Token.dart';
import 'package:atasayaregitim/Models/ItemTypes.dart';
import 'package:atasayaregitim/Screens/FirstScreen.dart';
import 'package:atasayaregitim/Screens/ThirdScreen.dart';
import 'package:flutter/material.dart';

import 'SecondScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int mainScreenSelectedTab = 0;
  final _pageOptions = [
    FirstScreen(),
    SecondScreen(),
    ThirdScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("APM"),
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_horiz),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Logout")
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            onChanged: (itemIde) {
              if (itemIde == 'logout') {
                Token.deleteToken();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: _pageOptions[mainScreenSelectedTab],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.red,
        currentIndex: mainScreenSelectedTab,
        onTap: (int index) {
          setState(() {
            mainScreenSelectedTab = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("qwe"),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.audiotrack), title: Text("2")),
          BottomNavigationBarItem(
              icon: Icon(Icons.mode_edit), title: Text("3")),
        ],
      ),
    );
  }
}
