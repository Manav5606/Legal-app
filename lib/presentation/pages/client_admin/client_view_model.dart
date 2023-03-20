import 'package:admin/core/enum/role.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/data/repositories/index.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider.autoDispose(
    (ref) => ClientViewModel(ref.read(Repository.database)));

class ClientViewModel extends BaseViewModel {
  final DatabaseRepositoryImpl _databaseRepositoryImpl;

  bool sortAscending = false;
  int sortIndex = 0;

  ClientViewModel(this._databaseRepositoryImpl) {
    fetchClients();
  }

  static AutoDisposeChangeNotifierProvider<ClientViewModel> get provider =>
      _provider;

  String? error;

  List<User> _clients = [];

  List<User> get getClients => _clients;

  void clearErrors() {
    error = null;
    notifyListeners();
  }

  Future<void> fetchClients() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchUsersByType(UserType.client);
    res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      clearErrors();
      _clients = r;
      toggleLoadingOn(false);
    });
  }

  void sortClients(int index, bool ascending) {
    switch (index) {
      case 0:
        _clients.sort((a, b) =>
            ascending ? a.id!.compareTo(b.id!) : b.id!.compareTo(a.id!));
        break;
      case 1:
        _clients.sort((a, b) => ascending
            ? DateTime.fromMillisecondsSinceEpoch(a.createdAt!)
                .compareTo(DateTime.fromMillisecondsSinceEpoch(b.createdAt!))
            : DateTime.fromMillisecondsSinceEpoch(b.createdAt!)
                .compareTo(DateTime.fromMillisecondsSinceEpoch(a.createdAt!)));
        break;
      case 2:
        _clients.sort((a, b) =>
            ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case 3:
        _clients.sort((a, b) => ascending
            ? a.phoneNumber.compareTo(b.phoneNumber)
            : b.phoneNumber.compareTo(a.phoneNumber));
        break;
      case 4:
        _clients.sort((a, b) => ascending
            ? a.email.compareTo(b.email)
            : b.email.compareTo(a.email));
        break;
    }
    sortAscending = !ascending;
    sortIndex = index;
    notifyListeners();
  }
}
