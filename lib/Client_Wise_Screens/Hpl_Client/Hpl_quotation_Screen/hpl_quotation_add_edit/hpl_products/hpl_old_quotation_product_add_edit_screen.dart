import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_add_edit/hpl_qt_assembly/hpl_qt_assembly_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_add_edit/hpl_specification/hpl_specification_list_screen.dart';
import 'package:soleoserp/blocs/other/bloc_modules/quotation/quotation_bloc.dart';
import 'package:soleoserp/models/api_requests/other/specification_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/hpl_Design_dropDown_list.dart';
import 'package:soleoserp/models/api_requests/quotation/hpl_Grade_dropDown_list.dart';
import 'package:soleoserp/models/api_requests/quotation/hpl_Size_dropDown_list.dart';
import 'package:soleoserp/models/api_requests/quotation/hpl_Thickness_dropDown_list.dart';
import 'package:soleoserp/models/api_requests/quotation/hpl_finish_dropDown_list.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/designation_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/hpl_quotation_table.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/search_inquiry_product_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/calculation/model/product_calculation_model.dart';
import 'package:soleoserp/utils/calculation/product_calulation.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class HplOldAddQuotationProductScreenArguments {
  QuotationTable1 model;
  int StateCode;
  String HeaderDiscAmnt;
  String QuotationNo;

  HplOldAddQuotationProductScreenArguments(
      this.model, this.StateCode, this.HeaderDiscAmnt, this.QuotationNo);
}

/*class AddStateCodeArguments {
  String StateCode;

  AddStateCodeArguments(this.StateCode);
}*/

class HplOldAddQuotationProductScreen extends BaseStatefulWidget {
  static const routeName = '/HplOldAddQuotationProductScreen';
  final HplOldAddQuotationProductScreenArguments arguments;

  HplOldAddQuotationProductScreen(this.arguments);

  @override
  _HplOldAddQuotationProductScreenState createState() =>
      _HplOldAddQuotationProductScreenState();
}

