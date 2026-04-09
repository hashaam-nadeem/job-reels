import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobreels/util/app_constants.dart';
import 'package:jobreels/view/base/custom_loader.dart';
import 'Utils/utils.dart';
import 'package:get/get.dart';

class CustomImagePickerScreen extends StatefulWidget {
  final bool showImagePicker;
  const CustomImagePickerScreen({Key? key,this.showImagePicker = true}) : super(key: key);

  @override
  CameraPickerScreenState createState() => CameraPickerScreenState();
}

class CameraPickerScreenState extends State<CustomImagePickerScreen> with WidgetsBindingObserver {
  List<CameraDescription> cameras=[];

  XFile? pickedImage;
  CameraController ?cameraController;
  bool isCameraInitializing = true;
  bool isTorchOn=false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameraList){
      cameras = availableCameraList;
      if(cameras.isNotEmpty){
        cameraController = CameraController(
          cameras[0],
          kIsWeb ? ResolutionPreset.max : ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        cameraController!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          cameraController!.setFocusMode(FocusMode.auto);
          cameraController!.setExposureMode(ExposureMode.auto);
          cameraController!.setFlashMode(FlashMode.off);
          isCameraInitializing = false;
          setState(() {});
        });
      }else{
        isCameraInitializing = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{
        onBackButtonPressed();
        return false;
      },
      child: SafeArea(
          top: true,
          bottom: true,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SizedBox(
              child: Stack(
                  fit: StackFit.expand,
                  children: [
                    pickedImage==null && (cameraController?.value.isInitialized??false)
                        ? Stack(
                          fit: StackFit.expand,
                          children: [
                            AspectRatio(
                            aspectRatio: AppConstants.cameraAspectRatio,
                            child: Container(margin: const EdgeInsets.only(top: 50), child: CameraPreview(cameraController!)),
                      ),
                          ],
                        )
                        : isCameraInitializing
                        ? const Center(
                          child: CustomLoader(),
                        )
                        :Container(
                          alignment: Alignment.center,
                          child: cameras.isEmpty
                              ? const Text(
                            "Camera is not available on this device",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),
                          )
                              : _pickedImageView(deviceSize),
                        ),
                      if( pickedImage==null && (cameraController?.value.isInitialized??false))
                        Positioned(
                        bottom: 0,
                        child: SizedBox(
                          width: context.width,
                          child: _buildCameraControls(),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          child: Container(
                            color: Colors.black26,
                            width: context.width,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: onBackButtonPressed,
                                  icon: const Icon(Icons.arrow_back_ios_outlined,color: Colors.white,),
                                ),
                                const Spacer(),
                                /// Image Cropper
                                pickedImage!=null
                                    ? IconButton(
                                    onPressed: (){
                                      cropImage(imageToBeCroppedPath: pickedImage!.path).then((croppedImage){
                                        if(croppedImage!=null){
                                          pickedImage = croppedImage;
                                          setState(() {});
                                        }
                                      });
                                    },
                                    iconSize: 25,
                                    icon: const Icon(Icons.crop,color: Colors.white,)
                                )
                                    : const SizedBox(),
                                /// Image picker done
                                pickedImage==null
                                    ? const SizedBox()
                                    : IconButton(
                                    onPressed: (){
                                      Get.back(result: {"pickedImage": File(pickedImage!.path)});
                                    },
                                    iconSize: 25,
                                    icon: const Icon(Icons.send,color: Colors.white,)
                                ),
                                SizedBox(width:pickedImage==null?0:5,),
                                pickedImage==null
                                    ?Row(
                                  children: [
                                    IconButton(
                                      onPressed: (){
                                        isTorchOn=!isTorchOn;
                                        if(isTorchOn){
                                          cameraController!.setFlashMode(FlashMode.torch);
                                        } else{
                                          cameraController!.setFlashMode(FlashMode.off);
                                        }
                                        setState(() { });
                                      },
                                      icon: isTorchOn
                                          ? Icon(Icons.flashlight_on,color: Theme.of(context).primaryColorLight)
                                          : Icon(Icons.flashlight_off_outlined,color: Theme.of(context).primaryColorLight),
                                    ),
                                    IconButton(onPressed: _switchCamera, icon: RotatedBox(quarterTurns: 4,child: Icon(Icons.flip_camera_android_outlined, color: Theme.of(context).primaryColorLight,),),),
                                  ],
                                )
                                    :const SizedBox(),
                              ],
                            ),
                          ),
                        )
                    ],
              ),
            )
          ),
      ),
    );
  }

  Widget _pickedImageView(Size deviceSize){
    return FittedBox(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        color: Colors.black
      ),
      child: Image.file(
        File(pickedImage!.path),
        // fit: BoxFit.contain,
      ),
    ),
    );
  }

  Widget _buildCameraControls() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        widget.showImagePicker
            ? IconButton(
          icon: const Icon(Icons.photo_library),
          color: Colors.white,
          onPressed: () async{
            isTorchOn=false;
            cameraController!.setFlashMode(FlashMode.off);
            pickedImage = await pickGalleryImage(context: context);
            setState(() {});
          }
        )
            :const IconButton(
            icon: Icon(null),
            color: Colors.transparent,
            onPressed: null
        ),
        Column(
          children: [
            GestureDetector(
                child: const SizedBox(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                onTap: ()async{
                  pickedImage = await pickCameraImage(context: context,cameraController: cameraController);
                  isTorchOn=false;
                  cameraController!.setFlashMode(FlashMode.off);
                  setState(() {});
                },
            ),
            const SizedBox(height: 3,),
            const FittedBox(
              child:  Text(
                'Tap for photo',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5,),
          ],
        ),
        const IconButton(
            icon: Icon(null),
            color: Colors.transparent,
            onPressed: null
        ),
      ],
    );
  }

  void Function()? onBackButtonPressed(){

    if(pickedImage==null){
      Get.back();
    }else{
      pickedImage = null;
      setState(() {});
    }
    return null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (cameraController == null || !(cameraController?.value.isInitialized??false)) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (cameraController != null) {
        onNewCameraSelected(cameraController!.description);
      }
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController?.dispose();
    }

    cameraController = CameraController(
      cameras[0],
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    cameraController = cameraController;

    // If the controller is updated then update the UI.
    cameraController?.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if ((cameraController?.value.hasError??true)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${cameraController?.value.errorDescription??"Camera not initialized"}')));
      }
    });

    try {
      await cameraController?.initialize();
    } on CameraException catch (e) {
      try{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.description}')));
      }catch(e){
        debugPrint("Exception:-> $e");
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _switchCamera() {
    _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;
    _initializeCamera();
  }

  void _initializeCamera() async {
    await cameraController?.dispose();
    cameraController = CameraController(
      cameras[_selectedCameraIndex],
      ResolutionPreset.high,
    );
    await cameraController?.initialize();
    setState(() {});
  }

}

