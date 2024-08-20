import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/buyer/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/seller/profile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCategoriesView extends StatelessWidget {
  AllCategoriesView({super.key});

  // categories
  final List<String> categories = [
    "Crops",
    "Forestry",
    "Livestock",
    "Dairy",
    "Dry Fruits",
    "Fish Farming",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.getAppBar(
          'Categories',
          [
            // search icon
            SizedBox(
              width: 25,
              child: Image.asset('assets/images/icon@search-active.png'),
            ),
            const SizedBox(
              width: 30,
            ),
          ],
          context),
      body: _getBody(context),
      backgroundColor: Utils.whiteColor,
    );
  }

  _getBody(context) {
    return Column(
        children: categories.map((category) {
      return category == 'Crops'
          ? OptionRow(
              text: category,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StreamProvider.value(
                              value: ProductServices()
                                  .getCategoryProductsStream(category),
                              initialData: null,
                              child: ProductsView(
                                title: '$category Category Items',
                              ),
                            )));
              })
          : OptionRow(
              text: category,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StreamProvider.value(
                              value: ProductServices()
                                  .getCategoryProductsStream(category),
                              initialData: null,
                              child: ProductsView(
                                title: '$category Category Items',
                              ),
                            )));
              },
              noTopDivider: true,
            );
    }).toList());
  }
}
