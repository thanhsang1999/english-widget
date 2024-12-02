import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'vocabulary.dart';
import 'manage_page.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Vocabulary? _randomWord;

  @override
  void initState() {
    super.initState();
    _getRandomWord();
  }

  Future<void> _getRandomWord() async {
    final words = await DatabaseHelper.instance.getAllWords();
    if (words.isNotEmpty) {
      final random = Random();
      setState(() {
        _randomWord = words[random.nextInt(words.length)];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn English'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManagePage()),
              ).then((_) => _getRandomWord());
            },
          )
        ],
      ),
      body: Center(
        child: _randomWord == null
            ? Text('No words available. Add new words!')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _randomWord!.word,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              _randomWord!.meaning,
              style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _getRandomWord,
              child: Text('Show Another Word'),
            )
          ],
        ),
      ),
    );
  }
}
