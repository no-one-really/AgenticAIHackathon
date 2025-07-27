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
    'Device Setup',
    'Connectivity Issues',
    'Automation Rules',
    'Sensor Calibration',
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
            'Hello! I\'m your IoT specialist ready to help with device setup, troubleshooting, and automation. What can I assist you with today?',
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

    if (message.contains('device setup') || message.contains('setup')) {
      return '🔧 **Device Setup Guide**\n\nFor new IoT device installation:\n\n**Step 1:** Power on device and check LED indicators\n**Step 2:** Download companion app or access web portal\n**Step 3:** Connect device to Wi-Fi network\n**Step 4:** Register device with your farm hub\n**Step 5:** Configure device settings and thresholds\n\n**Diagnostic Tools Available:**\n```\npython device_scanner.py --scan\n```\n\nWhich specific device are you setting up? I can provide device-specific instructions.';
    } else if (message.contains('connectivity') ||
        message.contains('connection') ||
        message.contains('network')) {
      return '📡 **Connectivity Troubleshooting**\n\n**Common Issues & Solutions:**\n\n🔴 **No Connection:**\n• Check Wi-Fi signal strength (-70 dBm or better)\n• Verify network credentials\n• Restart device and router\n\n🟡 **Intermittent Connection:**\n• Update device firmware\n• Check for network interference\n• Optimize antenna positioning\n\n**Network Diagnostics:**\n```bash\nping device_ip_address\nnslookup farm-hub.local\n```\n\n**Device Status:** 🟢 Hub Online | 🟡 3 devices need attention\n\nWould you like me to run remote diagnostics on a specific device?';
    } else if (message.contains('automation') ||
        message.contains('rules') ||
        message.contains('workflow')) {
      return '🤖 **Automation Rules Configuration**\n\n**Smart Irrigation Example:**\n```yaml\nautomation_rule:\n  trigger: soil_moisture < 30%\n  condition: time between 06:00-18:00\n  action: \n    - activate_irrigation: zone_1\n    - duration: 15_minutes\n    - notify: farmer_mobile\n```\n\n**Available Triggers:**\n• Sensor thresholds (moisture, pH, temperature)\n• Time-based schedules\n• Weather conditions\n• Manual overrides\n\n**Safety Protocols:**\n✅ Confirm all automation actions\n⚠️ Emergency stop always available\n🔒 Require confirmation for critical operations\n\nWhat automation workflow would you like to set up?';
    } else if (message.contains('calibration') ||
        message.contains('sensor') ||
        message.contains('calibrate')) {
      return '⚡ **Sensor Calibration Protocol**\n\n**pH Sensor Calibration:**\n1. Prepare buffer solutions (pH 4.0, 7.0, 10.0)\n2. Clean sensor probe thoroughly\n3. Calibrate using 2-point method:\n\n```python\n# Calibration sequence\nsensor.calibrate_start()\nsensor.set_buffer_ph(7.0)  # Neutral\nsensor.set_buffer_ph(4.0)  # Acidic\nsensor.calibration_complete()\n```\n\n**Moisture Sensor:**\n• Dry calibration: Air exposure (0%)\n• Wet calibration: Distilled water (100%)\n• Validation: Known soil samples\n\n**Temperature Sensors:**\n• Compare with certified thermometer\n• Account for ambient temperature drift\n\n**Calibration Schedule:**\n📅 pH sensors: Monthly\n📅 Moisture: Bi-weekly\n📅 Temperature: Quarterly\n\nWhich sensors need calibration? I can guide you through the specific process.';
    } else if (message.contains('diagnostics') ||
        message.contains('troubleshoot') ||
        message.contains('error')) {
      return '🔍 **System Diagnostics Report**\n\n**Current Device Status:**\n```\n┌─────────────────┬────────┬──────────┐\n│ Device          │ Status │ Last Seen│\n├─────────────────┼────────┼──────────┤\n│ Soil Sensor #1  │ 🟢 OK  │ 2 min    │\n│ Weather Station │ 🟢 OK  │ 1 min    │\n│ Pump Controller │ 🟡 WARN│ 5 min    │\n│ Gate Motor      │ 🔴 ERR │ 15 min   │\n└─────────────────┴────────┴──────────┘\n```\n\n**Issue Detected:**\n⚠️ Gate Motor: Communication timeout\n\n**Recommended Actions:**\n1. Check power supply and connections\n2. Restart device using reset button\n3. Update firmware if available\n4. Contact support if issue persists\n\nWould you like me to run extended diagnostics or help with a specific device issue?';
    } else {
      return '🌾 **IoT Farm Assistant Ready**\n\nI specialize in connected device management for smart farming systems. I can help with:\n\n🔧 **Device Management:**\n• Setup and configuration\n• Firmware updates\n• Performance monitoring\n\n📊 **Data & Analytics:**\n• Sensor data interpretation\n• Trend analysis\n• Predictive maintenance\n\n⚙️ **Automation:**\n• Rule creation and editing\n• Workflow optimization\n• Safety protocols\n\n🔧 **Technical Support:**\n• Troubleshooting guidance\n• Network diagnostics\n• Remote assistance\n\n**Quick Actions Available:**\n• View device status\n• Run diagnostics\n• Update automation rules\n• Schedule maintenance\n\nWhat IoT challenge can I help you solve today?';
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
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(8),
                // Circuit pattern effect
                border: Border.all(
                  color: const Color(0xFF388E3C),
                  width: 1,
                ),
              ),
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
                Row(
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'IoT Specialist • 12 devices online',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Device control panel quick access
              Navigator.pushNamed(context, '/device-control-panel');
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              size: 5.w,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Technical status bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'wifi',
                  color: const Color(0xFF4CAF50),
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Hub Connected • Last sync: 1 min ago',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'v2.1.4',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF388E3C),
                        width: 1,
                      ),
                    ),
                    child: SizedBox(
                      width: 4.w,
                      height: 4.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'IoT Agent is analyzing systems...',
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
