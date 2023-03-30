import 'package:flutter/cupertino.dart';
import 'package:recom_buddy/core/vm_state.dart';

class RStreamBuilder<T> extends StatelessWidget{

  final Widget? loading;

  final Stream<VMState<T>> stream;

  Widget Function(BuildContext, T?, String? error, Event? event)? builder;

   RStreamBuilder({super.key, required this.stream,
    required this.builder, this.loading});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VMState<T>>(builder: (context, snapshot){
      if(!snapshot.hasData && !snapshot.hasError && loading !=null){
        return loading!;
      } else  if(snapshot.hasError){
        return builder!.call(context, null, snapshot.error.toString(), null);
      }else if(snapshot.hasData){
        final state = snapshot.requireData;
        if(state.hasData){
          return builder!.call(context, state.data, null, null);
        }else if(state.hasError){
          return builder!.call(context, null, snapshot.error.toString(), null);
        }else if(state.isEvent){
         return builder!.call(context, null, null, state.event);
        }
      }
      return builder!.call(context, null, null, null);
    }, stream: stream,);
  }

}