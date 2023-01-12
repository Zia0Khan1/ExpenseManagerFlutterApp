import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expensemanager/controllers/db_helper.dart';
import 'package:expensemanager/pages/add_name.dart';
import 'package:expensemanager/pages/homepage.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  //
  DbHelper dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), (){

      getName();
    });
    // getName();

  }

  Future getName() async {
    String? name = await dbHelper.getName();
    if (name != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Homepage(),
          ),
        );
      }
     else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AddName(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {


    const colorizeColors = [
      Colors.black,
      Color(0xffFF826E),
      Color(0xffFCD770),
      Color(0xff69D6F4),
      Color(0xffFCD770),
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: Image.asset(
              "assets/budget.png",
              width: 150.0,
              height: 150.0,

            ),


          ),
          Spacer(),
          Center(
            child: AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'Manage Your Budget Wisely',
                  textStyle: const TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                  colors: colorizeColors,
                ),

              ],
              repeatForever: true,
              isRepeatingAnimation: true,
              onTap: () {
                print("Tap Event");
              },
            ),
          ),
          Spacer(),
        ],
      ),

    );
  }
}
