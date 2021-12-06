// CurrentSessionsWidget displays a list of the current sessions

import 'package:flutter/material.dart';
import 'package:jade/model/contact_list.dart';
import 'package:provider/provider.dart';

class ContactListWidget extends StatefulWidget {
  final ContactList _contactList;
  const ContactListWidget(this._contactList, {Key? key}) : super(key: key);

  @override
  _ContactListWidget createState() {
    // ignore: no_logic_in_create_state
    return _ContactListWidget(_contactList);
  }
}

class _ContactListWidget extends State<ContactListWidget> {
  final ContactList _contactList;

  _ContactListWidget(this._contactList);

  Widget _builder(var context, var contactList, var child) {
    var tableRows = <TableRow>[];
    var string = contactList.result['string'];
    string.split('\n').forEach((eachLine) {
      if (eachLine.length > 0) {
        var cells = <Widget>[];
        eachLine.split('\t').forEach((eachCell) {
          if (cells.length < 5) {
            cells.add(
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(eachCell),
              ),
            );
          }
        });
        tableRows.add(TableRow(children: cells));
      }
    });
    var table = Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: tableRows,
    );

    var buttonRow = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () => _contactList.newContact(),
              child: const Text('New'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () => _contactList.editContact(),
              child: const Text('Edit'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () => _contactList.begin(),
              child: const Text('Begin'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () => _contactList.commit(),
              child: const Text('Commit'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () => _contactList.abort(),
              child: const Text('Abort'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () => _contactList.refresh(),
              child: const Text('Refersh'),
            ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        table,
        Expanded(child: buttonRow),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _contactList,
      child: Consumer<ContactList>(builder: _builder),
    );
  }
}
