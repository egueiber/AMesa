import 'package:flutter_tts/flutter_tts.dart';

Future<void> setStartHandler(String msg, num velocidade) async {
  var flutterTts = FlutterTts();
  // await flutterTts.stop();
  await flutterTts.setLanguage('pt-BR');
  await flutterTts.setSpeechRate(velocidade);
  await flutterTts.awaitSpeakCompletion(true);
  await flutterTts.speak(msg);
}

Future sleep2() {
  return new Future.delayed(const Duration(seconds: 2), () => "2");
}
