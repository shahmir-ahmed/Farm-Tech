import 'package:farm_tech/backend/services/product_services.dart';
import 'package:farm_tech/configs/utils.dart';
import 'package:farm_tech/presentation/views/buyer/widgets/widgets.dart';
import 'package:farm_tech/presentation/views/seller/profile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCategoriesView extends StatelessWidget {
  AllCategoriesView({super.key, required this.setOrderTabAsActive});

  // categories
  final List<String> categories = [
    "Crops",
    "Forestry",
    "Livestock",
    "Dairy",
    "Dry Fruits",
    "Fish Farming",
    "Fruits",
    "Vegetables",
  ];

  VoidCallback setOrderTabAsActive;

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
      return OptionRow(
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
                          setOrderTabAsActive: setOrderTabAsActive,
                        ),
                      )));
        },
        // crops category option row with top divider
        // all other categories option rows with no top divider
        noTopDivider: category == 'Crops' ? false : true,
      );
    }).toList());
  }
}
