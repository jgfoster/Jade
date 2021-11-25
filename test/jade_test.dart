import 'package:flutter_test/flutter_test.dart';

import 'package:jade/model/jade.dart';

void main() {
  test('singleton', () {
    var jade1 = Jade();
    var jade2 = Jade();
    expect(identical(jade1, jade2), true);
  });

  test('logins size', () {
    var jade = Jade();
    var logins = jade.loginList;
    expect(logins.length, 1);
  });
}
