import 'package:admin/presentation/pages/profile/widget/add_service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/fontstyles.dart';
import '../profile_view_model.dart';

class AddRemoveServiceDailog extends ConsumerStatefulWidget {
  final String userID;
  const AddRemoveServiceDailog(this.userID, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddRemoveServiceDailogState();
}

class _AddRemoveServiceDailogState
    extends ConsumerState<AddRemoveServiceDailog> {
  late final AddRemoveServiceViewModel _viewModel;
  @override
  void initState() {
    _viewModel = ref.read(AddRemoveServiceViewModel.provider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchService();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(AddRemoveServiceViewModel.provider);
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('vendor-service');
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.height * 0.7,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _viewModel.getService.length,
          itemBuilder: (BuildContext context, int index) {
            final service = _viewModel.getService[index];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    width: 300,
                    child: Text(service.aboutDescription),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: usersRef
                          .where('vendor_id', isEqualTo: widget.userID)
                          .get()
                          .then((snapshot) => snapshot.docs.isNotEmpty
                              ? snapshot.docs.first.reference.get()
                              : Future.value(null)),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final docRef = snapshot.data;
                          if (docRef != null &&
                              docRef.get('service_id').contains(service.id)) {
                            return Padding(
                              padding: EdgeInsets.all(8.0).copyWith(right: 20),
                              child: Text("Already Added"),
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.all(8.0).copyWith(right: 20),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final myList = [service.id!];
                                  await _viewModel.addService(
                                      myList, widget.userID);
                                  // Update the dialog content
                                },
                                child: Text("Add"),
                              ),
                            );
                          }
                        } else {
                          return Text("Loading...");
                        }
                      },
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    final myList = [service.id!];
                    await _viewModel.removeServicesFromVendor(
                        myList, widget.userID);
                    // Update the dialog content
                  },
                  child: Text(
                    "Remove",
                    style: FontStyles.font14Semibold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
