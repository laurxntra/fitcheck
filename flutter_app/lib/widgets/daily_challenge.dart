import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:google_fonts/google_fonts.dart';

class DailyChallengeWidget extends StatefulWidget {
  @override
  _DailyChallengeWidgetState createState() => _DailyChallengeWidgetState();
}

class _DailyChallengeWidgetState extends State<DailyChallengeWidget> {
  final List<String> challenges = [
    "Wear something red ❤️", 
    "Rock a denim look 👖", 
    "Valentine’s Day Special 💌", 
    "Throwback 90s Outfit 🎵", 
    "Casual Friday 😎",
    "Christmas Spirit 🎄",
    "Show off your sneakers 👟",
    "All-black Outfit 🖤",
    "Happy International Women's Day 🌸",
    "Formal Friday 👔"
  ];

  String dailyChallenge = "";
  late DateTime challengeEndTime;
  Duration remainingTime = Duration();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _setDailyChallenge();
    _updateRemainingTime();
  }

  /// Sets the daily challenge based on Pacific Time (PST/PDT)
  void _setDailyChallenge() {
    final pacificTime = tz.TZDateTime.now(tz.getLocation('America/Los_Angeles'));
    int dayOfYear = pacificTime.day + pacificTime.month * 30;
    
    setState(() {
      dailyChallenge = challenges[dayOfYear % challenges.length]; // Rotate daily
      challengeEndTime = tz.TZDateTime(
        tz.getLocation('America/Los_Angeles'),
        pacificTime.year,
        pacificTime.month,
        pacificTime.day + 1, // Reset at midnight PST
      );
    });
  }

  /// Updates countdown timer
  void _updateRemainingTime() {
    setState(() {
      remainingTime = challengeEndTime.difference(tz.TZDateTime.now(tz.getLocation('America/Los_Angeles')));
    });

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) _updateRemainingTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Theme",
          style: GoogleFonts.bubblegumSans(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent.shade200, // Light pink
          ),
        ),
        SizedBox(height: 5),
        Text(
          dailyChallenge,
          style: GoogleFonts.bubblegumSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade300, // Slightly darker pink
          ),
        ),
        SizedBox(height: 5),
        Text(
          "Time left: ${_formatDuration(remainingTime)}",
          style: GoogleFonts.bubblegumSans(
            fontSize: 18,
            color: Colors.pinkAccent.shade100,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    return "${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}
