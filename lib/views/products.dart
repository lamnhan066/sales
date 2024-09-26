import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/controllers/product_controller.dart';
import 'package:sales/di.dart';
import 'package:sales/models/category.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final controller = getIt<ProductController>();

  @override
  void initState() {
    controller.initial(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm'.tr),
      ),
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
                        textAlign: TextAlign.left,
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
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: DataTable(
                  dataRowMinHeight: 68,
                  dataRowMaxHeight: 68,
                  columns: [
                    const DataColumn(
                      label: Text(
                        'STT',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'ID',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 220),
                        child: const Text(
                          'Tên',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text('Giá nhập',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const DataColumn(
                      label: Text('Loại',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const DataColumn(
                      label: Text(
                        'Số lượng',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Hành động',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: [
                    for (final p in controller.products)
                      DataRow(
                        cells: [
                          DataCell(
                            Text(
                              '${(controller.page - 1) * controller.perpage + controller.products.indexOf(p) + 1}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            Text(p.sku, textAlign: TextAlign.center),
                          ),
                          DataCell(
                            Tooltip(
                              message: p.name,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(minWidth: 220),
                                child: Text(
                                  p.name,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${p.importPrice}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 70),
                              child: Text(
                                controller.categories.fromId(p.categoryId).name,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataCell(
                            Text('${p.count}', textAlign: TextAlign.center),
                          ),
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.infoProduct(
                                        context, setState, p);
                                  },
                                  icon: const Icon(Icons.info_rounded),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.editProduct(
                                        context, setState, p);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.copyProduct(
                                        context, setState, p);
                                  },
                                  icon: const Icon(Icons.copy),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.removeProduct(
                                        context, setState, p);
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
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
