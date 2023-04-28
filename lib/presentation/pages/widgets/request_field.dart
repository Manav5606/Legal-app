// import 'package:admin/core/enum/field_type.dart';
// import 'package:admin/data/models/models.dart';
// import 'package:cross_file/cross_file.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class RequestInputField extends ConsumerStatefulWidget {
//   final ServiceRequest serviceRequest;
//   const RequestInputField({Key? key, required this.serviceRequest})
//       : super(key: key);

//   @override
//   ConsumerState<RequestInputField> createState() => _RequestInputFieldState();
// }

// class _RequestInputFieldState extends ConsumerState<RequestInputField> {
//   late final TextEditingController controller;
//   bool active = false;
//   bool clearError = false;
//   final FocusNode focusNode = FocusNode();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   bool loading = false;

//   @override
//   void initState() {
//     controller = TextEditingController(text: widget.serviceRequest.value);

//     focusNode.addListener(() {
//       if (focusNode.hasFocus && !active) {
//         setState(() {
//           active = true;
//         });
//       }
//     });
//     super.initState();
//   }

//   Future<XFile?> pickFile(FilePickerResult? result) async {
//     if (result != null) {
//       final choosenFile = result.files.first;
//       return XFile.fromData(choosenFile.bytes!, name: choosenFile.name);
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: formKey,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.7,
//         child: Row(
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   Text(widget.serviceRequest.fieldName,
//                       style: const TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     child: InkWell(
//                       onTap: widget.serviceRequest.fieldType ==
//                                   ServiceFieldType.image ||
//                               widget.serviceRequest.fieldType ==
//                                   ServiceFieldType.file
//                           ? () async {
//                               setState(() {
//                                 active = true;
//                               });
//                               final file = await pickFile(
//                                   await FilePicker.platform.pickFiles());
//                               if (file != null) {
//                                 // controller.text =
//                                 // await uploadToFirebaseAndGetUrl(file: file);
//                               }
//                             }
//                           : null,
//                       child: AbsorbPointer(
//                         absorbing: widget.serviceRequest.fieldType ==
//                                 ServiceFieldType.image ||
//                             widget.serviceRequest.fieldType ==
//                                 ServiceFieldType.file ||
//                             widget.serviceRequest.fieldType ==
//                                 ServiceFieldType.date,
//                         child: widget.serviceRequest.fieldType ==
//                                     ServiceFieldType.image ||
//                                 widget.serviceRequest.fieldType ==
//                                     ServiceFieldType.file
//                             ? OutlinedButton(
//                                 onPressed: () {},
//                                 child: Text(
//                                     "Upload ${widget.serviceRequest.fieldName}"))
//                             : Expanded(
//                                 child: TextFormField(
//                                   focusNode: focusNode,
//                                   controller: controller,
//                                   autocorrect: true,
//                                   onChanged: (v) {
//                                     _validateValue(v);
//                                     setState(() {});
//                                   },
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(4)),
//                                   ),
//                                   validator: _validateValue,
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 20),
//             Visibility(
//               visible: active,
//               child: loading
//                   ? const CircularProgressIndicator.adaptive()
//                   : Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             controller.text = widget.serviceRequest.value ?? "";
//                             if (widget.serviceRequest.fieldType ==
//                                     ServiceFieldType.image &&
//                                 widget.serviceRequest.value?.isNotEmpty ==
//                                     true) {
//                               userImage = UserImage.fromURI(
//                                   widget.serviceRequest.value);
//                             }
//                             setState(() {
//                               active = false;
//                               clearError = true;
//                             });
//                             formKey.currentState!.validate();
//                           },
//                           icon: const Icon(Icons.cancel, color: Colors.red),
//                         ),
//                         IconButton(
//                           onPressed: () async {
//                             try {
//                               if (widget.serviceRequest.fieldType ==
//                                   ServiceFieldType.image) {
//                                 setState(() {
//                                   loading = true;
//                                 });
//                                 final uri =
//                                     await _uploadImageAndReturnUrl(userImage);
//                                 if (uri == null) {
//                                   return;
//                                 }
//                                 await ref
//                                     .read(AppSettingViewserviceRequest.provider)
//                                     .saveToFirestore(widget.serviceRequest, uri,
//                                         widget.name);
//                                 Fluttertoast.showToast(
//                                     msg:
//                                         "${widget.serviceRequest.title} saved ✅");
//                                 setState(() {
//                                   active = false;
//                                 });
//                               } else {
//                                 if (formKey.currentState!.validate()) {
//                                   final bool value = await showDialog(
//                                     context: context,
//                                     builder: (_) => AlertDialog(
//                                       title: const SizedBox(
//                                         width: 600,
//                                         child: Text(
//                                             "WARNING: Changing this will overwrite the entire app theme and impact changes through out the app. If you want to change specific parts of the app you should change them in the app branding section. Are you sure you want to continue?"),
//                                       ),
//                                       actions: [
//                                         TextButton(
//                                             onPressed: () async {
//                                               Navigator.of(context,
//                                                       rootNavigator: true)
//                                                   .pop(true);
//                                             },
//                                             child: loading
//                                                 ? const CircularProgressIndicator
//                                                     .adaptive()
//                                                 : const Text("I Understand")),
//                                         TextButton(
//                                             onPressed: () {
//                                               Navigator.of(context,
//                                                       rootNavigator: true)
//                                                   .pop(false);
//                                             },
//                                             child: const Text("Cancel",
//                                                 style: TextStyle(
//                                                     color: Colors.red))),
//                                       ],
//                                     ),
//                                   );
//                                   if (value) {
//                                     setState(() {
//                                       loading = true;
//                                     });
//                                     if (widget.serviceRequest.fieldType ==
//                                             ServiceFieldType.color &&
//                                         widget.name == TabName.general &&
//                                         widget.serviceRequest.title ==
//                                             "Primary Color") {
//                                       await ref
//                                           .read(AppSettingViewserviceRequest
//                                               .provider)
//                                           .savePrimaryColorsFirestore(
//                                               controller.text.trim());
//                                     } else if (widget
//                                                 .serviceRequest.fieldType ==
//                                             ServiceFieldType.color &&
//                                         widget.name == TabName.general &&
//                                         widget.serviceRequest.title ==
//                                             "Secondary Color") {
//                                       await ref
//                                           .read(AppSettingViewserviceRequest
//                                               .provider)
//                                           .saveSecondaryColorsFirestore(
//                                               controller.text.trim());
//                                     } else if (widget
//                                                 .serviceRequest.fieldType ==
//                                             ServiceFieldType.fontfamily &&
//                                         widget.name == TabName.general &&
//                                         widget.serviceRequest.title ==
//                                             "Secondary Font") {
//                                       await ref
//                                           .read(AppSettingViewserviceRequest
//                                               .provider)
//                                           .savePrimaryFontFirestore(
//                                               controller.text.trim());
//                                     } else if (widget
//                                                 .serviceRequest.fieldType ==
//                                             ServiceFieldType.fontfamily &&
//                                         widget.name == TabName.general &&
//                                         widget.serviceRequest.title ==
//                                             "Secondary Font") {
//                                       await ref
//                                           .read(AppSettingViewserviceRequest
//                                               .provider)
//                                           .saveSecondaryFontFirestore(
//                                               controller.text.trim());
//                                     } else {
//                                       await ref
//                                           .read(AppSettingViewserviceRequest
//                                               .provider)
//                                           .saveToFirestore(
//                                               widget.serviceRequest,
//                                               controller.text.trim(),
//                                               widget.name);
//                                     }
//                                     Fluttertoast.showToast(
//                                         msg:
//                                             "${widget.serviceRequest.title} saved ✅");
//                                   } else {
//                                     controller.text =
//                                         widget.serviceRequest.value;
//                                     if (widget.serviceRequest.fieldType ==
//                                             ServiceFieldType.image &&
//                                         widget
//                                             .serviceRequest.value.isNotEmpty) {
//                                       userImage = UserImage.fromURI(
//                                           widget.serviceRequest.value);
//                                     }
//                                     setState(() {
//                                       active = false;
//                                       clearError = true;
//                                     });
//                                     formKey.currentState!.validate();
//                                   }
//                                   setState(() {
//                                     active = false;
//                                   });
//                                 }
//                               }
//                             } catch (_) {
//                             } finally {
//                               setState(() {
//                                 loading = false;
//                               });
//                             }
//                           },
//                           icon: const Icon(Icons.done, color: Colors.green),
//                         ),
//                       ],
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Future<String?> _uploadImageAndReturnUrl(UserImage image) async {
//   //   if (image.fieldType == eIMAGE_TYPE.FROM_FB) {
//   //     return image.uri;
//   //   } else if (image.fieldType == eIMAGE_TYPE.FROM_PC) {
//   //     var uploadPath = getImagePath(image.fileName!,
//   //         FB_GALLERY_PATH: Configs.FB_GALLERY_PATH);
//   //     var imageURI =
//   //         await WebStorageHandler.instance.uploadImage(uploadPath, image.bytes);
//   //     return imageURI?.toString();
//   //   } else {
//   //     return null;
//   //   }
//   // }

//   Future<dynamic> datePickDialog(BuildContext context) {
//     return showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//     ).then((value) {
//       if (value != null) {
//         controller.text = value.toString();
//       }
//     });
//     // return showDialog(
//     //     context: context,
//     //     builder: (_) => AlertDialog(
//     //           title: const Text('Pick a color!'),
//     //           content: SingleChildScrollView(
//     //             child: ColorPicker(
//     //               pickerColor: widget.serviceRequest.value.isEmpty
//     //                   ? Colors.black
//     //                   : Color(PartnerConfig.colorIntConversion(
//     //                       controller.text.trim())),
//     //               onColorChanged: (color) {
//     //                 controller.text = color
//     //                     .toString()
//     //                     .replaceAll("Color(0xff", "")
//     //                     .replaceAll(")", "");
//     //                 setState(() {});
//     //               },
//     //             ),
//     //           ),
//     //         ));
//   }

//   String? _validateValue(String? value) {
//     if (clearError) {
//       setState(() {
//         clearError = false;
//       });
//       return null;
//     }
//     switch (widget.serviceRequest.fieldType) {
//       case ServiceFieldType.image:
//         if (value == null || value.isEmpty) {
//           return "Invalid Image.";
//         }
//         break;
//       case ServiceFieldType.text:
//         if (value == null || value.isEmpty) {
//           return "This field is required";
//         }
//         break;
//       case ServiceFieldType.file:
//         if (value == null || value.isEmpty) {
//           return "Invalid File.";
//         }
//         break;
//       case ServiceFieldType.number:
//         if (value == null || value.isEmpty || num.tryParse(value) == null) {
//           return "Invalid Number.";
//         }
//         break;
//       case ServiceFieldType.date:
//         if (value == null || value.isEmpty) {
//           return "Invalid Date.";
//         }
//         break;
//     }
//     return null;
//   }
// }
