import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogTextField extends FormField<String> {
  final String? label;
  final String hintText;
  final bool readOnly;
  final int maxLines;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color backgroundColor;
  final bool showBorder;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final String? errorText;
  static const Color defaultBackgroundColor = Color(0xffFAFBFF);

  DialogTextField({
    Key? key,
    this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon =
        const IconButton(onPressed: null, icon: SizedBox.shrink()),
    this.inputFormatters,
    this.backgroundColor = defaultBackgroundColor,
    this.maxLines = 1,
    this.readOnly = false,
    this.showBorder = true,
    this.onTap,
    this.errorText,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    ValueChanged<String>? onChanged,
  }) : super(
          key: key,
          initialValue: controller.text,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<String> field) {
            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            // BoxBorder setBorder() {
            //   Color borderColor = (!field.isValid && field.errorText == null)
            //       ? defaultBackgroundColor
            //       : field.isValid
            //           ? defaultBackgroundColor
            //           : Colors.red;
            //   return Border.all(width: 0.8, color: borderColor);
            // }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: label != null,
                      child: Text(label ?? "",
                          style: FontStyles.font14Semibold
                              .copyWith(color: AppColors.greyColor))),
                  Container(
                    padding: suffixIcon != null
                        ? EdgeInsets.only(left: Sizes.s12.h)
                        : prefixIcon == null
                            ? EdgeInsets.symmetric(
                                horizontal: Sizes.s12.h,
                                vertical: maxLines > 1 ? Sizes.s8.h : 0,
                              )
                            : EdgeInsets.zero,
                    child: TextField(
                      cursorColor: AppColors.blueColor,
                      autocorrect: false,
                      style: TextStyle(
                        color: AppColors.blueColor,
                        fontSize: Sizes.s16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      maxLines: maxLines,
                      onTap: onTap,
                      controller: controller,
                      keyboardType: keyboardType,
                      onChanged: onChangedHandler,
                      readOnly: readOnly,
                      obscureText: obscureText,
                      inputFormatters: inputFormatters,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: hintText,
                        prefixIcon: prefixIcon,
                        suffixIcon: suffixIcon,
                        border: InputBorder.none,
                        errorText: errorText,
                      ),
                    ),
                  ),
                  if (!field.isValid && field.errorText != null)
                    Visibility(
                      visible: !field.isValid,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 7, left: 3),
                        child: Text(
                          field.errorText ?? '',
                          style: TextStyle(
                            fontSize: Sizes.s12.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
}
