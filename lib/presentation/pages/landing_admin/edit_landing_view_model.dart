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

  final List<BannerDetail> _banners = [];
  List<BannerDetail> get getBanners => _banners;

  final List<CustomerReview> _reviews = [];
  List<CustomerReview> get getReviews => _reviews;

  void clearErrors() {
    error = null;
    notifyListeners();
  }

  Future<void> initBanner() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getBanners();
    res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      clearErrors();
      _banners.clear();
      _banners.addAll(r);
      toggleLoadingOn(false);
    });
  }

  Future<void> initReview() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getReviews();
    res.fold((l) {
      error = l.message;
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      clearErrors();
      _reviews.clear();
      _reviews.addAll(r);
      toggleLoadingOn(false);
    });
  }
}
