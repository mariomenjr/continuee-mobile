import 'package:flutter/material.dart';

class ConfirmSyncCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Sync Code"),
      ),
      body: Center(
          child: Padding(
        padding: new EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Confirm chain name'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FlatButton(
                  textTheme: ButtonTextTheme.primary,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Confirm'),
                ),
                FlatButton(
                  textTheme: ButtonTextTheme.normal,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Reset'),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
