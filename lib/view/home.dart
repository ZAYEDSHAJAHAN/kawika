import 'package:flutter/material.dart';
import 'package:kawika/view/secondpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _name = '';
  String _username = '';
  String _role = '';
  String _phone = '';
  String _email = '';
  int _currentIndex = 0;

  Future<void> _getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name") ?? "";
      _username = prefs.getString("username") ?? "";
      _role = prefs.getString("role") ?? "";
      _phone = prefs.getString("phone") ?? "";
      _email = prefs.getString("email") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: _appbartitle()),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.paste_sharp),
            label: 'data listing',
          ),
        ],
      ),
    ));
  }

  Widget _appbartitle() {
    switch (_currentIndex) {
      case 0:
        return Text("profile");
      case 1:
        return Text("datalisting");
      default:
        return Text("");
    }
  }

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0:
        return _Profilepage();
      case 1:
        return Datalistingpage();
      default:
        return Container();
    }
  }

  Widget _Profilepage() {
    return ListView(
      children: [
        UserAccountsDrawerHeader(
            accountName: Text(_name),
            accountEmail: Text(_email),
            currentAccountPicture: Image.asset("assets/profilepic.png")),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Name'),
          subtitle: Text(_name),
        ),
        ListTile(
          leading: Icon(Icons.person_outline),
          title: Text('Username'),
          subtitle: Text(_username),
        ),
        ListTile(
          leading: Icon(Icons.work),
          title: Text('Role'),
          subtitle: Text(_role),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('Phone'),
          subtitle: Text(_phone),
        ),
        ListTile(
          leading: Icon(Icons.email),
          title: Text('Email'),
          subtitle: Text(_email),
        ),
      ],
    );
  }
}
