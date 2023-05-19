import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/enum/contact.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/category_client/category_client_page.dart';
import 'package:admin/presentation/pages/landing_admin/show_contactus_details_dialog.dart';
import 'package:admin/presentation/pages/widgets/circular_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AdminContactServiceContainer extends StatelessWidget {
  final ContactUsForm category;
  final double width;
  final bool contactCard;

  const AdminContactServiceContainer({
    super.key,
    required this.category,
    required this.width,
    this.contactCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Dialog(
            insetPadding: const EdgeInsets.all(24),
            child: AdminShowContactUsDialog(contact: category),
          ),
        );
      },
      child: Flexible(
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 20,
          runSpacing: 20,
          children: [
            LimitedBox(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
              child: Container(
                width: width / 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.yellowColor,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 20,
                      child: SvgPicture.asset(
                        Assets.iconsVectoroverlayright,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(category.firstName.toUpperCase(),
                              style: FontStyles.font24Semibold),
                          Text(category.lastName.toUpperCase(),
                              style: FontStyles.font24Semibold),
                          const SizedBox(height: 8),
                          Text(category.companyName,
                              style: FontStyles.font14Semibold),
                          const SizedBox(height: 8),
                          Text(category.email ?? "",
                              style: FontStyles.font14Semibold),
                          const CircularArrow(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
