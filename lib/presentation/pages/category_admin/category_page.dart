import 'package:admin/core/constant/colors.dart';
import 'package:admin/core/constant/fontstyles.dart';
import 'package:admin/core/extension/date.dart';
import 'package:admin/presentation/pages/category_admin/category_view_model.dart';
import 'package:admin/presentation/pages/category_admin/dialog/add_category_dialog.dart';
import 'package:admin/presentation/pages/widgets/cta_button.dart';
import 'package:admin/presentation/utils/web_scroll.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryPage extends ConsumerStatefulWidget {
  static const String routeName = "/category";

  const CategoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  late final CategoryViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ref.read(CategoryViewModel.provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(CategoryViewModel.provider);
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
                              border: TableBorder.symmetric(
                                  outside:
                                      BorderSide(color: AppColors.greyColor)),
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
                                  label: const Text("Category ID"),
                                  onSort: _viewModel.sortCategories,
                                ),
                                DataColumn(
                                  numeric: true,
                                  label: const Text("Name"),
                                  onSort: _viewModel.sortCategories,
                                ),
                                const DataColumn(
                                  label: Text("Icon"),
                                  // onSort: _viewModel.sortCategories,
                                ),
                                const DataColumn(
                                  numeric: true,
                                  label: Text("Description"),
                                  // onSort: _viewModel.sortCategories,
                                ),
                                DataColumn(
                                  label: const Text("Added at"),
                                  onSort: _viewModel.sortCategories,
                                ),
                                DataColumn(
                                  label: const Text("Added by"),
                                  onSort: _viewModel.sortCategories,
                                ),
                                const DataColumn(label: Text("Action")),
                              ],
                              rows: _viewModel.getCategories.map(
                                (data) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(data.id.toString())),
                                      DataCell(Text(data.name.toString())),
                                      DataCell(CachedNetworkImage(
                                          imageUrl: data.iconUrl,
                                          height: 30,
                                          width: 30)),
                                      DataCell(Text(data.description.toString(),
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(
                                          Text(data.addedAt!.formatToDate())),
                                      DataCell(Text(data.name.toString())),
                                      DataCell(Text(data.addedBy.toString())),
                                      DataCell(TextButton(
                                          child: const Text("Edit"),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => Dialog(
                                                insetPadding:
                                                    const EdgeInsets.all(24),
                                                child: AddCategoryDialog(
                                                    categoryDetail: data),
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
            Text("Category", style: FontStyles.font24Semibold),
            Text("Your list of category is here",
                style: FontStyles.font14Semibold),
          ],
        ),
        CTAButton(
            title: "Add Category",
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Dialog(
                  insetPadding: EdgeInsets.all(24),
                  child: AddCategoryDialog(),
                ),
              );
            }),
      ],
    );
  }
}
