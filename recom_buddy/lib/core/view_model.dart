import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:recom_buddy/core/vm_state.dart';

abstract class ViewModel<TYPE>{

  @protected
  final StreamController<VMState<TYPE>> viewModelState = StreamController.broadcast();

  Stream<VMState<TYPE>> get vMState => viewModelState.stream;

  @protected
  void launch(Future Function() onLaunch){
    onLaunch.call().then((value){
      viewModelState.sink.add(VMState(data: value));
    }).catchError((error){
      viewModelState.sink.add(VMState(error: error?.toString() ?? "An unknown exception has occurred"));
    });
  }

  Future<void> destroy() async{
    if(await viewModelState.done){
      viewModelState.close();
    }
  }
}