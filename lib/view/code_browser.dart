// CurrentSessionsWidget displays a list of the current sessions

import 'package:flutter/material.dart';
import 'package:jade/model/code_model.dart';
import 'package:jade/view/open_nav_drawer.dart';
import 'package:provider/provider.dart';

class CodeBrowser extends StatefulWidget {
  final CodeModel _codeModel;
  const CodeBrowser(this._codeModel, {Key? key}) : super(key: key);

  @override
  _CodeBrowser createState() {
    return _CodeBrowser();
  }
}

class _CodeBrowser extends State<CodeBrowser> {
  _CodeBrowser();

  // Set up notification for changes in the CodeModel
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget._codeModel,
      child: Consumer<CodeModel>(builder: _builder),
    );
  }

  Widget _builder(var context, var codeModel, var child) {
    return Column(
      children: [
        // Button row
        Row(
          children: [
            const OpenNavDrawer(),
            // Commit transaction
            IconButton(
              icon: const Icon(Icons.photo_camera_outlined),
              tooltip: 'Commit transaction',
              onPressed: () async {
                // var result = await widget._codeModel!.commit();
                setState(() {
                  // print(result);
                });
              },
            ),
            // Abort transaction
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete_outlined),
                  tooltip: 'Abort transaction',
                  onPressed: () async {
                    // var result = await widget._codeModel!.commit();
                    setState(() {
                      // print(result);
                    });
                  },
                ),
              ),
            ),
            // Close page
            IconButton(
              icon: const Icon(Icons.close_outlined),
              tooltip: 'Close browser',
              onPressed: () async {
                // var result = await widget._codeModel!.commit();
                setState(() {
                  // print(result);
                });
              },
            ),
          ],
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Placeholder(),
              ),
              Expanded(
                child: Placeholder(),
              ),
              Expanded(
                child: Placeholder(),
              ),
              Expanded(
                child: Placeholder(),
              ),
              Expanded(
                child: Placeholder(),
              ),
            ],
          ),
        ),
        Expanded(
          child: Placeholder(),
        ),
      ],
    );
  }
}
