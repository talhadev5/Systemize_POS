// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/widgets/custom_sankbar.dart';

class WebSocketSettingsPage extends StatefulWidget {
  const WebSocketSettingsPage({super.key});

  @override
  State<WebSocketSettingsPage> createState() => _WebSocketSettingsPageState();
}

class _WebSocketSettingsPageState extends State<WebSocketSettingsPage> {
  final TextEditingController _urlController = TextEditingController();
  String _savedUrl = '';

  @override
  void initState() {
    super.initState();
    _loadSavedUrl();
  }

  // Load the saved WebSocket URL from SharedPreferences
  Future<void> _loadSavedUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl =
        prefs.getString('websocket_url') ?? 'ws://192.168.192.24:8765';
    setState(() {
      _savedUrl = savedUrl;
      _urlController.text = savedUrl;
    });
  }

  // Save the WebSocket URL to SharedPreferences
  Future<void> _saveUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      await prefs.setString('websocket_url', url);
      setState(() {
        _savedUrl = url;
      });
      CustomSnackbar.show(
        context: context,
        message: 'WebSocket URL saved successfully!',
      );
    } else {
      CustomSnackbar.show(
        context: context,
        message: 'Please enter a valid URL',
      );
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customScaffoldColor,
      appBar: AppBar(
        title: const Text('WebSocket Settings'),
        backgroundColor: AppColors.customThemeColor,
        foregroundColor: AppColors.customWhiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set WebSocket URL',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.customBlackColor,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'WebSocket URL',
                hintText: 'e.g., ws://192.168.192.24:8765',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.customThemeColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUrl,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.customThemeColor,
                foregroundColor: AppColors.customWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
              child: const Text('Save URL'),
            ),
            const SizedBox(height: 20),
            Text(
              'Current WebSocket URL: $_savedUrl',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.customBlackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
