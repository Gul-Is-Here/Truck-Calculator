import 'package:flutter/material.dart';

void showDeleteConfirmationDialog(BuildContext context, int index,var controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Load'),
          content: Text('Are you sure you want to delete this load?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                controller.removeLoad(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }