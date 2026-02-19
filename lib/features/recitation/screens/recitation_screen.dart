import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recitation_bloc.dart';
import '../bloc/recitation_event.dart';
import '../bloc/recitation_state.dart';
import '../../quran_data/models/surah.dart';
import '../../quran_data/models/juz.dart';
import '../../quran_data/repository/quran_repository.dart';
import '../../../core/enums/app_mode.dart';

class RecitationScreen extends StatelessWidget {
  final Surah? surah;
  final Juz? juz;
  final AppMode mode;

  const RecitationScreen({super.key, this.surah, this.juz, required this.mode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecitationBloc(
        quranRepository: RepositoryProvider.of<QuranRepository>(context),
        mode: mode,
      )..add(LoadRecitation(surah: surah, juz: juz)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(surah?.title ?? 'Juz ${juz?.number}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // TODO: Settings
              },
            ),
          ],
        ),
        body: BlocBuilder<RecitationBloc, RecitationState>(
          builder: (context, state) {
            if (state is RecitationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecitationLoaded) {
              final verse = state.verses[state.currentIndex];
              return Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SingleChildScrollView(
                          child: Text(
                            verse.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Amiri', // Or your Arabic font
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildControls(context, state),
                ],
              );
            } else if (state is RecitationError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Initializing...'));
          },
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, RecitationLoaded state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          if (state.status == RecitationStatus.correct)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Masha'Allah! Correct.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (state.status == RecitationStatus.processing)
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: LinearProgressIndicator(),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Verse ${state.currentVerse.number}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  // Show details
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 32),
                onPressed: state.currentIndex > 0
                    ? () => context.read<RecitationBloc>().add(PreviousVerse())
                    : null,
              ),
              _buildMicButton(context, state),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 32),
                onPressed: state.currentIndex < state.verses.length - 1
                    ? () => context.read<RecitationBloc>().add(NextVerse())
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMicButton(BuildContext context, RecitationLoaded state) {
    bool isListening = state.status == RecitationStatus.listening;
    return GestureDetector(
      onTap: () {
        if (isListening) {
          context.read<RecitationBloc>().add(StopListening());
        } else {
          context.read<RecitationBloc>().add(StartListening());
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isListening ? Colors.red : Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isListening ? Colors.red : Theme.of(context).primaryColor)
                  .withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          isListening ? Icons.stop : Icons.mic,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
