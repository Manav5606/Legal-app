import 'package:admin/core/constant/colors.dart';
import 'package:admin/data/models/models.dart';
import 'package:admin/presentation/pages/landing_admin/edit_landing_view_model.dart';
import 'package:admin/presentation/pages/landing_admin/view_contact_us_card_service_container.dart';
import 'package:admin/presentation/pages/widgets/service_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../core/constant/fontstyles.dart';
import '../../../core/constant/resource.dart';
import '../widgets/contact_service_conatiner.dart';

class ViewContactUsCard extends ConsumerStatefulWidget {
  const ViewContactUsCard({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewContactUsCardState();
}

class _ViewContactUsCardState extends ConsumerState<ViewContactUsCard> {
  late final EditLandingViewModel _viewModel;
  @override
  void initState() {
    _viewModel = ref.read(EditLandingViewModel.provider);

    _viewModel.initContactUsCardDetails();

    // _viewModel.initNewss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(EditLandingViewModel.provider);
    return ScreenTypeLayout.builder(
      desktop: (context) => SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 20),
                child: Text("Contact Us", style: FontStyles.font24Semibold),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 20,
                    runSpacing: 20,
                    children: _viewModel.getContactUs
                        .map((contact) => AdminContactServiceContainer(
                              contactCard: true,
                              category: contact,
                              width: MediaQuery.of(context).size.width,
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      mobile: (context) => SizedBox(
        height: 1000,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _viewModel.getContactUs
                      .map((contact) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AdminContactServiceContainer(
                                contactCard: true,
                                category: contact,
                                width: MediaQuery.of(context).size.width * 4.3),
                          ))
                      .toList(),
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
