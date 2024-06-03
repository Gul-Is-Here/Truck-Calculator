import 'package:flutter/material.dart';

void showAddLoadDialog(BuildContext context, var controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add Another Load'),
        content: Text('Do you want to add another load?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Add'),
            onPressed: () {
              controller.addNewLoad();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
