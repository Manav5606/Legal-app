import 'package:admin/core/constant/colors.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/widgets/service_container.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/resource.dart';
import 'contact_service_conatiner.dart';

class ContactUsCard extends StatefulWidget {
  const ContactUsCard({
    super.key,
    required this.contactDetails,
    required this.height,
  });

  final List<Category> contactDetails;
  final double height;

  @override
  State<ContactUsCard> createState() => _ContactUsCardState();
}

class _ContactUsCardState extends State<ContactUsCard> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  .map((contact) => ContactServiceContainer(
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
