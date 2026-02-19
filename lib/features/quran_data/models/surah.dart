import 'package:ai_hafiz/features/quran_data/models/verse.dart';

class Surah {
  final int number;
  final String title;
  final String titleAr;
  final String content; // full text maybe? No, keep it per verse.
  final int verseCount;
  final String place; // Mecca or Medina
  final String type; // Makkiyah or Madaniyah
  final List<Verse> verses;

  const Surah({
    required this.number,
    required this.title,
    required this.titleAr,
    required this.verseCount,
    required this.place,
    required this.type,
    this.verses = const [],
    this.content = '',
  });

  factory Surah.fromJsonMetadata(Map<String, dynamic> json) {
    return Surah(
      number: int.parse(json['index']),
      title: json['title'],
      titleAr: json['titleAr'],
      verseCount: json['count'],
      place: json['place'],
      type: json['type'],
      verses: [],
    );
  }
}
