import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';

import 'Providers/ImageProvider.dart';

typedef OnTakePhoto = Widget? Function(File photoFile);
typedef OnSelectPhoto = Widget? Function(File photoFile);

// ignore: must_be_immutable
class NativeCamera extends StatefulWidget {
  List<CameraDescription> cameraDescription;
  OnTakePhoto capturedImage;
  OnSelectPhoto selectedImage;

  NativeCamera(
      {Key? key,
      required this.cameraDescription,
      required this.capturedImage,
      required this.selectedImage})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<NativeCamera> createState() =>
      // ignore: no_logic_in_create_state
      _NativeCameraState(cameraDescription, capturedImage, selectedImage);
}

class _NativeCameraState extends State<NativeCamera> {
  CameraController? cameraController;
  Future<void>? cameraValue;
  XFile? takePhoto;
  int cameraMode = 0;
  ImagePicker imagePicker = ImagePicker();
  List<CameraDescription>? cameraDescription;

  //
  OnTakePhoto capturedImage;
  OnSelectPhoto selectedImage;

  //
  _NativeCameraState(
      this.cameraDescription, this.capturedImage, this.selectedImage);

  @override
  void initState() {
    cameraController = CameraController(
        cameraDescription![cameraMode], ResolutionPreset.veryHigh);
    cameraValue = cameraController!.initialize();
    Provider.of<Image_Provider>(context, listen: false).getRecentImage();
    // readGallary();
    super.initState();
  }

  List<FileSystemEntity> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                future: cameraValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(
                      cameraController!,
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Positioned(
              bottom: 50,
              left: MediaQuery.of(context).size.width / 2 - 40,
              right: MediaQuery.of(context).size.width / 2 - 40,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 5,
                    color: Colors.white,
                  ),
                ),
                child: MaterialButton(
                  splashColor: Colors.transparent,
                  onPressed: () async {
                    cameraController!.setFlashMode(FlashMode.off);
                    takePhoto = await cameraController!.takePicture();

                    CroppedFile? croppedImage = await ImageCropper().cropImage(
                      sourcePath: takePhoto!.path,
                      aspectRatioPresets: [
                        CropAspectRatioPreset.square,
                        CropAspectRatioPreset.ratio3x2,
                        CropAspectRatioPreset.original,
                        CropAspectRatioPreset.ratio4x3,
                        CropAspectRatioPreset.ratio16x9
                      ],
                      uiSettings: [
                        AndroidUiSettings(
                            toolbarTitle: 'Cropper',
                            toolbarColor: Colors.black87,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: false),
                        IOSUiSettings(
                          title: 'Cropper',
                        ),
                        WebUiSettings(
                          context: context,
                        ),
                      ],
                    );

                    // return croppedImage;
                    capturedImage(File(croppedImage!.path));
                  },
                ),
              ),
            ),
            Positioned(
              top: 35,
              right: 30,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 35,
              left: 30,
              child: IconButton(
                onPressed: () async {
                  takePhoto =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  CroppedFile? croppedImage = await ImageCropper().cropImage(
                    sourcePath: takePhoto!.path,
                    aspectRatioPresets: [
                      CropAspectRatioPreset.square,
                      CropAspectRatioPreset.ratio3x2,
                      CropAspectRatioPreset.original,
                      CropAspectRatioPreset.ratio4x3,
                      CropAspectRatioPreset.ratio16x9
                    ],
                    uiSettings: [
                      AndroidUiSettings(
                          toolbarTitle: 'Cropper',
                          toolbarColor: Colors.black87,
                          toolbarWidgetColor: Colors.white,
                          initAspectRatio: CropAspectRatioPreset.original,
                          lockAspectRatio: false),
                      IOSUiSettings(
                        title: 'Cropper',
                      ),
                      WebUiSettings(
                        context: context,
                      ),
                    ],
                  );
                  capturedImage(File(croppedImage!.path));
                },
                icon: const Icon(
                  FontAwesomeIcons.image,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 35,
              right: 30,
              child: IconButton(
                onPressed: () async {
                  setState(() {
                    cameraMode = cameraMode == 0 ? 1 : 0;
                    cameraController = CameraController(
                      cameraDescription![cameraMode],
                      ResolutionPreset.veryHigh,
                    );

                    cameraValue = cameraController!.initialize();
                  });
                },
                icon: const Icon(
                  FontAwesomeIcons.cameraRotate,
                  color: Colors.white,
                ),
              ),
            ),
            Consumer<Image_Provider>(builder: (context, value, child) {
              return Positioned(
                bottom: 130,
                right: 5,
                left: 5,
                child: SizedBox(
                  height: 65,
                  child: value.files.isNotEmpty
                      ? ListView.builder(
                          reverse: false,
                          itemCount: value.files.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                height: 90,
                                width: 85,
                                color: const Color.fromARGB(51, 0, 0, 0),
                                child: Image.file(
                                  value.files[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onTap: () async {
                                File f = value.files[index];

                                CroppedFile? croppedFile =
                                    await croppedFileMethod(f.path);

                                selectedImage(File(croppedFile!.path));
                              },
                            );
                          },
                        )
                      : Container(),
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Future<CroppedFile?> croppedFileMethod(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            activeControlsWidgetColor: Colors.blue,
            toolbarTitle: 'Edit Size',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Edit Size',
        ),
        // ignore: use_build_context_synchronously
        WebUiSettings(
          context: context,
        ),
      ],
    );
    return croppedFile;
  }
}
