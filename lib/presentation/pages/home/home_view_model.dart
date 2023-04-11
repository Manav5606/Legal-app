import 'package:admin/data/models/vendor.dart';
import 'package:admin/presentation/base_view_model.dart';
import 'package:admin/presentation/pages/vendor_admin/vendor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider = ChangeNotifierProvider((ref) => HomeViewModel());

class HomeViewModel extends BaseViewModel {
  bool _showTabView = true;

  Widget _view = const VendorPage();

  static ChangeNotifierProvider<HomeViewModel> get provider => _provider;

  bool get showTabView => _showTabView;

  Widget get otherView => _view;

  void updateTabView(bool value) {
    _showTabView = value;
    notifyListeners();
  }

  void loadOtherView(Widget view) {
    _view = view;
    _showTabView = false;
    notifyListeners();
  }
}
