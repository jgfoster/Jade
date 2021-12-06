// ContactWidget displays a Contact

import 'package:flutter/material.dart';
import 'package:jade/model/contact.dart';
import 'package:provider/provider.dart';

class ContactWidget extends StatefulWidget {
  final Contact _contact;
  const ContactWidget(this._contact, {Key? key}) : super(key: key);

  @override
  _ContactWidget createState() {
    // ignore: no_logic_in_create_state
    return _ContactWidget(_contact);
  }
}

class _ContactWidget extends State<ContactWidget> {
  final Contact _contact;

  _ContactWidget(this._contact);

  Widget _builder(var context, var contact, var child) {
    return const Text('Contact');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _contact,
      child: Consumer<Contact>(builder: _builder),
    );
  }
}
