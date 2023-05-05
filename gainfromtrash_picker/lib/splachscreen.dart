import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'package:http/http.dart' as http;

import 'picker.dart';
import 'user.dart';
import 'welcomescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/gainfromtrashpicker.png'), 
              fit: BoxFit.cover
            )
          )
        )
      ]
    );
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String pass = (prefs.getString('pass')) ?? '';
    if (email.isNotEmpty) {
      http.post(Uri.parse("${Config.server}/gainfromtrash/php/login_user.php"),
          body: {"email": email, "password": pass}).then((response) {
            print(response.body);
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200 && jsonResponse['status'] == "success") {
          
          Picker picker = Picker.fromJson(jsonResponse['data']);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => const WelcomeScreen())));
        } else {
          Picker picker = Picker(
            id: "0",
              email: "unregistered",
              name: "unregistered",
              address: "na",
              phone: "0123456789",
              regdate: "0",
              balance: "0");
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => const WelcomeScreen())));
        }
      });
    } else {
      Picker picker = Picker(
          id: "0",
          email: "unregistered@email.com",
          name: "unregistered",
          address: "na",
          phone: "0123456789",
          regdate: "0",
          balance: "0");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => const WelcomeScreen())));
    }
  }
}