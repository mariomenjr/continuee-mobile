import 'package:continuee_mobile/pages/PageLayout.dart';
import 'package:flutter/material.dart';

class JoinChain extends StatefulWidget {
  const JoinChain({Key? key}) : super(key: key);

  @override
  State<JoinChain> createState() => _JoinChainState();
}

class _JoinChainState extends State<JoinChain> {
  final String _titleText = "Join Chain";

  @override
  Widget build(BuildContext context) {
    return PageLayout(titleText: this._titleText, children: []);
  }
}
