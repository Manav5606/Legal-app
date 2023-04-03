import 'package:admin/core/provider.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/models/vendor.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => ProfileViewModel(ref.read(Repository.database)));

class ProfileViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;
  bool sortAscending = false;
  int sortIndex = 0;
  static AutoDisposeChangeNotifierProvider<ProfileViewModel> get provider =>
      _provider;

  ProfileViewModel(this._databaseRepositoryImpl);

  late final User _user;
  late final Vendor? _vendor;

  User get getUser => _user;
  Vendor? get getVendor => _vendor;

  Future<void> fetchUser(String uid) async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchUsersByID(uid);
  }
}
