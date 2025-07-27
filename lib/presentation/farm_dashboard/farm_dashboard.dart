import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../weather_details/widgets/agricultural_insights_widget.dart';
import './widgets/iot_sensor_card_widget.dart';
import './widgets/quick_action_fab_widget.dart';
import './widgets/weather_card_widget.dart';

class FarmDashboard extends StatefulWidget {
  const FarmDashboard({Key? key}) : super(key: key);

  @override
  State<FarmDashboard> createState() => _FarmDashboardState();
}

class _FarmDashboardState extends State<FarmDashboard> with TickerProviderStateMixin {
  // Agricultural Insights data (moved from insights page)
  final Map<String, dynamic> _agriculturalInsights = {
    "sprayingTime": "Early Morning (5-7 AM)",
    "sprayingAdvice":
        "Current weather conditions are ideal for pesticide application. Low wind speed and moderate humidity will ensure effective coverage and minimal drift.",
    "irrigationStatus": "Moderate Need",
    "irrigationAdvice":
        "Soil moisture levels are adequate but consider light irrigation in 2-3 days. Monitor weather forecast for upcoming rainfall.",
    "harvestStatus": "Optimal Window",
    "harvestAdvice":
        "Weather conditions are perfect for harvesting. Clear skies and low humidity will help maintain crop quality during harvest operations.",
  };
  late TabController _tabController;
  bool _isRefreshing = false;

  // Mock data for IoT sensors
  final List<Map<String, dynamic>> _sensorData = [
   
  ];

  final List<String> _tabs = ['Dashboard', 'IoT Hub', 'Tasks', 'Settings'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshWeatherData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Weather data updated successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }



  void _onSensorTap(Map<String, dynamic> sensor) {
    Navigator.pushNamed(context, '/device-control-panel');
  }

  void _onSensorLongPress(Map<String, dynamic> sensor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSensorActionSheet(sensor),
    );
  }

  Widget _buildSensorActionSheet(Map<String, dynamic> sensor) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            '${sensor["type"]} Actions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildActionTile(
            icon: 'tune',
            title: 'Calibrate Sensor',
            subtitle: 'Adjust sensor readings',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calibration started')),
              );
            },
          ),
          _buildActionTile(
            icon: 'notifications',
            title: 'Set Alerts',
            subtitle: 'Configure threshold alerts',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alert settings opened')),
              );
            },
          ),
          _buildActionTile(
            icon: 'history',
            title: 'View History',
            subtitle: 'See historical data',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History view opened')),
              );
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: _buildDashboardTab(),
      floatingActionButton: QuickActionFabWidget(
        onIrrigationTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Irrigation system activated'),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onPestControlTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Pest control drones deployed'),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onEmergencyTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Emergency Alert'),
              content: const Text(
                  'Emergency protocols have been activated. All systems are being monitored.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Current screen - do nothing
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/io-t-hub');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/task-management');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/weather-details');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/device-control-panel');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'hub',
              color: AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'hub',
              color: AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'IoT Hub',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'task_alt',
              color: AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'task_alt',
              color: AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'wb_cloudy',
              color: AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'wb_cloudy',
              color: AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings_remote',
              color: AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'settings_remote',
              color: AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Analyze',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshWeatherData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h), // Increased space above Hello, Farmer!
            // Hello message and profile pic
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, Farmer!',
                        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        'Welcome back to your dashboard',
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            WeatherCardWidget(
              location: 'Bangalore',
              temperature: '24°C',
              weatherCondition: 'Partly Cloudy',
              onRefresh: _isRefreshing ? null : _refreshWeatherData,
            ),
            SizedBox(height: 3.h),
            // Agricultural Insights section
            AgriculturalInsightsWidget(insightsData: _agriculturalInsights),
            SizedBox(height: 3.h),
            // Remove IoT Sensor Summary title, just show the list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sensorData.length,
              itemBuilder: (context, index) {
                final sensor = _sensorData[index];
                return IoTSensorCardWidget(
                  sensorType: sensor["type"] as String,
                  currentValue: sensor["value"] as String,
                  unit: sensor["unit"] as String,
                  status: sensor["status"] as String,
                  lastUpdated: sensor["lastUpdated"] as String,
                  statusColor: sensor["statusColor"] as Color,
                  trendIcon: sensor["trend"] == "up"
                      ? Icons.trending_up
                      : Icons.trending_down,
                  onTap: () => _onSensorTap(sensor),
                  onLongPress: () => _onSensorLongPress(sensor),
                );
              },
            ),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }


}
