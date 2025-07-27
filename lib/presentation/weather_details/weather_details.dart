import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/agricultural_insights_widget.dart';
import './widgets/daily_forecast_widget.dart';
import './widgets/hourly_forecast_widget.dart';
import './widgets/weather_header_widget.dart';
import './widgets/weather_hero_widget.dart';
import './widgets/weather_metrics_widget.dart';

class WeatherDetails extends StatefulWidget {
  const WeatherDetails({super.key});

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  bool _isRefreshing = false;

  // Mock weather data
  final Map<String, dynamic> _currentWeather = {
    "location": "Bangalore",
    "temperature": "24°C",
    "condition": "Partly Cloudy",
    "weatherIcon":
        "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
  };

  final List<Map<String, dynamic>> _hourlyForecast = [
    {
      "time": "Now",
      "temp": 24,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 20,
      "windSpeed": "8 km/h",
    },
    {
      "time": "1 PM",
      "temp": 26,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 15,
      "windSpeed": "10 km/h",
    },
    {
      "time": "2 PM",
      "temp": 28,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 10,
      "windSpeed": "12 km/h",
    },
    {
      "time": "3 PM",
      "temp": 29,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 5,
      "windSpeed": "15 km/h",
    },
    {
      "time": "4 PM",
      "temp": 27,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 25,
      "windSpeed": "18 km/h",
    },
    {
      "time": "5 PM",
      "temp": 25,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 30,
      "windSpeed": "20 km/h",
    },
  ];

  final Map<String, dynamic> _weatherMetrics = {
    "humidity": 65,
    "uvIndex": 7,
    "visibility": 10,
    "pressure": 1013,
    "sunrise": "6:15 AM",
    "sunset": "6:45 PM",
  };

  final List<Map<String, dynamic>> _dailyForecast = [
    {
      "day": "Today",
      "high": 29,
      "low": 22,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 20,
      "hourlyBreakdown": [
        {
          "time": "6 AM",
          "temp": 22,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "12 PM",
          "temp": 28,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "6 PM",
          "temp": 25,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
      ],
    },
    {
      "day": "Tomorrow",
      "high": 31,
      "low": 24,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 10,
      "hourlyBreakdown": [
        {
          "time": "6 AM",
          "temp": 24,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "12 PM",
          "temp": 30,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "6 PM",
          "temp": 27,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
      ],
    },
    {
      "day": "Wednesday",
      "high": 28,
      "low": 21,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 40,
      "hourlyBreakdown": [
        {
          "time": "6 AM",
          "temp": 21,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "12 PM",
          "temp": 27,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "6 PM",
          "temp": 24,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
      ],
    },
    {
      "day": "Thursday",
      "high": 26,
      "low": 19,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 60,
      "hourlyBreakdown": [
        {
          "time": "6 AM",
          "temp": 19,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "12 PM",
          "temp": 25,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "6 PM",
          "temp": 22,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
      ],
    },
    {
      "day": "Friday",
      "high": 30,
      "low": 23,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 15,
      "hourlyBreakdown": [
        {
          "time": "6 AM",
          "temp": 23,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "12 PM",
          "temp": 29,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "6 PM",
          "temp": 26,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
      ],
    },
    {
      "day": "Saturday",
      "high": 32,
      "low": 25,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 5,
      "hourlyBreakdown": [
        {
          "time": "6 AM",
          "temp": 25,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "12 PM",
          "temp": 31,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "6 PM",
          "temp": 28,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
      ],
    },
    {
      "day": "Sunday",
      "high": 29,
      "low": 22,
      "icon":
          "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "precipitation": 25,
      "hourlyBreakdown": [
        {
          "time": "6 AM",
          "temp": 22,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "12 PM",
          "temp": 28,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
        {
          "time": "6 PM",
          "temp": 25,
          "icon":
              "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        },
      ],
    },
  ];


  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Weather data updated successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Weather settings coming soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                WeatherHeaderWidget(
                  location: _currentWeather['location'] as String,
                  onRefresh: _handleRefresh,
                  onSettings: _handleSettings,
                ),
                WeatherHeroWidget(
                  temperature: _currentWeather['temperature'] as String,
                  condition: _currentWeather['condition'] as String,
                  weatherIcon: _currentWeather['weatherIcon'] as String,
                ),
                SizedBox(height: 2.h),
                SizedBox(height: 2.h),
                WeatherMetricsWidget(metricsData: _weatherMetrics),
                SizedBox(height: 2.h),
                DailyForecastWidget(dailyData: _dailyForecast),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/farm-dashboard');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/io-t-hub');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/task-management');
              break;
            case 3:
              // Current screen - do nothing
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
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'hub',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'hub',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'IoT Hub',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'task_alt',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'task_alt',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'wb_cloudy',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'wb_cloudy',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings_remote',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'settings_remote',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 24,
            ),
            label: 'Control',
          ),
        ],
      ),
    );
  }
}
