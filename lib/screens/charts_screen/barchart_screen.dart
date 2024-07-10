import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';

import '../../services/firebase_services.dart';

class ProfitBarChartScreen extends StatelessWidget {
  ProfitBarChartScreen({super.key});
  final List<OrdinalData> chartData = [];
  Future<List<OrdinalGroup>> _fetchProfitData() async {
    final User? user = FirebaseServices().auth.currentUser;

    if (user == null) {
      print('Error: No user is currently logged in.');
      return [];
    }

    try {
      final QuerySnapshot querySnapshot = await FirebaseServices()
          .firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No documents found.');
        return [];
      }

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        print('Document data: $data');

        if (data.containsKey('calculatedValues')) {
          List<dynamic> calculatedValues =
              data['calculatedValues'] as List<dynamic>;

          double totalProfit = 0.0;
          for (var value in calculatedValues) {
            if (value is Map<String, dynamic> &&
                value.containsKey('totalProfit')) {
              totalProfit += value['totalProfit'];
            } else {
              print('Invalid entry or missing totalProfit in: $value');
            }
          }

          String timestamp = data.containsKey('timestamp')
              ? (data['timestamp'] as Timestamp).toDate().toString()
              : 'Unknown Date';

          chartData.add(OrdinalData(domain: timestamp, measure: totalProfit));
        } else {
          print('Missing calculatedValues in: $data');
        }
      }

      print('Chart data length: ${chartData.length}');
      return [
        OrdinalGroup(
          id: 'Profit',
          data: chartData,
        ),
      ];
    } catch (e) {
      print('Error fetching history data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Charter Date : $chartData');
    return Scaffold(
      appBar: AppBar(
        title: Text('Profit Bar Chart'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Weekly Profit Analysis',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'This chart represents the profit for each week.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: FutureBuilder<List<OrdinalGroup>>(
                future: _fetchProfitData(),
                builder: (context, snapshot) {
                  print('Snapshot data: ${snapshot.data}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: DChartBarO(
                            groupList: snapshot.data!,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
