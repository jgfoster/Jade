import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/session.dart';

class CodeModel extends JadeModel {
  static Widget getIcon() => Transform.rotate(
        angle: 270 * pi / 180,
        child: const Icon(Icons.view_sidebar_outlined),
      );
  static String getTitle() => 'Code Browser';
  final dictionaries = <Map<String, dynamic>>[];
  final classes = <Map<String, dynamic>>[];
  final methods = <Map<String, dynamic>>[];
  final nil = {'name': 'nil', 'oop': '18', 'isSelected': false};

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

  void selectClass(var aMap) async {
    for (var each in classes) {
      each['isSelected'] = false;
    }
    aMap['isSelected'] = true;
    updateState();
  }

  void selectDictionary(var aMap) async {
    for (var each in dictionaries) {
      each['isSelected'] = false;
    }
    aMap['isSelected'] = true;
    updateState();
  }

  void selectMethod(var aMap) async {
    for (var each in methods) {
      each['isSelected'] = false;
    }
    aMap['isSelected'] = true;
    updateState();
  }

  @override
  void updateState() async {
    var buffer = _updateStateCode();

    Map<String, dynamic> myDict = nil;
    try {
      myDict = dictionaries.firstWhere((each) => each['isSelected']);
    } catch (_) {}

    Map<String, dynamic> myClass = nil;
    try {
      myClass = classes.firstWhere((each) => each['isSelected']);
    } catch (_) {}

    Map<String, dynamic> myMethod = nil;
    try {
      myMethod = methods.firstWhere((each) => each['isSelected']);
    } catch (_) {}

    // OOPs for dictionary, class,
    buffer.write("#( '${myDict['oop']}' '${myClass['oop']}' )");
    var response = await _session.execute(buffer.toString());
    var myMap = jsonDecode(response['string']);

    dictionaries.clear();
    for (var eachMap in myMap['dicts']) {
      eachMap['isSelected'] =
          eachMap['oop'] == myDict['oop'] && eachMap['name'] == myDict['name'];
      dictionaries.add(eachMap);
    }

    classes.clear();
    for (var eachMap in myMap['classes']) {
      eachMap['isSelected'] = eachMap['oop'] == myClass['oop'] &&
          eachMap['name'] == myClass['name'];
      classes.add(eachMap);
    }

    methods.clear();
    for (var eachMap in myMap['methods']) {
      eachMap['isSelected'] = eachMap['oop'] == myMethod['oop'] &&
          eachMap['name'] == myMethod['name'];
      methods.add(eachMap);
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
result asJson] valueWithArguments:
''');
  }
}
