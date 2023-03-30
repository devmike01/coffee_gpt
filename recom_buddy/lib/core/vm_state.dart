import 'dart:ffi';

class VMState<D>{
  D? data;
  String? error;
  Event? event;
  VMState({this.data, this.error, this.event});

  bool get hasError => error != null;

  bool get hasData => data !=null;

  bool get isEvent => event != null;
}

class Event{}
class ScanEvent extends Event{}
class OpenCameraEvent extends Event{}
class Loading extends Event{}