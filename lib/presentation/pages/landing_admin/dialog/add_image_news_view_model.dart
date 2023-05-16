import 'dart:developer';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart' as model;
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => AddImageNewsViewModel(ref.read(DatabaseRepositoryImpl.provider)));

class AddImageNewsViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  AddImageNewsViewModel(this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<AddImageNewsViewModel> get provider =>
      _provider;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController btnController = TextEditingController();
   TextEditingController urlController = TextEditingController();

  String? imageUrl;

  String? titleError;
  String? descriptionError;
  String? btnError;
  String? urlError;

  bool imageLoading = false;

  final List<NewsImage> _newsImage = [];
  List<NewsImage> get getNewsImage => _newsImage;

  void clearError() {
    titleError = descriptionError = btnError = urlError = null;
    notifyListeners();
  }

  Future<XFile?> pickFile(FilePickerResult? result) async {
    if (result != null) {
      final choosenFile = result.files.first;
      return XFile.fromData(choosenFile.bytes!, name: choosenFile.name);
    }
    return null;
  }


  void initnewsImageDetails(model.NewsImage? newsImageDetails) {
    if (newsImageDetails != null) {
    
      imageUrl = newsImageDetails.imageUrl;
      notifyListeners();
    }
  }

   Future<void> fetchNewsImage() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getNewsImage();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _newsImage.clear();
      _newsImage.addAll(r);
    });
    toggleLoadingOn(false);
  }

  Future<void> uploadImage({required XFile file}) async {
    try {
      imageLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: "newsImageDetails");
      imageUrl = downloadUrl;
    } catch (e) {
      log(e.toString());
    } finally {
      imageLoading = false;
      notifyListeners();
    }
  }

  Future deleteNewsImageDetails(model.NewsImage newsImageDetails) async {
    toggleLoadingOn(true);
    final result = await _databaseRepositoryImpl.deleteNewsImage(news: newsImageDetails);
    result.fold((l) async {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) {
      Messenger.showSnackbar("Image Deleted");
      toggleLoadingOn(false);

      return r;
    });
    toggleLoadingOn(false);
  }

  Future createnewsImageDetails({model.NewsImage? existingnewsImageDetails}) async {
  
      toggleLoadingOn(true);
      late final Either<AppError, model.NewsImage> result;
      if (existingnewsImageDetails != null) {
        final newsImageDetails = existingnewsImageDetails.copyWith(
         
          imageUrl: imageUrl,
     
        );
        result = await _databaseRepositoryImpl.updateNewsImage(news: newsImageDetails);
      } else {
        final newsImageDetails = model.NewsImage(
        
          imageUrl: imageUrl ?? "",
        
        );
        result = await _databaseRepositoryImpl.createNewsImage(news: newsImageDetails);
      }

      return await result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) async {
        if (existingnewsImageDetails == null) {
          Messenger.showSnackbar("Image Created ✅");
        } else {
          Messenger.showSnackbar("Updated Image");
        }
        toggleLoadingOn(false);
        return r;
      });
    }

}
