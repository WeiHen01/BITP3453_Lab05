import 'dart:convert'; //json encode/decode
import 'package:http/http.dart' as http;

class RequestController {
  String path;
  String server;
  var _res;
  final Map<dynamic, dynamic> _body = {};
  final Map<String, String> _headers = {};
  dynamic _resultData;

  /**
   * constructor
   */
  RequestController({required this.path, this.server =
  "http://10.0.2.2" /*10.0.0.2 for emulated device*/});
  setBody(Map<String, dynamic> data){
    _body.clear();
    _body.addAll(data);
    _headers["Content-Type"] = "application/json; charset=UTF-8";
  }

  Future<void> post() async {
    _res = await http.post(
      Uri.parse(server + path),
      headers: _headers,
      body: jsonEncode(_body),
    );

    _parseResult();
  }

  Future<void> get() async {
    _res = await http.get(
      Uri.parse(server + path),
      headers: _headers,
    );
    _parseResult();
  }

  void _parseResult(){
    // parse result into json structure if possible
    try{
      print("raw response:${_res?.body}");
      _resultData = jsonDecode(_res?.body?? "");
    }catch(ex){
      // otherwise the response body will be stored as is
      _resultData = _res?.body;
      print("exception in http result parsing ${ex}");
    }
  }
  dynamic result(){
    return _resultData;
  }

  int status(){
    return _res?.statusCode ?? 0;
  }


}