import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/session.dart';

class GsObject {
  late final String name;
  late final String oop;
  late bool isSelected;

  GsObject(this.name, this.oop, [this.isSelected = false]);
}

class CodeModel extends JadeModel {
  static Widget getIcon() => Transform.rotate(
        angle: 270 * pi / 180,
        child: const Icon(Icons.view_sidebar_outlined),
      );
  static String getTitle() => 'Code Browser';
  final dictionaries = <GsObject>[];
  final classes = <GsObject>[];
  final methods = <GsObject>[];
  final nil = GsObject('nil', '18');

  get icon => getIcon();
  get title => getTitle();

  final Session _session;

  CodeModel(this._session);

  void abort() {
    _session.abort();
  }

  void close() {
    _session.removeChild(this);
  }

  void commit() {
    _session.commit();
  }

  void selectClass(var aClass) async {
    for (var each in classes) {
      each.isSelected = false;
    }
    aClass.isSelected = true;
    updateState();
  }

  void selectDictionary(var dict) async {
    for (var each in dictionaries) {
      each.isSelected = false;
    }
    dict.isSelected = true;
    updateState();
  }

  void selectMethod(var dict) async {
    for (var each in methods) {
      each.isSelected = false;
    }
    dict.isSelected = true;
    updateState();
  }

  @override
  void updateState() async {
    var buffer = _updateStateCode();

    GsObject myDict = nil;
    try {
      myDict = dictionaries.firstWhere((each) => each.isSelected);
    } catch (_) {}

    GsObject myClass = nil;
    try {
      myClass = classes.firstWhere((each) => each.isSelected);
    } catch (_) {}

    GsObject myMethod = nil;
    try {
      myMethod = methods.firstWhere((each) => each.isSelected);
    } catch (_) {}

    buffer.write(' value: \'${myDict.oop}\' value: \'${myClass.oop}\'');
    var response = await _session.execute(buffer.toString());
    var myMap = jsonDecode(response['string']);

    dictionaries.clear();
    for (var eachMap in myMap['dicts']) {
      var each = GsObject(
        eachMap['name'],
        eachMap['oop'],
        eachMap['oop'] == myDict.oop && eachMap['name'] == myDict.name,
      );
      dictionaries.add(each);
    }

    classes.clear();
    for (var eachMap in myMap['classes']) {
      var each = GsObject(
        eachMap['name'],
        eachMap['oop'],
        eachMap['oop'] == myClass.oop && eachMap['name'] == myClass.name,
      );
      classes.add(each);
    }

    methods.clear();
    for (var eachMap in myMap['methods']) {
      var each = GsObject(
        eachMap['name'],
        eachMap['oop'],
        eachMap['oop'] == myMethod.oop && eachMap['name'] == myMethod.name,
      );
      methods.add(each);
    }

    notifyListeners();
  }

  StringBuffer _updateStateCode() {
    return StringBuffer('''
[:dictOop :classOop |
| class dict result selectedClassOop selectedDictOop selectors |
selectedDictOop := Integer fromHexString: dictOop.
selectedClassOop := Integer fromHexString: classOop.
dict := Dictionary new.
selectors := #().
result := Dictionary new
	at: 'dicts' put: (System myUserProfile symbolList collect: [:each |
		each asOop == selectedDictOop ifTrue: [dict := each].
		Dictionary new
			at: 'name' put: each name;
			at: 'oop' put: (each asOop printStringRadix: 16 showRadix: false);
			yourself.
	]);
	yourself.
result at: 'classes' put: (((dict values
  select: [:each | each isClass])
  asSortedCollection: [:a :b | a name <= b name])
  collect: [:each |
		each asOop == selectedClassOop ifTrue: [
      class := each.
      selectors := class selectors.
    ].
    Dictionary new
      at: 'name' put: each name;
      at: 'oop' put: (each asOop printStringRadix: 16 showRadix: false);
      yourself.
  ]).
result at: 'methods' put: (selectors asSortedCollection collect: [:each |
  | method |
  method := class compiledMethodAt: each.
  Dictionary new
    at: 'name' put: each;
    at: 'oop' put: (method asOop printStringRadix: 16 showRadix: false);
    yourself.
]).
result asJson]
''');
  }
}
