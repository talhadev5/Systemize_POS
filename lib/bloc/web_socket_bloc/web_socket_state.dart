
import 'package:equatable/equatable.dart';

enum SaveStatus { initial, success, error }

class WebSocketSettingsState extends Equatable {
  final String currentUrl;
  final SaveStatus status;

  const WebSocketSettingsState({
    this.currentUrl = '',
    this.status = SaveStatus.initial,
  });

  WebSocketSettingsState copyWith({
    String? currentUrl,
    SaveStatus? status,
  }) {
    return WebSocketSettingsState(
      currentUrl: currentUrl ?? this.currentUrl,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [currentUrl, status];
}
