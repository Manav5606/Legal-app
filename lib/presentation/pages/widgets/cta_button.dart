import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:flutter/material.dart';

class CTAButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final bool fullWidth;

  const CTAButton(
      {super.key, this.onTap, required this.title, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 14),
            width: fullWidth ? MediaQuery.of(context).size.width : null,
            decoration: BoxDecoration(
                color: AppColors.yellowColor,
                borderRadius: BorderRadius.circular(8)),
            child: fullWidth ? Center(child: _title()) : _title()));
  }

  Text _title() => Text(title, style: FontStyles.font14Bold);
}
