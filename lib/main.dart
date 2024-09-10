import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const DadJokesApp());
}

class DadJokesApp extends StatelessWidget {
  const DadJokesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dad Jokes App with Bottom Navigation Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

// Main Screen with Bottom Navigation Bar and Favorites List
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<String> _favorites = []; // List to store favorite jokes

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      DadJokesScreen(onLike: _addToFavorites),
      FavoritesScreen(favorites: _favorites),
      const SettingsScreen(),
    ]);
  }

  // Function to add a joke to the favorites list
  void _addToFavorites(String joke) {
    setState(() {
      if (!_favorites.contains(joke)) {
        _favorites.add(joke);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dad Jokes App'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// Dad Jokes Screen (with Like Button)
class DadJokesScreen extends StatefulWidget {
  final Function(String) onLike;

  const DadJokesScreen({super.key, required this.onLike});

  @override
  _DadJokesScreenState createState() => _DadJokesScreenState();
}

class _DadJokesScreenState extends State<DadJokesScreen> {
  String _joke = "Press the button to get a random dad joke!";

  // Function to fetch a random dad joke from the API
  Future<void> fetchJoke() async {
    final url = Uri.parse('https://icanhazdadjoke.com/');
    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _joke = data['joke'];
        });
      } else {
        setState(() {
          _joke = "Failed to load joke. Try again!";
        });
      }
    } catch (e) {
      setState(() {
        _joke = "An error occurred. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _joke,
            style: const TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: fetchJoke,
                child: const Text('Get Random Dad Joke'),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  widget.onLike(_joke); // Save the joke to favorites
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added to favorites!')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Favorites Screen (new screen)
class FavoritesScreen extends StatelessWidget {
  final List<String> favorites;

  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return favorites.isEmpty
        ? const Center(child: Text('No favorites yet!'))
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(favorites[index]),
              );
            },
          );
  }
}

// Settings Screen (new screen)
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings screen content goes here!'),
    );
  }
}