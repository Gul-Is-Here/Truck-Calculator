import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dispatched_calculator_app/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widgets/custome_textFormField.dart';

class LoadScreen extends StatefulWidget {
  final HomeController homeController;

  LoadScreen({required this.homeController});

  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  List<Map<String, TextEditingController>> loadControllers = [];

  @override
  void initState() {
    super.initState();
    addLoad();
  }

  void addLoad() {
    loadControllers.add({
      'freightChargeController': TextEditingController(),
      'dispatchedMilesController': TextEditingController(),
      'estimatedTollsController': TextEditingController(),
      'otherCostsController': TextEditingController(),
    });
  }

  @override
  void dispose() {
    for (var controllers in loadControllers) {
      controllers.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(loadControllers.length);
    print(widget.homeController.freightChargeController.value);
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Costs'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: loadControllers.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Load ${index + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      buildTextFormField(
                        controller: loadControllers[index]
                            ['freightChargeController']!,
                        label: 'Freight Charge (\$)',
                        hint: 'e.g., \$1000',
                        validator: widget.homeController.validateInput,
                      ),
                      buildTextFormField(
                        controller: loadControllers[index]
                            ['dispatchedMilesController']!,
                        label: 'Dispatched Miles',
                        hint: 'e.g., 2000',
                        validator: widget.homeController.validateInput,
                      ),
                      buildTextFormField(
                        controller: loadControllers[index]
                            ['estimatedTollsController']!,
                        label: 'Estimated Tolls (\$)',
                        hint: 'e.g., \$50',
                        validator: widget.homeController.validateInput,
                      ),
                      buildTextFormField(
                        controller: loadControllers[index]
                            ['otherCostsController']!,
                        label: 'Other Costs (\$)',
                        hint: 'e.g., \$100',
                        validator: widget.homeController.validateInput,
                      ),
                      20.heightBox,
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? addAnotherLoad = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add Another Load?'),
                      content: Text('Do you want to add another load?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    );
                  },
                );

                if (addAnotherLoad == true) {
                  setState(() {
                    addLoad();
                  });
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
