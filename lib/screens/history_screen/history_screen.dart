import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispatched_calculator_app/app_classes/app_class.dart';
import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/constants/fonts_strings.dart';
import 'package:dispatched_calculator_app/screens/history_screen/history_details_screen.dart';
import 'package:dispatched_calculator_app/services/firebase_services.dart';
import 'package:dispatched_calculator_app/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(
              color: AppColor().appTextColor, fontFamily: robotoRegular),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: FirebaseServices().fetchHistoryDataById(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  itemCount: 6, // Number of shimmer items to show
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                color: Colors.white,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 20,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    width: 150,
                                    height: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history data found.'));
          } else {
            var historyData = snapshot.data!;

            // Sort the historyData by updateTime in descending order
            historyData.sort((a, b) {
              var aTime =
                  a['data']['calculatedValues'][0]['updateTime']?.toDate() ??
                      DateTime(1970);
              var bTime =
                  b['data']['calculatedValues'][0]['updateTime']?.toDate() ??
                      DateTime(1970);
              return bTime.compareTo(aTime);
            });

            return ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> document = historyData[index];
                List<dynamic> calculatedValues =
                    document['data']['calculatedValues'];

                // Check if calculatedValues is not empty and get the first element's updateTime
                DateTime dateTime;
                if (calculatedValues.isNotEmpty &&
                    calculatedValues[0]['updateTime'] != null) {
                  var timestamp = calculatedValues[0]['updateTime'];
                  if (timestamp is Timestamp) {
                    dateTime = timestamp.toDate();
                  } else if (timestamp is DateTime) {
                    dateTime = timestamp;
                  } else {
                    dateTime = DateTime
                        .now(); // Fallback if the timestamp is not recognized
                  }
                } else {
                  dateTime =
                      DateTime.now(); // Fallback if the timestamp is null
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        () => HistoryDetailsScreen(
                          data: document['data'],
                          documentId: document['id'],
                        ),
                        transition: Transition.circularReveal,
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.info_rounded,
                              size: 40,
                              color: AppColor().secondaryAppColor,
                            ),
                            Column(
                              children: [
                                Text(document['id']),
                                Text(AppClass()
                                    .formatDateTimeFriendly(dateTime)),
                              ],
                            ),
                          ],
                        ),
                        10.heightBox,
                        const Divider(),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
