import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Assinto_DropDown_List_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Complaint_Add_Update_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_SericeTag_DropDown_List_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_project_List_DropDown_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Complaint_List_Screen_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Bloc_Event_State/mudra_bloc.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/Mudra_Complaint_Module/Mudra_Complaint_List_Screen.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/search_followup_customer_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class MudraComplaintAddEditArguments2 {
  MudraComplaintListResponseDetails editModel;
  MudraComplaintAddEditArguments2(this.editModel);
}

class MudraComplaintAddEdit extends BaseStatefulWidget {
  static const routeName = '/MudraComplaintAddEdit';
  final MudraComplaintAddEditArguments2 arguments;

  MudraComplaintAddEdit(this.arguments);

  @override
  _MudraComplaintAddEditScreen createState() => _MudraComplaintAddEditScreen();
}

class _MudraComplaintAddEditScreen extends BaseState<MudraComplaintAddEdit>
    with BasicScreen, WidgetsBindingObserver {
  MudraBloc _mudraBloc;
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
  MudraComplaintListResponseDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  final TextEditingController edt_Complaint = TextEditingController();
  final TextEditingController edt_Complaint_date = TextEditingController();
  final TextEditingController edt_Reverse_Complaint_date =
      TextEditingController();
  final TextEditingController edt_Status = TextEditingController();
  final TextEditingController edt_Type = TextEditingController();
  final TextEditingController edt_Type_Id = TextEditingController();
  final TextEditingController edt_ProductGroup = TextEditingController();
  final TextEditingController edt_ProductGroup_Id = TextEditingController();
  final TextEditingController edt_ServiceTag = TextEditingController();
  final TextEditingController edt_ServiceTag_Id = TextEditingController();
  final TextEditingController edt_TypesOfService = TextEditingController();
  final TextEditingController edt_TypesOfService_Id = TextEditingController();
  final TextEditingController edt_AssignedTo = TextEditingController();
  final TextEditingController edt_AssignedTo_Id = TextEditingController();
  final TextEditingController edt_Schedule_date = TextEditingController();
  final TextEditingController edt_Reverse_Schedule_date =
      TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_PreferedTime = TextEditingController();
  final TextEditingController edt_PreferedTime_To = TextEditingController();
  final TextEditingController edt_CompaintNotes = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Type = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProductGroup = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ServiceTag = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TypesOfService = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_AssignedTo = [];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _mudraBloc = MudraBloc(baseBloc);
    myFocusNode = FocusNode();
    PicCodeFocus = FocusNode();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();

    StatusPriorityDetails();
    TypeDetails();
    TypeOfServiceDetails();
    // edt_Priority.addListener(() {
    //   NotesFocusNode.requestFocus();
    // });

    edt_Status.text = "Open";
    edt_Type.text = "---Select Type---";
    edt_TypesOfService.text = "---Select Type---";

    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      edt_Complaint_date.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_Reverse_Complaint_date.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      edt_Schedule_date.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_Reverse_Schedule_date.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour = selectedTime.hourOfPeriod <= 9
          ? "0" + selectedTime.hourOfPeriod.toString()
          : selectedTime.hourOfPeriod.toString();
      String beforZerominute = selectedTime.minute <= 9
          ? "0" + selectedTime.minute.toString()
          : selectedTime.minute.toString();

      edt_PreferedTime.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;
      edt_PreferedTime_To.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;
      /* edt_TransactionDateChequeDate_date.text = selectedDate.day.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.year.toString();
    edt_Reverse_TransactionDateChequeDate_date.text =
        selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();*/

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
      create: (BuildContext context) => _mudraBloc,
      child: BlocConsumer<MudraBloc, MudraStates>(
        builder: (BuildContext context, MudraStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, MudraStates state) {
          if (state is MudraAssignToListResponseState) {
            _onAssignedToDropDownSuccess(state);
          }
          if (state is MudraProjectListResponseState) {
            _onProductGroupDropDownSuccess(state);
          }
          if (state is MudraCompliantAddUpdateSaveResponseState) {
            _onMudraComplaintSaveResponse(state);
          }
          if (state is MudraServiceTagListResponseState) {
            _onServiceTagDropDownSuccess(state);
          }
          /*if (state is MayankBankVoucherSaveResponseState) {
            _onBankVoucherSaveResponse(state);
          }*/
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MudraAssignToListResponseState) {
            return true;
          }
          if (currentState is MudraProjectListResponseState) {
            return true;
          }
          if (currentState is MudraCompliantAddUpdateSaveResponseState) {
            return true;
          }
          if (currentState is MudraServiceTagListResponseState) {
            return true;
          }
          /*if (currentState is MayankTransectionModeResponseState) {
            return true;
          }
          if (currentState is MayankBankVoucherSaveResponseState) {
            return true;
          }*/
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
          title: Text('Generate - Register Customer Complaint'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          leading: InkWell(
              onTap: () {
                navigateTo(context, MudraCompliantListScreen.routeName);
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
                    Complaint(),
                    SizedBox(height: 15),
                    ComplaintDate(),
                    SizedBox(height: 15),
                    CustomDropDown1("Status",
                        enable1: false,
                        title: "Status",
                        hintTextvalue: "Tap to Select Status",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_Status,
                        Custom_values1: arr_ALL_Name_ID_For_Folowup_Status),
                    SizedBox(height: 15),
                    CustomDropDown2("Type",
                        enable1: false,
                        title: "Type",
                        hintTextvalue: "---Select Type---",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_Type,
                        Custom_values1: arr_ALL_Name_ID_For_Type),
                    SizedBox(height: 15),
                    _buildSearchView(),
                    SizedBox(height: 15),
                    ProductGroupDropDown3(
                      "ProductGroup",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                      controllerProductGroup: edt_ProductGroup,
                      ProductGroupList: arr_ALL_Name_ID_For_ProductGroup,
                    ),
                    SizedBox(height: 15),
                    ServiceTagDropDown(
                      "ServiceTag",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                      controllerServiceTag: edt_ServiceTag,
                      ServiceTagList: arr_ALL_Name_ID_For_ServiceTag,
                    ),
                    SizedBox(height: 15),
                    CustomDropDown3("Types Of Service",
                        enable1: false,
                        title: "Types Of Service",
                        hintTextvalue: "---Select Type---",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_TypesOfService,
                        Custom_values1: arr_ALL_Name_ID_For_TypesOfService),
                    SizedBox(height: 15),
                    AssignedToDropDown(
                      "Assigned To",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                      controllerAssignedTo: edt_AssignedTo,
                      AssignedToList: arr_ALL_Name_ID_For_AssignedTo,
                    ),
                    SizedBox(height: 15),
                    ScheduleDate(),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(flex: 1, child: _buildPreferredTime()),
                        Expanded(flex: 1, child: _buildPreferredTime1()),
                      ],
                    ),
                    SizedBox(height: 15),
                    ComplaintNotes(),
                    SizedBox(height: 30),
                    Container(
                      height: 50,
                      width: 150,
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

  StatusPriorityDetails() {
    arr_ALL_Name_ID_For_Folowup_Status.clear();
    for (var i = 0; i <= 6; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Open";
      } else if (i == 1) {
        all_name_id.Name = "Inward";
      } else if (i == 2) {
        all_name_id.Name = "In-Process";
      } else if (i == 3) {
        all_name_id.Name = "Waiting On  Customer";
      } else if (i == 4) {
        all_name_id.Name = "Waiting On Order";
      } else if (i == 5) {
        all_name_id.Name = "Re-Open";
      } else if (i == 6) {
        all_name_id.Name = "Close";
      }
      arr_ALL_Name_ID_For_Folowup_Status.add(all_name_id);
    }
  }

  Widget CustomDropDown2(String Category,
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

  TypeDetails() {
    arr_ALL_Name_ID_For_Type.clear();
    for (var i = 0; i <= 5; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "---Select Type---";
      } else if (i == 1) {
        all_name_id.Name = "Online";
      } else if (i == 2) {
        all_name_id.Name = "Offline";
      } else if (i == 3) {
        all_name_id.Name = "On-Site";
      } else if (i == 4) {
        all_name_id.Name = "Remote";
      } else if (i == 5) {
        all_name_id.Name = "Telephonic";
      } else if (i == 6) {
        all_name_id.Name = "New Installation";
      }
      arr_ALL_Name_ID_For_Type.add(all_name_id);
    }
  }

  Widget CustomDropDown3(String Category,
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

  TypeOfServiceDetails() {
    arr_ALL_Name_ID_For_TypesOfService.clear();
    for (var i = 0; i <= 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "---Select Type---";
      } else if (i == 1) {
        all_name_id.Name = "AMC ";
      } else if (i == 2) {
        all_name_id.Name = "Chargeable ";
      } else if (i == 3) {
        all_name_id.Name = "Warranty";
      } else if (i == 4) {
        all_name_id.Name = "FOC";
      }
      arr_ALL_Name_ID_For_TypesOfService.add(all_name_id);
    }
  }

/*  Widget TypeDropDown3(
    String Type, {
    bool enable1,
    Icon icon,
    TextEditingController controllerType,
    List<ALL_Name_ID> TypeList,
  }) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            */ /*_mainBloc.add(
                VehicleDriverDesignationDropdownRequestEvent(
                    DriverDesignationIDListRequest(
                        DesigCode: "DRIVER", CompanyId: CompanyID))),*/ /*
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Type",
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
                              controller: controllerType,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "---select---",
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

  void _onTypeDropDownSuccess(MayankTransectionModeResponseState state) {
    arr_ALL_Name_ID_For_Type.clear();
    for (var i = 0; i < state.transectionModeListResponse.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.pkID = state.transectionModeListResponse.details[i].pkID;
      all_name_id.Name =
          state.transectionModeListResponse.details[i].walletName;
      arr_ALL_Name_ID_For_Type.add(all_name_id);
    }

    if (arr_ALL_Name_ID_For_Type.length != 0) {
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_Type,
          context1: context,
          controller: edt_Type,
          controllerID: edt_Type_Id,
          lable: "Select Type");
    }
  }*/

  //ProductGroup

  Widget ProductGroupDropDown3(
    String ProductGroup, {
    bool enable1,
    Icon icon,
    TextEditingController controllerProductGroup,
    List<ALL_Name_ID> ProductGroupList,
  }) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                _mudraBloc.add(MudraProjectListEvent(MudraProjectListRequest(
              pkID: "0",
              LoginUserID: LoginUserID,
              Searchkey: "",
              PageNo: "1",
              PageSize: "100",
              CompanyId: CompanyID.toString(),
            ))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Product Group",
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
                              controller: controllerProductGroup,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "---select---",
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

  void _onProductGroupDropDownSuccess(MudraProjectListResponseState state) {
    arr_ALL_Name_ID_For_ProductGroup.clear();
    for (var i = 0; i < state.response.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.pkID = state.response.details[i].pkID;
      all_name_id.Name = state.response.details[i].productGroupName;
      arr_ALL_Name_ID_For_ProductGroup.add(all_name_id);
    }

    if (arr_ALL_Name_ID_For_ProductGroup.length != 0) {
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_ProductGroup,
          context1: context,
          controller: edt_ProductGroup,
          controllerID: edt_ProductGroup_Id,
          lable: "Select Product Group");
    }
  }

  Widget ServiceTagDropDown(
    String ServiceTag, {
    bool enable1,
    Icon icon,
    TextEditingController controllerServiceTag,
    List<ALL_Name_ID> ServiceTagList,
  }) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                _mudraBloc.add(MudraServiceTagListEvent(MudraServiceListRequest(
              CustomerID: edt_CustomerpkID.text,
              CompanyId: CompanyID.toString(),
            ))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Service Tag #",
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
                              controller: controllerServiceTag,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "---select---",
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

  void _onServiceTagDropDownSuccess(MudraServiceTagListResponseState state) {
    arr_ALL_Name_ID_For_ServiceTag.clear();
    for (var i = 0; i < state.response.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.pkID = state.response.details[i].pkID;
      all_name_id.Name = state.response.details[i].inquiryNo;
      arr_ALL_Name_ID_For_ServiceTag.add(all_name_id);
    }

    if (arr_ALL_Name_ID_For_ServiceTag.length != 0) {
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_ServiceTag,
          context1: context,
          controller: edt_ServiceTag,
          controllerID: edt_ServiceTag_Id,
          lable: "Select Service Tag");
    }
  }

  Widget AssignedToDropDown(
    String AssignedTo, {
    bool enable1,
    Icon icon,
    TextEditingController controllerAssignedTo,
    List<ALL_Name_ID> AssignedToList,
  }) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                _mudraBloc.add(MudraAssignToListEvent(MudraAssignToRequest(
              OrgCode: "",
              LoginUserID: LoginUserID,
              SearchKey: "",
              PageNo: "1",
              PageSize: "9999",
              CompanyId: CompanyID.toString(),
            ))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Assigned To",
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
                              controller: controllerAssignedTo,
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

  void _onAssignedToDropDownSuccess(MudraAssignToListResponseState state) {
    arr_ALL_Name_ID_For_AssignedTo.clear();
    for (var i = 0; i < state.response.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.pkID = state.response.details[i].pkID;
      all_name_id.Name = state.response.details[i].employeeName;
      arr_ALL_Name_ID_For_AssignedTo.add(all_name_id);
    }

    if (arr_ALL_Name_ID_For_AssignedTo.length != 0) {
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_AssignedTo,
          context1: context,
          controller: edt_AssignedTo,
          controllerID: edt_AssignedTo_Id,
          lable: "Select Assigned To");
    }
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
            child: Text("Customer Name *",
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
                          contentPadding: EdgeInsets.only(bottom: 12, top: 12),
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

        _mudraBloc.add(MudraSearchBankVoucherCustomerListByNameCallEvent(
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

  Widget Complaint() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Complaint #",
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
                          controller: edt_Complaint,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: myFocusNode,
                          maxLength: 14,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),
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

  Widget ComplaintNotes() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Complaint Description *",
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
                          controller: edt_CompaintNotes,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Tap to enter Complaint Notes",
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

  Widget ComplaintDate() {
    return InkWell(
      onTap: () {
        Complaint_Date(context, edt_Complaint_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Complaint Date *",
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
                      edt_Complaint_date.text == null ||
                              edt_Complaint_date.text == ""
                          ? "YYYY-MM--DD"
                          : edt_Complaint_date.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_Reverse_Complaint_date.text == null ||
                                  edt_Reverse_Complaint_date.text == ""
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

  Future<void> Complaint_Date(
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
        edt_Complaint_date.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_Reverse_Complaint_date.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Widget ScheduleDate() {
    return InkWell(
      onTap: () {
        Complaint_Date(context, edt_Schedule_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Schedule Date *",
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
                      edt_Schedule_date.text == null ||
                              edt_Schedule_date.text == ""
                          ? "YYYY-MM--DD"
                          : edt_Schedule_date.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_Reverse_Schedule_date.text == null ||
                                  edt_Reverse_Schedule_date.text == ""
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

  Future<void> Schedule_Date(
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
        edt_Schedule_date.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_Reverse_Schedule_date.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
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
            child: Text("Preferred Time",
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
            margin: EdgeInsets.only(left: 15, right: 15),
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

  Widget _buildPreferredTime1() {
    return InkWell(
      onTap: () {
        _selectTime1(context, edt_PreferedTime_To);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text("Preferred Time",
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
            margin: EdgeInsets.only(left: 15, right: 15),
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
                      edt_PreferedTime_To.text == null ||
                              edt_PreferedTime_To.text == ""
                          ? "HH:MM:SS"
                          : edt_PreferedTime_To.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_PreferedTime_To.text == null ||
                                  edt_PreferedTime_To.text == ""
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

  Future<void> _selectTime1(BuildContext contextdialog,
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

        edt_PreferedTime_To.text = beforZeroHour +
            ":" +
            beforZerominute +
            " " +
            AM_PM; //picked_s.periodOffset.toString();
      });
  }

  _onTapOfSaveVehiclePunchAPICall() {
    if (edt_CustomerName.text.toString() != "") {
      if (edt_Complaint_date.text.toString() != "") {
        if (edt_CompaintNotes.text.toString() != "") {
          DateTime FbrazilianDate =
              new DateFormat("dd-MM-yyyy").parse(edt_Complaint_date.text);
          DateTime NbrazilianDate =
              new DateFormat("dd-MM-yyyy").parse(edt_Schedule_date.text);

          if (FbrazilianDate.isBefore(NbrazilianDate)) {
            showCommonDialogWithTwoOptions(
                context, "Are you sure you want to Save this record ?",
                negativeButtonTitle: "No",
                positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
              _mudraBloc.add(MudraCompliantAddUpdateSaveCallEvent(
                  MudraComplaintSaveRequest(
                      pkID: pkID.toString(),
                      ComplaintNo: edt_Complaint.text,
                      ComplaintDate: edt_Reverse_Complaint_date.text,
                      ComplaintStatus: edt_Status.text,
                      CustomerID: edt_CustomerpkID.text,
                      ProductGroup: edt_ProductGroup.text,
                      ReferenceNo: "",
                      ServiceType: edt_TypesOfService.text,
                      ServiceTag: edt_ServiceTag.text,
                      ComplaintNotes: edt_CompaintNotes.text,
                      ComplaintType: edt_Type.text,
                      EmployeeID: edt_AssignedTo_Id.text,
                      PreferredDate: edt_Reverse_Schedule_date.text,
                      TimeFrom: edt_PreferedTime.text,
                      TimeTo: edt_PreferedTime_To.text,
                      LoginUserID: LoginUserID,
                      CompanyId: CompanyID.toString())));
            });
          } else {
            if (FbrazilianDate.isAtSameMomentAs(NbrazilianDate)) {
              showCommonDialogWithTwoOptions(context,
                  "Are you sure you want to Save this Complaint Details ?",
                  negativeButtonTitle: "No",
                  positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
                Navigator.of(context).pop();
                _mudraBloc.add(MudraCompliantAddUpdateSaveCallEvent(
                    MudraComplaintSaveRequest(
                        pkID: pkID.toString(),
                        ComplaintNo: edt_Complaint.text,
                        ComplaintDate: edt_Reverse_Complaint_date.text,
                        ComplaintStatus: edt_Status.text,
                        CustomerID: edt_CustomerpkID.text,
                        ProductGroup: edt_ProductGroup.text,
                        ReferenceNo: "",
                        ServiceType: edt_TypesOfService.text,
                        ServiceTag: edt_ServiceTag.text,
                        ComplaintNotes: edt_CompaintNotes.text,
                        ComplaintType: edt_Type.text,
                        EmployeeID: edt_AssignedTo_Id.text,
                        PreferredDate: edt_Reverse_Schedule_date.text,
                        TimeFrom: edt_PreferedTime.text,
                        TimeTo: edt_PreferedTime_To.text,
                        LoginUserID: LoginUserID,
                        CompanyId: CompanyID.toString())));
              });
            } else {
              showCommonDialogWithSingleOption(context,
                  "Schedule Date Should be greater than Complaint Date !",
                  positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                Navigator.of(context).pop();
              });
            }
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Complaint Notes is Required", positiveButtonTitle: "OK",
              onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }
      } else {
        showCommonDialogWithSingleOption(context, "Complaint Date is required.",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showCommonDialogWithSingleOption(
          context, "Select Proper Customer From the list",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, MudraCompliantListScreen.routeName);
  }

  void _onMudraComplaintSaveResponse(
      MudraCompliantAddUpdateSaveResponseState state) {
    showCommonDialogWithSingleOption(
        context, state.mudraComplaintSaveResponse.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, MudraCompliantListScreen.routeName,
          clearAllStack: true);
    });
  }

  void fillData() {
    pkID = _editModel.pkID;

    edt_Complaint_date.text = _editModel.complaintDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_Complaint_date.text = _editModel.complaintDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_Schedule_date.text = _editModel.preferredDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_Schedule_date.text = _editModel.preferredDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_Complaint.text = _editModel.complaintNo;
    edt_Status.text = _editModel.complaintStatus;
    edt_Type.text = _editModel.complaintType;
    edt_CustomerName.text = _editModel.customerName;
    edt_CustomerpkID.text = _editModel.customerID.toString();
    edt_ProductGroup.text = _editModel.productGroup;

    edt_ServiceTag.text = _editModel.serviceTag;

    edt_ServiceTag_Id.text = _editModel.serviceTag.toString();

    edt_TypesOfService.text = _editModel.serviceType;
    edt_AssignedTo.text = _editModel.employeeName;
    edt_AssignedTo_Id.text = _editModel.employeeID.toString();
    edt_PreferedTime.text = _editModel.timeFrom;
    edt_PreferedTime_To.text = _editModel.timeTo;
    edt_CompaintNotes.text = _editModel.complaintNotes;
  }
}
