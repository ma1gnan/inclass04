// Deborah Maignan 002327056
//Saurav Annepu 002705192

import 'package:flutter/material.dart';

void main() {
  runApp(const TactileDeckApp());
}

class TactileDeckApp extends StatefulWidget {
  const TactileDeckApp({super.key});

  @override
  State<TactileDeckApp> createState() => _TactileDeckAppState();
}

class _TactileDeckAppState extends State<TactileDeckApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber-Tactile Control Studio (BROKEN)',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: ControlDeckScreen(
        isDark: isDarkMode,
        onToggleTheme: () => setState(() => isDarkMode = !isDarkMode),
      ),
    );
  }
}

class ControlDeckScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ControlDeckScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ControlDeckScreen> createState() => _ControlDeckScreenState();
}

class _ControlDeckScreenState extends State<ControlDeckScreen> {
  int totalTaps = 0;
  double powerLevel = 65.0;
  String systemStatus = "READY";

  // 🐛 BUG #1 — this flag is owned by the SCREEN, not by an individual button.
  // Every TactileButton below reads this exact same variable.
  bool isPressed = false;

  void _triggerAction(String actionName) {
    setState(() {
      totalTaps++;
      systemStatus = "$actionName ACTIVATED";
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenBg = widget.isDark ? const Color(0xFF1E1F29) : const Color(0xFFE0E5EC);
    final cardBg = widget.isDark ? const Color(0xFF282A36) : Colors.white;

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        title: const Text(
          "TACTILE CONTROL STUDIO",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(widget.isDark ? 0.3 : 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text("TOTAL TAPS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("$totalTaps", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                  Column(
                    children: [
                      const Text("ENERGY LEVEL", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("${powerLevel.toInt()}%", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "STATUS: $systemStatus",
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
                color: widget.isDark ? Colors.tealAccent : Colors.teal.shade700,
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                TactileButton(
                  icon: Icons.flash_on,
                  label: "TURBO",
                  accentColor: Colors.amber,
                  isDark: widget.isDark,
                  // 🐛 BUG #1 — every button below is wired to the SAME isPressed value.
                  onTap: () {
                      _triggerAction("TURBO BOOST");
                    },
                ),
                TactileButton(
                  icon: Icons.shield,
                  label: "SHIELD",
                  accentColor: Colors.tealAccent,
                  isDark: widget.isDark,
                  onTap: () {
                      _triggerAction("DEFENSE SHIELD");
                    },
                ),
                TactileButton(
                  icon: Icons.wifi_tethering,
                  label: "RADAR",
                  accentColor: Colors.purpleAccent,
                  isDark: widget.isDark,
                  onTap: () {
                      _triggerAction("PULSE RADAR");
                    },
                ),
                TactileButton(
                  icon: Icons.rocket_launch,
                  label: "LAUNCH",
                  accentColor: Colors.redAccent,
                  isDark: widget.isDark,
                  onTap: () {
                      _triggerAction("THRUSTER LAUNCH");
                    },
                ),
              ],
            ),
            const SizedBox(height: 36),
            Text(
              "Power Calibration: ${powerLevel.toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Slider(
              value: powerLevel,
              min: 0,
              max: 100,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.grey.withOpacity(0.3),
              // 🐛 BUG #2 — the value on the right definitely changes... but does
              // the framework know it needs to redraw anything?
              //onChanged: (newVal) => powerLevel = newVal,
              onChanged: (newVal) {
                setState(() {
                  powerLevel = newVal;
                  });
                },
            ),
          ],
        ),
      ),
    );
  }
}

// Refactored to StatelessWidget: isPressed now arrives from the parent screen
// instead of being tracked locally. Compare this to the clean starter code!
class TactileButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final bool isDark;
  final VoidCallback onTap;

  const TactileButton({
    super.key,
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDark
        ? const Color(0xFF222430)
        : const Color(0xFFE0E5EC);

    final darkShadow = widget.isDark
        ? Colors.black87
        : const Color(0xFFA3B1C6);

    final lightShadow = widget.isDark
        ? const Color(0xFF2F3244)
        : Colors.white;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },

      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });

        widget.onTap();
      },

      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(24),

          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: darkShadow.withOpacity(0.7),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: lightShadow.withOpacity(0.9),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: darkShadow.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: lightShadow.withOpacity(0.5),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: isPressed ? 40 : 46,
              color: isPressed
                  ? widget.accentColor
                  : (widget.isDark
                      ? Colors.white70
                      : Colors.black87),
            ),

            const SizedBox(height: 8),

            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.1,
                color: isPressed
                    ? widget.accentColor
                    : (widget.isDark
                        ? Colors.white54
                        : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}