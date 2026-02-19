import 'package:flutter_bloc/flutter_bloc.dart';
import '../../quran_data/repository/quran_repository.dart';
import 'selector_state.dart';

class SelectorCubit extends Cubit<SelectorState> {
  final QuranRepository _quranRepository;

  SelectorCubit({required QuranRepository quranRepository})
    : _quranRepository = quranRepository,
      super(SelectorInitial());

  Future<void> loadData() async {
    try {
      emit(SelectorLoading());
      final surahs = await _quranRepository.getAllSurahs();
      final juzs = await _quranRepository.getJuzList();
      emit(SelectorLoaded(surahs: surahs, juzs: juzs));
    } catch (e) {
      emit(SelectorError(e.toString()));
    }
  }
}
