import 'dart:math';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:soleoserp/models/common/Maintenance_product_model.dart';
import 'package:soleoserp/models/common/inquiry_product_model.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/add_inquiry_product_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/maintenance/maintenance_add_update/maintenance_product_add_update.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/ui/widgets/new_common_widget.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';

class MaintenanceProductListScreenArgument {
  String inquiry_No;
  String StartDate;
  String EndDate;

  MaintenanceProductListScreenArgument(this.inquiry_No,this.StartDate,this.EndDate);
}

class MaintenanceProductListScreen extends BaseStatefulWidget {
  static const routeName = '/MaintenanceProductListScreen';
  final MaintenanceProductListScreenArgument arguments;
  MaintenanceProductListScreen(this.arguments);
  @override
  _MaintenanceProductListScreenState createState() =>
      _MaintenanceProductListScreenState();
}

class _MaintenanceProductListScreenState extends BaseState<MaintenanceProductListScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<MaintenanceProductModel> _productList = [];
  double sizeboxsize = 12;
  MaintenanceProductModel qtModel;
  int selected = 0;

  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    if (widget.arguments != null) {}
    getProduct();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      color: colorWhite,
      child: Column(
        children: [
          getCommonAppBar(context, baseTheme, "Product Details", showBack: true),
          Expanded(
            child: Stack(
              children: [
                _buildContactsListView(),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.bottomRight,
                  child:
                  FloatingActionButton(
                    backgroundColor: colorPrimary,
                    onPressed: () async {
                      await
                      navigateTo(context, MaintenanceProductAddEditScreen.routeName,
                          arguments: MaintenanceProductAddEditScreenArguments(
                              qtModel,
                              widget.arguments.inquiry_No,
                              widget.arguments.StartDate,
                              widget.arguments.EndDate
                          ))
                          .then((value) {
                        getProduct();
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _buildContactsListView() {
    if (_productList.length != 0) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _buildInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _productList.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_DATA_ANIMATED
          *//*height: 200,
              width: 200*//*
        ),
      );
    }
  }*/


  Future<void> getProduct() async {
    _productList.clear();
    _productList
        .addAll(await OfflineDbHelper.getInstance().getMaintenanceProduct());
    setState(() {});
  }

  Future<void> _onTapOfEditContact(int index) async {
    await navigateTo(context, MaintenanceProductAddEditScreen.routeName,
        arguments: MaintenanceProductAddEditScreenArguments(
            _productList[index],
            widget.arguments.inquiry_No,
            widget.arguments.StartDate,
            widget.arguments.EndDate
        ));

    getProduct(); //right now calling again get contacts, later it can be optimized
  }

  Future<void> _onTapOfDeleteContact(int index) async {
    await OfflineDbHelper.getInstance()
        .deleteInquiryProduct(_productList[index].id);
    setState(() {
      _productList.removeAt(index);
    });
  }

 /* Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }*/

  Widget _buildContactsListView() {
    if (_productList == null) {
      return Container();
    }

    return ListView.builder(
      key: Key('selected $selected'),
      itemBuilder: (context, index) {
        MaintenanceProductModel model = _productList[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Visit ID and Complaint No
                MultipleList(
                  label: "Product Name",
                  value: model.ProductName,
                  icon: Icon(Icons.production_quantity_limits, color: Colors.blueAccent),
                  label1: "Quantity",
                  value1: model.Quantity.toString(),
                  icon1: Icon(Icons.attach_money, color: Colors.blueAccent),
                ),
                SizedBox(height: 15),
                MultipleList(
                  label: "Unit Price",
                  value: model.UnitPrice.toString(),
                  icon: Icon(Icons.attach_money, color: Colors.blueAccent),
                  label1: "Total Amount",
                  value1: model.TotalAmount.toString(),
                  icon1: Icon(Icons.attach_money, color: Colors.blueAccent),
                ),
                SizedBox(height: 10),
                // Edit and Delete Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _onTapOfEditContact(index);
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text("Edit"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent,
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to delete this record?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                              Navigator.of(context).pop();
                              _onTapOfDeleteContact(model.id);
                            });
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      shrinkWrap: true,
      itemCount: _productList.length,
    );
  }

/*  ExpantionCustomer(BuildContext context, int index) {
    MaintenanceProductModel model = _productList[index];

    return Container(
        padding: EdgeInsets.all(15),
        child: ExpansionTileCard(
          // key:Key(index.toString()),
          initialElevation: 5.0,
          elevation: 5.0,
          elevationCurve: Curves.easeInOut,
          shadowColor: Color(0xFF504F4F),
          baseColor: Colors.grey[200],
          expandedColor: Colors.grey.shade200,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(
                  Icons.production_quantity_limits,
                  color: colorBlack,
                  size: 30,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product Name",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: colorBlack,
                            fontSize: 15,
                          )),
                      // Wrap the value text to a new line if it exceeds two lines
                      Text(model.ProductName,
                          maxLines: max(0, 100), // Maximum of 2 lines
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: colorBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
              color: colorBlack,
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: colorBlack,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  // Use Expanded to allow the text to wrap onto new lines
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("Quantity",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 12,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.Quantity == 0.00
                                              ? "N/A"
                                              : model.Quantity.toString(),
                                          maxLines:
                                          max(0, 100), // Maximum of 2 lines
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: colorBlack,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: colorBlack,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  // Use Expanded to allow the text to wrap onto new lines
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("Unit Price",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 12,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.UnitPrice == 0.00
                                              ? "0.00"
                                              : model.UnitPrice.toString(),
                                          maxLines:
                                          max(0, 100), // Maximum of 2 lines
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: colorBlack,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: colorBlack,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  // Use Expanded to allow the text to wrap onto new lines
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("Total Amount",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 12,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.TotalAmount == 0.00
                                              ? "0.00"
                                              : model.TotalAmount.toString(),
                                          maxLines:
                                          max(0, 100), // Maximum of 2 lines
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: colorBlack,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )),
            Divider(
              thickness: 1.0,
              height: 1.0,
              color: colorBlack,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
                    height: 45,
                    margin: EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        onPressed: () {

                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.edit,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Update',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: colorWhite),
                            ),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Container(
                    height: 45,
                    margin: EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      onPressed: () {

                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.delete,
                            size: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Delete',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: colorWhite),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            )
          ],
        ));
  }*/

}
