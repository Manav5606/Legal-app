import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/enum/admin_menu.dart';
import 'package:admin/core/enum/role.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/home/home_view_model.dart';
import 'package:admin/presentation/pages/landing/landing_page.dart';
import 'package:admin/presentation/pages/my_orders/my_orders_page.dart';
import 'package:admin/presentation/pages/orders_admin_page/order_page.dart';
import 'package:admin/presentation/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../home/home_page.dart';

// TODO make all displayed text dynamic
class Header extends StatelessWidget {
  final bool mobile;
  const Header({super.key, required this.mobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(mobile: mobile),
        bottomBar(context),
      ],
    );
  }

  Widget bottomBar(BuildContext context) {
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
          InkWell(
            onTap: () {
              Routemaster.of(context).push(LandingPage.routeName);
            },
            child: SvgPicture.asset(
              Assets.iconsTitleBarlogo,
              width: 255,
              height: 51,
            ),
          ),
          const Spacer(),
          mobile
              ? IconButton(
                  onPressed: () {
                    landingScaffold.currentState?.openEndDrawer();
                  },
                  icon: const Icon(Icons.menu))
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50)),
                  // child: Row(
                  //   children: [
                  //     // SizedBox(
                  //     //   width: 150,
                  //     //   child: TextFormField(
                  //     //       decoration: const InputDecoration(
                  //     //     hintText: "Search...",
                  //     //     border: InputBorder.none,
                  //     //   )),
                  //     // ),
                  //     // Icon(Icons.search, color: AppColors.blueColor),
                  //   ],
                  // )
                ),
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
      width: double.infinity,
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
          InkWell(
            onTap: () {
              launchUrlString("tel:+918125504448");
            },
            child: Text(
              "+91-8125504448",
              style: FontStyles.font12Regular,
            ),
          ),
          const SizedBox(
            width: 11.22,
          ),
          Visibility(visible: widget.mobile, child: const Spacer()),
          SvgPicture.asset(Assets.ASSETS_ICONS_VECTORMAIL_SVG),
          const SizedBox(
            width: 9.68,
          ),
          InkWell(
            onTap: () {
              launchMailTo();
            },
            child: Text(
              "contact@247legal.in",
              style: FontStyles.font12Regular,
            ),
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
                            SizedBox(
                              width: 28,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage("${user?.profilePic}"),
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down,
                                size: 12, color: AppColors.yellowColor)
                          ],
                        ),
                        itemBuilder: (_) => (user?.userType == UserType.admin
                                ? ["Profile", "History", "Sign out"]
                                : [
                                    "Profile",
                                    "History",
                                    "Sign out",
                                    "My orders",
                                    "My Chat"
                                  ])
                            .map((menu) => PopupMenuItem(
                                  child: Text(menu),
                                  onTap: () {
                                    if (menu == "Sign out") {
                                      ref.read(AppState.auth.notifier).logout();
                                    } else if (menu == "My orders") {
                                      Routemaster.of(context)
                                          .push(MyOrdersPage.routeName);
                                    } else if (menu == "Profile") {
                                      Routemaster.of(context).push(
                                          ProfilePage.routeName,
                                          queryParameters: {
                                            "userID": user!.id!
                                          });
                                    } else if (menu == "My Chat") {
                                      Routemaster.of(context).push(
                                        HomePage.routeName,
                                      );
                                    } else if (menu == "History") {
                                      Routemaster.of(context).push(
                                        MyOrdersPage.routeName,
                                      );
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

  void launchMailTo() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'contact@247legal.in',
    );

    String url = params.toString();

    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url';
    }
  }
}
