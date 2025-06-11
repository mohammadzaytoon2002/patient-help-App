import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/componant/shape%20copy.dart';
import 'package:watch3/screen/doctor_screen/homepage.dart';

class FAQScreen1 extends StatefulWidget {
  @override
  _FAQScreen1State createState() => _FAQScreen1State();
}

class _FAQScreen1State extends State<FAQScreen1> {
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

  Future<bool> sendNote(int faqId, String note) async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.1.107:8000/api/from_doctor/faqs/add_note/$faqId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'note': note}),
    );
    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 209, 208, 208),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 30, 71, 114),
          automaticallyImplyLeading: false, // تعطيل زر الرجوع تلقائيًا
          flexibleSpace: Stack(
            children: [
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
                        fontWeight: FontWeight.bold,
                      ),
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
          shape: CustomShapeBorder(),
          toolbarHeight: 20.0,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
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
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              query = '';
                            });
                            searchFAQs('');
                          },
                        )
                      : null,
                  prefixStyle: TextStyle(
                    color: query.isNotEmpty ? Colors.blue : Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  return FAQCard(
                    faq: faqs[index],
                    sendNote: sendNote,
                    query: query, // Pass query to FAQCard
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

class FAQCard extends StatefulWidget {
  final Map<String, dynamic> faq;
  final Future<bool> Function(int, String) sendNote;
  final String query; // Declare query parameter

  FAQCard({required this.faq, required this.sendNote, required this.query});

  @override
  _FAQCardState createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 190, 190, 190),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.play_circle_fill, color: Colors.blue),
              SizedBox(width: 10),
              Expanded(
                child: _buildQuestionText(widget.faq['question']),
              ),
              Text(
                widget.faq['created_at'].substring(0, 10),
                style: TextStyle(color: Colors.grey[800]),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            widget.faq['answer'],
            style: TextStyle(color: Colors.grey[700]),
          ),
          SizedBox(height: 10),
          TextField(
            controller: noteController,
            decoration: InputDecoration(
              hintText: 'Enter your note ...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  bool success = await widget.sendNote(
                    widget.faq['id'],
                    noteController.text,
                  );
                  noteController.clear();

                  final snackBar = SnackBar(
                    content: Text(success
                        ? 'Note sent successfully'
                        : 'Failed to send note'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: Text('Send'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionText(String question) {
    if (widget.query.isEmpty) {
      return Text(question);
    } else {
      // Split the question into parts based on the query
      List<TextSpan> parts = [];
      RegExp regex = RegExp(widget.query, caseSensitive: false);
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
}
