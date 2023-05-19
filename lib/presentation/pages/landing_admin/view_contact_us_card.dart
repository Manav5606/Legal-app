import 'package:admin/core/constant/colors.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/landing_admin/view_contact_us_card_service_container.dart';
import 'package:admin/presentation/pages/widgets/service_container.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/constant/resource.dart';
import '../widgets/contact_service_conatiner.dart';


class ViewContactUsCard extends StatefulWidget {
  const ViewContactUsCard({
    super.key,
    required this.contactDetails,
    required this.height,
  });

  final List<ContactUsForm> contactDetails;
  final double height;

  @override
  State<ViewContactUsCard> createState() => _ViewContactUsCardState();
}

class _ViewContactUsCardState extends State<ViewContactUsCard> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      desktop: (context) => SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: widget.height * 0.40,
                width: double.infinity,
                color: AppColors.blueColor,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.contactDetails
                    .map((contact) => AdminContactServiceContainer(
                        contactCard: true,
                        category: contact,
                        width: MediaQuery.of(context).size.width))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      mobile: (context) => SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: widget.height,
                width: double.infinity,
                color: AppColors.blueColor,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.contactDetails
                    .map((contact) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AdminContactServiceContainer(
                              contactCard: true,
                              category: contact,
                              width: MediaQuery.of(context).size.width * 4.3),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
