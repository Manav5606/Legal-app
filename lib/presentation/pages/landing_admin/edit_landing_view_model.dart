import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => EditLandingViewModel(ref.read(Repository.database)));

class EditLandingViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  bool sortAscending = false;
  int sortIndex = 0;

  EditLandingViewModel(this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<EditLandingViewModel> get provider =>
      _provider;

  String? error;

  List<Service> _services = [];

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

  void clearErrors() {
    error = null;
    notifyListeners();
  }

  Future<void> initCategory(String categoryId) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getServicesbyCategory(
        categoryID: categoryId);
    res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      clearErrors();
      _services = r;
      toggleLoadingOn(false);
    });
  }
}
