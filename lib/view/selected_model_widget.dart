import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/login.dart';
import 'package:jade/model/session.dart';
import 'package:jade/view/login_form.dart';
import 'package:jade/view/session_widget.dart';
import 'package:provider/provider.dart';

class SelectedModelWidget extends StatelessWidget {
  const SelectedModelWidget({Key? key}) : super(key: key);

  Widget _builder(context, jade, child) {
    var model = jade.selectedModel;
    switch (model.runtimeType) {
      case Login:
        return LoginForm(model! as Login);
      case Session:
        return SessionWidget(model! as Session);
      default:
        return Container();
    }
  }

  // the Provider/Consumer structure allows us to be
  // notified when the selectedModel changes
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Jade(),
      child: Consumer<Jade>(
        builder: _builder,
      ),
    );
  }
}
