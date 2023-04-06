import 'package:admin/core/enum/qualification.dart';
import 'package:admin/presentation/pages/profile/profile_view_model.dart';
import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddQualificationUniversity extends ConsumerStatefulWidget {
  const AddQualificationUniversity({super.key});

  @override
  ConsumerState<AddQualificationUniversity> createState() =>
      _AddQualificationUniversityState();
}

class _AddQualificationUniversityState
    extends ConsumerState<AddQualificationUniversity> {
  QualificationUniversity university =
      QualificationUniversity.barCounsilOfIndia;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(8),
      title: const Text("Add Qualification university"),
      children: [
        DropdownMenu(
          initialSelection: university.name,
          dropdownMenuEntries: QualificationUniversity.values
              .map((e) => DropdownMenuEntry(value: e.name, label: e.title))
              .toList(),
          onSelected: (v) {
            if (v != null) {
              setState(() {
                university = QualificationUniversity.values
                    .firstWhere((element) => element.name == v);
              });
            }
          },
        ),
        Visibility(
            visible: university == QualificationUniversity.other,
            child: CustomTextField(
              hintText: "university name",
              controller: _controller,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  ref
                      .read(ProfileViewModel.provider)
                      .addQualificationUniversity(
                          university == QualificationUniversity.other
                              ? _controller.text
                              : university.title);
                  Navigator.pop(context);
                },
                child: const Text("Add")),
          ],
        ),
      ],
    );
  }
}
