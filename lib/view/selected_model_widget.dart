import 'package:flutter/material.dart';
import 'package:jade/model/current_sessions.dart';
import 'package:jade/model/jade.dart';
import 'package:jade/model/login.dart';
import 'package:jade/model/session.dart';
import 'package:jade/view/current_sessions_widget.dart';
import 'package:jade/view/login_form.dart';
import 'package:jade/view/transcript_widget.dart';
import 'package:provider/provider.dart';

class SelectedModelWidget extends StatelessWidget {
  const SelectedModelWidget({Key? key}) : super(key: key);

  // Set up notification for selectedModel changes
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Jade(),
      child: Consumer<Jade>(
        builder: _builder,
      ),
    );
  }

  // Padding
  Widget _builder(context, jade, child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: _selectedWidget(jade.selectedModel),
    );
  }

  // main widget depends on selected item from Navigation drawer
  Widget _selectedWidget(var model) {
    switch (model.runtimeType) {
      case Login:
        return LoginForm(model! as Login);
      case Session:
        return TranscriptWidget(model! as Session);
      case CurrentSessions:
        return CurrentSessionsWidget(model! as CurrentSessions);
      default:
        return const Center(
          child: Text(
            'Welcome to Jade, an IDE for GemStone/S 64 Bit.\n'
            'Please select an item from Navigation drawer to the left.',
          ),
        );
    }
  }
}
