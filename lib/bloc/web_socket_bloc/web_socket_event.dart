
import 'package:equatable/equatable.dart';

abstract class WebSocketSettingsEvent extends Equatable {
  const WebSocketSettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadWebSocketUrl extends WebSocketSettingsEvent {}

class SaveWebSocketUrl extends WebSocketSettingsEvent {
  final String url;

  const SaveWebSocketUrl(this.url);

  @override
  List<Object> get props => [url];
}
