import 'package:dispatched_calculator_app/app_classes/app_class.dart';
import 'package:dispatched_calculator_app/constants/colors.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:dispatched_calculator_app/screens/history_screen/history_details_screen.dart';
import 'package:dispatched_calculator_app/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: HomeController().fetchHistoryDataById(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                          transition: Transition.circularReveal);
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
                                    .formatDateTimeFriendly(timestamp.toDate()))
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
