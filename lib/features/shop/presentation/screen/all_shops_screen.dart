import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:upgrade_traine_project/features/shop/data/model/response/products_model.dart';
import '../../../../core/common/app_colors.dart';
import '../../../restaurant/presentation/screen/plates_view.dart';
import '../../../restaurant/presentation/widget/dishes_view.dart';
class AllShopScreen extends StatelessWidget {
  const AllShopScreen({Key? key, required this.listPlatesModel})
      : super(key: key);
  final List<Items> listPlatesModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GridView.builder(
        itemCount: listPlatesModel.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          Items platesModel = listPlatesModel[index];
          return DishesView(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: AlertDialogContent(
                        image: platesModel.images!.isEmpty
                            ? "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg"
                            : platesModel.images![0],
                        deliverPrice:
                        "${platesModel.price}",
                        description: platesModel.components
                            .toString(),
                        mainTitle: platesModel.name
                            .toString(),
                        restName: platesModel.shop!.text!,
                        totalPrice: platesModel.price!,
                        weight: platesModel.enComponents
                            .toString(),
                        id: platesModel.id!,
                      ),
                      backgroundColor: AppColors.grey,
                    );
                  },
                );
              },
              restaurantName: platesModel.shop!.text
                  .toString(),
              price: platesModel.price
                  .toString(),
              imagePlate: platesModel.images!.isEmpty
                  ? "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg"
                  : platesModel.images![0],
              plateName: platesModel.name
                  .toString());
        },
      ),
    );
  }
}
