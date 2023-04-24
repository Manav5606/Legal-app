import 'package:admin/core/constant/colors.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/widgets/service_container.dart';
import 'package:flutter/material.dart';

class ContactUsCard extends StatelessWidget {
  const ContactUsCard({
    super.key,
    required this.contactDetails,
    required this.height,
  });

  final List<Category> contactDetails;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height * 0.40,
              width: double.infinity,
              color: AppColors.blueColor,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: contactDetails
                  .map((contact) => ServiceContainer(
                      contactCard: true,
                      category: contact,
                      width: MediaQuery.of(context).size.width))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
