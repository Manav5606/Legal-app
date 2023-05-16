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
    fetchContacts();
    fetchBanners();
    fetchReviews();
    fetchStats();
    fetchNews();
    fetchNewsImage();
  }

  static ChangeNotifierProvider<LandingPageViewModel> get provider => _provider;

  final List<Category> _categories = [];
  final List<Category> _contacts = [];
  final List<BannerDetail> _banners = [];
  final List<CustomerReview> _reviews = [];
  final List<News> _news = [];
  final List<Stats> _stats = [];
  final List<Service> _service = [];
  final List<String> _s = [];
  final List<NewsImage> _newsImage = [];

  List<Category> get getCategories => _categories;
  List<Category> get getContacts => _contacts;
  List<BannerDetail> get getBanners => _banners;
  List<CustomerReview> get getReviews => _reviews;
  List<News> get getNews => _news;
  List<Stats> get getStats => _stats;
  List<Service> get getService => _service;
  List<String> get gets => _s;
  List<NewsImage> get getNewsImage => _newsImage;

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

  Future<void> fetchServices() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.fetchServices();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _service.clear();
      _service.addAll(r);

      // ..sort((a, b) => a.name.compareTo(b.name)));
    });
    toggleLoadingOn(false);
  }

  Future<void> fetchContacts() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getContactDetails();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _contacts.clear();
      _contacts.addAll(r.where((e) => !e.isDeactivated).toList()
        ..sort((a, b) => a.name.compareTo(b.name)));
    });
    toggleLoadingOn(false);
  }

  Future<void> fetchBanners() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getBanners();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _banners.clear();
      _banners.addAll(r);
    });
    toggleLoadingOn(false);
  }

  Future<void> fetchStats() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getStats();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _stats.clear();
      _stats.addAll(r);
    });
    toggleLoadingOn(false);
  }

  Future<void> fetchReviews() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getReviews();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _reviews.clear();
      _reviews.addAll(r);
    });
    toggleLoadingOn(false);
  }

  Future<void> fetchNews() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getNews();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _news.clear();
      _news.addAll(r);
    });
    toggleLoadingOn(false);
  }

  Future<void> fetchNewsImage() async {
    toggleLoadingOn(true);
    final res = await _databaseRepositoryImpl.getNewsImage();
    res.fold((l) {
      Messenger.showSnackbar(l.message);
      toggleLoadingOn(false);
    }, (r) {
      _newsImage.clear();
      _newsImage.addAll(r);
      print(_newsImage);
    });
    toggleLoadingOn(false);
  }
}
