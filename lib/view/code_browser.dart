// CurrentSessionsWidget displays a list of the current sessions

import 'dart:math';

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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Expanded(child: _dictionaries(context)),
            Expanded(child: _classCategories(context)),
            Expanded(child: _classes(context)),
            Expanded(child: _methodCategories(context)),
            Expanded(child: _methods(context)),
          ],
        ),
      ),
    );
  }

  Widget _dictionaries(context) {
    return _list(
      context,
      _codeModel.dictionaries,
      (each) => _codeModel.selectDictionary(each),
    );
  }

  Widget _classCategories(context) {
    return const Placeholder();
  }

  Widget _classes(context) {
    return _list(
      context,
      _codeModel.classes,
      (each) => _codeModel.selectClass(each),
    );
  }

  Widget _methodCategories(context) {
    return const Placeholder();
  }

  Widget _methods(context) {
    return _list(
      context,
      _codeModel.methods,
      (each) => _codeModel.selectMethod(each),
    );
  }

  Widget _list(var context, var list, var onPressed) {
    final selectedColor = Theme.of(context).colorScheme.primary;
    const unselectedColor = Colors.black;
    var size = 0.0;
    // calculate maximum width (<2ms for ~650 items)
    for (var each in list) {
      final TextPainter textPainter = TextPainter(
          text: TextSpan(text: each.name),
          maxLines: 1,
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: double.infinity);
      size = max(size, textPainter.size.width);
    }
    // return textPainter.size;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: size + 30,
        child: ListView.builder(
          itemCount: list.length,
          itemExtent: 20.0,
          controller: ScrollController(),
          itemBuilder: (BuildContext context, int index) {
            var each = list[index];
            var name = each.name;
            return TextButton(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: TextStyle(
                    color: each.isSelected ? selectedColor : unselectedColor,
                  ),
                ),
              ),
              onPressed: () => onPressed(each),
            );
          },
        ),
      ),
    );
  }

  Widget _editors() {
    return const Expanded(
      child: Placeholder(),
    );
  }
}
