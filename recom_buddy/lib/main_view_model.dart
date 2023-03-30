import 'package:recom_buddy/core/view_model.dart';

import 'api_manager.dart';
import 'core/vm_state.dart';
import 'models/gpt_chat.dart';

class MainViewModel extends ViewModel<List<GptChat>>{

  final ApiManager _apiManager;

  MainViewModel(this._apiManager);

  List<GptChat> chats = [];

  void solveProblem(String problemStr){
    chats.add(GptChat(problemStr, true));
    viewModelState.add(VMState(data: chats, event: Loading()));
    launch(() async{
      chats.add(GptChat( (await _apiManager.getSuggestions(problemStr)).last, false));
      return chats;
    });
  }

  void addMyChat(){

  }

}