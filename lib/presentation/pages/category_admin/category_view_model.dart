import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => CategoryViewModel(ref.read(Repository.database)));

class CategoryViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  bool sortAscending = false;
  int sortIndex = 0;

  CategoryViewModel(this._databaseRepositoryImpl) {
    fetchCategories();
  }

  static AutoDisposeChangeNotifierProvider<CategoryViewModel> get provider =>
      _provider;

  String? error;

  List<Category> _categories = [];

  List<Category> get getCategories => _categories;

  void clearErrors() {
    error = null;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchCategories();
    res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      clearErrors();
      _categories = r;
      toggleLoadingOn(false);
    });
  }

  void sortCategories(int index, bool ascending) {
    switch (index) {
      case 0:
        _categories.sort((a, b) =>
            ascending ? a.id!.compareTo(b.id!) : b.id!.compareTo(a.id!));
        break;
      case 1:
        _categories.sort((a, b) =>
            ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case 4:
        _categories.sort((a, b) => ascending
            ? DateTime.fromMillisecondsSinceEpoch(a.addedAt!)
                .compareTo(DateTime.fromMillisecondsSinceEpoch(b.addedAt!))
            : DateTime.fromMillisecondsSinceEpoch(b.addedAt!)
                .compareTo(DateTime.fromMillisecondsSinceEpoch(a.addedAt!)));
        break;
      case 5:
        _categories.sort((a, b) => ascending
            ? a.addedBy.compareTo(b.addedBy)
            : b.addedBy.compareTo(a.addedBy));
        break;
    }
    sortAscending = !ascending;
    sortIndex = index;
    notifyListeners();
  }
}
