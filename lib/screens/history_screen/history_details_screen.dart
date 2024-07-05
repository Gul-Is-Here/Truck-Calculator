import 'package:dispatched_calculator_app/constants/colors.dart';
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

  const HistoryDetailsScreen({
    super.key,
    required this.documentId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeController());
    print('data=>  $data');

    double getValue(dynamic value) {
      return value != null ? (value as num).toDouble() : 0.0;
    }

    return Scaffold(
        drawer: MyDrawerWidget(),
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontFamily: robotoRegular,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: List.generate(
                      data['calculatedValues'].length,
                      (index) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: ListTile(
                                  title: Text(
                                    'Total Miles',
                                    style: TextStyle(
                                        fontFamily: robotoRegular,
                                        fontSize: 13,
                                        color: AppColor().secondaryAppColor),
                                  ),
                                  subtitle: Text(
                                    getValue(data['calculatedValues'][index]
                                            ['totalDispatchedMiles'])
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                        fontFamily: robotoRegular,
                                        fontSize: 13,
                                        color: AppColor().secondaryAppColor),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: ListTile(
                                  title: Text(
                                    getValue(data['calculatedValues'][index]
                                                ['totalProfit']) <=
                                            0
                                        ? 'Loss'
                                        : 'Profit',
                                    style: TextStyle(
                                        fontFamily: robotoRegular,
                                        fontSize: 13,
                                        color: AppColor().secondaryAppColor),
                                  ),
                                  subtitle: Text(
                                    getValue(data['calculatedValues'][index]
                                            ['totalProfit'])
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                        fontFamily: robotoRegular,
                                        fontSize: 13,
                                        color: AppColor().secondaryAppColor),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: ListTile(
                                  title: Text(
                                    'Total Freight',
                                    style: TextStyle(
                                        fontFamily: robotoRegular,
                                        fontSize: 13,
                                        color: AppColor().secondaryAppColor),
                                  ),
                                  subtitle: Text(
                                    getValue(data['calculatedValues'][index]
                                            ['totalFreightCharges'])
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                        fontFamily: robotoRegular,
                                        fontSize: 13,
                                        color: AppColor().secondaryAppColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          10.heightBox,
                          const Divider(
                            thickness: 2,
                          ),
                          10.heightBox,
                          Row(
                            children: [
                              Expanded(
                                  child: Card(
                                child: Column(
                                  children: List.generate(
                                      data['truckPayment'].length,
                                      (index) => SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 8),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    'Fixed Cost',
                                                    style: TextStyle(
                                                      fontFamily: robotoRegular,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  10.heightBox,
                                                  CustomeRowWidget(
                                                    textHeading:
                                                        'Truck Payment',
                                                    values: getValue(data[
                                                                    'truckPayment']
                                                                [index][
                                                            'monthlyTruckInsurance'])
                                                        .toStringAsFixed(2),
                                                  ),
                                                  10.heightBox,
                                                  CustomeRowWidget(
                                                    textHeading: 'ELD Service',
                                                    values: getValue(data[
                                                                    'truckPayment']
                                                                [index][
                                                            'monthlyEldService'])
                                                        .toStringAsFixed(2),
                                                  ),
                                                  10.heightBox,
                                                  CustomeRowWidget(
                                                    textHeading:
                                                        'Trailer Lease',
                                                    values: getValue(data[
                                                                    'truckPayment']
                                                                [index][
                                                            'monthlyTrailerLease'])
                                                        .toStringAsFixed(2),
                                                  ),
                                                  10.heightBox,
                                                  CustomeRowWidget(
                                                    textHeading: 'Insurance',
                                                    values: getValue(data[
                                                                    'truckPayment']
                                                                [index][
                                                            'monthlyTruckInsurance'])
                                                        .toStringAsFixed(2),
                                                  ),
                                                  10.heightBox,
                                                  CustomeRowWidget(
                                                    textHeading: 'Overhead',
                                                    values: getValue(data[
                                                                    'truckPayment']
                                                                [index][
                                                            'monthlyOverheadCost'])
                                                        .toStringAsFixed(2),
                                                  ),
                                                  10.heightBox,
                                                  CustomeRowWidget(
                                                    textHeading: 'Other',
                                                    values: getValue(data[
                                                                    'truckPayment']
                                                                [index][
                                                            'monthlyOtherCost'])
                                                        .toStringAsFixed(2),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                ),
                              )),
                              Expanded(
                                child: Card(
                                  child: Column(
                                    children: List.generate(
                                      data['mileageFee'].length,
                                      (index) => SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              const Text(
                                                'Cost Per Mile',
                                                style: TextStyle(
                                                  fontFamily: robotoRegular,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              10.heightBox,
                                              CustomeRowWidget(
                                                textHeading: 'Mileage Fee',
                                                values: getValue(data[
                                                            'mileageFee'][index]
                                                        ['milageFeePerMile'])
                                                    .toStringAsFixed(3),
                                              ),
                                              10.heightBox,
                                              CustomeRowWidget(
                                                textHeading: 'Fuel',
                                                values: getValue(
                                                        data['mileageFee']
                                                                [index]
                                                            ['fuelFeePerMile'])
                                                    .toStringAsFixed(2),
                                              ),
                                              10.heightBox,
                                              CustomeRowWidget(
                                                textHeading: 'DEF',
                                                values: getValue(
                                                        data['mileageFee']
                                                                [index]
                                                            ['defFeePerMile'])
                                                    .toStringAsFixed(2),
                                              ),
                                              10.heightBox,
                                              CustomeRowWidget(
                                                textHeading: 'Driver Pay',
                                                values: getValue(data[
                                                            'mileageFee'][index]
                                                        ['driverPayFeePerMile'])
                                                    .toStringAsFixed(2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
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
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: List.generate(
                                  data['calculatedValues'][index]['loads']
                                      .length, (loadIndex) {
                                var load = data['calculatedValues'][index]
                                    ['loads'][loadIndex];
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Card(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.elliptical(20, 20),
                                          bottomRight:
                                              Radius.elliptical(20, 20),
                                        ),
                                      ),
                                      elevation: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColor()
                                                    .secondaryAppColor),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Text(
                                                '${loadIndex + 1}',
                                                style: TextStyle(
                                                  fontFamily: robotoRegular,
                                                  fontSize: 19,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomeHistoryCardWidget(
                                            textHeading: 'Dispatched Miles',
                                            values: load['dispatchedMiles']
                                                .toStringAsFixed(2),
                                          ),
                                          10.heightBox,
                                          CustomeHistoryCardWidget(
                                              textHeading: 'Estimated Tolls',
                                              values: data['calculatedValues']
                                                          [index]['loads']
                                                      [index]['estimatedTolls']
                                                  .toStringAsFixed(2)),
                                          10.heightBox,
                                          CustomeHistoryCardWidget(
                                              textHeading: 'Freight Charges',
                                              values: data['calculatedValues']
                                                          [index]['loads']
                                                      [index]['freightCharge']
                                                  .toStringAsFixed(2)),
                                          10.heightBox,
                                          CustomeHistoryCardWidget(
                                              textHeading: 'Other Cost',
                                              values: data['calculatedValues']
                                                          [index]['loads']
                                                      [index]['otherCosts']
                                                  .toStringAsFixed(2)),
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
                ],
              ),
            ),
          ),
        ));
  }
}
