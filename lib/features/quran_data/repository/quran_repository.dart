import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/surah.dart';
import '../models/verse.dart';
import '../models/juz.dart';

class QuranRepository {
  List<Surah>? _cachedMetadata;

  Future<List<Surah>> getAllSurahs() async {
    if (_cachedMetadata != null) return _cachedMetadata!;

    try {
      final jsonString = await rootBundle.loadString('assets/json/surah.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      _cachedMetadata = jsonList
          .map((json) => Surah.fromJsonMetadata(json))
          .toList();
      return _cachedMetadata!;
    } catch (e) {
      throw Exception('Failed to load surah metadata: $e');
    }
  }

  Future<List<Juz>> getJuzList() async {
    try {
      final jsonString = await rootBundle.loadString('assets/json/juz.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Juz.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load juz list: $e');
    }
  }

  Future<List<Verse>> getVerses(int surahNumber) async {
    try {
      final String filename =
          'assets/json/surah/surah_${surahNumber.toString()}.json';
      final jsonString = await rootBundle.loadString(filename);
      final Map<String, dynamic> json = jsonDecode(jsonString);

      final Map<String, dynamic> versesMap = json['verse'];
      final List<Verse> verses = [];

      versesMap.forEach((key, value) {
        // key format: "verse_1"
        final verseNum = int.parse(key.split('_')[1]);
        verses.add(
          Verse(
            number: verseNum,
            text: value,
            audioPath: getAudioFileName(surahNumber, verseNum),
          ),
        );
      });

      // Sort by verse number
      verses.sort((a, b) => a.number.compareTo(b.number));

      return verses;
    } catch (e) {
      throw Exception('Failed to load verses for surah $surahNumber: $e');
    }
  }

  Future<List<Verse>> getJuzVerses(Juz juz) async {
    List<Verse> allVerses = [];
    try {
      for (int i = juz.startSurah; i <= juz.endSurah; i++) {
        final surahVerses = await getVerses(i);

        List<Verse> filtered = surahVerses;
        if (i == juz.startSurah) {
          filtered = filtered.where((v) => v.number >= juz.startVerse).toList();
        }
        if (i == juz.endSurah) {
          filtered = filtered.where((v) => v.number <= juz.endVerse).toList();
        }

        allVerses.addAll(filtered);
      }
      return allVerses;
    } catch (e) {
      throw Exception('Failed to load verses for juz ${juz.number}: $e');
    }
  }

  String getAudioFileName(int surahNumber, int verseNumber) {
    // Format: 001001.mp3
    final s = surahNumber.toString().padLeft(3, '0');
    final v = verseNumber.toString().padLeft(3, '0');
    return '$s$v.mp3';
  }
}
