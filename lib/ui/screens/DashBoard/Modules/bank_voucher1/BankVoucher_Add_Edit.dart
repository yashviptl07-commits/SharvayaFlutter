import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/Model_Classis_Fro_ODB/bank_voucher_detail_model.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_Bank_Voucher_Add_Update_request.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_Bank_Voucher_Details_List_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/transection_mode_list_request.dart';
import 'package:soleoserp/models/api_responses/Mayank_BankVoucher_Response/Mayank_BankVoucher_List_Respnse.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/bank_voucher1/BankVoucher_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/bank_voucher1/bank_details_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/search_followup_customer_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class AddUpdateVehiclePunchArguments2 {
  MayankBankVoucherListDetails editModel;
  AddUpdateVehiclePunchArguments2(this.editModel);
}

class MayankBankVoucherAddEdit extends BaseStatefulWidget {
  static const routeName = '/MayankBankVoucherAddEdit';
  final AddUpdateVehiclePunchArguments2 arguments;

  MayankBankVoucherAddEdit(this.arguments);

  @override
  _MayankBankVoucherAddEditScreen createState() =>
      _MayankBankVoucherAddEditScreen();
}

class _MayankBankVoucherAddEditScreen
    extends BaseState<MayankBankVoucherAddEdit>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
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
  MayankBankVoucherListDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  List<BankVoucherDetailsTable> _inquiryProductList = [];
  bool isCompare;

  final TextEditingController edt_EmployeeName = TextEditingController();
  final TextEditingController edt_EmployeeID = TextEditingController();
  final TextEditingController edt_VoucherNo = TextEditingController();
  final TextEditingController edt_VoucherAmount = TextEditingController();
  final TextEditingController edt_TDSAc = TextEditingController();
  final TextEditingController edt_TDSAcId = TextEditingController();
  final TextEditingController edt_TDSAmount = TextEditingController();
  final TextEditingController edt_Priority = TextEditingController();
  final TextEditingController edt_Bank_A_C = TextEditingController();
  final TextEditingController edt_Bank_A_C_ID = TextEditingController();
  final TextEditingController edt_TransactionNotes = TextEditingController();
  final TextEditingController edt_TransactionIDChequeNo =
      TextEditingController();
  final TextEditingController edt_BankPortalPaymentAppName =
      TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_Voucher_date = TextEditingController();
  final TextEditingController edt_Reverse_Voucher_date =
      TextEditingController();
  final TextEditingController edt_TransactionDateChequeDate_date =
      TextEditingController();
  final TextEditingController edt_Reverse_TransactionDateChequeDate_date =
      TextEditingController();
  final TextEditingController edt_PreferedTime = TextEditingController();
  final TextEditingController edt_TransectionMode_ID = TextEditingController();
  final TextEditingController edt_TransectionMode_Name =
      TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Select_vehicleID = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_vehicle = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Country = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TransectionModeList = [];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _mainBloc = MainBloc(baseBloc);
    myFocusNode = FocusNode();
    PicCodeFocus = FocusNode();
    isCompare = false;
    FetchFollowupPriorityDetails();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    // edt_Priority.addListener(() {
    //   NotesFocusNode.requestFocus();
    // });

    edt_Priority.text = "Receivable";
    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      edt_Voucher_date.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_Reverse_Voucher_date.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      edt_TransactionDateChequeDate_date.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_Reverse_TransactionDateChequeDate_date.text =
          selectedDate.year.toString() +
              "-" +
              selectedDate.month.toString() +
              "-" +
              selectedDate.day.toString();

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
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is MayankBankVoucherDetailsListResponseState) {
            _OnCustomerIdToFetchContactDetails(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MayankBankVoucherDetailsListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is MayankTransectionModeResponseState) {
            _onTransactionModeCallSuccess(state);
          }
          if (state is MayankBankVoucherSaveResponseState) {
            _onBankVoucherSaveResponse(state);
          }
          if (state is MayankBankVoucherDetailsAddEditResponseState1) {
            _OnInquiryProductSaveResponse(state);
          }

          /*if (state is VehiclePunchVehicleDropdownResponseState) {
            _onVehicleDropDown(state);
          }
          if (state is VehiclePunchAddEditResponseState) {
            _onVehiclePunchAddEdit(state);
          }*/
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MayankTransectionModeResponseState) {
            return true;
          }
          if (currentState is MayankBankVoucherSaveResponseState) {
            return true;
          }
          if (currentState is MayankBankVoucherDetailsAddEditResponseState1) {
            return true;
          }

          /*if (currentState is VehiclePunchVehicleDropdownResponseState) {
            return true;
          }
          if (currentState is VehiclePunchAddEditResponseState) {
            return true;
          }*/
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
          title: Text('Manage Bank Voucher'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          leading: InkWell(
              onTap: () async {
                await _onTapOfDeleteALLContact();
                navigateTo(context, MayankBankVoucherListScreen.routeName,
                    clearAllStack: true);
              },
              child: Icon(Icons.arrow_back_outlined)),
          actions: <Widget>[
            SizedBox(
              width: 10,
            ),
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                  size: 30,
                ),
                onPressed: () {}),
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
                    /*CustomDropDownVehical(
                      "Vehicle",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                      controllerVehical: edt_vehicle,
                      vehicalList: arr_ALL_Name_ID_For_vehicle,
                    ),*/
                    PunchDate(),
                    SizedBox(height: 15),
                    VoucherNo(),
                    SizedBox(height: 15),
                    CustomDropDown1("Rec./Pay.",
                        enable1: false,
                        title: "Rec./Pay.",
                        hintTextvalue: "Tap to Select Rec./Pay.",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_Priority,
                        Custom_values1: arr_ALL_Name_ID_For_Folowup_Priority),
                    SizedBox(height: 15),
                    _buildEmployeeListView(),
                    SizedBox(height: 15),
                    _buildBankACSearchView(),
                    SizedBox(height: 15),
                    _buildSearchView(),
                    SizedBox(height: 15),
                    VoucherAmount(),
                    SizedBox(height: 15),
                    TDSAc(),
                    SizedBox(height: 15),
                    TDSAmount(),
                    SizedBox(height: 15),
                    showcustomdialogWithID1("Transaction Mode",
                        enable1: false,
                        title: "Transaction Mode *",
                        hintTextvalue: "--- Select TransactionMode ---",
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: colorPrimary,
                        ),
                        controllerForLeft: edt_TransectionMode_Name,
                        controllerpkID: edt_TransectionMode_ID,
                        Custom_values1:
                            arr_ALL_Name_ID_For_TransectionModeList),
                    SizedBox(height: 15),
                    BankPortalPaymentAppName(),
                    SizedBox(height: 15),
                    TransactionIDChequeNo(),
                    SizedBox(height: 15),
                    TransactionDateChequeDate(),
                    SizedBox(height: 15),
                    TransactionNotes(),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        CustomerId = edt_CustomerpkID.text.isNotEmpty
                            ? int.parse(edt_CustomerpkID.text)
                            : 0;
                        navigateTo(
                            //MaintenanceDetailsListScreen
                            context,
                            MaintenanceDetailsListScreen.routeName,
                            arguments: MaintenanceDetailsListScreenArgument(
                                pkID, CustomerId));
                        //navigateTo(context, VehicleCheckList.routeName);
                      },
                      child: Card(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          elevation: 10,
                          color: colorYellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Icon(
                                  Icons.contact_phone_outlined,
                                  color: colorPrimary,
                                ),
                                SizedBox(
                                  width: 32,
                                ),
                                Text("Allocate Bill Wise Payment",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: colorPrimary,
                                        fontWeight: FontWeight.bold)),
                                Spacer(),
                                Icon(
                                  Icons.add,
                                  color: colorPrimary,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
                          )),
                    ),

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
                            backgroundColor: Color(0xff013220),
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

  Widget _buildBankACSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfBankACSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Account Name *",
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
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: edt_Bank_A_C,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Search Bank A/c",
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

  Future<void> _onTapOfBankACSearchView() async {
    navigateTo(context, SearchFollowupCustomerScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        edt_Bank_A_C_ID.text = _searchDetails.value.toString();
        edt_Bank_A_C.text = _searchDetails.label.toString();

        _mainBloc.add(MayankSearchBankVoucherCustomerListByNameCallEvent(
            CustomerLabelValueRequest(
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID.toString(),
                word: _searchDetails.value.toString())));
      }
      print("CustomerInfo : " +
          edt_Bank_A_C.text.toString() +
          " CustomerID : " +
          edt_Bank_A_C_ID.text.toString());
    });
  }

  Widget TDSAc() {
    return InkWell(
      onTap: () {
        _onTapOfBankACSearchView1();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("TDS A/c",
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
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: edt_TDSAc,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Search TDS A/c",
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

  Future<void> _onTapOfBankACSearchView1() async {
    navigateTo(context, SearchFollowupCustomerScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        edt_TDSAcId.text = _searchDetails.value.toString();
        edt_TDSAc.text = _searchDetails.label.toString();

        _mainBloc.add(MayankSearchBankVoucherCustomerListByNameCallEvent(
            CustomerLabelValueRequest(
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID.toString(),
                word: _searchDetails.value.toString())));
      }
      print("CustomerInfo : " +
          edt_TDSAc.text.toString() +
          " CustomerID : " +
          edt_TDSAcId.text.toString());
    });
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Customer A/c *",
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
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: edt_CustomerName,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Search customer",
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
    navigateTo(context, SearchFollowupCustomerScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        edt_CustomerpkID.text = _searchDetails.value.toString();
        edt_CustomerName.text = _searchDetails.label.toString();

        _mainBloc.add(MayankSearchBankVoucherCustomerListByNameCallEvent(
            CustomerLabelValueRequest(
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID.toString(),
                word: _searchDetails.value.toString())));
      }
      print("CustomerInfo : " +
          edt_CustomerName.text.toString() +
          " CustomerID : " +
          edt_CustomerpkID.text.toString());
    });
  }

  Widget VoucherNo() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Voucher No",
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
                          enabled: false,
                          controller: edt_VoucherNo,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: myFocusNode,
                          maxLength: 14,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "",
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

  Widget VoucherAmount() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Voucher Amount",
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
                          controller: edt_VoucherAmount,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          maxLength: 14,
                          decoration: InputDecoration(
                            counterText: "",
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
        ),
      ],
    ));
  }

  Widget TransactionNotes() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Transaction Notes *",
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
                height: 90,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_TransactionNotes,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Tap to enter Transaction Notes",
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
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    ));
  }

  Widget TDSAmount() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("TDS Amount",
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
                          controller: edt_TDSAmount,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          maxLength: 14,
                          decoration: InputDecoration(
                            counterText: "",
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
        ),
      ],
    ));
  }

  Widget BankPortalPaymentAppName() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Bank/Portal/Payment App. Name",
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
                          controller: edt_BankPortalPaymentAppName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLength: 14,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText:
                                "Tap to enter Bank/Portal/Payment AppName",
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

  Widget TransactionIDChequeNo() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Transaction ID/Cheque No",
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
                          controller: edt_TransactionIDChequeNo,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLength: 14,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Tap to enter Transaction ID/Cheque No",
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
            onTap: () => _mainBloc
              ..add(MayankTransectionModeCallEvent(TransectionModeListRequest(
                  LoginUserID: LoginUserID,
                  pkID: 0,
                  CompanyID: CompanyID.toString()))),
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

  void _onTransactionModeCallSuccess(MayankTransectionModeResponseState state) {
    arr_ALL_Name_ID_For_TransectionModeList.clear();
    for (var i = 0; i < state.transectionModeListResponse.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.pkID = state.transectionModeListResponse.details[i].pkID;
      all_name_id.Name =
          state.transectionModeListResponse.details[i].walletName;
      arr_ALL_Name_ID_For_TransectionModeList.add(all_name_id);
    }
    showcustomdialogWithID(
        values: arr_ALL_Name_ID_For_TransectionModeList,
        context1: context,
        controller: edt_TransectionMode_Name,
        controllerID: edt_TransectionMode_ID,
        lable: "Select Transaction Mode");
  }

  Widget CustomDropDown1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                lable: "Select $Category"),
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

  FetchFollowupPriorityDetails() {
    arr_ALL_Name_ID_For_Folowup_Priority.clear();
    for (var i = 0; i <= 1; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Receivable";
      } else if (i == 1) {
        all_name_id.Name = "Payable";
      }
      arr_ALL_Name_ID_For_Folowup_Priority.add(all_name_id);
    }
  }

  Widget _buildEmployeeListView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
        showcustomdialogWithID(
            values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
            context1: context,
            controller: edt_EmployeeName,
            controllerID: edt_EmployeeID,
            lable: "Select Employee");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Select Employee",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
              Icon(
                Icons.filter_list_alt,
                color: colorPrimary,
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
                      controller: edt_EmployeeName,
                      enabled: false,
                      style: TextStyle(
                          color: Colors.black, // <-- Change this

                          fontSize: 15),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "--- All Employee ---"),
                    ),
                    // dropdown()
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

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.pkID = state.details[i].pkID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
  }

  Widget PunchDate() {
    return InkWell(
      onTap: () {
        _PunchDate(context, edt_Voucher_date, edt_Reverse_Voucher_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Voucher Date *",
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
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_Voucher_date.text == null ||
                              edt_Voucher_date.text == ""
                          ? "YYYY-MM--DD"
                          : edt_Voucher_date.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_Reverse_Voucher_date.text == null ||
                                  edt_Reverse_Voucher_date.text == ""
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
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

  Future<void> _PunchDate(
      BuildContext context,
      TextEditingController edt_Voucher_date,
      TextEditingController edt_Reverse_Voucher_date) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        edt_Voucher_date.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_Reverse_Voucher_date.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Widget TransactionDateChequeDate() {
    return InkWell(
      onTap: () {
        _TransactionDateChequeDate(context, edt_TransactionDateChequeDate_date,
            edt_Reverse_TransactionDateChequeDate_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Transaction Date/Cheque Date *",
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
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_TransactionDateChequeDate_date.text == null ||
                              edt_TransactionDateChequeDate_date.text == ""
                          ? "YYYY-MM--DD"
                          : edt_TransactionDateChequeDate_date.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_TransactionDateChequeDate_date.text ==
                                      null ||
                                  edt_TransactionDateChequeDate_date.text == ""
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
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

  Future<void> _TransactionDateChequeDate(
      BuildContext context,
      TextEditingController edt_TransactionDateChequeDate_date,
      TextEditingController edt_Reverse_TransactionDateChequeDate_date) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        edt_TransactionDateChequeDate_date.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_Reverse_TransactionDateChequeDate_date.text =
            selectedDate.year.toString() +
                "-" +
                selectedDate.month.toString() +
                "-" +
                selectedDate.day.toString();
      });
  }

/*  Future<void> _TransactionDateChequeDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_TransactionDateChequeDate_date.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_Reverse_TransactionDateChequeDate_date.text =
            selectedDate.year.toString() +
                "-" +
                selectedDate.month.toString() +
                "-" +
                selectedDate.day.toString();
      });
  }*/

  Widget CustomDropDownVehical(
    String Outsource, {
    bool enable1,
    Icon icon,
    TextEditingController controllerVehical,
    List<ALL_Name_ID> vehicalList,
  }) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => _mainBloc.add(
                MayankSearchBankVoucherCustomerListByNameCallEvent(
                    CustomerLabelValueRequest(
                        CompanyId: CompanyID.toString(),
                        LoginUserID: LoginUserID.toString(),
                        word: _searchDetails.value.toString()))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Select Vehicle",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
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
                  color: Color(0xffe6f3f3),
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
                              controller: controllerVehical,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "---select---",
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

  Widget _buildPreferredTime() {
    return InkWell(
      onTap: () {
        _selectTime(context, edt_PreferedTime);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text("PunchTime",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            margin: EdgeInsets.only(left: 15, right: 15),
            elevation: 5,
            color: Color(0xffe6f3f3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_PreferedTime.text == null ||
                              edt_PreferedTime.text == ""
                          ? "HH:MM:SS"
                          : edt_PreferedTime.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_PreferedTime.text == null ||
                                  edt_PreferedTime.text == ""
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.watch_later_outlined,
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

  Future<void> _selectTime(BuildContext contextdialog,
      TextEditingController F_datecontroller) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: contextdialog,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(contextdialog)
                .copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;

        String AM_PM =
            selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
        String beforZeroHour = selectedTime.hourOfPeriod <= 9
            ? "0" + selectedTime.hourOfPeriod.toString()
            : selectedTime.hourOfPeriod.toString();
        String beforZerominute = selectedTime.minute <= 9
            ? "0" + selectedTime.minute.toString()
            : selectedTime.minute.toString();

        edt_PreferedTime.text = beforZeroHour +
            ":" +
            beforZerominute +
            " " +
            AM_PM; //picked_s.periodOffset.toString();
      });
  }

  _onTapOfSaveVehiclePunchAPICall() async {
    await getContacts();

    bool isValidateAmount = false;
    double totalAmount = 0.00;

    if (_inquiryProductList.length != 0) {
      for (int i = 0; i < _inquiryProductList.length; i++) {
        print("Amount" + _inquiryProductList[0].Amount);
        totalAmount += double.parse(_inquiryProductList[i].Amount);
      }
      if (totalAmount == double.parse(edt_VoucherAmount.text)) {
        isValidateAmount = true;
      } else {
        isValidateAmount = false;
      }
      print("TAmount" +
          totalAmount.toString() +
          "VAmount" +
          edt_VoucherAmount.text);
    } else {
      isValidateAmount = true;
    }

    if (edt_Bank_A_C.text.toString() != "") {
      if (edt_CustomerName.text.toString() != "") {
        if (edt_VoucherAmount.text.toString() != "") {
          if (edt_TransectionMode_Name.text.toString() != "") {
            if (edt_TransactionNotes.text.toString() != "") {
              if (isValidateAmount == true) {
                showCommonDialogWithTwoOptions(
                    context, "Are you sure you want to Save this record ?",
                    negativeButtonTitle: "No",
                    positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                  _mainBloc.add(MayankBankVoucherSaveCallEvent(
                      MayankBankVoucherAddEditRequest(
                          pkID: pkID.toString(),
                          VoucherType: "Bank",
                          RecPay:
                              edt_Priority.text == "" ? "" : edt_Priority.text,
                          VoucherNo: edt_VoucherNo.text,
                          VoucherDate: edt_Reverse_Voucher_date.text,
                          AccountID: edt_Bank_A_C_ID.text == ""
                              ? ""
                              : edt_Bank_A_C_ID.text,
                          CustomerID: edt_CustomerpkID.text == ""
                              ? ""
                              : edt_CustomerpkID.text,
                          TDSAccountID:
                              edt_TDSAcId.text == "" ? "" : edt_TDSAcId.text,
                          TransType: "acc",
                          TransModeID: edt_TransectionMode_ID.text == ""
                              ? ""
                              : edt_TransectionMode_ID.text,
                          TransID: edt_TransactionIDChequeNo.text == ""
                              ? ""
                              : edt_TransactionIDChequeNo.text,
                          EmployeeID: edt_EmployeeID.text == ""
                              ? ""
                              : edt_EmployeeID.text,
                          TransDate:
                              edt_Reverse_TransactionDateChequeDate_date.text,
                          TDSAmount: edt_TDSAmount.text == ""
                              ? "0.00"
                              : edt_TDSAmount.text.toString(),
                          VoucherAmount: edt_VoucherAmount.text,
                          BankName: edt_BankPortalPaymentAppName.text,
                          Remark: edt_TransactionNotes.text,
                          RDURD: "",
                          BasicAmt: edt_VoucherAmount.text,
                          NetAmt: edt_VoucherAmount.text,
                          SGSTPer: "0",
                          SGSTAmt: "0",
                          CGSTPer: "0",
                          CGSTAmt: "0",
                          IGSTPer: "0",
                          IGSTAmt: "0",
                          LoginUserID: LoginUserID,
                          CompanyId: CompanyID.toString(),
                          TerminationOfDelivery: "0")));
                });
              } else {
                showCommonDialogWithSingleOption(context,
                    "Distributed Amount Is Not Matching With Payment Amount",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                });
              }
            } else {
              showCommonDialogWithSingleOption(
                  context, "Transaction Note Is required",
                  positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                Navigator.of(context).pop();
              });
            }
          } else {
            showCommonDialogWithSingleOption(
                context, "Please Select TransactionMode",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
            });
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Voucher amount Must be Grater Than Zero",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }
      } else {
        showCommonDialogWithSingleOption(
            context, "Please Select Transaction Mode",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showCommonDialogWithSingleOption(
          context, "Please Select Proper Debit Account",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  Future<bool> _onBackPressed() async {
    await _onTapOfDeleteALLContact();
    navigateTo(context, MayankBankVoucherListScreen.routeName,
        clearAllStack: true);
  }

  _onTapOfAdd(String InvoiceNo, String Amount) async {
    await OfflineDbHelper.getInstance()
        .insertBankVoucher(BankVoucherDetailsTable(
      "0",
      "",
      InvoiceNo,
      Amount,
      "",
      "",
    ));
  }

  Future<void> _onTapOfDeleteALLContact() async {
    await OfflineDbHelper.getInstance().deleteAllBankVoucher();
  }

  _OnCustomerIdToFetchContactDetails(
      MayankBankVoucherDetailsListResponseState state) {
    print(state.detailsResponse);
  }

  void _onBankVoucherSaveResponse(MayankBankVoucherSaveResponseState state) {
    showCommonDialogWithSingleOption(context,
        state.mayankBankVoucherAddEditResponse.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
      await _onTapOfDeleteALLContact;
      navigateTo(context, MayankBankVoucherListScreen.routeName,
          clearAllStack: true);
    });
  }

  Future<void> getContacts() async {
    _inquiryProductList.clear();
    List<BankVoucherDetailsTable> temp =
        await OfflineDbHelper.getInstance().getBankVoucher();
    _inquiryProductList.addAll(temp);
    setState(() {});
  }

  _OnInquiryProductSaveResponse(
      MayankBankVoucherDetailsAddEditResponseState1 state) async {
    showCommonDialogWithSingleOption(
        context, state.response.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, MayankBankVoucherListScreen.routeName,
          clearAllStack: true);
    });
  }

  void fillData() async {
    pkID = _editModel.pkID;

    edt_Voucher_date.text = _editModel.voucherDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_Voucher_date.text = _editModel.voucherDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_TransactionDateChequeDate_date.text = _editModel.voucherDate
        .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_TransactionDateChequeDate_date.text = _editModel.voucherDate
        .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_VoucherNo.text = _editModel.voucherNo;
    edt_Priority.text = _editModel.recPay;
    edt_EmployeeName.text = _editModel.employeeName;
    edt_EmployeeID.text = _editModel.employeeID.toString();
    edt_Bank_A_C_ID.text = _editModel.accountID.toString();

    edt_Bank_A_C.text = _editModel.accountName;
    edt_CustomerName.text = _editModel.customerName;
    edt_CustomerpkID.text = _editModel.customerID.toString();
    edt_VoucherAmount.text = _editModel.voucherAmount.toString();

    edt_TDSAc.text = _editModel.tDSAccountName;
    edt_TDSAcId.text = _editModel.tDSAccountID.toString();
    edt_TDSAmount.text = _editModel.tDSAmount.toString();
    edt_TransectionMode_Name.text = _editModel.transModeName;
    edt_TransectionMode_ID.text = _editModel.transModeID.toString();
    edt_BankPortalPaymentAppName.text = _editModel.bankName;
    edt_TransactionIDChequeNo.text = _editModel.transID;
    edt_TransactionNotes.text = _editModel.remark;

    if (_editModel.pkID.toString() != '') {
      _mainBloc.add(MayankBankVoucherDetailsListEvent(
          1,
          MayankBankVoucherDetailsListRequest(
              ParentID: _editModel.pkID,
              InvoiceNo: "",
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString())));
    }
  }
}
