import 'package:admin/core/enum/qualification.dart';
import 'package:admin/presentation/pages/profile/profile_view_model.dart';
import 'package:admin/presentation/pages/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddQualificationDegree extends ConsumerStatefulWidget {
  const AddQualificationDegree({super.key});

  @override
  ConsumerState<AddQualificationDegree> createState() =>
      _AddQualificationDegreeState();
}

class _AddQualificationDegreeState
    extends ConsumerState<AddQualificationDegree> {
  QualificationDegree degree = QualificationDegree.ca;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(8),
      title: const Text("Add Qualification Degree"),
      children: [
        DropdownMenu(
          initialSelection: degree.name,
          dropdownMenuEntries: QualificationDegree.values
              .map((e) => DropdownMenuEntry(value: e.name, label: e.title))
              .toList(),
          onSelected: (v) {
            if (v != null) {
              setState(() {
                degree = QualificationDegree.values
                    .firstWhere((element) => element.name == v);
              });
            }
          },
        ),
        Visibility(
            visible: degree == QualificationDegree.other,
            child: CustomTextField(
              hintText: "Degree name",
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
                  ref.read(ProfileViewModel.provider).addQualificationDegree(
                      degree == QualificationDegree.other
                          ? _controller.text
                          : degree.title);
                  Navigator.pop(context);
                },
                child: const Text("Add")),
          ],
        ),
      ],
    );
  }
}
