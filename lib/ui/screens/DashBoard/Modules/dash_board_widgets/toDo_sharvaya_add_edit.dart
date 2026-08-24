import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/todo/todo_bloc.dart';
import 'package:soleoserp/models/api_requests/toDo_request/task_category_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_employee_not_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_header_save_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_module_sharing_list_request.dart';
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
import 'package:soleoserp/ui/screens/DashBoard/Modules/dash_board_widgets/toDo_sharvaya_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/dash_board_widgets/test_tag.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/other_screens/dropdownscreen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/General_Constants.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class SharvayaToDoWidgetAddEditScreenArguments {
  ToDoDetails editModel;
  String ListStatus;
  String ListLoginID;
  List<ALL_Name_ID> tagEmployeeList;
  SharvayaToDoWidgetAddEditScreenArguments(
      this.ListStatus, this.ListLoginID, this.editModel,this.tagEmployeeList);
}


class SharvayaToDoWidgetAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/SharvayaToDoWidgetAddEditScreen';
  final SharvayaToDoWidgetAddEditScreenArguments arguments;
  SharvayaToDoWidgetAddEditScreen(this.arguments);

  @override
  _SharvayaToDoWidgetAddEditScreenState createState() =>
      _SharvayaToDoWidgetAddEditScreenState();
}

