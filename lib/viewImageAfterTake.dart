import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_application/home_page.dart';
import 'package:provider/provider.dart';

import 'Providers/ImageProvider.dart';

class ViewImageAfterTake extends StatefulWidget {
  final imagePath;

  const ViewImageAfterTake({this.imagePath, Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ViewImageAfterTake> createState() =>
      // ignore: no_logic_in_create_state
      _ViewImageAfterTakeState(imagePath);
}

class _ViewImageAfterTakeState extends State<ViewImageAfterTake> {
  _ViewImageAfterTakeState(imagePath);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.deepPurple,
        child: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.check),
          onPressed: () async {
            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages = referenceRoot.child('assets');
            var number = Random().nextInt(100000);
            Reference referenceImageToUpload =
                referenceDirImages.child('name_${number}');
            await referenceImageToUpload.putFile(File(widget.imagePath));
            try {
              var imageUrl = await referenceImageToUpload.getDownloadURL();
              Provider.of<Image_Provider>(context, listen: false)
                  .addImage(imageUrl);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            } catch (error) {
              //Some error occurred
            }
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            child: Expanded(
              child: Center(
                child: Image.file(
                  File(
                    widget.imagePath,
                  ),
                  // fit: BoxFit.contain,
                  // height: double.infinity,
                  // width: double.infinity,
                  // alignment: Alignment.center,
                ),
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
        ],
      ),
    );
  }
}
