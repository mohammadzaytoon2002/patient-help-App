import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final int chatId;
  final int userId;
  final String token;

  ChatPage({required this.chatId, required this.userId, required this.token});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  TextEditingController messageController = TextEditingController();
  String senderName = '';
  String recipientName = '';
  String recipientPicture = '';

  @override
  void initState() {
    super.initState();
    fetchChatMessages();
    fetchRecipientInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchRecipientInfo() async {
    final url = 'http://192.168.1.107:8000/api/chat';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final chatData = responseData['chats']
          .firstWhere((chat) => chat['id'] == widget.chatId);
      final participants = chatData['participants'];
      final recipient = participants.firstWhere((participant) =>
          participant['user']['id'] !=
          widget.userId); // Assuming userId is unique

      setState(() {
        recipientName =
            '${recipient['user']['first_name']} ${recipient['user']['last_name']}';
        recipientPicture = recipient['user']['picture'];
      });
    } else {
      // Handle error
      print('Failed to fetch recipient info: ${response.statusCode}');
    }
  }

  Future<void> fetchChatMessages() async {
    final url =
        'http://192.168.1.107:8000/api/chat_message?chat_id=${widget.chatId}&page=1';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        messages = (responseData['chats'][0]['messages'] as List)
            .map((message) => Message.fromJson(message))
            .toList();
      });
    } else {
      // Handle error
      print('Failed to fetch chat messages: ${response.statusCode}');
    }
  }

  Future<void> sendMessage(String message) async {
    final url = 'http://192.168.1.107:8000/api/chat_message';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'chat_id': widget.chatId.toString(),
        'message': message,
        'user_id': widget.userId.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        messages.insert(0, Message.fromJson(responseData['message_sent']));
      });
    } else {
      // Handle error
      print('Failed to send message: ${response.statusCode}');
    }
  }

  void showMessageDetails(Message message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sender: ${message.senderName ?? 'Unknown'}'),
              Text('Message: ${message.message ?? ''}'),
              Text(
                  'Sent at: ${DateFormat.yMMMd().add_jm().format(message.createdAt ?? DateTime.now())}'),
              Text('Seen: ${message.isSeen ? 'Yes' : 'No'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage('http://192.168.1.107:8000$recipientPicture'),
            ),
            SizedBox(width: 10),
            Text(
              recipientName,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Add functionality for the menu button
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // To display messages from bottom to top
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showMessageDetails(messages[index]);
                  },
                  child: MessageWidget(
                    message: messages[index],
                    isMe: messages[index].userId == widget.userId,
                    senderName: senderName,
                    recipientName: recipientName,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.lightBlue,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      sendMessage(messageController.text);
                      messageController.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;
  final String senderName;
  final String recipientName;

  MessageWidget({
    required this.message,
    required this.isMe,
    required this.senderName,
    required this.recipientName,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.7;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              isMe ? 'You' : senderName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe ? Colors.lightBlue : Colors.black,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.lightBlue : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Text(
                    '$recipientName',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                Text(
                  message.message ?? '',
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat.Hm()
                          .format(message.createdAt ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 12,
                        color: isMe ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    SizedBox(width: 5),
                    if (isMe && message.isSeen)
                      Icon(
                        Icons.done,
                        color: Colors.blue,
                        size: 18,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final int? id;
  final int? chatId;
  final int? userId;
  final String? message;
  final DateTime? createdAt;
  bool isSeen;
  final String? senderName;
  final String? recipientName;

  Message({
    this.id,
    this.chatId,
    this.userId,
    this.message,
    this.createdAt,
    this.isSeen = false,
    this.senderName,
    this.recipientName,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'] ?? ''),
      chatId: json['chat_id'] is int
          ? json['chat_id']
          : int.tryParse(json['chat_id'] ?? ''),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'] ?? ''),
      message: json['message'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      isSeen: json['is_seen'] ?? false,
      senderName: json['user'] != null
          ? '${json['user']['first_name']} ${json['user']['last_name']}'
          : null,
      recipientName: json['recipient'] != null
          ? '${json['recipient']['first_name']} ${json['recipient']['last_name']}'
          : null,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, chatId: $chatId, userId: $userId, message: $message, '
        'createdAt: $createdAt, isSeen: $isSeen, senderName: $senderName, recipientName: $recipientName)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          chatId == other.chatId &&
          userId == other.userId &&
          message == other.message &&
          createdAt == other.createdAt &&
          isSeen == other.isSeen &&
          senderName == other.senderName &&
          recipientName == other.recipientName;

  @override
  int get hashCode =>
      id.hashCode ^
      chatId.hashCode ^
      userId.hashCode ^
      message.hashCode ^
      createdAt.hashCode ^
      isSeen.hashCode ^
      senderName.hashCode ^
      recipientName.hashCode;
}
