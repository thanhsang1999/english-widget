import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'vocabulary.dart';

class ManagePage extends StatefulWidget {
  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  final _wordController = TextEditingController();
  final _meaningController = TextEditingController();

  Future<void> _addWord() async {
    if (_wordController.text.isNotEmpty && _meaningController.text.isNotEmpty) {
      final vocab = Vocabulary(
        word: _wordController.text,
        meaning: _meaningController.text,
      );
      await DatabaseHelper.instance.addWord(vocab);
      _wordController.clear();
      _meaningController.clear();
      setState(() {});
    }
  }

  Future<void> _deleteWord(int id) async {
    await DatabaseHelper.instance.deleteWord(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Vocabulary')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _wordController,
                  decoration: InputDecoration(labelText: 'Word'),
                ),
                TextField(
                  controller: _meaningController,
                  decoration: InputDecoration(labelText: 'Meaning'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addWord,
                  child: Text('Add Word'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Vocabulary>>(
              future: DatabaseHelper.instance.getAllWords(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final words = snapshot.data!;
                return ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return ListTile(
                      title: Text(word.word),
                      subtitle: Text(word.meaning),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteWord(word.id!),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
