import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/widgets/custome_row_widget.dart';
import 'package:dispatched_calculator_app/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/custome_history_card_widget.dart';

class HistoryDetailsScreen extends StatelessWidget {
  final String documentId;
  final dynamic data;
  const HistoryDetailsScreen(
      {super.key, required this.documentId, required this.data, });

  @override
  Widget build(BuildContext context) {
    var homeController=Get.put(HomeController());
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: 
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // OverView Section
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontFamily: robotoRegular,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.heightBox,
                CustomeRowWidget(
                  textHeading:data['totalProfit'] <= 0
                      ? 'Loss'
                      : 'Total Profit',
                  values: data['totalProfit'].toStringAsFixed(2),
                ),
                10.heightBox,
                CustomeRowWidget(
                  textHeading: 'Total Miles',
                  values: data['totalDispatchedMiles'].toStringAsFixed(2),
                ),
                10.heightBox,
                CustomeRowWidget(
                  textHeading: 'Total freight charges',
                  values: data['totalFreightCharges'].toStringAsFixed(2),
                ),
                10.heightBox,
                const Divider(
                  thickness: 2,
                ),
                10.heightBox,
                const Text(
                  'Truck Monthly Cost',
                  style: TextStyle(
                    fontFamily: robotoRegular,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.heightBox,
                // CustomeRowWidget(
                //   textHeading: 'Truck Payment',
                //   values: data['monthlyTruckPayment'].toStringAsFixed(2),
                // ),
                // 10.heightBox,
                // CustomeRowWidget(
                //   textHeading: 'Insurance',
                //   values: data['monthlyTruckInsurance'].toStringAsFixed(2),
                // ),
                // 10.heightBox,
                // CustomeRowWidget(
                //   textHeading: 'Trailer lease',
                //   values: data['monthlyTrailerLease'].toStringAsFixed(2),
                // ),
                // 10.heightBox,
                // CustomeRowWidget(
                //   textHeading: 'ELD Service',
                //   values: data['monthlyEldService'].toStringAsFixed(2),
                // ),
                // 10.heightBox,
                // CustomeRowWidget(
                //   textHeading: 'Overhead',
                //   values: data['monthlyOverheadCost'].toStringAsFixed(2),
                // ),
                // 10.heightBox,
                // CustomeRowWidget(
                //   textHeading: 'Other',
                //   values: data['monthlyOtherCost'].toStringAsFixed(2),
                // ),
                10.heightBox,
                const Divider(
                  thickness: 2,
                ),
                10.heightBox,
                const Text(
                  'Truck loads',
                  style: TextStyle(
                    fontFamily: robotoRegular,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                10.heightBox,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(data['loads'].length, (index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.elliptical(20, 20),
                                bottomRight: Radius.elliptical(20, 20),
                              ),
                            ),
                            elevation: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                        fontFamily: robotoRegular,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                CustomeHistoryCardWidget(
                                  textHeading: 'Dispatched Miles',
                                  values: data['loads'][index]['dispatchedMiles']
                                      .toStringAsFixed(2),
                                ),
                                10.heightBox,
                                CustomeHistoryCardWidget(
                                  textHeading: 'Estimated Tolls',
                                  values: data['loads'][index]['estimatedTolls']
                                      .toStringAsFixed(2),
                                ),
                                10.heightBox,
                                CustomeHistoryCardWidget(
                                  textHeading: 'Freight Charges',
                                  values: data['loads'][index]['freightCharge']
                                      .toStringAsFixed(2),
                                ),
                                10.heightBox,
                                CustomeHistoryCardWidget(
                                  textHeading: 'Other Cost',
                                  values: data['loads'][index]['otherCosts']
                                      .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      
    );
  }
}
