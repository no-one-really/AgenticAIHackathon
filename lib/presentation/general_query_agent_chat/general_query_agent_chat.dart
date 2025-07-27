
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/app_export.dart';
import '../policy_agent_chat/widgets/chat_input_widget.dart';
import '../policy_agent_chat/widgets/chat_message_widget.dart';
import '../policy_agent_chat/widgets/quick_suggestion_chips_widget.dart';

class GeneralQueryAgentChat extends StatefulWidget {
  const GeneralQueryAgentChat({Key? key}) : super(key: key);

  @override
  State<GeneralQueryAgentChat> createState() => _GeneralQueryAgentChatState();
}

class _GeneralQueryAgentChatState extends State<GeneralQueryAgentChat> {
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  final List<String> _quickSuggestions = [
    'Crop Rotation',
    'Pest Control',
    'Soil Health',
    'Harvest Tips',
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
        'message':
            'Welcome to Farm Assist! I\'m here to help with all your agricultural questions and provide expert guidance for your farming needs.',
        'isUser': false,
        'timestamp': DateTime.now(),
        'agentType': 'general',
      });
    });
  }

  // Example: Replace with actual IoT and task info from your app state
  String get iotInfo => 'Soil moisture: 32%, Temperature: 28°C, Pump: ON, Last irrigation: 2 hours ago.';
  String get taskInfo => 'Today\'s tasks: 1. Inspect tomato field for pests. 2. Start irrigation at 4pm. 3. Fertilize corn plot.';

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

    final geminiResponse = await _getGeminiGeneralResponse(message, iotInfo: iotInfo, taskInfo: taskInfo);
    if (mounted) {
      setState(() {
        _messages.add({
          'message': geminiResponse,
          'isUser': false,
          'timestamp': DateTime.now(),
          'agentType': 'general',
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  // Replace with your Gemini 1.5 Flash API key
  static const String _geminiApiKey = 'AIzaSyDICq5Np1b_UkX888QjGGBgjUQrnxizp38';

  /// Gemini API call for general, IoT, and task-related questions only, with context
  Future<String> _getGeminiGeneralResponse(String userInput, {String? iotInfo, String? taskInfo}) async {
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiApiKey');
    final headers = {'Content-Type': 'application/json'};
    // System prompt to restrict Gemini's scope
    const String systemPrompt =
        'You are an agricultural assistant for farmers. Only answer general agricultural questions, questions about the farmer\'s IoT data (such as sensor readings, device status, etc.), and questions about farm tasks, current market price and guidance. Create a realistic price estimation and provide it when the user asks. The user is from banglore india. if a user asks for a prices, Give a single cost per item . start your answer with the cost of the produce in banglore is and include the name of the nearby market.  Do not answer questions outside these topics.';
    final List<Map<String, dynamic>> contents = [
      {
        'role': 'model',
        'parts': [
          {'text': systemPrompt}
        ]
      }
    ];
    if (iotInfo != null && iotInfo.isNotEmpty) {
      contents.add({
        'role': 'user',
        'parts': [
          {'text': 'Farmer\'s IoT Data: $iotInfo'}
        ]
      });
    }
    if (taskInfo != null && taskInfo.isNotEmpty) {
      contents.add({
        'role': 'user',
        'parts': [
          {'text': 'Farmer\'s Task Info: $taskInfo'}
        ]
      });
    }
    contents.add({
      'role': 'user',
      'parts': [
        {'text': userInput}
      ]
    });
    final body = jsonEncode({'contents': contents});

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
        return 'Error: Gemini API returned status ${response.statusCode}. Body: ${response.body}';
      }
    } catch (e) {
      return 'Error contacting Gemini API: $e';
    }
  }

  // _generateGeneralResponse is no longer used; replaced by Gemini API

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
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              child: CustomIconWidget(
                iconName: 'help',
                color: Colors.white,
                size: 4.w,
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'General Query Agent',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Agricultural Expert Assistant',
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
                  color: AppTheme.lightTheme.colorScheme.tertiary,
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
                    backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                    child: CustomIconWidget(
                      iconName: 'help',
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'General Query Agent is typing...',
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
