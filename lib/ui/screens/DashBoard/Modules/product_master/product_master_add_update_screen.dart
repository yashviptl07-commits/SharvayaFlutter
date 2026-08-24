import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/product_master/product_master_bloc.dart';
import 'package:soleoserp/models/api_requests/product/product_add_update_screen.dart';
import 'package:soleoserp/models/api_requests/product/product_brand_list_request.dart';
import 'package:soleoserp/models/api_requests/product/product_group_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/product_master/product_master_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/product_master/product_master_list_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class ProductMasterAddEditArguments {
  ProductMasterResponseDetails editModel;
  ProductMasterAddEditArguments(this.editModel);
}

class ProductMasterAddEdit extends BaseStatefulWidget {
  static const routeName = '/ProductMasterAddEdit';
  final ProductMasterAddEditArguments arguments;

  ProductMasterAddEdit(this.arguments);

  @override
  _ProductMasterAddEditScreenState createState() =>
      _ProductMasterAddEditScreenState();
}

class _ProductMasterAddEditScreenState extends BaseState<ProductMasterAddEdit>
    with BasicScreen, WidgetsBindingObserver {
  ManagePurchaseBloc _mainBloc;
  Function refreshList;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  double CardViewHieght = 50;
  bool _isSwitched;
  bool _isForUpdate;
  FocusNode PicCodeFocus;
  SearchDetails _searchDetails;
  FocusNode myFocusNode;
  int pkID = 0;
  int CustomerId = 0;
  String InquiryNo = "";
  ProductMasterResponseDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isCompare;

  /// For New
  final TextEditingController edt_ProductName = TextEditingController();
  final TextEditingController edt_ProductSpec = TextEditingController();
  final TextEditingController edt_ProductAlias = TextEditingController();
  final TextEditingController edt_HSNCode = TextEditingController();
  final TextEditingController edt_ProductUnit = TextEditingController();
  final TextEditingController edt_ProductPrice = TextEditingController();
  final TextEditingController edt_GSTTextPer = TextEditingController();
  final TextEditingController edt_GSTTax = TextEditingController();
  final TextEditingController edt_TypeOfProduct = TextEditingController();
  final TextEditingController edt_Brand = TextEditingController();
  final TextEditingController edt_BrandId = TextEditingController();
  final TextEditingController edt_ProductCategory = TextEditingController();
  final TextEditingController edt_ProductCategoryId = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_TypeOfProduct = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_GSTTax = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Brand = [];
  List<ALL_Name_ID> arr_ProductGruopList = [];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _mainBloc = ManagePurchaseBloc(baseBloc);
    myFocusNode = FocusNode();
    PicCodeFocus = FocusNode();
    isCompare = false;
    TypeOfProductStatus();
    GSTTaxStatus();

    edt_TypeOfProduct.text = "General";
    edt_GSTTax.text = "Exclusive";

    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    PicCodeFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<ManagePurchaseBloc, ProductMasterState>(
        builder: (BuildContext context, ProductMasterState state) {
          /*if (state is ProductMasterResponseState) {
            _OnProductListResponse(state);
          }*/
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          /*if (currentState is ProductMasterResponseState) {
            return true;
          }*/
          return false;
        },
        listener: (BuildContext context, ProductMasterState state) {
          if (state is ProductBrandResponseState) {
            _onBrandListResponse(state);
          }
          if (state is ProductGroupDropDownResponseState) {
            _onProductGroupDropDownAPIResponse(state);
          }
          if (state is ProductAddUpdateResponseState) {
            _onBankVoucherSaveResponse(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ProductBrandResponseState) {
            return true;
          }
          if (currentState is ProductGroupDropDownResponseState) {
            return true;
          }
          if (currentState is ProductAddUpdateResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: NewGradientAppBar(
          title: Text('Product ${_isForUpdate == true ? "Update" : "Add"}'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: InkWell(
              onTap: () async {
                navigateTo(context, ProductMasterListScreen.routeName);
              },
              child: Icon(Icons.arrow_back_outlined)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, ProductMasterListScreen.routeName,
                      clearAllStack: true);
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 10,
                ),
                child: Column(
                  children: [
                    ProductName(),
                    SizedBox(height: 10),
                    SwitchNoFollowup(),
                    SizedBox(height: 10),
                    ProductAlias(),
                    SizedBox(height: 10),
                    showcustomdialogWithID1("Product Brand",
                        enable1: false,
                        title: "Product Brand",
                        hintTextvalue: "--- Select Brand ---",
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: colorPrimary,
                        ),
                        controllerForLeft: edt_Brand,
                        controllerpkID: edt_BrandId,
                        Custom_values1: arr_ALL_Name_ID_For_Brand),
                    SizedBox(height: 10),
                    TypeOfProduct(),
                    SizedBox(height: 10),
                    _buildProductGroupListView(),
                    SizedBox(height: 10),
                    HSNCode(),
                    SizedBox(height: 10),
                    ProductUnit(),
                    SizedBox(height: 10),
                    ProductPrice(),
                    SizedBox(height: 10),
                    GSTTaxPer(),
                    SizedBox(height: 10),
                    GSTTax(),
                    SizedBox(height: 10),
                    ProductSpecificationm(),
                    SizedBox(height: 30),
                    Container(
                      height: 50,
                      width: 140,
                      child: ElevatedButton(
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          _onTapOfSaveVehiclePunchAPICall();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 10),
                    // _buildSearchView(),
                    //Expanded(child: Container())
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ProductName() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Product Name *",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10),
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_ProductName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter ProductName",
                            /*contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),*/
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
            )
          ],
        ),
      ],
    ));
  }

  Widget ProductSpecificationm() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Short Discription",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10),
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 125,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_ProductSpec,
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter Product Spec",
                            contentPadding: EdgeInsets.only(
                                left: 7, top: 15, bottom: 10, right: 7),
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
            )
          ],
        ),
      ],
    ));
  }

  Widget SwitchNoFollowup() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Active Status",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(children: [
              Container(
                child: Text("InActive",
                    style: TextStyle(
                        fontSize: 12,
                        color: colorGrayDark,
                        fontWeight: FontWeight.w100)),
              ),
              Container(
                child: Container(
                  child: Switch(
                    value: _isSwitched,
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                    onChanged: (value) {
                      print("_isSwitchedVALUE : $value");
                      setState(() {
                        _isSwitched = value;
                      });
                    },
                  ),
                ),
              ),
              Container(
                child: Text("Active",
                    style: TextStyle(
                        fontSize: 12,
                        color: colorGrayDark,
                        fontWeight: FontWeight.w100)),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget ProductAlias() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Product Alias *",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10),
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_ProductAlias,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter ProductAlias",
                            /*contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),*/
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
            )
          ],
        ),
      ],
    ));
  }

  Widget HSNCode() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("HSN Code",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10),
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_HSNCode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter HSN Code",
                            /*contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),*/
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
            )
          ],
        ),
      ],
    ));
  }

  Widget ProductUnit() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Product Unit",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10),
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_ProductUnit,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter Product Unit",
                            /*contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),*/
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
            )
          ],
        ),
      ],
    ));
  }

  Widget ProductPrice() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Product Price *",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10),
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_ProductPrice,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter Product Price",
                            /*contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),*/
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
            )
          ],
        ),
      ],
    ));
  }

  Widget GSTTaxPer() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("GST Tax %",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10),
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_GSTTextPer,
                          textInputAction: TextInputAction.next,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "0.00",
                            /*contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),*/
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
            )
          ],
        ),
      ],
    ));
  }

  Widget TypeOfProduct() {
    return InkWell(
      onTap: () {
        showcustomdialogWithOnlyName(
            values: arr_ALL_Name_ID_For_TypeOfProduct,
            context1: context,
            controller: edt_TypeOfProduct,
            lable: "Loading Type");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Flexible(
                  child: Text("Type Of Product",
                      style: TextStyle(
                          fontSize: 12,
                          color: colorPrimary,
                          fontWeight: FontWeight
                              .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: false,
                        // focusNode: PicCodeFocus,
                        controller: edt_TypeOfProduct,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "---Select---",
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
                  Icon(
                    Icons.arrow_drop_down,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  TypeOfProductStatus() {
    arr_ALL_Name_ID_For_TypeOfProduct.clear();
    for (var i = 0; i < 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "General";
      } else if (i == 1) {
        all_name_id.Name = "Finished";
      } else if (i == 2) {
        all_name_id.Name = "Semi-Finished";
      } else if (i == 3) {
        all_name_id.Name = "Row Material";
      }
      arr_ALL_Name_ID_For_TypeOfProduct.add(all_name_id);
    }
  }

  Widget GSTTax() {
    return InkWell(
      onTap: () {
        showcustomdialogWithOnlyName(
            values: arr_ALL_Name_ID_For_GSTTax,
            context1: context,
            controller: edt_GSTTax,
            lable: "GST Tax");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Flexible(
                  child: Text("GST Tax",
                      style: TextStyle(
                          fontSize: 12,
                          color: colorPrimary,
                          fontWeight: FontWeight
                              .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: false,
                        controller: edt_GSTTax,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "---Select---",
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
                  Icon(
                    Icons.arrow_drop_down,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  GSTTaxStatus() {
    arr_ALL_Name_ID_For_GSTTax.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Exclusive";
      } else if (i == 1) {
        all_name_id.Name = "Inclusive";
      } else if (i == 2) {
        all_name_id.Name = "None";
      }
      arr_ALL_Name_ID_For_GSTTax.add(all_name_id);
    }
  }

  Widget showcustomdialogWithID1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => _mainBloc.add(ProductBrandListRequestEvent(
                ProductBrandListRequest(
                    LoginUserID: LoginUserID,
                    CompanyId: CompanyID.toString()))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 12,
                          color: colorPrimary,
                          fontWeight: FontWeight
                              .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: hintTextvalue,
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
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onBrandListResponse(ProductBrandResponseState state) {
    arr_ALL_Name_ID_For_Brand.clear();
    for (var i = 0; i < state.productBrandResponse.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.pkID = state.productBrandResponse.details[i].pkID;
      all_name_id.Name = state.productBrandResponse.details[i].brandName;
      arr_ALL_Name_ID_For_Brand.add(all_name_id);
    }
    showcustomdialogWithID(
        values: arr_ALL_Name_ID_For_Brand,
        context1: context,
        controller: edt_Brand,
        controllerID: edt_BrandId,
        lable: "Select Brand");
  }

  Widget _buildProductGroupListView() {
    return InkWell(
      onTap: () {
        _mainBloc.add(ProductGroupDropDownRequestCallEvent(
            ProductGroupDropDownListRequest(
          pkID: "",
          ListMode: "",
          SearchKey: "",
          PageNo: "1",
          PageSize: "1000000",
          LoginUserID: LoginUserID,
          CompanyId: CompanyID.toString(),
        )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Product Category",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ]),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: edt_ProductCategory,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Select",
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
                  Icon(
                    Icons.arrow_drop_down,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onProductGroupDropDownAPIResponse(
      ProductGroupDropDownResponseState state) {
    arr_ProductGruopList.clear();
    for (int i = 0;
        i < state.productGroupDropDownResponse.details.length;
        i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name =
          state.productGroupDropDownResponse.details[i].productGroupName;
      all_name_id.pkID = state.productGroupDropDownResponse.details[i].pkID;
      arr_ProductGruopList.add(all_name_id);
    }
    showcustomdialogWithLargeNameID(
        values: arr_ProductGruopList,
        context1: context,
        controller: edt_ProductCategory,
        controllerID: edt_ProductCategoryId,
        lable: "Product Group");
  }

  _onTapOfSaveVehiclePunchAPICall() async {
    int nofollowupvalue = 1;

    if (_isSwitched == false) {
      nofollowupvalue = 0;
    } else {
      nofollowupvalue = 1;
    }

    if (edt_ProductName.text != "") {
      if (edt_ProductPrice.text != "") {
        if (edt_Brand.text != "") {
          if (edt_ProductAlias.text != "") {
            showCommonDialogWithTwoOptions(
                context, "Are you sure you want to Save this record ?",
                negativeButtonTitle: "No",
                positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
              _mainBloc.add(
                  ProductAddUpdateRequestCallEvent(ProductMasterAddEditRequest(
                pkID: pkID.toString(),
                ProductName: edt_ProductName.text,
                ProductAlias: edt_ProductAlias.text,
                BrandID: edt_BrandId.text,
                ProductGroupID: edt_ProductCategoryId.text,
                ProductType: edt_TypeOfProduct.text,
                ActiveFlag: nofollowupvalue.toString(),
                HSNCode: edt_HSNCode.text,
                UnitPrice: edt_ProductPrice.text,
                TaxRate:
                    edt_GSTTextPer.text == "" ? "0.00" : edt_GSTTextPer.text,
                TaxType: edt_GSTTax.text == "Exclusive"
                    ? "0"
                    : edt_GSTTax.text == "Inclusive"
                        ? "1"
                        : edt_GSTTax.text == "None"
                            ? "2"
                            : edt_GSTTax.text,
                Unit: edt_ProductUnit.text,
                ProductSpecification: edt_ProductSpec.text,
                LoginUserID: LoginUserID,
                CompanyId: CompanyID.toString(),
              )));
            });
          } else {
            showCommonDialogWithSingleOption(
                context, "Product Alias Is Required !",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
            });
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Product Brand Is Required !", positiveButtonTitle: "OK",
              onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }
      } else {
        showCommonDialogWithSingleOption(context, "Unit Price Is Required !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "Product Name Is Required !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, ProductMasterListScreen.routeName, clearAllStack: true);
  }

  void _onBankVoucherSaveResponse(ProductAddUpdateResponseState state) {
    showCommonDialogWithSingleOption(context,
        state.productMasterAddEditResponse.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
      navigateTo(context, ProductMasterListScreen.routeName,
          clearAllStack: true);
    });
  }

  void fillData() async {
    pkID = _editModel.pkID;
    edt_ProductName.text = _editModel.productName;
    edt_ProductSpec.text = _editModel.productSpecification;
    edt_ProductAlias.text = _editModel.productAlias;
    edt_HSNCode.text = _editModel.hSNCode;
    edt_ProductUnit.text = _editModel.unit;
    edt_ProductPrice.text = _editModel.unitPrice.toString();
    edt_GSTTextPer.text = _editModel.taxRate.toString();
    edt_GSTTax.text = _editModel.taxType.toString() == "0"
        ? "Exclusive"
        : _editModel.taxType.toString() == "1"
            ? "Inclusive"
            : _editModel.taxType.toString() == "2"
                ? "None"
                : _editModel.taxType.toString();
    edt_TypeOfProduct.text = _editModel.productType;
    edt_Brand.text = _editModel.brandName;
    edt_BrandId.text = _editModel.brandID.toString();
    edt_ProductCategory.text = _editModel.productGroupName;
    edt_ProductCategoryId.text = _editModel.productGroupID.toString();
    _isSwitched = _editModel.activeFlag;
  }
}
