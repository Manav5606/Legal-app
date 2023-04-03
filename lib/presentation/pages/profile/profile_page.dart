import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/profile/profile_view_model.dart';
import 'package:admin/presentation/pages/widgets/footer.dart';
import 'package:admin/presentation/pages/widgets/header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static const String routeName = "/profile";
  const ProfilePage({super.key, required this.userID});
  final String userID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late final ProfileViewModel _viewModel;
  @override
  void initState() {
    _viewModel = ref.read(ProfileViewModel.provider);
    _viewModel.fetchUser(widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(ProfileViewModel.provider);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView(
              children: [
                const Header(mobile: false),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text("Profile",
                            style: FontStyles.font24Semibold.copyWith(
                                fontSize: 48, color: AppColors.blueColor)),
                        subtitle: Text("Your profile details are updated here",
                            style: FontStyles.font12Medium
                                .copyWith(color: AppColors.blueColor)),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            child: CachedNetworkImage(
                                imageUrl: "", height: 200, width: 200),
                          ),
                          ListView(
                            shrinkWrap: true,
                            children: [
                              Row(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Footer(),
              ],
            ),
    );
  }
}
