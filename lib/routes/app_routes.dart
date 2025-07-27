import 'package:flutter/material.dart';
import '../presentation/farm_dashboard/farm_dashboard.dart';
import '../presentation/weather_details/weather_details.dart';
import '../presentation/device_control_panel/device_control_panel.dart';
import '../presentation/io_t_hub/io_t_hub.dart';
import '../presentation/task_management/task_management.dart';
import '../presentation/policy_agent_chat/policy_agent_chat.dart';
import '../presentation/general_query_agent_chat/general_query_agent_chat.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String farmDashboard = '/farm-dashboard';
  static const String weatherDetails = '/weather-details';
  static const String deviceControlPanel = '/device-control-panel';
  static const String ioTHub = '/io-t-hub';
  static const String taskManagement = '/task-management';
  static const String policyAgentChat = '/policy-agent-chat';
  static const String generalQueryAgentChat = '/general-query-agent-chat';
  static const String iotAgentChat = '/iot-agent-chat';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const FarmDashboard(),
    farmDashboard: (context) => const FarmDashboard(),
    weatherDetails: (context) => const WeatherDetails(),
    deviceControlPanel: (context) => const DiseaseDetectionPage(),
    ioTHub: (context) => const IoTHub(),
    taskManagement: (context) => const TaskManagement(),
    policyAgentChat: (context) => const PolicyAgentChat(),
    generalQueryAgentChat: (context) => const GeneralQueryAgentChat(),
    // TODO: Add your other routes here
  };
}