import 'package:flutter_test/flutter_test.dart';

// Standalone implementation of our streak calculation algorithm for verification
int calculateCurrentStreak(List<String> completedDates, DateTime today) {
  if (completedDates.isEmpty) return 0;

  final todayStr = formatDate(today);
  final yesterday = today.subtract(const Duration(days: 1));
  final yesterdayStr = formatDate(yesterday);

  if (!completedDates.contains(todayStr) && !completedDates.contains(yesterdayStr)) {
    return 0;
  }

  int currentStreak = 0;
  DateTime checkDate = completedDates.contains(todayStr) ? today : yesterday;

  while (completedDates.contains(formatDate(checkDate))) {
    currentStreak++;
    checkDate = checkDate.subtract(const Duration(days: 1));
  }

  return currentStreak;
}

int calculateBestStreak(List<String> completedDates) {
  if (completedDates.isEmpty) return 0;

  final List<DateTime> dates = completedDates.map((d) {
    final parts = d.split('-');
    return DateTime.utc(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]), 12, 0, 0);
  }).toList();

  dates.sort();

  int maxStreak = 1;
  int currentBlock = 1;

  for (int i = 1; i < dates.length; i++) {
    final diff = dates[i].difference(dates[i - 1]).inDays;
    if (diff == 1) {
      currentBlock++;
    } else if (diff > 1) {
      if (currentBlock > maxStreak) {
        maxStreak = currentBlock;
      }
      currentBlock = 1;
    }
  }

  if (currentBlock > maxStreak) {
    maxStreak = currentBlock;
  }

  return maxStreak;
}

String formatDate(DateTime date) {
  return "${date.year.toString().padLeft(4,'0')}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
}

void main() {
  group('Streak Calculations Engine Tests', () {
    test('Zero completed dates returns 0 current and best streak', () {
      final dates = <String>[];
      final today = DateTime(2026, 5, 26);
      expect(calculateCurrentStreak(dates, today), 0);
      expect(calculateBestStreak(dates), 0);
    });

    test('Single completed date returns 1 current streak and 1 best streak', () {
      final dates = ['2026-05-26'];
      final today = DateTime(2026, 5, 26);
      expect(calculateCurrentStreak(dates, today), 1);
      expect(calculateBestStreak(dates), 1);
    });

    test('Consecutive completed dates calculate current and best streak correctly', () {
      final dates = ['2026-05-26', '2026-05-25', '2026-05-24'];
      final today = DateTime(2026, 5, 26);
      expect(calculateCurrentStreak(dates, today), 3);
      expect(calculateBestStreak(dates), 3);
    });

    test('Breaks in current streak set current streak to 0, while keeping best streak', () {
      // Completed last week, but missed yesterday and today
      final dates = ['2026-05-20', '2026-05-21', '2026-05-22'];
      final today = DateTime(2026, 5, 26);
      expect(calculateCurrentStreak(dates, today), 0);
      expect(calculateBestStreak(dates), 3);
    });

    test('Multi-block breaks calculate overall maximum best streak correctly', () {
      final dates = [
        '2026-05-10', '2026-05-11', // Streak of 2
        '2026-05-15', '2026-05-16', '2026-05-17', '2026-05-18', // Streak of 4 (Best)
        '2026-05-25', '2026-05-26' // Streak of 2 (Current)
      ];
      final today = DateTime(2026, 5, 26);
      expect(calculateCurrentStreak(dates, today), 2);
      expect(calculateBestStreak(dates), 4);
    });

    test('DST and Timezone variations do not affect best streak calculations due to UTC noon normalization', () {
      // Set completed dates containing potential 23 or 25 hour DST change days
      final dates = ['2026-03-28', '2026-03-29', '2026-03-30'];
      expect(calculateBestStreak(dates), 3);
    });
  });
}
