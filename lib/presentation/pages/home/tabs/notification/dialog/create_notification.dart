import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/sizes.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/pages/widgets/dialog_textfield.dart';
import 'package:flutter/material.dart';

class CreateNotification extends StatelessWidget {
  const CreateNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create Notification",
                  style: FontStyles.font24Semibold.copyWith(
                    color: AppColors.blueColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.cancel, color: AppColors.blueColor),
                ),
              ],
            ),
            SizedBox(height: Sizes.s20.h),
            DialogTextField(
              width: 600 * 0.8,
              errorText: '',
              label: "Title",
              hintText: "Enter Title",
              controller: TextEditingController(),
            ),
            const SizedBox(height: 12),
            DialogTextField(
              width: 600 * 0.8,
              errorText: '',
              label: "Subtitle",
              hintText: "Enter Subtitle",
              controller: TextEditingController(),
            ),
            const SizedBox(height: 12),
            const CTAButton(title: "Add Notification"),
          ],
        ),
      ),
    );
  }
}
