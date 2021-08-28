import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordpairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();

          final index = item ~/ 2;

          if (index >= _randomWordPairs.length) {
            _randomWordPairs.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_randomWordPairs[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _savedWordpairs.contains(pair);
    return ListTile(
      title: Text(pair.asPascalCase, style: TextStyle(fontSize: 18)),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.amber[700] : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordpairs.remove(pair);
          } else {
            _savedWordpairs.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _savedWordpairs.map((WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: TextStyle(fontSize: 16),
          ),
        );
      });

      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Wordpairs'),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPair Gen'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildList(),
    );
  }
}
