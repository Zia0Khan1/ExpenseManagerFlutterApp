import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expensemanager/controllers/db_helper.dart';
import 'package:expensemanager/models/Transaction_model.dart';
import 'package:expensemanager/pages/Add_rename.dart';
import 'package:expensemanager/pages/add_transaction.dart';
import 'package:expensemanager/widgets/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expensemanager/static.dart' as Static;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Box box;
  late SharedPreferences preferences;
  DbHelper dbHelper = DbHelper();
  Map? data;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;

  DateTime today = DateTime.now();
  DateTime now = DateTime.now();
  int index = 1;
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

  @override
  void initState() {
    super.initState();
    getPreference();
    box = Hive.box('money');
    fetch();

    //theme work
    _brightness = Brightness.light;

  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {

      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        items.add(
          TransactionModel(
            element['amount'] as int,
            element['note'],
            element['date'] as DateTime,
            element['type'],
          ),
        );
      });
      return items;
    }
  }

  getTotalBalance(List<TransactionModel> entiredata) {
    totalExpense = 0;
    totalIncome = 0;
    totalBalance = 0;

    for (TransactionModel data in entiredata) {
      if (data.date.month == today.month) if (data.type == "Income") {
        totalBalance += data.amount;
        totalIncome += data.amount;
      } else {
        totalBalance -= data.amount;
        totalExpense += data.amount;
      }
    }
  }

  //ad work

  InterstitialAd? interstitialAd;
  bool isInterstitialAdLoaded = false;

  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-1910071497933889/4019019561",
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

  ///ad work completed


  //theme work start

  Brightness? _brightness;

  void changeTheme(){
    setState(() {
      _brightness = _brightness == Brightness.dark?Brightness.light:Brightness.dark;
    });
  }

  //theme work completed


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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isInterstitialAdLoaded) {
            print("interstitialAd ----- FAB BUTTON | HOME_PAGE");
            interstitialAd!.show();
          }
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const AddTransaction(),
            ),
          )
              .whenComplete(() {
            setState(() {});
          });
        },
        backgroundColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              // shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xffd8fac5),
                  Color(0xfffac5c5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
          child: const Icon(
            Icons.add,
            size: 32.0,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: FutureBuilder<List<TransactionModel>>(
            future: fetch(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error!"),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Please add your transactions!"),
                  );
                }
                getTotalBalance(snapshot.data!);
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [

                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32.0),
                                color: Colors.white70,
                              ),
                              child: CircleAvatar(
                                maxRadius: 32.0,
                                child: Image.asset(
                                  "assets/face.png",
                                  width: 64.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            AnimatedTextKit(
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  "Welcome, ${preferences.getString('name')}",
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  colors: colorizeColors,
                                ),
                              ],
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              onTap: () {
                                print("Tap Event");
                              },
                            ),
                          ]),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white70,
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: IconButton(
                              icon: const Icon(Icons.settings,
                                  size: 32.0, color: Color(0xff3E454C)),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const AddreName(),
                                  ),
                                );
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffd8fac5),
                                Color(0xfffac5c5),
                                Color(0xffd8fac5),

                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.0))),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 8.0),
                        child: Column(
                          children: [
                            const Text(
                              "Total Balance",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22.0, color: Colors.black),
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Text(
                              "$totalBalance \$ ",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 26.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  cardIncome(totalIncome.toString()),
                                  cardExpense(totalExpense.toString())
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(
                        12.0,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText(
                            'Recent Transactions',
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                            colors: colorizeColors,
                          ),
                        ],
                        isRepeatingAnimation: true,
                        repeatForever: true,
                        // displayFullTextOnTap: true,

                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length + 1,
                        itemBuilder: (context, index) {
                          TransactionModel dataAtIndex;
                          try {
                            // dataAtIndex = snapshot.data![index];
                            dataAtIndex = snapshot.data![index];
                          } catch (e) {
                            // deleteAt deletes that key and value,
                            // hence makign it null here., as we still build on the length.
                            return Container();
                          }

                          if (dataAtIndex.type == "Income") {
                            return IncomeTile(dataAtIndex.amount,
                                dataAtIndex.note, dataAtIndex.date, index);
                          } else {
                            return expenseTile(dataAtIndex.amount,
                                dataAtIndex.note, dataAtIndex.date, index);
                          }
                        }),
                    const SizedBox(
                      height: 60.0,
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text("Error!"),
                );
              }
            }),
      ),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: const EdgeInsets.all(6.0),
          margin: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.green[700],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
              ),
            ),
            Text(
              "$value \$ ",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: const EdgeInsets.all(6.0),
          margin: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.red[700],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expense",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
              ),
            ),
            Text(
              "$value \$",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget expenseTile(int value, String note, DateTime date, int index) {
    return InkWell(
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "Do you really want to delete this record? This action is irreversible.",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
            color: const Color(0xfffac5c5),
            borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_down_outlined,
                      size: 28.0,
                      color: Colors.red[700],
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    const Text(
                      "Expense",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${date.day} ${months[date.month - 1]} ${date.year}",
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  " - $value \$",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  note,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget IncomeTile(int value, String note, DateTime date, int index) {
    return InkWell(
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "Do you really want to delete this record? This action is irreversible.",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
            color: const Color(0xffd8fac5),
            // Color(0xffced4eb),
            borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_up_outlined,
                      size: 28.0,
                      color: Colors.green[700],
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    const Text(
                      "Income",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    "${date.day} ${months[date.month - 1]} ${date.year}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      // fontSize: 24.0,
                      // fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  " + $value \$",
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.w700),
                ),
                Text(
                  note,
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  //back button alert
  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Press again to exit !",
          backgroundColor: const Color(0xff69D6F4),
          textColor: Colors.black);
      return Future.value(false);
    }
    return Future.value(true);
  }
}
