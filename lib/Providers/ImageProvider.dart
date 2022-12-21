import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker_application/models/Image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as Firebase_Storage;
import 'package:photo_gallery/photo_gallery.dart';

class Image_Provider extends ChangeNotifier {
  bool isLoading = false;
  List<ImageModel> _images = [];

  List<ImageModel> get images => _images;

  List<File> _files = [];

  List<File> get files => _files;
  final Firebase_Storage.FirebaseStorage storage =
      Firebase_Storage.FirebaseStorage.instance;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getImages() async {
    setLoading(true);
    QuerySnapshot _imagesSnap =
        await FirebaseFirestore.instance.collection('images').get();
    images.clear();
    for (var item in _imagesSnap.docs) {
      images.add(ImageModel(doc_id: item.id, image_path: item['path']));
    }
    setLoading(false);
  }

  Future<void> addImage(String path) async {
    setLoading(true);
    FirebaseFirestore.instance.collection('images').add({'path': path});
    setLoading(false);
  }

  Future<void> deleteImage(String id) async {
    setLoading(true);
    FirebaseFirestore.instance.collection('images').doc(id).delete();
    setLoading(false);
  }

  Future<void> getRecentImage() async {
    setLoading(true);
    List<Album> list =
        await PhotoGallery.listAlbums(mediumType: MediumType.image);

    MediaPage mediaPage = await list[0].listMedia(take: 50);
    List<Medium> listMedium = mediaPage.items;

    int setStateListener = 0;
    for (var item in listMedium) {
      files.add(await item.getFile());
      setStateListener++;

      if (setStateListener == 10 ||
          setStateListener == 50 ||
          setStateListener == 100 ||
          setStateListener == 200 ||
          setStateListener == 500 ||
          setStateListener == 1000 ||
          setStateListener == list[0].count) {
        print(setStateListener);
      }
    }
    setLoading(false);
  }
}