class _HplOldAddQuotationProductScreenState
    extends BaseState<HplOldAddQuotationProductScreen>
    with BasicScreen, WidgetsBindingObserver {
  //DesignationApiResponse _offlineCustomerDesignationData;

  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productIDController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _unitController = TextEditingController();

  TextEditingController _unitPriceController = TextEditingController();
  TextEditingController _discPerController = TextEditingController();
  TextEditingController _discAmountController = TextEditingController();

  TextEditingController _netRateController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _taxPerController = TextEditingController();
  TextEditingController _taxAmountController = TextEditingController();
  TextEditingController _taxTypeController = TextEditingController();
  TextEditingController edt_Specification = TextEditingController();
  TextEditingController edt_CGST_Per = TextEditingController();
  TextEditingController edt_SGST_Per = TextEditingController();
  TextEditingController edt_CGST_Amount = TextEditingController();
  TextEditingController edt_SGST_Amount = TextEditingController();
  TextEditingController edt_IGST_Per = TextEditingController();
  TextEditingController edt_IGST_Amount = TextEditingController();
  TextEditingController edt_StateCode = TextEditingController();
  TextEditingController txt_TotalNetAmnt = TextEditingController();

  TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController edt_Finish_ID = TextEditingController();
  final TextEditingController edt_Finish_Name = TextEditingController();
  final TextEditingController edt_Thickness_ID = TextEditingController();
  final TextEditingController edt_Thickness_Name = TextEditingController();
  final TextEditingController edt_Size_ID = TextEditingController();
  final TextEditingController edt_Size_Name = TextEditingController();
  final TextEditingController edt_Grade_ID = TextEditingController();
  final TextEditingController edt_Grade_Name = TextEditingController();
  final TextEditingController edt_Design_ID = TextEditingController();
  final TextEditingController edt_Design_Name = TextEditingController();
  FocusNode QuantityFocusNode;

  final _formKey = GlobalKey<FormState>();
  bool isForUpdate = false;
  bool isProductExist = false;
  QuotationBloc _inquiryBloc;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Designation = [];
  ProductSearchDetails _searchDetails;
  double airFlow;
  double velocity;
  double valueFinal;
  String sam, sam2;
  String airFlowText, velocityText, finalText;
  List<QuotationTable1> _inquiryProductList = [];
  List<QuotationTable1> _TempinquiryProductList = [];

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  //CustomerSourceResponse _offlineCustomerSource;
  //InquiryStatusListResponse _offlineInquiryLeadStatusData;
  int CompanyID = 0;
  String LoginUserID = "";
  double CardViewHeight = 35;

  double TotalNetAmnt = 0.00;

  String _HeaderDiscAmnt = "0.00";

  String _QuotationNo = "";

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Finish = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Thickness = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Size = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Grade = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Design = [];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId;

    _QuotationNo = widget.arguments.QuotationNo;
    QuantityFocusNode = FocusNode();

    // _offlineCustomerDesignationData = SharedPrefHelper.instance.getCustomerDesignationData();
    if (widget.arguments.model != null) {
      //for update
      isForUpdate = true;

      print("updateCase" + widget.arguments.QuotationNo);

      _productNameController.text = widget.arguments.model.ProductName;
      _productIDController.text = widget.arguments.model.ProductID.toString();
      _quantityController.text = widget.arguments.model.Quantity.toString();
      _unitController.text = widget.arguments.model.Unit.toString();
      _unitPriceController.text =
          widget.arguments.model.UnitRate.toStringAsFixed(2);
      _netRateController.text =
          widget.arguments.model.NetRate.toStringAsFixed(2);
      _discPerController.text =
          widget.arguments.model.DiscountPercent.toStringAsFixed(2);
      _discAmountController.text =
          widget.arguments.model.DiscountAmt.toStringAsFixed(2);

      _amountController.text = widget.arguments.model.Amount.toStringAsFixed(2);

      _taxTypeController.text = widget.arguments.model.TaxType.toString();

      print("jhfd" + _taxTypeController.text.toString());

      _taxPerController.text =
          widget.arguments.model.TaxRate.toStringAsFixed(2);
      _taxAmountController.text =
          widget.arguments.model.TaxAmount.toStringAsFixed(2);
      _totalAmountController.text =
          widget.arguments.model.NetAmount.toStringAsFixed(2);
      edt_Specification.text = removeAllHtmlTags(
          widget.arguments.model.ProductSpecification.toString());

      edt_StateCode.text = widget.arguments.StateCode.toString();
      edt_CGST_Per.text = "0.00";
      edt_SGST_Per.text = "0.00";
      edt_CGST_Amount.text = "0.00";
      edt_SGST_Amount.text = "0.00";

      edt_Finish_ID.text = widget.arguments.model.Finish.toString();
      edt_Finish_Name.text = widget.arguments.model.FinishName;
      edt_Thickness_ID.text = widget.arguments.model.Thickness.toString();
      edt_Thickness_Name.text = widget.arguments.model.ThicknessName;
      edt_Size_ID.text = widget.arguments.model.Size.toString();
      edt_Size_Name.text = widget.arguments.model.SizeName;
      edt_Grade_ID.text = widget.arguments.model.Grade.toString();
      edt_Grade_Name.text = widget.arguments.model.GradeName;
      edt_Design_ID.text = widget.arguments.model.Design.toString();
      edt_Design_Name.text = widget.arguments.model.DesignName;
      edt_Specification.text = widget.arguments.model.ProductSpecification;

      //_totalAmountController.text = _quantityController.text +_unitPriceController.text ;
    } else {
      _quantityController.text = "0.00";
      _unitPriceController.text = "0.00";
      _discPerController.text = "0.00";
      _netRateController.text = "0.00";
      _amountController.text = "0.00";
      _taxPerController.text = "0.00";
      _taxAmountController.text = "0.00";
      _totalAmountController.text = "0.00";
      edt_CGST_Per.text = "0.00";
      edt_SGST_Per.text = "0.00";
      edt_CGST_Amount.text = "0.00";
      edt_SGST_Amount.text = "0.00";

      if (widget.arguments.StateCode != null) {
        edt_StateCode.text = widget.arguments.StateCode.toString();
      }
    }
    _HeaderDiscAmnt = widget.arguments.HeaderDiscAmnt;

    // _totalAmountController.text = totalCalculated();
    _quantityController.addListener(TotalAmountCalculation);
    _unitPriceController.addListener(TotalAmountCalculation);
    _discPerController.addListener(TotalAmountCalculation);
    _discAmountController.addListener(TotalAmountCalculation);
    _netRateController.addListener(TotalAmountCalculation);
    _amountController.addListener(TotalAmountCalculation);
    _taxPerController.addListener(TotalAmountCalculation);
    _taxAmountController.addListener(TotalAmountCalculation);
    _totalAmountController.addListener(TotalAmountCalculation);
    _taxTypeController.addListener(TotalAmountCalculation);
    edt_CGST_Per.addListener(TotalAmountCalculation);
    edt_SGST_Per.addListener(TotalAmountCalculation);
    edt_CGST_Amount.addListener(TotalAmountCalculation);
    edt_SGST_Amount.addListener(TotalAmountCalculation);

    _inquiryBloc = QuotationBloc(baseBloc);
    //_onDesignationCallSuccess(_offlineCustomerDesignationData);
    /* _productNameController.addListener(() {
      QuantityFocusNode.requestFocus();
    });*/
    //getInquiryDetailsFromDb();

    print("HeaderDis7upc" + _HeaderDiscAmnt);
  }

  /* String totalCalculated() {
    airFlowText = _quantityController.text;
    velocityText = _unitPriceController.text;
    finalText = _totalAmountController.text;

    if (airFlowText != '' && velocityText != '') {
      sam = (airFlow * velocity).toString();
      _totalAmountController.value = _totalAmountController.value.copyWith(
        text: sam.toString(),
      );
    }
    return sam;
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<QuotationBloc, QuotationStates>(
        builder: (BuildContext context, QuotationStates state) {
          //handle states
          /*  if (state is In) {
            _onDesignationCallSuccess(state);
          }
*/
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called
          /* if (currentState is DesignationListEventResponseState) {
            return true;
          }*/
          return false;
        },
        listener: (BuildContext context, QuotationStates state) {
          if (state is SpecificationListResponseState) {
            _OnGetProductSpecificationResponse(state);
          }
          if (state is HplFinishListResponseState) {
            _onFinishCallSuccess(state);
          }
          if (state is HplThicknessListResponseState) {
            _onThicknessCallSuccess(state);
          }
          if (state is HplSizeListResponseState) {
            _onSizeCallSuccess(state);
          }
          if (state is HplGradeListResponseState) {
            _onGradeCallSuccess(state);
          }
          if (state is HplDesignListResponseState) {
            _onDesignCallSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called
          if (currentState is HplFinishListResponseState) {
            return true;
          }
          if (currentState is HplThicknessListResponseState) {
            return true;
          }
          if (currentState is HplSizeListResponseState) {
            return true;
          }
          if (currentState is HplGradeListResponseState) {
            return true;
          }
          if (currentState is HplDesignListResponseState) {
            return true;
          }
          if (currentState is SpecificationListResponseState) {
            return true;
          }

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
    _quantityController.dispose();
    _unitPriceController.dispose();
    _discPerController.dispose();
    _netRateController.dispose();
    _amountController.dispose();
    _taxPerController.dispose();
    _taxAmountController.dispose();
    _totalAmountController.dispose();
    edt_Specification.dispose();
    edt_CGST_Per.dispose();
    edt_SGST_Per.dispose();
    edt_CGST_Amount.dispose();
    edt_SGST_Amount.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        getCommonAppBar(context, baseTheme,
            "${isForUpdate ? "Update" : "Add"} Quotation Product",
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: Quantity()),
                      Expanded(flex: 1, child: UNIT()),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 1, child: UnitPrice()),
                    Expanded(flex: 1, child: DiscPer()),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 1, child: NetRate()),
                    Expanded(child: Amount()),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 1, child: TaxPer()),
                    Expanded(flex: 1, child: TaxAmount()),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  TotalAmount(),
                  SizedBox(
                    height: 10,
                  ),
                  Finish("Finish",
                      enable1: false,
                      title: "Finish *",
                      hintTextvalue: "--- Select Finish ---",
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: colorPrimary,
                      ),
                      controllerForLeft: edt_Finish_Name,
                      controllerpkID: edt_Finish_ID,
                      Custom_values1: arr_ALL_Name_ID_For_Finish),
                  SizedBox(
                    height: 10,
                  ),
                  Thickness("Thickness",
                      enable1: false,
                      title: "Thickness *",
                      hintTextvalue: "--- Select Thickness ---",
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: colorPrimary,
                      ),
                      controllerForLeft: edt_Thickness_Name,
                      controllerpkID: edt_Thickness_ID,
                      Custom_values1: arr_ALL_Name_ID_For_Thickness),
                  SizedBox(
                    height: 10,
                  ),
                  size1("Size",
                      enable1: false,
                      title: "Size *",
                      hintTextvalue: "--- Select Size ---",
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: colorPrimary,
                      ),
                      controllerForLeft: edt_Size_Name,
                      controllerpkID: edt_Size_ID,
                      Custom_values1: arr_ALL_Name_ID_For_Size),
                  SizedBox(
                    height: 10,
                  ),
                  Grade("Grade",
                      enable1: false,
                      title: "Grade *",
                      hintTextvalue: "--- Select Grade ---",
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: colorPrimary,
                      ),
                      controllerForLeft: edt_Grade_Name,
                      controllerpkID: edt_Grade_ID,
                      Custom_values1: arr_ALL_Name_ID_For_Grade),
                  SizedBox(
                    height: 10,
                  ),
                  Design("Design",
                      enable1: false,
                      title: "Design *",
                      hintTextvalue: "--- Select Design ---",
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: colorPrimary,
                      ),
                      controllerForLeft: edt_Design_Name,
                      controllerpkID: edt_Design_ID,
                      Custom_values1: arr_ALL_Name_ID_For_Design),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text("Remarks",
                            style: TextStyle(
                                fontSize: 12,
                                color: colorPrimary,
                                fontWeight: FontWeight
                                    .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 7, right: 7, top: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value.toString().trim().isEmpty) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          controller: edt_Specification,
                          minLines: 2,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: 'Enter Details',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  isForUpdate == true
                      ? Visibility(
                          visible: true,
                          child: Row(
                            children: [
                              Expanded(
                                child: getCommonButton(baseTheme, () async {
                                  //QuotationSpecificationAddEditScreen

                                  navigateTo(context,
                                          HplSpecificationListScreen.routeName,
                                          arguments:
                                              HplSpecificationListArgument(
                                                  _QuotationNo,
                                                  _productIDController.text
                                                      .toString()))
                                      .then((value) {
                                    print("ljfdjg" + value.toString());
                                  });

                                  //SpecificationListScreen
                                }, "Specification",
                                    width: 300,
                                    backGroundColor: Colors.blueAccent,
                                    radius: 30),
                              ),
                              /* SizedBox(
                                width: 10,
                              ),*/
                              Visibility(
                                visible: false,
                                child: Expanded(
                                  child: getCommonButton(baseTheme, () async {
                                    //QuotationSpecificationAddEditScreen

                                    navigateTo(context,
                                            HplQTAssemblyScreen.routeName,
                                            arguments:
                                                HplQTAssemblyScreenArgument(
                                                    _QuotationNo,
                                                    _productIDController.text
                                                        .toString()))
                                        .then((value) {
                                      print("ljfdjg" + value.toString());
                                    });

                                    //SpecificationListScreen
                                  }, "Assembly",
                                      width: 300,
                                      backGroundColor: Colors.blueAccent,
                                      radius: 30),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  // : Container(),
/*  List<String> table = productCalculation
                                  .producwisecalculation(2.0, 3.0);

                              for (int i = 0; i < table.length; i++) {
                                print("CalculateResult" +
                                    " Result : " +
                                    table[i]);
                              }*/
                  SizedBox(
                    height: 20,
                  ),
                  getCommonButton(baseTheme, () {
                    if (_productNameController.text != "") {
                      if (_quantityController.text != "") {
                        if (double.parse(_quantityController.text) > 0) {
                          if (_unitPriceController.text != "") {
                            if (double.parse(_unitPriceController.text) > 0) {
                              if (edt_Finish_ID.text != "") {
                                if (edt_Thickness_ID.text != "") {
                                  if (edt_Size_ID.text != "") {
                                    if (edt_Grade_ID.text != "") {
                                      if (edt_Design_ID.text != "") {
                                        _onTapOfAdd();
                                      } else {
                                        showCommonDialogWithSingleOption(
                                            context, "Design is required",
                                            positiveButtonTitle: "OK",
                                            onTapOfPositiveButton: () {
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    } else {
                                      showCommonDialogWithSingleOption(
                                          context, "Grade is required",
                                          positiveButtonTitle: "OK",
                                          onTapOfPositiveButton: () {
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(
                                        context, "Size is required",
                                        positiveButtonTitle: "OK",
                                        onTapOfPositiveButton: () {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                } else {
                                  showCommonDialogWithSingleOption(
                                      context, "Thickness is required",
                                      positiveButtonTitle: "OK",
                                      onTapOfPositiveButton: () {
                                    Navigator.of(context).pop();
                                  });
                                }
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Finish is required",
                                    positiveButtonTitle: "OK",
                                    onTapOfPositiveButton: () {
                                  Navigator.of(context).pop();
                                });
                              }
                            } else {
                              showCommonDialogWithSingleOption(context,
                                  "UnitRate Should not be Zero Value..!!",
                                  positiveButtonTitle: "OK",
                                  onTapOfPositiveButton: () {
                                Navigator.of(context).pop();
                              });
                            }
                          } else {
                            showCommonDialogWithSingleOption(context,
                                "UnitRate Should not be Blank Value..!!",
                                positiveButtonTitle: "OK",
                                onTapOfPositiveButton: () {
                              Navigator.of(context).pop();
                            });
                          }
                        } else {
                          showCommonDialogWithSingleOption(
                              context, "Quantity Should not be Zero Value..!!",
                              positiveButtonTitle: "OK",
                              onTapOfPositiveButton: () {
                            Navigator.of(context).pop();
                          });
                        }
                      } else {
                        showCommonDialogWithSingleOption(
                            context, "Quantity Should not be Blank Value..!!",
                            positiveButtonTitle: "OK",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();
                        });
                      }
                    } else {
                      showCommonDialogWithSingleOption(
                          context, "ProductName is required..!!",
                          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                        Navigator.of(context).pop();
                      });
                    }
                  }, isForUpdate ? "Update" : "Add", radius: 15)
                ],
              ),
            ),
          )),
        ),
      ],
    );
  }

  _onTapOfAdd() async {
    var CGSTPer = 0.00;
    var CGSTAmount = 0.00;
    var SGSTPer = 0.00;
    var SGSTAmount = 0.00;
    var IGSTPer = 0.00;
    var IGSTAmount = 0.00;

    if (_discPerController.text == "") {
      _discPerController.text = "0.00";
    }
    if (_taxPerController.text == "") {
      _taxPerController.text = "0.00";
    }

    int productID = int.parse(_productIDController.text.toString());
    double quantity = double.parse(_quantityController.text.toString());
    double unitRate = double.parse(_unitPriceController.text.toString());
    double disc = double.parse(_discPerController.text.toString());
    double discAmount = double.parse(_discAmountController.text.toString());
    double netRate = double.parse(_netRateController.text.toString());
    double amount = double.parse(_amountController.text.toString());
    double taxPer = double.parse(_taxPerController.text.toString());
    double taxAmount = double.parse(_taxAmountController.text.toString());
    double netAmount = double.parse(_totalAmountController.text.toString());
    String Specification = edt_Specification.text.toString();
    String unit = _unitController.text.toString();
    int Finish =
        edt_Finish_ID.text == "" ? 0 : int.parse(edt_Finish_ID.text.toString());
    int Thickness = edt_Thickness_ID.text == ""
        ? 0
        : int.parse(edt_Thickness_ID.text.toString());
    int Size =
        edt_Size_ID.text == "" ? 0 : int.parse(edt_Size_ID.text.toString());
    int Grade =
        edt_Grade_ID.text == "" ? 0 : int.parse(edt_Grade_ID.text.toString());
    int Design =
        edt_Design_ID.text == "" ? 0 : int.parse(edt_Design_ID.text.toString());

    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (_taxTypeController.text != null) {
      Taxtype = double.parse(_taxTypeController.text);
      ISTaxType = Taxtype.toInt();
    }

    /*int ISTaxType = int.parse(_taxTypeController.text.toString() == null
        ? 0
        : _taxTypeController.text.toString());*/

    /* double CGSTPer = double.parse(edt_CGST_Per.text.toString());
    double SGSTPer = double.parse(edt_SGST_Per.text.toString());
    double IGSTPer = double.parse(edt_IGST_Per.text.toString());

    double CGSTAmount = double.parse(edt_CGST_Amount.text.toString());
    double SGSTAmount = double.parse(edt_SGST_Amount.text.toString());
    double IGSTAmount = double.parse(edt_IGST_Amount.text.toString());*/
    int StateCode = int.parse(edt_StateCode.text);

    if (_offlineLoggedInData.details[0].stateCode ==
        int.parse(edt_StateCode.text)) {
      CGSTPer = taxPer / 2;
      edt_CGST_Per.text = CGSTPer.toStringAsFixed(2);
      SGSTPer = taxPer / 2;
      edt_SGST_Per.text = CGSTPer.toStringAsFixed(2);
      CGSTAmount = taxAmount / 2;
      edt_CGST_Amount.text = CGSTPer.toStringAsFixed(2);
      SGSTAmount = taxAmount / 2;
      edt_SGST_Amount.text = CGSTPer.toStringAsFixed(2);
      edt_IGST_Per.text = "";
      edt_IGST_Amount.text = "";
    } else {
      edt_CGST_Per.text = "";
      edt_SGST_Per.text = "";
      edt_CGST_Amount.text = "";
      edt_SGST_Amount.text = "";
      IGSTPer = taxPer;
      edt_IGST_Per.text = CGSTPer.toStringAsFixed(2);
      IGSTAmount = taxAmount;
      edt_IGST_Amount.text = CGSTPer.toStringAsFixed(2);
    }

    //await getInquiryProductDetails();

    if (isForUpdate) {
      await OfflineDbHelper.getInstance().hplUpdateQuotationProduct(
          QuotationTable1(
              widget.arguments.model.QuotationNo,
              Specification,
              productID,
              _productNameController.text.toString(),
              unit,
              quantity,
              unitRate,
              disc,
              discAmount,
              netRate,
              amount,
              taxPer,
              taxAmount,
              netAmount,
              ISTaxType,
              CGSTPer,
              SGSTPer,
              IGSTPer,
              CGSTAmount,
              SGSTAmount,
              IGSTAmount,
              StateCode,
              0,
              LoginUserID,
              CompanyID.toString(),
              0,
              0.00,
              Finish,
              edt_Finish_Name.text,
              Thickness,
              edt_Thickness_Name.text,
              Size,
              edt_Size_Name.text,
              Grade,
              edt_Grade_Name.text,
              Design,
              edt_Design_Name.text,
              id: widget.arguments.model.id));
    } else {
      print("checking" + _inquiryProductList.length.toString());

      await OfflineDbHelper.getInstance()
          .hplInsertQuotationProduct(QuotationTable1(
        "",
        Specification,
        productID,
        _productNameController.text.toString(),
        unit,
        quantity,
        unitRate,
        disc,
        discAmount,
        netRate,
        amount,
        taxPer,
        taxAmount,
        netAmount,
        ISTaxType,
        CGSTPer,
        SGSTPer,
        IGSTPer,
        CGSTAmount,
        SGSTAmount,
        IGSTAmount,
        StateCode,
        0,
        LoginUserID,
        CompanyID.toString(),
        0,
        0.00,
        Finish,
        edt_Finish_Name.text,
        Thickness,
        edt_Thickness_Name.text,
        Size,
        edt_Size_Name.text,
        Grade,
        edt_Grade_Name.text,
        Design,
        edt_Design_Name.text,
      ));
    }
    Navigator.of(context).pop(_inquiryProductList);
  }

  void _onDesignationCallSuccess(DesignationApiResponse state) {
    arr_ALL_Name_ID_For_Designation.clear();
    for (var i = 0; i < state.details.length; i++) {
      print("DesignationDetails : " + state.details[i].designation);
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = state.details[i].designation;
      all_name_id.Name1 = state.details[i].desigCode;
      arr_ALL_Name_ID_For_Designation.add(all_name_id);
    }
  }

  Widget Quantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Quantity * ",
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
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
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
                      onTap: () => {
                            _quantityController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _quantityController.text.length,
                            )
                          },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
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
                /* Icon(
                  Icons.style,
                  color: colorGrayDark,
                )*/
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
          child: Text("Unit Rate *",
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
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
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
                      onTap: () => {
                            _unitPriceController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _unitPriceController.text.length,
                            )
                          },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget DiscPer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Disc.%",
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
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
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
                      onTap: () => {
                            _discPerController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _discPerController.text.length,
                            )
                          },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _discPerController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget TaxPer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Tax.%",
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
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
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
                      controller: _taxPerController,
                      onTap: () => {
                            _taxPerController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _taxPerController.text.length,
                            )
                          },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget UNIT() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Unit  ",
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
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
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
                      controller: _unitController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "Unit",
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
          child: Text("Net Amount",
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
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
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
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget NetRate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Net Rate",
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
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
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
                      controller: _netRateController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget Amount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Amount",
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
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
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
                      controller: _amountController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget TaxAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Tax Amount",
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
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
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
                      controller: _taxAmountController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
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
        print("VlaueForISForUpdate" + isForUpdate.toString());
        if (isForUpdate == false) {
          _onTapOfSearchView();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Search Product * ",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 40,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: /*TextField(
                      _searchDetails == null
                          ? "Tap to search inquiry"
                          : _searchDetails.productName,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _searchDetails == null
                              ? colorGrayDark
                              : colorBlack),
                    ),
                    */
                        TextFormField(
                            validator: (value) {
                              if (value.toString().trim().isEmpty) {
                                return "Please enter this field";
                              }
                              return null;
                            },
                            onTap: () {
                              if (isForUpdate == false) {
                                _onTapOfSearchView();
                              }
                            },
                            readOnly: true,
                            controller: _productNameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 5),
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
    /* navigateTo(context, SearchInquiryProductScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        _inquiryBloc.add(InquiryProductSearchNameCallEvent(InquiryProductSearchRequest(pkID: "",CompanyId: "10032",ListMode: "L",SearchKey: value)));
       print("ProductDetailss345"+_searchDetails.productName +"Alias"+ _searchDetails.productAlias);
      }
    });*/
    navigateTo(
      context,
      SearchInquiryProductScreen.routeName,
    ).then((value) {
      if (value != null) {
        _searchDetails = ProductSearchDetails();
        _searchDetails = value;
        setState(() {
          _quantityController.text = "0.00";
          _unitPriceController.text = "0.00";
          _discPerController.text = "0.00";
          _netRateController.text = "0.00";
          _amountController.text = "0.00";
          _taxPerController.text = "0.00";
          _taxAmountController.text = "0.00";
          _totalAmountController.text = "0.00";
          _taxTypeController.text = "";
          _unitController.text = "";
          edt_Specification.text = "";
          edt_CGST_Per.text = "";
          edt_SGST_Per.text = "";
          edt_CGST_Amount.text = "";
          edt_SGST_Amount.text = "";

          // edt_Specification.text = "";
          _productNameController.text = _searchDetails.productName.toString();
          _productIDController.text = _searchDetails.pkID.toString();
          _unitPriceController.text = _searchDetails.unitPrice.toString();
          _taxPerController.text = _searchDetails.taxRate.toString();
          _taxTypeController.text = _searchDetails.taxType.toString();
          _unitController.text = _searchDetails.unit.toString();
          edt_Specification.text =
              _searchDetails.ProductSpecification.toString();

          //_totalAmountController.text = ""
          if (_productNameController.text ==
              _searchDetails.productName.toString()) {
            QuantityFocusNode.requestFocus();
          }
          _quantityController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _quantityController.text.length,
          );
        });

        _inquiryBloc.add(QuotationSpecificationCallEvent(
            "pro",
            SpecificationListRequest(
                Module: "pro",
                QuotationNo: "",
                FinishProductID: _searchDetails.pkID.toString(),
                LoginUserID: LoginUserID,
                CompanyId: CompanyID.toString())));
      }
    });
  }

  TotalAmountCalculation1() async {
    List<QuotationTable1> temp =
        await OfflineDbHelper.getInstance().getHplQuotationProduct();
    double Exclusivetot_amount = 0.00;
    double Exclusivetot_tax_amt = 0.00;
    double Exclusivetot_amnt_net = 0.00;
    double Inclusivetot_amount = 0.00;
    double Inclusivetot_tax_amt = 0.00;
    double Inclusivetot_amnt_net = 0.00;

    double TotEXINNetmant = 0.00;
    double ExTotalNetAmnt = 0.00;
    double InTotalNetAmnt = 0.00;

    List<QuotationTable1> temp2 = [];
    if (temp.length != 0) {
      for (int i = 0; i < temp.length; i++) {
        if (temp[i].TaxType == 1) {
          Exclusivetot_amount = temp[i].Quantity * temp[i].NetRate;
          Exclusivetot_tax_amt = (Exclusivetot_amount * temp[i].TaxRate) / 100;
          Exclusivetot_amnt_net = Exclusivetot_amount + Exclusivetot_tax_amt;
          ExTotalNetAmnt += Exclusivetot_amnt_net;
          print("TotExclusive" +
              "ExclusiveNaetAmnt : " +
              Exclusivetot_amnt_net.toStringAsFixed(2));
        } else {
          Inclusivetot_amount = temp[i].Quantity * temp[i].NetRate;
          Inclusivetot_tax_amt =
              ((temp[i].Quantity * temp[i].NetRate) * temp[i].TaxRate) /
                  (100 + temp[i].TaxRate);
          Inclusivetot_amnt_net =
              Inclusivetot_amount; // + Inclusivetot_tax_amt;
          InTotalNetAmnt += Inclusivetot_amnt_net;
          print("TotInclusive" +
              "InclusiveNaetAmnt : " +
              Inclusivetot_amnt_net.toStringAsFixed(2));
        }
      }
    }
    TotEXINNetmant = ExTotalNetAmnt + InTotalNetAmnt;

    double Hdrdis = _HeaderDiscAmnt == "" || _HeaderDiscAmnt == null
        ? 0.00
        : double.parse(_HeaderDiscAmnt);
    // double.parse(_HeaderDiscAmnt == null ? 0.00 : _HeaderDiscAmnt);

    /* if(isForUpdate!=true)
      {
        Hdrdis = 0.00;
      }
    else
      {
        Hdrdis = double.parse(_HeaderDiscAmnt == null ? 0.00 : _HeaderDiscAmnt);
      }*/
    print("NetAfggkj" +
        TotEXINNetmant.toStringAsFixed(2) +
        Hdrdis.toStringAsFixed(2));
    if (_quantityController.text.toString() != null &&
        _unitPriceController.text.toString() != null) {
      setState(() {
        if (_discPerController.text == "") {
          _discPerController.text = "0.00";
        }
        var Quantity = _quantityController.text == ""
            ? 0.00
            : double.parse(_quantityController.text
                .toString()); //double.parse(_quantityController.text.toString());
        var UnitPrice = _unitPriceController.text == ""
            ? 0.00
            : double.parse(_unitPriceController.text
                .toString()); //double.parse(_unitPriceController.text.toString());
        var DisPer = _discPerController.text == ""
            ? 0.00
            : double.parse(_discPerController.text
                .toString()); /*double.parse(_discPerController.text.toString() == null
            ? 0.00
            : _discPerController.text.toString());*/
        var TaxPer = _taxPerController.text == ""
            ? 0.00
            : double.parse(_taxPerController.text
                .toString()); //double.parse(_taxPerController.text.toString());
        var Amount1 = 0.00;
        var TaxAmount1 = 0.00;
        var TotalAmount = 0.00;
        var NetRate1 = 0.00;
        double ExclusiveItemWiseHeaderDisAmnt = 0.00;
        double ExclusiveItemWiseAmount = 0.00;
        double ExclusiveNetAmntAfterHeaderDisAmnt = 0.00;
        double ExclusiveItemWiseTaxAmnt = 0.00;
        double ExclusiveTaxPluse100 = 0.00;
        double ExclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

        double ExclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;

        double InclusiveItemWiseHeaderDisAmnt = 0.00;
        double InclusiveItemWiseAmount = 0.00;
        double InclusiveNetAmntAfterHeaderDisAmnt = 0.00;
        double InclusiveItemWiseTaxAmnt = 0.00;
        double InclusiveTaxPluse100 = 0.00;
        double InclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

        double InclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;

        if (DisPer > 0) {
          final disper = (UnitPrice * DisPer) / 100;
          _discAmountController.text = disper.toStringAsFixed(2);
          NetRate1 = UnitPrice - disper;
        } else {
          NetRate1 = UnitPrice;
          _discAmountController.text = "0.00";
        }

        _netRateController.text = NetRate1.toStringAsFixed(2);

        double Taxtype = 0.00;
        int intTaxType = 0;

        if (_taxTypeController.text != null) {
          Taxtype = double.parse(_taxTypeController.text);
          intTaxType = Taxtype.toInt();
        }
        print("EditedTaxType" + " TaxType : " + intTaxType.toString());

        if (intTaxType == 1) {
          if (Hdrdis == 0.00) {
            Amount1 = Quantity * NetRate1;
            _amountController.text = Amount1.toStringAsFixed(2);
            TaxAmount1 = (Amount1 * TaxPer) / 100;
            _taxAmountController.text = TaxAmount1.toStringAsFixed(2);
            TotalAmount = Amount1 + TaxAmount1;
            _totalAmountController.text = TotalAmount.toStringAsFixed(2);
          } else {
            Amount1 = Quantity * NetRate1;

            print("Onlyfg" +
                Quantity.toString() +
                " NetAmount : " +
                NetRate1.toString() +
                " Amount : " +
                Amount1.toString());
            //_amountController.text = Amount1.toStringAsFixed(2);
            TaxAmount1 = (Amount1 * TaxPer) / 100;
            // _taxAmountController.text = TaxAmount1.toStringAsFixed(2);
            TotalAmount = Amount1 + TaxAmount1;
            // _totalAmountController.text = TotalAmount.toStringAsFixed(2); //getNumber(TotalAmount,precision: 2).toString();//TotalAmount.toStringAsFixed(3);

            ExclusiveItemWiseHeaderDisAmnt =
                TotalAmount * Hdrdis / TotEXINNetmant;
            ExclusiveItemWiseAmount = Quantity * NetRate1;
            ExclusiveNetAmntAfterHeaderDisAmnt =
                ExclusiveItemWiseAmount - ExclusiveItemWiseHeaderDisAmnt;
            ExclusiveItemWiseTaxAmnt =
                (ExclusiveNetAmntAfterHeaderDisAmnt * TaxPer) / 100;
            ExclusiveFinalNetAmntAfterHeaderDisAmnt =
                ExclusiveNetAmntAfterHeaderDisAmnt;
            ExclusiveTotalNetAmntAfterHeaderDisAmnt =
                ExclusiveItemWiseAmount + ExclusiveItemWiseTaxAmnt;
            var CGSTPer = 0.00;
            var CGSTAmount = 0.00;
            var SGSTPer = 0.00;
            var SGSTAmount = 0.00;
            var IGSTPer = 0.00;
            var IGSTAmount = 0.00;

            _amountController.text =
                ExclusiveFinalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2);
            _taxAmountController.text =
                ExclusiveItemWiseTaxAmnt.toStringAsFixed(2);
            _totalAmountController.text =
                ExclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2);
          }
        } else {
          Amount1 = 0.00;
          TaxAmount1 = 0.00;
          TotalAmount = 0.00;

          if (Hdrdis == 0.00) {
            TaxAmount1 = ((Quantity * NetRate1) * TaxPer) / (100 + TaxPer);
            _taxAmountController.text = TaxAmount1.toStringAsFixed(
                2); //getNumber(TaxAmount1,precision: 2).toString();

            Amount1 = (Quantity * NetRate1) - TaxAmount1;
            _amountController.text = Amount1.toStringAsFixed(
                2); //getNumber(Amount1,precision: 2).toString();
            TotalAmount = (Quantity *
                NetRate1); //+ TaxAmount1; //getNumber(TaxAmount1,precision: 2);
            _totalAmountController.text = TotalAmount.toStringAsFixed(
                2); //getNumber(TotalAmount,precision: 2).toString();
            print("dsljf333" + TotalAmount.toStringAsFixed(2));
          } else {
            TaxAmount1 = ((Quantity * NetRate1) * TaxPer) / (100 + TaxPer);

            Amount1 = (Quantity * NetRate1) - TaxAmount1;

            TotalAmount = (Quantity * NetRate1) +
                TaxAmount1; //getNumber(TaxAmount1,precision: 2);

            InclusiveItemWiseHeaderDisAmnt =
                (TotalAmount * Hdrdis) / TotEXINNetmant;
            InclusiveItemWiseAmount = Quantity * NetRate1;
            InclusiveNetAmntAfterHeaderDisAmnt =
                InclusiveItemWiseAmount - InclusiveItemWiseHeaderDisAmnt;
            InclusiveTaxPluse100 = 100 + TaxPer;
            InclusiveItemWiseTaxAmnt =
                (InclusiveNetAmntAfterHeaderDisAmnt * TaxPer) /
                    InclusiveTaxPluse100;
            InclusiveFinalNetAmntAfterHeaderDisAmnt =
                InclusiveNetAmntAfterHeaderDisAmnt - InclusiveItemWiseTaxAmnt;
            InclusiveTotalNetAmntAfterHeaderDisAmnt =
                InclusiveNetAmntAfterHeaderDisAmnt; //+ InclusiveItemWiseTaxAmnt;

            print("dsljf333" +
                InclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsExponential(
                    2));

            _amountController.text =
                InclusiveFinalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2);
            _taxAmountController.text =
                InclusiveItemWiseTaxAmnt.toStringAsFixed(2);
            _totalAmountController.text =
                InclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2);
          }
        }
      });
    }
  }

  Widget Finish(String Category,
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
            onTap: () => isForUpdate == true
                ? edt_Finish_Name.text
                : _inquiryBloc.add(HplFinishListRequestEvent(
                    HplFinishListRequest(
                        pkID: 0.toString(),
                        SearchKey: "",
                        PageNo: 1.toString(),
                        PageSize: 100000.toString(),
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
                    height: CardViewHeight,
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
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  void _onFinishCallSuccess(HplFinishListResponseState state) {
    arr_ALL_Name_ID_For_Finish.clear();
    //if (arr_ALL_Name_ID_For_Finish.isNotEmpty) {
    for (var i = 0; i < state.response.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.pkID = state.response.details[i].pkID;
      all_name_id.Name = state.response.details[i].finishName;
      arr_ALL_Name_ID_For_Finish.add(all_name_id);
    }
    showcustomdialogWithID(
        values: arr_ALL_Name_ID_For_Finish,
        context1: context,
        controller: edt_Finish_Name,
        controllerID: edt_Finish_ID,
        lable: "Select Finish");
  } /*else {
      showCommonDialogWithSingleOption(context, "FinishList is Empty",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
    }
    */

  Widget Thickness(String Category,
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
            onTap: () => isForUpdate == true
                ? edt_Thickness_Name.text
                : _inquiryBloc.add(HplThicknessListRequestEvent(
                    HplThicknessListRequest(
                        pkID: 0.toString(),
                        SearchKey: "",
                        PageNo: 1.toString(),
                        PageSize: 100000.toString(),
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
                    height: CardViewHeight,
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
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  void _onThicknessCallSuccess(HplThicknessListResponseState state) {
    arr_ALL_Name_ID_For_Thickness.clear();
    if (state.response.details.isNotEmpty) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = new ALL_Name_ID();
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name = state.response.details[i].thicknessName;
        arr_ALL_Name_ID_For_Thickness.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_Thickness,
          context1: context,
          controller: edt_Thickness_Name,
          controllerID: edt_Thickness_ID,
          lable: "Select Thickness");
    } else {
      showCommonDialogWithSingleOption(context, "Thickness List is Empty",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  Widget size1(String Category,
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
            onTap: () => isForUpdate == true
                ? edt_Size_Name.text
                : _inquiryBloc.add(HplSizeListRequestEvent(HplSizeListRequest(
                    pkID: 0.toString(),
                    SearchKey: "",
                    PageNo: 1.toString(),
                    PageSize: 100000.toString(),
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
                    height: CardViewHeight,
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
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  void _onSizeCallSuccess(HplSizeListResponseState state) {
    arr_ALL_Name_ID_For_Size.clear();
    if (state.response.details.isNotEmpty) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = new ALL_Name_ID();
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name = state.response.details[i].sizeName;
        arr_ALL_Name_ID_For_Size.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_Size,
          context1: context,
          controller: edt_Size_Name,
          controllerID: edt_Size_ID,
          lable: "Select Size");
    } else {
      showCommonDialogWithSingleOption(context, "SizeList is Empty",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  Widget Grade(String Category,
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
            onTap: () => isForUpdate == true
                ? edt_Grade_Name.text
                : _inquiryBloc.add(HplGradeListRequestEvent(HplGradeListRequest(
                    pkID: 0.toString(),
                    SearchKey: "",
                    PageNo: 1.toString(),
                    PageSize: 100000.toString(),
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
                    height: CardViewHeight,
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
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  void _onGradeCallSuccess(HplGradeListResponseState state) {
    arr_ALL_Name_ID_For_Grade.clear();
    if (state.response.details.isNotEmpty) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = new ALL_Name_ID();
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name = state.response.details[i].gradeName;
        arr_ALL_Name_ID_For_Grade.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_Grade,
          context1: context,
          controller: edt_Grade_Name,
          controllerID: edt_Grade_ID,
          lable: "Select Grade");
    } else {
      showCommonDialogWithSingleOption(context, "GradeList is Empty",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  Widget Design(String Category,
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
            onTap: () => isForUpdate == true
                ? edt_Design_Name.text
                : _inquiryBloc.add(HplDesignListRequestEvent(
                    HplDesignListRequest(
                        pkID: 0.toString(),
                        SearchKey: "",
                        PageNo: 1.toString(),
                        PageSize: 100000.toString(),
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
                    height: CardViewHeight,
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
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  void _onDesignCallSuccess(HplDesignListResponseState state) {
    arr_ALL_Name_ID_For_Design.clear();
    if (state.response.details.isNotEmpty) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = new ALL_Name_ID();
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name = state.response.details[i].designName;
        arr_ALL_Name_ID_For_Design.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_Design,
          context1: context,
          controller: edt_Design_Name,
          controllerID: edt_Design_ID,
          lable: "Select Design");
    } else {
      showCommonDialogWithSingleOption(context, "Design List is Empty",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  TotalAmountCalculation() async {
    ProductCalculationModel productoutparam =
        productCalculation.funCalculateProduct(
      UnitQuantity: 1,
      TaxType: int.parse(
          _taxTypeController.text == "" ? "0" : _taxTypeController.text),
      Qty: double.parse(
          _quantityController.text == "" ? "0.00" : _quantityController.text),
      Rate: double.parse(
          _unitPriceController.text == "" ? "0.00" : _unitPriceController.text),
      ItmDiscPer: double.parse(
          _discPerController.text == "" ? "0.00" : _discPerController.text),
      ItmDiscAmt: 0,
      TaxPer: double.parse(
          _taxPerController.text == "" ? "0.00" : _taxPerController.text),
      AddTaxPer: 0,
      HdDiscAmt: 0,
      CustomerStateId: edt_StateCode.text,
      CompanyStateId: _offlineLoggedInData.details[0].stateCode.toString(),
      TaxAmt: 0,
      CGSTPer: 0,
      CGSTAmt: 0,
      SGSTPer: 0,
      SGSTAmt: 0,
      IGSTPer: 0,
      IGSTAmt: 0,
      NetRate: 0,
      BasicAmt: 0,
      NetAmt: 0,
      ItmDiscPer1: 0,
      ItmDiscAmt1: 0,
      AddTaxAmt: 0,
    );
    _netRateController.text = productoutparam.NetRate.toString();
    _amountController.text = productoutparam.BasicAmt.toString();
    _taxAmountController.text = productoutparam.TaxAmt.toString();
    _totalAmountController.text = productoutparam.NetAmt.toString();
    _discAmountController.text = productoutparam.ItmDiscAmt1.toString();

    edt_CGST_Per.text = productoutparam.CGSTPer.toString();
    edt_SGST_Per.text = productoutparam.SGSTPer.toString();
    edt_CGST_Amount.text = productoutparam.CGSTAmt.toString();
    edt_SGST_Amount.text = productoutparam.SGSTAmt.toString();
    edt_IGST_Per.text = productoutparam.IGSTPer.toString();
    edt_IGST_Amount.text = productoutparam.IGSTAmt.toString();

    print("CGST" + productoutparam.CGSTPer.toString());
  }

  double getNumber(double input, {int precision = 2}) => double.parse(
      '$input'.substring(0, '$input'.indexOf('.') + precision + 1));

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<QuotationTable1> temp =
        await OfflineDbHelper.getInstance().getHplQuotationProduct();
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

  Future<void> getInquiryDetailsFromDb() async {
    //_inquiryProductList.clear();
    List<QuotationTable1> temp =
        await OfflineDbHelper.getInstance().getHplQuotationProduct();
    //_inquiryProductList.addAll(temp);
    // txt_TotalNetAmnt.text = "0.00";

    for (int i = 0; i < temp.length; i++) {
      TotalNetAmnt = TotalNetAmnt + temp[i].NetAmount;
    }

    // txt_TotalNetAmnt.text =TotalNetAmnt.toStringAsFixed(2);
    print("GetNetAMnt" + "Total NetAmnt : " + TotalNetAmnt.toStringAsFixed(2));
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    String removedHTML = htmlText.replaceAll(exp, '');
    return removedHTML;
  }

  void _OnGetProductSpecificationResponse(
      SpecificationListResponseState state) {
    if (state.response.details.length != 0) {
      for (int i = 0; i < state.response.details.length; i++) {
        /*QuotationSpecificationTable quotationSpecificationTable =
            QuotationSpecificationTable(
          state.response.details[i].itemOrder.toString(),
          state.response.details[i].groupHead.toString(),
          state.response.details[i].materialHead.toString(),
          state.response.details[i].materialSpec.toString(),
          "",

          state.response.details[i].quotationNo.toString(),
          state.response.details[i].finishProductID.toString(),
        );
*/
        print("ssfsfd342ed34" +
            state.response.details[i].finishProductID.toString());
        /* _inquiryBloc.add(InsertQuotationSpecificationTableEvent(
            quotationSpecificationTable));*/
      }
    }
  }
}
