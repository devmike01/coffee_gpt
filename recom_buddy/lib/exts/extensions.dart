import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension Widgets on BuildContext{
  void showSnackbar({required String message, bool inWidget=false}){
    if(inWidget){
      addPostFrameCallback((){
        _showSnackbar(message: message);
      });

      return;
    }
    _showSnackbar(message: message);
  }

  void addPostFrameCallback(Function f1){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      f1.call();
    });
  }

  void _showSnackbar({required String message}){
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}