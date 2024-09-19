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
          Table(
            children: [
              const TableRow(children: [
                TableCell(
                  child: Text(
                    'STT',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TableCell(
                  child: Text(
                    'ID',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TableCell(
                  child: Text('Tên',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TableCell(
                  child: Text('Giá nhập',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TableCell(
                  child: Text('Loại',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                TableCell(
                  child: Text(
                    'Số lượng',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TableCell(
                  child: Text(
                    'Hành động',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
              for (final p in controller.products)
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(
                        '${controller.products.indexOf(p)}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(p.sku, textAlign: TextAlign.center),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(p.name, textAlign: TextAlign.center),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(
                        '${p.importPrice}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text(
                        controller.categories.fromId(p.categoryId).name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text('${p.count}', textAlign: TextAlign.center),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.editProduct(context, setState, p);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.copyProduct(context, setState, p);
                            },
                            icon: const Icon(Icons.copy),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.removeProduct(context, setState, p);
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
          const Expanded(child: SizedBox()),
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
                  for (int i = 0; i < controller.totalPage; i++)
                    IconButton(
                      onPressed: () {
                        controller.onPageChanged(context, setState);
                      },
                      icon: Text('${i + 1}/${controller.totalPage}'),
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
