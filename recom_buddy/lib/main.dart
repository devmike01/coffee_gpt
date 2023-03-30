import 'package:flutter/material.dart';
import 'package:recom_buddy/main_view_model.dart';
import 'package:recom_buddy/models/gpt_chat.dart';

import 'api_manager.dart';
import 'core/recom_stream_builder.dart';
import 'core/vm_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController problemController = TextEditingController();
  // In real project, this would be injected using a plugin
  MainViewModel viewModel = MainViewModel(ApiManager.instance);


  void _solveProblem() {
    if(problemController.text.isEmpty){
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Field cannot be empty!')));
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
        Expanded(child: TextField(
          controller: problemController,
          decoration: const InputDecoration(
              icon: Icon(Icons.camera_rounded)
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
          if(data == null){
            return Container();
          }

          final chatGptRes = List.from(data);
          return Container(
            color: Colors.white,
            child: ListView.builder(
                itemCount: chatGptRes.length,
                itemBuilder: (context, index){
                  return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Text(chatGptRes[index]),
                  );
                }),
          );
        }),);
  }

}
