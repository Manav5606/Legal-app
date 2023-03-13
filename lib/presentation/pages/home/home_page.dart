import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
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

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        Container(
          color: AppColors.whiteColor,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                DashboardTab(),
                InboxTab(),
                NotificationTab(),
              ],
            ),
          ),
        ),
        const Footer(),
      ],
    ));
  }
}
