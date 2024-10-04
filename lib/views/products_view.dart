// ignore_for_file: function_lines_of_code
import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/controllers/product_controller.dart';
import 'package:sales/di.dart';
import 'package:sales/models/category.dart';

/// Màn hình sản phẩm.
class ProductsView extends StatefulWidget {
  /// Màn hình sản phẩm.
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final controller = getIt<ProductController>();

  @override
  void initState() {
    super.initState();
    controller.initial(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                  onPressed: () {
                    controller.addProduct(context, setState);
                  },
                  child: const Icon(Icons.add),
                ),
                Row(
                  children: [
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        controller.loadDataFromExcel(context, setState);
                      },
                      icon: const Icon(Icons.upload_rounded),
                    ),
                    SizedBox(
                      width: 200,
                      child: BoxWInput(
                        onChanged: (value) {
                          controller.onSearchChanged(setState, value);
                        },
                        suffixIcon: const Icon(Icons.search),
                      ),
                    ),
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        controller.onFilterTapped(context, setState);
                      },
                      icon: const Icon(FontAwesomeIcons.filter),
                    ),
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        controller.onSortTapped(context, setState);
                      },
                      icon: const Icon(FontAwesomeIcons.arrowDownAZ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  dataRowMinHeight: 68,
                  dataRowMaxHeight: 68,
                  columnSpacing: 20,
                  horizontalMargin: 10,
                  columns: [
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 30,
                          maxWidth: 40,
                        ),
                        child: Text(
                          'STT'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                          maxWidth: 120,
                        ),
                        child: Text(
                          'ID'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 220,
                        ),
                        child: Text(
                          'Tên'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 80,
                          maxWidth: 100,
                        ),
                        child: Text(
                          'Giá nhập'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                          maxWidth: 120,
                        ),
                        child: Text(
                          'Loại hàng'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 70,
                          maxWidth: 80,
                        ),
                        child: Text(
                          'Số lượng'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 160,
                          maxWidth: 160,
                        ),
                        child: Text(
                          'Hành động'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    for (final p in controller.products)
                      DataRow(
                        cells: [
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 30,
                                maxWidth: 40,
                              ),
                              child: Text(
                                '${(controller.page - 1) * controller.perpage + controller.products.indexOf(p) + 1}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 100,
                                maxWidth: 120,
                              ),
                              child: Text(p.sku, textAlign: TextAlign.center),
                            ),
                          ),
                          DataCell(
                            Tooltip(
                              message: p.name,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 220,
                                ),
                                child: Text(
                                  p.name,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 80,
                                maxWidth: 100,
                              ),
                              // TODO: Giá nhập nên hiện theo dạng phân cách hàng ngàn bằng dấu phẩy
                              child: Text(
                                '${p.importPrice}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 100,
                                maxWidth: 120,
                              ),
                              child: Text(
                                controller.categories.fromId(p.categoryId).name,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 60,
                                maxWidth: 80,
                              ),
                              child: Text(
                                '${p.count}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 160,
                                maxWidth: 160,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      controller.infoProduct(
                                        context,
                                        setState,
                                        p,
                                      );
                                    },
                                    icon: const Icon(Icons.info_rounded),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.editProduct(
                                        context,
                                        setState,
                                        p,
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.copyProduct(
                                        context,
                                        setState,
                                        p,
                                      );
                                    },
                                    icon: const Icon(Icons.copy),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.removeProduct(
                                        context,
                                        setState,
                                        p,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: controller.page == 1 || controller.totalPage == 0
                      ? null
                      : () {
                          controller.onPagePrevious(setState);
                        },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
                if (controller.totalPage == 0)
                  const IconButton(
                    onPressed: null,
                    icon: Text('0/0'),
                  )
                else
                  IconButton(
                    onPressed: () {
                      controller.onPageChanged(context, setState);
                    },
                    icon: Text('${controller.page}/${controller.totalPage}'),
                  ),
                IconButton(
                  onPressed: controller.page == controller.totalPage ||
                          controller.totalPage == 0
                      ? null
                      : () {
                          controller.onPageNext(setState);
                        },
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}