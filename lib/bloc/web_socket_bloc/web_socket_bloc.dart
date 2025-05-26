import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemize_pos/bloc/web_socket_bloc/web_socket_event.dart';
import 'package:systemize_pos/bloc/web_socket_bloc/web_socket_state.dart';


class  WebSocketSettingsBloc extends Bloc<WebSocketSettingsEvent, WebSocketSettingsState> {
  WebSocketSettingsBloc() : super(const WebSocketSettingsState()) {
    on<LoadWebSocketUrl>(_onLoadWebSocketUrl);
    on<SaveWebSocketUrl>(_onSaveWebSocketUrl);
  }

  Future<void> _onLoadWebSocketUrl(
    LoadWebSocketUrl event,
    Emitter<WebSocketSettingsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('websocket_url') ?? 'ws://192.168.192.2:8765';
    emit(state.copyWith(currentUrl: savedUrl));
  }

  Future<void> _onSaveWebSocketUrl(
    SaveWebSocketUrl event,
    Emitter<WebSocketSettingsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    if (event.url.trim().isNotEmpty) {
      await prefs.setString('websocket_url', event.url.trim());
      emit(state.copyWith(currentUrl: event.url.trim(), status: SaveStatus.success));
    } else {
      emit(state.copyWith(status: SaveStatus.error));
    }
  }
}
