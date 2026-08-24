import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/Material_Inward_Product_table.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Material_Inward/Material_Inward/Material_Inward_Detail_Screen/test_add_edit_inward.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class MaterialInwardProductListScreenArgument {
  String outWard_No;
  String StateCode;
  String LocationID;
  String CustomerID;

  MaterialInwardProductListScreenArgument(
      this.outWard_No, this.StateCode, this.LocationID, this.CustomerID);
}

  class MaterialInwardProductListScreen extends BaseStatefulWidget {
  static const routeName = '/MaterialInwardProductListScreen';
  final MaterialInwardProductListScreenArgument arguments;
  MaterialInwardProductListScreen(this.arguments);
  @override
  _MaterialInwardProductListScreenState createState() =>
      _MaterialInwardProductListScreenState();
}

class _MaterialInwardProductListScreenState
    extends BaseState<MaterialInwardProductListScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<MaterialInwardTable> _productList = [];
  List<MaterialInwardTable> AfterDiscountProductList = [];
  TextEditingController edt_NetAmount = TextEditingController();
  TextEditingController edt_BasicAmt = TextEditingController();
  TextEditingController edt_SGSTAmt = TextEditingController();
  TextEditingController edt_CGSTAmt = TextEditingController();
  TextEditingController edt_IGSTAmt = TextEditingController();
  TextEditingController edt_ROffAmt = TextEditingController();
  TextEditingController edt_roundoff = TextEditingController();
  TextEditingController edt_TotalGST = TextEditingController();
  double sizeboxsize = 12;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  int _StateCode = 0;
  String OutwardNo = "";
  MaterialInwardTable qtModel;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  String LoginUserID;
  String CompanyID;
  MainBloc _mainBloc;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    _mainBloc = MainBloc(baseBloc);

    if (widget.arguments != null) {
      OutwardNo = widget.arguments.outWard_No;
      _StateCode = int.parse(widget.arguments.StateCode);
      _mainBloc.add(MaterialInwardDetailsListEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          _mainBloc..add(MaterialInwardDetailsListEvent()),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is MaterialInwardDetailsListState) {
            _OnGetMaterialOutwardProductList(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MaterialInwardDetailsListState) {
            return true;
          }

          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is MaterialInwardDetailsOneDeleteState) {
            _onSBOneProductDeleteResponse(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MaterialInwardDetailsOneDeleteState) {
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
        title: Text("Product Details"),
      ),
      body: _buildContactsListView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "btn1",
            onPressed: () {
              /* edt_FollowupEmployeeList.text = "";
                _onTapOfSearchView();*/
              return showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.white,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Wrap(
                      children: [
                        ListTile(
                          // leading: Icon(Icons.share),
                          title: Center(
                            child: Text(
                              "~~~Filter~~~",
                              style: TextStyle(color: colorPrimary),
                            ),
                          ),
                        ),
                        Container(
                          height: 2,
                          color: colorLightGray,
                        ),
                        Container(
                          height: 5,
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text("Basic Amount	",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: colorBlack,
                                              fontWeight: FontWeight
                                                  .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Card(
                                      elevation: 5,
                                      color: colorLightGray,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Container(
                                        height: 45,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        width: double.maxFinite,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  enabled: false,
                                                  controller: edt_BasicAmt,
                                                  decoration: InputDecoration(
                                                    hintText: "0.00",
                                                    labelStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFF000000),
                                                  ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text("Total Gst",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: colorBlack,
                                              fontWeight: FontWeight
                                                  .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Card(
                                      elevation: 5,
                                      color: colorLightGray,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Container(
                                        height: 45,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        width: double.maxFinite,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  enabled: false,
                                                  controller: edt_TotalGST,
                                                  decoration: InputDecoration(
                                                    hintText: "0.00",
                                                    labelStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFF000000),
                                                  ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text("Round Off",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: colorBlack,
                                              fontWeight: FontWeight
                                                  .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Card(
                                      elevation: 5,
                                      color: colorLightGray,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Container(
                                        height: 45,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        width: double.maxFinite,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  enabled: false,
                                                  controller: edt_roundoff,
                                                  decoration: InputDecoration(
                                                    hintText: "0.00",
                                                    labelStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFF000000),
                                                  ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text("Net Amount	",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: colorBlack,
                                              fontWeight: FontWeight
                                                  .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Card(
                                      elevation: 5,
                                      color: colorLightGray,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Container(
                                        height: 45,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        width: double.maxFinite,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  enabled: false,
                                                  controller: edt_NetAmount,
                                                  decoration: InputDecoration(
                                                    hintText: "0.00",
                                                    labelStyle: TextStyle(
                                                      color: Color(0xFF000000),
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFF000000),
                                                  ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Close")),
                        ),
                        Container(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            label: Image.asset(
              CUSTOM_SETTING,
              color: Colors.white,
              height: 32,
              width: 32,
            ),
            backgroundColor: colorPrimary,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
            onPressed: () async {
              navigateTo(context, MaterialInwardDetailsAddEditScreen.routeName,
                      arguments: MaterialInwardDetailsAddEditScreenArguments(
                          qtModel,
                          _StateCode,
                          OutwardNo,
                          widget.arguments.LocationID,
                          widget.arguments.CustomerID))
                  .then((value) {
                _mainBloc.add(MaterialInwardDetailsListEvent());
              });
            },
            label: Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            ),
            backgroundColor: colorPrimary,
          )
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
        child: Lottie.asset(NO_DATA_ANIMATED
            /*height: 200,
              width: 200*/
            ),
      );
    }
  }

  Future<void> _onTapOfEditContact(int index) async {
    navigateTo(context, MaterialInwardDetailsAddEditScreen.routeName,
            arguments: MaterialInwardDetailsAddEditScreenArguments(
                _productList[index],
                _StateCode,
                OutwardNo,
                widget.arguments.LocationID,
                widget.arguments.CustomerID))
        .then((value) {
      _mainBloc.add(MaterialInwardDetailsListEvent());
    });
  }

  Future<void> _onTapOfDeleteContact(int id, int ItemIndex) async {
    if (ItemIndex != null) {
      _productList.removeAt(ItemIndex);
    }
    _mainBloc.add(MaterialInwardDetailsDeleteEvent(id));
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  TextStyle _valueStyle(double fontSize) => TextStyle(
        color: Colors.black87,
        fontSize: fontSize,
      );

// Helper styles for labels and titles
  TextStyle _labelStyle(double fontSize) => TextStyle(
        color: Colors.blueAccent,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      );

  ExpantionCustomer(BuildContext context, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.04;
    double fontSizeTitle = screenWidth * 0.045;
    double fontSizeLabel = screenWidth * 0.037;
    double fontSize = screenWidth * 0.04; // Consistent font size for all texts
    MaterialInwardTable model = _productList[index];

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      //padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[50],
        elevation: 8,
        shadowColor: Colors.blue[600],
        child: Padding(
          padding: EdgeInsets.only(left: padding, right: padding, top: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Product Name", style: _labelStyle(fontSize)),
                  Text(
                    model.ProductName,
                    overflow: TextOverflow.ellipsis,
                    style: _valueStyle(fontSize),
                  ),
                ],
              ),
              Divider(thickness: 1.0, color: Colors.grey[300]),
              Padding(
                padding: EdgeInsets.only(top: padding / 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      "Quantity : ",
                      model.SampleQuantity.toString(),
                      fontSizeLabel,
                      fontSizeLabel * 1.1,
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Adjust spacing
                      children: [
                        Expanded(
                          flex: 1, // Adjust as needed for equal spacing
                          child: _buildDetailRow(
                            "Con Quantity : ",
                            model.Quantity.toString(),
                            fontSizeLabel,
                            fontSizeLabel * 1.1,
                          ),
                        ),
                        Expanded(
                          flex: 1, // Adjust as needed for equal spacing
                          child: _buildDetailRow(
                            "Unit : ",
                            model.Unit,
                            fontSizeLabel,
                            fontSizeLabel * 1.1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Adjust spacing
                      children: [
                        Expanded(
                          flex: 1, // Adjust as needed for equal spacing
                          child: _buildDetailRow(
                            "Unit Rate  : ",
                            model.UnitRate.toString(),
                            fontSizeLabel,
                            fontSizeLabel * 1.1,
                          ),
                        ),
                        Expanded(
                          flex: 1, // Adjust as needed for equal spacing
                          child: _buildDetailRow(
                            "Date Code	: ",
                            model.DateCode,
                            fontSizeLabel,
                            fontSizeLabel * 1.1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Adjust spacing
                      children: [
                        Expanded(
                          flex: 1, // Adjust as needed for equal spacing
                          child: _buildDetailRow(
                            "Disc. % : ",
                            model.DiscountPercent.toString(),
                            fontSizeLabel,
                            fontSizeLabel * 1.1,
                          ),
                        ),
                        Expanded(
                          flex: 1, // Adjust as needed for equal spacing
                          child: _buildDetailRow(
                            "Net Rate : ",
                            model.NetRate.toString(),
                            fontSizeLabel,
                            fontSizeLabel * 1.1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Adjust spacing
                      children: [
                        Expanded(
                          flex: 1, // Adjust as needed for equal spacing
                          child: _buildDetailRow(
                            "Amount : ",
                            model.Amount.toString(),
                            fontSizeLabel,
                            fontSizeLabel * 1.1,
                          ),
                        ),
                        Expanded(
                          flex: 1, // Adjust as needed for equal spacing
                          child: _buildDetailRow(
                            "Tax Rate : ",
                            model.TaxRate,
                            fontSizeLabel,
                            fontSizeLabel * 1.1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Adjust spacing
                      children: [
                        Expanded(
                          flex: 1, // Adjust as needed for equal spacing
                          child: _buildDetailRow(
                            "Tax Amount : ",
                            model.TaxAmount.toString(),
                            fontSizeLabel,
                            fontSizeLabel * 1.1,
                          ),
                        ),
                        Expanded(
                          flex: 1, // Adjust as needed for equal spacing
                          child: _buildDetailRow(
                            "Net Amount : ",
                            model.NetAmount,
                            fontSizeLabel,
                            fontSizeLabel * 1.1,
                          ),
                        ),
                      ],
                    ),
                    model.OrderNo != ""
                        ? _buildDetailRow(
                            "Order No : ",
                            model.OrderNo.toString(),
                            fontSizeLabel,
                            fontSizeLabel * 1.1,
                          )
                        : Container(),
                  ],
                ),
              ),
              Divider(thickness: 1.0, color: Colors.grey[300]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        _onTapOfEditContact(index);
                      },
                      icon: Icon(Icons.edit, color: colorPrimary, size: 30)),
                  IconButton(
                      onPressed: () {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to delete this record?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();
                          _onTapOfDeleteContact(model.id, index);
                        });
                      },
                      icon: Icon(Icons.delete, color: colorPrimary, size: 30))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, double labelFontSize, double valueFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle(labelFontSize)),
          Expanded(
            child: Text(value,
                style:
                    TextStyle(color: Colors.black87, fontSize: valueFontSize)),
          ),
        ],
      ),
    );
  }

  void _OnGetMaterialOutwardProductList(MaterialInwardDetailsListState state) {
    double totalSumOfNetAmount = 0; // total sum of base rating
    double totalSumOfBasicAmt = 0; // total sum of base rating
    double totalSumOfSGSTAmt = 0; // total sum of base rating
    double totalSumOfCGSTAmt = 0; // total sum of base rating
    double totalSumOfIGSTAmt = 0; // total sum of base rating
    double totalGSTAmount = 0; // total sum of base rating

    if (state.response.length != 0) {
      _productList.clear();
      for (int i = 0; i < state.response.length; i++) {
        totalSumOfNetAmount += double.parse(state.response[i].NetAmount);
        totalSumOfBasicAmt += double.parse(state.response[i].Amount);
        totalSumOfSGSTAmt += double.parse(state.response[i].SGSTAmt);
        totalSumOfCGSTAmt += double.parse(state.response[i].CGSTAmt);
        totalSumOfIGSTAmt += double.parse(state.response[i].IGSTAmt);
        totalGSTAmount += double.parse(state.response[i].TaxAmount);
        _productList.add(state.response[i]);
      }
      print("chjhiducgv" + totalSumOfBasicAmt.toString());
    }

    edt_NetAmount.text = totalSumOfNetAmount.toString();
    edt_BasicAmt.text = totalSumOfBasicAmt.toString();
    edt_SGSTAmt.text = totalSumOfSGSTAmt.toString();
    edt_CGSTAmt.text = totalSumOfCGSTAmt.toString();
    edt_IGSTAmt.text = totalSumOfIGSTAmt.toString();

    // Calculate round off value
    double roundOffValue = totalSumOfNetAmount.round() - totalSumOfNetAmount;
    edt_roundoff.text =
        roundOffValue.toStringAsFixed(2); // Round off to 2 decimal places

    edt_TotalGST.text = totalGSTAmount.toString();
  }

  void _onSBOneProductDeleteResponse(
      MaterialInwardDetailsOneDeleteState state) {
    _mainBloc.add(MaterialInwardDetailsListEvent());
  }
}
