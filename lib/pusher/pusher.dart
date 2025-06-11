import 'dart:convert';
import 'package:pusher_client/pusher_client.dart';

class PusherService {
  static String pusherAppKey = 'dee013cc462023c954a9';
  static String pusherCluster = 'eu';

  late PusherClient pusherClient;
  late Channel channel;

  Function(Map<String, dynamic>) onMessageSent;
  Function(Map<String, dynamic>) onMessageSeen;

  PusherService(
    String channelName, {
    required this.onMessageSent,
    required this.onMessageSeen,
  }) {
    pusherClient = PusherClient(
      pusherAppKey,
      PusherOptions(cluster: pusherCluster, encrypted: true),
      enableLogging: true,
    );

    pusherClient.connect();

    channel = pusherClient.subscribe(channelName);

    channel.bind('App\\Events\\MessageSent', (PusherEvent? event) {
      if (event != null && event.data != null) {
        var messageData = jsonDecode(event.data!);
        onMessageSent(messageData);
      }
    });

    channel.bind('App\\Events\\MessageSeen', (PusherEvent? event) {
      if (event != null && event.data != null) {
        var messageData = jsonDecode(event.data!);
        onMessageSeen(messageData);
      }
    });
  }

  void connect() {
    pusherClient.connect();
  }

  void disconnect() {
    pusherClient.disconnect();
  }
}
