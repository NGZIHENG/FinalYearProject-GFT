import 'package:flutter/material.dart';
import '../appointment.dart';
import '../appointmentstatus.dart';
import '../price.dart';
import '../profilescreen.dart';
import '../recyclingcenter.dart';
import '../user.dart';
import '../withdrawalstatus.dart';

class HomePage extends StatefulWidget {
  final User user;
  
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 161, 247, 187),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:20, vertical:10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 208, 183),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (content) => ProfileScreen(user: widget.user)));},
                      )
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Welcome', style:TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      const Text(
                        "Greener, ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        widget.user.name.toString(),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 50,
                      children: <Widget>[
                        CategoryCard(
                          title: "Appointment Status",
                          image: "assets/appointment.png",
                          press: (){Navigator.push(context,MaterialPageRoute(builder: (content) => AppointmentStatusScreen(user: widget.user)));},
                        ),
                        CategoryCard(
                          title: "Withdrawal History",
                          image: "assets/atm.png",
                          press: (){Navigator.push(context,MaterialPageRoute(builder: (content) => WithdrawalStatusScreen(user: widget.user)));},
                        ),
                        CategoryCard(
                          title: "Price List",
                          image: "assets/price.png",
                          press: () {Navigator.push(context,MaterialPageRoute(builder: (content) => const PriceScreen()));},
                        ),
                        CategoryCard(
                          title: "Recycling Center",
                          image: "assets/recycling.png",
                          press: (){Navigator.push(context,MaterialPageRoute(builder: (content) => const RecyclingCenterScreen()));},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }

}

class CategoryCard extends StatelessWidget {
  final String image;
  final String title;
  final Function press;
  const CategoryCard({
    super.key, 
    required this.image, 
    required this.title, 
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        //padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0,17),
              blurRadius: 17,
              spreadRadius: -23,
              color: Color.fromARGB(255, 146, 220, 148),
            )
          ]
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => press(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  const Spacer(),
                  Image.asset(image, height: 75, width: 75),
                  const Spacer(),
                  Text(title, textAlign: TextAlign.center, style:const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ]
              ),
            ),
          ),
        )
      ),
    );
  }
}