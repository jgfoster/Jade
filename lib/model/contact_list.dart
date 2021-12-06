import 'package:flutter/material.dart';
import 'package:jade/model/jade_model.dart';
import 'package:jade/model/session.dart';

class ContactList extends JadeModel {
  final Session _session;
  Map<String, dynamic> _result = {'string': ''};

/*
  String get _doSetup {
    return '''
| segment dict newUser list |
(AllUsers anySatisfy: [:each | each userId = 'Staff']) ifTrue: [
	System transactionMode: #manualBegin.
	^self
].
segment := Segment newInRepository: SystemRepository.
segment group: 'Publishers' authorization: #'write'.
segment group: 'Subscribers' authorization: #'read'.
UserGlobals
	at: #'ContactsSecurityPolicy'
	put: segment.
System commitTransaction ifFalse: [nil error: 'commit failed'].

list := IdentityBag new.
list assignToSegment: segment.
list
		add: (Array with: 'James Foster' 	with: 'GemTalk VP' 		    with: '+1 503-766-4714');
		add: (Array with: 'Timothy Cook'	with: 'Apple CEO' 			  with: '+1 408-996-1010');
		add: (Array with: 'Bill Gates' 		with: 'Microsoft Founder'	with: '+1 800-Microsoft');
		add: (Array with: 'Larry Ellison'	with: 'Oracle CEO'			  with: '+1 650-506-7000');
		yourself.
(dict := SymbolDictionary new)
	at: #'ContactsGlobals' put: dict;
	at: #'ContactsSecurityPolicy' put: segment;
	at: #ContactList put: list;
	assignToSegment: segment;
	yourself.
(AllUsers userWithId: 'DataCurator') insertDictionary: dict at: 1.
System commitTransaction ifFalse: [nil error: 'commit failed'].

newUser := AllUsers
	addNewUserWithId: 'Staff'
	password: 'swordfish'.
newUser addGroup: 'Subscribers'.
((System stoneVersionReport at: #'gsVersion') first = \$6) ifFalse: [
	newUser addPrivilege: 'CodeModification'.
].
newUser insertDictionary: dict at: 1.
System commitTransaction ifFalse: [nil error: 'commit failed'].
System transactionMode: #manualBegin.
true
    ''';
  }
*/

  String get _readContactList {
    return '''
| i stream |
i := 0.
[
ContactsGlobals includesKey: #ContactList.
] whileFalse: [
ContactsGlobals
  at: #ContactList
  put: RcIdentityBag new.
System
  commitTransaction;
  abortTransaction;
  yourself.
i := i + 1.
10 < i ifTrue: [nil error: 'Unable to create ContactList!'].
].
stream := WriteStream on: String new.
(ContactsGlobals at: #ContactList) do: [:eachContact | 	"really (Array with: nameString with: titleString with: phoneString with: version)"
eachContact asOop printOn: stream.
eachContact do: [:each |
  stream tab; nextPutAll: each asString.
].
stream nextPut: Character lf.
].
stream contents.
''';
  }

  get result => _result;
  get title => const Text('Contact List');

  ContactList(this._session) {
    // _session.execute(_doSetup);
  }

  @override
  void selectionStatusChanged() async {
    refresh();
  }

  void newContact() {
    _session.newContact();
  }

  void editContact() {
    // print('editContact()');
  }

  void begin() {
    _session.begin();
  }

  void commit() {
    _session.commit();
  }

  void abort() {
    _session.abort();
  }

  void refresh() async {
    _result = await _session.execute(_readContactList);
    notifyListeners();
  }
}
