class Verse {
  final int number;
  final String text;
  final String audioPath;

  const Verse({
    required this.number,
    required this.text,
    required this.audioPath,
  });

  factory Verse.fromJson(int number, String text, int surahNumber) {
    // Format: 001001.mp3 (3 digits surah, 3 digits verse)
    // Audio path is relative or just the filename that the audio player will use
    String surahPadded = surahNumber.toString().padLeft(3, '0');
    String versePadded = number.toString().padLeft(3, '0');
    return Verse(
      number: number,
      text: text,
      audioPath: "$surahPadded$versePadded.mp3",
    );
  }
}
