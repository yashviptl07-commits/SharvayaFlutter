import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/other/bloc_modules/inquiry/inquiry_bloc.dart';
import 'package:soleoserp/models/api_requests/constant_master/constant_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/Maintenance_product_model.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/search_inquiry_product_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class MaintenanceProductAddEditScreenArguments {
  MaintenanceProductModel model;
  String inquiry_No;
  String StartDate;
  String EndDate;

  MaintenanceProductAddEditScreenArguments(
      this.model, this.inquiry_No, this.StartDate, this.EndDate);
}

class MaintenanceProductAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/MaintenanceProductAddEditScreen';
  final MaintenanceProductAddEditScreenArguments arguments;

  MaintenanceProductAddEditScreen(this.arguments);

  @override
  _MaintenanceProductAddEditScreenState createState() =>
      _MaintenanceProductAddEditScreenState();
}

class _MaintenanceProductAddEditScreenState
    extends BaseState<MaintenanceProductAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productIDController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _unitPriceController = TextEditingController();
  TextEditingController _totalAmountController = TextEditingController();
  FocusNode QuantityFocusNode;

  final _formKey = GlobalKey<FormState>();
  bool isForUpdate = false;
  bool isProductExist = false;
  bool isProductExistAfter = false;
  InquiryBloc _inquiryBloc;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Designation = [];
  ProductSearchDetails _searchDetails;
  double airFlow;
  double velocity;
  double valueFinal;
  String sam, sam2;
  String airFlowText, velocityText, finalText;
  List<MaintenanceProductModel> _inquiryProductList = [];
  String ConstantMAster = "";
  int CompanyID = 0;
  String LoginUserID = "";
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    QuantityFocusNode = FocusNode();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId;

    if (widget.arguments.model != null) {
      print("jbcdc");
      isForUpdate = true;
      _productNameController.text = widget.arguments.model.ProductName;
      _productIDController.text = widget.arguments.model.ProductID;
      _quantityController.text = widget.arguments.model.Quantity;
      _unitPriceController.text = widget.arguments.model.UnitPrice;
      _totalAmountController.text = widget.arguments.model.TotalAmount;
    }
    _quantityController.addListener(TotalAmountCalculation);
    _unitPriceController.addListener(TotalAmountCalculation);
    _totalAmountController.addListener(TotalAmountCalculation);
    _inquiryBloc = InquiryBloc(baseBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<InquiryBloc, InquiryStates>(
        builder: (BuildContext context, InquiryStates state) {
          //handle states
          /*  if (state is In) {
            _onDesignationCallSuccess(state);
          }
*/
          if (state is ConstantResponseState) {
            _onGetConstant(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called
          /* if (currentState is DesignationListEventResponseState) {
            return true;
          }*/
          if (currentState is ConstantResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, InquiryStates state) {},
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called
          /* if (currentState is StateListEventResponseState) {
            return true;
          }
          if (currentState is DistrictListEventResponseState) {
            return true;
          }*/

          return false;
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
    QuantityFocusNode.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        getCommonAppBar(context, baseTheme,
            "${isForUpdate ? "Update" : "Add"} Product Details",
            showBack: true, showHome: true),
        Expanded(
          child: SingleChildScrollView(
              child: Container(

            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildSearchView(),
                  SizedBox(
                    height: 10,
                  ),
                  Quantity(),
                  SizedBox(
                    height: 10,
                  ),
                  UnitPrice(),
                  SizedBox(
                    height: 10,
                  ),
                  TotalAmount(),
                  SizedBox(
                    height: 30,
                  ),
                  getCommonButton(baseTheme, () {
                    _onTapOfAdd();
                  }, isForUpdate ? "Update" : "Add",
                      radius: 10, backGroundColor: colorPrimary)
                ],
              ),
            ),
          )),
        ),
      ],
    );
  }

  _onTapOfAdd() async {
    await getInquiryProductDetails();
    if (_formKey.currentState.validate()) {
      if (ConstantMAster.toLowerCase() == "yes") {
        isProductExistAfter = false;
        print("efnefn" + isProductExist.toString());
      } else {
        isProductExistAfter = true;
        print("efnefn" + isProductExist.toString());
      }

      if (_quantityController.text != "0") {
        if (_unitPriceController.text != "0") {
          if (isProductExist == false) {
            if (isForUpdate) {
              await OfflineDbHelper.getInstance().updateMaintenanceProduct(
                  MaintenanceProductModel(
                      "0", //String pkID,
                      "", //String InquiryNo,
                      _productIDController.text.toString(), //String ProductID,
                      _productNameController.text
                          .toString(), //String ProductName,
                      _unitPriceController.text.toString(), //String UnitPrice,
                      "0.00", //String TaxRate,
                      _quantityController.text.toString(), //String Quantity,
                      _totalAmountController.text, //String TotalAmount,
                      widget.arguments.StartDate, //String StartDate,
                      widget.arguments.EndDate, //String EndDate,
                      "", //String OrderNo,
                      "", //String SerialKey,
                      "0", //String ContractMonth,
                      LoginUserID, //String LoginUserID,
                      CompanyID.toString(), //String CompanyId,
                      id: widget.arguments.model.id));
            } else {
              await OfflineDbHelper.getInstance()
                  .insertMaintenanceProduct(MaintenanceProductModel(
                "0", //String pkID,
                "", //String InquiryNo,
                _productIDController.text.toString(), //String ProductID,
                _productNameController.text.toString(), //String ProductName,
                _unitPriceController.text.toString(), //String UnitPrice,
                "0.00", //String TaxRate,
                _quantityController.text.toString(), //String Quantity,
                _totalAmountController.text, //String TotalAmount,
                widget.arguments.StartDate, //String StartDate,
                widget.arguments.EndDate, //String EndDate,
                "", //String OrderNo,
                "", //String SerialKey,
                "", //String ContractMonth,
                LoginUserID, //String LoginUserID,
                CompanyID.toString(), //String CompanyId,
              ));
            }
            Navigator.of(context).pop();
          } else {
            //Check Once
            if (isForUpdate) {
              await OfflineDbHelper.getInstance().updateMaintenanceProduct(
                  MaintenanceProductModel(
                      "0", //String pkID,
                      "", //String InquiryNo,
                      _productIDController.text.toString(), //String ProductID,
                      _productNameController.text
                          .toString(), //String ProductName,
                      _unitPriceController.text.toString(), //String UnitPrice,
                      "0.00", //String TaxRate,
                      _quantityController.text.toString(), //String Quantity,
                      _totalAmountController.text, //String TotalAmount,
                      widget.arguments.StartDate, //String StartDate,
                      widget.arguments.EndDate, //String EndDate,
                      "", //String OrderNo,
                      "", //String SerialKey,
                      "", //String ContractMonth,
                      LoginUserID, //String LoginUserID,
                      CompanyID.toString(), //String CompanyId,
                      id: widget.arguments.model.id));
              Navigator.of(context).pop();
            } else {
              if (isProductExistAfter == false) {
                await OfflineDbHelper.getInstance()
                    .insertMaintenanceProduct(MaintenanceProductModel(
                  "0", //String pkID,
                  "", //String InquiryNo,
                  _productIDController.text.toString(), //String ProductID,
                  _productNameController.text.toString(), //String ProductName,
                  _unitPriceController.text.toString(), //String UnitPrice,
                  "0.00", //String TaxRate,
                  _quantityController.text.toString(), //String Quantity,
                  _totalAmountController.text, //String TotalAmount,
                  widget.arguments.StartDate, //String StartDate,
                  widget.arguments.EndDate, //String EndDate,
                  "", //String OrderNo,
                  "", //String SerialKey,
                  "", //String ContractMonth,
                  LoginUserID, //String LoginUserID,
                  CompanyID.toString(), //String CompanyId,
                ));
                Navigator.of(context).pop();
              } else {
                showCommonDialogWithSingleOption(
                    context, "Duplicate Product Not Allowed..!!",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                });
              }
            }
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Unit Price Should not be Zero Values!",
              positiveButtonTitle: "OK");
        }
      } else {
        showCommonDialogWithSingleOption(
            context, "Quantity Should not be Zero Values!",
            positiveButtonTitle: "OK");
      }
    }
  }

  Widget Quantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Quantity *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: Colors.grey[200],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 15, right: 15),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      focusNode: QuantityFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _quantityController,
                      onChanged: (_quantityController) {},
                      onTap: () {
                        setState(() {
                          _quantityController.clear();
                          _totalAmountController.clear();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Tap to enter Quantity",
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
                  Icons.style,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget UnitPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("UnitPrice *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: Colors.grey[200],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 15, right: 15),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _unitPriceController,
                      onChanged: (_unitPriceController) {
                        /* setState(() {
                          velocity =
                              double.parse(_unitPriceController.toString());
                        });*/
                      },
                      onTap: () {
                        setState(() {
                          _unitPriceController.clear();
                          _totalAmountController.clear();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Tap to enter UnitPrice",
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
    );
  }

  Widget TotalAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("NetAmount *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: Colors.grey[200],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 15, right: 15),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _totalAmountController,
                      onChanged: (value) {
                        setState(() {
                          _totalAmountController.value =
                              _totalAmountController.value.copyWith(
                            text: value.toString(),
                          );
                        });
                      },
                      onTap: () {
                        setState(() {
                          _totalAmountController.clear();
                          _totalAmountController.value =
                              _totalAmountController.value.copyWith(
                            text: '',
                          );
                        });
                      },
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
        )
      ],
    );
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Search Product *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            color: Colors.grey[200],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        validator: (value) {
                          if (value.toString().trim().isEmpty) {
                            return "Please enter this field";
                          }
                          return null;
                        },
                        onTap: () {
                          _onTapOfSearchView();
                        },
                        readOnly: true,
                        controller: _productNameController,
                        decoration: InputDecoration(
                          hintText: "Tap to search Product",
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
                    Icons.search,
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

  Future<void> _onTapOfSearchView() async {
    navigateTo(
      context,
      SearchInquiryProductScreen.routeName,
    ).then((value) {
      if (value != null) {
        _searchDetails = value;
        _productNameController.text = _searchDetails.productName.toString();
        _productIDController.text = _searchDetails.pkID.toString();
        _unitPriceController.text = _searchDetails.unitPrice.toString();
        //_totalAmountController.text = ""
        if (_productNameController.text ==
            _searchDetails.productName.toString()) {
          QuantityFocusNode.requestFocus();
        }
      }
    });
    _inquiryBloc.add(ConstantRequestEvent(
        CompanyID.toString(),
        ConstantRequest(
            ConstantHead: "QuotationProDuplication",
            CompanyId: CompanyID.toString())));
  }

  TotalAmountCalculation() {
    if (_quantityController.text.isNotEmpty &&
        _unitPriceController.text.isNotEmpty) {
      double Quantity = double.parse(_quantityController.text.toString());
      double UnitPrice = double.parse(_unitPriceController.text.toString());
      double TotalAmount = Quantity * UnitPrice;
      _totalAmountController.text = TotalAmount.toString();
    }
  }

/*
  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<InquiryProductModel> temp =
        await OfflineDbHelper.getInstance().getInquiryProduct();
    _inquiryProductList.addAll(temp);
    if (_inquiryProductList.length != 0) {
      for (var i = 0; i < _inquiryProductList.length; i++) {
        if (_inquiryProductList[i].ProductID ==
            _productIDController.text.toString()) {
          isProductExist = true;
          break;
        } else {
          isProductExist = false;
        }
      }
    } else {
      isProductExist = false;
    }
    setState(() {});
  }
*/

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<MaintenanceProductModel> temp =
        await OfflineDbHelper.getInstance().getMaintenanceProduct();
    _inquiryProductList.addAll(temp);
    if (_inquiryProductList.length != 0) {
      for (var i = 0; i < _inquiryProductList.length; i++) {
        print("ChekProduct" +
            " DBProduct : " +
            _inquiryProductList[i].ProductID.toString() +
            " TextProduct : " +
            _productIDController.text.toString());
        if (_inquiryProductList[i].ProductID.toString() ==
            _productIDController.text.toString()) {
          isProductExist = true;
          break;
        } else {
          isProductExist = false;
        }
      }
    }
  }

  void _onGetConstant(ConstantResponseState state) {
    for (int i = 0; i < state.response.details.length; i++) {
      print("ConstantValue" + state.response.details[i].value.toString());

      ConstantMAster = state.response.details[i].value.toString();
    }
  }
}
