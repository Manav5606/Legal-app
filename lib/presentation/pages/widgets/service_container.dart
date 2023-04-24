import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/resource.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/category_client/category_client_page.dart';
import 'package:admin/presentation/pages/widgets/circular_arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:routemaster/routemaster.dart';

class ServiceContainer extends StatelessWidget {
  final Category category;
  final double width;
  const ServiceContainer({
    super.key,
    required this.category,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Routemaster.of(context).push(CategoryClientPage.routeName,
            queryParameters: {"categoryId": category.id!});
      },
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
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.blueColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(Assets.iconsVectorbookmark),
                  ),
                  const SizedBox(height: 12),
                  Text(category.name.toUpperCase(),
                      style: FontStyles.font24Semibold),
                  const SizedBox(height: 4),
                  Text(category.description, style: FontStyles.font10Medium),
                  const SizedBox(height: 8),
                  const CircularArrow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
