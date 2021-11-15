class GciError extends StateError {
  late final Map<String, dynamic> error;
  GciError(Map<String, dynamic> gciError)
      : error = gciError,
        super(gciError['message']);
}
/*
  Because of the difficulty of representing a true 64-bit integer
  in Dart/JavaScript, we treat a Session ID and an OOP as a
  string representing the hex digits of the actual integer.
  This should be fine since all client code should treat these
  as opaque objects. (We could cut this down to a maximum of eleven
  characters by using Base64 encoding, but that seems unnecessary.)
 */

abstract class JadeServerAbstract {
  static const oopNil = '14';

  Future<bool> abort(String session);
  Future<bool> begin(String session);
// 'break' is a reserved word!
  Future<bool> doBreak(String session, bool isHard);
  Future<String> charToOop(int anOop);
  void close();
  Future<bool> commit(String session);
  Future<String> doubleToOop(String session, double value);
  Future<String> doubleToSmallDouble(double value);
  Future<String> encrypt(String password);
  Future<bool> execute(String session, String code);
  Future<String> fetchSpecialClass(String anOop);
  Future<String> fetchUnicode(String session, String anOop);
  Future<List<String>> getFreeOops(String session, int count);
  Future<String> getGciVersion();
  Future<String> i32ToOop(int value);
  Future<String> i64ToOop(String session, BigInt value);
  Future<String> login(String username, String password);
  Future<bool> logout(String session);
  Future<Map<String, dynamic>> nbResult(String session, [int timeoutMs = 0]);
  Future<String> newByteArray(String session, List<int> bytes);
  Future<String> newObj(String session, String classOop);
  Future<String> newString(String session, String string);
  Future<String> newSymbol(String session, String string);
  Future<String> newUnicodeString(String session, var bytes);
  Future<String> newUtf8String(String session, var bytes);
  Future<bool> oopIsSpecial(String anOop);
  Future<int> oopToChar(String anOop);
  Future<num> oopToDouble(String session, String anOop);
  Future<BigInt> oopToI64(String session, String anOop,
      [String symbolList = oopNil]);
  Future<String> resolveSymbol(String session, String symbol,
      [String symbolList = oopNil]);
  Future<String> resolveSymbolObj(String session, String anOop,
      [String symbolList = oopNil]);
  Future<bool> sessionIsRemote(String session);
}
