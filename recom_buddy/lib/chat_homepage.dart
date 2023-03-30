
import 'package:flutter/material.dart';
import 'package:recom_buddy/exts/extensions.dart';
import 'package:recom_buddy/chat_home_viewmodel.dart';
import 'package:recom_buddy/models/gpt_chat.dart';

import 'api_manager.dart';
import 'core/recom_stream_builder.dart';
import 'core/vm_state.dart';


class ChatHomepage extends StatefulWidget {
  ChatHomepage({super.key, required this.title});
  final String title;


  @override
  State<ChatHomepage> createState() => _ChatHomepageState();
}

class _ChatHomepageState extends State<ChatHomepage> with SingleTickerProviderStateMixin {


  late List<GptChat> chatGptRes;
  TextEditingController problemController = TextEditingController();
  // In real project, this would be injected using a plugin
  ChatHomeViewModel viewModel = ChatHomeViewModel(ApiManager.instance);
  final ScrollController _chatController = ScrollController();


  void _solveProblem() {
    if(problemController.text.isEmpty){
      context.showSnackbar(message: 'Field cannot be empty!');
      return;
    }
    viewModel.solveProblem(problemController.text);
    problemController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            _buildResult(),
            Align(alignment: Alignment.bottomCenter,child: _buildQField(),)
          ],
        ),)),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     problemController.clear();
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildProgressBar({Widget? child}){
    return Column(
      children: [
        _buildQField(),
        //LinearProgressIndicator()
      ],
    );
  }
  Widget _buildQField(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Container(
          color: Colors.white,
          child: TextField(
            controller: problemController,
            decoration: const InputDecoration(
                icon: Icon(Icons.camera_rounded)
            ),
          ),
        )),
        Expanded(flex: 0,child: FloatingActionButton(
          onPressed: _solveProblem,
          tooltip: 'Increment',
          child: const Icon(Icons.send),
        ),)
      ],
    );
  }
  Widget _buildResult(){
    return Padding(padding: const EdgeInsets.all(20),
      child: RStreamBuilder<List<GptChat>>(
          stream: viewModel.vMState,
          //loading: const Center(child: CircularProgressIndicator(),),
          builder: (BuildContext context, List<GptChat>? data,
              String? error, Event? event){
            if(event is None){
              return Container();
            }

            if(error != null){
              context.showSnackbar(message: 'Error: $error', inWidget: true);
            }
            if(data != null){
              chatGptRes =  List.from(data);
            }
            return Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 50),
              child: _buildChatList(event),
            );
          }),);
  }

  Widget _buildChatList(Event? event){
    final length = chatGptRes.length;
    return ListView.builder(
        shrinkWrap: true,
        controller: _chatController,
        itemCount: length,
        itemBuilder: (context, index){
          final children = <Widget>[
            _chaBubble(index),
          ];
          if(event is GptTyping){
            if(index == length-1){
              children.add(Expanded(flex: 0,child: Text(event.msg,
                style: const TextStyle(fontStyle: FontStyle.italic),),));
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        });
  }
  Widget _chaBubble(int index){
    GptChat chat = chatGptRes[index];
    final isHuman = chat.isHuman;
    final chatChildren = [
      Expanded(flex: 0,child: Container(
        height: 30,
        width: 30,
        margin: EdgeInsets.only(left: isHuman ? 10 : 0,
            right: isHuman ? 0 : 10 ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isHuman ? Colors.blue : Colors.green,
        ),
        child: Icon(isHuman ? Icons.account_circle_rounded : Icons.adb, size: 28,),
      ),),
      Expanded(child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: isHuman ? Colors.green : Colors.blue,
            border: Border.all(color: Colors.blueGrey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Text(chat.message, style: TextStyle(fontWeight: FontWeight.w600),),
      ))
    ];
    context.addPostFrameCallback(() {
      _chatController.jumpTo(_chatController.position.maxScrollExtent);
    });
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isHuman ? chatChildren.reversed.toList(): chatChildren,
    );
  }

}
