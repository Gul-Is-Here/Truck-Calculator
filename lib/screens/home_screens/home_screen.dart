import 'package:dispatched_calculator_app/app_classes/app_class.dart';
import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/screens/history_screen/update_screen.dart';
import 'package:dispatched_calculator_app/screens/load_screen/load_screen.dart';
import 'package:dispatched_calculator_app/screens/load_screen/mileage_fee_section.dart';
import 'package:dispatched_calculator_app/widgets/card_widget.dart';
import 'package:dispatched_calculator_app/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../calculator_screen/calculator_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());

  final GlobalKey mileageButtonKey = GlobalKey();

  final GlobalKey truckPaymentButtonKey = GlobalKey();

  final GlobalKey calculatorCardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLogin = prefs.getBool('isFirstLogin') ?? true;
      if (isFirstLogin) {
        showTutorial(context);
        await prefs.setBool('isFirstLogin', false);
      }
    });

    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              20.heightBox,
              Center(
                child: Text(
                  AppClass().getGreeting(),
                  style: TextStyle(
                    fontFamily: robotoRegular,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              20.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    key: mileageButtonKey,
                    onPressed: () async {
                      final result = await Get.to(() => MileageFeSection(
                            homeController: homeController,
                            isUpdate: true,
                          ));
                      if (result == true) {
                        setState(() {
                          homeController.fetchMileageValues();
                        });
                      }
                    },
                    child: Text('Cost Per Mile'),
                  ),
                  ElevatedButton(
                    key: truckPaymentButtonKey,
                    onPressed: () async {
                      final result = await Get.to(() => CalculatorScreen());
                      setState(() {
                        if (result == true) {
                          homeController.fetchTruckPaymentIntialValues();
                        }
                      });
                    },
                    child: Text('Fixed Payment'),
                  ),
                ],
              ),
              10.heightBox,
              if (homeController.fTrcukPayment.value != 0.0 &&
                  homeController.fPermileageFee.value != 0.0)
                CardWidget(
                  key: calculatorCardKey,
                  onTap: () {
                    Get.to(() => LoadScreen(
                          homeController: homeController,
                          isUpdate: false,
                        ));
                  },
                  butonText: 'Calculate',
                  cardText:
                      'This is a calculator where you can calculate your expanses',
                  cardColor: AppColor().secondaryAppColor,
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    color: AppColor().secondaryAppColor.withOpacity(.7),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (homeController.fPermileageFee.value == 0.0)
                            Text(
                              "1 - Please add 'cost per mile' value.",
                              style: TextStyle(
                                fontFamily: robotoRegular,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellowAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (homeController.fTrcukPayment.value == 0.0)
                            Text(
                              "2 - Please add 'fixed payment'.",
                              style: TextStyle(
                                fontFamily: robotoRegular,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellowAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              10.heightBox,
              CardWidget(
                onTap: () {
                  Get.to(() => UpdateScreen(
                        homeController: homeController,
                        isUpdate: true,
                      ));
                },
                butonText: 'Update',
                cardText:
                    'This is a calculator where you can calculate your expanses',
                cardColor: AppColor().primaryAppColor,
              ),
              10.heightBox,
              // CardWidget(
              //   onTap: () {
              //     // print(homeController.newDocumentId);
              //     Get.to(() => HistoryScreen(), transition: Transition.fadeIn);
              //   },
              //   butonText: 'History',
              //   cardText: 'This is a calculator where you can calculate your expanses',
              //   cardColor: AppColor().primaryAppColor,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void showTutorial(BuildContext context) {
    TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
    ).show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "MileageButton",
        keyTarget: mileageButtonKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              "Tap here to add Mileage values",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "TruckPaymentButton",
        keyTarget: truckPaymentButtonKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              "Tap here to add Truck Payment",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "CalculatorCard",
        keyTarget: calculatorCardKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              "Tap here to use the Calculator",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    ];
  }
}
