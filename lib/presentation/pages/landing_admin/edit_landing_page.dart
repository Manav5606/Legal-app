import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_banner_dialog.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_contact_dialog.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_review_dialog.dart';
import 'package:admin/presentation/pages/landing_admin/edit_landing_view_model.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EditLandingPage extends ConsumerStatefulWidget {
  static const String routeName = "/editLanding";

  const EditLandingPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServicePageState();
}

class _ServicePageState extends ConsumerState<EditLandingPage> {
  late final EditLandingViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(EditLandingViewModel.provider);
    _viewModel.initBanner();
    _viewModel.initReview();
    _viewModel.initContactDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(EditLandingViewModel.provider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heading(),
          const SizedBox(height: 28),
          Expanded(
            child: Column(
              children: [
                _editBanner(),
                _editReview(),
                _editContactDetail(),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _heading() {
    return Text("Edit Landing Page", style: FontStyles.font24Semibold);
  }

  Widget _editBanner() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bannerHeading(),
        const Divider(),
        ListView.builder(
          itemCount: _viewModel.getBanners.length,
          itemBuilder: (_, i) => ListTile(
            dense: true,
            title: Text(_viewModel.getBanners[i].title),
            subtitle: Text(_viewModel.getBanners[i].description),
            leading: Image.network(_viewModel.getBanners[i].imageUrl),
            trailing: TextButton(
              child: Text(_viewModel.getBanners[i].btnText),
              onPressed: () =>
                  launchUrlString(_viewModel.getBanners[i].urlToLoad),
            ),
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Dialog(
                  insetPadding: const EdgeInsets.all(24),
                  child:
                      AddBannerDialog(bannerDetail: _viewModel.getBanners[i]),
                ),
              );
            },
          ),
          shrinkWrap: true,
        ),
      ],
    );
  }

  Widget _bannerHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Banner", style: FontStyles.font24Semibold),
            Text("Your list of banner is here",
                style: FontStyles.font14Semibold),
          ],
        ),
        CTAButton(
            title: "Add Banner",
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Dialog(
                  insetPadding: EdgeInsets.all(24),
                  child: AddBannerDialog(),
                ),
              );
            }),
      ],
    );
  }

  Widget _editReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _reviewHeading(),
        const Divider(),
        ListView.builder(
          itemCount: _viewModel.getReviews.length,
          itemBuilder: (_, i) => ListTile(
            dense: true,
            title: Text(_viewModel.getReviews[i].title),
            subtitle: Text(_viewModel.getReviews[i].review),
            leading: Image.network(_viewModel.getReviews[i].customerProfilePic),
            trailing: Row(
              children: [
                Text(_viewModel.getReviews[i].designation),
                Text(_viewModel.getReviews[i].name),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Dialog(
                  insetPadding: const EdgeInsets.all(24),
                  child:
                      AddReviewDialog(customerReview: _viewModel.getReviews[i]),
                ),
              );
            },
          ),
          shrinkWrap: true,
        ),
      ],
    );
  }

  Widget _reviewHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer Review", style: FontStyles.font24Semibold),
            Text("Your list of review is here",
                style: FontStyles.font14Semibold),
          ],
        ),
        CTAButton(
            title: "Add Customer Review",
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Dialog(
                  insetPadding: EdgeInsets.all(24),
                  child: AddReviewDialog(),
                ),
              );
            }),
      ],
    );
  }

  Widget _editContactDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _contactDetailHeading(),
        const Divider(),
        ListView.builder(
          itemCount: _viewModel.getContactDetails.length,
          itemBuilder: (_, i) => ListTile(
            dense: true,
            title: Text(_viewModel.getContactDetails[i].name),
            subtitle: Text(_viewModel.getContactDetails[i].description),
            leading: Image.network(_viewModel.getContactDetails[i].iconUrl),
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Dialog(
                  insetPadding: const EdgeInsets.all(24),
                  child: AddContactDialog(
                      contactDetail: _viewModel.getContactDetails[i]),
                ),
              );
            },
          ),
          shrinkWrap: true,
        ),
      ],
    );
  }

  Widget _contactDetailHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact Detail", style: FontStyles.font24Semibold),
            Text("Your list of contacts is here",
                style: FontStyles.font14Semibold),
          ],
        ),
        CTAButton(
            title: "Add Contact Detail",
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Dialog(
                  insetPadding: EdgeInsets.all(24),
                  child: AddContactDialog(),
                ),
              );
            }),
      ],
    );
  }
}
