import 'package:flutter/material.dart';
import '../../quran_data/models/surah.dart';
import '../../recitation/screens/recitation_screen.dart';
import '../../../core/enums/app_mode.dart';

class SurahListTab extends StatelessWidget {
  final List<Surah> surahs;
  final AppMode mode;

  const SurahListTab({super.key, required this.surahs, required this.mode});

  @override
  Widget build(BuildContext context) {
    if (surahs.isEmpty) {
      return const Center(child: Text("No Surahs Found"));
    }
    return ListView.separated(
      itemCount: surahs.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final surah = surahs[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              surah.number.toString(),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(surah.title),
          subtitle: Text("${surah.type} • ${surah.verseCount} verses"),
          trailing: Text(
            surah.titleAr,
            style: const TextStyle(
              fontFamily: 'Amiri', // Or a nice Arabic font if available
              fontSize: 18,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RecitationScreen(surah: surah, mode: mode),
              ),
            );
          },
        );
      },
    );
  }
}
