import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class RealtimeController extends GetxController {
  CameraController? cameraController;
  var isCameraInitialized = false.obs;
  var isDetecting = false.obs;
  var detections = [].obs;
  
  // Additional properties for fresh/rotten detection
  var lastDetectionTime = DateTime.now().obs;
  var detectionCount = 0.obs;
  var averageConfidence = 0.0.obs;
  
  Timer? _detectionTimer;

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  @override
  void onClose() {
    _detectionTimer?.cancel();
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        Get.snackbar(
          'Error',
          'No cameras available',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      final camera = cameras.first;

      cameraController = CameraController(
        camera,
        ResolutionPreset.high, // Changed from veryHigh to reduce processing load
        enableAudio: false,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;

      // Show success message
      Get.snackbar(
        'Camera Ready',
        'Freshness detector is now active',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      startFrameLoop();
    } catch (e) {
      print("❌ Camera initialization error: $e");
      Get.snackbar(
        'Camera Error',
        'Failed to initialize camera: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void startFrameLoop() {
    // Increased interval to 3 seconds for better performance
    _detectionTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      if (!isCameraInitialized.value || isDetecting.value) return;

      try {
        isDetecting.value = true;

        final imageFile = await captureFrame();
        if (imageFile != null) {
          await sendToServer(imageFile);
          // Clean up temporary file
          await imageFile.delete();
        }
      } catch (e) {
        print("❌ Detection error: $e");
        // Clear detections on error to avoid showing stale data
        detections.clear();
      } finally {
        isDetecting.value = false;
      }
    });
  }

  Future<File?> captureFrame() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return null;
    }

    try {
      final dir = await getTemporaryDirectory();
      final imagePath = join(dir.path, "fresh_detection_${DateTime.now().millisecondsSinceEpoch}.jpg");

      final XFile picture = await cameraController!.takePicture();
      final File imageFile = File(picture.path);
      
      // Copy to our specific path
      return await imageFile.copy(imagePath);
    } catch (e) {
      print("❌ Capture error: $e");
      return null;
    }
  }

  Future<void> sendToServer(File image) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.68.234:5000/predict'), // Update your Flask server IP
      );

      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      
      // Add timeout to prevent hanging
      final response = await request.send().timeout(Duration(seconds: 10));
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        
        // Update detections with fresh/rotten specific processing
        if (data['detections'] != null && data['detections'].isNotEmpty) {
          detections.value = _processFreshRottenDetections(data['detections']);
          lastDetectionTime.value = DateTime.now();
          detectionCount.value++;
          
          // Calculate average confidence
          double totalConfidence = 0.0;
          for (var detection in detections) {
            totalConfidence += detection['confidence'];
          }
          averageConfidence.value = totalConfidence / detections.length;
          
          // Show notification for important detections
          _showDetectionNotification();
        } else {
          detections.clear();
        }
      } else {
        print("❌ Server error: ${response.statusCode}");
        print("Response: $responseBody");
        
        // Show user-friendly error message
        if (response.statusCode == 404) {
          Get.snackbar(
            'Server Error',
            'Detection service not available',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      print("❌ Network error: $e");
      
      // Handle different types of errors
      if (e.toString().contains('TimeoutException')) {
        Get.snackbar(
          'Timeout',
          'Detection taking too long, please try again',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  List<Map<String, dynamic>> _processFreshRottenDetections(List<dynamic> rawDetections) {
    List<Map<String, dynamic>> processedDetections = [];
    
    for (var detection in rawDetections) {
      // Ensure the detection has required fields
      if (detection['class'] != null && detection['confidence'] != null && detection['bbox'] != null) {
        Map<String, dynamic> processed = {
          'class': _normalizeFreshnessClass(detection['class']),
          'confidence': detection['confidence'].toDouble(),
          'bbox': detection['bbox'],
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };
        
        // Only include detections with reasonable confidence
        if (processed['confidence'] > 0.3) {
          processedDetections.add(processed);
        }
      }
    }
    
    return processedDetections;
  }

  String _normalizeFreshnessClass(String className) {
    // Normalize different variations of class names
    String normalized = className.toLowerCase().trim();
    
    // Map various fresh indicators
    if (normalized.contains('fresh') || normalized.contains('good') || normalized.contains('healthy')) {
      return 'fresh';
    }
    
    // Map various rotten indicators
    if (normalized.contains('rotten') || normalized.contains('spoiled') || 
        normalized.contains('bad') || normalized.contains('decay')) {
      return 'rotten';
    }
    
    // Map overripe indicators
    if (normalized.contains('overripe') || normalized.contains('over-ripe')) {
      return 'overripe';
    }
    
    // Map unripe indicators
    if (normalized.contains('unripe') || normalized.contains('under-ripe') || normalized.contains('green')) {
      return 'unripe';
    }
    
    // Return original if no mapping found
    return className;
  }

  void _showDetectionNotification() {
    // Only show notifications for important detections
    bool hasRottenItems = detections.any((d) => d['class'].toLowerCase().contains('rotten'));
    bool hasHighConfidenceFresh = detections.any((d) => 
        d['class'].toLowerCase().contains('fresh') && d['confidence'] > 0.8);
    
    if (hasRottenItems) {
      Get.snackbar(
        '⚠️ Warning',
        'Spoiled items detected - do not consume',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else if (hasHighConfidenceFresh) {
      Get.snackbar(
        '✅ Fresh',
        'Items appear fresh and safe to consume',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }
  }

  // Method to manually trigger detection (for testing)
  Future<void> triggerManualDetection() async {
    if (isDetecting.value) return;
    
    try {
      isDetecting.value = true;
      final imageFile = await captureFrame();
      if (imageFile != null) {
        await sendToServer(imageFile);
        await imageFile.delete();
      }
    } catch (e) {
      print("❌ Manual detection error: $e");
    } finally {
      isDetecting.value = false;
    }
  }

  // Method to clear current detections
  void clearDetections() {
    detections.clear();
    detectionCount.value = 0;
    averageConfidence.value = 0.0;
  }

  // Method to get detection statistics
  Map<String, int> getDetectionStats() {
    Map<String, int> stats = {
      'fresh': 0,
      'rotten': 0,
      'overripe': 0,
      'unripe': 0,
      'other': 0,
    };
    
    for (var detection in detections) {
      String className = detection['class'].toLowerCase();
      if (stats.containsKey(className)) {
        stats[className] = stats[className]! + 1;
      } else {
        stats['other'] = stats['other']! + 1;
      }
    }
    
    return stats;
  }
}