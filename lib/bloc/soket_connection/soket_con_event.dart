
import 'package:equatable/equatable.dart';

abstract class WebSocketConnEvent extends Equatable {
  const WebSocketConnEvent();
  @override
  List<Object?> get props => [];
}

class ConnectWebSocket extends WebSocketConnEvent {
  final String url;
  const ConnectWebSocket(this.url);
  @override
  List<Object?> get props => [url];
}

class DisconnectWebSocket extends WebSocketConnEvent {}

class WebSocketMessageReceived extends WebSocketConnEvent {
  final String message;
  const WebSocketMessageReceived(this.message);
  @override
  List<Object?> get props => [message];
}
