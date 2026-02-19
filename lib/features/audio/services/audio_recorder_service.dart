import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  StreamSubscription<RecordState>? _recordSub;
  StreamSubscription<Amplitude>? _amplitudeSub;

  bool _isRecording = false;

  Stream<Amplitude> get onAmplitudeChanged =>
      _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 100));

  Future<void> start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String audioPath = '${appDocDir.path}/temp_recording.wav';

        // Start recording to file
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: audioPath,
        );
        _isRecording = true;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error starting recorder: $e");
      }
    }
  }

  Future<String?> stop() async {
    try {
      if (!_isRecording) return null;
      final path = await _audioRecorder.stop();
      _isRecording = false;
      return path;
    } catch (e) {
      if (kDebugMode) {
        print("Error stopping recorder: $e");
      }
      return null;
    }
  }

  Future<void> dispose() async {
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
  }

  bool isRecording() => _isRecording;
}
