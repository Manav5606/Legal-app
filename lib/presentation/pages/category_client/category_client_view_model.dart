import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider(
    (ref) => CategoryClientPageViewModel(ref.read(Repository.database)));

class CategoryClientPageViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  CategoryClientPageViewModel(this._databaseRepositoryImpl);
  static ChangeNotifierProvider<CategoryClientPageViewModel> get provider =>
      _provider;

  Category? selectedCategory;

  final List<Service> _services = [];

  List<Service> get getServices =>
      _services.where((e) => e.parentServiceID == null).toList();

  Service getServiceByID(String id) {
    return _services.firstWhere((element) => element.id == id,
        orElse: () => Service(
            shortDescription: "",
            aboutDescription: "",
            childServices: [],
            categoryID: "",
            createdBy: ""));
  }

  Future<void> initCategoryInfo(String categoryId) async {
    toggleLoadingOn(true);
    final res =
        await _databaseRepositoryImpl.getCategoryByID(categoryId: categoryId);
    await res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) async {
      selectedCategory = r;
      notifyListeners();
      await _getServicesByCategoryID(categoryId);
    });
    toggleLoadingOn(false);
  }

  Future<void> _getServicesByCategoryID(String categoryId) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getServicesbyCategory(
        categoryID: categoryId);
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _services.clear();
      _services.addAll(r);
    });
    toggleLoadingOn(false);
  }
}
