import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:jobreels/util/app_constants.dart';
import 'package:jobreels/util/styles.dart';
import 'package:jobreels/view/base/custom_toast.dart';
import 'package:jobreels/view/screens/VideoCreater/recorded_video_preview.dart';
import 'dart:math' as math;

class RecordVideo extends StatefulWidget {
  const RecordVideo({super.key});

  @override
  _RecordVideoState createState() => _RecordVideoState();
}

class _RecordVideoState extends State<RecordVideo>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _availableCameras = [];
  bool _isRecording = false;
  double _zoomValue = 1.0;
  int _selectedCameraIndex = 0;
  late AnimationController animationController;
  Timer? _timer;
  Duration videoTime = const Duration();
  int _start = 89;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 90));
    animationController.addListener(() {
      setState(() {});
    });
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _availableCameras = await availableCameras();
      _cameraController = CameraController(
          _availableCameras[_selectedCameraIndex], ResolutionPreset.high,
          enableAudio: true);
      await _cameraController?.initialize();
      setState(() {});
    } on CameraException catch (e) {
      if (kDebugMode) {
        print('Error initializing camera: ${e.description}');
      }
    }
  }

  @override
  void dispose() {
    _disposeCamera();
    _timer?.cancel();
    _start = 89;
    _isRecording = false;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_cameraController == null ||
        !(_cameraController?.value.isInitialized ?? false)) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_cameraController != null) {
        onNewCameraSelected(_cameraController!.description);
      }
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_cameraController != null) {
      await _cameraController?.dispose();
    }

    _cameraController = CameraController(
      _availableCameras[0],
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // If the controller is updated then update the UI.
    _cameraController?.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if ((_cameraController?.value.hasError ?? true)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Error: ${_cameraController?.value.errorDescription ?? "Camera not initialized"}')));
      }
    });

    try {
      await _cameraController?.initialize();
    } on CameraException catch (e) {
      try {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${e.description}')));
      } catch (e) {
        debugPrint("Exception:-> $e");
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  _disposeCamera() async {
    if (_cameraController != null) {
      await _cameraController?.dispose();
    }
  }

  Future<void> _startVideoRecording() async {
    // final String filePath = '${DateTime.now().millisecondsSinceEpoch.toString()}.mp4';

    try {
      await _cameraController?.startVideoRecording();
      startTimer();
      _isRecording = true;
      setState(() {});
      animationController.forward();
    } on CameraException catch (e) {
      if (kDebugMode) {
        print('Error starting video recording: ${e.description}');
      }
    }
  }

  Future<void> _stopVideoRecording() async {
    try {
      XFile? recordedVideoFile = await _cameraController?.stopVideoRecording();
      if (recordedVideoFile != null && videoTime.inSeconds > 0) {
        Get.to(() => RecordedVideoPreview(
            videoFile: recordedVideoFile,
            isFrontCamera: _selectedCameraIndex == 1 ? true : false));
        // await FFmpegKit.execute("-y -i ${recordedVideoFile.path} -filter:v \"hflip\" ${recordedVideoFile.path}_flipped.mp4").then((_) {
        //
        // });
      }
      animationController.stop();
      _isRecording = false;
      _timer?.cancel();
      videoTime = const Duration();
      _start = 89;
      setState(() {});
    } on CameraException catch (e) {
      if (kDebugMode) {
        print('Error stopping video recording: ${e.description}');
      }
    }
  }

  void _switchCamera() {
    _selectedCameraIndex =
        (_selectedCameraIndex + 1) % _availableCameras.length;
    _initializeCamera();
  }

  void _initializeCamera() async {
    print("camera index is:${_selectedCameraIndex}");
    await _cameraController?.dispose();
    _cameraController = CameraController(
      _availableCameras[_selectedCameraIndex],
      ResolutionPreset.high,
    );
    await _cameraController?.initialize();
    setState(() {});
  }

  void _handleZoomValueChanged(double value) {
    setState(() {
      _zoomValue = value;
      _cameraController?.setZoomLevel(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (animationController.value == 1.0) {
      animationController.stop();
      _timer?.cancel();
      _stopVideoRecording();
      setState(() {
        _start = 89;
        _isRecording = false;
        animationController.value = 0;
      });
    }
    if (_cameraController == null ||
        !(_cameraController?.value.isInitialized ?? false)) {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final Size screenSize = MediaQuery.of(context).size;
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: deviceRatio,
            // AppConstants.cameraAspectRatio,
            child: CameraPreview(_cameraController!),
          ),
          Positioned(
            bottom: 20,
            child: SizedBox(
              width: context.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Slider(
                    value: _zoomValue,
                    mouseCursor: MouseCursor.defer,
                    onChanged: _handleZoomValueChanged,
                    min: 1.000000,
                    max: 10.000000,
                  ),
                  if (_isRecording)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${twoDigits(videoTime.inMinutes)}:${twoDigits(videoTime.inSeconds)} / 01:30",
                        style: montserratSemiBold.copyWith(
                            color: Theme.of(context).primaryColorLight),
                      ),
                    ),
                  Container(
                    width: context.width,
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const IconButton(onPressed: null, icon: Icon(null)),
                        GestureDetector(
                          onTap: () {
                            if ((_cameraController?.value.isRecordingVideo ??
                                true)) {
                              animationController.stop();
                              _timer?.cancel();
                              _stopVideoRecording();
                              setState(() {
                                _start = 89;
                                _isRecording = false;
                                animationController.value = 0;
                              });
                            } else if (_cameraController != null &&
                                (_cameraController?.value.isInitialized ??
                                    true)) {
                              _startVideoRecording();
                            }

                            // showCustomToast("Press and hold to record video.", isErrorToast: true);
                          },
                          // onLongPress: () {
                          //   if (_cameraController == null || !(_cameraController?.value.isInitialized??true) || (_cameraController?.value.isRecordingVideo??true)) return;
                          //   _startVideoRecording();
                          // },
                          // onLongPressEnd: (value) {
                          //
                          // },
                          // onLongPressUp: () {
                          //   if (_cameraController == null ||
                          //       !(_cameraController?.value.isInitialized??false) ||
                          //       !(_cameraController?.value.isRecordingVideo??false)) return;
                          //   _stopVideoRecording();
                          // },
                          child: Stack(alignment: Alignment.center, children: [
                            Container(
                              height: 45,
                              width: 45,
                              alignment: Alignment.center,
                              child: Icon(
                                (_cameraController?.value.isRecordingVideo ??
                                        true)
                                    ? Icons.stop
                                    : Icons.camera_outlined,
                                color: Colors.red,
                                size: 45,
                              ),
                            ),
                            const SizedBox(
                              height: 65,
                              width: 65,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 65,
                              width: 65,
                              child: CircularProgressIndicator(
                                value: animationController.value,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                              ),
                            ),
                          ]),
                        ),
                        IconButton(
                          onPressed: _switchCamera,
                          icon: RotatedBox(
                            quarterTurns: 4,
                            child: Icon(
                              Icons.flip_camera_android_outlined,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _start = 89;
            _isRecording = false;
          });
        } else {
          setState(() {
            _start--;
            videoTime = Duration(seconds: 89 - _start);
            debugPrint("videoTime:-> $videoTime");
          });
        }
      },
    );
  }

  String twoDigits(int n) => n.abs().toString().padLeft(2, "0");
}
