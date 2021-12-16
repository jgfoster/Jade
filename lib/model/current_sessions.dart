import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/session.dart';

class CurrentSessions extends JadeModel {
  static Widget getIcon() => const Icon(Icons.people_outline);
  static String getTitle() => 'Current Sessions';

  final Session _session;
  Map<String, dynamic> _result = {'string': ''};

  CurrentSessions(this._session);

  get icon => getIcon();
  get result => _result;
  get title => getTitle();

  String _code() {
    return '''
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
  }

  void close() {
    _session.removeChild(this);
  }

  @override
  void updateState() async {
    _result = await _session.execute(_code());
    notifyListeners();
  }
}
