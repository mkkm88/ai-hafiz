import 'package:flutter/material.dart';
import '../../quran_data/models/juz.dart';
import '../../recitation/screens/recitation_screen.dart';
import '../../../core/enums/app_mode.dart';

class JuzListTab extends StatelessWidget {
  final List<Juz> juzs;
  final AppMode mode;

  const JuzListTab({super.key, required this.juzs, required this.mode});

  @override
  Widget build(BuildContext context) {
    if (juzs.isEmpty) {
      return const Center(child: Text("No Juz Data Found"));
    }
    return ListView.separated(
      itemCount: juzs.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final juz = juzs[index];
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
              juz.number.toString(),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text("Juz ${juz.number}"),
          subtitle: Text(
            "Starts at Surah ${juz.startSurah}, Verse ${juz.startVerse}",
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecitationScreen(juz: juz, mode: mode),
              ),
            );
          },
        );
      },
    );
  }
}
