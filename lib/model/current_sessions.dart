import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/session.dart';

class CurrentSessions extends JadeModel {
  final Session _session;
  Map<String, dynamic> _result = {'string': ''};
  var code = '''
| stream |
stream := WriteStream on: String new.
System currentSessions do: [:each |
	| descr |
	descr := System descriptionOfSession: each.
	descr ifNotNil: [
		stream
			print: each; tab;
			nextPutAll: (descr at: 1) userId; tab;
			print: (descr at: 2); tab;
			nextPutAll: (descr at: 3); tab;
			print: (descr at: 4); tab;
			lf.
	].
].
stream contents.
''';

  get result => _result;
  get title => const Text('Current Sessions');

  CurrentSessions(this._session);

  @override
  void selectionStatusChanged() async {
    _result = await _session.execute(code);
    notifyListeners();
  }
}