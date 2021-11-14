import 'package:flutter/material.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({Key? key, required this.titleText, required this.children})
      : super(key: key);

  final String titleText;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text("${this.titleText}"),
    );

    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
            clipBehavior: Clip.antiAlias,
            padding: new EdgeInsets.all(25.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight -
                      appBar.preferredSize.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: this.children,
              ),
            ));
      }),
    );
  }
}
