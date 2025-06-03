// websocket_status_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/soket_connection/soket_con_bolc.dart';
import 'package:systemize_pos/bloc/soket_connection/soket_con_state.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/components/app_bar.dart';

class WebSocketStatusWidget extends StatelessWidget {
  // final String url;
  const WebSocketStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor:
            AppColors.customThemeColor, // Set your desired color here
        statusBarIconBrightness: Brightness.light, // For white icons
        statusBarBrightness: Brightness.dark, // iOS only
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            text: 'WebSocket Status',
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.customThemeColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        
          body: BlocBuilder<WebSocketConnBloc, WebSocketConnState>(
            builder: (context, state) {
              if (state is WebSocketInitial || state is WebSocketConnecting) {
                return _buildStatus(
                  context,
                  title: "Connecting...",
                  icon: Icons.sync,
                  color: Colors.amber[700],
                );
              } else if (state is WebSocketConnected) {
                // Navigate after frame is built
        
                return _buildStatus(
                  context,
                  title: "Connected ✅",
                  subtitle: 'WebSocket connection established successfully',
                  icon: Icons.check_circle_outline,
                  color: Colors.green[600],
                );
              } else if (state is WebSocketDisconnected) {
                return _buildStatus(
                  context,
                  title: "Disconnected ❌",
                  icon: Icons.cancel_outlined,
                  color: Colors.red[600],
                );
              } else if (state is WebSocketError) {
                return _buildStatus(
                  context,
                  title: "Error Occurred",
                  subtitle: state.error,
                  icon: Icons.error_outline,
                  color: Colors.deepOrange,
                );
              }
              return _buildStatus(
                context,
                title: "Unknown State ❓",
                icon: Icons.help_outline,
                color: Colors.grey,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatus(
    BuildContext context, {
    required String title,
    IconData? icon,
    Color? color,
    String? subtitle,
  }) {
    return Center(
      child: Card(
        color: AppColors.customWhiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: color?.withOpacity(0.1),
                child: Icon(icon, color: color, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