class _SharvayaToDoWidgetAddEditScreenState extends BaseState<SharvayaToDoWidgetAddEditScreen>
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

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Category = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Priority = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_AssignTo = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TransferTo = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];

  List<ALL_Name_ID> arr_ALL_Name_ID_For_TAG_Employee_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TAG_Employee_List_Selected = [];

  List<String> tempdd = [];


  final TextEditingController edt_EmployeeID = TextEditingController();
  final TextEditingController edt_EmployeeName = TextEditingController();


  final TextEditingController edt_TAG_EmployeeID = TextEditingController();
  final TextEditingController edt_TAG_EmployeeName = TextEditingController();

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

  bool ISCHECKED = false;
  SearchDetails _searchDetails;

  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();

  bool IsForClient = false;

  String ReportToToken = "";

  ALL_EmployeeList_Response _offlineALLEmployeeListData;

  bool IsforEmployeeAddEdit = false;

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
    // Clean up the focus node when the Form is disposed.

    super.dispose();
    NotesFocusNode.dispose();
    edt_TransferTo.dispose();
  }

  @override
  void initState() {
    screenStatusBarColor = Color(0xff0066b3);

    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    print("dnucbdhchd" + _offlineLoggedInData.details[0].serialKey);

    if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
        "SI08-SB94-MY45-RY15" ||
        _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208") {
      IsForClient = true;
    } else {
      IsForClient = false;
    }

    // _onFollowerEmployeeListByStatusCallSuccess(_offlineFollowerEmployeeListData);

    CategoryTypeDetails();
    FetchPriorityDetails();
    FetchFollowupStatusDetails();
    FetchTransferToDetails();

    edt_TransferTo.addListener(textListener);
    NotesFocusNode = FocusNode();
    edt_TaskDetails.addListener(() {
      NotesFocusNode.requestFocus();
    });

    _offlineALLEmployeeListData =
        SharedPrefHelper.instance.getALLEmployeeList();

    _onALLEmplyeeList(_offlineALLEmployeeListData);

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

      /*  edt_CompletionDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_CompletionDateReverse.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();*/

      edt_EmployeeName.text = _offlineLoggedInData.details[0].employeeName;
      edt_EmployeeID.text =
          _offlineLoggedInData.details[0].employeeID.toString();

      String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour = selectedTime.hourOfPeriod <= 9
          ? "0" + selectedTime.hourOfPeriod.toString()
          : selectedTime.hourOfPeriod.toString();
      String beforZerominute = selectedTime.minute <= 9
          ? "0" + selectedTime.minute.toString()
          : selectedTime.minute.toString();

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

      /*  edt_ProductDeliveryTime.text = beforZeroHour +
          ":" +
          beforZerominute +
          " " +
          AM_PM;
      edt_ProductDeliveryTimeDatewith24Hours.text = selectedTime.hour.toString() + ":" + beforZerominute;*/

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

          if (state is ToDoModuleSharingListResponseState) {
            _onToDoModuleSharingListResponseState(state);
          }

          if (state is GetEmployeeFromHeaderListResponseState) {
            _onGetTokenFromReportToPersonResult(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GetReportToTokenResponseState || currentState is ToDoModuleSharingListResponseState || currentState is GetEmployeeFromHeaderListResponseState ) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ToDoStates state) {
          if (state is TaskCategoryCallResponseState) {
            _onLeaveRequestTypeSuccessResponse(state);
          }
          if (state is ToDoSaveHeaderState) {
            _OnSaveToDoHeaderResponse(state);
          }
          if (state is ToDoSaveSubDetailsState) {
            _OnSaveToDoSubResponse(state);
          }

          if (state is FCMNotificationResponseNewState) {
            _onRecevedNotification(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is TaskCategoryCallResponseState ||
              currentState is ToDoSaveHeaderState ||
              currentState is ToDoSaveSubDetailsState ||
              currentState is FCMNotificationResponseNewState) {
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
            Color(0xff108dcf),
          ]),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: colorWhite,
              ),
              onPressed: () {
                navigateTo(context, SharvayaToDoWidgetListScreen.routeName,
                    clearAllStack: true);
              }),
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
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskDescription(),
                        SizedBox(height: 15),
                        CustomDropDownContainer(
                          "Task Category",
                          enable1: false,
                          icon: Icon(Icons.arrow_drop_down),
                          controllerVehical: edt_Category,
                          vehicalList: arr_ALL_Name_ID_For_Category,
                        ),
                        SizedBox(height: 15),
                        Visibility(
                          visible: false,
                          child: Column(
                            children: [
                              Card(
                                // elevation:10.00,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: colorLightGray,
                                child: CheckboxListTile(
                                  value: ISCHECKED == null ? false : ISCHECKED,
                                  onChanged: (value) {
                                    setState(
                                          () {
                                        ISCHECKED = value;
                                        // arrinquiryShareModel[index] = model;
                                      },
                                    );
                                  },
                                  title: Text(
                                    "Reminder",
                                    style: TextStyle(color: colorPrimary),
                                  ),
                                  // contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                        CustomDropDown1("Priority",
                            enable1: false,
                            title: "Priority ",
                            hintTextvalue: "Tap to Select Priority",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_Priority,
                            Custom_values1: arr_ALL_Name_ID_For_Priority),
                        SizedBox(height: 15),
                        Area(),
                        SizedBox(height: 15),
                        _buildEmplyeeListView(),
                        SizedBox(height: 15),
                        _buildNextFollowupDate(),
                        SizedBox(height: 15),
                        _buildPreferredTime(),
                        SizedBox(height: 15),
                        _buildDueDate(),
                        SizedBox(height: 15),
                        _buildDueTime(),
                        SizedBox(height: 15),
                        _ModuleDropDown(context),
                        SizedBox(height: 15),
                        _offlineLoggedInData.details[0].serialKey
                            .toUpperCase() ==
                            "TEST-0000-SI0F-0208" ||
                            _offlineLoggedInData.details[0].serialKey
                                .toUpperCase() ==
                                "SI08-SB94-MY45-RY15"
                            ? Column(
                          children: [
                            _buildSearchView(),
                            SizedBox(height: 15),
                            _buildProductDeliveryDate(),
                            SizedBox(height: 15),
                            _buildProductDeliveryTime(),
                            SizedBox(height: 15),
                          ],
                        )
                            : Container(),
                        CustomDropDown1("Transfer To",
                            enable1: false,
                            title: "Transfer To ",
                            hintTextvalue: "Select Transfer To",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_TransferTo,
                            Custom_values1: arr_ALL_Name_ID_For_TransferTo),
                        ActualCompletion(),
                        _buildReAssignListView(),
                        SizedBox(height: 15),
                        ClosingRemarks(),
                        SizedBox(height: 30),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              "Save",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              _offlineLoggedInData.details[0].serialKey
                                  .toUpperCase() ==
                                  "TEST-0000-SI0F-0208" ||
                                  _offlineLoggedInData.details[0].serialKey
                                      .toUpperCase() ==
                                      "SI08-SB94-MY45-RY15"
                              //SI08-SB94-MY45-RY15
                                  ? save()
                                  : Save1();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                      ]))),
        ),
      ),
    );
  }

  Widget _buildReAssignListView() {
    return Visibility(
      visible: viewVisibleTransferToDropdown,
      child: Container(
        child: Column(
          children: [
            InkWell(
                onTap: () {
                    showCustomDialogWithIDForScreen(
                        values: arr_ALL_Name_ID_For_AssignTo,
                        context1: context,
                        controller: edt_ReAssignTo,
                        controllerID: edt_ReAssignToID,
                        label: "Re-Assign To");
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Re-Assign To",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      elevation: 8,
                      color: Colors.grey[50],
                      shadowColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        height: 55,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                enabled: false,
                                textInputAction: TextInputAction.next,
                                controller: edt_ReAssignTo,
                                decoration: InputDecoration(
                                  hintText: "--- Select ---",
                                  hintStyle:
                                  TextStyle(color: Colors.grey.shade400),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: colorGrayDark,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget ActualCompletion() {
    return Visibility(
      visible: viewVisibleCompletionDate,
      child: InkWell(
          onTap: () {
            _selectCompletionDate(
                context, edt_CompletionDate);
          },
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Actual Completion",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                elevation: 8,
                color: Colors.grey[50],
                shadowColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  height: 55,
                  padding: EdgeInsets.only(left: 20, right: 20),
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
                        Icons.calendar_today_outlined,
                        color: colorGrayDark,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget ClosingRemarks() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Closing Remarks",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  elevation: 8,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                              controller: edt_CloserDetails,
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
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget TaskDescription() {
    return Container(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Task Description *",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  elevation: 8,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                              controller: edt_TaskDetails,
                              keyboardType: TextInputType.multiline,
                              maxLines: 8,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter Description",
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
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Future<bool> _onBackPressed() {
    if (_isForUpdate == true) {
      // skdjdsf

      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = widget.arguments.ListStatus;
      all_name_id.Name1 = widget.arguments.ListLoginID;
      Navigator.of(context).pop(all_name_id);
    } else {
      navigateTo(context, SharvayaToDoWidgetListScreen.routeName, clearAllStack: true);
    }
  }

  Widget FirstRow(
      String Category,
      String priority, {
        bool enable1,
        bool enable2,
        Icon icon,
        Icon icon2,
        TextEditingController controllerForLeft,
        TextEditingController controllerForRight,
        List<ALL_Name_ID> Custom_values1,
        List<ALL_Name_ID> Custom_values2,
      }) {
    return Container(
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => showcustomdialog(
                    values: Custom_values1,
                    context1: context,
                    controller: controllerForLeft,
                    lable: "Select $Category"),
                child: Container(
                  child: buildUserNameTextFiled(
                      enablevalue: enable1,
                      userName_Controller: controllerForLeft,
                      labelName: Category,
                      icon: icon,
                      maxline: 1,
                      baseTheme: baseTheme),
                ),
              ),
              SizedBox(
                width: 20,
                height: 15,
              ),
              GestureDetector(
                onTap: () => showcustomdialog(
                    values: Custom_values2,
                    context1: context,
                    controller: controllerForLeft,
                    lable: "Select $priority"),
                child: Container(
                  child: buildUserNameTextFiled(
                      enablevalue: enable1,
                      userName_Controller: controllerForLeft,
                      labelName: priority,
                      icon: icon,
                      maxline: 1,
                      baseTheme: baseTheme),
                ),
              ),
            ],
          ),
        ));
  }

  Widget SecondRow(
      String location,
      String assignTo, {
        bool enable1,
        bool enable2,
        Icon icon,
        Icon icon2,
        TextEditingController controllerForLeft,
        TextEditingController controllerForRight,
        List<ALL_Name_ID> Custom_values1,
      }) {
    return Container(
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  child: buildUserNameTextFiled(
                      enablevalue: enable1,
                      userName_Controller: controllerForLeft,
                      labelName: location,
                      icon: icon,
                      maxline: 1,
                      baseTheme: baseTheme),
                ),
              ),
              SizedBox(
                width: 20,
                height: 15,
              ),
              GestureDetector(
                onTap: () => showcustomdialog(
                    values: Custom_values1,
                    context1: context,
                    controller: controllerForRight,
                    lable: "Select Employee "),
                child: Container(
                  child: buildUserNameTextFiled(
                      enablevalue: enable2,
                      userName_Controller: controllerForRight,
                      labelName: assignTo,
                      icon: icon2,
                      maxline: 1,
                      baseTheme: baseTheme),
                ),
              ),
            ],
          ),
        ));
  }

  Widget ThirdRow(
      String Category,
      String Source, {
        bool enable1,
        bool enable2,
        Icon icon,
        Icon icon2,
        TextEditingController controllerForLeft,
        TextEditingController controllerForRight,
        List<ALL_Name_ID> Custom_values1,
      }) {
    return Container(
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  child: buildUserNameTextFiled(
                      enablevalue: enable1,
                      userName_Controller: controllerForLeft,
                      labelName: Category,
                      icon: icon,
                      maxline: 1,
                      baseTheme: baseTheme),
                ),
              ),
              SizedBox(
                width: 20,
                height: 15,
              ),
              GestureDetector(
                onTap: () => showcustomdialog(
                    values: Custom_values1,
                    context1: context,
                    controller: controllerForRight,
                    lable: "Select $Source"),
                child: Container(
                  child: buildUserNameTextFiled(
                      enablevalue: enable2,
                      userName_Controller: controllerForRight,
                      labelName: Source,
                      icon: icon2,
                      maxline: 1,
                      baseTheme: baseTheme),
                ),
              ),
            ],
          ),
        ));
  }

  Widget FourthRow(
      String Category,
      String Source, {
        bool enable1,
        bool enable2,
        Icon icon,
        Icon icon2,
        TextEditingController controllerForLeft,
        TextEditingController controllerForRight,
      }) {
    return Container(
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectStartDate(context, controllerForLeft),
                  child: Container(
                    child: buildUserNameTextFiled(
                        enablevalue: enable1,
                        userName_Controller: controllerForLeft,
                        labelName: Category,
                        icon: icon,
                        maxline: 1,
                        baseTheme: baseTheme),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
                height: 15,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _StartTime(context),
                  child: Container(
                    child: buildUserNameTextFiled(
                        enablevalue: enable2,
                        userName_Controller: controllerForRight,
                        labelName: Source,
                        icon: icon2,
                        maxline: 1,
                        baseTheme: baseTheme),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget FifthRow(
      String Category,
      String Source, {
        bool enable1,
        bool enable2,
        Icon icon,
        Icon icon2,
        TextEditingController controllerForLeft,
        TextEditingController controllerForRight,
      }) {
    return Container(
        child: Container(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _SelectDueDate(context, controllerForLeft),
                  child: Container(
                    child: buildUserNameTextFiled(
                        enablevalue: enable1,
                        userName_Controller: controllerForLeft,
                        labelName: Category,
                        icon: icon,
                        maxline: 1,
                        baseTheme: baseTheme),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
                height: 15,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _DueTime(context),
                  child: Container(
                    child: buildUserNameTextFiled(
                        enablevalue: enable2,
                        userName_Controller: controllerForRight,
                        labelName: Source,
                        icon: icon2,
                        maxline: 1,
                        baseTheme: baseTheme),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget SixthRow(
      String Category, {
        bool enable1,
        Icon icon,
        TextEditingController controllerForLeft,
        List<ALL_Name_ID> Custom_values1,
      }) {
    return Container(
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => showcustomdialog(
                    values: Custom_values1,
                    context1: context,
                    controller: controllerForLeft,
                    lable: "Select $Category"),
                child: Container(
                  child: TextFormField(
                    style: baseTheme.textTheme.bodyText1,
                    enabled: false,
                    controller: edt_TransferTo,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    onChanged: (text) => {
                      print("EDTTransefer" + text),
                      /* if(text.trim().toLowerCase() == "completetask")
                        {
                          IsReAssignToVisible = false,
                          IsCompleteTaskVisible = true
                        }
                      else if(text.trim().toLowerCase() == "re-assigntask")
                        {
                          IsReAssignToVisible = true,
                          IsCompleteTaskVisible = false
                        }
                      else
                        {
                          IsReAssignToVisible = false,
                          IsCompleteTaskVisible = false
                        }*/
                    },
                    //initialValue: userName_Controller.text,
                    decoration: InputDecoration(
                      labelText: "Transfer To",
                      labelStyle: TextStyle(
                        color: Color(0xFF000000),
                      ),
                      suffixIcon: icon,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF000000)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget SeventhRow(
      String Category, {
        bool enable1,
        Icon icon,
        TextEditingController controllerForLeft,
        List<ALL_Name_ID> Custom_values1,
      }) {
    return Visibility(
      visible: true,
      child: Container(
          child: Container(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => showcustomdialog(
                      values: Custom_values1,
                      context1: context,
                      controller: controllerForLeft,
                      lable: "Select Employee"),
                  child: Container(
                    child: TextFormField(
                      style: baseTheme.textTheme.bodyText1,
                      enabled: false,
                      controller: edt_ReAssignTo,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      maxLines: 1,

                      //initialValue: userName_Controller.text,
                      decoration: InputDecoration(
                        labelText: "Re-Assign To",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        suffixIcon: icon,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF000000)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _selectStartDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_StartDate.text = selectedDate.day.toString() +
            "/" +
            selectedDate.month.toString() +
            "/" +
            selectedDate.year.toString();
      });
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

  Future<void> _StartTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
        edt_StartTime.text =
            selectedTime.hour.toString() + ":" + selectedTime.minute.toString();
      });
  }

  Future<void> _SelectDueDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_DueDate.text = selectedDate.day.toString() +
            "/" +
            selectedDate.month.toString() +
            "/" +
            selectedDate.year.toString();
      });
  }

  Future<void> _DueTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
        edt_DueTime.text =
            selectedTime.hour.toString() + ":" + selectedTime.minute.toString();
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

/*  Widget showcustomdialogWithID1(String Category,
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
            onTap:
                () => *//*showcustomdialogWithID(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                controllerID: controllerpkID,
                lable: "Select $Category")*//*
            CreateDialogDropdown(Category),

            *//* _toDoBloc.add(TaskCategoryListCallEvent(
                TaskCategoryListRequest(pkID:"",CompanyId: CompanyID.toString()))),*//*

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
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 60,
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
  }*/

  Widget CustomDropDownContainer(
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
              onTap: () {
                if (IsforEmployeeAddEdit == true) {
                  _toDoBloc
                    ..add(TaskCategoryListCallEvent(TaskCategoryListRequest(
                        pkID: "", CompanyId: CompanyID.toString())));
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Task Category",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    elevation: 8,
                    color: Colors.grey[50],
                    shadowColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              controller: controllerVehical,
                              decoration: InputDecoration(
                                hintText: "--- Select ---",
                                hintStyle:
                                TextStyle(color: Colors.grey.shade400),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ),
                          edt_Category.text != ""
                              ? InkWell(
                            onTap: () {
                              edt_Category.text = "";
                              edt_CategoryID.text = "0";
                              setState(() {});
                            },
                            child: Icon(
                              Icons.close,
                              color: colorGrayDark,
                            ),
                          )
                              : Icon(
                            Icons.arrow_drop_down,
                            color: colorGrayDark,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  void _onLeaveRequestTypeSuccessResponse(TaskCategoryCallResponseState state) {
    arr_ALL_Name_ID_For_Category.clear();
    if (state.taskCategoryResponse.details.length != 0) {
      for (var i = 0; i < state.taskCategoryResponse.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name = state.taskCategoryResponse.details[i].taskCategoryName;
        categoryResponse123.pkID = state.taskCategoryResponse.details[i].pkID;
        arr_ALL_Name_ID_For_Category.add(categoryResponse123);
      }

      if (arr_ALL_Name_ID_For_Category.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
            arguments: VehicleListDropDownScreenArgument(
                arr_ALL_Name_ID_For_Category,
                "Task Category List",
                "Three Chars To Search Task Category ",
                "Tap To Enter Task Category"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_Category.text = "";
            edt_CategoryID.text = "0";
          } else {
            ALL_Name_ID model = value;
            edt_Category.text = model.Name;
            edt_CategoryID.text = model.pkID.toString();
          }

          setState(() {});
        });
      }
    }
  }

/*  void _onLeaveRequestTypeSuccessResponse(TaskCategoryCallResponseState state) {
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
  }*/

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
                showCustomDialogWithNameOnlyFor(
                    values: Custom_values1,
                    context1: context,
                    controller: controllerForLeft,
                    label: "Select $Category");
              }
            },
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  elevation: 8,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    height: 55,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: false,
                            textInputAction: TextInputAction.next,
                            controller: controllerForLeft,
                            decoration: InputDecoration(
                              hintText: "--- Select ---",
                              hintStyle:
                              TextStyle(color: Colors.grey.shade400),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                                fontSize: 16, color: Colors.black87),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _buildEmplyeeListView() {
    return Container(
      child: Column(
        children: [
          InkWell(
              onTap: () {
                if (IsforEmployeeAddEdit == true) {
                  showCustomDialogWithIDForScreen(
                      values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
                      context1: context,
                      controller: edt_EmployeeName,
                      controllerID: edt_EmployeeID,
                      label: "Assign To");
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Assign To *",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    elevation: 8,
                    color: Colors.grey[50],
                    shadowColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              controller: edt_EmployeeName,
                              decoration: InputDecoration(
                                hintText: "--- Select ---",
                                hintStyle:
                                TextStyle(color: Colors.grey.shade400),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: colorGrayDark,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Future<void> showCustomDialogWithIDForScreen({
     List<ALL_Name_ID> values,
     BuildContext context1,
     TextEditingController controller,
     TextEditingController controllerID,
     String label,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label at the top of the dialog
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // List of options
                Container(
                  height: 200, // Adjust as necessary or make it dynamic
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: values.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context123).pop();
                          controller.text = values[index].Name;
                          controllerID.text = values[index].pkID.toString();
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueAccent,
                                  ),
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.only(right: 12),
                                ),
                                Expanded(
                                  child: Text(
                                    values[index].Name,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),

                // Close Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context123).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showCustomDialogWithNameOnlyFor({
     List<ALL_Name_ID> values,
     BuildContext context1,
     TextEditingController controller,
     String label,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label at the top of the dialog
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // List of options
                Container(
                  height: 200, // Adjust as necessary or make it dynamic
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: values.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context123).pop();
                          controller.text = values[index].Name;
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blueAccent,
                                  ),
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.only(right: 12),
                                ),
                                Expanded(
                                  child: Text(
                                    values[index].Name,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),

                // Close Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context123).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget Area() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Location",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              elevation: 8,
              color: Colors.grey[50],
              shadowColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        controller: edt_Location,
                        enabled: IsforEmployeeAddEdit,
                        decoration: InputDecoration(
                          hintText: "Tap to enter Location",
                          hintStyle:
                          TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "StartDate *",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 55,
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
          ),
        ],
      )
    );
  }

  Widget _buildPreferredTime() {
    return InkWell(
      onTap: () {
        if (IsforEmployeeAddEdit == true) {
          _selectTime(context, edt_StartTime);
        }
      },
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Start Time",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 55,
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
                    Icons.lock_clock,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildDueDate() {
    return InkWell(
      onTap: () {
        if (IsforEmployeeAddEdit == true) {
          _selectDueDate(context, edt_DueDate);
        }
      },
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "DueDate *",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 55,
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
          ),
        ],
      )
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
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Due Time",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 55,
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
                    Icons.lock_clock,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildProductDeliveryDate() {
    return InkWell(
      onTap: () {
        if (IsforEmployeeAddEdit == true) {
          _selectProductDeliveryDate(context, edt_ProductDeliveryDate);
        }
      },
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Product Delivery Date *",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 55,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_ProductDeliveryDate.text == null ||
                          edt_ProductDeliveryDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_ProductDeliveryDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_ProductDeliveryDateReverse.text == null ||
                              edt_ProductDeliveryDateReverse.text == ""
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
          ),
        ],
      )
    );
  }

  Future<void> _selectProductDeliveryDate(
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

        edt_ProductDeliveryDate.text = selectedDate.day.toString() +
            "-" +
            AddZero +
            "-" +
            selectedDate.year.toString();
        edt_ProductDeliveryDateReverse.text = selectedDate.year.toString() +
            "-" +
            AddZero +
            "-" +
            selectedDate.day.toString();
      });
  }

  Widget _buildProductDeliveryTime() {
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

            edt_ProductDeliveryTime.text =
                beforZeroHour + ":" + beforZerominute + " " + AM_PM;

            edt_ProductDeliveryTimeDatewith24Hours.text =
                selectedTime.hour.toString() + ":" + beforZerominute;
          });

          print(value.format(context).toString());
        });

        /*if (IsforEmployeeAddEdit == true) {
          _selectProductDeliveryTime(context, edt_ProductDeliveryTime);
        }*/
      },
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Product Delivery Time *",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 55,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_ProductDeliveryTime.text == null ||
                          edt_ProductDeliveryTime.text == ""
                          ? "HH:MM:SS"
                          : edt_ProductDeliveryTime.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_ProductDeliveryTime.text == null ||
                              edt_ProductDeliveryTime.text == ""
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.lock_clock,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          ),
        ],
      )
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

  Future<void> _selectDueTime(
      BuildContext context, TextEditingController F_datecontroller) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 11, minute: 59),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != TimeOfDay(hour: 11, minute: 59))
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

        edt_DueTime.text = beforZeroHour + ":" + beforZerominute + " " + AM_PM;

        edt_DueTimeDatewith24Hours.text =
            selectedTime.hour.toString() + ":" + beforZerominute;
      });
  }

  void _OnSaveToDoHeaderResponse(ToDoSaveHeaderState state) {
    if (_isForUpdate == true) {
      if (edt_TransferTo.text == "Complete Task") {
        _toDoBloc.add(GetEmployeeFromHeaderListRequestEvent(
            ToDoEmployeeListSharingRequest(
              ParentID: state.toDoSaveHeaderResponse.details[0].column1.toString(),
              Status: "Complete",
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString(),
            )));
      } else {
        _toDoBloc.add(GetEmployeeFromHeaderListRequestEvent(
            ToDoEmployeeListSharingRequest(
              ParentID: state.toDoSaveHeaderResponse.details[0].column1.toString(),
              Status: "Activity",
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString(),
            )));
      }
    } else {
      _toDoBloc.add(
          GetEmployeeFromHeaderListRequestEvent(ToDoEmployeeListSharingRequest(
            ParentID: state.toDoSaveHeaderResponse.details[0].column1.toString(),
            Status: "",
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString(),
          )));
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

  void _onGetTokenFromReportToPersonResult(
      GetEmployeeFromHeaderListResponseState state) {
    for (var detail in state.response.details) {
      String reportToToken = detail.tokenNo ?? "0";

      if (reportToToken.isNotEmpty) {
        String notiTitle = "To-Do";
        String taskStatus = _isForUpdate ? "Completed" : "Created";
        String taskDetails = edt_TaskDetails.text;
        String employeeName = _offlineLoggedInData.details[0].employeeName;
        String completionDate = edt_CompletionDate.text;

        String notibody;
        if (_isForUpdate) {
          notibody = (edt_TransferTo.text == "Complete Task")
              ? "To-Do $taskDetails is $taskStatus By $employeeName On $completionDate"
              : "To-Do Activity Added By $employeeName";
        } else {
          notibody = "To-Do $taskDetails is $taskStatus And AssignTo ${detail.employeeName} By $employeeName";
        }

        final Map<String, dynamic> message = {
          'message': {
            'token': ReportToToken,
            "notification": {"body": notibody, "title": notiTitle},
            'data': {
              "body": notibody,
              "title": notiTitle,
              "click_action": "FLUTTER_NOTIFICATION_CLICK"        },
          }
        };

        _toDoBloc.add(FCMNotificationRequestNewEvent(message));
      }
    }
  }

  void _OnSaveToDoSubResponse(ToDoSaveSubDetailsState state) {
    String Msg = _isForUpdate == true
        ? "Task Updated Successfully !"
        : "Task Added Successfully !";

    /* showCommonDialogWithSingleOption(state.context,Msg,
        positiveButtonTitle: "OK",onTapOfPositiveButton: (){
     //navigateTo(context, ToDoListScreen.routeName,clearAllStack: true);
          Navigator.pop(state.context);
        });*/

    showCommonDialogWithSingleOption(state.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          if (_isForUpdate == true) {
            // skdjdsf

            ALL_Name_ID all_name_id = ALL_Name_ID();
            all_name_id.Name = widget.arguments.ListStatus;
            all_name_id.Name1 = widget.arguments.ListLoginID;
            Navigator.pop(context);
            Navigator.of(state.context).pop(all_name_id);
          } else {
            navigateTo(context, SharvayaToDoWidgetListScreen.routeName, clearAllStack: true);
          }
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


    if(widget.arguments.tagEmployeeList.isNotEmpty)
    {

      arr_ALL_Name_ID_For_TAG_Employee_List_Selected.addAll(widget.arguments.tagEmployeeList);

      for(int k=0;k<arr_ALL_Name_ID_For_TAG_Employee_List.length;k++)
      {
        for(int k1=0;k1<widget.arguments.tagEmployeeList.length;k1++)
        {

          if(arr_ALL_Name_ID_For_TAG_Employee_List[k].pkID==widget.arguments.tagEmployeeList[k1].pkID)
          {
            arr_ALL_Name_ID_For_TAG_Employee_List[k].Name =widget.arguments.tagEmployeeList[k1].Name;
            arr_ALL_Name_ID_For_TAG_Employee_List[k].pkID =widget.arguments.tagEmployeeList[k1].pkID;
            arr_ALL_Name_ID_For_TAG_Employee_List[k].isChecked =true;


          }





        }
      }


      for(int h=0;h<arr_ALL_Name_ID_For_TAG_Employee_List.length;h++)
      {
        print("listfr" + " NAme " + arr_ALL_Name_ID_For_TAG_Employee_List[h].Name + " ISChecked " + arr_ALL_Name_ID_For_TAG_Employee_List[h].isChecked.toString() );
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


      if(editModel.deliveryDate.isNotEmpty)
      {
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

    edt_CloserDetails.text = ""; //editModel.closingRemarks;

    edt_Location.text = editModel.location;

    ISCHECKED = editModel.reminder;
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        if (IsforEmployeeAddEdit == true) {
          _onTapOfSearchView();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Select Customer *",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      textInputAction: TextInputAction.next,
                      controller: edt_CustomerName,
                      decoration: InputDecoration(
                        hintText: "Search customer",
                        hintStyle:
                        TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchTODOCustomerScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        edt_CustomerpkID.text = _searchDetails.value.toString();
        edt_CustomerName.text = _searchDetails.label.toString();
      }
    });
  }

  void _onGetTokenfromReportopersonResult(GetReportToTokenResponseState state) {
    ReportToToken = state.response.details[0].reportPersonTokenNo;
    print("jffbryvu" + state.response.details[0].reportPersonTokenNo);
  }

  void _onRecevedNotification(FCMNotificationResponseNewState state) {
    print("fcm_notification" +
        state.response.canonicalIds.toString() +
        state.response.failure.toString() +
        state.response.multicastId.toString() +
        state.response.success.toString());
  }

  void _onALLEmplyeeList(ALL_EmployeeList_Response offlineALLEmployeeListData) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();
    arr_ALL_Name_ID_For_AssignTo.clear();
    arr_ALL_Name_ID_For_TAG_Employee_List.clear();
    if (offlineALLEmployeeListData.details != null) {
      for (var i = 0; i < offlineALLEmployeeListData.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = offlineALLEmployeeListData.details[i].employeeName;
        all_name_id.pkID = offlineALLEmployeeListData.details[i].pkID;
        all_name_id.isChecked = false;

        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
        arr_ALL_Name_ID_For_AssignTo.add(all_name_id);
        arr_ALL_Name_ID_For_TAG_Employee_List.add(all_name_id);
      }
    }





  }

  Save1() async {
    //await share();

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

                              _toDoBloc.add(ToDoSaveWithTagEmployeeHeaderEvent(
                                  context,
                                  pkID,
                                  arr_ALL_Name_ID_For_TAG_Employee_List_Selected,
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
                                      ReminderMonth: "",
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
                                              .text)));
                            });
                      } else {
                        if (SbrazilianDate.isAtSameMomentAs(DbrazilianDate)) {
                          showCommonDialogWithTwoOptions(context,
                              "Are you sure you want to Save ToDo Details ?",
                              negativeButtonTitle: "No",
                              positiveButtonTitle: "Yes",
                              onTapOfPositiveButton: () {
                                Navigator.of(context).pop();

                                _toDoBloc.add(ToDoSaveWithTagEmployeeHeaderEvent(
                                    context,
                                    pkID,
                                    arr_ALL_Name_ID_For_TAG_Employee_List_Selected,

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
                                        ReminderMonth: "",
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
                                                .text)));
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

                            _toDoBloc.add(ToDoSaveWithTagEmployeeHeaderEvent(
                                context,
                                pkID,
                                arr_ALL_Name_ID_For_TAG_Employee_List_Selected,
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
                                    ReminderMonth: "",
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
                                            .text)));
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

                            _toDoBloc.add(ToDoSaveWithTagEmployeeHeaderEvent(
                                context,
                                pkID,
                                arr_ALL_Name_ID_For_TAG_Employee_List_Selected,

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
                                    ReminderMonth: "",
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
                                            .text)));
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
                      positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                    Navigator.pop(context);
                  });
                }
              } else {
                showCommonDialogWithSingleOption(
                    context, "Completion Date is Required !",
                    positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                  Navigator.pop(context);
                });
              }
            } else {
              showCommonDialogWithSingleOption(
                  context, "Closing Remarks is Required !",
                  positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                Navigator.pop(context);
              });
            }
          } else {
            showCommonDialogWithSingleOption(context, "Due Date is Required !",
                positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                  Navigator.pop(context);
                });
          }
        } else {
          showCommonDialogWithSingleOption(context, "Assign To is Required !",
              positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                Navigator.pop(context);
              });
        }
      } else {
        showCommonDialogWithSingleOption(context, "Task Category is Required !",
            positiveButtonTitle: "OK",onTapOfPositiveButton: (){
              Navigator.pop(context);
            });
      }
    } else {
      showCommonDialogWithSingleOption(
          context, "Task Description is Required !",
          positiveButtonTitle: "OK",onTapOfPositiveButton: (){
        Navigator.pop(context);
      });
    }
  }

  save() async {
    bool ISclosingRemerks = false;
    bool ISCompletion = false;
    bool ISAssignTo = true;


    if(arr_ALL_Name_ID_For_TAG_Employee_List_Selected.isNotEmpty)
    {
      for(int i=0;i<arr_ALL_Name_ID_For_TAG_Employee_List_Selected.length;i++)
      {
        print("TagList" + arr_ALL_Name_ID_For_TAG_Employee_List_Selected[i].Name + " pkID : "+ arr_ALL_Name_ID_For_TAG_Employee_List_Selected[i].pkID.toString());
      }
    }


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
            if (edt_CustomerpkID.text.toString() != "") {
              if (edt_ProductDeliveryDate.text != "") {
                if (ISclosingRemerks == true) {
                  if (ISCompletion == true) {
                    if (ISAssignTo == true) {
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

                                  _toDoBloc.add(ToDoSaveWithTagEmployeeHeaderEvent(
                                      context,
                                      pkID,
                                      arr_ALL_Name_ID_For_TAG_Employee_List_Selected,
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
                                          ReminderMonth: "",
                                          Latitude: SharedPrefHelper.instance
                                              .getLongitude(),
                                          Longitude: SharedPrefHelper.instance
                                              .getLatitude(),
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
                                                  .text)));
                                });
                          } else {
                            if (SbrazilianDate.isAtSameMomentAs(
                                DbrazilianDate)) {
                              showCommonDialogWithTwoOptions(context,
                                  "Are you sure you want to Save ToDo Details ?",
                                  negativeButtonTitle: "No",
                                  positiveButtonTitle: "Yes",
                                  onTapOfPositiveButton: () {
                                    Navigator.of(context).pop();

                                    _toDoBloc.add(ToDoSaveWithTagEmployeeHeaderEvent(
                                        context,
                                        pkID,
                                        arr_ALL_Name_ID_For_TAG_Employee_List_Selected,

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
                                            edt_CompletionDateReverse.text ==
                                                null
                                                ? ""
                                                : edt_CompletionDateReverse
                                                .text,
                                            LoginUserID: LoginUserID,
                                            EmployeeID: edt_EmployeeID.text,
                                            Reminder: ISCHECKED == true ? "1" : "0",
                                            ReminderMonth: "",
                                            Latitude: SharedPrefHelper.instance
                                                .getLatitude(),
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
                                                    .text)));
                                  });
                            }

                            showCommonDialogWithSingleOption(context,
                                "Completion Date Should be greater than Start Date !",
                                positiveButtonTitle: "OK");
                          }
                        } else {
                          showCommonDialogWithTwoOptions(context,
                              "Are you sure you want to Save ToDo Details ?",
                              negativeButtonTitle: "No",
                              positiveButtonTitle: "Yes",
                              onTapOfPositiveButton: () {
                                Navigator.of(context).pop();

                                _toDoBloc.add(ToDoSaveWithTagEmployeeHeaderEvent(
                                    context,
                                    pkID,
                                    arr_ALL_Name_ID_For_TAG_Employee_List_Selected,

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
                                        ReminderMonth: "",
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
                                                .text)));
                              });
                        }
                      } else {
                        // print("DatesRemoveSymobles"+ " False : " +"SDate : " +SDate +" DDate : " +DDate );

                        if (SbrazilianDate.isAtSameMomentAs(DbrazilianDate)) {
                          showCommonDialogWithTwoOptions(context,
                              "Are you sure you want to Save ToDo Details ?",
                              negativeButtonTitle: "No",
                              positiveButtonTitle: "Yes",
                              onTapOfPositiveButton: () {
                                Navigator.of(context).pop();

                                _toDoBloc.add(ToDoSaveWithTagEmployeeHeaderEvent(
                                    context,
                                    pkID,
                                    arr_ALL_Name_ID_For_TAG_Employee_List_Selected,
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
                                        ReminderMonth: "",
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
                                                .text)));
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
                          positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    showCommonDialogWithSingleOption(
                        context, "Completion Date is Required !",
                        positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                      Navigator.pop(context);
                    });
                  }
                } else {
                  showCommonDialogWithSingleOption(
                      context, "Closing Remarks is Required !",
                      positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                    Navigator.pop(context);
                  });
                }
              } else {
                showCommonDialogWithSingleOption(
                    context, "Delivery Date is Required !",
                    positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                  Navigator.pop(context);
                });
              }
            } else {
              showCommonDialogWithSingleOption(
                  context, "Customer Name is Required !",
                  positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                Navigator.pop(context);
              });
            }
          } else {
            showCommonDialogWithSingleOption(context, "Due Date is Required !",
                positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                  Navigator.pop(context);
                });
          }
        } else {
          showCommonDialogWithSingleOption(context, "Assign To is Required !",
              positiveButtonTitle: "OK",onTapOfPositiveButton: (){
                Navigator.pop(context);
              });
        }
      } else {
        showCommonDialogWithSingleOption(context, "Task Category is Required !",
            positiveButtonTitle: "OK",onTapOfPositiveButton: (){
              Navigator.pop(context);
            });
      }
    } else {
      showCommonDialogWithSingleOption(
          context, "Task Description is Required !",
          positiveButtonTitle: "OK",onTapOfPositiveButton: (){
        Navigator.pop(context);
      });
    }
  }


  Widget _BuildTagEmployeeCheckList() {
    return InkWell(
      onTap: () async {
        // _onTapOfSearchView(context);

        /*showCustomCheckListDialogwithID(
              values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
              context1: context,
              controller: edt_TAG_EmployeeName,
              controllerID: edt_TAG_EmployeeID,
              lable: "Tag Employee");*/



        List<dynamic> tempall_name_id = await showDialogGroupedCheckbox(
            context: context,
            cancelDialogText: "cancel",
            isMultiSelection: true,
            itemsTitle: List.generate(arr_ALL_Name_ID_For_TAG_Employee_List.length,
                    (index) => arr_ALL_Name_ID_For_TAG_Employee_List[index].Name),
            submitDialogText: "select",
            dialogTitle: Text("Select Tag Employee."),
            values:
            arr_ALL_Name_ID_For_TAG_Employee_List);


        if (tempall_name_id != null) {
          print("lsdfjsdjfl" + tempall_name_id.toString());



          List<ALL_Name_ID> strlist = tempall_name_id.cast<ALL_Name_ID>();



          tempdd.clear();

          List<String> pkIDList = [];
          for (int i = 0; i < strlist.length; i++) {
            print("sdkljdfk" +
                strlist[i].Name +
                " PKID" +
                strlist[i].pkID.toString());

            String AddComma = strlist[i]==strlist.last?"":" | ";


            tempdd.add(strlist[i].Name + AddComma);
            pkIDList.add(strlist[i].pkID.toString());
          }
          String dff = tempdd.toString().replaceAll("[", "");
          String dffddd = dff.toString().replaceAll("]", "");
          String dffdddf54f5 = dffddd.toString().replaceAll(",", "");

          edt_TAG_EmployeeName.text = dffdddf54f5.toString();

          String pkIDList1 = pkIDList.toString().replaceAll("[", "");
          String pkIDList2 = pkIDList1.toString().replaceAll("]", "");

          print("lsflssf900" + pkIDList2.toString());


        }

      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Tag Employee",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: /* Text(
                        SelectedStatus =="" ?
                        "Tap to select Status" : SelectedStatus.Name,
                        style:TextStyle(fontSize: 12,color: Color(0xFF000000),fontWeight: FontWeight.bold)// baseTheme.textTheme.headline2.copyWith(color: colorBlack),
                    ),*/

                    TextField(
                      controller: edt_TAG_EmployeeName,
                      enabled: false,
                      /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
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
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Select"),
                    ),
                    // dropdown()
                  ),
                  /*  Icon(
                    Icons.arrow_drop_down,
                    color: colorGrayDark,
                  )*/
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onToDoModuleSharingListResponseState(ToDoModuleSharingListResponseState state) {


    if(state.response.details.isNotEmpty)
    {

      List<ALL_Name_ID> tempList=[];

      List<ALL_Name_ID> tempList1=[];
      arr_ALL_Name_ID_For_TAG_Employee_List_Selected.clear();

      for(int i=0;i<state.response.details.length;i++)
      {
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name = state.response.details[i].employeeName;
        all_name_id.pkID = state.response.details[i].employeeID;

        print("oopsadad" + state.response.details[i].employeeName);


        tempList.add(all_name_id);
        arr_ALL_Name_ID_For_TAG_Employee_List_Selected.add(all_name_id);


      }

      for(int k=0;k<arr_ALL_Name_ID_For_TAG_Employee_List.length;k++)
      {
        for(int k1=0;k1<tempList.length;k1++)
        {

          if(arr_ALL_Name_ID_For_TAG_Employee_List[k].pkID==tempList[k1].pkID)
          {
            arr_ALL_Name_ID_For_TAG_Employee_List[k].Name =tempList[k1].Name;
            arr_ALL_Name_ID_For_TAG_Employee_List[k].pkID =tempList[k1].pkID;
            arr_ALL_Name_ID_For_TAG_Employee_List[k].isChecked =true;

          }
        }
      }


      for(int h=0;h<arr_ALL_Name_ID_For_TAG_Employee_List.length;h++)
      {
        print("listfr" + " NAme " + arr_ALL_Name_ID_For_TAG_Employee_List[h].Name + " ISChecked " + arr_ALL_Name_ID_For_TAG_Employee_List[h].isChecked.toString() );
      }


    }
  }


  Widget _ModuleDropDown(BuildContext context) {
    return InkWell(
      onTap: () {
        if (arr_ALL_Name_ID_For_TAG_Employee_List.length != 0) {
          navigateTo(context, TagEmployeeListScreen.routeName,
              arguments: TagEmployeeListScreenArguments(
                  arr_ALL_Name_ID_For_TAG_Employee_List, "Module"))
              .then((value) {
            arr_ALL_Name_ID_For_TAG_Employee_List_Selected.clear();
            arr_ALL_Name_ID_For_TAG_Employee_List_Selected = value;
            setState(() {});
          });
        } else {
          showCommonDialogWithSingleOption(
              context, "Employee List Not Exist !",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.pop(context);
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Tag Employee",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          arr_ALL_Name_ID_For_TAG_Employee_List_Selected.isNotEmpty
              ? Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 55,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Card(
                            elevation: 5,
                            color: colorPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                arr_ALL_Name_ID_For_TAG_Employee_List_Selected[index].Name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: arr_ALL_Name_ID_For_TAG_Employee_List_Selected.length,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: 24,
                  ),
                  SizedBox(width: 15),
                ],
              ),
            ),
          )
              : Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: "Select Tag Employee.",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget createTextLabel(String labelName, double leftPad, double rightPad) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: leftPad, right: rightPad),
        child: Row(
          children: [
            Text(labelName,
                style: TextStyle(
                    fontSize: 10,
                    color: colorPrimary,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }


}