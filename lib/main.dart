// Activity 04
// Team Name: Name Team
// Team Members:
// - Saurav Annepu 002705192
// - Deborah Maignan 002327056
// Submission Date: September 22, 2026

import 'package:flutter/material.dart';

// workout challenge tracker
// gold is brighter in dark mode, darker in light mode so its readable
const gold = Color(0xFFD4AF37);
const darkGold = Color(0xFF8C6D1F);

void main() {
  runApp(const WorkoutApp());
}

// here is root app that holds isDarkMode and passes a callback down so the screen can flip it
class WorkoutApp extends StatefulWidget {
  const WorkoutApp({super.key});

  @override
  State<WorkoutApp> createState() => _WorkoutAppState();
}

class _WorkoutAppState extends State<WorkoutApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: WorkoutScreen(
        isDark: isDarkMode,
        onToggleTheme: () => setState(() => isDarkMode = !isDarkMode),
      ),
    );
  }
}

// main screen, all the workout numbers live here
class WorkoutScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const WorkoutScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int reps = 0;
  int sets = 0;
  int dailyGoal = 25;
  int streak = 0;
  bool goalCompleted = false;
  String status = "Ready";

  //so here it checks if goal is hit then only adds to streak the first time
  void checkGoal() {
    if (!goalCompleted && reps >= dailyGoal) {
      goalCompleted = true;
      streak++;
      status = "Goal hit!";
    } else if (reps < dailyGoal) {
      goalCompleted = false;
    }
  }

  void addReps(int amount) {
    setState(() {
      reps += amount;
      status = "+$amount reps";
      checkGoal();
    });
  }

  void finishSet() {
    setState(() {
      sets++;
      status = "Set $sets done";
    });
  }

  // fake rest, just changes the status
  void rest() {
    setState(() {
      status = "Resting...";
    });
  }

  //here it make it where new day resets reps and sets but keeps the streak
  void newDay() {
    setState(() {
      reps = 0;
      sets = 0;
      goalCompleted = false;
      status = "New day";
    });
  }

  @override
  Widget build(BuildContext context) {
    // progress for the bar, stops at 1 so it doesnt go past full
    double progress = reps / dailyGoal;
    if (progress > 1) {
      progress = 1;
    }

    // so bar color is blue under 50% orange under 100% and green when done
    Color barColor = Colors.blue;
    if (progress >= 1) {
      barColor = Colors.green;
    } else if (progress >= 0.5) {
      barColor = Colors.orange;
    }

    final accent = widget.isDark ? gold : darkGold;
    final bg = widget.isDark ? Colors.black : Colors.white;
    final cardBg =
        widget.isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF4EFE1);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text("Workout Tracker",
            style: TextStyle(fontWeight: FontWeight.bold, color: accent)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: accent),
            tooltip: 'New day',
            onPressed: newDay,
          ),
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode,
                color: accent),
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            HeaderTitle(text: "Daily Rep Challenge", color: accent),
            const SizedBox(height: 16),

            // stats
            Row(
              children: [
                Expanded(
                    child: StatBadge(
                        label: "Reps", value: "$reps", bg: cardBg, border: accent)),
                const SizedBox(width: 10),
                Expanded(
                    child: StatBadge(
                        label: "Sets", value: "$sets", bg: cardBg, border: accent)),
                const SizedBox(width: 10),
                Expanded(
                    child: StatBadge(
                        label: "Streak",
                        value: "$streak",
                        bg: cardBg,
                        border: accent)),
              ],
            ),
            const SizedBox(height: 20),

            // progress bar
            Text("$reps / $dailyGoal reps",
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              color: barColor,
              backgroundColor: Colors.grey.withOpacity(0.3),
            ),
            const SizedBox(height: 12),

            if (goalCompleted)
              const Text("GOAL COMPLETE 💪",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            Text(status,
                style: TextStyle(color: accent, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),

            // buttons
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                TactileButton(
                    icon: Icons.fitness_center,
                    label: "+1 REP",
                    isDark: widget.isDark,
                    onPressed: () => addReps(1)),
                TactileButton(
                    icon: Icons.bolt,
                    label: "+5 REPS",
                    isDark: widget.isDark,
                    onPressed: () => addReps(5)),
                TactileButton(
                    icon: Icons.check_circle,
                    label: "FINISH SET",
                    isDark: widget.isDark,
                    onPressed: finishSet),
                TactileButton(
                    icon: Icons.timer,
                    label: "REST",
                    isDark: widget.isDark,
                    onPressed: rest),
              ],
            ),
            const SizedBox(height: 28),

            // the slider changes the daily goal and also rechecks goal every time it moves
            Text("Daily goal: $dailyGoal reps",
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: dailyGoal.toDouble(),
              min: 10,
              max: 100,
              divisions: 18,
              label: "$dailyGoal",
              activeColor: accent,
              inactiveColor: Colors.grey.withOpacity(0.3),
              onChanged: (newValue) {
                setState(() {
                  dailyGoal = newValue.toInt();
                  checkGoal();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// stateless stuff, these just show whatever gets passed in
class HeaderTitle extends StatelessWidget {
  final String text;
  final Color color;

  const HeaderTitle({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: color));
  }
}

class StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color bg;
  final Color border;

  const StatBadge({
    super.key,
    required this.label,
    required this.value,
    required this.bg,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// here is custom button with its own isPressed state and the screen doesnt need to know about it
class TactileButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onPressed;

  const TactileButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onPressed,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.isDark ? gold : darkGold;
    final base =
        widget.isDark ? const Color(0xFF141414) : const Color(0xFFF3F3F3);
    final darkShadow = widget.isDark ? Colors.black : const Color(0xFFBDBDBD);
    final lightShadow = widget.isDark ? const Color(0xFF2A2A2A) : Colors.white;

    // so first tap down = push in, tap up = pop back + run action, cancel = pop back without running it
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isPressed ? accent : Colors.transparent, width: 1.5),
          // so 2 shadows make it look 3d they shrink when pressed
          boxShadow: isPressed
              ? [
                  BoxShadow(
                      color: darkShadow,
                      offset: const Offset(2, 2),
                      blurRadius: 4),
                  BoxShadow(
                      color: lightShadow,
                      offset: const Offset(-2, -2),
                      blurRadius: 4),
                ]
              : [
                  BoxShadow(
                      color: darkShadow,
                      offset: const Offset(6, 6),
                      blurRadius: 12),
                  BoxShadow(
                      color: lightShadow,
                      offset: const Offset(-6, -6),
                      blurRadius: 12),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: isPressed ? 38 : 44, color: accent),
            const SizedBox(height: 8),
            Text(widget.label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isPressed ? accent : Colors.grey)),
          ],
        ),
      ),
    );
  }
}