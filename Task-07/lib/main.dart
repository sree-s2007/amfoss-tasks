import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(WordRushApp());
}

class WordRushApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Rush',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: StartScreen(),
    );
  }
}

// ---------------- Start Screen ----------------
class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: ElevatedButton(
          child: Text("Start Game", style: TextStyle(fontSize: 22)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameScreen()),
            );
          },
        ),
      ),
    );
  }
}

// ---------------- Game Screen ----------------
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> words = [];
  String currentWord = "";
  List<String> scrambledLetters = [];
  List<String?> selectedLetters = [];
  int score = 0;
  int timeLeft = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    final String fileData = await rootBundle.loadString('assets/Wordlist.md');

    // Extract only UPPERCASE words inside quotes
    final RegExp wordPattern = RegExp(r'"([A-Z]+)"');
    final matches = wordPattern.allMatches(fileData);

    final List<String> cleanedWords = matches.map((m) => m.group(1)!).toList();

    setState(() {
      words = cleanedWords;
    });

    startNewRound();
    startTimer();
  }

  void startNewRound() {
    if (words.isEmpty) return;

    final random = Random();
    currentWord = words[random.nextInt(words.length)];

    // scramble word
    scrambledLetters = currentWord.split('')..shuffle();

    // create empty slots for the answer
    selectedLetters = List.filled(currentWord.length, null);

    setState(() {});
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 30;
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          t.cancel();
          endGame();
        }
      });
    });
  }

  void selectLetter(String letter) {
    // find the first empty slot
    final index = selectedLetters.indexOf(null);
    if (index != -1) {
      setState(() {
        selectedLetters[index] = letter;
        scrambledLetters.remove(letter);
      });
    }

    // check if word is complete
    if (!selectedLetters.contains(null)) {
      checkAnswer();
    }
  }

  void checkAnswer() {
    final answer = selectedLetters.join();
    if (answer == currentWord) {
      setState(() {
        score++;
      });
      startNewRound();
    } else {
      endGame();
    }
  }

  void endGame() {
    timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(score: score),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Word Rush")),
      body: words.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Time Left: $timeLeft",
                style: TextStyle(fontSize: 20, color: Colors.red)),
            SizedBox(height: 10),
            Text("Score: $score", style: TextStyle(fontSize: 22)),
            SizedBox(height: 40),

            // Answer slots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                selectedLetters.length,
                    (i) => Container(
                  width: 40,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2)),
                  ),
                  child: Text(
                    selectedLetters[i] ?? "",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),

            // Scrambled letters as centered buttons
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: scrambledLetters
                  .map((l) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(60, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => selectLetter(l),
                child: Text(l,
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Result Screen ----------------
class ResultScreen extends StatelessWidget {
  final int score;
  ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Game Over!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Your Score: $score", style: TextStyle(fontSize: 24)),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text("Play Again"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              },
            ),
            SizedBox(height: 15),
            ElevatedButton(
              child: Text("Back to Start"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => StartScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
