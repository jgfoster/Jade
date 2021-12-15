import 'package:flutter/material.dart';
import 'package:jade/model/jade.dart';

abstract class JadeModel with ChangeNotifier {
  void beSelected() {
    Jade().selectModel(this);
  }

  get isSelected => Jade().selectedModel == this;

  void updateState() {
    // notifyListeners();
  }
}
