class Juz {
  final int number;
  final int startSurah;
  final int startVerse;
  final int endSurah;
  final int endVerse;

  const Juz({
    required this.number,
    required this.startSurah,
    required this.startVerse,
    required this.endSurah,
    required this.endVerse,
  });

  factory Juz.fromJson(Map<String, dynamic> json) {
    return Juz(
      number: int.parse(json['index']),
      startSurah: int.parse(json['start']['index']),
      startVerse: int.parse(json['start']['verse'].split('_')[1]),
      endSurah: int.parse(json['end']['index']),
      endVerse: int.parse(json['end']['verse'].split('_')[1]),
    );
  }
}
