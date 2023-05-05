import 'package:flutter/material.dart';
import 'package:gainfromtrash/loginscreen.dart';

import 'registrationscreen.dart';


class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Image.asset('assets/gftlogo.png',scale:1)
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[200], //background color of button
                  elevation: 3, //elevation of button
                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 120, left: 120)
                ),
                  onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (content) => const LogInScreen()));},
                  child: const Text('Log In'),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, //background color of button
                  elevation: 3, //elevation of button
                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 113, left: 113)
                ),
                  onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (content) => const RegistrationScreen()));},
                  child: const Text('Register'),
                ),
              ],
            ),
          )
        ]
      )
    );
  }
}