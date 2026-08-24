import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/blocs/other/bloc_modules/salesorder/salesorder_bloc.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/Short_Invoice_Table.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/short_invoice/short_invoice_manan_design/products/short_invoice_product_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/calculation/short_invoice/short_invoice_calculation.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class ShortInvoiceProductListArgument {
  String quotation_No;
  String stateCode;
  String HeaderDiscAmnt;

  ShortInvoiceProductListArgument(
      this.quotation_No, this.stateCode, this.HeaderDiscAmnt);
}

class ShortInvoiceProductListScreen extends BaseStatefulWidget {
  static const routeName = '/ShortInvoiceProductListScreen';
  final ShortInvoiceProductListArgument arguments;
  ShortInvoiceProductListScreen(this.arguments);
  @override
  _ShortInvoiceProductListScreenState createState() =>
      _ShortInvoiceProductListScreenState();
}

class _ShortInvoiceProductListScreenState
    extends BaseState<ShortInvoiceProductListScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<ShortInvoiceTable> _productList = [];
  List<ShortInvoiceTable> AfterDiscountProductList = [];
  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  int _StateCode = 0;
  String QuotationNo = "";
  ShortInvoiceTable qtModel;
  String _HeaderDiscAmnt = "0.00";
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  String LoginUserID;
  String CompanyID;
  MainBloc _mainBloc;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    _mainBloc = MainBloc(baseBloc);

    if (widget.arguments != null) {
      print("GetINQNOFRomList" + widget.arguments.quotation_No);
      QuotationNo = widget.arguments.quotation_No;
      print(widget.arguments.stateCode);

      _StateCode = int.parse(widget.arguments.stateCode);
      _HeaderDiscAmnt = widget.arguments.HeaderDiscAmnt;

      _mainBloc.add(GetSIProductListEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc..add(GetSIProductListEvent()),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is GetSIProductListState) {
            _OnGetSIProductList(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GetSIProductListState) {
            return true;
          }

          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is SIProductOneDeleteState) {
            _onOneProductDeleteResponse(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SIProductOneDeleteState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: Text("Product List"),
      ),
      body: _buildContactsListView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: colorPrimary,
            onPressed: () async {
              await navigateTo(context, ShortInvoiceAddEditScreen.routeName,
                      arguments: ShortInvoiceAddEditScreenArguments(
                          qtModel, _StateCode, _HeaderDiscAmnt, QuotationNo))
                  .then((value) {
                List<ShortInvoiceTable> temp_productList = value;

                for (int i = 0; i < temp_productList.length; i++) {
                  print("tableID" + " ID " + temp_productList[i].id.toString());
                }

                _mainBloc.add(GetSIProductListEvent());
              });
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsListView() {
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
        child: Lottie.asset(NO_DATA_ANIMATED),
      );
    }
  }

  Future<void> getProduct() async {
    _productList.clear();
    _productList
        .addAll(await OfflineDbHelper.getInstance().getShortInvoiceList());

    double hiderdiscount = double.parse(
        _HeaderDiscAmnt.toString() == null || _HeaderDiscAmnt.toString() == ""
            ? 0.00
            : _HeaderDiscAmnt.toString());
    String CompanyStateCode =
        _offlineLoggedInData.details[0].stateCode.toString();
    String CustomerStateID = _productList[0].StateCode.toString();

    List<ShortInvoiceTable> TempproductList1 =
        ShortInvoiceHeaderDiscountCalculation.txtHeadDiscount_WithZero(
            _productList, hiderdiscount, CompanyStateCode, CustomerStateID);

    List<ShortInvoiceTable> TempproductList =
        ShortInvoiceHeaderDiscountCalculation.txtHeadDiscount_TextChanged(
            TempproductList1, hiderdiscount, CompanyStateCode, CustomerStateID);

    _productList.clear();
    _productList.addAll(TempproductList);

    setState(() {});
  }

  Future<void> _onTapOfEditContact(int index) async {
    print("fjdj" + QuotationNo);

    navigateTo(context, ShortInvoiceAddEditScreen.routeName,
            arguments: ShortInvoiceAddEditScreenArguments(
                _productList[index], _StateCode, _HeaderDiscAmnt, QuotationNo))
        .then((value) {
      _mainBloc.add(GetSIProductListEvent());
    });
  }

  _onTapOfDeleteContact(int id, int ItemIndex) {
    if (ItemIndex != null) {
      _productList.removeAt(ItemIndex);
    }
    _mainBloc.add(SIProductOneDeleteEvent(id));
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  Widget ExpantionCustomer(BuildContext context, int index) {
    ShortInvoiceTable model = _productList[index];

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ExpansionTileCard(
        initialElevation: 4,
        elevation: 4,
        baseColor: Colors.white,
        expandedColor: Color(0xFFE3F2FD),
        shadowColor: Colors.grey.shade400,
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          child: Image.asset(PRODUCT_ICON, height: 40),
        ),
        title: Text(
          model.ProductName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          Divider(height: 1, color: Colors.grey.shade400),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildDetailRow("Unit", model.Unit),
                _buildDetailRow("Quantity", model.Qty.toString()),
                _buildDetailRow("Unit Rate", model.Rate.toStringAsFixed(2)),
                _buildDetailRow(
                    "Discount (%)", model.DiscountPer.toStringAsFixed(2)),
                _buildDetailRow("Net Rate", model.NetRate.toStringAsFixed(2)),
                _buildDetailRow("Amount", model.Amount.toStringAsFixed(2)),
                _buildDetailRow("Tax (%)", model.AddTaxPer.toStringAsFixed(2)),
                _buildDetailRow(
                    "Tax Amount", model.AddTaxAmt.toStringAsFixed(2)),
                _buildDetailRow("Net Amount", model.NetAmt.toStringAsFixed(2),
                    isBold: true),
                _buildDetailRow("Specification", model.ProductSpecification),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                  Icons.edit, "Edit", () => _onTapOfEditContact(index)),
              _buildActionButton(Icons.delete, "Delete",
                  () => _mainBloc.add(SIProductOneDeleteEvent(model.id))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? "N/A" : value,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  void _OnGetSIProductList(GetSIProductListState state) {
    if (state.response.length != 0) {
      String CustomerStateID = state.response[0].StateCode.toString();
      _productList.clear();
      for (int i = 0; i < state.response.length; i++) {
        _productList.add(state.response[i]);
      }

      double HeaderDisAmnt =
          _HeaderDiscAmnt.isNotEmpty ? double.parse(_HeaderDiscAmnt) : 0.00;
      String CompanyStateCode =
          _offlineLoggedInData.details[0].stateCode.toString();

      List<ShortInvoiceTable> TempproductList1 =
          ShortInvoiceHeaderDiscountCalculation.txtHeadDiscount_WithZero(
              _productList, HeaderDisAmnt, CompanyStateCode, CustomerStateID);

      List<ShortInvoiceTable> TempproductList =
          ShortInvoiceHeaderDiscountCalculation.txtHeadDiscount_TextChanged(
              TempproductList1,
              HeaderDisAmnt,
              CompanyStateCode,
              CustomerStateID);

      _productList.clear();
      for (int i = 0; i < TempproductList.length; i++) {
        _productList.add(TempproductList[i]);
      }
    }
  }

  void _onOneProductDeleteResponse(SIProductOneDeleteState state) {
    _mainBloc.add(GetSIProductListEvent());
  }
}
