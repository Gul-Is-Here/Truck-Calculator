import 'package:dispatched_calculator_app/app_classes/app_class.dart';
import 'package:dispatched_calculator_app/constants/colors.dart';
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
        title: const Text('History'),
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
                          horizontal: 10, vertical: 20),
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
                                  SizedBox(height: 10),
                                  Container(
                                    width: 150,
                                    height: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
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
            return ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> document = historyData[index];

                var timestamp = (document['data']['updateTime']);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                                Text(AppClass().formatDateTimeFriendly(
                                    timestamp.toDate())),
                              ],
                            ),
                          ],
                        ),
                        10.heightBox,
                        Divider(),
                        10.heightBox,
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
