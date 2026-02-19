import 'package:equatable/equatable.dart';
import '../../quran_data/models/verse.dart';

enum RecitationStatus {
  idle,
  listening,
  processing,
  correct,
  wrong,
  playingHint,
  finished,
}

sealed class RecitationState extends Equatable {
  const RecitationState();

  @override
  List<Object?> get props => [];
}

final class RecitationInitial extends RecitationState {}

final class RecitationLoading extends RecitationState {}

final class RecitationLoaded extends RecitationState {
  final List<Verse> verses;
  final int currentIndex;
  final RecitationStatus status;
  final String? errorMessage;

  const RecitationLoaded({
    required this.verses,
    this.currentIndex = 0,
    this.status = RecitationStatus.idle,
    this.errorMessage,
  });

  Verse get currentVerse => verses[currentIndex];
  bool get isLastVerse => currentIndex == verses.length - 1;

  RecitationLoaded copyWith({
    List<Verse>? verses,
    int? currentIndex,
    RecitationStatus? status,
    String? errorMessage,
  }) {
    return RecitationLoaded(
      verses: verses ?? this.verses,
      currentIndex: currentIndex ?? this.currentIndex,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [verses, currentIndex, status, errorMessage];
}

final class RecitationError extends RecitationState {
  final String message;

  const RecitationError(this.message);

  @override
  List<Object> get props => [message];
}
