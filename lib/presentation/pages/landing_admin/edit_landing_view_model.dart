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

  final List<BannerDetail> _banners = [];
  List<BannerDetail> get getBanners => _banners;

  final List<Stats> _stats = [];
  List<Stats> get getStats => _stats;

  final List<CustomerReview> _reviews = [];
  List<CustomerReview> get getReviews => _reviews;

  final List<Category> _contactDetails = [];
  List<Category> get getContactDetails => _contactDetails;

  Future<void> initBanner() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getBanners();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _banners.clear();
      _banners.addAll(r);
      toggleLoadingOn(false);
    });
  }
  Future<void> initStats() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getStats();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _stats.clear();
      _stats.addAll(r);
      toggleLoadingOn(false);
    });
  }

  Future<void> initReview() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getReviews();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _reviews.clear();
      _reviews.addAll(r);
      toggleLoadingOn(false);
    });
  }

  Future<void> initContactDetails() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getContactDetails();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _contactDetails.clear();
      _contactDetails.addAll(r);
      toggleLoadingOn(false);
    });
  }
}
