import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Price List'),
      backgroundColor: Colors.green[300],
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              color: Colors.green[100],
              margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Image.asset('assets/paper.png'),
                        title: const Text('Paper', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('RM0.30/KG'),
                      ),
                   ],
                ),
            ),
            Card(
              color: Colors.green[100],
              margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Image.asset('assets/aluminium.png'),
                        title: const Text('Aluminium', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('RM3.00/KG'),
                      ),
                   ],
                ),
            ),
            Card(
              color: Colors.green[100],
              margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Image.asset('assets/plastic.png'),
                        title: const Text('Plastic', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('RM0.30/KG'),
                      ),
                   ],
                ),
            ),
            Card(
              color: Colors.green[100],
              margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Image.asset('assets/glass.png'),
                        title: const Text('Glass', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('RM1.00/KG'),
                      ),
                   ],
                ),
            ),
            Card(
              color: Colors.green[100],
              margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Image.asset('assets/oil.png'),
                        title: const Text('Used Cooking Oil', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('RM3.00/KG'),
                      ),
                   ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}