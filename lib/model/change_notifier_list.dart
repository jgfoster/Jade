// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'dart:collection';

class ChangeNotifierList<T> extends ListBase<T> with ChangeNotifier {
  final _list = <T>[];

  @override
  int get length => _list.length;

  @override
  set length(int length) {
    _list.length = length;
    notifyListeners();
  }

  @override
  void operator []=(int index, T value) {
    _list[index] = value;
    notifyListeners();
  }

  @override
  T operator [](int index) => _list[index];

  @override
  void add(T element) {
    _list.add(element);
    notifyListeners();
  }

  @override
  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
    notifyListeners();
  }
}
