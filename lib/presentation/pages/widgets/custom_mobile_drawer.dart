import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/provider.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/authentication/index.dart';
import 'package:admin/presentation/pages/my_orders/my_orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../home/home_page.dart';

class CustomMobileDrawer extends ConsumerStatefulWidget {
  final List<Category> categories;
  const CustomMobileDrawer({super.key, required this.categories});

  @override
  ConsumerState<CustomMobileDrawer> createState() => _CustomMobileDrawerState();
}

class _CustomMobileDrawerState extends ConsumerState<CustomMobileDrawer> {
  late bool isAuthenticated;
  @override
  Widget build(BuildContext context) {
    isAuthenticated = ref.watch(AppState.auth).isAuthenticated;
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(20.0)),
      child: Drawer(
        backgroundColor: AppColors.yellowColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListView(
            // TODO make this dynamic
            children: [
              ListTile(
                title: Text(
                  "Menu",
                  textAlign: TextAlign.center,
                  style: FontStyles.font14Bold
                      .copyWith(color: AppColors.blueColor, fontSize: 24),
                ),
                trailing: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.cancel_outlined,
                        color: AppColors.blueColor)),
              ),
              ListTile(
                  title: Text("Home",
                      style: FontStyles.font14Semibold.copyWith(
                          fontSize: 18, color: AppColors.blackColor))),
              ...widget.categories
                  .map((category) => ListTile(
                      title: Text(category.name,
                          style: FontStyles.font14Semibold.copyWith(
                              fontSize: 18, color: AppColors.blackColor))))
                  .toList(),
              // ListTile(
              //     title: Text("Business",
              //         style: FontStyles.font14Semibold.copyWith(
              //             fontSize: 18, color: AppColors.blackColor))),
              // ListTile(
              //     title: Text("Finance",
              //         style: FontStyles.font14Semibold.copyWith(
              //             fontSize: 18, color: AppColors.blackColor))),
              // ListTile(
              //     title: Text("Legal",
              //         style: FontStyles.font14Semibold.copyWith(
              //             fontSize: 18, color: AppColors.blackColor))),
              // ListTile(
              //     title: Text("Advertisement",
              //         style: FontStyles.font14Semibold.copyWith(
              //             fontSize: 18, color: AppColors.blackColor))),
              Divider(color: AppColors.lightGreyColor, thickness: 2),
              Visibility(
                visible: isAuthenticated,
                child: ListTile(
                    onTap: () {
                      Routemaster.of(context).push(MyOrdersPage.routeName);
                    },
                    title: Text("My Orders",
                        style: FontStyles.font12Regular.copyWith(
                            fontSize: 16, color: AppColors.blackColor))),
              ),
              ListTile(
                onTap: () {
                      Routemaster.of(context).push(HomePage.routeName);
                    },
                  title: Text("My Chat",
                      style: FontStyles.font12Regular.copyWith(
                          fontSize: 16, color: AppColors.blackColor))),
                           ListTile(
                  title: Text("FAQs",
                      style: FontStyles.font12Regular.copyWith(
                          fontSize: 16, color: AppColors.blackColor))),
              ListTile(
                  title: Text("Contact Us",
                      style: FontStyles.font12Regular.copyWith(
                          fontSize: 16, color: AppColors.blackColor))),
              ListTile(
                  title: Text("Settings",
                      style: FontStyles.font12Regular.copyWith(
                          fontSize: 16, color: AppColors.blackColor))),
              !isAuthenticated
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              Routemaster.of(context).push(LoginPage.routeName);
                            },
                            icon: Icon(Icons.login, color: AppColors.blueColor),
                            label: Text("Login",
                                style: FontStyles.font14Semibold.copyWith(
                                    fontSize: 16, color: AppColors.blueColor))),
                        TextButton(
                            onPressed: () {
                              Routemaster.of(context)
                                  .push(RegisterPage.routeName);
                            },
                            child: Text("New User?",
                                style: FontStyles.font12Regular.copyWith(
                                    fontSize: 16,
                                    color: AppColors.whiteColor))),
                        const SizedBox.shrink(),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              ref.read(AppState.auth.notifier).logout();
                            },
                            icon: Icon(Icons.login, color: AppColors.blueColor),
                            label: Text("SignOut",
                                style: FontStyles.font14Semibold.copyWith(
                                    fontSize: 16, color: AppColors.blueColor))),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
