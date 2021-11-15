import 'package:continuee_mobile/utils/store.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:continuee_mobile/extensions/Device.extension.dart';
import 'package:continuee_mobile/pages/PageLayout.dart';
import 'package:continuee_mobile/utils/api.dart';
import 'package:continuee_mobile/utils/conditionals.dart';

class CreateChain extends StatefulWidget {
  const CreateChain({Key? key, required this.syncCode, required this.chainName})
      : super(key: key);

  final String syncCode;
  final String chainName;

  @override
  State<CreateChain> createState() => _CreateChainState();
}

class _CreateChainState extends State<CreateChain> {
  final _formKey = GlobalKey<FormState>();
  final _titleText = "Confirm Sync Code";

  bool _isResetEnabled = false;

  @override
  Widget build(BuildContext context) {
    return PageLayout(titleText: this._titleText, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          QrImage(
            data: widget.syncCode,
            version: QrVersions.auto,
          ),
          Text(widget.syncCode)
        ],
      ),
      Form(
          key: this._formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                autofocus: true,
                initialValue: widget.chainName,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Chain name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Please enter a chain name";
                  }
                  return null;
                },
                onChanged: (value) => this.setState(() {
                  this._isResetEnabled = value.trim() != widget.chainName;
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlatButton(
                      textTheme: ButtonTextTheme.primary,
                      onPressed: () async {
                        if (this._formKey.currentState!.validate()) {
                          var device = await DeviceFactory.getLocal();
                          var r = await Api().post("chain/createChain", data: {
                            "device": device,
                            "sync": widget.syncCode,
                            "name": widget.chainName
                          });
                          // TODO: Catch possible errors

                          Store.setChainId(r.data["chainId"]);

                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Ok'),
                    ),
                    FlatButton(
                      textTheme: ButtonTextTheme.normal,
                      onPressed: Conditionals.getValueOrNull(
                          this._isResetEnabled, () => Navigator.pop(context)),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              )
            ],
          )),
    ]);
  }
}
