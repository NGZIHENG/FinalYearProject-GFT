import 'package:flutter/material.dart';
import 'package:gainfromtrash/tabbar%20page/acceptedpage.dart';
import 'package:gainfromtrash/tabbar%20page/completedpage.dart';
import 'package:gainfromtrash/tabbar%20page/pendingpage.dart';
import 'user.dart';

class AppointmentStatusScreen extends StatefulWidget {
  final User user;
  const AppointmentStatusScreen({super.key, required this.user});

  @override
  State<AppointmentStatusScreen> createState() => _AppointmentStatusScreenState();
}

class _AppointmentStatusScreenState extends State<AppointmentStatusScreen> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3, 
    child: Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(title: const Text('Appointment Status'),
        backgroundColor: Colors.green[300],
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Completed'),
          ],
          indicatorColor: Colors.white, // Set the selected tab indicator color
          indicatorSize: TabBarIndicatorSize.tab, // Set the indicator size to match the tab size
          labelColor: Colors.white, // Set the color of the selected tab's label
          unselectedLabelColor: Colors.white60,
        )
      ),
      body: TabBarView(
        children: [
          PendingPage(user: widget.user),
          AcceptedPage(user: widget.user),
          CompletedPage(user: widget.user),
        ],
      )
    )
  );

}