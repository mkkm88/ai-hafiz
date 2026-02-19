import 'package:equatable/equatable.dart';
import '../../quran_data/models/juz.dart';
import '../../quran_data/models/surah.dart';

sealed class SelectorState extends Equatable {
  const SelectorState();

  @override
  List<Object> get props => [];
}

final class SelectorInitial extends SelectorState {}

final class SelectorLoading extends SelectorState {}

final class SelectorLoaded extends SelectorState {
  final List<Surah> surahs;
  final List<Juz> juzs;

  const SelectorLoaded({required this.surahs, required this.juzs});

  @override
  List<Object> get props => [surahs, juzs];
}

final class SelectorError extends SelectorState {
  final String message;

  const SelectorError(this.message);

  @override
  List<Object> get props => [message];
}
