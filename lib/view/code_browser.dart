// CurrentSessionsWidget displays a list of the current sessions

import 'package:flutter/material.dart';
import 'package:jade/model/code_model.dart';
import 'package:jade/view/open_nav_drawer.dart';
import 'package:provider/provider.dart';

class CodeBrowser extends StatelessWidget {
  final CodeModel _codeModel;
  const CodeBrowser(this._codeModel, {Key? key}) : super(key: key);

  // Set up notification for changes in the CodeModel
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _codeModel,
      child: Consumer<CodeModel>(builder: _builder),
    );
  }

  // Three rows: buttons, filters, and editors
  Widget _builder(var context, var codeModel, var child) {
    return Column(
      children: [
        _buttonRow(),
        _filterRow(context),
        _editors(),
      ],
    );
  }

  Widget _buttonRow() {
    return Row(
      children: [
        const OpenNavDrawer(),
        _commitButton(),
        // push abort and close buttons to the right
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: _abortButton(),
          ),
        ),
        _closeButton(),
      ],
    );
  }

  Widget _commitButton() {
    return IconButton(
      icon: const Icon(Icons.photo_camera_outlined),
      tooltip: 'Commit transaction',
      onPressed: () async {
        _codeModel.commit();
      },
    );
  }

  Widget _abortButton() {
    return IconButton(
      icon: const Icon(Icons.delete_outlined),
      tooltip: 'Abort transaction',
      onPressed: () async {
        _codeModel.abort();
      },
    );
  }

  Widget _closeButton() {
    return IconButton(
      icon: const Icon(Icons.close_outlined),
      tooltip: 'Close browser',
      onPressed: () async {
        _codeModel.close();
      },
    );
  }

  Widget _filterRow(context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(child: _dictionaries(context)),
          Expanded(child: _classCategories()),
          Expanded(child: _classes(context)),
          Expanded(child: _methodCategories()),
          Expanded(child: _methods()),
        ],
      ),
    );
  }

  Widget _dictionaries(context) {
    final selectedColor = Theme.of(context).colorScheme.primary;
    const unselectedColor = Colors.black;
    final list = _codeModel.dictionaries;
    return ListView.builder(
      itemCount: list.length,
      itemExtent: 20.0,
      itemBuilder: (BuildContext context, int index) {
        var each = list[index];
        return TextButton(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              each.name,
              style: TextStyle(
                color: each.isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ),
          onPressed: () => _codeModel.selectDictionary(each),
        );
      },
    );
  }

  Widget _classCategories() {
    return const Placeholder();
  }

  Widget _classes(context) {
    final list = _codeModel.classes;
    final selectedColor = Theme.of(context).colorScheme.primary;
    const unselectedColor = Colors.black;
    return ListView.builder(
      itemCount: list.length,
      itemExtent: 20.0,
      itemBuilder: (BuildContext context, int index) {
        var each = list[index];
        return TextButton(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              each.name,
              style: TextStyle(
                color: each.isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ),
          onPressed: () => _codeModel.selectClass(each),
        );
      },
    );
  }

  Widget _methodCategories() {
    return const Placeholder();
  }

  Widget _methods() {
    return const Placeholder();
  }

  Widget _editors() {
    return const Expanded(
      child: Placeholder(),
    );
  }
}
