import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Random name generator',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white, foregroundColor: Colors.black)),
        home: RandomWords(),
      );
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _favorites = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);

  // Change view to favorites names
  void _pushFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _favorites.map((pair) {
            return ListTile(title: Text(pair.asPascalCase, style: _biggerFont));
          });

          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(tiles: tiles, context: context).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Favorite names'),
            ),
            body: ListView(
              children: divided,
            ),
          );
        },
      ),
    );
  }

  // Create list tile
  Widget _buildRow(WordPair pair) {
    final _inFavorites = _favorites.contains(pair);

    return ListTile(
      title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: Icon(
        _inFavorites ? Icons.favorite : Icons.favorite_border,
        color: _inFavorites ? Colors.red : null,
        semanticLabel:
            _inFavorites ? 'Remove from favorites' : 'Add to favorites',
      ),
      onTap: () {
        setState(() {
          if (_inFavorites) {
            _favorites.remove(pair);
          } else {
            _favorites.add(pair);
          }
        });
      },
    );
  }

  // Generate 10 word pairs
  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        if (index.isOdd) {
          return const Divider();
        }

        final _index = index ~/ 2;
        if (_index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[_index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random name generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushFavorites,
            tooltip: 'Favorites names',
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
