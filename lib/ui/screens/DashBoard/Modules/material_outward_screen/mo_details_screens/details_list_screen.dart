import 'dart:math';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/MaterialOutwardDetailsTable.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_outward_screen/mo_details_screens/details_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class MaterialOutwardProductListScreenArgument {
  String outWard_No;
  String StateCode;

  MaterialOutwardProductListScreenArgument(this.outWard_No, this.StateCode);
}

class MaterialOutwardProductListScreen extends BaseStatefulWidget {
  static const routeName = '/MaterialOutwardProductListScreen';
  final MaterialOutwardProductListScreenArgument arguments;
  MaterialOutwardProductListScreen(this.arguments);
  @override
  _MaterialOutwardProductListScreenState createState() =>
      _MaterialOutwardProductListScreenState();
}

class _MaterialOutwardProductListScreenState
    extends BaseState<MaterialOutwardProductListScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<MaterialOutwardTable> _productList = [];

  List<MaterialOutwardTable> _TempinquiryProductList = [];

  List<MaterialOutwardTable> AfterDiscountProductList = [];

  TextEditingController edt_NetAmount = TextEditingController();
  TextEditingController edt_BasicAmt = TextEditingController();
  TextEditingController edt_SGSTAmt = TextEditingController();
  TextEditingController edt_CGSTAmt = TextEditingController();
  TextEditingController edt_IGSTAmt = TextEditingController();
  TextEditingController edt_ROffAmt = TextEditingController();
  TextEditingController edt_roundoff = TextEditingController();
  TextEditingController edt_TotalGST = TextEditingController();

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  int _StateCode = 0;
  String OutwardNo = "";
  MaterialOutwardTable qtModel;
  String _HeaderDiscAmnt = "0.00";

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
      print("jbcjebeb" + _StateCode.toString());

      _mainBloc.add(GetMaterialOutwardProductListEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          _mainBloc..add(GetMaterialOutwardProductListEvent()),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is GetMaterialOutwardProductListState) {
            _OnGetMaterialOutwardProductList(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GetMaterialOutwardProductListState) {
            return true;
          }

          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is SBMaterialOutwardOneDeleteState) {
            _onSBOneProductDeleteResponse(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SBMaterialOutwardOneDeleteState) {
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
              navigateTo(context, MaterialOutwardDetailsAddEditScreen.routeName,
                      arguments: MaterialOutwardDetailsAddEditScreenArguments(
                          qtModel, _StateCode, OutwardNo))
                  .then((value) {
                _mainBloc.add(GetMaterialOutwardProductListEvent());
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
    navigateTo(context, MaterialOutwardDetailsAddEditScreen.routeName,
            arguments: MaterialOutwardDetailsAddEditScreenArguments(
                _productList[index], _StateCode, OutwardNo))
        .then((value) {
      _mainBloc.add(GetMaterialOutwardProductListEvent());
    });
  }

  Future<void> _onTapOfDeleteContact(int id, int ItemIndex) async {
    if (ItemIndex != null) {
      _productList.removeAt(ItemIndex);
    }
    _mainBloc.add(MaterialOutwardProductOneDeleteEvent(id));
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    MaterialOutwardTable model = _productList[index];

    return Container(
        padding: EdgeInsets.all(15),
        child: ExpansionTileCard(
          // key:Key(index.toString()),
          initialElevation: 5.0,
          elevation: 5.0,
          elevationCurve: Curves.easeInOut,
          shadowColor: Color(0xFF504F4F),
          baseColor: Color(0xFFFCFCFC),
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
                                  Icons.straighten,
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
                                      Text("Unit",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 12,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.Unit == ""
                                              ? "N/A"
                                              : model.Unit.toString(),
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
                                  Icons.add_shopping_cart,
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
                                  Icons.calendar_today,
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
                                      Text("Date Code	",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 12,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.DateCode == ""
                                              ? "N/A"
                                              : model.DateCode.toString(),
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
                                      Text("Unit Rate ",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 12,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.UnitRate == 0.00
                                              ? "N/A"
                                              : model.UnitRate.toString(),
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
                                  Icons.trending_down,
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
                                      Text("Disc. %",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 12,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.DiscountPercent == 0.00
                                              ? "0.00"
                                              : model.DiscountPercent
                                                  .toString(),
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
                                      Text("Net Rate	",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 12,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.NetRate == 0.00
                                              ? "N/A"
                                              : model.NetRate.toString(),
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
                                      Text("Amount	",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 12,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.Amount == 0.00
                                              ? "N/A"
                                              : model.Amount.toString(),
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
                                  Icons.assignment_turned_in,
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
                                      Text("Tax Rate	",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 10,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.TaxRate == 0.00
                                              ? "0.00"
                                              : model.TaxRate.toString(),
                                          maxLines:
                                              max(0, 100), // Maximum of 2 lines
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: colorBlack,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
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
                                      Text("Tax Amount",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 12,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.TaxAmount == 0.00
                                              ? "0.00"
                                              : model.TaxAmount.toString(),
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
                                      Text("Net Amount",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorBlack,
                                            fontSize: 12,
                                          )),
                                      // Wrap the value text to a new line if it exceeds two lines
                                      Text(
                                          model.NetAmount == 0.00
                                              ? "0.00"
                                              : model.NetAmount.toString(),
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
                      model.OrderNo != ""
                          ? Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.receipt,
                                        color: colorBlack,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        // Use Expanded to allow the text to wrap onto new lines
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Order No",
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  color: colorBlack,
                                                  fontSize: 12,
                                                )),
                                            // Wrap the value text to a new line if it exceeds two lines
                                            Text(model.OrderNo,
                                                maxLines: max(0,
                                                    100), // Maximum of 2 lines
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
                            )
                          : Container(),
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
                          _onTapOfEditContact(index);
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
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to delete this record?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();
                          _onTapOfDeleteContact(model.id, index);
                        });
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
  }

  void _OnGetMaterialOutwardProductList(
      GetMaterialOutwardProductListState state) {
    double totalSumOfNetAmount = 0; // total sum of base rating
    double totalSumOfBasicAmt = 0; // total sum of base rating
    double totalSumOfSGSTAmt = 0; // total sum of base rating
    double totalSumOfCGSTAmt = 0; // total sum of base rating
    double totalSumOfIGSTAmt = 0; // total sum of base rating
    double totalGSTAmount = 0; // total sum of base rating

    if (state.response.length != 0) {
      _productList.clear();
      for (int i = 0; i < state.response.length; i++) {
        totalSumOfNetAmount += state.response[i].NetAmount.toDouble();
        totalSumOfBasicAmt += state.response[i].Amount.toDouble();
        totalSumOfSGSTAmt += state.response[i].SGSTAmt.toDouble();
        totalSumOfCGSTAmt += state.response[i].CGSTAmt.toDouble();
        totalSumOfIGSTAmt += state.response[i].IGSTAmt.toDouble();
        totalGSTAmount += state.response[i].TaxAmount.toDouble();
        _productList.add(state.response[i]);
      }
      print("chjhiducgv" + totalGSTAmount.toString());
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

  void _onSBOneProductDeleteResponse(SBMaterialOutwardOneDeleteState state) {
    _mainBloc.add(GetMaterialOutwardProductListEvent());
  }
}
