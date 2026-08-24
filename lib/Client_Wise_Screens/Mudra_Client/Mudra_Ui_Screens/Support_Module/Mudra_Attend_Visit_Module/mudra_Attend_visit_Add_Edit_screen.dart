import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Atttend_Visit/Mudra_Attend_Visit_Add_Update_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Complaint_List_Screen_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Attend_Visit_response/Mudra_Attend_Visit_list_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Bloc_Event_State/mudra_bloc.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/Mudra_Attend_Visit_Module/mudra_Attend_visit_list_screen.dart';
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
  MudraAttendVisitListResponseDetails editModel;
  MudraComplaintAddEditArguments2(this.editModel);
}

class MudraAttendVisitAddEdit extends BaseStatefulWidget {
  static const routeName = '/MudraAttendVisitAddEdit';
  final MudraComplaintAddEditArguments2 arguments;

  MudraAttendVisitAddEdit(this.arguments);

  @override
  _MudraAttendVisitAddEditScreen createState() =>
      _MudraAttendVisitAddEditScreen();
}

class _MudraAttendVisitAddEditScreen extends BaseState<MudraAttendVisitAddEdit>
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
  MudraAttendVisitListResponseDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  bool IsCharged = false;

  final TextEditingController edt_ServiceTag = TextEditingController();
  final TextEditingController edt_Complaint = TextEditingController();
  final TextEditingController edt_ComplaintId = TextEditingController();
  final TextEditingController edt_AttendedOnDate_date = TextEditingController();
  final TextEditingController edt_Reverse_AttendedOnDate_date =
      TextEditingController();
  final TextEditingController edt_Status = TextEditingController();
  final TextEditingController edt_Status_Id = TextEditingController();
  final TextEditingController edt_TransectionName = TextEditingController();
  final TextEditingController edt_TransectionID = TextEditingController();
  final TextEditingController edt_VisitNotes = TextEditingController();
  final TextEditingController edt_EngineerNotes = TextEditingController();

  final TextEditingController edt_FromKMS = TextEditingController();
  final TextEditingController edt_ToKMS = TextEditingController();
  final TextEditingController edt_VisitType = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_ChargeType = TextEditingController();
  final TextEditingController edt_ChargeTypePkId = TextEditingController();
  final TextEditingController edt_PreferedTime = TextEditingController();
  final TextEditingController edt_PreferedTime_To = TextEditingController();
  final TextEditingController edt_VisiCharge = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Type = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProductGroup = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Complaint = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TypesOfService = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_AssignedTo = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_VisitType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ChargeType = [];

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
    FetchFollowupPriorityDetails();
    FetchFollowupPriorityDetails2();
    StatusPriorityDetails();

    edt_Status.text = "Open";
    edt_VisitType.text = "Free";
    edt_ChargeType.text = "---Select---";

    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();

    edt_VisitType.addListener(() {
      if (edt_VisitType.text == "Charged") {
        IsCharged = true;
      } else {
        IsCharged = false;
      }

      setState(() {});
    });

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      edt_AttendedOnDate_date.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_Reverse_AttendedOnDate_date.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      /* String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour = selectedTime.hourOfPeriod <= 9
          ? "0" + selectedTime.hourOfPeriod.toString()
          : selectedTime.hourOfPeriod.toString();
      String beforZerominute = selectedTime.minute <= 9
          ? "0" + selectedTime.minute.toString()
          : selectedTime.minute.toString();

      edt_PreferedTime.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;

      edt_PreferedTime_To.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;*/

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
          if (state is MudraAttendVisitAddUpdateSaveResponseState) {
            _onBankVoucherSaveResponse(state);
          }
          if (state is MudraBankVoucherListResponseState) {
            _onComplaintListSuccess(state);
          }
          /* if (state is MayankTransectionModeResponseState) {
            _onTransactionModeCallSuccess(state);
          }
          if (state is MayankBankVoucherSaveResponseState) {
            _onBankVoucherSaveResponse(state);
          }*/
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MudraAttendVisitAddUpdateSaveResponseState) {
            return true;
          }
          if (currentState is MudraBankVoucherListResponseState) {
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
          title: Text('Manage Complaint Visit'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          leading: InkWell(
              onTap: () {
                navigateTo(context, MudraAttendListScreen.routeName);
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
                    _buildSearchView(),
                    SizedBox(height: 15),
                    ProductGroupDropDown3(
                      "Complaint",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                    /*ProductGroupDropDown3(
                      "Complaint",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                      controllerComplaint: edt_Complaint,
                      ComplaintList: arr_ALL_Name_ID_For_Complaint,
                    ),*/
                    SizedBox(height: 15),
                   /* ServiceTag(),
                    SizedBox(height: 15),*/
                    CustomDropDown3("Status",
                        enable1: false,
                        title: "Status",
                        hintTextvalue: "Tap to Select Status",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_Status,
                        Custom_values1: arr_ALL_Name_ID_For_Status),
                    SizedBox(height: 15),
                    AttendedOnDate(),
                    _isForUpdate == true
                        ? Column(
                            children: [
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: _buildPreferredTime()),
                                  Expanded(
                                      flex: 1, child: _buildPreferredTime1()),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(flex: 1, child: FromKMS()),
                        Expanded(flex: 1, child: ToKMS()),
                      ],
                    ),
                    SizedBox(height: 15),
                    CustomDropDown1("Visit Type",
                        enable1: false,
                        title: "Visit Type",
                        hintTextvalue: "Tap to Select Visit Type",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_VisitType,
                        Custom_values1: arr_ALL_Name_ID_For_Folowup_VisitType),
                    Visibility(
                      visible: IsCharged,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          CustomDropDown2("Charge Type",
                              enable1: false,
                              title: "Charge Type *",
                              hintTextvalue: "Tap to Select Charge Type",
                              icon: Icon(Icons.arrow_drop_down),
                              controllerForLeft: edt_ChargeType,
                              Custom_values1: arr_ALL_Name_ID_For_ChargeType),
                          SizedBox(
                            width: 20,
                            height: 15,
                          ),
                          VisiCharge()
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    VisitNotes(),
                    SizedBox(height: 15),
                    EngineerNotes(),
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

  Widget ProductGroupDropDown3(
    String Category, {
    bool enable1,
    Icon icon,
    String title,
    String hintTextvalue,
  }) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (edt_CustomerpkID.text != "") {

                  _mudraBloc.add(MudraBankVoucherListEvent(
                      1,
                      MudraComplaintListRequest(
                          pkID: "0",
                          CustomerID: edt_CustomerpkID.text,
                          ComplaintStatus: "",
                          ComplaintType: "",
                          LoginUserID: LoginUserID,
                          SearchKey: "",
                          PageNo: 1.toString(),
                          PageSize: 99999.toString(),
                          CompanyId: CompanyID.toString())));
              } else {
                showCommonDialogWithSingleOption(
                    context, "Customer Name is Required!",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.pop(context);
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text("Complaint # *",
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
                              controller: edt_Complaint,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "--- Select ---",
                                contentPadding:
                                    EdgeInsets.only(bottom: 12, top: 12),
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 17,
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

  void _onComplaintListSuccess(MudraBankVoucherListResponseState state) {
    arr_ALL_Name_ID_For_Complaint.clear();

    if(state.response.details.isNotEmpty){
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].complaintNotes);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].complaintNo;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].complaintNotes;

        arr_ALL_Name_ID_For_Complaint.add(all_name_id);
      }
      if(arr_ALL_Name_ID_For_Complaint.isNotEmpty){
        showcustomdialogWithMultipleID(
            values: arr_ALL_Name_ID_For_Complaint,
            context1: context,
            controller: edt_Complaint,
            controllerID: edt_ComplaintId,
            controller2: edt_VisitNotes,
            lable: "Select Complaint");

      } else {
        showCommonDialogWithSingleOption(
            context, "Complaint does not exist",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.pop(context);
        });
      }

    } else {
      showCommonDialogWithSingleOption(
          context, "Complaint does not exist",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.pop(context);
      });
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
                                fontSize: 17,
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
    arr_ALL_Name_ID_For_Status.clear();
    for (var i = 0; i <= 7; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        // ---Select---
        all_name_id.Name = "---Select---";
      } else if (i == 1) {
        all_name_id.Name = "Open";
      } else if (i == 2) {
        all_name_id.Name = "Inward";
      } else if (i == 3) {
        all_name_id.Name = "In-Process";
      } else if (i == 4) {
        all_name_id.Name = "Waiting On  Customer";
      } else if (i == 5) {
        all_name_id.Name = "Waiting On Order";
      } else if (i == 6) {
        all_name_id.Name = "Re-Open";
      } else if (i == 7) {
        all_name_id.Name = "Close";
      }
      arr_ALL_Name_ID_For_Status.add(all_name_id);
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

  FetchFollowupPriorityDetails2() {
    arr_ALL_Name_ID_For_ChargeType.clear();
    for (var i = 0; i <= 6; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Free";
      } else if (i == 1) {
        all_name_id.Name = "Cash";
      } else if (i == 2) {
        all_name_id.Name = "Cheque";
      } else if (i == 3) {
        all_name_id.Name = "Paytm";
      } else if (i == 4) {
        all_name_id.Name = "PhonePe";
      } else if (i == 5) {
        all_name_id.Name = "GooglePay";
      } else if (i == 6) {
        all_name_id.Name = "Other";
      }
      arr_ALL_Name_ID_For_ChargeType.add(all_name_id);
    }
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
                                fontSize: 17,
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
    arr_ALL_Name_ID_For_Folowup_VisitType.clear();
    for (var i = 0; i <= 1; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Free";
      } else if (i == 1) {
        all_name_id.Name = "Charged";
      }
      arr_ALL_Name_ID_For_Folowup_VisitType.add(all_name_id);
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
                          fontSize: 17,
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

  Widget ServiceTag() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Service Tag # *",
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
                          controller: edt_ServiceTag,
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
                            fontSize: 17,
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

  Widget FromKMS() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("From KMS",
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
                          controller: edt_FromKMS,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),
                            counterText: "",
                            hintText: "0.00",
                            labelStyle: TextStyle(
                              color: Color(0xFF000000),
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 17,
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

  Widget VisitNotes() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Visit Notes",
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
                          controller: edt_VisitNotes,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Tap to enter Visit Notes",
                            contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),
                            labelStyle: TextStyle(
                              color: Color(0xFF000000),
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 17,
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

  Widget EngineerNotes() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Engineer Notes",
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
                          controller: edt_EngineerNotes,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Tap to enter Engineer Notes",
                            contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),
                            labelStyle: TextStyle(
                              color: Color(0xFF000000),
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 17,
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

  Widget ToKMS() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("To KMS",
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
                          controller: edt_ToKMS,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),
                            counterText: "",
                            hintText: "0.00",
                            labelStyle: TextStyle(
                              color: Color(0xFF000000),
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 17,
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

  Widget VisiCharge() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Visit Charge *",
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
                          controller: edt_VisiCharge,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),
                            counterText: "",
                            hintText: "0.00",
                            labelStyle: TextStyle(
                              color: Color(0xFF000000),
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 17,
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

  Widget AttendedOnDate() {
    return InkWell(
      onTap: () {
        Complaint_Date(
            context, edt_AttendedOnDate_date, edt_Reverse_AttendedOnDate_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Attended On *",
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
                      edt_AttendedOnDate_date.text == null ||
                              edt_AttendedOnDate_date.text == ""
                          ? "YYYY-MM--DD"
                          : edt_AttendedOnDate_date.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_Reverse_AttendedOnDate_date.text == null ||
                                  edt_Reverse_AttendedOnDate_date.text == ""
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
      BuildContext context,
      TextEditingController edt_AttendedOnDate_date,
      TextEditingController edt_Reverse_AttendedOnDate_date) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        edt_AttendedOnDate_date.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_Reverse_AttendedOnDate_date.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Widget _buildPreferredTime() {
    return InkWell(
      onTap: () {
        /* _selectTime(context, edt_PreferedTime);*/
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text("Visit Time-In",
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
                        enabled: false,
                        controller: edt_PreferedTime,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 12, top: 12),
                          counterText: "",
                          hintText: "0.00",
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 17,
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
        //_selectTime1(context, edt_PreferedTime_To);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text("Visit Time-Out",
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
                        enabled: false,
                        controller: edt_PreferedTime_To,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 12, top: 12),
                          counterText: "",
                          hintText: "0.00",
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF000000),
                        ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                        ),
                  ),
                ],
              ),
            ),
          )
          /* Card(
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
          )*/
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
      if (edt_Complaint.text.toString() != "") {
        if (edt_VisitNotes.text.toString() != "") {
          if (IsCharged == true) {
            if (edt_ChargeType.text.toString().trim() != "") {
              if (edt_VisiCharge.text != "") {
                showCommonDialogWithTwoOptions(
                    context, "Are you sure you want to Save this record ?",
                    negativeButtonTitle: "No",
                    positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();

                  _mudraBloc.add(MudraAttendVisitAddUpdateSaveCallEvent(
                      MudraAttendVisitSaveRequest(
                          pkID: pkID.toString(),
                          ComplaintNo: edt_ComplaintId.text,
                          VisitDate: edt_Reverse_AttendedOnDate_date.text,
                          ComplaintStatus: edt_Status.text,
                          CustomerID: edt_CustomerpkID.text,
                          VisitCharge: edt_VisiCharge.text == null
                              ? ""
                              : edt_VisiCharge.text,
                          FromKMS: edt_FromKMS.text,
                          VisitType: edt_VisitType.text,
                          ServiceTag: edt_ServiceTag.text,
                          VisitNotes: edt_VisitNotes.text,
                          EngineerNotes: edt_EngineerNotes.text,
                          VisitChargeType: edt_ChargeType.text,
                          ToKMS: edt_ToKMS.text.toString(),
                          TimeFrom: _editModel.timeFrom.toString(),
                          TimeTo: _editModel.timeTo.toString(),
                          LoginUserID: LoginUserID,
                          VisitDocument: "",
                          CompanyId: CompanyID.toString())));
                });
              } else {
                showCommonDialogWithSingleOption(
                    context, "Visit Charge Amount is required !",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                });
              }
            } else {
              showCommonDialogWithSingleOption(
                  context, "Charge Type is required !",
                  positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                Navigator.of(context).pop();
              });
            }
          } else {
            showCommonDialogWithTwoOptions(
                context, "Are you sure you want to Save this record ?",
                negativeButtonTitle: "No",
                positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
              String temp_timeFrom = "";
              String temp_timeTo = "";

              if(widget.arguments != null){
                 temp_timeFrom = _editModel.timeFrom.toString() == null ? "" : _editModel.timeFrom.toString();
                 temp_timeTo = _editModel.timeTo.toString() == null ? "" : _editModel.timeTo.toString();

              }    else {
                temp_timeFrom = "";  
                temp_timeTo = "";    
              }

              _mudraBloc.add(MudraAttendVisitAddUpdateSaveCallEvent(
                  MudraAttendVisitSaveRequest(
                      pkID: pkID.toString(),
                      ComplaintNo: edt_ComplaintId.text,
                      VisitDate: edt_Reverse_AttendedOnDate_date.text,
                      ComplaintStatus: edt_Status.text,
                      CustomerID: edt_CustomerpkID.text,
                      VisitCharge: "0.00",
                      FromKMS: edt_FromKMS.text,
                      VisitType: edt_VisitType.text,
                      ServiceTag: edt_ServiceTag.text,
                      VisitNotes: edt_VisitNotes.text,
                      EngineerNotes: edt_EngineerNotes.text,
                      VisitChargeType: "",
                      ToKMS: edt_ToKMS.text.toString(),
                      TimeFrom: temp_timeFrom,
                      TimeTo: temp_timeTo,
                      LoginUserID: LoginUserID,
                      VisitDocument: "",
                      CompanyId: CompanyID.toString())));
            });
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Complaint Visit Notes is Required",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }
      } else {
        showCommonDialogWithSingleOption(context, "Complaint # is Required.",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "Customer is Required",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, MudraAttendListScreen.routeName);
  }

  void _onBankVoucherSaveResponse(
      MudraAttendVisitAddUpdateSaveResponseState state) {
    showCommonDialogWithSingleOption(context,
        state.mudraAttendVisitSaveResponse.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, MudraAttendListScreen.routeName, clearAllStack: true);
    });
  }

  void fillData() {
    pkID = _editModel.pkID;

    edt_AttendedOnDate_date.text = _editModel.visitDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_AttendedOnDate_date.text = _editModel.visitDate
        .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_CustomerName.text = _editModel.customerName;
    edt_CustomerpkID.text = _editModel.customerID.toString();

    edt_Complaint.text = _editModel.complaintNo.toString();
    edt_ComplaintId.text = _editModel.complaintID.toString();

    edt_ServiceTag.text = _editModel.serviceTag;
    edt_Status.text = _editModel.complaintStatus;
    edt_PreferedTime.text = _editModel.timeFrom;
    edt_PreferedTime_To.text = _editModel.timeTo;
    edt_FromKMS.text = _editModel.fromKMS.toString();

    edt_ToKMS.text = _editModel.toKMS.toString();

    edt_VisitType.text = _editModel.visitType.toString();

    edt_ChargeType.text = _editModel.visitChargeType;
    edt_VisiCharge.text = _editModel.visitCharge.toString();
    edt_VisitNotes.text = _editModel.visitNotes.toString();
    edt_EngineerNotes.text = _editModel.engineerNotes;
  }
}
