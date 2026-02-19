import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../quran_data/repository/quran_repository.dart';
import '../../../core/enums/app_mode.dart';
import '../../audio/services/audio_recorder_service.dart';
import '../../stt/services/google_stt_service.dart';
import '../../brain/services/comparison_service.dart';
import 'recitation_event.dart';
import 'recitation_state.dart';

class RecitationBloc extends Bloc<RecitationEvent, RecitationState> {
  final QuranRepository _quranRepository;
  final AppMode mode;
  final AudioRecorderService _recorderService;
  final GoogleSttService _sttService;
  final TextComparisonService _comparisonService;

  StreamSubscription<dynamic>? _amplitudeSub;
  Timer? _silenceTimer;

  // Settings for silence detection
  static const double _silenceThreshold = -30.0; // dB
  static const int _silenceDurationMs =
      1500; // 1.5 seconds silence triggers processing

  RecitationBloc({required QuranRepository quranRepository, required this.mode})
    : _quranRepository = quranRepository,
      _recorderService = AudioRecorderService(),
      _sttService = GoogleSttService(),
      _comparisonService = TextComparisonService(),
      super(RecitationInitial()) {
    on<LoadRecitation>(_onLoadRecitation);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<ProcessAudio>(_onProcessAudio);
    on<NextVerse>(_onNextVerse);
    on<PreviousVerse>(_onPreviousVerse);
  }

  @override
  Future<void> close() {
    _recorderService.dispose();
    _amplitudeSub?.cancel();
    _silenceTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoadRecitation(
    LoadRecitation event,
    Emitter<RecitationState> emit,
  ) async {
    emit(RecitationLoading());
    try {
      if (event.surah != null) {
        final verses = await _quranRepository.getVerses(event.surah!.number);
        emit(RecitationLoaded(verses: verses));
      } else if (event.juz != null) {
        final verses = await _quranRepository.getJuzVerses(event.juz!);
        emit(RecitationLoaded(verses: verses));
      } else {
        emit(const RecitationError("No Surah or Juz selected"));
      }
    } catch (e) {
      emit(RecitationError(e.toString()));
    }
  }

  Future<void> _onStartListening(
    StartListening event,
    Emitter<RecitationState> emit,
  ) async {
    if (state is RecitationLoaded) {
      final currentState = state as RecitationLoaded;

      // Start recording
      await _recorderService.start();

      // Monitor amplitude for silence
      _amplitudeSub?.cancel();
      _amplitudeSub = _recorderService.onAmplitudeChanged.listen((amp) {
        if (amp.current < _silenceThreshold) {
          // Silence detected
          if (_silenceTimer == null || !_silenceTimer!.isActive) {
            _silenceTimer = Timer(
              const Duration(milliseconds: _silenceDurationMs),
              () {
                // Silence persisted for X seconds, stop and process
                add(StopListening());
              },
            );
          }
        } else {
          // Noise detected, reset timer
          _silenceTimer?.cancel();
        }
      });

      emit(currentState.copyWith(status: RecitationStatus.listening));
    }
  }

  Future<void> _onStopListening(
    StopListening event,
    Emitter<RecitationState> emit,
  ) async {
    if (state is RecitationLoaded) {
      final currentState = state as RecitationLoaded;
      _amplitudeSub?.cancel();
      _silenceTimer?.cancel();

      final path = await _recorderService.stop();
      if (path != null) {
        add(ProcessAudio(path));
      } else {
        emit(currentState.copyWith(status: RecitationStatus.idle));
      }
    }
  }

  Future<void> _onProcessAudio(
    ProcessAudio event,
    Emitter<RecitationState> emit,
  ) async {
    if (state is RecitationLoaded) {
      final currentState = state as RecitationLoaded;
      emit(currentState.copyWith(status: RecitationStatus.processing));

      try {
        // Read file bytes
        final File audioFile = File(event.audioPath);
        final Uint8List bytes = await audioFile.readAsBytes();

        // STT
        final String spokenText = await _sttService.recognizeAudioBytes(bytes);

        if (spokenText.isEmpty) {
          emit(
            currentState.copyWith(
              status: RecitationStatus.wrong,
              errorMessage: "No speech detected",
            ),
          );
          return;
        }

        // Compare with current verse
        final currentVerse = currentState.currentVerse;
        final bool isCorrect = _comparisonService.isCorrect(
          currentVerse.text,
          spokenText,
        );

        if (isCorrect) {
          emit(currentState.copyWith(status: RecitationStatus.correct));
          // Provide visual feedback then move to next
          await Future.delayed(const Duration(seconds: 1));
          add(NextVerse());
        } else {
          emit(
            currentState.copyWith(
              status: RecitationStatus.wrong,
              errorMessage:
                  "Expected: ${currentVerse.text}\nHeard: $spokenText",
            ),
          );
          // Rewind logic could go here if needed
        }
      } catch (e) {
        emit(
          currentState.copyWith(
            status: RecitationStatus.wrong,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void _onNextVerse(NextVerse event, Emitter<RecitationState> emit) {
    if (state is RecitationLoaded) {
      final currentState = state as RecitationLoaded;
      if (currentState.currentIndex < currentState.verses.length - 1) {
        emit(
          currentState.copyWith(
            currentIndex: currentState.currentIndex + 1,
            status: RecitationStatus.idle,
            errorMessage: null, // Clear error
          ),
        );
      } else {
        emit(currentState.copyWith(status: RecitationStatus.finished));
      }
    }
  }

  void _onPreviousVerse(PreviousVerse event, Emitter<RecitationState> emit) {
    if (state is RecitationLoaded) {
      final currentState = state as RecitationLoaded;
      if (currentState.currentIndex > 0) {
        emit(
          currentState.copyWith(
            currentIndex: currentState.currentIndex - 1,
            status: RecitationStatus.idle,
            errorMessage: null, // Clear error
          ),
        );
      }
    }
  }
}
