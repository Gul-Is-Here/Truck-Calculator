// import 'package:dispatched_calculator_app/screens/load_screen/load_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:dispatched_calculator_app/controllers/home_controller.dart';


// class EditScreen extends StatelessWidget {
//   final String documentId;
//   final HomeController homeController;
//   final Map<String, dynamic>? loadData;

//   EditScreen(
//       {required this.documentId,
//       required this.homeController,
//       required this.loadData});

//   @override
//   Widget build(BuildContext context) {
//     print(documentId);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Entry'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),

//         child: LoadScreen(
//           isUpdate: false,
//           loadData: loadData,
//           documentId: documentId,
//           homeController: homeController,
//         ), // Navigate to the LoadScreen
//       ),
//     );
//   }
// }
