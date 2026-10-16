import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/arabia_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const FoulFalafelApp());
}

class FoulFalafelApp extends StatelessWidget {
  const FoulFalafelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Foul & Falafel",
      debugShowCheckedModeBanner: false,
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late ArabiaGame _game;

  @override
  void initState() {
    super.initState();
    _game = ArabiaGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A1F14),
      body: GameWidget(game: _game),
    );
  }
}