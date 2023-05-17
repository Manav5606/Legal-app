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
    (ref) => AddNewsViewModel(ref.read(DatabaseRepositoryImpl.provider)));

class AddNewsViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  AddNewsViewModel(this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<AddNewsViewModel> get provider =>
      _provider;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? imageUrl;

  String? titleError;
  String? descriptionError;
  String? btnError;
  String? urlError;

  bool imageLoading = false;

  final List<News> _news = [];
  List<News> get getNews => _news;

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

  bool _validateValues() {
    clearError();

    if (titleController.text.isEmpty) {
      titleError = "News title description can't be empty.";
    }
    if (descriptionController.text.isEmpty) {
      descriptionError = "News description can't be empty.";
    }

    return titleError == null && descriptionError == null;
  }

  @override
  void dispose() {
    titleController.dispose();

    super.dispose();
  }

  void initNews(model.News? news) {
    if (news != null) {
      titleController.text = news.title;
      descriptionController.text = news.description;
      notifyListeners();
    }
  }

  Future<void> fetchNews() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getNews();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _news.clear();
      _news.addAll(r);
    });
    toggleLoadingOn(false);
  }

  Future<void> uploadImage({required XFile file}) async {
    try {
      imageLoading = true;
      notifyListeners();
      final downloadUrl = await _databaseRepositoryImpl.uploadToFirestore(
          file: file, userID: "banner");
      imageUrl = downloadUrl;
    } catch (e) {
      log(e.toString());
    } finally {
      imageLoading = false;
      notifyListeners();
    }
  }

  Future deleteNews(model.News news) async {
    toggleLoadingOn(true);
    final result = await _databaseRepositoryImpl.deleteNews(news: news);
    result.fold((l) async {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) {
      Messenger.showSnackbar("News Deleted");
      toggleLoadingOn(false);

      return r;
    });
    toggleLoadingOn(false);
  }

  Future createNews({model.News? existingNews}) async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, model.News> result;
      if (existingNews != null) {
        final news = existingNews.copyWith(
          description: descriptionController.text,
          title: titleController.text,
        );
        result = await _databaseRepositoryImpl.updateNews(news: news);
      } else {
        final news = model.News(
          title: titleController.text,
          description: descriptionController.text,
        );
        result = await _databaseRepositoryImpl.createNews(news: news);
      }

      return await result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) async {
        if (existingNews == null) {
          Messenger.showSnackbar("News Created ✅");
        } else {
          Messenger.showSnackbar("Updated News");
        }
        toggleLoadingOn(false);
        return r;
      });
    }
  }
}
