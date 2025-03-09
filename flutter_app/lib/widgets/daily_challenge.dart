import 'dart:async'; // Required for Timer
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
    "Pastel Colors Day 🌸",
    "Formal Friday 👔"
  ];

  String dailyChallenge = "";
  late DateTime challengeEndTime;
  Duration remainingTime = Duration();
  Timer? _timer; // Track timer for cleanup

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _setDailyChallenge();
    _startTimer();
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

  /// Starts a timer that updates every second
  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer before starting a new one

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        remainingTime = challengeEndTime.difference(
          tz.TZDateTime.now(tz.getLocation('America/Los_Angeles')),
        );

        // If time reaches zero, reset the challenge
        if (remainingTime.isNegative) {
          _setDailyChallenge();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Theme",
          style: GoogleFonts.bubblegumSans(
            fontSize: 18, // Smaller size
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent.shade200,
          ),
        ),
        SizedBox(height: 2),
        Text(
          dailyChallenge,
          style: GoogleFonts.bubblegumSans(
            fontSize: 20, // More compact
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade300,
          ),
        ),
        SizedBox(height: 2),
        Text(
          "Time left: ${_formatDuration(remainingTime)}",
          style: GoogleFonts.bubblegumSans(
            fontSize: 14,
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
