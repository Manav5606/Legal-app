import 'dart:developer';
import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/enum/admin_menu.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routemaster/routemaster.dart';

// TODO make all displayed text dynamic
class Header extends StatelessWidget {
  final bool mobile;
  const Header({super.key, required this.mobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(mobile: mobile),
        bottomBar(),
      ],
    );
  }

  Widget bottomBar() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          SvgPicture.asset(
            Assets.iconsTitleBarlogo,
            width: 255,
            height: 51,
          ),
          const Spacer(),
          mobile
              ? IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: AppColors.yellowColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextFormField(
                            decoration: const InputDecoration(
                          hintText: "Search...",
                          border: InputBorder.none,
                        )),
                      ),
                      Icon(Icons.search, color: AppColors.blueColor),
                    ],
                  )),
          const SizedBox(
            width: 30,
          ),
        ],
      ),
    );
  }
}

class TopBar extends ConsumerStatefulWidget {
  final bool mobile;
  const TopBar({super.key, required this.mobile});

  @override
  ConsumerState<TopBar> createState() => _TopBarState();
}

class _TopBarState extends ConsumerState<TopBar> {
  late bool isAuthenticated;
  late User? user;

  @override
  void initState() {
    super.initState();
    isAuthenticated = ref.read(AppState.auth).isAuthenticated;
    user = ref.read(AppState.auth).user;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AppState.auth).isAuthenticated;
    ref.watch(AppState.auth).user;
    return Container(
      height: 26,
      color: AppColors.blueColor,
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          SvgPicture.asset(Assets.ASSETS_ICONS_VECTORPHONE_SVG),
          const SizedBox(
            width: 9.68,
          ),
          Text(
            "+91-11153-42382",
            style: FontStyles.font12Regular,
          ),
          const SizedBox(
            width: 11.22,
          ),
          Visibility(visible: widget.mobile, child: const Spacer()),
          SvgPicture.asset(Assets.ASSETS_ICONS_VECTORMAIL_SVG),
          const SizedBox(
            width: 9.68,
          ),
          Text(
            "contact@247legal.in",
            style: FontStyles.font12Regular,
          ),
          Visibility(visible: !widget.mobile, child: const Spacer()),
          Visibility(
              visible: !widget.mobile,
              child: isAuthenticated
                  ? Row(children: [
                      Visibility(
                        visible: user?.userType == UserType.admin,
                        child: PopupMenuButton(
                          child: Row(
                            children: [
                              Text(
                                "Admin",
                                style: FontStyles.font12Regular
                                    .copyWith(color: AppColors.yellowColor),
                              ),
                              Icon(Icons.arrow_drop_down,
                                  color: AppColors.yellowColor)
                            ],
                          ),
                          itemBuilder: (_) => AdminMenu.values
                              .map((menu) => PopupMenuItem(
                                    child: Text(menu.title),
                                    onTap: () => ref
                                        .read(HomeViewModel.provider)
                                        .loadOtherView(menu.view),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(
                        width: 11.22,
                      ),
                      Text(
                        "${user?.name}",
                        style: FontStyles.font12Regular,
                      ),
                      const SizedBox(
                        width: 11.22,
                      ),
                      VerticalDivider(
                          color: AppColors.yellowColor, thickness: 3),
                      PopupMenuButton(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 28,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://randomuser.me/api/portraits/men/51.jpg"),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down,
                                color: AppColors.yellowColor)
                          ],
                        ),
                        itemBuilder: (_) => ["Profile", "History", "Sign out"]
                            .map((menu) => PopupMenuItem(
                                  child: Text(menu),
                                  onTap: () {
                                    if (menu == "Sign out") {
                                      ref.read(AppState.auth.notifier).logout();
                                    }
                                  },
                                ))
                            .toList(),
                      ),
                    ])
                  : Row(
                      children: [
                        TextButton.icon(
                            onPressed: () => Routemaster.of(context)
                                .push(LoginPage.routeName),
                            icon: Icon(Icons.login_rounded,
                                color: AppColors.yellowColor),
                            label: Text("Login",
                                style: FontStyles.font12Regular
                                    .copyWith(color: AppColors.yellowColor))),
                        const SizedBox(
                          width: 11.22,
                        ),
                        TextButton(
                            onPressed: () => Routemaster.of(context)
                                .push(RegisterPage.routeName),
                            child: Text("New User?",
                                style: FontStyles.font12Regular.copyWith(
                                    color: AppColors.whiteColor,
                                    decoration: TextDecoration.underline))),
                      ],
                    )),
          const SizedBox(
            width: 11.22,
          ),
        ],
      ),
    );
  }
}
