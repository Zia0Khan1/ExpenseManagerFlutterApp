
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expensemanager/ads/banner_ad.dart';
import 'package:expensemanager/controllers/db_helper.dart';
import 'package:expensemanager/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';



class AddreName extends StatefulWidget {
  const AddreName({Key? key}) : super(key: key);

  @override
  _AddreNameState createState() => _AddreNameState();
}

class _AddreNameState extends State<AddreName> {
  //
  DbHelper dbHelper = DbHelper();

  String name = "";

  //ad work starts

  InterstitialAd? interstitialAd;
  bool isInterstitialAdLoaded=false;
  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-1910071497933889/4019019561",
      // adUnitId: "ca-app-pub-3940256099942544/1033173712",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print("Ad Loaded");
          setState(() {
            interstitialAd = ad;
            isInterstitialAdLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          print("interstitialAd --- FAILED ");
          print(error.message);
          print("Ad Failed to Load");
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    loadInterstitial();
  }

  //ad closed
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
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),



      body: Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      width: 64.0,
                      height: 64.0,
                    ),
                  ),
                  //
                  const SizedBox(
                    height: 20.0,
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Rename Your Name',
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,

                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  //
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Your Name",
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                      maxLength: 12,
                      onChanged: (val) {
                        name = val;
                      },
                    ),
                  ),
                  //
                  const SizedBox(
                    height: 20.0,
                  ),
                  //
                  SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isInterstitialAdLoaded) {
                          print("interstitialAd ----- ADD_RENAME ");
                          interstitialAd!.show();
                        }
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              action: SnackBarAction(
                                label: "OK",
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                },
                              ),
                              backgroundColor: Colors.white,
                              content: const Text(
                                "Please Enter a name",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          );
                        } else {
                          DbHelper dbHelper = DbHelper();
                          await dbHelper.addName(name);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Homepage(),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.0,
                            ),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Proceed",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            Icons.arrow_right_alt,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                  ),




                ],
              ),
            ),
            // const CustomBannerAd(),
          ],
        ),
      ),
    );
  }

}
