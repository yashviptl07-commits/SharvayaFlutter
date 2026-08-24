import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_status_list_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_chacklist_dropdown.dart';
import 'package:soleoserp/models/api_requests/other/all_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_add_update_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_details_list_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_log_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_list_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_log_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/repairing_table.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Repairing/repairing_header_screen/repairing_details_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Repairing/repairing_header_screen/repairing_header_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/search_followup_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/search_inquiry_product_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class RepairingAddEditMainScreenArguments {
  RepairingListResponseDetails editModel;
  RepairingAddEditMainScreenArguments(this.editModel);
}

class RepairingAddEditMainScreen extends BaseStatefulWidget {
  static const routeName = '/RepairingAddEditMainScreen';
  final RepairingAddEditMainScreenArguments arguments;

  RepairingAddEditMainScreen(this.arguments);

  @override
  _RepairingAddEditMainScreenState createState() =>
      _RepairingAddEditMainScreenState();
}

class _RepairingAddEditMainScreenState extends BaseState<RepairingAddEditMainScreen>
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
  RepairingListResponseDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isCompare;
  int selectedDurationMonths = 0;
  ProductSearchDetails _searchProductSearchDetails;

  /// For New
  final TextEditingController edt_SlipNo = TextEditingController();
  final TextEditingController edt_SlipDate = TextEditingController();
  final TextEditingController edt_Reverse_SlipDate = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_PrimaryMobile = TextEditingController();
  final TextEditingController edt_AlternateMobile = TextEditingController();
  final TextEditingController edt_productNameController = TextEditingController();
  final TextEditingController edt_productIDController = TextEditingController();
  final TextEditingController edt_Remarks = TextEditingController();
  final TextEditingController edt_IMEINo = TextEditingController();
  final TextEditingController edt_DeliveryDate = TextEditingController();
  final TextEditingController edt_Reverse_DeliveryDate = TextEditingController();
  final TextEditingController edt_AccessPattern = TextEditingController();
  final TextEditingController edt_AccessPin = TextEditingController();
  final TextEditingController edt_Amount = TextEditingController();
  final TextEditingController edt_assignTo = TextEditingController();
  final TextEditingController edt_assignToId = TextEditingController();
  final TextEditingController edt_RepairingStage = TextEditingController();
  final TextEditingController edt_ProblemNotes = TextEditingController();
  final TextEditingController edt_RepairingNotes = TextEditingController();
  final TextEditingController edt_TermConditionHeader = TextEditingController();
  final TextEditingController edt_TermConditionHeaderID =
  TextEditingController();
  final TextEditingController edt_TermConditionFooter = TextEditingController();


  List<ALL_Name_ID> arr_ALL_Name_ID_For_AssignTo = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_RepairingStage = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TermConditionList = [];

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

    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {

      _mainBloc.add(RepairingListByDRPNameCallEvent(
          MaintenanceCheckListDRPRequest(
            CompanyId: CompanyID.toString(),
            CheckHead: "Repairing",
            LoginUserID: LoginUserID,
          )));

      edt_SlipDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();

      edt_Reverse_SlipDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      edt_DeliveryDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();

      edt_Reverse_DeliveryDate.text = selectedDate.year.toString() +
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
          if (state is RepairingDetailsListCallResponseState) {
            _onMaintenanceDetailsListCallResponse(state);
          }
          if (state is RepairingListCallDRPResponseState) {
            _onRepairingStageForDRPResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is RepairingDetailsListCallResponseState) {
            return true;
          }
          if (currentState is RepairingListCallDRPResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is MaintenanceTermsConditionResponseState) {
            _OnTermConditionListResponse(state);
          }
          if (state is RepairingAddUpdateCallResponseState) {
            _onBankVoucherSaveResponse(state);
          }
          if (state is ALL_EmployeeNameListResponseState) {
            _onAssignToResponse(state);
          }
          if (state is InquiryLeadStatusListCallResponseState) {
            _onRepairingStageResponse(state);
          }
          if (state is RepairingLogListResponseState) {
            _OnCityCodetoCustomerDetails(state);
          }

        },
        listenWhen: (oldState, currentState) {
          if (currentState is MaintenanceTermsConditionResponseState) {
            return true;
          }
          if (currentState is RepairingAddUpdateCallResponseState) {
            return true;
          }
          if (currentState is ALL_EmployeeNameListResponseState) {
            return true;
          }
          if (currentState is InquiryLeadStatusListCallResponseState) {
            return true;
          }
          if (currentState is RepairingLogListResponseState) {
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
          title: Text('Repairing'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          leading: InkWell(
              onTap: () async {
                navigateTo(context, RepairingListMainScreen.routeName);
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
                    SlipNo(),
                    SizedBox(height: 15),
                    SlipDate(),
                    SizedBox(height: 15),
                    _buildSearchView(),
                    SizedBox(height: 15),
                    PrimaryMobile(),
                    SizedBox(height: 15),
                    AlternateMobile(),
                    SizedBox(height: 15),
                    _buildProductNameModelNo(),
                    SizedBox(height: 15),
                    IMEINo(),
                    SizedBox(height: 15),
                    DeliveryDate(),
                    SizedBox(height: 15),
                    AccessPattern(),
                    SizedBox(height: 15),
                    AccessPin(),
                    SizedBox(height: 15),
                    Amount(),
                    SizedBox(height: 15),
                    RepairingStage("Repairing Stage",
                        enable1: false,
                        title: "Repairing Stage",
                        hintTextvalue: "--- Select ---",
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: colorPrimary,
                        ),
                        controllerForLeft: edt_RepairingStage,
                        Custom_values1: arr_ALL_Name_ID_For_RepairingStage),
                    SizedBox(height: 15),
                    AssignTo("Assign TO",
                        enable1: false,
                        title: "Assign TO",
                        hintTextvalue: "--- Select ---",
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: colorPrimary,
                        ),
                        controllerForLeft: edt_assignTo,
                        controllerpkID: edt_assignToId,
                        Custom_values1: arr_ALL_Name_ID_For_AssignTo),
                    SizedBox(height: 15),
                    ProblemNotes(),
                    SizedBox(height: 15),
                    RepairingNotes(),
                    SizedBox(height: 15),
                    TermsConditionList("Select Term & Condition",
                        enable1: false,
                        title: "Select Term & Condition",
                        hintTextvalue: "Tap to Select Term & Condition",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_TermConditionHeader,
                        controllerpkID: edt_TermConditionHeaderID,
                        Custom_values1: arr_ALL_Name_ID_For_TermConditionList),
                    SizedBox(
                      height: 15,
                    ),
                    TermsCondition(),
                    SizedBox(
                      height: 10,
                    ),
                    ProductDetails(),
                    SizedBox(
                      height: 10,
                    ),
                    _isForUpdate == true
                        ? RepairingLog()
                        : Container(),
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

  ProductDetails() {
    return Container(
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 25),
        alignment: Alignment.bottomCenter,
        child: getCommonButton(baseTheme, () {
            navigateTo(context, RepairingDetailsListScreen.routeName,
                arguments: RepairingDetailsListScreenArgument());
        }, "Parts Detail",
            textColor: colorBlack,
            backGroundColor: Colors.grey[500],
            radius: 15),
      ),
    );
  }

  RepairingLog() {
    return Container(
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 25),
        alignment: Alignment.bottomCenter,
        child: getCommonButton(baseTheme, () {
          _mainBloc.add(RepairingLogListCallEvent(
              RepairingLogListRequest(
                  HeaderID: _editModel.pkID.toString(),
                  LoginUserID: LoginUserID,
                  CompanyId: CompanyID.toString())));
        }, " Repairing Log",
            textColor: colorBlack,
            backGroundColor: Colors.grey[500],
            radius: 15),
      ),
    );
  }

  Widget SlipNo() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text("Slip No",
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
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
                              controller: edt_SlipNo,
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "",
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
                                  fontWeight: FontWeight.bold
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

  Widget SlipDate() {
    return InkWell(
      onTap: () {
        _selectSlipDate(context, edt_SlipDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              "Slip Date",
              style: TextStyle(
                  fontSize: 13,
                  color: colorBlack, // colorPrimary
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          Card(
            margin: EdgeInsets.only(left: 15, right: 15),
            elevation: 5,
            color: Colors.grey[200], // colorLightGray
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
                      edt_SlipDate.text.isEmpty
                          ? "YYYY-MM-DD"
                          : edt_SlipDate.text,
                      style: TextStyle(
                        fontSize: 15,
                        color: edt_SlipDate.text.isEmpty
                            ? Colors.grey
                            : Colors.black,
                          fontWeight: FontWeight.bold// colorGrayDark or colorBlack
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey, // colorGrayDark
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectSlipDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        edt_SlipDate.text = DateFormat('dd-MM-yyyy').format(selectedDate);
        edt_Reverse_SlipDate.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Widget ProblemNotes() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text("Problem Notes *",
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
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
                              controller: edt_ProblemNotes,
                              keyboardType: TextInputType.multiline,
                              maxLines: 8,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter Problem Notes",
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
                                  fontWeight: FontWeight.bold
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

  Widget RepairingNotes() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text("Repairing Notes",
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
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
                              controller: edt_RepairingNotes,
                              keyboardType: TextInputType.multiline,
                              maxLines: 8,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter Repairing Notes",
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
                                  fontWeight: FontWeight.bold
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

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text("Select Customer* ",
                style: TextStyle(
                    fontSize: 13,
                    color: colorBlack,
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
            color: Colors.grey[200],
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
                          //contentPadding: EdgeInsets.only(bottom: 12, top: 12),
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                            fontWeight: FontWeight.bold
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
        edt_PrimaryMobile.text = _searchDetails.ContactNo1.toString();
        edt_AlternateMobile.text = _searchDetails.ContactNo2.toString();


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


  Widget PrimaryMobile() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text("Primary Mobile *",
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
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
                              controller: edt_PrimaryMobile,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter Primary Mobile",
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
                                  fontWeight: FontWeight.bold
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

  Widget AlternateMobile() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text("Alternate Mobile",
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
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
                              controller: edt_AlternateMobile,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter Alternate Mobile",
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
                                  fontWeight: FontWeight.bold
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

  Widget _buildProductNameModelNo() {
    return InkWell(
      onTap: () {
        _onTapOfSearchViewProduct();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text("Product Name / Model No",
                style: TextStyle(
                    fontSize: 13,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            elevation: 5,
            color: Colors.grey[200],
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 50,
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
                        onTap: () {
                          _onTapOfSearchViewProduct();
                        },
                        readOnly: true,
                        controller: edt_productNameController,
                        decoration: InputDecoration(
                          hintText: "--- Search ---",
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold
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

  Future<void> _onTapOfSearchViewProduct() async {
    navigateTo(context, SearchInquiryProductScreen.routeName,)
        .then((value) {
      if (value != null) {
        _searchProductSearchDetails = value;
        edt_productNameController.text = _searchProductSearchDetails.productName.toString();
        edt_productIDController.text = _searchProductSearchDetails.pkID.toString();
      }
    });
  }

  Widget IMEINo() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text("IMEI No *",
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
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
                              controller: edt_IMEINo,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter IMEI No",
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
                                  fontWeight: FontWeight.bold
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

  Widget DeliveryDate() {
    return InkWell(
      onTap: () {
        _selectDeliveryDate(context, edt_DeliveryDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              "Delivery Date",
              style: TextStyle(
                  fontSize: 13,
                  color: colorBlack, // colorPrimary
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          Card(
            margin: EdgeInsets.only(left: 15, right: 15),
            elevation: 5,
            color: Colors.grey[200], // colorLightGray
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
                      edt_DeliveryDate.text.isEmpty
                          ? "YYYY-MM-DD"
                          : edt_DeliveryDate.text,
                      style: TextStyle(
                        fontSize: 15,
                        color: edt_DeliveryDate.text.isEmpty
                            ? Colors.grey
                            : Colors.black,
                        fontWeight: FontWeight.bold// colorGrayDark or colorBlack
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey, // colorGrayDark
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDeliveryDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        edt_DeliveryDate.text = DateFormat('dd-MM-yyyy').format(selectedDate);
        edt_Reverse_DeliveryDate.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Widget AccessPattern() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text("Access Pattern",
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
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
                              controller: edt_AccessPattern,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter Access Pattern",
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
                                  fontWeight: FontWeight.bold
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

  Widget AccessPin() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text("Access Pin",
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
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
                              controller: edt_AccessPin,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter Access Pin",
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
                                  fontWeight: FontWeight.bold
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

  Widget Amount() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text("Amount *",
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
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
                              controller: edt_Amount,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter Amount",
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
                                  fontWeight: FontWeight.bold
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

  Widget RepairingStage(String ContactPerson,
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
            onTap: () {
              _mainBloc.add(InquiryLeadStatusTypeListByNameCallEvent(
                  FollowupInquiryStatusTypeListRequest(
                      CompanyId: CompanyID.toString(),
                      pkID: "",
                      StatusCategory: "RepairingStage",
                      LoginUserID: LoginUserID,
                      SearchKey: "")));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
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
                                fontWeight: FontWeight.bold
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

  void _onRepairingStageResponse(
      InquiryLeadStatusListCallResponseState state) {
    if (state.inquiryStatusListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_RepairingStage.clear();
      for (var i = 0; i < state.inquiryStatusListResponse.details.length; i++) {
        print("InquiryStatus : " +
            state.inquiryStatusListResponse.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.inquiryStatusListResponse.details[i].inquiryStatus;
        arr_ALL_Name_ID_For_RepairingStage.add(all_name_id);
      }
      showcustomdialogWithOnlyName(
          values: arr_ALL_Name_ID_For_RepairingStage,
          context1: context,
          controller: edt_RepairingStage,
          lable: "Select Repairing Stage");
    }
  }

  void _onRepairingStageForDRPResponse(
      RepairingListCallDRPResponseState state) async {

    if (state.inquiryStatusListResponse.details.length != 0) {
      await OfflineDbHelper.getInstance().deleteALLRepairing();

      for (var i = 0; i < state.inquiryStatusListResponse.details.length; i++) {

        await OfflineDbHelper.getInstance()
            .insertRepairing(RepairingDetailsTable(
          "",//String pkID,
          "0",//String ParentID,
          "",//String RepairingNo,
          state.inquiryStatusListResponse.details[i].pkid.toString(),//String CheckListID,
          state.inquiryStatusListResponse.details[i].checkDesc,//String CheckListName,
          "false",//state.response.details[i].CheckFlag,//String CheckFlag,
          LoginUserID, //String LoginUserID,
          CompanyID.toString(),//String CompanyId,
        ));
      }
    }
  }

  Widget AssignTo(String ContactPerson,
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
            onTap: () {
                _mainBloc.add(ALLEmployeeNameCallEvent(
                    ALLEmployeeNameRequest(CompanyId: CompanyID.toString())));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
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
                                fontWeight: FontWeight.bold
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

  void _onAssignToResponse(ALL_EmployeeNameListResponseState state) {
    arr_ALL_Name_ID_For_AssignTo.clear();
    for (var i = 0; i < state.all_employeeList_Response.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.Name = state.all_employeeList_Response.details[i].employeeName;
      all_name_id.pkID = state.all_employeeList_Response.details[i].pkID;
      arr_ALL_Name_ID_For_AssignTo.add(all_name_id);
    }
    showcustomdialogWithID(
        values: arr_ALL_Name_ID_For_AssignTo,
        context1: context,
        controller: edt_assignTo,
        controllerID: edt_assignToId,
        lable: "Select Assign To");
  }

  termsAndCondition() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: colorPrimary, borderRadius: BorderRadius.circular(20)),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Terms & Condition",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),

                leading: Container(
                  child: ClipRRect(
                    child: Image.asset(
                      CREDIT_INFORMATION,
                      width: 27,
                    ),
                  ),
                ),

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        TermsConditionList("Select Term & Condition",
                            enable1: false,
                            title: "Select Term & Condition",
                            hintTextvalue: "Tap to Select Term & Condition",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_TermConditionHeader,
                            controllerpkID: edt_TermConditionHeaderID,
                            Custom_values1:
                            arr_ALL_Name_ID_For_TermConditionList),
                        SizedBox(
                          height: 10,
                        ),
                        TermsCondition(),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  Widget TermsCondition() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text("Terms & Condition",
                      style: TextStyle(
                          fontSize: 13,
                          color: colorBlack,
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
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 125,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                              controller: edt_TermConditionFooter,
                              keyboardType: TextInputType.multiline,
                              maxLines: 8,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter Term & Condition",
                                contentPadding: EdgeInsets.only(
                                    left: 7, top: 15, bottom: 10, right: 7),
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                              ),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                                  fontWeight: FontWeight.bold
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

  void _OnTermConditionListResponse(
      MaintenanceTermsConditionResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_TermConditionList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].tNCHeader);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].tNCHeader;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].tNCContent;

        arr_ALL_Name_ID_For_TermConditionList.add(all_name_id);
      }
      showcustomdialogWithMultipleID(
          values: arr_ALL_Name_ID_For_TermConditionList,
          context1: context,
          controller: edt_TermConditionHeader,
          controllerID: edt_TermConditionHeaderID,
          controller2: edt_TermConditionFooter,
          lable: "Select Term & Condition ");
    }
  }

  Widget TermsConditionList(String Category,
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
            onTap: () {
              _mainBloc.add(MaintenanceTermsConditionCallEvent(
                  QuotationTermsConditionRequest(
                      CompanyId: CompanyID.toString(),
                      LoginUserID: LoginUserID)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 13,
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
                  margin: EdgeInsets.only(left: 15, right: 15),
                  color: Colors.grey[200],
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
                                fontWeight: FontWeight.bold
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




  /// Save and update section
  _onTapOfSaveVehiclePunchAPICall() async {

    if(edt_CustomerName.text != ""){
      if(edt_PrimaryMobile.text != ""){
        if (edt_IMEINo.text != "") {
          if(edt_ProblemNotes.text != ""){
           if(edt_Amount.text != ""){
            if(edt_productNameController.text != ""){

              List<RepairingDetailsTable> arrGContainerList = [];
              arrGContainerList.addAll(await OfflineDbHelper.getInstance().getRepairing());


              bool hasTrueFlag = false;

              for (int i = 0; i < arrGContainerList.length; i++) {
                if (arrGContainerList[i].CheckFlag == "true") {
                  hasTrueFlag = true;
                  break; // No need to check further if we found at least one true flag
                }
              }


              print("kjhwifidu" + hasTrueFlag.toString());

              if(hasTrueFlag) {
                 showCommonDialogWithTwoOptions(
                     context, "Are you sure you want to Save this record ?",
                     negativeButtonTitle: "No",
                     positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
                   Navigator.of(context).pop();
                   _mainBloc.add(
                       RepairingAddUpdateRequestCallEvent(RepairingAddEditRequest(
                         pkID : pkID.toString(),
                         RepairingNo : edt_SlipNo.text,
                         RepairingDate : edt_Reverse_SlipDate.text,
                         CustomerID : edt_CustomerpkID.text,
                         PrimaryMobileNo : edt_PrimaryMobile.text,
                         AlternateMobileNo : edt_AlternateMobile.text,
                         ProductID : edt_productIDController.text,
                         IMEINo : edt_IMEINo.text,
                         DeliveryDate : edt_Reverse_DeliveryDate.text,
                         AccessPattern : edt_AccessPattern.text,
                         AccessPin : edt_AccessPin.text,
                         ProblemNotes : edt_ProblemNotes.text,
                         RepairingNotes : edt_RepairingNotes.text,
                         EmployeeID : edt_assignToId.text,
                         Amount : edt_Amount.text,
                         LoginUserID : LoginUserID,
                         ContractFooter : edt_TermConditionFooter.text,
                         RepairingStage : edt_RepairingStage.text,
                         AssignTo : edt_assignToId.text,
                         CompanyId : CompanyID.toString(),
                       )));
                 });
               } else {
                 showCommonDialogWithSingleOption(
                     context, "At Least One Part Selection Is Required !",
                     positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                   Navigator.of(context).pop();
                 });
               }
             } else{
               showCommonDialogWithSingleOption(
                   context, "Product Name Is Required !",
                   positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                 Navigator.of(context).pop();
               });
             }
             } else {
              showCommonDialogWithSingleOption(
                  context, "Estimated Amount Is Required !",
                  positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                Navigator.of(context).pop();
              });
            }
          } else {
            showCommonDialogWithSingleOption(
                context, "Problem Remark Is Required !",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
            });
          }
        } else{
          showCommonDialogWithSingleOption(
              context, "IMEI No Is Required !",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }
      }else{
        showCommonDialogWithSingleOption(
            context, "Primary Contact Is Required !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    }else{
      showCommonDialogWithSingleOption(
          context, "Customer Name Is Required !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  void _onBankVoucherSaveResponse(RepairingAddUpdateCallResponseState state) {
    showCommonDialogWithSingleOption(context,
        state.repairingAddUpdateResponse.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
          navigateTo(context, RepairingListMainScreen.routeName, clearAllStack: true);
        });
  }

  void fillData() async {

    pkID = _editModel.pkID;
    edt_SlipNo.text = _editModel.repairingNo;
    edt_SlipDate.text = _editModel.repairingDate.getFormattedDate(
    fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_SlipDate.text = _editModel.repairingDate.getFormattedDate(
    fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_CustomerName.text = _editModel.customerName;
    edt_CustomerpkID.text = _editModel.customerID.toString();
    edt_PrimaryMobile.text = _editModel.primaryMobileNo;
    edt_AlternateMobile.text = _editModel.alternateMobileNo;
    edt_productNameController.text = _editModel.productName;
    edt_productIDController.text = _editModel.productID.toString();
    edt_IMEINo.text = _editModel.iMEINo;
    edt_DeliveryDate.text = _editModel.deliveryDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");;
    edt_Reverse_DeliveryDate.text = _editModel.deliveryDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_AccessPattern.text = _editModel.accessPattern;
    edt_AccessPin.text = _editModel.accessPin;
    edt_Amount.text = _editModel.amount.toString();
    edt_assignTo.text = _editModel.assigntoEmployeeName;
    edt_assignToId.text = _editModel.assignTo.toString();
    edt_RepairingStage.text = _editModel.repairingStage;
    edt_ProblemNotes.text = _editModel.problemNotes;
    edt_RepairingNotes.text = _editModel.repairingNotes;
    edt_TermConditionFooter.text = _editModel.contractFooter;

    if (_editModel.repairingNo.toString() != "") {
      _mainBloc.add(RepairingDetailsListCallEvent(
          LoginUserID,
          RepairingDetailsListRequest(
              RepairingNo: _editModel.repairingNo,
              CompanyId: CompanyID.toString())));
    }
  }

  void _onMaintenanceDetailsListCallResponse(
      RepairingDetailsListCallResponseState state) async {

  }

  /// Extra Screens

  Future<bool> _onBackPressed() async {
    navigateTo(context, RepairingListMainScreen.routeName, clearAllStack: true);
  }

  void NearByCityDialog(BuildContext context,
      List<RepairingLogListResponseDetails> citytocustomerList) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                      colorPrimary, //                   <--- border color
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(
                        15.0) //                 <--- border radius here
                    ),
                  ),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Repairing Log",
                        style: TextStyle(
                            color: colorPrimary, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ))),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close_rounded,
                  color: colorPrimary,
                  size: 24,
                ),
              )
            ],
          ),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(children: <Widget>[
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              RepairingLogListResponseDetails model =
                              citytocustomerList[index];

                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colorTileBG,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14.0),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Card(
                                        color: colorBackGroundGray,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Action Date ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 12,
                                                      letterSpacing: .3)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  model.createdDate.getFormattedDate(
                                                      fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") == ""
                                                      ? "N/A"
                                                      : model.createdDate.getFormattedDate(
                                                      fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy hh:mm a"),
                                                  style: TextStyle(
                                                      color: Color(title_color),
                                                      fontSize: 15,
                                                      letterSpacing: .3))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Card(
                                        color: colorBackGroundGray,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Action Taken",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 12,
                                                      letterSpacing: .3)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  model.actionTaken == ""
                                                      ? "N/A"
                                                      : model.actionTaken,
                                                  style: TextStyle(
                                                      color: Color(title_color),
                                                      fontSize: 15,
                                                      letterSpacing: .3))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Card(
                                        color: colorBackGroundGray,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Action Description	",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 12,
                                                      letterSpacing: .3)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  model.actionDescription == ""
                                                      ? "N/A"
                                                      : model.actionDescription,
                                                  softWrap: true,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      color: Color(title_color),
                                                      fontSize: 15,
                                                      overflow:
                                                      TextOverflow.clip,
                                                      letterSpacing: .3))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Card(
                                        color: colorBackGroundGray,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Repairing Stage",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 12,
                                                      letterSpacing: .3)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  model.repairingStage == ""
                                                      ? "N/A"
                                                      : model.repairingStage,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(title_color),
                                                      fontSize: 15,
                                                      letterSpacing: .3))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Card(
                                        color: colorBackGroundGray,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Created / Updated By",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 12,
                                                      letterSpacing: .3)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  model.createdBy == ""
                                                      ? "N/A"
                                                      : model.createdBy,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(title_color),
                                                      fontSize: 15,
                                                      letterSpacing: .3))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Card(
                                        color: colorBackGroundGray,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 12,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Assign To",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 12,
                                                      letterSpacing: .3)),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  model.employeeName == ""
                                                      ? "N/A"
                                                      : model.employeeName,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      color: Color(title_color),
                                                      fontSize: 15,
                                                      letterSpacing: .3))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: citytocustomerList.length,
                          ),
                        ])),
                  ],
                )),
            Center(
            child: Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  color: Color(0xFFF27442),
                  borderRadius: BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Color(0xFFF27442))),
              //color: Color(0xFFF27442),
              child: GestureDetector(
                child: Text(
                  "Close",
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
          ],
        );
      },
    );
  }

  void _OnCityCodetoCustomerDetails(RepairingLogListResponseState state) {
    NearByCityDialog(context, state.repairingLogListResponse.details);
  }

}
