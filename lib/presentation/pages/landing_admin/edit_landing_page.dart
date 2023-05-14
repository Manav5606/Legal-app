import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_banner_dialog.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_contact_dialog.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_review_dialog.dart';
import 'package:admin/presentation/pages/landing_admin/dialog/add_stats.dart';
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
    _viewModel.initStats();
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
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  _editBanner(),
                  _editReview(),
                  _editContactDetail(),
                  _editStats()
                ],
              ),
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
    return ExpansionTile(
      title: _bannerHeading(),
      children: _viewModel.getBanners.map((banner) {
        return ListTile(
          dense: true,
          title: Text(banner.title),
          subtitle: Text(banner.description),
          leading: Image.network(banner.imageUrl),
          // trailing: TextButton(
          //   child: Text(banner.btnText),
          //   onPressed: () => launchUrlString(banner.urlToLoad),
          // ),
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Dialog(
                insetPadding: const EdgeInsets.all(24),
                child: AddBannerDialog(bannerDetail: banner),
              ),
            );
          },
        );
      }).toList(),
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

  Widget _editStats() {
    return ExpansionTile(
      title: _statsHeading(),
      children: _viewModel.getStats.map((stats) {
        return ListTile(
          dense: true,
          title: Text(stats.title),
          subtitle: Text(stats.description),
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Dialog(
                insetPadding: const EdgeInsets.all(24),
                child: AddStatsDilaog(statsDetails: stats),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _statsHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Stats", style: FontStyles.font24Semibold),
            Text("Your list of stats is here",
                style: FontStyles.font14Semibold),
          ],
        ),
        CTAButton(
            title: "Add Stats",
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Dialog(
                  insetPadding: EdgeInsets.all(24),
                  child: AddStatsDilaog(),
                ),
              );
            }),
      ],
    );
  }

  Widget _editReview() {
    return ExpansionTile(
      title: _reviewHeading(),
      children: _viewModel.getReviews
          .map((review) => ListTile(
                dense: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(review.title),
                    Column(
                      children: [
                        Text(review.designation),
                        Text(review.name),
                      ],
                    )
                  ],
                ),
                subtitle: Text(review.review),
                leading: Image.network(review.customerProfilePic),
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Dialog(
                      insetPadding: const EdgeInsets.all(24),
                      child: AddReviewDialog(customerReview: review),
                    ),
                  );
                },
              ))
          .toList(),
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
    return ExpansionTile(
      title: _contactDetailHeading(),
      children: _viewModel.getContactDetails
          .map((contactDetails) => ListTile(
                dense: true,
                title: Text(contactDetails.name),
                subtitle: Text(contactDetails.description),
                leading: Image.network(contactDetails.iconUrl),
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Dialog(
                      insetPadding: const EdgeInsets.all(24),
                      child: AddContactDialog(contactDetail: contactDetails),
                    ),
                  );
                },
              ))
          .toList(),
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
