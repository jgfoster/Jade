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

  @override
  void updateState() async {
    var buffer = _updateStateCode();
    GsObject? myDict;
    try {
      myDict = dictionaries.firstWhere((each) => each.isSelected);
    } on Error {
      myDict = GsObject('nil', '18');
    }

    GsObject? myClass;
    try {
      myClass = classes.firstWhere((each) => each.isSelected);
    } on Error {
      myClass = GsObject('nil', '18');
    }

    buffer.write(' value: \'${myDict.oop}\'');
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

    notifyListeners();
  }

  StringBuffer _updateStateCode() {
    return StringBuffer('''
[:dictOop | | dict result selectedDictOop |
selectedDictOop := Integer fromHexString: dictOop.
dict := Dictionary new.
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
    Dictionary new
      at: 'name' put: each name;
      at: 'oop' put: (each asOop printStringRadix: 16 showRadix: false);
      yourself.
  ]).
result asJson]
''');
  }
}
