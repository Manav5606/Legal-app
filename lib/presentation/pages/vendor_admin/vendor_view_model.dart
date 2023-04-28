import 'package:admin/core/enum/role.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => VendorViewModel(ref.read(Repository.database)));

class VendorViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  bool sortAscending = false;
  int sortIndex = 0;

  VendorViewModel(this._databaseRepositoryImpl) {
    fetchVendors();
  }

  static AutoDisposeChangeNotifierProvider<VendorViewModel> get provider =>
      _provider;

  String? error;

  List<User> _vendors = [];

  List<User> get getVendors => _vendors;

  void clearErrors() {
    error = null;
    notifyListeners();
  }

  Future<void> fetchVendors() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchUsersByType(UserType.vendor);
    res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      clearErrors();
      _vendors = r;
      toggleLoadingOn(false);
    });
  }
  

  void sortVendors(int index, bool ascending) {
    switch (index) {
      case 0:
        _vendors.sort((a, b) =>
            ascending ? a.id!.compareTo(b.id!) : b.id!.compareTo(a.id!));
        break;
      case 1:
        _vendors.sort((a, b) => ascending
            ? DateTime.fromMillisecondsSinceEpoch(a.createdAt!)
                .compareTo(DateTime.fromMillisecondsSinceEpoch(b.createdAt!))
            : DateTime.fromMillisecondsSinceEpoch(b.createdAt!)
                .compareTo(DateTime.fromMillisecondsSinceEpoch(a.createdAt!)));
        break;
      case 2:
        _vendors.sort((a, b) =>
            ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case 3:
        _vendors.sort((a, b) => ascending
            ? a.phoneNumber.compareTo(b.phoneNumber)
            : b.phoneNumber.compareTo(a.phoneNumber));
        break;
      case 4:
        _vendors.sort((a, b) => ascending
            ? a.email.compareTo(b.email)
            : b.email.compareTo(a.email));
        break;
    }
    sortAscending = !ascending;
    sortIndex = index;
    notifyListeners();
  }
}
