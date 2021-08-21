import 'package:flutter/material.dart';

class ConfirmWords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Sync Code"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Confirm!'),
        ),
      ),
    );
  }
}
