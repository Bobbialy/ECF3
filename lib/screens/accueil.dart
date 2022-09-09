import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../screens/calendar.dart';
import '../screens/login.dart';

class MyResultPage extends StatefulWidget {
  const MyResultPage({super.key});

  @override
  State<MyResultPage> createState() => _MyResultPageState();
}

class _MyResultPageState extends State<MyResultPage> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Accueil',
      style: optionStyle,
    ),
    Text(
      'Index 1: Cryo',
      style: optionStyle,
    ),
    Text(
      'Index 2: Profil',
      style: optionStyle,
    ),
    Text(
      'Index 3: Réglages',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final Widget _myHome = const MyCal();
  final Widget _cryo = const Cryo();
  final Widget _myProfile = const MyProfile();
  final Widget _mySettings = const MySettings();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Accueil'),
        centerTitle: true,
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white38,
        iconSize: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit),
            label: 'Cryo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Réglages',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget getBody() {
    if(_selectedIndex == 0) {
      return _myHome;
    } else if (_selectedIndex == 1) {
      return _cryo;
    } else if (_selectedIndex == 2) {
      return _myProfile;
    } else {
      return _mySettings;
    }
  }
}

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Center(
      child: TableCalendar(
        locale: 'fr_FR',
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),

      ),
    );
  }
}

class Cryo extends StatelessWidget {
  const Cryo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Cryo'),
    );
  }
}

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profil'),
    );
  }
}

class MySettings extends StatelessWidget {
  const MySettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        color: Colors.blue,
        width: double.infinity,
        child: const Text('Réglages'),
      ),
    );
  }
}