import 'package:flutter/material.dart';

class RecyclingCenterScreen extends StatefulWidget {
  const RecyclingCenterScreen({super.key});

  @override
  State<RecyclingCenterScreen> createState() => _RecyclingCenterScreenState();
}

class _RecyclingCenterScreenState extends State<RecyclingCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Recycling Center'),
      backgroundColor: Colors.green[300],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10) ,
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.green[100],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.place),
                      title: Text('Green Resource Recovery Sdn Bhd', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Plot 19, Darul Aman Industrial Estate, Bandar Darul Aman, Kampung Pantai Halban, 06000 Jitra, Kedah'),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 150.0,
                      width: 300.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/greenresource.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ]
                )
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.green[100],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.place),
                      title: Text('GlobalCycle Changlun', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('No 9, Batu 16, Jalan Changlun, North-South Expy, KM22.5 of, 06000 Jitra, Kedah'),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 150.0,
                      width: 300.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/globalcycle.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ]
                )
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.green[100],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.place),
                      title: Text('WellRecycle Sdn Bhd', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('6a, Kampung Mergong Hilir, Kampung Batin, 05150 Alor Setar, Kedah'),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 150.0,
                      width: 300.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/wellrecycle.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ]
                )
              ),
              const SizedBox(height: 10),
            ],
          )
        ),
      ),
    );
  }
}