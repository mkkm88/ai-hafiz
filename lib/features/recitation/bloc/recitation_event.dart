import 'package:equatable/equatable.dart';
import '../../quran_data/models/juz.dart';
import '../../quran_data/models/surah.dart';

sealed class RecitationEvent extends Equatable {
  const RecitationEvent();

  @override
  List<Object?> get props => [];
}

final class LoadRecitation extends RecitationEvent {
  final Surah? surah;
  final Juz? juz;

  const LoadRecitation({this.surah, this.juz});

  @override
  List<Object?> get props => [surah, juz];
}

final class StartListening extends RecitationEvent {}

final class StopListening extends RecitationEvent {}

final class ProcessAudio extends RecitationEvent {
  final String audioPath;
  const ProcessAudio(this.audioPath);
}

final class PlayHint extends RecitationEvent {}

final class NextVerse extends RecitationEvent {}

final class PreviousVerse extends RecitationEvent {}
