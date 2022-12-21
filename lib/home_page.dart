// ignore_for_file: use_build_context_synchronously

import 'dart:io';


import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_application/Providers/ImageProvider.dart';
import 'package:image_picker_application/viewImageAfterTake.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'NativeCamera.dart';

List<CameraDescription> cameraDis = [];

class MyHomePage extends StatefulWidget {
  @override
  // ignore: no_logic_in_create_state
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<File> images = [];
  File? img;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Image_Provider>(context, listen: false).getImages();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: GestureDetector(
          onTap: () async {
            int storage = await getPermission(Permission.storage);
            int camera = await getPermission(Permission.camera);
            if (storage == 0 || camera == 0) {
              await AppSettings.openAppSettings();
            } else if (storage == 1 && camera == 1) {
              cameraDis = await availableCameras();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NativeCamera(
                    cameraDescription: cameraDis,
                    capturedImage: (photo) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewImageAfterTake(imagePath: photo.path),
                        ),
                      );
                      // return null;
                    },
                    selectedImage: (photoFile) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewImageAfterTake(
                            imagePath: photoFile.path,
                          ),
                        ),
                      );
                      //return null;
                    },
                  ),
                ),
              );
            }
          },
          child: SizedBox(
            height: 85,
            child: Consumer<Image_Provider>(builder: ((context, value, child) {
              return ListView(scrollDirection: Axis.horizontal, children: [
                ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: value.images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(
                          right: 5,
                        ),
                        width: 80,
                        height: 80,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 8),
                              child: CachedNetworkImage(
                                imageUrl: "${value.images[index].image_path}",
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Positioned(
                              right: -1,
                              top: -1,
                              child: GestureDetector(
                                onTap: () {
                                  value.deleteImage(
                                      '${value.images[index].doc_id}');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                const SizedBox(
                  width: 80,
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.black54,
                  ),
                )
              ]);
            })),
          ),
        ),
      ),
    );
  }
}

Future<int> getPermission(Permission permission) async {
  var request = await permission.request();
  if (request.isGranted) {
    return 1;
  } else if (request.isPermanentlyDenied) {
    return 0;
  } else {
    return 2;
  }
}
