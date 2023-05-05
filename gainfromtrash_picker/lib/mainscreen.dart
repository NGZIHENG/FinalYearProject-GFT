import 'package:flutter/material.dart';
import 'page/appointmentpage.dart';
import 'page/cashwithdrawalpage.dart';
import 'page/homepage.dart';
import 'picker.dart';
import 'user.dart';

class MainScreen extends StatefulWidget {
  final Picker picker;
  const MainScreen({super.key, required this.picker});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 1;
  List<Widget> screens = [];
  
  @override

  Widget build(BuildContext context) {
    final screens = [
    AppointmentPage(picker: widget.picker),
    HomePage(picker: widget.picker),
    CashWithdrawalPage(picker: widget.picker),
    ];
    return MaterialApp(
      title: 'Gain From Trash',
      home: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green[300],
          iconSize: 30,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items:const [
            BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined, ),
            label: "Pick Up",
            backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.home, ),
            label: "Home",
            backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.money_rounded, ), 
            label: "Cash Withdrawal",
            backgroundColor: Colors.white,
            )
          ],
       ),
     )
   );
  }
}