import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:flutter/material.dart';

class CTAButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final bool fullWidth;
  final double? radius;
  final bool loading;
  final bool mobile;
  final Color? color;

  const CTAButton({
    super.key,
    this.onTap,
    this.mobile = false,
    required this.title,
    this.fullWidth = false,
    this.radius,
    this.loading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: loading ? null : onTap,
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: mobile ? 12 : 42, vertical: mobile ? 4 : 14),
            width: fullWidth ? MediaQuery.of(context).size.width : null,
            decoration: BoxDecoration(
                color: color ?? AppColors.yellowColor,
                borderRadius: BorderRadius.circular(radius ?? 8)),
            child: fullWidth ? Center(child: _title()) : _title()));
  }

  Widget _title() => loading
      ? const CircularProgressIndicator.adaptive()
      : Text(title, style: FontStyles.font14Bold);
}
