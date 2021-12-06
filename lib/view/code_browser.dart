// CodeBrowser

import 'package:flutter/material.dart';
import 'package:jade/model/browser_model.dart';
import 'package:provider/provider.dart';

class CodeBrowser extends StatefulWidget {
  final BrowserModel _model;
  const CodeBrowser(this._model, {Key? key}) : super(key: key);

  @override
  _CodeBrowser createState() {
    // ignore: no_logic_in_create_state
    return _CodeBrowser(_model);
  }
}

class _CodeBrowser extends State<CodeBrowser> {
  final BrowserModel _model;

  _CodeBrowser(this._model);

  Widget _builder(var context, var model, var child) {
    return SizedBox.expand(
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 0.5,
        alignment: FractionalOffset.center,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
              width: 4,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<BrowserModel>(builder: _builder),
    );
  }
}
