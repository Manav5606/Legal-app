import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/home/home_view_model.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tabs/dashboard/dashboard_view.dart';
import 'tabs/inbox/inbox_view.dart';
import 'tabs/notification/notification_view.dart';

class HomePage extends ConsumerStatefulWidget {
  static const String routeName = "/home";
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _viewModel = ref.read(HomeViewModel.provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(HomeViewModel.provider);
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: ListView(
          children: [
            const Header(),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightBlueColor,
              ),
              child: Row(
                children: [
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 3,
                    child: TabBar(
                        controller: _tabController,
                        indicatorColor: AppColors.blueColor,
                        onTap: (value) {
                          _viewModel.updateTabView(true);
                          _tabController.animateTo(value);
                        },
                        tabs: ["Dashboard", "Inbox", "Notification"]
                            .map((e) => Text(e,
                                style: FontStyles.font24Semibold
                                    .copyWith(color: AppColors.blueColor)))
                            .toList()),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Expanded(
                child: _viewModel.showTabView
                    ? TabBarView(
                        controller: _tabController,
                        children: const [
                          DashboardTab(),
                          InboxTab(),
                          NotificationTab(),
                        ],
                      )
                    : _viewModel.otherView,
              ),
            ),
            const Footer(),
          ],
        ));
  }
}
