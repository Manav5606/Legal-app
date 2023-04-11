import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => ServiceViewModel(ref.read(Repository.database)));

class ServiceViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  bool sortAscending = false;
  int sortIndex = 0;

  ServiceViewModel(this._databaseRepositoryImpl);

  static AutoDisposeChangeNotifierProvider<ServiceViewModel> get provider =>
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

  // Future<void> fetchServices() async {
  //   toggleLoadingOn(true);
  //   final res = await _databaseRepositoryImpl.fetchServices();
  //   res.fold((l) {
  //     error = l.message;
  //     Messenger.showSnackbar(l.message);
  //     toggleLoadingOn(false);
  //   }, (r) {
  //     clearErrors();
  //     _services = r;
  //     toggleLoadingOn(false);
  //   });
  // }

  void sortServices(int index, bool ascending) {
    // switch (index) {
    //   case 0:
    //     _services.sort((a, b) =>
    //         ascending ? a.id!.compareTo(b.id!) : b.id!.compareTo(a.id!));
    //     break;
    //   case 1:
    //     _services.sort((a, b) =>
    //         ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    //     break;
    //   case 4:
    //     _services.sort((a, b) => ascending
    //         ? DateTime.fromMillisecondsSinceEpoch(a.addedAt!)
    //             .compareTo(DateTime.fromMillisecondsSinceEpoch(b.addedAt!))
    //         : DateTime.fromMillisecondsSinceEpoch(b.addedAt!)
    //             .compareTo(DateTime.fromMillisecondsSinceEpoch(a.addedAt!)));
    //     break;
    //   case 5:
    //     _services.sort((a, b) => ascending
    //         ? a.addedBy.compareTo(b.addedBy)
    //         : b.addedBy.compareTo(a.addedBy));
    //     break;
    // }
    sortAscending = !ascending;
    sortIndex = index;
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
