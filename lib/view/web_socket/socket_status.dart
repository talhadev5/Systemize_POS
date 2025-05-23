import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketStatusWidget extends StatefulWidget {
  final String url;

  WebSocketStatusWidget({required this.url});

  @override
  _WebSocketStatusWidgetState createState() => _WebSocketStatusWidgetState();
}

class _WebSocketStatusWidgetState extends State<WebSocketStatusWidget> {
  late WebSocketChannel channel;
  String status = "Connecting...";

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
  }

  void connectToWebSocket() {
    try {
      channel = IOWebSocketChannel.connect(Uri.parse(widget.url));

      channel.stream.listen(
        (message) {
          // You can update this logic based on your server's first message
          setState(() {
            status = "Connected ✅";
          });
        },
        onError: (error) {
          setState(() {
            status = "Disconnected ❌";
          });
        },
        onDone: () {
          setState(() {
            status = "Connection Closed ❌";
          });
        },
      );
    } catch (e) {
      setState(() {
        status = "Failed: $e ❌";
      });
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WebSocket Status")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "WebSocket Status:",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Text(
              status,
              style: TextStyle(
                fontSize: 24,
                color: status.contains("Connected") ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
