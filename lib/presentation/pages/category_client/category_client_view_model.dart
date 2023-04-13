import 'package:admin/presentation/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _provider =
    ChangeNotifierProvider((ref) => CategoryClientPageViewModel());

class CategoryClientPageViewModel extends BaseViewModel {
  static ChangeNotifierProvider<CategoryClientPageViewModel> get provider =>
      _provider;
}
