import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DadJokesApp());
}

class DadJokesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dad Jokes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DadJokesScreen(),
    );
  }
}

class DadJokesScreen extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Dad Jokes App'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _joke,
              style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchJoke,
              child: Text('Get Random Dad Joke'),
            ),
          ],
        ),
      ),
    );
  }
}