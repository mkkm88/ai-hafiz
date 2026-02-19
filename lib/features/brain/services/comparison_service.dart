class TextComparisonService {
  String normalizeArabic(String input) {
    if (input.isEmpty) return "";

    // Remove Diacritics (Tashkeel)
    String normalized = input.replaceAll(
      RegExp(r'[\u064B-\u065F\u0670\u0671]'),
      '',
    );

    // Normalize Alephs (أآإ -> ا)
    normalized = normalized.replaceAll(RegExp(r'[أآإ]'), 'ا');

    // Normalize Taa Marbuta (ة -> ه) for more lenient matching
    normalized = normalized.replaceAll('ة', 'ه');

    // Normalize Ya (ى -> ي)
    normalized = normalized.replaceAll('ى', 'ي');

    // Remove extra whitespace
    return normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  // Calculate Levenshtein Distance
  int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = [
          v1[j] + 1, // Deletion
          v0[j + 1] + 1, // Insertion
          v0[j] + cost, // Substitution
        ].reduce((a, b) => a < b ? a : b);
      }

      for (int j = 0; j < t.length + 1; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[t.length];
  }

  /// Returns similarity score (0.0 to 1.0)
  /// 1.0 means perfect match.
  double compare(String original, String spoken) {
    String normOriginal = normalizeArabic(original);
    String normSpoken = normalizeArabic(spoken);

    if (normOriginal.isEmpty || normSpoken.isEmpty) return 0.0;
    if (normOriginal == normSpoken) return 1.0;

    int distance = _levenshtein(normOriginal, normSpoken);
    int maxLength = normOriginal.length > normSpoken.length
        ? normOriginal.length
        : normSpoken.length;

    if (maxLength == 0) return 0.0;

    return 1.0 - (distance / maxLength);
  }

  bool isCorrect(String original, String spoken, {double threshold = 0.75}) {
    return compare(original, spoken) >= threshold;
  }
}
