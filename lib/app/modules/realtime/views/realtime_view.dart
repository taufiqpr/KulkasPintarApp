import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import '../controllers/realtime_controller.dart';

class RealtimeView extends StatelessWidget {
  final controller = Get.put(RealtimeController());
  final GlobalKey _cameraKey = GlobalKey(); // Tambahkan ini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.eco, color: Colors.green, size: 20),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Freshness Detector',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Fresh vs Rotten Classification',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          // Detection status indicator
          Obx(() => Container(
                margin: EdgeInsets.only(right: 16),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: controller.isDetecting.value
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: controller.isDetecting.value
                            ? Colors.orange
                            : Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      controller.isDetecting.value ? 'Scanning...' : 'Ready',
                      style: TextStyle(
                        color: controller.isDetecting.value
                            ? Colors.orange
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return _buildLoadingScreen();
        }

        final size = MediaQuery.of(context).size;
        final previewSize = controller.cameraController!.value.previewSize!;
        final scale = size.aspectRatio * previewSize.aspectRatio;

        return Stack(
          children: [
            // Camera Preview with frame
            Container(
              key: _cameraKey,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CameraPreview(controller.cameraController!),
              ),
            ),

            // Detection overlay with enhanced styling
            Container(
              margin: EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Camera frame overlay
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    // Focus area guide
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.center_focus_strong,
                              color: Colors.white.withOpacity(0.8),
                              size: 40,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Focus Here',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Enhanced bounding boxes for fresh/rotten detection
                    ...controller.detections.asMap().entries.map((entry) {
                      final det = entry.value;
                      final bbox = det['bbox'];
                      final className = det['class'];
                      final confidence =
                          (det['confidence'] * 100).toStringAsFixed(1);

                      // Pastikan context kamera tersedia
                      if (_cameraKey.currentContext == null) return Container();

                      final RenderBox renderBox = _cameraKey.currentContext!
                          .findRenderObject() as RenderBox;
                      final cameraOffset = renderBox.localToGlobal(Offset.zero);
                      final cameraSize = renderBox.size;

                      final previewSize =
                          controller.cameraController!.value.previewSize!;
                      final xRatio = cameraSize.width / previewSize.width;
                      final yRatio = cameraSize.height / previewSize.height;

                      final double x = bbox[0] * xRatio + cameraOffset.dx;
                      final double y = bbox[1] * yRatio + cameraOffset.dy;
                      final double w = (bbox[2] - bbox[0]) * xRatio;
                      final double h = (bbox[3] - bbox[1]) * yRatio;

                      return Positioned(
                        left: x,
                        top: y,
                        width: w,
                        height: h,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _getColorForFreshness(className),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: _getColorForFreshness(className)
                                    .withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -3,
                                left: -3,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        _getColorForFreshness(className),
                                        _getColorForFreshness(className)
                                            .withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getIconForFreshness(className),
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        className.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -3,
                                right: -3,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _getColorForFreshness(className),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    "$confidence%",
                                    style: TextStyle(
                                      color: _getColorForFreshness(className),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            // Top instruction banner
            Positioned(
              top: 30,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Point camera at fruits/vegetables to check freshness',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Enhanced bottom results panel
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: controller.detections.isEmpty ? 120 : 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                      Colors.black,
                    ],
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.analytics, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Freshness Analysis',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                          Obx(() => AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: controller.detections.isEmpty
                                      ? Colors.grey.withOpacity(0.3)
                                      : _getOverallStatusColor()
                                          .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  controller.detections.isEmpty
                                      ? 'No items detected'
                                      : _getOverallStatus(),
                                  style: TextStyle(
                                    color: controller.detections.isEmpty
                                        ? Colors.grey[400]
                                        : _getOverallStatusColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: Obx(() {
                          if (controller.detections.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.eco,
                                    color: Colors.grey[400],
                                    size: 32,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Place fruits or vegetables in focus area',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.detections.length,
                            itemBuilder: (context, index) {
                              final det = controller.detections[index];
                              final className = det['class'];
                              final confidence =
                                  (det['confidence'] * 100).toStringAsFixed(1);

                              return Container(
                                margin: EdgeInsets.only(right: 16),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _getColorForFreshness(className)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _getColorForFreshness(className)
                                        .withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getIconForFreshness(className),
                                      color: _getColorForFreshness(className),
                                      size: 32,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      className.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '$confidence% confident',
                                      style: TextStyle(
                                        color: _getColorForFreshness(className),
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _getRecommendation(className),
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Initializing Freshness Detector...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Setting up AI classification system',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForFreshness(String className) {
    switch (className.toLowerCase()) {
      case 'fresh':
        return Colors.green;
      case 'rotten':
      case 'spoiled':
        return Colors.red;
      case 'overripe':
        return Colors.orange;
      case 'unripe':
        return Colors.yellow;
      default:
        return Colors.blue;
    }
  }

  IconData _getIconForFreshness(String className) {
    switch (className.toLowerCase()) {
      case 'fresh':
        return Icons.eco;
      case 'rotten':
      case 'spoiled':
        return Icons.warning;
      case 'overripe':
        return Icons.schedule;
      case 'unripe':
        return Icons.hourglass_empty;
      default:
        return Icons.help_outline;
    }
  }

  String _getRecommendation(String className) {
    switch (className.toLowerCase()) {
      case 'fresh':
        return 'Good to eat!';
      case 'rotten':
      case 'spoiled':
        return 'Do not consume';
      case 'overripe':
        return 'Use quickly';
      case 'unripe':
        return 'Wait to ripen';
      default:
        return 'Check manually';
    }
  }

  Color _getOverallStatusColor() {
    if (controller.detections.isEmpty) return Colors.grey;

    bool hasFresh =
        controller.detections.any((d) => d['class'].toLowerCase() == 'fresh');
    bool hasRotten = controller.detections.any((d) =>
        d['class'].toLowerCase() == 'rotten' ||
        d['class'].toLowerCase() == 'spoiled');

    if (hasRotten) return Colors.red;
    if (hasFresh) return Colors.green;
    return Colors.orange;
  }

  String _getOverallStatus() {
    if (controller.detections.isEmpty) return 'No detection';

    int freshCount = controller.detections
        .where((d) => d['class'].toLowerCase() == 'fresh')
        .length;
    int rottenCount = controller.detections
        .where((d) =>
            d['class'].toLowerCase() == 'rotten' ||
            d['class'].toLowerCase() == 'spoiled')
        .length;

    if (rottenCount > 0) return '$rottenCount spoiled items';
    if (freshCount > 0) return '$freshCount fresh items';
    return '${controller.detections.length} items detected';
  }
}
