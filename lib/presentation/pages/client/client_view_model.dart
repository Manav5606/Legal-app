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
    final res = await _databaseRepositoryImpl.fetchAllClients();
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
}
