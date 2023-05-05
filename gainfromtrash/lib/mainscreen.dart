import 'package:flutter/material.dart';
import 'package:gainfromtrash/page/cashwithdrawalpage.dart';
import 'package:gainfromtrash/user.dart';
import 'page/appointmentpage.dart';
import 'page/homepage.dart';


class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 1;
  List<Widget> screens = [];
  
  @override

  Widget build(BuildContext context) {
    final screens = [
    AppointmentPage(user: widget.user),
    HomePage(user: widget.user),
    CashWithdrawalPage(user: widget.user),
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