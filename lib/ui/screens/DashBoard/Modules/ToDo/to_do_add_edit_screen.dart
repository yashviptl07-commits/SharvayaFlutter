import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soleoserp/blocs/other/bloc_modules/todo/todo_bloc.dart';
import 'package:soleoserp/models/api_requests/other/all_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/task_category_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_header_save_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_save_sub_details_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/all_employee_List_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/todo_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/pushnotification/get_report_to_token_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/to_do_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/to_do_serach_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/todo_bg_services.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/General_Constants.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;

class AddUpdateTODOScreenArguments {
  ToDoDetails editModel;
  String ListStatus;
  String ListLoginID;
  List<File> documentList;
  AddUpdateTODOScreenArguments(
      this.ListStatus, this.ListLoginID, this.editModel, this.documentList);
}

class ToDoAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/ToDoWidgetAddEditScreen';
  final AddUpdateTODOScreenArguments arguments;
  ToDoAddEditScreen(this.arguments);

  @override
  _ToDoAddEditScreenState createState() => _ToDoAddEditScreenState();
}

class _ToDoAddEditScreenState extends BaseState<ToDoAddEditScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController edt_Category = TextEditingController();
  final TextEditingController edt_CategoryID = TextEditingController();
  final TextEditingController edt_Priority = TextEditingController();
  final TextEditingController edt_Location = TextEditingController();
  final TextEditingController edt_AssignTo = TextEditingController();
  final TextEditingController edt_AssignToID = TextEditingController();
  final TextEditingController edt_InqNo = TextEditingController();
  final TextEditingController edt_FollowupStatus = TextEditingController();
  final TextEditingController edt_TaskDetails = TextEditingController();
  final TextEditingController edt_StartDate = TextEditingController();
  final TextEditingController edt_StartDateReverse = TextEditingController();
  final TextEditingController edt_StartTime = TextEditingController();
  final TextEditingController edt_StartTimewith24Hours =
      TextEditingController();
  final TextEditingController edt_DueDate = TextEditingController();
  final TextEditingController edt_DueDateReverse = TextEditingController();
  final TextEditingController edt_ProductDeliveryDate = TextEditingController();
  final TextEditingController edt_ProductDeliveryDateReverse =
      TextEditingController();
  final TextEditingController edt_ProductDeliveryTime = TextEditingController();
  final TextEditingController edt_ProductDeliveryTimeDatewith24Hours =
      TextEditingController();
  final TextEditingController edt_DueTime = TextEditingController();
  final TextEditingController edt_DueTimeDatewith24Hours =
      TextEditingController();
  final TextEditingController edt_CloserDetails = TextEditingController();
  final TextEditingController edt_TransferTo = TextEditingController();
  final TextEditingController edt_ReAssignTo = TextEditingController();
  final TextEditingController edt_ReAssignToID = TextEditingController();
  final TextEditingController edt_CompletionDate = TextEditingController();
  final TextEditingController edt_CompletionDateReverse =
      TextEditingController();
  final TextEditingController edt_EmployeeID = TextEditingController();
  final TextEditingController edt_EmployeeName = TextEditingController();
  final TextEditingController edt_Token = TextEditingController();
  final TextEditingController edt_ReToken = TextEditingController();
  final TextEditingController edt_TAG_EmployeeID = TextEditingController();
  final TextEditingController edt_TAG_EmployeeName = TextEditingController();
  final TextEditingController edt_ReminderType = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Category = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Priority = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_AssignTo = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TransferTo = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ReminderType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];

  List<String> tempdd = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime1 = TimeOfDay(hour: 23, minute: 59);
  TimeOfDay selectedTime2 = TimeOfDay(hour: 00, minute: 00);
  DateTime SeletedStartDate = DateTime.now();
  DateTime SeletedDueDate = DateTime.now();
  DateTime SeletedCompletionDate = DateTime.now();
  bool viewVisibleCompletionDate = true;
  bool viewVisibleTransferToDropdown = false;
  FocusNode NotesFocusNode;
  ToDoBloc _toDoBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  int CompanyID = 0;
  String LoginUserID = "";
  int pkID = 0;
  bool _isForUpdate;
  ToDoDetails _editModel;
  List<File> MultipleVideoList = [];
  final imagepicker = ImagePicker();
  bool permissionGranted;
  bool ISCHECKED = false;
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  bool IsForClient = false;
  String ReportToToken = "";
  bool IsforEmployeeAddEdit = false;
  bool checkFlagBasedOnReminder = false;

  void showWidgetCompletionDate() {
    setState(() {
      viewVisibleCompletionDate = true;
    });
  }

  void hideWidgetCompletionDate() {
    setState(() {
      viewVisibleCompletionDate = false;
      edt_CompletionDate.text = "";
      edt_CompletionDateReverse.text = "";
      edt_CloserDetails.text = "";
    });
  }

  void showWidgetTrasferToDropDown() {
    setState(() {
      viewVisibleTransferToDropdown = true;
    });
  }

  void hideWidgetTrasferToDropDown() {
    setState(() {
      viewVisibleTransferToDropdown = false;
    });
  }

  textListener() {
    print("Current Text is ${edt_TransferTo.text}");
    if (edt_TransferTo.text == "Complete Task") {
      showWidgetCompletionDate();
      hideWidgetTrasferToDropDown();
    } else {
      hideWidgetCompletionDate();
    }
    if (edt_TransferTo.text == "Re-Assign Task") {
      showWidgetTrasferToDropDown();
      hideWidgetCompletionDate();
    } else {
      hideWidgetTrasferToDropDown();
    }
    print("Current Transfer TO Bool is ${viewVisibleTransferToDropdown}");
  }

  @override
  void dispose() {
    super.dispose();
    NotesFocusNode.dispose();
    edt_TransferTo.dispose();
  }

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "SI08-SB94-MY45-RY15" ||
        _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
      IsForClient = true;
    } else {
      IsForClient = false;
    }

    CategoryTypeDetails();
    FetchPriorityDetails();
    FetchFollowupStatusDetails();
    FetchTransferToDetails();
    ReminderTypeDetails();
    edt_ReminderType.text = "Just Once";

    edt_TransferTo.addListener(textListener);
    NotesFocusNode = FocusNode();
    edt_TaskDetails.addListener(() {
      NotesFocusNode.requestFocus();
    });

    _toDoBloc = ToDoBloc(baseBloc);
    _toDoBloc.add(GetReportToTokenRequestEvent(GetReportToTokenRequest(
        CompanyId: CompanyID.toString(),
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString())));
    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      edt_TransferTo.text = "Add Activity";

      fillData(_editModel);
    } else {
      IsforEmployeeAddEdit = true;

      edt_TransferTo.text = "Add Activity";
      edt_StartDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_StartDateReverse.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      edt_DueDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_DueDateReverse.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      edt_EmployeeName.text = _offlineLoggedInData.details[0].employeeName;
      edt_EmployeeID.text =
          _offlineLoggedInData.details[0].employeeID.toString();

      String AM_PM1 =
          selectedTime1.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour1 = selectedTime1.hourOfPeriod <= 9
          ? "0" + selectedTime1.hourOfPeriod.toString()
          : selectedTime1.hourOfPeriod.toString();
      String beforZerominute1 = selectedTime1.minute <= 9
          ? "0" + selectedTime1.minute.toString()
          : selectedTime1.minute.toString();

      String AM_PM2 =
          selectedTime2.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour2 = selectedTime2.hourOfPeriod <= 9
          ? "0" + selectedTime2.hourOfPeriod.toString()
          : selectedTime2.hourOfPeriod.toString();
      String beforZerominute2 = selectedTime2.minute <= 9
          ? "0" + selectedTime2.minute.toString()
          : selectedTime2.minute.toString();

      edt_DueTime.text = beforZeroHour1 + ":" + beforZerominute1 + " " + AM_PM1;
      edt_DueTimeDatewith24Hours.text =
          selectedTime1.hour.toString() + ":" + beforZerominute1;
      edt_StartTime.text =
          beforZeroHour2 + ":" + beforZerominute2 + " " + AM_PM2;
      edt_StartTimewith24Hours.text =
          selectedTime2.hour.toString() + ":" + beforZerominute2;

      edt_Priority.text = "Low";
      edt_CustomerName.text = "";
      edt_CustomerpkID.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _toDoBloc,
      child: BlocConsumer<ToDoBloc, ToDoStates>(
        builder: (BuildContext context, ToDoStates state) {
          if (state is GetReportToTokenResponseState) {
            _onGetTokenfromReportopersonResult(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GetReportToTokenResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ToDoStates state) {
          if (state is TaskCategoryCallResponseState) {
            _onLeaveRequestTypeSuccessResponse(state);
          }
          if (state is ToDoSaveHeaderOtherState) {
            _OnSaveToDoHeaderResponse(state);
          }
          if (state is ToDoSaveSubDetailsState) {
            _OnSaveToDoSubResponse(state);
          }

          if (state is FCMNotificationResponseNewState) {
            _onRecevedNotification(state);
          }
          if (state is ALL_EmployeeNameListResponseState) {
            _onALLEmployeeListByStatusCallSuccess(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is TaskCategoryCallResponseState ||
              currentState is ToDoSaveHeaderOtherState ||
              currentState is ToDoSaveSubDetailsState ||
              currentState is FCMNotificationResponseNewState ||
              currentState is ALL_EmployeeNameListResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    getcurrentTimeInfoFromMain(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text('To-Do Details'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
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
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(10),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskDescription(),
                        SizedBox(
                          height: 10,
                        ),
                        showcustomdialogWithID1("Task Category",
                            enable1: false,
                            title: "Task Category *",
                            hintTextvalue: "Tap to Select Task Category",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_Category,
                            controllerpkID: edt_CategoryID,
                            Custom_values1: arr_ALL_Name_ID_For_Category),
                        SizedBox(
                          height: 10,
                        ),
                        CustomDropDown1("Priority",
                            enable1: false,
                            title: "Priority ",
                            hintTextvalue: "Tap to Select Priority",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_Priority,
                            Custom_values1: arr_ALL_Name_ID_For_Priority),
                        SizedBox(
                          height: 10,
                        ),
                        Area(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildEmplyeeListView(),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: true,
                          child: CheckboxListTile(
                            value: ISCHECKED == null ? false : ISCHECKED,
                            onChanged: (value) {

                              setState(
                                () {
                                  ISCHECKED = value;
                                  if (ISCHECKED == true) {
                                    checkFlagBasedOnReminder = true;
                                    edt_ReminderType.text = "Just Once";
                                  } else {
                                    checkFlagBasedOnReminder = false;
                                    edt_ReminderType.text = "Just Once";
                                  }
                                },
                              );
                            },
                            title: Text(
                              "Reminder Alert",
                              style: TextStyle(color: colorPrimary),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            visible: checkFlagBasedOnReminder == true,
                            child: ReminderType()),
                        SizedBox(
                          height: 10,
                        ),
                        _buildNextFollowupDate(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildPreferredTime(),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            visible: checkFlagBasedOnReminder == false,
                            child: _buildDueDate()),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                            visible: checkFlagBasedOnReminder == false,
                            child: _buildDueTime()),
                        SizedBox(
                          height: 10,
                        ),
                        Attachments(),
                        SizedBox(
                          height: 10,
                        ),
                        TransferTo(),
                        SizedBox(
                          height: 10,
                        ),
                        ActualCompletion(),
                        TransferToNew(),
                        SizedBox(
                          height: 10,
                        ),
                        ClosingRemarks(),
                        SizedBox(
                          height: 30,
                        ),
                        getCommonButton(baseTheme, () {
                          Save1();
                        }, "Save", backGroundColor: Colors.blueAccent),
                      ]))),
        ),
      ),
    );
  }

  Widget TransferTo() {
    return GestureDetector(
      onTap: () => showcustomdialogWithOnlyName(
          values: arr_ALL_Name_ID_For_TransferTo,
          context1: context,
          controller: edt_TransferTo,
          lable: "Select Transfer To"),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Transfer To",
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
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 50,
                padding:
                EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_TransferTo,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: "Select Transfer To",
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
    );
  }

  Widget ReminderType() {
    return GestureDetector(
      onTap: () => showcustomdialogWithOnlyName(
          values: arr_ALL_Name_ID_For_ReminderType,
          context1: context,
          controller: edt_ReminderType,
          lable: "Select Reminder Type"),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Reminder Type",
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
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 50,
                padding:
                EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_ReminderType,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: "Select Reminder Type",
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
    );
  }

  Widget ActualCompletion() {
    return Visibility(
      visible: viewVisibleCompletionDate,
      child: GestureDetector(
        onTap: () => _selectCompletionDate(
            context, edt_CompletionDate),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                EdgeInsets.only(left: 10, right: 10),
                child: Text("Actual Completion",
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
                color: colorLightGray,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15)),
                child: Container(
                  height: 50,
                  padding:
                  EdgeInsets.only(left: 20, right: 20),
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            controller: edt_CompletionDate,
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: "DD-MM-YYYY",
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
                        Icons.date_range,
                        color: colorGrayDark,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget TransferToNew() {
    return Visibility(
      visible: viewVisibleTransferToDropdown,
      child: GestureDetector(
        onTap: () {
          _toDoBloc.add(ALLEmployeeNameCallEvent(
              ALLEmployeeNameRequest(
                  CompanyId: CompanyID.toString())));
        },
        child: Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin:
                  EdgeInsets.only(left: 10, right: 10),
                  child: Text("Transfer To",
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
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15)),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(
                        left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: edt_ReAssignTo,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText:
                                "Select Transfer To",
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
            )),
      ),
    );
  }

  Widget ClosingRemarks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Closing Remarks",
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
        Padding(
          padding: EdgeInsets.only(left: 7, right: 7, top: 10),
          child: TextFormField(
            controller: edt_CloserDetails,
            minLines: 2,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Enter Remarks',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(10)),
                )),
          ),
        )
      ],
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, ToDoListScreen.routeName, clearAllStack: true);
  }

  Future<void> _selectCompletionDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        currentDate: SeletedCompletionDate,
        context: context,
        initialDate: selectedDate,
        firstDate: SeletedStartDate,
        lastDate: selectedDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        SeletedCompletionDate = picked;
        edt_CompletionDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();

        edt_CompletionDateReverse.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }


  CategoryTypeDetails() {
    arr_ALL_Name_ID_For_Category.clear();
    for (var i = 0; i < 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Account";
      } else if (i == 1) {
        all_name_id.Name = "Administration";
      } else if (i == 2) {
        all_name_id.Name = "ClientVisit";
      } else if (i == 3) {
        all_name_id.Name = "Communication";
      } else if (i == 4) {
        all_name_id.Name = "Development";
      }
      arr_ALL_Name_ID_For_Category.add(all_name_id);
    }
  }

  FetchPriorityDetails() {
    arr_ALL_Name_ID_For_Priority.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "High";
      } else if (i == 1) {
        all_name_id.Name = "Medium";
      } else if (i == 2) {
        all_name_id.Name = "Low";
      }
      arr_ALL_Name_ID_For_Priority.add(all_name_id);
    }
  }

  FetchFollowupStatusDetails() {
    arr_ALL_Name_ID_For_Folowup_Status.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Initialized";
      } else if (i == 1) {
        all_name_id.Name = "Pending";
      } else if (i == 2) {
        all_name_id.Name = "Sucess";
      }
      arr_ALL_Name_ID_For_Folowup_Status.add(all_name_id);
    }
  }

  FetchTransferToDetails() {
    arr_ALL_Name_ID_For_TransferTo.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Re-Assign Task";
      } else if (i == 1) {
        all_name_id.Name = "Complete Task";
      } else if (i == 2) {
        all_name_id.Name = "Add Activity";
      }
      arr_ALL_Name_ID_For_TransferTo.add(all_name_id);
    }
  }

  ReminderTypeDetails() {
    arr_ALL_Name_ID_For_ReminderType.clear();
    for (var i = 0; i < 7; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Just Once";
      } else if (i == 1) {
        all_name_id.Name = "Daily";
      } else if (i == 2) {
        all_name_id.Name = "Weekly";
      } else if (i == 3) {
        all_name_id.Name = "Every Month";
      } else if (i == 4) {
        all_name_id.Name = "Quarterly";
      } else if (i == 5) {
        all_name_id.Name = "Half Yearly";
      } else if (i == 6) {
        all_name_id.Name = "Yearly";
      }
      arr_ALL_Name_ID_For_ReminderType.add(all_name_id);
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
            onTap: () => CreateDialogDropdown(Category),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
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
                  color: colorLightGray,
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

  CreateDialogDropdown(String category) {
    if (category == "Task Category") {
      if (IsforEmployeeAddEdit == true) {
        _toDoBloc
          ..add(TaskCategoryListCallEvent(TaskCategoryListRequest(
              pkID: "", CompanyId: CompanyID.toString())));
      }
    }
  }

  void _onLeaveRequestTypeSuccessResponse(TaskCategoryCallResponseState state) {
    if (state.taskCategoryResponse.details.length != 0) {
      arr_ALL_Name_ID_For_Category.clear();
      for (var i = 0; i < state.taskCategoryResponse.details.length; i++) {
        print("description : " +
            state.taskCategoryResponse.details[i].taskCategoryName);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.taskCategoryResponse.details[i].taskCategoryName;
        all_name_id.pkID = state.taskCategoryResponse.details[i].pkID;
        arr_ALL_Name_ID_For_Category.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_Category,
          context1: context,
          controller: edt_Category,
          controllerID: edt_CategoryID,
          lable: "Select Task Category");
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
            onTap: () {
              if (IsforEmployeeAddEdit == true) {
                showcustomdialogWithOnlyName(
                    values: Custom_values1,
                    context1: context,
                    controller: controllerForLeft,
                    lable: "Select $Category");
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
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
                  color: colorLightGray,
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

  Widget _buildEmplyeeListView() {
    return InkWell(
      onTap: () {
        if (IsforEmployeeAddEdit == true) {
          _toDoBloc.add(ALLEmployeeNameCallEvent(
              ALLEmployeeNameRequest(CompanyId: CompanyID.toString())));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Assign To *",
                  style: TextStyle(
                      fontSize: 13,
                      color: colorBlack,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ]),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Select"),
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

  Widget TaskDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Task Description *",
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
        Padding(
          padding: EdgeInsets.only(left: 7, right: 7 /*, top: 10*/),
          child: TextFormField(
            controller: edt_TaskDetails,
            minLines: 2,
            maxLines: 5,
            enabled: IsforEmployeeAddEdit,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Enter Description',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
          ),
        )
      ],
    );
  }

  Widget Area() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Location",
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
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: edt_Location,
                      enabled: IsforEmployeeAddEdit,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "Tap to enter Location",
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
                  Icons.house,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildNextFollowupDate() {
    return InkWell(
      onTap: () {
        if (IsforEmployeeAddEdit == true) {
          _selectNextFollowupDate(context, edt_StartDate);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("StartDate *",
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
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_StartDate.text == null || edt_StartDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_StartDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_StartDateReverse.text == null ||
                                  edt_StartDateReverse.text == ""
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

  Widget _buildPreferredTime() {
    return InkWell(
      onTap: () {
        if (IsforEmployeeAddEdit == true) {
          _selectTime(context, edt_StartTime);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Start Time",
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
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_StartTime.text == null || edt_StartTime.text == ""
                          ? "HH:MM:SS"
                          : edt_StartTime.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_StartTime.text == null ||
                                  edt_StartTime.text == ""
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

  Widget _buildDueDate() {
    return InkWell(
      onTap: () {
        if (IsforEmployeeAddEdit == true) {
          _selectDueDate(context, edt_DueDate);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("DueDate *",
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
                      edt_DueDate.text == null || edt_DueDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_DueDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_DueDateReverse.text == null ||
                                  edt_DueDateReverse.text == ""
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

  Widget _buildDueTime() {
    return InkWell(
      onTap: () {
        showTimePicker(
            context: context,
            initialTime: selectedTime,
            builder: (BuildContext context, Widget child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child,
              );
            }).then((dynamic value) {
          setState(() {
            selectedTime = value;

            String AM_PM =
                selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
            String beforZeroHour = selectedTime.hourOfPeriod <= 9
                ? "0" + selectedTime.hourOfPeriod.toString()
                : selectedTime.hourOfPeriod.toString();
            String beforZerominute = selectedTime.minute <= 9
                ? "0" + selectedTime.minute.toString()
                : selectedTime.minute.toString();

            edt_DueTime.text =
                beforZeroHour + ":" + beforZerominute + " " + AM_PM;

            edt_DueTimeDatewith24Hours.text =
                selectedTime.hour.toString() + ":" + beforZerominute;
          });

          print(value.format(context).toString());
        });
        /*if (IsforEmployeeAddEdit == true) {
          _selectDueTime(context, edt_DueTime);
        }*/
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Due Time",
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
                      edt_DueTime.text == null || edt_DueTime.text == ""
                          ? "HH:MM:SS"
                          : edt_DueTime.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color:
                              edt_DueTime.text == null || edt_DueTime.text == ""
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

  Future<void> _selectNextFollowupDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        currentDate: SeletedStartDate,
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        SeletedStartDate = picked;

        String AddZero = selectedDate.month <= 9
            ? "0" + selectedDate.month.toString()
            : selectedDate.month.toString();

        edt_StartDate.text = selectedDate.day.toString() +
            "-" +
            AddZero +
            "-" +
            selectedDate.year.toString();
        edt_StartDateReverse.text = selectedDate.year.toString() +
            "-" +
            AddZero +
            "-" +
            selectedDate.day.toString();
      });
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController F_datecontroller) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime2,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime2)
      setState(() {
        selectedTime2 = picked_s;
        /*edt_StartTimewith24Hours*/
        print("24HourseTime" +
            selectedTime2.hour.toString() +
            ":" +
            selectedTime2.minute.toString());

        String AM_PM =
            selectedTime2.periodOffset.toString() == "12" ? "PM" : "AM";
        String beforZeroHour = selectedTime2.hourOfPeriod <= 9
            ? "0" + selectedTime2.hourOfPeriod.toString()
            : selectedTime2.hourOfPeriod.toString();
        String beforZerominute = selectedTime2.minute <= 9
            ? "0" + selectedTime2.minute.toString()
            : selectedTime2.minute.toString();

        edt_StartTime.text = beforZeroHour +
            ":" +
            beforZerominute +
            " " +
            AM_PM; //picked_s.periodOffset.toString();
        edt_StartTimewith24Hours.text =
            selectedTime2.hour.toString() + ":" + beforZerominute;
      });
  }

  Future<void> _selectDueDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        currentDate: SeletedDueDate,
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        SeletedDueDate = picked;

        String AddZero = selectedDate.month <= 9
            ? "0" + selectedDate.month.toString()
            : selectedDate.month.toString();

        edt_DueDate.text = selectedDate.day.toString() +
            "-" +
            AddZero +
            "-" +
            selectedDate.year.toString();
        edt_DueDateReverse.text = selectedDate.year.toString() +
            "-" +
            AddZero +
            "-" +
            selectedDate.day.toString();
      });
  }

  void _OnSaveToDoHeaderResponse(ToDoSaveHeaderOtherState state) async {

    String updatemsg = _isForUpdate == true ? " Updated " : " Created ";
    String notiTitle = "To-Do";

    ///state.inquiryHeaderSaveResponse.details[0].column3;
    String notibody = "To-Do " +
        edt_TaskDetails.text +
        " is " +
        updatemsg +
        " And AssignTo " +
        edt_EmployeeName.text +
        " By " +
        _offlineLoggedInData.details[0].employeeName;

    if (edt_TransferTo.text == "Re-Assign Task") {
      final Map<String, dynamic> message = {
        'message': {
          'token': edt_ReToken.text,
          "notification": {"body": notibody, "title": notiTitle},
          'data': {
            "body": notibody,
            "title": notiTitle,
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
          },
        }
      };

      if (edt_Token.text != "") {
        _toDoBloc.add(FCMNotificationRequestNewEvent(message));
      }
    } else {
      final Map<String, dynamic> message = {
        'message': {
          'token': edt_Token.text,
          "notification": {"body": notibody, "title": notiTitle},
          'data': {
            "body": notibody,
            "title": notiTitle,
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
          },
        }
      };

      if (edt_Token.text != "") {
        _toDoBloc.add(FCMNotificationRequestNewEvent(message));
      }
    }


    for (var i = 0; i < state.toDoSaveHeaderResponse.details.length; i++) {
      int pk = state.toDoSaveHeaderResponse.details[i].column1;
      String ActionTaken = "";
      String ActionDescription = "";
      String EmpID = "";

      if (edt_TransferTo.text == "Complete Task") {
        if (edt_CompletionDate.text == null || edt_CompletionDate.text == "") {
          ActionTaken = "Task Initiated";
          ActionDescription = "Task Assigned To " + edt_EmployeeName.text;
          EmpID = edt_EmployeeID.text;
        } else {
          ActionTaken = "Task Completed";
          ActionDescription = "Task Completed On " + edt_CompletionDate.text;
          EmpID = edt_EmployeeID.text;
        }
      } else if (edt_TransferTo.text == "Re-Assign Task") {
        ActionTaken = "Task Transferred";
        ActionDescription = "Task Transferred From " +
            edt_EmployeeName.text +
            "To" +
            edt_ReAssignTo.text;
        EmpID = edt_ReAssignToID.text;
      } else {
        ActionTaken = "Task Activity";
        ActionDescription = "Task Activity Added";
        EmpID = edt_EmployeeID.text;
      }
      _toDoBloc.add(ToDoSaveSubDetailsEvent(
          state.context,
          pk,
          ToDoSaveSubDetailsRequest(
              ActionTaken: ActionTaken,
              ActionDescription: ActionDescription,
              EmployeeID: EmpID,
              Remarks:
                  edt_CloserDetails.text == null ? "" : edt_CloserDetails.text,
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString())));
    }
  }

  void _OnSaveToDoSubResponse(ToDoSaveSubDetailsState state) {
    String Msg = _isForUpdate == true
        ? "Task Updated Successfully !"
        : "Task Added Successfully !";

    showCommonDialogWithSingleOption(state.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, ToDoListScreen.routeName, clearAllStack: true);
    });
  }

  void fillData(ToDoDetails editModel) {
    pkID = editModel.pkID;
    edt_TaskDetails.text = editModel.taskDescription;
    edt_Category.text = editModel.taskCategory;
    edt_CategoryID.text = editModel.taskCategoryId.toString();
    edt_Priority.text = editModel.priority;
    edt_EmployeeName.text = editModel.employeeName;
    edt_EmployeeID.text = editModel.employeeID.toString();
    edt_CustomerName.text = editModel.CustomerName;
    edt_CustomerpkID.text = editModel.CustomerID.toString();
    edt_Token.text = editModel.tokenNo;

    if (widget.arguments.documentList.isNotEmpty) {
      MultipleVideoList.clear();
      for (int i = 0; i < widget.arguments.documentList.length; i++) {
        MultipleVideoList.add(widget.arguments.documentList[i]);
      }
    }

    if (editModel.fromEmployeeID ==
        _offlineLoggedInData.details[0].employeeID) {
      IsforEmployeeAddEdit = true;
    } else {
      IsforEmployeeAddEdit = false;
    }

    if (editModel.startDate != "" &&
        editModel.startDate != "1900-01-01T00:00:00") {
      SeletedStartDate = DateTime.parse(editModel.startDate);
      edt_StartDate.text = editModel.startDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_StartDateReverse.text = editModel.startDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
      edt_StartTime.text = editModel.startDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "h:mm a");
      edt_StartTimewith24Hours.text = editModel.startDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "H:mm a");
    } else {
      edt_StartDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_StartDateReverse.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();
      TimeOfDay selectedTime = TimeOfDay.now();

      String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour = selectedTime.hourOfPeriod <= 9
          ? "0" + selectedTime.hourOfPeriod.toString()
          : selectedTime.hourOfPeriod.toString();
      String beforZerominute = selectedTime.minute <= 9
          ? "0" + selectedTime.minute.toString()
          : selectedTime.minute.toString();
      edt_StartTime.text = beforZeroHour + ":" + beforZerominute + " " + AM_PM;
      edt_StartTimewith24Hours.text =
          selectedTime.hour.toString() + ":" + beforZerominute;
    }

    if (editModel.dueDate != "" || editModel.dueDate != "1900-01-01T00:00:00") {
      SeletedDueDate = DateTime.parse(editModel.dueDate);
      edt_DueDate.text = editModel.dueDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_DueDateReverse.text = editModel.dueDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
      edt_DueTime.text = editModel.dueDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "h:mm a");
      edt_DueTimeDatewith24Hours.text = editModel.dueDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "H:mm a");
    } else {
      edt_DueDate.text = SeletedDueDate.day.toString() +
          "-" +
          SeletedDueDate.month.toString() +
          "-" +
          SeletedDueDate.year.toString();
      edt_DueDateReverse.text = SeletedDueDate.year.toString() +
          "-" +
          SeletedDueDate.month.toString() +
          "-" +
          SeletedDueDate.day.toString();
      TimeOfDay selectedTime = TimeOfDay.now();

      String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour = selectedTime.hourOfPeriod <= 9
          ? "0" + selectedTime.hourOfPeriod.toString()
          : selectedTime.hourOfPeriod.toString();
      String beforZerominute = selectedTime.minute <= 9
          ? "0" + selectedTime.minute.toString()
          : selectedTime.minute.toString();

      edt_DueTime.text = beforZeroHour + ":" + beforZerominute + " " + AM_PM;
      edt_DueTimeDatewith24Hours.text =
          selectedTime.hour.toString() + ":" + beforZerominute;
    }

    if (editModel.deliveryDate != "" ||
        editModel.deliveryDate != "1900-01-01T00:00:00") {
      if (editModel.deliveryDate.isNotEmpty) {
        SeletedDueDate = DateTime.parse(editModel.deliveryDate);
        edt_ProductDeliveryDate.text = editModel.deliveryDate.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
        edt_ProductDeliveryDateReverse.text = editModel.deliveryDate
            .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
        edt_ProductDeliveryTime.text = editModel.deliveryDate.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "h:mm a");
        edt_ProductDeliveryTimeDatewith24Hours.text = editModel.deliveryDate
            .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "H:mm a");
      }
    } else {
      edt_ProductDeliveryDate.text = SeletedDueDate.day.toString() +
          "-" +
          SeletedDueDate.month.toString() +
          "-" +
          SeletedDueDate.year.toString();
      edt_ProductDeliveryDateReverse.text = SeletedDueDate.year.toString() +
          "-" +
          SeletedDueDate.month.toString() +
          "-" +
          SeletedDueDate.day.toString();
      TimeOfDay selectedTime = TimeOfDay.now();

      String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour = selectedTime.hourOfPeriod <= 9
          ? "0" + selectedTime.hourOfPeriod.toString()
          : selectedTime.hourOfPeriod.toString();
      String beforZerominute = selectedTime.minute <= 9
          ? "0" + selectedTime.minute.toString()
          : selectedTime.minute.toString();

      edt_ProductDeliveryTime.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;
      edt_ProductDeliveryTimeDatewith24Hours.text =
          selectedTime.hour.toString() + ":" + beforZerominute;
    }

    if (editModel.completionDate != "1900-01-01T00:00:00" &&
        editModel.completionDate != "") {
      edt_CompletionDate.text = editModel.completionDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_CompletionDateReverse.text = editModel.completionDate
          .getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

      SeletedCompletionDate = DateTime.parse(editModel.completionDate);
    } else {
      edt_CompletionDate.text = "";
      edt_CompletionDateReverse.text = "";
    }
    edt_CloserDetails.text = "";
    edt_Location.text = editModel.location;

    ISCHECKED = editModel.reminder;

    if (ISCHECKED == true) {
      checkFlagBasedOnReminder = true;
    } else {
      checkFlagBasedOnReminder = false;
    }

    edt_ReminderType.text =
    editModel.reminderMonth.toString() == "0"
        ? "Just Once"
        : editModel.reminderMonth.toString() == "2"
        ? "Daily"
        : editModel.reminderMonth.toString() == "7"
        ? "Weekly"
        : editModel.reminderMonth.toString() == "1"
        ? "Every Month"
        : editModel.reminderMonth.toString() == "3"
        ? "Quarterly"
        : editModel.reminderMonth.toString() == "6"
        ? "Half Yearly"
        : editModel.reminderMonth.toString() == "12"
        ? "Yearly"
        : editModel.reminderMonth.toString();
  }

  void _onGetTokenfromReportopersonResult(GetReportToTokenResponseState state) {
    ReportToToken = state.response.details[0].reportPersonTokenNo;
  }

  void _onRecevedNotification(FCMNotificationResponseNewState state) {}

  Save1() async {

    print(edt_ReminderType.text);

    bool ISclosingRemerks = false;
    bool ISCompletion = false;
    bool ISAssignTo = true;

    if (edt_TransferTo.text == "Complete Task") {
      if (edt_CloserDetails.text != "") {
        ISclosingRemerks = true;
        ISCompletion = true;
      } else {
        ISclosingRemerks = false;
      }

      if (edt_CompletionDate.text != "") {
        ISCompletion = true;
      } else {
        ISCompletion = false;
      }
    }

    if (edt_TransferTo.text == "Add Activity") {
      if (edt_CloserDetails.text != "") {
        ISclosingRemerks = true;
        ISCompletion = true;
      } else {
        ISclosingRemerks = true;
        ISCompletion = true;
      }
    }

    if (edt_TransferTo.text == "Re-Assign Task") {
      if (edt_CloserDetails.text != "") {
        ISclosingRemerks = true;
        ISCompletion = true;
      } else {
        ISclosingRemerks = false;
      }

      if (edt_ReAssignTo.text != "") {
        ISAssignTo = true;
      } else {
        ISAssignTo = false;
      }
    }

    DateTime SbrazilianDate =
        new DateFormat("dd-MM-yyyy").parse(edt_StartDate.text);
    DateTime DbrazilianDate =
        new DateFormat("dd-MM-yyyy").parse(edt_DueDate.text);

    if (edt_TaskDetails.text.toString() != "") {
      if (edt_Category.text.toString() != "") {
        if (edt_EmployeeName.text.toString() != "") {
          if (edt_DueDate.text.toString() != "") {
            if (ISclosingRemerks == true) {
              if (ISCompletion == true) {
                if (ISAssignTo == true) {
                  List<File> tempMultipleVideoList = [];
                  if (MultipleVideoList.length != 0) {
                    for (int i = 0; i < MultipleVideoList.length; i++) {
                      final extension = p.extension(MultipleVideoList[i].path);
                      if (extension.toString() == ".jpg" ||
                          extension.toString() == ".jpeg" ||
                          extension.toString() == ".png") {
                        final dir = await path_provider.getTemporaryDirectory();
                        int timestamp1 = DateTime.now().millisecondsSinceEpoch;
                        final targetPath = dir.absolute.path +
                            "/" +
                            i.toString() +
                            timestamp1.toString() +
                            extension.toString();
                        File file1231 = await testCompressAndGetFile(
                            MultipleVideoList[i], targetPath);
                        tempMultipleVideoList.add(file1231);
                      } else {
                        final dir = await path_provider.getTemporaryDirectory();
                        int timestamp1 = DateTime.now().millisecondsSinceEpoch;
                        final targetPath = dir.absolute.path +
                            "/" +
                            i.toString() +
                            timestamp1.toString() +
                            extension.toString();
                        tempMultipleVideoList
                            .add(MultipleVideoList[i].renameSync(targetPath));
                      }
                    }
                  }

                  if (SbrazilianDate.isBefore(DbrazilianDate)) {
                    if (edt_CompletionDate.text != "") {
                      DateTime CbrazilianDate = new DateFormat("dd-MM-yyyy")
                          .parse(edt_CompletionDate.text);

                      print("DueDateddf" +
                          "Completion Date : " +
                          CbrazilianDate.getFormattedDate("dd-mm-yyyy") +
                          " StartDate : " +
                          SbrazilianDate.getFormattedDate("dd-mm-yyyy"));

                      if (SbrazilianDate.isBefore(CbrazilianDate))
                      // if(CbrazilianDate.isBefore(SbrazilianDate))
                      {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to Save ToDo Details ?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();

                          _toDoBloc.add(ToDoSaveHeaderOtherEvent(
                              context,
                              pkID,
                              ToDoHeaderSaveRequest(
                                  Priority: edt_Priority.text,
                                  TaskDescription: edt_TaskDetails.text,
                                  Location: edt_Location.text,
                                  TaskCategoryID: edt_CategoryID.text,
                                  StartDate: edt_StartDateReverse.text +
                                      " " +
                                      edt_StartTimewith24Hours.text,
                                  DueDate: edt_DueDateReverse.text +
                                      " " +
                                      edt_DueTimeDatewith24Hours.text,
                                  CompletionDate:
                                      edt_CompletionDateReverse.text == null
                                          ? ""
                                          : edt_CompletionDateReverse.text,
                                  LoginUserID: LoginUserID,
                                  EmployeeID: edt_EmployeeID.text,
                                  Reminder: ISCHECKED == true ? "1" : "0",
                                  ReminderMonth:
                                  edt_ReminderType.text == "Just Once"
                                      ? "0"
                                      : edt_ReminderType.text == "Daily"
                                      ? "2"
                                      : edt_ReminderType.text == "Weekly"
                                      ? "7"
                                      : edt_ReminderType.text == "Every Month"
                                      ? "1"
                                      : edt_ReminderType.text == "Quarterly"
                                      ? "3"
                                      : edt_ReminderType.text == "Half Yearly"
                                      ? "6"
                                      : edt_ReminderType.text == "Yearly"
                                      ? "12"
                                      : edt_ReminderType.text,
                                  Latitude:
                                      SharedPrefHelper.instance.getLongitude(),
                                  Longitude:
                                      SharedPrefHelper.instance.getLatitude(),
                                  ClosingRemarks: edt_CloserDetails.text == null
                                      ? ""
                                      : edt_CloserDetails.text,
                                  CompanyId: CompanyID.toString(),
                                  CustomerID: edt_CustomerpkID.text != ""
                                      ? edt_CustomerpkID.text
                                      : "",
                                  DeliveryDate:
                                      edt_ProductDeliveryDateReverse.text +
                                          " " +
                                          edt_ProductDeliveryTimeDatewith24Hours
                                              .text),
                              tempMultipleVideoList));
                        });
                      } else {
                        if (SbrazilianDate.isAtSameMomentAs(DbrazilianDate)) {
                          showCommonDialogWithTwoOptions(context,
                              "Are you sure you want to Save ToDo Details ?",
                              negativeButtonTitle: "No",
                              positiveButtonTitle: "Yes",
                              onTapOfPositiveButton: () {
                            Navigator.of(context).pop();

                            _toDoBloc.add(ToDoSaveHeaderOtherEvent(
                                context,
                                pkID,
                                ToDoHeaderSaveRequest(
                                    Priority: edt_Priority.text,
                                    TaskDescription: edt_TaskDetails.text,
                                    Location: edt_Location.text,
                                    TaskCategoryID: edt_CategoryID.text,
                                    StartDate: edt_StartDateReverse.text +
                                        " " +
                                        edt_StartTimewith24Hours.text,
                                    DueDate: edt_DueDateReverse.text +
                                        " " +
                                        edt_DueTimeDatewith24Hours.text,
                                    CompletionDate:
                                        edt_CompletionDateReverse.text == null
                                            ? ""
                                            : edt_CompletionDateReverse.text,
                                    LoginUserID: LoginUserID,
                                    EmployeeID: edt_EmployeeID.text,
                                    Reminder: ISCHECKED == true ? "1" : "0",
                                    ReminderMonth: edt_ReminderType.text == "Just Once"
                                        ? "0"
                                        : edt_ReminderType.text == "Daily"
                                        ? "2"
                                        : edt_ReminderType.text == "Weekly"
                                        ? "7"
                                        : edt_ReminderType.text == "Every Month"
                                        ? "1"
                                        : edt_ReminderType.text == "Quarterly"
                                        ? "3"
                                        : edt_ReminderType.text == "Half Yearly"
                                        ? "6"
                                        : edt_ReminderType.text == "Yearly"
                                        ? "12"
                                        : edt_ReminderType.text,
                                    Latitude:
                                        SharedPrefHelper.instance.getLatitude(),
                                    Longitude: SharedPrefHelper.instance
                                        .getLongitude(),
                                    ClosingRemarks:
                                        edt_CloserDetails.text == null
                                            ? ""
                                            : edt_CloserDetails.text,
                                    CompanyId: CompanyID.toString(),
                                    CustomerID: edt_CustomerpkID.text != ""
                                        ? edt_CustomerpkID.text
                                        : "",
                                    DeliveryDate: edt_ProductDeliveryDateReverse
                                            .text +
                                        " " +
                                        edt_ProductDeliveryTimeDatewith24Hours
                                            .text),
                                tempMultipleVideoList));
                          });
                        }

                        showCommonDialogWithSingleOption(context,
                            "Completion Date Should be greater than Start Date !",
                            positiveButtonTitle: "OK");
                      }
                    } else {
                      showCommonDialogWithTwoOptions(context,
                          "Are you sure you want to Save ToDo Details ?",
                          negativeButtonTitle: "No", positiveButtonTitle: "Yes",
                          onTapOfPositiveButton: () {
                        Navigator.of(context).pop();

                        _toDoBloc.add(ToDoSaveHeaderOtherEvent(
                            context,
                            pkID,
                            ToDoHeaderSaveRequest(
                                Priority: edt_Priority.text,
                                TaskDescription: edt_TaskDetails.text,
                                Location: edt_Location.text,
                                TaskCategoryID: edt_CategoryID.text,
                                StartDate: edt_StartDateReverse.text +
                                    " " +
                                    edt_StartTimewith24Hours.text,
                                DueDate: edt_DueDateReverse.text +
                                    " " +
                                    edt_DueTimeDatewith24Hours.text,
                                CompletionDate:
                                    edt_CompletionDateReverse.text == null
                                        ? ""
                                        : edt_CompletionDateReverse.text,
                                LoginUserID: LoginUserID,
                                EmployeeID: edt_EmployeeID.text,
                                Reminder: ISCHECKED == true ? "1" : "0",
                                ReminderMonth: edt_ReminderType.text == "Just Once"
                                    ? "0"
                                    : edt_ReminderType.text == "Daily"
                                    ? "2"
                                    : edt_ReminderType.text == "Weekly"
                                    ? "7"
                                    : edt_ReminderType.text == "Every Month"
                                    ? "1"
                                    : edt_ReminderType.text == "Quarterly"
                                    ? "3"
                                    : edt_ReminderType.text == "Half Yearly"
                                    ? "6"
                                    : edt_ReminderType.text == "Yearly"
                                    ? "12"
                                    : edt_ReminderType.text,
                                Latitude:
                                    SharedPrefHelper.instance.getLatitude(),
                                Longitude:
                                    SharedPrefHelper.instance.getLongitude(),
                                ClosingRemarks: edt_CloserDetails.text == null
                                    ? ""
                                    : edt_CloserDetails.text,
                                CompanyId: CompanyID.toString(),
                                CustomerID: edt_CustomerpkID.text != ""
                                    ? edt_CustomerpkID.text
                                    : "",
                                DeliveryDate: edt_ProductDeliveryDateReverse
                                        .text +
                                    " " +
                                    edt_ProductDeliveryTimeDatewith24Hours
                                        .text),
                            tempMultipleVideoList));
                      });
                    }
                  } else {
                    // print("DatesRemoveSymobles"+ " False : " +"SDate : " +SDate +" DDate : " +DDate );

                    if (SbrazilianDate.isAtSameMomentAs(DbrazilianDate)) {
                      showCommonDialogWithTwoOptions(context,
                          "Are you sure you want to Save ToDo Details ?",
                          negativeButtonTitle: "No", positiveButtonTitle: "Yes",
                          onTapOfPositiveButton: () {
                        Navigator.of(context).pop();

                        _toDoBloc.add(ToDoSaveHeaderOtherEvent(
                            context,
                            pkID,
                            ToDoHeaderSaveRequest(
                                Priority: edt_Priority.text,
                                TaskDescription: edt_TaskDetails.text,
                                Location: edt_Location.text,
                                TaskCategoryID: edt_CategoryID.text,
                                StartDate: edt_StartDateReverse.text +
                                    " " +
                                    edt_StartTimewith24Hours.text,
                                DueDate: edt_DueDateReverse.text +
                                    " " +
                                    edt_DueTimeDatewith24Hours.text,
                                CompletionDate:
                                    edt_CompletionDateReverse.text == null
                                        ? ""
                                        : edt_CompletionDateReverse.text,
                                LoginUserID: LoginUserID,
                                EmployeeID: edt_EmployeeID.text,
                                Reminder: ISCHECKED == true ? "1" : "0",
                                ReminderMonth: edt_ReminderType.text == "Just Once"
                                    ? "0"
                                    : edt_ReminderType.text == "Daily"
                                    ? "2"
                                    : edt_ReminderType.text == "Weekly"
                                    ? "7"
                                    : edt_ReminderType.text == "Every Month"
                                    ? "1"
                                    : edt_ReminderType.text == "Quarterly"
                                    ? "3"
                                    : edt_ReminderType.text == "Half Yearly"
                                    ? "6"
                                    : edt_ReminderType.text == "Yearly"
                                    ? "12"
                                    : edt_ReminderType.text,
                                Latitude:
                                    SharedPrefHelper.instance.getLatitude(),
                                Longitude:
                                    SharedPrefHelper.instance.getLongitude(),
                                ClosingRemarks: edt_CloserDetails.text == null
                                    ? ""
                                    : edt_CloserDetails.text,
                                CompanyId: CompanyID.toString(),
                                CustomerID: edt_CustomerpkID.text != ""
                                    ? edt_CustomerpkID.text
                                    : "",
                                DeliveryDate: edt_ProductDeliveryDateReverse
                                        .text +
                                    " " +
                                    edt_ProductDeliveryTimeDatewith24Hours
                                        .text),
                            tempMultipleVideoList));
                      });
                    } else {
                      showCommonDialogWithSingleOption(context,
                          "Due Date Should be greater than Start Date !",
                          positiveButtonTitle: "OK");
                    }
                  }
                } else {
                  showCommonDialogWithSingleOption(
                      context, "Re-Assign To is Required !",
                      positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                    Navigator.pop(context);
                  });
                }
              } else {
                showCommonDialogWithSingleOption(
                    context, "Completion Date is Required !",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.pop(context);
                });
              }
            } else {
              showCommonDialogWithSingleOption(
                  context, "Closing Remarks is Required !",
                  positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                Navigator.pop(context);
              });
            }
          } else {
            showCommonDialogWithSingleOption(context, "Due Date is Required !",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.pop(context);
            });
          }
        } else {
          showCommonDialogWithSingleOption(context, "Assign To is Required !",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.pop(context);
          });
        }
      } else {
        showCommonDialogWithSingleOption(context, "Task Category is Required !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.pop(context);
        });
      }
    } else {
      showCommonDialogWithSingleOption(
          context, "Task Description is Required !", positiveButtonTitle: "OK",
          onTapOfPositiveButton: () {
        Navigator.pop(context);
      });
    }
  }

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "e-office-desk-flutter",
      "private_key_id": "dee49b88aa4fda701ba25636836d5cb4a6bf7fd8",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCkch6ADZ5bnHGF\nxerUqS4SSo7O79XBztHqJv89POOS3ZZFJallYVjN/2coiyj7CUGH7btoyTijRoCn\nz+X2sEf0kK9gdbq7mQ0tM6ka0nr7uYZIYpLLDJfLtvzPIaKwGUIvjQ/Jmd8kKuau\no7iziv0TH2nwtuZKslued7nanisd343zNnNS22nXnKS/QR/blSesOp5ohPYegufk\nJlIQByXjF+TnRQNbOD3erERIG6U1BBm6ybZdWZCum5q9+nVr2TxaLphOTeBaVsac\n2s5cvSinw47bfpRZ0aVGAatK0/lRBstmlXD/p7D/Uy+8kHivB2EtBMugPT1WBUoE\n+iXGqjk/AgMBAAECggEAH45GjAwQ90NuBV2VUnmkfZ4RCWS8gBRP877H+9hTUzty\nOpKfjvS/Nchs4zrRAlskWBEmhVUXqT0+MvWSC2SIakXZYYk17AnSnXnsWVlKgEN5\noSpJQO2Js23J1XV+4ov2R2mqPeVpDGevHJQOPWXOanz8t1RhnLPdIOuYnnr7ix+s\nJn/FfuItz8tulpfxhOXX6U4hguJmZRTM8VWNx0OXm01JNdrRc01kE94XRIY2sclU\nEWkq0nmRbR0lY5+PY9heuuxgz7dfUyyhk5nxR/wNGsE9WRIMAIk0UtWDhq8kpHge\nCkgUuGKmlvpwcKAwvrMZa//KXkSUxa+SfQKT7KI4AQKBgQDXhCCol60o7zZUFt3G\nCB5X3H8YlfEmAqN9olruJ/HdSvV3Mj83qn3u3+UYUOFdHNhGOMk/N73i0NifhwX2\nUNEFPGCTRqfbQFZw2j6BkgeRM/70WviUHZLKHsh6RO+bjqtGVELupr0l1/ZEpkMu\n9HylK2WQkQ6RT6nbkzN3mzuIIQKBgQDDVhbZvaFK9t40mzolx0NqiUIkauzdos9q\nIdM5oWDecEytevdQ8JaoNhpS/xiBlJaJWvlgb8c+V0bWuHuZvmAaD+Y1UBzre3fF\nJRAmUe3VhbcVu3zHL2/wFCHv9eDg8VMAIyJTb+QM6XWFPlmi/jWPusHzceQGXEDi\nIy3ofGgVXwKBgQCTgeO4gNgMBG5y75OrTzM1f72d3kLHeVbdTppeFwj8JaoMg1+x\nggffz27GTdVyHaQJrCRSGJzm+XrK9WenR3lI1CJlqx6IemivpTDTDlgPkj8WkI1D\nE1q87ITa6wP0vJmN8W4+WfFsTXxJUGL7aGtHwYQqhp4p5xSjLQU1ABKnAQKBgEoZ\ndU+iNPZ4EbEJFZTRM0zNxs6D1Vj6cw5CyJr7EgEvvpasp/cHXU9wPqovZP96+2Qd\no64mmQGYICJCF3kqE9CvKVgeDOpziuq5dZfjyoIOWHahCeORpjf/myQpNOaABUlv\nCo12S59uTIuALIa9QlpEsWCFWsfi5SYjzD1+PAmnAoGBAL/na3HFfrrp2vvsRo+w\nCe0sH3Kfiugut41wtbl1cog370HCaRVeHucSmMxg97mNPScN7/KFBwpvkQqq0g9G\nJCKwK8EfWlM/dDFfCIJcXgQcj3+1cnvHzyiJ5EdUadDKsCnNk4chk9Xn4NKKB/94\ni2eaHQ6MAdCxLFeSjL+SIjwe\n-----END PRIVATE KEY-----\n",
      "client_email": "e-office-desk-flutter@appspot.gserviceaccount.com",
      "client_id": "100799278322772767315",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/e-office-desk-flutter%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();
    return credentials.accessToken.data;
  }

  Attachments() {
    return Container(
      child: Card(
        color: Colors.pink,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(),
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
                  "Attachment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                leading: Container(child: Icon(Icons.attachment)),
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
                        AttachedFileList(),
                        SizedBox(
                          height: 5,
                        ),
                        getCommonButton(baseTheme, () async {
                          if (permissionGranted == false) {
                            _getStoragePermission();
                          } else {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return SafeArea(
                                    child: Container(
                                      child: new Wrap(
                                        children: <Widget>[
                                          new ListTile(
                                              leading:
                                                  new Icon(Icons.photo_library),
                                              title: new Text('Choose Files'),
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                FilePickerResult result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: [
                                                    'jpg',
                                                    'pdf',
                                                    'doc',
                                                    'png'
                                                  ],
                                                  allowMultiple: true,
                                                );
                                                if (result != null) {
                                                  List<File> files =
                                                      result.paths.map((path) {
                                                    bool ISDuplicate = false;
                                                    if (MultipleVideoList
                                                            .length !=
                                                        0) {
                                                      for (int i = 0;
                                                          i <
                                                              MultipleVideoList
                                                                  .length;
                                                          i++) {
                                                        if (path ==
                                                            MultipleVideoList[i]
                                                                .path) {
                                                          ISDuplicate = true;
                                                        } else {
                                                          ISDuplicate = false;
                                                        }
                                                      }
                                                    }
                                                    if (ISDuplicate == true) {
                                                      showCommonDialogWithSingleOption(
                                                          context,
                                                          "File Is Already Exist !",
                                                          positiveButtonTitle:
                                                              "OK");
                                                    } else {
                                                      final bytes = File(path)
                                                          .readAsBytesSync()
                                                          .lengthInBytes;
                                                      final kb = bytes / 1024;
                                                      final mb = kb / 1024;
                                                      if (mb >= 15) {
                                                        showCommonDialogWithSingleOption(
                                                            context,
                                                            "Document Size Should not be Greater than 15 MB !",
                                                            positiveButtonTitle:
                                                                "OK");
                                                      } else {
                                                        MultipleVideoList.add(
                                                            File(path));
                                                      }
                                                    }
                                                  }).toList();

                                                  setState(() {});
                                                } else {
                                                  // User canceled the picker
                                                }
                                              }),
                                          new ListTile(
                                            leading:
                                                new Icon(Icons.photo_camera),
                                            title: new Text('Choose Camera'),
                                            onTap: () async {
                                              Navigator.of(context).pop();

                                              XFile file =
                                                  await imagepicker.pickImage(
                                                source: ImageSource.camera,
                                              );

                                              File file1 = File(file.path);
                                              final dir =
                                                  await getTemporaryDirectory();
                                              final extension =
                                                  p.extension(file1.path);
                                              int timestamp1 = DateTime.now()
                                                  .millisecondsSinceEpoch;
                                              String filenamepunchin =
                                                  DateTime.now()
                                                          .day
                                                          .toString() +
                                                      "_" +
                                                      DateTime.now()
                                                          .month
                                                          .toString() +
                                                      "_" +
                                                      DateTime.now()
                                                          .year
                                                          .toString() +
                                                      "_" +
                                                      timestamp1.toString() +
                                                      extension;

                                              final targetPath =
                                                  dir.absolute.path +
                                                      "/" +
                                                      filenamepunchin;
                                              File newRenameFile =
                                                  await File(file1.path)
                                                      .copy(targetPath);
                                              final bytes = newRenameFile
                                                  .readAsBytesSync()
                                                  .lengthInBytes;
                                              final kb = bytes / 1024;
                                              final mb = kb / 1024;

                                              if (mb >= 15) {
                                                showCommonDialogWithSingleOption(
                                                    context,
                                                    "Image Size Should not be Greater than 15 MB !",
                                                    positiveButtonTitle: "OK");
                                              } else {
                                                MultipleVideoList.add(
                                                    File(newRenameFile.path));
                                                setState(() {});
                                              }
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        }, "Choose File",
                            radius: 20,
                            backGroundColor: Color(0xff02b1fc),
                            textColor: colorWhite)
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

  AttachedFileList() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to delete this File ?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();
                          MultipleVideoList.removeAt(index);
                          setState(() {});
                        });
                      },
                      child: Icon(
                        Icons.delete_forever,
                        size: 32,
                        color: colorPrimary,
                      ),
                    ),
                    Card(
                      elevation: 5,
                      color: colorLightGray,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                OpenFile.open(MultipleVideoList[index].path);
                              },
                              child: Text(
                                MultipleVideoList[index].path.split('/').last,
                                softWrap: true,

                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10, color: colorPrimary),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              );

              // }
            },
            shrinkWrap: true,
            itemCount: MultipleVideoList.length,
          ),
        ],
      ),
    );
  }

  Future<void> _getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      if (await Permission.storage.request().isGranted) {
        setState(() {
          permissionGranted = true;
        });
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.audio.request().isDenied) {
        setState(() {
          permissionGranted = false;
        });
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        setState(() {
          permissionGranted = true;
        });
      } else if (await Permission.photos.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.photos.request().isDenied) {
        setState(() {
          permissionGranted = false;
        });
      }
    }
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    print('testCompressAndGetFile');
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,
    );
    print(file.lengthSync());
    print(result?.lengthSync());
    return result;
  }

  void _onALLEmployeeListByStatusCallSuccess(
      ALL_EmployeeNameListResponseState state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();
    arr_ALL_Name_ID_For_AssignTo.clear();

    if (edt_TransferTo.text == "Re-Assign Task") {
      if (state.all_employeeList_Response.details.length != 0) {
        for (int i = 0;
            i < state.all_employeeList_Response.details.length;
            i++) {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.pkID = state.all_employeeList_Response.details[i].pkID;
          all_name_id.Name =
              state.all_employeeList_Response.details[i].employeeName;
          all_name_id.Name1 =
              state.all_employeeList_Response.details[i].tokenNo;
          all_name_id.isChecked = false;
          arr_ALL_Name_ID_For_AssignTo.add(all_name_id);
        }

        showcustomdialogWithMultipleID(
            values: arr_ALL_Name_ID_For_AssignTo,
            context1: context,
            controller: edt_ReAssignTo,
            controllerID: edt_ReAssignToID,
            controller2: edt_ReToken,
            lable: "Select Employee ");
      }
    } else {
      if (state.all_employeeList_Response.details.length != 0) {
        for (int i = 0;
            i < state.all_employeeList_Response.details.length;
            i++) {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.pkID = state.all_employeeList_Response.details[i].pkID;
          all_name_id.Name =
              state.all_employeeList_Response.details[i].employeeName;
          all_name_id.Name1 =
              state.all_employeeList_Response.details[i].tokenNo;
          all_name_id.isChecked = false;
          arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
        }

        showcustomdialogWithMultipleID(
            values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
            context1: context,
            controller: edt_EmployeeName,
            controllerID: edt_EmployeeID,
            controller2: edt_Token,
            lable: "Assign To");
      }
    }
  }
}
