class GptChat{
  String message;
  bool isHuman;

  GptChat(this.message, this.isHuman);

  @override
  String toString() {
    // TODO: implement toString
    return '{message: $message, isHuman: $isHuman}';
  }
}