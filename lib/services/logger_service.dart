import 'dart:developer' as dev_log;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lista_compras/controller/auth_controller.dart';

class LoggerService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace,
  ) async {
    // Get user information
    final AuthController authController = Get.find<AuthController>();
    final userId = authController.user?.uid ?? 'anonymous';

    // Log to console for immediate debugging
    dev_log.log(
      'Caught error: ${exception.toString()}',
      stackTrace: stackTrace,
      name: 'LoggerService',
      error: exception,
    );

    // Prepare data for Firestore
    final logData = {
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
      'errorMessage': exception.toString(),
      'stackTrace': stackTrace.toString(),
    };

    // Add error code if available (from FirebaseExceptions, etc.)
    if (exception is FirebaseException) {
      logData['errorCode'] = exception.code;
    }

    // Write to Firestore
    try {
      await _firestore.collection('error_logs').add(logData);
    } catch (e) {
      // If logging to Firestore fails, log that failure to the console.
      // This is a fallback to avoid an infinite loop of logging errors.
      dev_log.log(
        'Failed to write to error_logs collection: ${e.toString()}',
        name: 'LoggerService',
      );
    }
  }
}
