
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/app_export.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/quick_suggestion_chips_widget.dart';

class PolicyAgentChat extends StatefulWidget {
  const PolicyAgentChat({Key? key}) : super(key: key);

  @override
  State<PolicyAgentChat> createState() => _PolicyAgentChatState();
}

class _PolicyAgentChatState extends State<PolicyAgentChat> {
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  final List<String> _quickSuggestions = [
    'Subsidy Information',
    'Organic Certification',
    'Water Rights',
    'Land Use Policies',
  ];

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addInitialMessage() {
    setState(() {
      _messages.add({
        'message': 'Hi how can I help you',
        'isUser': false,
        'timestamp': DateTime.now(),
        'agentType': 'policy',
      });
    });
  }

  void _sendMessage(String message) async {
    setState(() {
      _messages.add({
        'message': message,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _isLoading = true;
    });

    _scrollToBottom();

    final geminiResponse = await _getGeminiResponse(message);
    if (mounted) {
      setState(() {
        _messages.add({
          'message': geminiResponse,
          'isUser': false,
          'timestamp': DateTime.now(),
          'agentType': 'policy',
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  // Replace with your Gemini 1.5 Flash API key
  static const String _geminiApiKey = 'AIzaSyDICq5Np1b_UkX888QjGGBgjUQrnxizp38';

  Future<String> _getGeminiResponse(String userInput) async {
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiApiKey');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text':"Please give me information about the following policy. Give nothing but the policy details from india. Mention Policy Name, who is eligible for it. How to avail it"+ userInput}
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'];
        if (candidates != null && candidates.isNotEmpty) {
          final parts = candidates[0]['content']['parts'];
          if (parts != null && parts.isNotEmpty) {
            return parts[0]['text'] ?? 'Sorry, I could not generate a response.';
          }
        }
        return 'Sorry, I could not generate a response.';
      } else {
        return 'Error: Gemini API returned status ${response.statusCode}.';
      }
    } catch (e) {
      return 'Error contacting Gemini API: $e';
    }
  }

  // _generatePolicyResponse is no longer used; replaced by Gemini API

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 4.w,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              child: CustomIconWidget(
                iconName: 'gavel',
                color: Colors.white,
                size: 4.w,
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Policy Agent',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Agricultural Policy Assistant',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_messages.isEmpty)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatMessageWidget(
                    message: message['message'],
                    isUser: message['isUser'],
                    timestamp: message['timestamp'],
                    agentType: message['agentType'],
                  );
                },
              ),
            ),
          if (_isLoading)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 4.w,
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    child: CustomIconWidget(
                      iconName: 'gavel',
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Policy Agent is typing...',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          QuickSuggestionChipsWidget(
            suggestions: _quickSuggestions,
            onSuggestionTap: _sendMessage,
          ),
          ChatInputWidget(
            onSendMessage: _sendMessage,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
