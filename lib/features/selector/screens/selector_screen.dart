import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../quran_data/repository/quran_repository.dart';
import '../bloc/selector_cubit.dart';
import '../bloc/selector_state.dart';
import 'surah_list_tab.dart';
import 'juz_list_tab.dart';
import '../../../core/enums/app_mode.dart';

class SelectorScreen extends StatelessWidget {
  final AppMode mode;

  const SelectorScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectorCubit(
        quranRepository: RepositoryProvider.of<QuranRepository>(context),
      )..loadData(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Select Recitation'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Surah'),
                Tab(text: 'Juz'),
              ],
            ),
          ),
          body: BlocBuilder<SelectorCubit, SelectorState>(
            builder: (context, state) {
              if (state is SelectorLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SelectorLoaded) {
                return TabBarView(
                  children: [
                    SurahListTab(surahs: state.surahs, mode: mode),
                    JuzListTab(juzs: state.juzs, mode: mode),
                  ],
                );
              } else if (state is SelectorError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
