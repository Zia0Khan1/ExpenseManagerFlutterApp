import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expensemanager/ads/banner_ad.dart';
import 'package:expensemanager/controllers/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart';
import 'package:expensemanager/static.dart' as Static;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  //

  int? amonunt;
  String note = "Milk";
  String types = "income";
  DateTime sdate = DateTime.now();
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: sdate,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != sdate) {
      setState(() {
        sdate = picked;
      });
    }
  }
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
          print(error.code.toString());
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Add Transaction',
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24.0),
                          colors: colorizeColors,
                        ),
                      ],
                      repeatForever: true,
                      isRepeatingAnimation: true,
                      onTap: () {
                        print("Tap Event");
                      },
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              // color: Static.PrimaryMaterialColor,
                              borderRadius: BorderRadius.circular(16.0),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xffd8fac5),
                                  Color(0xfffac5c5),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )),
                          padding: const EdgeInsets.all(12.0),
                          child: const Icon(
                            Icons.attach_money,
                            size: 24.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Enter Amount",
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 24.0,
                            ),
                            onChanged: (val) {
                              try {
                                amonunt = int.parse(val);
                              } catch (e) {
                                print("Error from Add Transaction page");
                                print(e.toString());
                              }
                            },
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),

// 2nd
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xffd8fac5),
                                  Color(0xfffac5c5),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16.0)),
                          padding: const EdgeInsets.all(12.0),
                          child: const Icon(
                            Icons.description,
                            size: 24.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Note of Transaction",
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 24.0,
                            ),
                            onChanged: (val) {
                              note = val;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xffd8fac5),
                                  Color(0xfffac5c5),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16.0)),
                          padding: const EdgeInsets.all(12.0),
                          child: const Icon(
                            Icons.moving_sharp,
                            size: 24.0,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        ChoiceChip(
                          label: Text(
                            "Income",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: types == "Income" ? Colors.white : Colors.black,
                            ),
                          ),
                          selectedColor: const Color(0xff69D6F4),
                          selected: types == "Income" ? true : false,
                          onSelected: (val) {
                            if (val) {
                              setState(() {
                                types = "Income";
                                if (note.isEmpty || note == "Expense") {
                                  note = 'Income';
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        ChoiceChip(
                          label: Text(
                            "Expense",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: types == "Income" ? Colors.white : Colors.black,
                            ),
                          ),
                          selectedColor: const Color(0xff69D6F4),
                          selected: types == "Expense" ? true : false,
                          onSelected: (val) {
                            if (val) {
                              setState(() {
                                types = "Expense";
                                if (note.isEmpty || note == "Expense") {
                                  note = 'Expense';
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 50.0,
                      child: TextButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero)),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffd8fac5),
                                    Color(0xfffac5c5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(
                                  16.0,
                                ),
                              ),
                              padding: const EdgeInsets.all(
                                12.0,
                              ),
                              child: const Icon(
                                Icons.date_range,
                                size: 24.0,
                                // color: Colors.grey[700],
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Text(
                              "${sdate.day} ${months[sdate.month - 1]}",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    SizedBox(
                      height: 50.0,
                      width: double.infinity,
                      child: ElevatedButton(

                        onPressed: () {
                          if (isInterstitialAdLoaded) {
                            print("interstitialAd ----- ADD_TRANSACTION");
                            interstitialAd!.show();
                          }

                          if (amonunt != null) {
                            DbHelper dbHelper = DbHelper();
                            dbHelper.addData(amonunt!, sdate, types, note);

                            Navigator.of(context).pop();
                          } else {
                            print("Not ");
                          }
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // const CustomBannerAd()
          ],
        ));
  }
}
