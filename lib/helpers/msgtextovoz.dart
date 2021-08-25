import 'package:flutter_tts/flutter_tts.dart';

Future<void> setStartHandler(String msg, num velocidade) async {
  var flutterTts = FlutterTts();
  await flutterTts.setSpeechRate(velocidade);
  await flutterTts.awaitSpeakCompletion(true);
  var result = await flutterTts.speak(msg);
}

Future sleep2() {
  return new Future.delayed(const Duration(seconds: 2), () => "2");
}
