import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../policy_agent_chat/widgets/chat_input_widget.dart';
import '../policy_agent_chat/widgets/chat_message_widget.dart';
import '../policy_agent_chat/widgets/quick_suggestion_chips_widget.dart';

class IoTAgentChat extends StatefulWidget {
  const IoTAgentChat({Key? key}) : super(key: key);

  @override
  State<IoTAgentChat> createState() => _IoTAgentChatState();
}

class _IoTAgentChatState extends State<IoTAgentChat> {
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  final List<String> _quickSuggestions = [
    'Device Status',
    'Sensor Data',
    'Connectivity Issues',
    'Device Setup',
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
            'Hello! I\'m your IoT specialist here to help with all your smart farming devices, sensors, and connectivity solutions. How can I assist you today?',
        'isUser': false,
        'timestamp': DateTime.now(),
        'agentType': 'iot',
      });
    });
  }

  void _sendMessage(String message) {
    setState(() {
      _messages.add({
        'message': message,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _isLoading = true;
    });

    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'message': _generateIoTResponse(message),
            'isUser': false,
            'timestamp': DateTime.now(),
            'agentType': 'iot',
          });
          _isLoading = false;
        });
        _scrollToBottom();
      }
    });
  }

  String _generateIoTResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    if (message.contains('device status') || message.contains('status')) {
      return 'Here\'s your current device status overview:\n\n📟 **Active Devices:** 8/10 online\n🌡️ **Temperature Sensors:** ✅ All functioning\n💧 **Moisture Sensors:** ⚠️ Sensor #3 needs calibration\n📡 **Gateway Connection:** ✅ Strong signal\n🔋 **Battery Levels:** 85% average\n\n**Alerts:**\n• Soil sensor #3 requires attention\n• Weather station needs firmware update\n\nWould you like detailed information about any specific device?';
    } else if (message.contains('sensor') || message.contains('data')) {
      return 'Current sensor readings from your farm:\n\n🌡️ **Temperature Sensors:**\n• Field A: 24.5°C (Optimal)\n• Field B: 26.1°C (Good)\n• Greenhouse: 28.8°C (High)\n\n💧 **Soil Moisture:**\n• Field A: 45% (Good)\n• Field B: 32% (Low - irrigation recommended)\n• Field C: 67% (High)\n\n📊 **Data Trends:**\n• Temperature rising by 2°C over 3 days\n• Moisture levels declining in Field B\n\nWould you like me to set up automated alerts for any of these readings?';
    } else if (message.contains('connectivity') ||
        message.contains('connection') ||
        message.contains('offline')) {
      return 'Let\'s troubleshoot your connectivity issues:\n\n🔍 **Common Solutions:**\n\n1️⃣ **Check Power Supply**\n• Verify all devices are powered on\n• Check battery levels on wireless sensors\n\n2️⃣ **Network Connection**\n• Restart your gateway device\n• Check WiFi signal strength\n• Verify internet connectivity\n\n3️⃣ **Device Reset**\n• Hold reset button for 10 seconds\n• Wait for LED to flash blue\n• Reconnect through the app\n\n📞 **Still having issues?**\nI can run a remote diagnostic. Which specific devices are having problems?';
    } else if (message.contains('setup') ||
        message.contains('install') ||
        message.contains('configure')) {
      return 'I\'ll guide you through device setup! Here\'s the process:\n\n📱 **Step-by-Step Setup:**\n\n1️⃣ **Physical Installation**\n• Place sensors at optimal locations\n• Ensure weatherproof connections\n• Check power/battery connections\n\n2️⃣ **Network Configuration**\n• Connect to Farm Assist WiFi\n• Enter your network credentials\n• Wait for green LED confirmation\n\n3️⃣ **App Integration**\n• Open Farm Assist app\n• Tap "Add Device"\n• Scan QR code on device\n• Follow calibration prompts\n\n🔧 **Need help with a specific device type?**\nTell me what you\'re setting up (soil sensor, weather station, irrigation controller, etc.)';
    } else {
      return 'I\'m your IoT support specialist! I can help you with:\n\n🌐 **Device Management:**\n• Status monitoring and diagnostics\n• Configuration and setup\n• Firmware updates\n\n📊 **Data & Analytics:**\n• Sensor readings interpretation\n• Historical data analysis\n• Alert configuration\n\n🔧 **Technical Support:**\n• Connectivity troubleshooting\n• Device calibration\n• Performance optimization\n\n🆕 **New Features:**\n• Device recommendations\n• Integration with third-party systems\n\nWhat specific IoT challenge can I help you solve today?';
    }
  }

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
              backgroundColor: const Color(0xFF4CAF50),
              child: CustomIconWidget(
                iconName: 'devices',
                color: Colors.white,
                size: 4.w,
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IoT Agent',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Smart Device Specialist',
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
                  color: const Color(0xFF4CAF50),
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
                    backgroundColor: const Color(0xFF4CAF50),
                    child: CustomIconWidget(
                      iconName: 'devices',
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'IoT Agent is typing...',
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
