import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/core/enum/contact.dart';
import 'package:admin/core/utils/messenger.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/category_client/category_client_page.dart';
import 'package:admin/presentation/pages/widgets/circular_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactServiceContainer extends StatelessWidget {
  final Category category;
  final double width;
  final bool contactCard;

  const ContactServiceContainer({
    super.key,
    required this.category,
    required this.width,
    this.contactCard = false,
  });

  void openGoogleMaps(String address) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$address';

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (contactCard) {
          if (category.detail == ContactDetails.phone.name) {
            launchUrlString("tel:+918125504448");
          }
          if (category.detail == ContactDetails.address.name) {
            openGoogleMaps(
                "SAI NAGAR COLONY,MANSOORABAD Hyderabad TG 500068 IN");
          }
        } else {
          Routemaster.of(context).push(CategoryClientPage.routeName,
              queryParameters: {"categoryId": category.id!});
        }
      },
      child: Container(
        width: width / 5,
        height: MediaQuery.of(context).size.height * 0.35,
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
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.blueColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Image.network(
                      category.iconUrl ?? Assets.iconsVectorbookmark,
                      height: 15,
                      width: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(category.name.toUpperCase(),
                      style: FontStyles.font24Semibold),
                  const SizedBox(height: 4),
                  Text(category.description, style: FontStyles.font10Medium),
                  const SizedBox(height: 8),
                  Visibility(
                      visible: category.detail != ContactDetails.none.name,
                      child: const CircularArrow()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
