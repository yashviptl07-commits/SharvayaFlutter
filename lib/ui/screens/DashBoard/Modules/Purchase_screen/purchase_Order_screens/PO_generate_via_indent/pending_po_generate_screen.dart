import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_load_to_indent_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/po_indent_load_to_response.dart';
import 'package:soleoserp/models/common/purchase_order_teble.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class PendingPoForIndentListScreenArguments {
  String StateCode;
  PendingPoForIndentListScreenArguments(this.StateCode);
}

class PendingPoForIndentListScreen extends BaseStatefulWidget {
  static const routeName = '/PendingPoForIndentListScreen';
  final PendingPoForIndentListScreenArguments arguments;

  PendingPoForIndentListScreen(this.arguments);

  @override
  _PendingPoForIndentListScreenState createState() =>
      _PendingPoForIndentListScreenState();
}

class _PendingPoForIndentListScreenState
    extends BaseState<PendingPoForIndentListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  PoFromTheIndentListResponse _listResponse;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int companyID = 0;
  String loginUserID = "";
  bool isProductExist = false;
  DateTime selectedDate = DateTime.now();
  List<PurchaseOrderTable> _inquiryProductList = [];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimaryLight;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    companyID = _offlineCompanyData.details[0].pkId;
    loginUserID = _offlineLoggedInData.details[0].userID;
    _mainBloc = MainBloc(baseBloc);

    print(widget.arguments.StateCode);

    // Fetch initial data
    _mainBloc.add(POFromTheIndentNumberEvent(
      PoFromTheIndentListRequest(
        No: "",
        CompanyId: companyID.toString(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is POFromTheIndentNumberState) {
            _onNoToProductDetails(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is POFromTheIndentNumberState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {},
        listenWhen: (oldState, currentState) => false,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        getCommonAppBar(context, baseTheme, "Pending Indent", showBack: true),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 20,
            ),
            child: Column(
              children: [
                Expanded(child: _buildProductList()),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text(
                      "Load Order",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if (_listResponse != null &&
                          _listResponse.details.isNotEmpty) {
                        // Filter selected items
                        var selectedItems = _listResponse.details
                            .where((item) => item.isChecked == true)
                            .toList();

                        if (selectedItems.isNotEmpty) {
                          // Generate a comma-separated list of "No" values
                          String commaSeparatedNos = selectedItems
                              .map((item) => item.indentNo)
                              .join(',');

                          print("Selected No values: $commaSeparatedNos");

                          // Make the API call with the comma-separated values
                          _mainBloc.add(POFromTheIndentNumberEvent(
                            PoFromTheIndentListRequest(
                              No: commaSeparatedNos,
                              CompanyId: companyID.toString(),
                            ),
                          ));

                          // Optionally, insert data into local storage
                          for (var item in selectedItems) {
                            bool productExists =
                                await checkProductExistence(item.productID);
                            if (!productExists) {
                              double Quantity = item.quantity;
                              double UnitPrice = item.unitRate;
                              double DisPer = item.discountPercent;
                              double DisAmount = item.discountAmt;
                              double NetRate = item.netRate;
                              double Amount = item.amount;
                              double TaxPer = item.taxRate;
                              double TaxAmount = item.taxAmount;
                              int TaxType = item.taxType;
                              double TotalAmount = item.netAmount;
                              double CGSTPer = item.cGSTPer;
                              double SGSTPer = item.sGSTPer;
                              double IGSTPer = item.iGSTPer;
                              double CGSTAmount = item.cGSTAmt;
                              double SGSTAmount = item.sGSTAmt;
                              double IGSTAmount = item.iGSTAmt;
                              double headerDiscountAmt = item.headerDiscAmt;
                              String DocRef = item.indentNo;

                              await OfflineDbHelper.getInstance()
                                  .insertPurchaseOrderProduct(
                                      PurchaseOrderTable(
                                          "",
                                          item.productSpecification,
                                          item.productID,
                                          item.productName,
                                          item.unit,
                                          Quantity,
                                          UnitPrice,
                                          DisPer,
                                          DisAmount,
                                          NetRate,
                                          Amount,
                                          TaxPer,
                                          TaxAmount,
                                          TotalAmount,
                                          TaxType,
                                          CGSTPer,
                                          SGSTPer,
                                          IGSTPer,
                                          CGSTAmount,
                                          SGSTAmount,
                                          IGSTAmount,
                                          int.parse(widget.arguments.StateCode),
                                          0,
                                          loginUserID,
                                          companyID.toString(),
                                          0,
                                          headerDiscountAmt,
                                          selectedDate.year.toString() +
                                              "-" +
                                              selectedDate.month.toString() +
                                              "-" +
                                              selectedDate.day.toString(),
                                          DocRef));
                            }
                          }

                          Navigator.of(context).pop(_inquiryProductList);
                        } else {
                          // Show dialog if no items are selected
                          showCommonDialogWithSingleOption(
                            context,
                            "No items selected!",
                            positiveButtonTitle: "OK",
                          );
                        }
                      } else {
                        // Show dialog if no data is available
                        showCommonDialogWithSingleOption(
                          context,
                          "No data available to load!",
                          positiveButtonTitle: "OK",
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    if (_listResponse == null) {
      return Center(child: Text("No data available"));
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildSearchProductListItem(index);
      },
      shrinkWrap: true,
      itemCount: _listResponse.details.length,
    );
  }

  Widget _buildSearchProductListItem(int index) {
    PoFromTheIndentListResponseDetails model = _listResponse.details[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: CheckboxListTile(
        value: model.isChecked ?? false,
        onChanged: (value) {
          setState(() {
            model.isChecked = value;
          });
        },
        title: Container(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.grey[50],
            elevation: 8,
            shadowColor: Colors.blue[600],
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product Name", style: _labelStyle(14)),
                      Text(
                        model.productName ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: _valueStyle(16),
                      ),
                    ],
                  ),
                  Divider(thickness: 1.0, color: Colors.grey[300]),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("Indent No	: ", model.indentNo, 14, 15),
                        _buildDetailRow("Order No : ", model.orderNo, 14, 15),
                        _buildDetailRow("Indent Qt : ",
                            model.inQty.toString() ?? '', 14, 15),
                        _buildDetailRow("P.O Qty : ",
                            model.usedQty.toString() ?? '', 14, 15),
                        _buildDetailRow("Pending Qty : ",
                            model.quantity.toString() ?? '', 14, 15),
                      ],
                    ),
                  ),
                  Divider(thickness: 1.0, color: Colors.grey[300]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _labelStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  TextStyle _valueStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      color: Colors.black87,
    );
  }

  Widget _buildDetailRow(
      String label, String value, double labelSize, double valueSize) {
    return Row(
      children: [
        Text(label, style: _labelStyle(labelSize)),
        Expanded(child: Text(value, style: _valueStyle(valueSize))),
      ],
    );
  }

  void _onNoToProductDetails(POFromTheIndentNumberState state) {
    _listResponse = state.poFromTheIndentListResponse;
  }

  Future<bool> checkProductExistence(int productID) async {
    List<PurchaseOrderTable> temp =
        await OfflineDbHelper.getInstance().getPurchaseOrderProduct();

    for (var product in temp) {
      if (product.ProductID.toString() == productID.toString()) {
        return true; // Product exists
      }
    }
    return false; // Product does not exist
  }
}
