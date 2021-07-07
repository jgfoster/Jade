import 'package:http/http.dart' as http;
import 'dart:convert';

class GciError extends StateError {
  late final error;
  GciError(Map<String, dynamic> gciError)
      : error = gciError,
        super(gciError['message']);
}

class GciSession {
  late final host;
  int session = 0;
  final headers = {'Content-Type': 'application/json'};

  GciSession(this.host);

  Future<String> post(String name, Map<String, dynamic> body) async {
    final url = Uri.parse(host + name);
    body['session'] = session;
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw StateError(response.body);
    }
    return response.body;
  }

  Future<Map<String, dynamic>?> getError() async {
    return jsonDecode(await post('getError.gs', {}))['result'];
  }

  Future<void> abort() async {
    await post('abort.gs', {});
  }

  Future<void> begin() async {
    await post('begin.gs', {});
  }

  Future<bool> commit() async {
    return jsonDecode(await post('commit.gs', {}))['result'];
  }

  Future<int> getSessionId() async {
    return jsonDecode(await post('getSessionId.gs', {}))['result'];
  }

  Future<String> getVersion() async {
    return jsonDecode(await post('version.gs', {}))['result'];
  }

  Future<void> hardBreak() async {
    await post('hardBreak.gs', {});
  }

  Future<bool> isCallInProgress() async {
    return jsonDecode(await post('callInProgress.gs', {}))['result'];
  }

  Future<void> login(String username, String password) async {
    if (session > 0) {
      throw StateError('Session already logged in!');
    }
    Map<String, dynamic> body = {
      'username': username,
      'password': password,
    };
    var response = await post('login.gs', body);
    final result = jsonDecode(response);
    session = result['result'] ?? 0;
    if (session > 0) {
      return;
    }
    throw GciError(result);
  }

  Future<void> logout() async {
    await post('logout.gs', {});
  }

  Future<void> nbExecuteStr(String source) async {
    await post('nbExecuteStr.gs', {'source': source});
  }

  /*
  typedef enum {
    GCI_RESULT_NOT_READY  = 0,  /* nothing happened */
    GCI_RESULT_PROGRESSED = 1,	/* a packet was received */
    GCI_RESULT_READY      = 2,  /* your result is now ready */
    GCI_RESULT_HAS_ERROR  = 3   /* result is ready with error */
  } GciNbProgressEType;
  */
  Future<Map<String, dynamic>> nbEnd() async {
    return jsonDecode(await post('nbEnd.gs', {}));
  }

  Future<void> softBreak() async {
    await post('softBreak.gs', {});
  }
}
