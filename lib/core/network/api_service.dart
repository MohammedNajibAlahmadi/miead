import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    // Determine baseUrl dynamically based on platform (Android Emulator uses 10.0.2.2)
    String baseUrl = 'http://localhost:5164/api';
    if (!kIsWeb && Platform.isAndroid) {
      baseUrl = 'http://10.0.2.2:5164/api';
    }

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  }

  Future<void> pushTasks(List<Map<String, dynamic>> tasks) async {
    for (var task in tasks) {
      try {
        // Mapped payload structure matching the Entity Framework C# TaskItem model
        final Map<String, dynamic> payload = {
          'id': task['id'],
          'title': task['title'],
          'isCompleted': (task['is_completed'] == 1),
          // Ensure standard ISO8601 formatting for absolute server sync timing
          'createdAt': DateTime.now().toUtc().toIso8601String() 
        };
        
        await _dio.post('/Tasks', data: payload);
        print('Synced task: ${task['title']}');
      } catch (e) {
        print('Sync error for task ${task['id']}: $e');
      }
    }
  }
}
