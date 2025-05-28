
import 'package:equatable/equatable.dart';

abstract class WebSocketConnState extends Equatable {
  const WebSocketConnState();
  @override
  List<Object?> get props => [];
}

class WebSocketInitial extends WebSocketConnState {}

class WebSocketConnecting extends WebSocketConnState {}

class WebSocketConnected extends WebSocketConnState {
  final String message;
  const WebSocketConnected(this.message);
  @override
  List<Object?> get props => [message];
}

class WebSocketDisconnected extends WebSocketConnState {}

class WebSocketError extends WebSocketConnState {
  final String error;
  const WebSocketError(this.error);
  @override
  List<Object?> get props => [error];
}

class WebSocketMessageState extends WebSocketConnState {
  final String message;
  const WebSocketMessageState(this.message);
  @override
  List<Object?> get props => [message];
}
