import 'package:recom_buddy/core/view_model.dart';

import 'api_manager.dart';
import 'core/vm_state.dart';
import 'models/gpt_chat.dart';

class ChatHomeViewModel extends ViewModel<List<GptChat>>{

  final ApiManager _apiManager;

  ChatHomeViewModel(this._apiManager);

  List<GptChat> chats = [];

  void solveProblem(String problemStr) async{
    chats.add(GptChat(problemStr, true));
    viewModelState.add(VMState(data: chats, event: Loading()));
    await Future.delayed(Duration(milliseconds: 300), (){
      viewModelState.add(VMState(data: null, event: GptTyping()));
    });
    launch(() async{
      chats.add(GptChat( (await _apiManager.getSuggestions(problemStr)).last, false));
      return chats;
    });
  }

}