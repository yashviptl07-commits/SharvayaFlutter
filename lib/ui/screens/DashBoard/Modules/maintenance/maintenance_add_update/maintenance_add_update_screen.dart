import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_add_update_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_chacklist_dropdown.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_details_list_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/master_maintenance_contactList%20_dropdown.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/maintenance/maintenance_list_response.dart';
import 'package:soleoserp/models/common/Maintenance_product_model.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/search_followup_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/maintenance/maintenance_add_update/maintenance_product_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/maintenance/maintenance_list/maintenance_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class MaintenanceAddEditScreenArguments {
  MaintenanceDetails editModel;
  MaintenanceAddEditScreenArguments(this.editModel);
}

class MaintenanceAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/MaintenanceAddEditScreen';
  final MaintenanceAddEditScreenArguments arguments;

  MaintenanceAddEditScreen(this.arguments);

  @override
  _MaintenanceAddEditScreenState createState() =>
      _MaintenanceAddEditScreenState();
}

class _MaintenanceAddEditScreenState extends BaseState<MaintenanceAddEditScreen>
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
  MaintenanceDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isCompare;
  int selectedDurationMonths = 0;

  /// For New
  final TextEditingController edt_ContractCode = TextEditingController();
  final TextEditingController edt_ContractType = TextEditingController();
  final TextEditingController edt_Remarks = TextEditingController();
  final TextEditingController edt_IMEINo = TextEditingController();
  final TextEditingController edt_WarrantyType = TextEditingController();
  final TextEditingController edt_WarrantyTypeId = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_ContactPerson = TextEditingController();
  final TextEditingController edt_ContactPersonId = TextEditingController();
  final TextEditingController edt_ContactNo = TextEditingController();
  final TextEditingController edt_ContactNoId = TextEditingController();
  final TextEditingController edt_StartDate = TextEditingController();
  final TextEditingController edt_Reverse_StartDate = TextEditingController();
  final TextEditingController edt_EndDate = TextEditingController();
  final TextEditingController edt_Reverse_EndDate = TextEditingController();
  final TextEditingController edt_TermConditionHeader = TextEditingController();
  final TextEditingController edt_TermConditionHeaderID =
      TextEditingController();
  final TextEditingController edt_TermConditionFooter = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_ContractType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_WarrantyType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ContactPerson = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ContactNo = [];
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
    ContractTypeStatus();

    edt_ContractType.text = "3 Months";
    selectedDurationMonths = 3;

    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      // Set initial start date
      edt_StartDate.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      edt_Reverse_StartDate.text =
          DateFormat('yyyy-MM-dd').format(selectedDate);

      DateTime _calculateEndDate(DateTime startDate, int durationMonths) {
        return DateTime(
            startDate.year, startDate.month + durationMonths, startDate.day);
      }

      // Calculate and set initial end date
      DateTime endDate =
          _calculateEndDate(selectedDate, selectedDurationMonths);
      edt_EndDate.text = DateFormat('dd-MM-yyyy').format(endDate);
      edt_Reverse_EndDate.text = DateFormat('yyyy-MM-dd').format(endDate);

      /* edt_StartDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();

      edt_Reverse_StartDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      DateTime _calculateEndDate(DateTime startDate, int durationMonths) {
        return DateTime(startDate.year, startDate.month + durationMonths, startDate.day);
      }

      if (edt_StartDate.text.isNotEmpty) {
        DateTime startDate = DateFormat('yyyy-MM-dd').parse(edt_StartDate.text);
        DateTime endDate = _calculateEndDate(startDate, selectedDurationMonths);

        edt_EndDate.text = DateFormat('yyyy-MM-dd').format(endDate);
        edt_Reverse_EndDate.text = DateFormat('yyyy-MM-dd').format(endDate);
      }*/

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
          if (state is MaintenanceDetailsListCallResponseState) {
            _onMaintenanceDetailsListCallResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MaintenanceDetailsListCallResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is MaintenanceTermsConditionResponseState) {
            _OnTermConditionListResponse(state);
          }
          if (state is MaintenanceAddUpdateCallResponseState) {
            _onBankVoucherSaveResponse(state);
          }
          if (state is MaintenanceCheckListDRPResponseState) {
            _onWarrantyTypeResponse(state);
          }
          if (state is MasterMaintenanceCheckListResponseState) {
            _onContactPersonResponse(state);
          }
          if (state is MasterMaintenanceCheckListResponseState1) {
            _onContactResponse(state);
          }
          /* if (state is ProductBrandResponseState) {
            _onBrandListResponse(state);
          }
          if (state is ProductAddUpdateResponseState) {
            _onBankVoucherSaveResponse(state);
          }*/
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MaintenanceTermsConditionResponseState) {
            return true;
          }
          if (currentState is MaintenanceAddUpdateCallResponseState) {
            return true;
          }
          if (currentState is MaintenanceCheckListDRPResponseState) {
            return true;
          }
          if (currentState is MasterMaintenanceCheckListResponseState) {
            return true;
          }
          if (currentState is MasterMaintenanceCheckListResponseState1) {
            return true;
          }
          /*if (currentState is ProductBrandResponseState) {
            return true;
          }
          if (currentState is ProductAddUpdateResponseState) {
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
        backgroundColor: Colors.blue.shade50,
        appBar: NewGradientAppBar(
          title: Text('Annual Maintenance Contract'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          leading: InkWell(
              onTap: () async {
                navigateTo(context, MaintenanceListScreen.routeName);
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
                    ContractCode(),
                    SizedBox(height: 10),
                    ContractType(),
                    SizedBox(height: 10),
                    WarrantyType("Warranty Type",
                        enable1: false,
                        title: "Warranty Type",
                        hintTextvalue: "--- Select ---",
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: colorPrimary,
                        ),
                        controllerForLeft: edt_WarrantyType,
                        controllerpkID: edt_WarrantyTypeId,
                        Custom_values1: arr_ALL_Name_ID_For_WarrantyType),
                    SizedBox(height: 10),
                    _buildSearchView(),
                    SizedBox(height: 10),
                    IMEINo(),
                    SizedBox(height: 10),
                    ContactPerson("Contact Person",
                        enable1: false,
                        title: "Contact Person",
                        hintTextvalue: "--- Select Contact person ---",
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: colorPrimary,
                        ),
                        controllerForLeft: edt_ContactPerson,
                        Custom_values1: arr_ALL_Name_ID_For_ContactPerson),
                    SizedBox(height: 10),
                    Contact("Contact No",
                        enable1: false,
                        title: "Contact No",
                        hintTextvalue: "--- Select Contact Number ---",
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: colorPrimary,
                        ),
                        controllerForLeft: edt_ContactNo,
                        Custom_values1: arr_ALL_Name_ID_For_ContactNo),
                    SizedBox(height: 10),
                    StartDate(),
                    SizedBox(height: 10),
                    EndDate(),
                    SizedBox(height: 10),
                    Remarks(),
                    SizedBox(height: 10),
                    TermsConditionList("Select Term & Condition",
                        enable1: false,
                        title: "Select Term & Condition",
                        hintTextvalue: "Tap to Select Term & Condition",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_TermConditionHeader,
                        controllerpkID: edt_TermConditionHeaderID,
                        Custom_values1: arr_ALL_Name_ID_For_TermConditionList),
                    SizedBox(
                      height: 10,
                    ),
                    TermsCondition(),
                    SizedBox(
                      height: 10,
                    ),
                    ProductDetails(),
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

  ProductDetails() {
    return Container(
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
        alignment: Alignment.bottomCenter,
        child: getCommonButton(baseTheme, () {
          if (edt_CustomerName.text != "") {
            navigateTo(context, MaintenanceProductListScreen.routeName,
                arguments: MaintenanceProductListScreenArgument(
                    edt_ContractCode.text,
                    edt_Reverse_StartDate.text,
                    edt_Reverse_EndDate.text));
          } else {
            showCommonDialogWithSingleOption(
                context, "Customer name is required To view Product !",
                positiveButtonTitle: "OK");
          }
        }, "Tap To Go Product Screen",
            textColor: colorBlack,
            backGroundColor: colorWhite,
            radius: 10),
      ),
    );
  }

  Widget ContractCode() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text("Contract Code",
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
              margin: EdgeInsets.only(left: 15, right: 15),
              elevation: 5,
              color: colorWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 15, right: 15),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_ContractCode,
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

  /* Widget ContractType() {
    return InkWell(
      onTap: () {
        showcustomdialogWithOnlyName(
            values: arr_ALL_Name_ID_For_ContractType,
            context1: context,
            controller: edt_ContractType,
            lable: "Contract Type");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Flexible(
                  child: Text("Contract Type",
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
                        controller: edt_ContractType,
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

  ContractTypeStatus() {
    arr_ALL_Name_ID_For_ContractType.clear();
    for (var i = 0; i < 9; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "3 Months";
      } else if (i == 1) {
        all_name_id.Name = "6 Months";
      } else if (i == 2) {
        all_name_id.Name = "9 Months";
      } else if (i == 3) {
        all_name_id.Name = "1 Years";
      } else if (i == 4) {
        all_name_id.Name = "2 Years";
      } else if (i == 5) {
        all_name_id.Name = "3 Years";
      } else if (i == 6) {
        all_name_id.Name = "4 Years";
      } else if (i == 7) {
        all_name_id.Name = "5 Years";
      } else if (i == 8) {
        all_name_id.Name = "10 Years";
      }
      arr_ALL_Name_ID_For_ContractType.add(all_name_id);
    }
  }*/

  Widget Remarks() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text("Remarks",
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
              margin: EdgeInsets.only(left: 15, right: 15),
              elevation: 5,
              color: colorWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 100,
                padding: EdgeInsets.only(left: 15, right: 15),
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_Remarks,
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter Remarks",
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
              margin: EdgeInsets.only(left: 15, right: 15),
              elevation: 5,
              color: colorWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 15, right: 15),
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
            margin: EdgeInsets.only(left: 15, right: 15),
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

  Widget ContactPerson(String ContactPerson,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (edt_CustomerName.text != "") {
                _mainBloc.add(MasterMaintenanceCheckListRequestCallEvent(
                    MasterMaintenanceCheckListRequest(
                        CustomerID: edt_CustomerpkID.text,
                        ContactType: "ContactPerson",
                        LoginUserID: LoginUserID,
                        CompanyId: CompanyID.toString())));
              } else {
                showCommonDialogWithSingleOption(
                    context, "Customer Name Is Required !",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text(title,
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
                  margin: EdgeInsets.only(left: 15, right: 15),
                  elevation: 5,
                  color: colorWhite,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 15, right: 15),
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

  void _onContactPersonResponse(MasterMaintenanceCheckListResponseState state) {
    arr_ALL_Name_ID_For_ContactPerson.clear();
    for (var i = 0; i < state.response.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.Name = state.response.details[i].contactPerson;
      arr_ALL_Name_ID_For_ContactPerson.add(all_name_id);
    }
    showcustomdialogWithOnlyName(
        values: arr_ALL_Name_ID_For_ContactPerson,
        context1: context,
        controller: edt_ContactPerson,
        lable: "Select ContactPerson");
  }

  Widget Contact(String ContactPerson,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (edt_CustomerName.text != "") {
                _mainBloc.add(MasterMaintenanceCheckListRequestCallEvent1(
                    MasterMaintenanceCheckListRequest(
                        CustomerID: edt_CustomerpkID.text,
                        ContactType: "ContactNumber",
                        LoginUserID: LoginUserID,
                        CompanyId: CompanyID.toString())));
              } else {
                showCommonDialogWithSingleOption(
                    context, "Customer Name Is Required !",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text(title,
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
                  margin: EdgeInsets.only(left: 15, right: 15),
                  elevation: 5,
                  color: colorWhite,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 15, right: 15),
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

  void _onContactResponse(MasterMaintenanceCheckListResponseState1 state) {
    arr_ALL_Name_ID_For_ContactNo.clear();
    for (var i = 0; i < state.response.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.Name = state.response.details[i].contactNumber;
      arr_ALL_Name_ID_For_ContactNo.add(all_name_id);
    }
    showcustomdialogWithOnlyName(
        values: arr_ALL_Name_ID_For_ContactNo,
        context1: context,
        controller: edt_ContactNo,
        lable: "Select Contact");
  }

  Widget WarrantyType(String ContactPerson,
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
              _mainBloc.add(MaintenanceCheckListDRPRequestCallEvent(
                  MaintenanceCheckListDRPRequest(
                      CompanyId: CompanyID.toString(),
                      CheckHead: "Warrantytype",
                      LoginUserID: LoginUserID)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text(title,
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
                  margin: EdgeInsets.only(left: 15, right: 15),
                  elevation: 5,
                  color: colorWhite,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 15, right: 15),
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

  void _onWarrantyTypeResponse(MaintenanceCheckListDRPResponseState state) {
    arr_ALL_Name_ID_For_WarrantyType.clear();
    for (var i = 0; i < state.response.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.pkID = state.response.details[i].pkid;
      all_name_id.Name = state.response.details[i].checkDesc;
      arr_ALL_Name_ID_For_WarrantyType.add(all_name_id);
    }
    showcustomdialogWithID(
        values: arr_ALL_Name_ID_For_WarrantyType,
        context1: context,
        controller: edt_WarrantyType,
        controllerID: edt_WarrantyTypeId,
        lable: "Select WarrantyType");
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
              margin: EdgeInsets.only(left: 15, right: 15),
              elevation: 5,
              color: colorWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 100,
                padding: EdgeInsets.only(left: 15, right: 15),
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
                  margin: EdgeInsets.only(left: 15, right: 15),
                  color: colorWhite,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(left: 15, right: 15),
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

  Widget StartDate() {
    return InkWell(
      onTap: () {
        _selectStartDate(context, edt_StartDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              "Start Date *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack, // colorPrimary
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          Card(
            margin: EdgeInsets.only(left: 15, right: 15),
            elevation: 5,
            color: colorWhite, // colorLightGray
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_StartDate.text.isEmpty
                          ? "YYYY-MM-DD"
                          : edt_StartDate.text,
                      style: TextStyle(
                        fontSize: 15,
                        color: edt_StartDate.text.isEmpty
                            ? Colors.grey
                            : Colors.black, // colorGrayDark or colorBlack
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

  Future<void> _selectStartDate(
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
        edt_StartDate.text = DateFormat('dd-MM-yyyy').format(selectedDate);
        edt_Reverse_StartDate.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);

        DateTime endDate =
            _calculateEndDate(selectedDate, selectedDurationMonths);
        edt_EndDate.text = DateFormat('dd-MM-yyyy').format(endDate);
        edt_Reverse_EndDate.text = DateFormat('yyyy-MM-dd').format(endDate);
      });
    }
  }

  Widget ContractType() {
    return InkWell(
      onTap: () {
        showcustomdialogWithOnlyName123(
            values: arr_ALL_Name_ID_For_ContractType,
            context1: context,
            controller: edt_ContractType,
            lable: "Contract Type");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              children: [
                Flexible(
                  child: Text("Contract Type",
                      style: TextStyle(
                          fontSize: 12,
                          color: colorBlack, // colorPrimary
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          SizedBox(height: 5),
          Card(
            margin: EdgeInsets.only(left: 15, right: 15),
            elevation: 5,
            color: colorWhite, // colorLightGray
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
                      enabled: false,
                      controller: edt_ContractType,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "---Select---",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
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

  void showcustomdialogWithOnlyName123({
    List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    String lable,
  }) {
    showDialog(
      context: context1,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(lable),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: values.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(values[index].Name),
                  onTap: () {
                    setState(() {
                      controller.text = values[index].Name;
                      selectedDurationMonths = values[index].durationMonths;

                      // Update end date based on selected contract type and start date
                      if (edt_StartDate.text.isNotEmpty) {
                        DateTime startDate =
                            DateFormat('dd-MM-yyyy').parse(edt_StartDate.text);
                        DateTime endDate = _calculateEndDate(
                            startDate, selectedDurationMonths);

                        edt_EndDate.text =
                            DateFormat('dd-MM-yyyy').format(endDate);
                        edt_Reverse_EndDate.text =
                            DateFormat('yyyy-MM-dd').format(endDate);
                      }
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  DateTime _calculateEndDate(DateTime startDate, int durationMonths) {
    return DateTime(
        startDate.year, startDate.month + durationMonths, startDate.day);
  }

  void ContractTypeStatus() {
    arr_ALL_Name_ID_For_ContractType.clear();
    List<Map<String, dynamic>> contractTypes = [
      {"Name": "3 Months", "Duration": 3},
      {"Name": "6 Months", "Duration": 6},
      {"Name": "9 Months", "Duration": 9},
      {"Name": "1 Year", "Duration": 12},
      {"Name": "2 Years", "Duration": 24},
      {"Name": "3 Years", "Duration": 36},
      {"Name": "4 Years", "Duration": 48},
      {"Name": "5 Years", "Duration": 60},
      {"Name": "10 Years", "Duration": 120},
    ];

    for (var type in contractTypes) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = type["Name"];
      all_name_id.durationMonths = type["Duration"];
      arr_ALL_Name_ID_For_ContractType.add(all_name_id);
    }
  }

  Widget EndDate() {
    return InkWell(
      onTap: () {
        //_selectStartDate(context, edt_StartDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              "End Date",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack, // colorPrimary
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          Card(
            margin: EdgeInsets.only(left: 15, right: 15),
            elevation: 5,
            color: colorWhite, // colorLightGray
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_EndDate.text.isEmpty
                          ? "YYYY-MM-DD"
                          : edt_EndDate.text,
                      style: TextStyle(
                        fontSize: 15,
                        color: edt_EndDate.text.isEmpty
                            ? Colors.grey
                            : Colors.black, // colorGrayDark or colorBlack
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

  /// Save and update section
  _onTapOfSaveVehiclePunchAPICall() async {
    if (edt_IMEINo.text != "") {
      List<MaintenanceProductModel> temp =
          await OfflineDbHelper.getInstance().getMaintenanceProduct();
      if (temp.length != 0) {
        showCommonDialogWithTwoOptions(
            context, "Are you sure you want to Save this record ?",
            negativeButtonTitle: "No",
            positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
          _mainBloc.add(
              MaintenanceAddUpdateRequestCallEvent(MaintenanceAddEditRequest(
            pkID: pkID.toString(),
            InquiryNo: edt_ContractCode.text,
            ContractType: edt_ContractType.text,
            SerialKey: "",
            StartDate: edt_Reverse_StartDate.text,
            EndDate: edt_Reverse_EndDate.text,
            CustomerID: edt_CustomerpkID.text,
            EmployeeID: "0",
            ContactPerson: edt_ContactPerson.text,
            IMEINo: edt_IMEINo.text,
            Remarks: edt_Remarks.text,
            ContactNumber: edt_ContactNo.text,
            ContractFooter: edt_TermConditionFooter.text,
            ContractTNC: edt_TermConditionHeaderID.text,
            Warranty: edt_WarrantyTypeId.text,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString(),
          )));
        });
      } else {
        showCommonDialogWithSingleOption(
            context, "Minimum One Product Is Required !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "IMEINo Is Required !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  void _onBankVoucherSaveResponse(MaintenanceAddUpdateCallResponseState state) {
    showCommonDialogWithSingleOption(context,
        state.maintenanceAddUpdateResponse.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
      navigateTo(context, MaintenanceListScreen.routeName, clearAllStack: true);
    });
  }

  void fillData() async {
    pkID = _editModel.pkID;
    edt_ContractCode.text = _editModel.inquiryNo;
    edt_ContractType.text = _editModel.contractType;
    edt_Remarks.text = _editModel.remarks;
    edt_IMEINo.text = _editModel.iMEINo;
    edt_WarrantyType.text = _editModel.warrantyName;
    edt_WarrantyTypeId.text = _editModel.warranty.toString();
    edt_CustomerName.text = _editModel.customerName;
    edt_CustomerpkID.text = _editModel.customerID.toString();
    edt_ContactPerson.text = _editModel.contactPerson;
    edt_ContactNo.text = _editModel.contactNumber;

    edt_StartDate.text = _editModel.startDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_StartDate.text = _editModel.startDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_EndDate.text = _editModel.endDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_EndDate.text = _editModel.endDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    //edt_TermConditionHeader.text = _editModel.contractTNC;
    edt_TermConditionFooter.text = _editModel.contractFooter;

    if (_editModel.inquiryNo.toString() != "") {
      _mainBloc.add(MaintenanceDetailsListCallEvent(
          LoginUserID,
          MaintenanceDetailsListRequest(
              InquiryNo: _editModel.inquiryNo,
              CompanyId: CompanyID.toString())));
    }
  }

  void _onMaintenanceDetailsListCallResponse(
      MaintenanceDetailsListCallResponseState state) async {
    /*if (state.response.details.length != 0) {
      await OfflineDbHelper.getInstance().deleteALLMaintenanceProduct();

      for (var i = 0; i < state.response.details.length; i++) {

        await OfflineDbHelper.getInstance()
            .insertMaintenanceProduct(MaintenanceProductModel(
          state.response.details[i].pkID.toString(),//String pkID,
          state.response.details[i].inquiryNo,//String InquiryNo,
          state.response.details[i].productID.toString(),//String ProductID,
          state.response.details[i].productName,//String ProductName,
          state.response.details[i].unitPrice.toString(),//String UnitPrice,
          "0.00",//String TaxRate,
          state.response.details[i].quantity.toString(),//String Quantity,
          "0.00",//String TotalAmount,
          state.response.details[i].startDate,//String StartDate,
          state.response.details[i].endDate,//String EndDate,
          state.response.details[i].orderNo,//String OrderNo,
          state.response.details[i].serialKey,//String SerialKey,
          "0",//String ContractMont
          LoginUserID, //String LoginUserID,
          CompanyID.toString(), //String CompanyId,
        ));
      }
    }*/
  }

  /// Extra Screens

  Future<bool> _onBackPressed() async {
    navigateTo(context, MaintenanceListScreen.routeName, clearAllStack: true);
  }
}
