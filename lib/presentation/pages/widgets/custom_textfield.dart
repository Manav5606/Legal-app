import 'package:admin/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimaryTextField extends FormField<String> {
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

  PrimaryTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.backgroundColor = AppColors.lightBacgroundColor,
    this.maxLines = 1,
    this.readOnly = false,
    this.showBorder = true,
    this.onTap,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
  }) : super(
          key: key,
          initialValue: controller.text,
          validator: validator,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<String> field) {
            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            BoxBorder setBorder() {
              Color borderColor = (!field.isValid && field.errorText == null)
                  ? AppColors.lightBacgroundColor
                  : field.isValid
                      ? AppColors.lightBacgroundColor
                      : Colors.red;
              return Border.all(width: 0.8, color: borderColor);
            }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: suffixIcon != null
                        ? EdgeInsets.only(left: Sizes.s12.h)
                        : prefixIcon == null
                            ? EdgeInsets.symmetric(
                                horizontal: Sizes.s12.h,
                                vertical: maxLines > 1 ? Sizes.s8.h : 0,
                              )
                            : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(Sizes.s6.r),
                      border: showBorder ? setBorder() : null,
                    ),
                    child: TextField(
                      cursorColor: AppColors.primaryColor,
                      autocorrect: false,
                      style: TextStyle(
                        color: Colors.black,
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
                        contentPadding: EdgeInsets.zero,
                        hintText: hintText,
                        prefixIcon: prefixIcon,
                        suffixIcon: suffixIcon,
                        border: InputBorder.none,
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
