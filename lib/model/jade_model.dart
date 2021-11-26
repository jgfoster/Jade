import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';

abstract class JadeModel with ChangeNotifier {
  get isSelected => Jade().selectedModel == this;

  void beSelected() {
    Jade().selectedModel = this;
  }

  void beNotSelected() {
    if (Jade().selectedModel == this) {
      Jade().selectedModel = null;
    }
  }

  void selectionStatusChanged() {
    notifyListeners();
  }
}
