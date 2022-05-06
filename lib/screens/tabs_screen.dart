import 'package:besty_apps/screens/account/account_screen.dart';
import 'package:besty_apps/screens/activity/activity_screen.dart';
import 'package:besty_apps/screens/home/homepage_screen.dart';
import 'package:besty_apps/screens/posting/add_posting.dart';
import 'package:besty_apps/screens/search/search_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List _pages = [];
  @override
  void initState() {
    _pages = [
      HomePage(),
      SearchScreen(),
      AddPosting(),
      ActivityScreen(),
      AccountScreen()
    ];
    super.initState();
  }

  int _selectedPage = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        items: [
          Icon(Icons.home, size: 30, color: Color(0xFFea4a49)),
          Icon(Icons.search, size: 30, color: Color(0xFFea4a49)),
          Icon(Icons.add, size: 30, color: Color(0xFFea4a49)),
          ImageIcon(
            AssetImage('assets/images/activity.png'),
            color: Color(0xFFea4a49),
          ),
          ImageIcon(
            AssetImage('assets/images/user.png'),
            color: Color(0xFFea4a49),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
      body: _pages[_selectedPage] as Widget,
    );
  }
}
