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
    (ref) => AddStatsViewModel(ref.read(DatabaseRepositoryImpl.provider)));

class AddStatsViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  AddStatsViewModel(this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<AddStatsViewModel> get provider =>
      _provider;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? titleError;
  String? descriptionError;
  

  void clearError() {
    titleError = descriptionError = null;
    notifyListeners();
  }

  bool _validateValues() {
    clearError();

    if (titleController.text.isEmpty) {
      titleError = "Stats title description can't be empty.";
    }
    if (descriptionController.text.isEmpty) {
      descriptionError = "Stats description can't be empty.";
    }

    return titleError == null && descriptionError == null;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void initStats(model.Stats? statsDetails) {
    if (statsDetails != null) {
      titleController.text = statsDetails.title;
      descriptionController.text = statsDetails.description;
      notifyListeners();
    }
  }

  Future deleteStats(model.Stats stats) async {
    toggleLoadingOn(true);
    final result = await _databaseRepositoryImpl.deleteStats(stats: stats);
    result.fold((l) async {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
      return null;
    }, (r) {
      Messenger.showSnackbar("Stats Deleted");
      toggleLoadingOn(false);

      return r;
    });
    toggleLoadingOn(false);
  }

  Future createStats({model.Stats? existingStats}) async {
    if (_validateValues()) {
      toggleLoadingOn(true);
      late final Either<AppError, model.Stats> result;
      if (existingStats != null) {
        final stats = existingStats.copyWith(

          description: descriptionController.text,
          title: titleController.text,

        );
        result = await _databaseRepositoryImpl.updateStats(stats: stats);
      } else {
        final stats = model.Stats(
          title: titleController.text,

          description: descriptionController.text,

        );
        result = await _databaseRepositoryImpl.createStats(stats: stats);
      }

      return await result.fold((l) async {
        Messenger.showSnackbar(l.message);
        toggleLoadingOn(false);
        return null;
      }, (r) async {
        if (existingStats == null) {
          Messenger.showSnackbar("Stats Created ✅");
        } else {
          Messenger.showSnackbar("Stats Stats");
        }
        toggleLoadingOn(false);
        return r;
      });
    }
  }
}
