import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/presentation/pages/user_admin/dialog/add_user_dialog.dart';
import 'package:admin/presentation/pages/user_admin/user_view_model.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/utils/web_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPage extends ConsumerStatefulWidget {
  static const String routeName = "/user";

  const UserPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  late final UserViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(UserViewModel.provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(UserViewModel.provider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _heading(),
          const SizedBox(height: 28),
          Expanded(child: _dataTable()),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _dataTable() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _viewModel.error != null
              ? Center(child: Text("⚠️ ${_viewModel.error}"))
              : LayoutBuilder(builder: (context, constraints) {
                  return ScrollConfiguration(
                    behavior: WebScrollBehavior(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.minWidth),
                          child: DataTable(
                              clipBehavior: Clip.antiAlias,
                              border: TableBorder.all(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColors.greyColor),
                              sortAscending: !_viewModel.sortAscending,
                              sortColumnIndex: _viewModel.sortIndex,
                              dataRowColor: MaterialStateProperty.all(
                                  AppColors.lightGreyColor),
                              headingRowColor: MaterialStateProperty.all(
                                  AppColors.whiteColor),
                              dataTextStyle: FontStyles.font14Semibold
                                  .copyWith(color: AppColors.blueColor),
                              headingTextStyle: FontStyles.font16Semibold
                                  .copyWith(color: AppColors.blackColor),
                              columns: [
                                DataColumn(
                                  label: const Text("User ID"),
                                  onSort: _viewModel.sortUsers,
                                ),
                                DataColumn(
                                  label: const Text("Date"),
                                  onSort: _viewModel.sortUsers,
                                ),
                                DataColumn(
                                  label: const Text("Username"),
                                  onSort: _viewModel.sortUsers,
                                ),
                                DataColumn(
                                  label: const Text("Contact"),
                                  onSort: _viewModel.sortUsers,
                                ),
                                DataColumn(
                                  label: const Text("Email"),
                                  onSort: _viewModel.sortUsers,
                                ),
                                const DataColumn(label: Text("Action")),
                              ],
                              rows: _viewModel.getUsers.map(
                                (data) {
                                  return DataRow(
                                    color: data.isDeactivated
                                        ? MaterialStateProperty.all(
                                            AppColors.lightRedColor)
                                        : null,
                                    cells: [
                                      DataCell(Text(data.id.toString())),
                                      DataCell(Text(data.createdAt.toString())),
                                      DataCell(Text(data.name.toString())),
                                      DataCell(
                                          Text(data.phoneNumber.toString())),
                                      DataCell(Text(data.email.toString())),
                                      DataCell(TextButton(
                                          child: const Text("Edit"),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => Dialog(
                                                insetPadding:
                                                    const EdgeInsets.all(24),
                                                child: AddUserDialog(
                                                    userUser: data),
                                              ),
                                            );
                                          })),
                                    ],
                                  );
                                },
                              ).toList()),
                        ),
                      ),
                    ),
                  );
                }),
    );
  }

  Widget _heading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User", style: FontStyles.font24Semibold),
            Text("Your list of user is here", style: FontStyles.font14Semibold),
          ],
        ),
        CTAButton(
            title: "Add User",
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Dialog(
                  insetPadding: EdgeInsets.all(24),
                  child: AddUserDialog(),
                ),
              );
            }),
      ],
    );
  }
}
