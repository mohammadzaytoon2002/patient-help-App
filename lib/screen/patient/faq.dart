import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List faqs = [];
  String query = "";
  String? token;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null && token!.isNotEmpty) {
      await fetchFAQs();
    } else {
      // Handle the case where the user is not logged in
      print('User is not logged in or token is null');
    }
  }

  Future<void> fetchFAQs() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/faqs'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        faqs = json.decode(response.body)['faqs'];
      });
    } else {
      throw Exception('Failed to load FAQs');
    }
  }

  Future<void> searchFAQs(String query) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.107:8000/api/faqs/search'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'query': query}),
    );
    if (response.statusCode == 200) {
      setState(() {
        faqs = json.decode(response.body)['faqs'];
      });
    } else {
      throw Exception('Failed to search FAQs');
    }
  }

  Widget _buildQuestionText(String question) {
    if (query.isEmpty) {
      return Text(question);
    } else {
      // Split the question into parts based on the query
      List<TextSpan> parts = [];
      RegExp regex = RegExp(query, caseSensitive: false);
      Iterable<Match> matches = regex.allMatches(question);

      // Add parts to the list
      int lastIndex = 0;
      for (Match match in matches) {
        if (match.start > lastIndex) {
          parts.add(TextSpan(
            text: question.substring(lastIndex, match.start),
            style: TextStyle(color: Colors.black),
          ));
        }
        parts.add(TextSpan(
          text: question.substring(match.start, match.end),
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ));
        lastIndex = match.end;
      }

      // Add the remaining text
      if (lastIndex < question.length) {
        parts.add(TextSpan(
          text: question.substring(lastIndex, question.length),
          style: TextStyle(color: Colors.black),
        ));
      }

      return RichText(
        text: TextSpan(
          children: parts,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 209, 208, 208),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.0),
        child: AppBar(
          backgroundColor: Colors.blue,
          flexibleSpace: Stack(
            children: [
              Positioned(
                top: 40.0,
                left: 10.0,
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/faq11.png',
                      height: 100,
                      width: 150,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'What question do you have ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Here you will find answers to all your medical questions concerning diabetes:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          elevation: 0,
          toolbarHeight: 20.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                  searchFAQs(value);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Help',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 190, 190, 190),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.play_circle_fill, color: Colors.blue),
                            SizedBox(width: 10),
                            Expanded(
                              child:
                                  _buildQuestionText(faqs[index]['question']),
                            ),
                            Text(
                              faqs[index]['created_at'].substring(0, 10),
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          faqs[index]['answer'],
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
