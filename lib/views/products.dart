import 'package:boxw/boxw.dart';
import 'package:flutter/material.dart';
import 'package:language_helper/language_helper.dart';
import 'package:sales/controllers/product_controller.dart';
import 'package:sales/di.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Tìm kiếm'),
              SizedBox(
                width: 100,
                child: BoxWInput(onChanged: (value) {
                  controller.onSeachChanged(setState, value);
                }),
              ),
              // TODO: Hoàn thiện bộ lọc
              Text('Bộ lọc'.tr),
              // TODO: Hoàn thiện sắp xếp
              Text('Sắp xếp'.tr),
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: controller.products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = controller.products[index];
                return ListTile(
                  title: Text('${product.name} - ${product.count}'),
                  onTap: () {
                    // TODO: Hiển thị cụ thể
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text('Trang:'.tr),
              ),
              for (int i = 0; i < controller.totalPage; i++)
                ElevatedButton(onPressed: () {}, child: Text('${i + 1}'))
            ],
          ),
        ],
      ),
    );
  }
}
