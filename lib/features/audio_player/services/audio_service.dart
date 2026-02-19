import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playAudio(String path) async {
    try {
      // Logic to determine if asset or local file
      // For now, assume it's an asset for testing, or a file path if absolute
      if (path.startsWith('/')) {
        await _player.setFilePath(path);
      } else {
        // Assume asset for now, e.g. assets/audio/001001.mp3
        // If not found, it might throw.
        await _player.setAsset('assets/audio/$path');
      }
      await _player.play();
    } catch (e) {
      throw Exception('Failed to play audio: $e');
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
