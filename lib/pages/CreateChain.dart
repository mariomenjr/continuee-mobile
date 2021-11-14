import 'package:continuee_mobile/extensions/Device.extension.dart';
import 'package:continuee_mobile/utils/api.dart';
import 'package:continuee_mobile/utils/conditionals.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

  bool _isResetEnabled = false;

  AppBar _appBar = AppBar(
    title: const Text("Confirm Sync Code"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: this._appBar,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
              clipBehavior: Clip.antiAlias,
              padding: new EdgeInsets.all(25.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight -
                        this._appBar.preferredSize.height),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                                  border: UnderlineInputBorder(),
                                  labelText: 'Chain name'),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return "Please enter a chain name";
                                }
                                return null;
                              },
                              onChanged: (value) => this.setState(() {
                                this._isResetEnabled =
                                    value.trim() != widget.chainName;
                              }),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FlatButton(
                                    textTheme: ButtonTextTheme.primary,
                                    onPressed: () async {
                                      if (this
                                          ._formKey
                                          .currentState!
                                          .validate()) {
                                        var device =
                                            await DeviceFactory.getLocal();
                                        var r = await Api()
                                            .post("chain/createChain", data: {
                                          "device": device,
                                          "sync": widget.syncCode,
                                          "name": widget.chainName
                                        });
                                        // TODO: Catch possible errors

                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Ok'),
                                  ),
                                  FlatButton(
                                    textTheme: ButtonTextTheme.normal,
                                    onPressed: Conditionals.getValueOrNull(
                                        this._isResetEnabled,
                                        () => Navigator.pop(context)),
                                    child: const Text('Reset'),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
