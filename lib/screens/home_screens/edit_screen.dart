import 'package:dispatched_calculator_app/screens/home_screens/load_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/addLoad_dialogBox.dart';
import '../../widgets/custome_textFormField.dart';
import '../../screens/home_screens/mileage_fee_section.dart';
import '../../widgets/delete_dialogBox.dart';

class EditScreen extends StatelessWidget {
  final String documentId;
  final HomeController homeController;

  EditScreen({required this.documentId, required this.homeController});

  @override
  Widget build(BuildContext context) {
    print(documentId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Entry'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: LoadScreen(
          homeController: homeController,
        ), // Navigate to the LoadScreen
      ),
    );
  }
}
