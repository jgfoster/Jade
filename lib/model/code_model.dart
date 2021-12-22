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
  final globals = <Map<String, dynamic>>[];
  var klass = {};
  var method = {};
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

    Map<String, dynamic> myGlobal = nil;
    try {
      myGlobal = globals.firstWhere((each) => each['isSelected']);
    } catch (_) {}

    Map<String, dynamic> myMethod = nil;
    try {
      myMethod = methods.firstWhere((each) => each['isSelected']);
    } catch (_) {}

    // OOPs for dictionary, global, class, method,
    buffer
        .write("#( '${myDict['oop']}' '${myGlobal['oop']}' '${myClass['oop']}' "
            " '${myMethod['oop']}' )");
    var response = await _session.execute(buffer.toString());
    var myMap = jsonDecode(response['string']);

    dictionaries.clear();
    for (var eachMap in myMap['dicts']) {
      eachMap['isSelected'] =
          eachMap['oop'] == myDict['oop'] && eachMap['name'] == myDict['name'];
      dictionaries.add(eachMap);
    }

    globals.clear();
    for (var eachMap in myMap['globals']) {
      eachMap['isSelected'] = eachMap['oop'] == myGlobal['oop'] &&
          eachMap['name'] == myGlobal['name'];
      globals.add(eachMap);
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

    klass = myMap['class'] ?? {};
    method = myMap['method'] ?? {};

    notifyListeners();
  }

  StringBuffer _updateStateCode() {
    return StringBuffer('''
[:dictOop :globalOop :classOop :methodOop |
| class classes dict globals method result 
  selectedClassOop selectedDictOop selectedGlobalOop selectedMethodOop 
  selectors |
selectedDictOop := Integer fromHexString: dictOop.
selectedClassOop := Integer fromHexString: classOop.
selectedMethodOop := Integer fromHexString: methodOop.
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
classes := SortedCollection new.
globals := SortedCollection new.
dict keysAndValuesDo: [:eachKey :eachValue |
  eachValue isClass ifTrue: [
		eachValue asOop == selectedClassOop ifTrue: [
      class := eachValue.
      selectors := class selectors.
    ].
    classes add: eachKey -> (Dictionary new
      at: 'name' put: eachKey;
      at: 'oop' put: (eachValue asOop printStringRadix: 16 showRadix: false);
      yourself).
  ] ifFalse: [
    globals add: eachKey -> (Dictionary new
      at: 'name' put: eachKey;
      at: 'class' put: eachValue class name asString;
      yourself).
  ].
].
result 
  at: 'class' put: (Dictionary new
    at: 'definition' put: (class ifNil: [
        'Object subclass: ''MyNewClass'' '
      ] ifNotNil: [
        class definition.
    ]);
    yourself);
  at: 'classes' put: (classes asArray collect: [:each | each value]);
  at: 'globals' put: (globals asArray collect: [:each | each value]);
  yourself.
result at: 'methods' put: (selectors asSortedCollection collect: [:eachSelector |
  | eachMethod |
  eachMethod := class compiledMethodAt: eachSelector.
  eachMethod asOop == selectedMethodOop ifTrue: [
    method := eachMethod.
  ].
  Dictionary new
    at: 'name' put: eachSelector;
    at: 'oop' put: (eachMethod asOop printStringRadix: 16 showRadix: false);
    yourself.
]).
result at: 'method' put: Dictionary new.
method ifNotNil: [
  (result at: 'method')
    at: 'selector' put: method selector;
    at: 'source' put: method sourceString;
    yourself.
].
result asJson] valueWithArguments:
''');
  }
}
