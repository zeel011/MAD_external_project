import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;

  Future<bool> initialize() async {
    bool available = await _speechToText.initialize();
    if (available) {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5);
    }
    return available;
  }

  Future<void> startListening() async {
    if (!_isListening) {
      _isListening = true;
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            _processCommand(result.recognizedWords);
          }
        },
      );
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      _isListening = false;
      await _speechToText.stop();
    }
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _processCommand(String command) {
    // TODO: Implement command processing logic
    print('Processing command: $command');
  }
} 