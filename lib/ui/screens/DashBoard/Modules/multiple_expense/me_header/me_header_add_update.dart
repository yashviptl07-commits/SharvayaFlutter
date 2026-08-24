import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_add_update_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_list_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/office_refType_from_customerID_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_list_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/office_refType_from_customerID_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_project_list_response.dart';
import 'package:soleoserp/models/common/multiple_expense_table.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/customer_search/customer_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/multiple_expense/me_detail/me_details_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/multiple_expense/me_header/me_header_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class MultiExpenseAddEditScreenArguments {
  MultiExpenseListResponseDetails editModel;
  MultiExpenseAddEditScreenArguments(this.editModel);
}

class MultiExpenseAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/MultiExpenseAddEditScreen';
  final MultiExpenseAddEditScreenArguments arguments;

  MultiExpenseAddEditScreen(this.arguments);

  @override
  _MultiExpenseAddEditScreenState createState() =>
      _MultiExpenseAddEditScreenState();
}

class _MultiExpenseAddEditScreenState
    extends BaseState<MultiExpenseAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  String EmployeeID = "";
  String SiteURL = "";
  bool _isForUpdate;
  FocusNode PicCodeFocus;
  FocusNode myFocusNode;
  int pkID = 0;
  MultiExpenseListResponseDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController edt_VoucherNo = TextEditingController();
  final TextEditingController edt_ClaimDate = TextEditingController();
  final TextEditingController edt_ReverseClaimDate = TextEditingController();
  final TextEditingController edt_FromDate = TextEditingController();
  final TextEditingController edt_ReverseFromDate = TextEditingController();
  final TextEditingController edt_ToDate = TextEditingController();
  final TextEditingController edt_ReverseToDate = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerId = TextEditingController();
  final TextEditingController edt_OfficeRefNo = TextEditingController();
  final TextEditingController edt_ExpenseNotes = TextEditingController();
  final TextEditingController edt_AdvanceAmount = TextEditingController();
  final TextEditingController edt_ProjectID = TextEditingController();
  final TextEditingController edt_ProjectName = TextEditingController();

  static const String kRefTypeSalesOrder = "Sales Order";
  static const String kRefTypeProjects = "Projects";

  final List<String> _officeRefTypeList = <String>[
    kRefTypeSalesOrder,
    kRefTypeProjects,
  ];
  String _selectedOfficeRefType = "";
  List<OfficeRefTypeFromCustomerIDResponseDetails> _officeRefNoList = [];
  List<QuotationProjectDetails> _quotationProjectList = [];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    EmployeeID = _offlineLoggedInData.details[0].employeeID.toString();
    SiteURL = _offlineCompanyData.details[0].siteURL;
    _mainBloc = MainBloc(baseBloc);

    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      edt_ClaimDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();

      edt_ReverseClaimDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      edt_FromDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();

      edt_ReverseFromDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      edt_ToDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();

      edt_ReverseToDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      _selectedOfficeRefType = kRefTypeSalesOrder;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          //
          if (state is MultiExpenseADetailsListResponseState) {
            _onMultiExpenseADetailsListResponseStateCallSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MultiExpenseADetailsListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is MultiExpenseAddUpUpdateResponseState) {
            _onMultiExpenseAddUpUpdateResponseStateCallSuccess(state);
          } else if (state is OfficeRefTypeFromCustomerIDResponseState) {
            _onOfficeRefTypeFromCustomerIDResponseSuccess(state);
          } else if (state is QuotationProjectListResponseState) {
            _onQuotationProjectListResponseStateSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MultiExpenseAddUpUpdateResponseState) {
            return true;
          }
          if (currentState is OfficeRefTypeFromCustomerIDResponseState) {
            return true;
          }
          if (currentState is QuotationProjectListResponseState) {
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
          title: Text(
              'Multiple Expense ${_isForUpdate == true ? "Update" : "Add"}'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: InkWell(
              onTap: () async {
                _onTapOfDeleteALLMultipleExpense();
                navigateTo(context, MultiExpenseListScreen.routeName);
              },
              child: Icon(Icons.arrow_back_outlined)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () {
                  _onTapOfDeleteALLMultipleExpense();
                  navigateTo(context, HomeScreen.routeName,
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
                    _isForUpdate ? VoucherNo() : Container(),
                    SizedBox(height: 10),
                    ClaimDate(),
                    SizedBox(height: 10),
                    CustomerSearchView(),
                    SizedBox(height: 10),
                    OfficeRefTypeDropdown(),
                    SizedBox(height: 10),
                    OfficeRefNoDropdown(),
                    if (_selectedOfficeRefType == kRefTypeProjects)
                      Column(
                        children: [
                          SizedBox(height: 10),
                          ProjectNameDropdown(),
                        ],
                      ),
                    SizedBox(height: 10),
                    FromDate(),
                    SizedBox(height: 10),
                    ToDate(),
                    SizedBox(height: 10),
                    ExpenseNotes(),
                    SizedBox(height: 30),
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          navigateTo(
                            context,
                            MultipleExpenseDetailsScreen.routeName,
                            arguments: MultipleExpenseDetailsScreenArgument(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorBackGroundGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text(
                          "Expense Details Screen",
                          style: TextStyle(color: colorBlack),
                        ),
                      ),
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
                            backgroundColor: colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectNextFollowupDate(BuildContext context,
      TextEditingController F_datecontroller, String dateType) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String displayDate = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        String reverseDate = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();

        if (dateType == "claim") {
          edt_ClaimDate.text = displayDate;
          edt_ReverseClaimDate.text = reverseDate;
        } else if (dateType == "from") {
          edt_FromDate.text = displayDate;
          edt_ReverseFromDate.text = reverseDate;
        } else if (dateType == "to") {
          edt_ToDate.text = displayDate;
          edt_ReverseToDate.text = reverseDate;
        }
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
              child: Text("Voucher No *",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorBlack,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10),
              elevation: 5,
              color: colorWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_VoucherNo,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            labelStyle: TextStyle(
                              color: Color(0xFF000000),
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
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

  Widget ClaimDate() {
    return InkWell(
      onTap: () {
        _selectNextFollowupDate(context, edt_ClaimDate, "claim");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Claim Date *",
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            elevation: 5,
            color: colorWhite,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_ClaimDate.text == null || edt_ClaimDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_ClaimDate.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_ClaimDate.text == null ||
                                  edt_ClaimDate.text == ""
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

  Widget FromDate() {
    return InkWell(
      onTap: () {
        _selectNextFollowupDate(context, edt_FromDate, "from");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("From Date *",
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            elevation: 5,
            color: colorWhite,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_FromDate.text == null || edt_FromDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_FromDate.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_FromDate.text == null ||
                                  edt_FromDate.text == ""
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

  Widget ToDate() {
    return InkWell(
      onTap: () {
        _selectNextFollowupDate(context, edt_ToDate, "to");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("To Date *",
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            elevation: 5,
            color: colorWhite,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_ToDate.text == null || edt_ToDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_ToDate.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color:
                              edt_ToDate.text == null || edt_ToDate.text == ""
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

  Widget CustomerSearchView() {
    return InkWell(
      onTap: _onTapOfSearchCustomer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Customer *",
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 5),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            elevation: 5,
            color: colorWhite,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: edt_CustomerName,
                      enabled: false,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "Search customer",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ),
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

  Widget OfficeRefTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Reference Type",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 5),
        Card(
          margin: EdgeInsets.only(left: 10, right: 10),
          elevation: 5,
          color: colorWhite,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedOfficeRefType.isEmpty
                    ? null
                    : _selectedOfficeRefType,
                hint: Text("Select Reference Type"),
                items: _officeRefTypeList
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOfficeRefType = value ?? "";
                    edt_OfficeRefNo.text = "";
                    edt_ProjectID.text = "";
                    edt_ProjectName.text = "";
                    _officeRefNoList = [];
                    _quotationProjectList = [];
                  });
                  _fetchReferenceData();
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget OfficeRefNoDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Reference Number",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 5),
        Card(
          margin: EdgeInsets.only(left: 10, right: 10),
          elevation: 5,
          color: colorWhite,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value:
                    edt_OfficeRefNo.text.isEmpty ? null : edt_OfficeRefNo.text,
                hint: Text(_officeRefNoList.isEmpty
                    ? "Select customer and type first"
                    : "Select Reference Number"),
                items: _officeRefNoList
                    .map((e) => DropdownMenuItem<String>(
                          value: e.orderNo,
                          child: Text(e.orderNo ?? ""),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    edt_OfficeRefNo.text = value ?? "";
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget ProjectNameDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Project Name *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 5),
        Card(
          margin: EdgeInsets.only(left: 10, right: 10),
          elevation: 5,
          color: colorWhite,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value:
                    edt_ProjectName.text.isEmpty ? null : edt_ProjectName.text,
                hint: Text(_quotationProjectList.isEmpty
                    ? "Select customer and type first"
                    : "Select Project"),
                items: _quotationProjectList
                    .map((e) => DropdownMenuItem<String>(
                          value: e.projectName,
                          child: Text(e.projectName ?? ""),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    edt_ProjectName.text = value ?? "";
                    final match = _quotationProjectList.firstWhere(
                      (e) => e.projectName == value,
                      orElse: () => null,
                    );
                    edt_ProjectID.text =
                        match?.pkID?.toString() ?? match?.pkID ?? "";
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget ExpenseNotes() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Expense Notes",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorBlack,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10),
              elevation: 5,
              color: colorWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                          controller: edt_ExpenseNotes,
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter expense notes",
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
                          )),
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

  Widget AdvanceAmount() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Advance Amount *",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorBlack,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10),
              elevation: 5,
              color: colorWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_AdvanceAmount,
                          textInputAction: TextInputAction.next,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                          )),
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

  _onTapOfSaveVehiclePunchAPICall() async {
    List<MultipleExpenseTable> temp =
        await OfflineDbHelper.getInstance().getMultipleExpense();

    if (temp.length != 0) {
      showCommonDialogWithTwoOptions(
          context, "Are you sure you want to Save this record ?",
          negativeButtonTitle: "No",
          positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
        Navigator.of(context).pop();

        final String customerId = edt_CustomerId.text.trim();
        final String employeeId =
            _isForUpdate == true && _editModel.employeeID != null
                ? _editModel.employeeID.toString()
                : EmployeeID;

        if (customerId.isEmpty) {
          showCommonDialogWithSingleOption(context, "Customer is required !",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
          return;
        }

        if (_selectedOfficeRefType == kRefTypeProjects) {
          if (edt_ProjectID.text.trim().isEmpty) {
            showCommonDialogWithSingleOption(
                context, "Project Selection is required !",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
            });
            return;
          }
        } else if (_selectedOfficeRefType == kRefTypeSalesOrder) {
          if (edt_OfficeRefNo.text.trim().isEmpty) {
            showCommonDialogWithSingleOption(
                context, "Reference Number is required !",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
            });
            return;
          }
        }

        final String requestId = _selectedOfficeRefType == kRefTypeProjects
            ? edt_ProjectID.text.trim()
            : "0";
        final String complaintNo = _selectedOfficeRefType == kRefTypeSalesOrder
            ? edt_OfficeRefNo.text.trim()
            : "0";

        _mainBloc
            .add(MultiExpenseAddUpdateRequestEvent(MultiExpenseAddUpdateRequest(
          pkID: pkID.toString(),
          ExpenseDate: edt_ReverseClaimDate.text,
          VoucherNo: edt_VoucherNo.text,
          ExpenseNotes: edt_ExpenseNotes.text,
          RequestID: requestId,
          EmployeeID: employeeId,
          FromDate: edt_ReverseFromDate.text,
          ToDate: edt_ReverseToDate.text,
          FromLocation: "",
          ToLocation: "",
          CustomerID: customerId,
          ServiceEng: "",
          ComplaintNo: complaintNo.isEmpty ? "0" : complaintNo,
          LoginUserID: LoginUserID,
          CompanyId: CompanyID.toString(),
          RequestType: _selectedOfficeRefType,
        )));
      });
    } else {
      showCommonDialogWithSingleOption(context, "Voucher Details Is Required !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  Future<bool> _onBackPressed() async {
    _onTapOfDeleteALLMultipleExpense();
    navigateTo(context, MultiExpenseListScreen.routeName, clearAllStack: true);
  }

  void _onMultiExpenseAddUpUpdateResponseStateCallSuccess(
      MultiExpenseAddUpUpdateResponseState state) {
    showCommonDialogWithSingleOption(context,
        state.multiExpenseAddUpdateResponse.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
      navigateTo(context, MultiExpenseListScreen.routeName,
          clearAllStack: true);
    });
  }

  void fillData() async {
    pkID = _editModel.pkID;
    edt_VoucherNo.text = _editModel.voucherNo;
    edt_CustomerId.text =
        _editModel.customerID != null ? _editModel.customerID.toString() : "";
    edt_CustomerName.text = _editModel.customerName ?? "";
    edt_ExpenseNotes.text = _editModel.expenseNotes;
    edt_AdvanceAmount.text = _editModel.amount.toString();
    edt_ClaimDate.text = _editModel.expenseDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_ReverseClaimDate.text = _editModel.expenseDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    final String savedType = _editModel.requestType?.toString()?.trim() ?? "";
    _selectedOfficeRefType =
        _officeRefTypeList.contains(savedType) ? savedType : kRefTypeSalesOrder;

    if (_selectedOfficeRefType == kRefTypeProjects) {
      // RequestID is the project PK, projectName is what we display.
      edt_ProjectID.text = _editModel.requestID?.toString() ?? "";
      edt_ProjectName.text = _editModel.projectName ?? "";
      edt_OfficeRefNo.text = "";
    } else {
      // ComplaintNo is the Sales Order ref number.
      edt_OfficeRefNo.text = _editModel.complaintNo?.toString() ?? "";
      edt_ProjectID.text = "";
      edt_ProjectName.text = "";
    }

    if (_editModel.fromDate != null &&
        _editModel.fromDate.toString().isNotEmpty) {
      edt_FromDate.text = _editModel.fromDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_ReverseFromDate.text = _editModel.fromDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    }

    if (_editModel.toDate != null && _editModel.toDate.toString().isNotEmpty) {
      edt_ToDate.text = _editModel.toDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_ReverseToDate.text = _editModel.toDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    }

    setState(() {});

    if (edt_CustomerId.text.isNotEmpty && _selectedOfficeRefType.isNotEmpty) {
      _fetchReferenceData();
    }

    if (_editModel.voucherNo != "") {
      _mainBloc.add(MultiExpenseADetailsListRequestEvent(
          SiteURL,
          MultiExpenseListRequest(
              pkID: _editModel.pkID.toString(),
              SearchKey: "",
              PageNo: "1",
              PageSize: "10000",
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID)));
    }
  }

  Future<void> _onTapOfSearchCustomer() async {
    final value =
        await navigateTo(context, SearchInquiryCustomerScreen.routeName);
    if (value != null) {
      SearchDetails searchCustomerDetails = value;
      setState(() {
        edt_CustomerName.text = searchCustomerDetails.label ?? "";
        edt_CustomerId.text = searchCustomerDetails.value?.toString() ?? "";
        edt_OfficeRefNo.text = "";
        edt_ProjectID.text = "";
        edt_ProjectName.text = "";
        _officeRefNoList = [];
        _quotationProjectList = [];
        if (_selectedOfficeRefType.isEmpty) {
          _selectedOfficeRefType = kRefTypeSalesOrder;
        }
      });
      _fetchReferenceData();
    }
  }

  void _fetchReferenceData() {
    if (edt_CustomerId.text.trim().isEmpty || _selectedOfficeRefType.isEmpty) {
      return;
    }

    if (_selectedOfficeRefType == kRefTypeSalesOrder) {
      _fetchOfficeRefNoList();
    } else if (_selectedOfficeRefType == kRefTypeProjects) {
      _fetchQuotationProjectList();
    }
  }

  void _fetchOfficeRefNoList() {
    _mainBloc.add(OfficeRefTypeFromCustomerIDRequestEvent(
        OfficeRefTypeFromCustomerIDRequest(
            CustomerID: edt_CustomerId.text.trim(),
            Type: _selectedOfficeRefType,
            CompanyId: CompanyID.toString())));
  }

  void _fetchQuotationProjectList() {
    _mainBloc.add(QuotationProjectListCallEvent(QuotationProjectListRequest(
        CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
  }

  void _onOfficeRefTypeFromCustomerIDResponseSuccess(
      OfficeRefTypeFromCustomerIDResponseState state) {
    setState(() {
      _officeRefNoList = state.response?.details ?? [];
      final String currentRef = edt_OfficeRefNo.text?.trim() ?? "";
      if (currentRef.isNotEmpty) {
        final exists = _officeRefNoList
            .any((e) => (e.orderNo ?? "").toString() == currentRef);
        if (!exists) {
          try {
            final item = OfficeRefTypeFromCustomerIDResponseDetails();
            item.orderNo = currentRef;
            _officeRefNoList.insert(0, item);
          } catch (e) {
            edt_OfficeRefNo.text = "";
          }
        }
      }
    });
  }

  void _onQuotationProjectListResponseStateSuccess(
      QuotationProjectListResponseState state) {
    setState(() {
      _quotationProjectList = state.response?.details ?? [];
      final String currentProjectName = edt_ProjectName.text?.trim() ?? "";
      if (currentProjectName.isNotEmpty) {
        final match = _quotationProjectList.firstWhere(
          (e) => (e.projectName ?? "").toString() == currentProjectName,
          orElse: () => null,
        );
        if (match == null) {
          try {
            final item = QuotationProjectDetails();
            item.projectName = currentProjectName;
            _quotationProjectList.insert(0, item);
          } catch (e) {
            edt_ProjectName.text = "";
            edt_ProjectID.text = "";
          }
        } else {
          edt_ProjectID.text = match.pkID?.toString() ?? edt_ProjectID.text;
        }
      }
    });
  }

  Future<void> _onTapOfDeleteALLMultipleExpense() async {
    await OfflineDbHelper.getInstance().deleteAllMultipleExpense();
  }

  void _onMultiExpenseADetailsListResponseStateCallSuccess(
      MultiExpenseADetailsListResponseState state) async {}
}
