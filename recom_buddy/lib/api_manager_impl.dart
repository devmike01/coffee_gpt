import 'dart:convert';

import 'package:http/http.dart';

import 'api_manager.dart';

class ApiManagerImpl extends ApiManager{
  ApiManagerImpl._privateInstance();

  static final ApiManagerImpl instance = ApiManagerImpl._privateInstance();

  List<String> contentList = [];

  @override
  Future<List<String>> getSuggestions(String content)async{
    try{
      final response = await get(Uri.parse('http://127.0.0.1:8000/suggest?content=$content'));
      final decodedData = Map.from(jsonDecode(response.body));
      final data = decodedData['data'][0];
      final message = data['message'];
      contentList.add(message['content']);
      print("object: $message");
      return contentList;
    }catch(exception){
      return Future.error(exception);
    }
  }
}