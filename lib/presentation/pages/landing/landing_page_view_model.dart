import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider(
    (ref) => LandingPageViewModel(ref.read(Repository.database)));

class LandingPageViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  LandingPageViewModel(this._databaseRepositoryImpl) {
    fetchCategories();
  }

  static ChangeNotifierProvider<LandingPageViewModel> get provider => _provider;

  final List<Category> _categories = [];

  List<Category> get getCategories => _categories;

  Future<void> fetchCategories() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchCategories();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _categories.clear();
      _categories.addAll(r.where((e) => !e.isDeactivated).toList()
        ..sort((a, b) => a.name.compareTo(b.name)));
    });
    toggleLoadingOn(false);
  }
}
