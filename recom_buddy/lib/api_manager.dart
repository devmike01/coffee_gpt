

import 'api_manager_impl.dart';

abstract class ApiManager{

  static ApiManager instance = ApiManagerImpl.instance;

  Future<List<String>> getSuggestions(String content);

}