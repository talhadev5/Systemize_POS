import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/soket_connection/soket_con_bolc.dart';
import 'package:systemize_pos/bloc/soket_connection/soket_con_event.dart';
import 'package:systemize_pos/bloc/web_socket_bloc/web_socket_bloc.dart';
import 'package:systemize_pos/bloc/web_socket_bloc/web_socket_event.dart';
import 'package:systemize_pos/bloc/web_socket_bloc/web_socket_state.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/components/app_bar.dart';
import 'package:systemize_pos/configs/widgets/custom_sankbar.dart';

class WebSocketSettingsPage extends StatefulWidget {
  const WebSocketSettingsPage({super.key});

  @override
  State<WebSocketSettingsPage> createState() => _WebSocketSettingsPageState();
}

class _WebSocketSettingsPageState extends State<WebSocketSettingsPage> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<WebSocketSettingsBloc>().add(LoadWebSocketUrl());
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

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
          backgroundColor: AppColors.customScaffoldColor,
          appBar: CustomAppBar(
            text: 'WebSocket Settings',
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.customThemeColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: BlocConsumer<WebSocketSettingsBloc, WebSocketSettingsState>(
            listener: (context, state) {
              if (state.status == SaveStatus.success) {
                CustomSnackbar.show(
                  context: context,
                  message: 'WebSocket URL saved!',
                );
              } else if (state.status == SaveStatus.error) {
                CustomSnackbar.show(
                  context: context,
                  message: 'Please enter a valid URL',
                );
              }
            },
            builder: (context, state) {
              _urlController.text = state.currentUrl;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.customWhiteColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Configure WebSocket',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.customBlackColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Enter your WebSocket server URL below to enable real-time features.',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _urlController,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                              labelText: 'WebSocket URL',
                              hintText: 'e.g., ws://192.168.192.18:8765',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.customThemeColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.save_rounded),
                              label: const Text(
                                "Save URL",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                context.read<WebSocketConnBloc>().add(
                                  ConnectWebSocket(_urlController.text),
                                );
                                context.read<WebSocketSettingsBloc>().add(
                                  SaveWebSocketUrl(_urlController.text),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.customThemeColor,
                                foregroundColor: AppColors.customWhiteColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.customWhiteColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.link, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              state.currentUrl,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.customBlackColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
