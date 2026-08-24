// AddMaintenanceDetailsScreen AddMaintenanceDetailsScreenArguments MaintenanceDetailsTable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/Model_Classis_Fro_ODB/bank_voucher_detail_model.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_Bank_Voucher_Pending_Amount_request.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Maynak_Inq_No_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class AddMaintenanceDetailsScreenArguments {
  int pkId;
  String CustomerId;
  AddMaintenanceDetailsScreenArguments(this.pkId, this.CustomerId);
}

class AddMaintenanceDetailsScreen extends BaseStatefulWidget {
  static const routeName = '/AddMaintenanceDetailsScreen';
  final AddMaintenanceDetailsScreenArguments arguments;

  AddMaintenanceDetailsScreen(this.arguments);

  @override
  _AddMaintenanceDetailsScreenState createState() =>
      _AddMaintenanceDetailsScreenState();
}

class _AddMaintenanceDetailsScreenState
    extends BaseState<AddMaintenanceDetailsScreen>
    with BasicScreen, WidgetsBindingObserver {
  //DesignationApiResponse _offlineCustomerDesignationData;

  final TextEditingController edt_InvoiceNo_ID = TextEditingController();
  final TextEditingController edt_InvoiceNo = TextEditingController();
  final TextEditingController edt_Amount = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_InvoiceNo = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_InvoiceNo1 = [];

  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";

  final _formKey = GlobalKey<FormState>();
  bool isForUpdate = false;
  bool isProductExist = false;
  MainBloc _inquiryBloc;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Designation = [];
  double airFlow;
  double velocity;
  double valueFinal;
  String sam, sam2;
  int pkID = 0;
  String CustomerId = "";
  FocusNode QuantityFocusNode;
  String airFlowText, velocityText, finalText;
  List<BankVoucherDetailsTable> _inquiryProductList = [];

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    screenStatusBarColor = colorWhite;
    widget.arguments.pkId;
    print("bvhvdvhdv" + widget.arguments.CustomerId.toString());
    widget.arguments.CustomerId;
    pkID = widget.arguments.pkId;
    CustomerId = widget.arguments.CustomerId;
    if (widget.arguments != null) {}
    _inquiryBloc = MainBloc(baseBloc);
    QuantityFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
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
        listener: (BuildContext context, MainStates state) {
          if (state is MayankBankVoucherModeResponseState) {
            _onTransactionModeCallSuccess(state);
          }
          if (state is MayankBankVoucherAmountResponseState) {
            _onTransactionModeCallSuccess1(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MayankBankVoucherModeResponseState) {
            return true;
          }
          if (currentState is MayankBankVoucherAmountResponseState) {
            return true;
          }
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
        getCommonAppBar(
            context, baseTheme, "Allocate Bill Wise Payment details",
            showBack: true, showHome: true),
        Expanded(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  showcustomdialogWithID1("Invoice No",
                      enable1: false,
                      title: "Invoice No",
                      hintTextvalue: "Tap to Select Transaction Mode",
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: colorPrimary,
                      ),
                      controllerForLeft: edt_InvoiceNo,
                      controllerpkID: edt_InvoiceNo_ID,
                      Custom_values1: arr_ALL_Name_ID_For_InvoiceNo),
                  SizedBox(height: 10),
                  vehicleSubType(),
                  SizedBox(height: 25),
                  Container(
                    height: 50,
                    width: 140,
                    child: ElevatedButton(
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        _onTapOfSaveData();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff013220),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
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
      if (isProductExist == false) {
        await OfflineDbHelper.getInstance()
            .insertBankVoucher(BankVoucherDetailsTable(
          "0", //pkID
          "", //ParentID
          edt_InvoiceNo.text, //InvoiceNo
          edt_Amount.text, //Amount
          "", //LoginUserID
          "", //CompanyId
        ));
        Navigator.of(context).pop();
      } else {
        showCommonDialogWithSingleOption(
            context, "Duplicate Data Not Allowed...",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  _onTapOfSaveData() {
    if (edt_InvoiceNo.text != "") {
      if (edt_Amount.text != "") {
        showCommonDialogWithTwoOptions(
            context, "Are you sure you want to Save this record ?",
            negativeButtonTitle: "No",
            positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
          _onTapOfAdd();
        });
      } else {
        showCommonDialogWithSingleOption(context, "Amount Is required",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "Invoice No Is required",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  showcustomdialogWithOnlyName(
      {List<ALL_Name_ID> values,
      BuildContext context1,
      TextEditingController controller,
      String lable}) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorPrimary, //                   <--- border color
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                        15.0) //                 <--- border radius here
                    ),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    lable,
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(children: <Widget>[
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context1).pop();
                                  controller.text = values[index].Name;
                                  _inquiryBloc.add(
                                      MayankBankVoucherAmountCallEvent(
                                          MayankBankVoucherAmountRequest(
                                              InvoiceNo: values[index].Name,
                                              Mode: "sales",
                                              LoginUserID: LoginUserID,
                                              CompanyId: CompanyID)));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 25, top: 10, bottom: 10, right: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorPrimary), //Change color
                                        width: 10.0,
                                        height: 10.0,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 1.5),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        values[index].Name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: colorPrimary, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: values.length,
                          ),
                        ])),
                  ],
                )),
          ],
        );
      },
    );
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
            onTap: () => _inquiryBloc.add(MayankBankVoucherModeCallEvent(
                MayankBankVoucherInqNoRequest(
                    CustomerID: CustomerId,
                    Mode: "sales",
                    LoginUserID: LoginUserID,
                    CompanyId: CompanyID))),
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
                    height: 45,
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
                                contentPadding:
                                    EdgeInsets.only(bottom: 12, top: 12),
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

  void _onTransactionModeCallSuccess(MayankBankVoucherModeResponseState state) {
    arr_ALL_Name_ID_For_InvoiceNo.clear();
    for (var i = 0;
        i < state.mayankBankVoucherInqNoResponse.details.length;
        i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.Name =
          state.mayankBankVoucherInqNoResponse.details[i].invoiceNo;
      arr_ALL_Name_ID_For_InvoiceNo.add(all_name_id);
    }
    showcustomdialogWithOnlyName(
        values: arr_ALL_Name_ID_For_InvoiceNo,
        context1: context,
        controller: edt_InvoiceNo,
        lable: "Select Transaction Mode");
  }

  Widget vehicleSubType() {
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
          margin: EdgeInsets.only(left: 10, right: 10),
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 45,
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
                      controller: edt_Amount,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 5, bottom: 12, top: 12),
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

  void _onTransactionModeCallSuccess1(
      MayankBankVoucherAmountResponseState state) {
    edt_Amount.text = state
        .mayankBankVoucherAmountResponse.details[0].invoiceAmount
        .toString();

    setState(() {});
  }

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<BankVoucherDetailsTable> temp =
        await OfflineDbHelper.getInstance().getBankVoucher();
    _inquiryProductList.addAll(temp);
    if (_inquiryProductList.length != 0) {
      for (var i = 0; i < _inquiryProductList.length; i++) {
        if (_inquiryProductList[i].InvoiceNo == edt_InvoiceNo.text.toString()) {
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

  bool checkExistProduct() {
    if (_inquiryProductList.length != 0) {
      for (var i = 0; i < _inquiryProductList.length; i++) {
        if (_inquiryProductList[i].Amount == edt_Amount.text.toString()) {
          return isProductExist = true;
        } else {
          return isProductExist = false;
        }
      }
    } else {
      return isProductExist = false;
    }
    setState(() {});
  }
}
