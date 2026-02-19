import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';

class GoogleSttService {
  final String _apiKey = ApiConstants.googleApiKey;
  final String _apiUrl = 'https://speech.googleapis.com/v1/speech:recognize';

  // For real usage, we should detect this from the audio file.
  // Assuming 16k PCM Linear for now as it's common for backend processing.
  Future<String> recognizeAudioBytes(Uint8List audioBytes) async {
    try {
      final String content = base64Encode(audioBytes);

      final Map<String, dynamic> requestBody = {
        "config": {
          "encoding": "LINEAR16",
          "sampleRateHertz": 16000,
          "languageCode": "ar-SA",
          "enableAutomaticPunctuation": false,
          "model": "command_and_search",
        },
        "audio": {"content": content},
      };

      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('results')) {
          final List<dynamic> results = jsonResponse['results'];
          if (results.isNotEmpty) {
            final firstResult = results[0];
            final alternatives = firstResult['alternatives'] as List<dynamic>;
            if (alternatives.isNotEmpty) {
              return alternatives[0]['transcript'] as String;
            }
          }
        }
        return ""; // No result found
      } else {
        throw Exception(
          'Google STT Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to recognize audio: $e');
    }
  }
}
