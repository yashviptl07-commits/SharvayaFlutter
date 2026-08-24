import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/Model_Classis_Fro_ODB/bank_voucher_detail_model.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/sharvaya_daily_activity/module_dropdown_request.dart';
import 'package:soleoserp/models/api_requests/sharvaya_daily_activity/sharvaya_daily_activity_add_edit_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/task_category_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/sharvaya_daily_activity%202/sharvaya_daily_activity_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Daily_Activity_For_Sharvaya/Daily_Activity_For_Sharvaya_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/search_followup_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/other_screens/dropdownscreen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class DailyActivityForSharvayaAddEditArguments2 {
  SharvayaDailyActivityListResponseDetails editModel;
  DailyActivityForSharvayaAddEditArguments2(this.editModel);
}

class DailyActivityForSharvayaAddEdit extends BaseStatefulWidget {
  static const routeName = '/DailyActivityForSharvayaAddEdit';
  final DailyActivityForSharvayaAddEditArguments2 arguments;

  DailyActivityForSharvayaAddEdit(this.arguments);

  @override
  _DailyActivityForSharvayaAddEditScreen createState() =>
      _DailyActivityForSharvayaAddEditScreen();
}

class _DailyActivityForSharvayaAddEditScreen
    extends BaseState<DailyActivityForSharvayaAddEdit>
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
  SharvayaDailyActivityListResponseDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  bool isCompare;
  final FocusNode _focusNode = FocusNode();

  /// For New
  final TextEditingController edt_EstimatedHrs = TextEditingController();
  final TextEditingController edt_WorkedHrs = TextEditingController();
  final TextEditingController edt_EmployeeList = TextEditingController();
  final TextEditingController edt_EmployeeUserID = TextEditingController();
  final TextEditingController edt_ExpenseType = TextEditingController();
  final TextEditingController edt_ExpenseTypepkID = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_ModuleName = TextEditingController();
  final TextEditingController edt_ModulePkID = TextEditingController();
  final TextEditingController edt_Voucher_date = TextEditingController();
  final TextEditingController edt_Reverse_Voucher_date =
      TextEditingController();
  final TextEditingController edt_TransactionNotes = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Employee = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeaveType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Modules = [];

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
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    edt_EmployeeList.text = _offlineLoggedInData.details[0].employeeName;
    edt_EmployeeUserID.text =
        _offlineLoggedInData.details[0].employeeID.toString();

    // edt_Priority.addListener(() {
    //   NotesFocusNode.requestFocus();
    // });

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
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MayankBankVoucherDetailsListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is TaskCategoryCallResponseState) {
            _onLeaveRequestTypeSuccessResponse(state);
          }
          if (state is SharvayaDailyActivitySaveResponseState) {
            _onBankVoucherSaveResponse(state);
          }
          if (state is ModulesDropDownListResponseState) {
            _onCarBrandDropDown(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is TaskCategoryCallResponseState) {
            return true;
          }
          if (currentState is SharvayaDailyActivitySaveResponseState) {
            return true;
          }
          if (currentState is ModulesDropDownListResponseState) {
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
          title: Text('Add New Work Log'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: InkWell(
              onTap: () async {
                navigateTo(
                    context, DailyActivityForSharvayaListScreen.routeName);
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
                    TransactionNotes(),
                    SizedBox(height: 15),
                    _buildEmplyeeListView(),
                    SizedBox(height: 15),
                    _buildSearchView(),
                    SizedBox(height: 15),
                    PunchDate(),
                    SizedBox(height: 15),
                    CustomDropDownTypes(
                      "Types Of Work",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                      controllerVehical: edt_ExpenseType,
                      vehicalList: arr_ALL_Name_ID_For_LeaveType,
                    ),
                    SizedBox(height: 15),
                    CustomDropDownContainer(
                      "Module Name",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                      controllerVehical: edt_ModuleName,
                      vehicalList: arr_ALL_Name_ID_For_Modules,
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(flex: 1, child: EstimatedHrs()),
                        Expanded(flex: 1, child: WorkedHrs()),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          _onTapOfSaveVehiclePunchAPICall();
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
            onTap: () => _mainBloc.add(TaskCategoryListCallEvent(
                TaskCategoryListRequest(
                    pkID: "", CompanyId: CompanyID.toString()))),
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

  Widget CustomDropDownTypes(
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
                _mainBloc.add(TaskCategoryListCallEvent(TaskCategoryListRequest(
                    pkID: "", CompanyId: CompanyID.toString())));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Types Of Work *",
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
                          edt_ExpenseType.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_ExpenseType.text = "";
                                    edt_ExpenseTypepkID.text = "0";
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
    arr_ALL_Name_ID_For_LeaveType.clear();
    if (state.taskCategoryResponse.details.length != 0) {
      for (var i = 0; i < state.taskCategoryResponse.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name =
            state.taskCategoryResponse.details[i].taskCategoryName;
        categoryResponse123.pkID = state.taskCategoryResponse.details[i].pkID;
        arr_ALL_Name_ID_For_LeaveType.add(categoryResponse123);
      }

      if (arr_ALL_Name_ID_For_LeaveType.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_LeaveType,
                    "Types Of Work List",
                    "Three Chars To Search Types Of Work ",
                    "Tap To Enter Types Of Work"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_ExpenseType.text = "";
            edt_ExpenseTypepkID.text = "0";
          } else {
            ALL_Name_ID model = value;
            edt_ExpenseType.text = model.Name;
            edt_ExpenseTypepkID.text = model.pkID.toString();
          }

          setState(() {});
        });
      }
    }
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Employee.clear();

    if (state.details != null) {
      if (_offlineLoggedInData.details[0].roleCode.toLowerCase().trim() ==
          "admin") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "ALL";
        all_name_id.Name1 = "";
        arr_ALL_Name_ID_For_Employee.add(all_name_id);
      }

      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].pkID.toString();
        arr_ALL_Name_ID_For_Employee.add(all_name_id);
      }
    }
  }

  Widget _buildEmplyeeListView() {
    return Container(
      child: Column(
        children: [
          InkWell(
              onTap: () {
                showCustomDialogWithIDForScreen(
                    values: arr_ALL_Name_ID_For_Employee,
                    context1: context,
                    controller: edt_EmployeeList,
                    controllerID: edt_EmployeeUserID,
                    label: "Select Employee");
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Select Employee",
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
                              controller: edt_EmployeeList,
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

  Widget _buildSearchView() {
    return InkWell(
        onTap: () {
          _onTapOfSearchView();
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
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
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
        ));
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
    });
  }

  Widget EstimatedHrs() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Estimated Hrs *",
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
                        controller: edt_EstimatedHrs,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        decoration: InputDecoration(
                          hintText: "0.00",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
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

  Widget WorkedHrs() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Worked Hrs *",
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
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        controller: edt_WorkedHrs,
                        decoration: InputDecoration(
                          hintText: "0.00",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
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

  Widget TransactionNotes() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Work Notes *",
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
                          controller: edt_TransactionNotes,
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          enableInteractiveSelection:
                              true, // <-- This disables the copy/paste popup
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Tap to enter Work Notes",
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
            ),
          ],
        )
      ],
    ));
  }

  Widget PunchDate() {
    return InkWell(
        onTap: () {
          _selectNextFollowupDate(context, edt_Voucher_date);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Select Date *",
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
            ),
          ],
        ));
  }

  Future<void> _selectNextFollowupDate(
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
                _mainBloc.add(
                    ModulesDropDownListRequestEvent(ModulesDropDownListRequest(
                  pkID: 0,
                  LoginUserID: LoginUserID,
                  PageNo: 1,
                  PageSize: 10000,
                  CompanyId: CompanyID,
                )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Module Name",
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
                          edt_ModuleName.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_ModuleName.text = "";
                                    edt_ModulePkID.text = "0";
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

  void _onCarBrandDropDown(ModulesDropDownListResponseState state) {
    arr_ALL_Name_ID_For_Modules.clear();
    if (state.taskCategoryResponse.details.length != 0) {
      for (var i = 0; i < state.taskCategoryResponse.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name =
            state.taskCategoryResponse.details[i].moduleName;
        categoryResponse123.pkID = state.taskCategoryResponse.details[i].pkID;
        arr_ALL_Name_ID_For_Modules.add(categoryResponse123);
      }

      if (arr_ALL_Name_ID_For_Modules.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_Modules,
                    "Module Name List",
                    "Three Chars To Search Module ",
                    "Tap To Enter Modules"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_ModuleName.text = "";
            edt_ModulePkID.text = "0";
          } else {
            ALL_Name_ID model = value;
            edt_ModuleName.text = model.Name;
            edt_ModulePkID.text = model.pkID.toString();
          }

          setState(() {});
        });
      }
    }
  }

  _onTapOfSaveVehiclePunchAPICall() async {
    bool DropDownValue = false;

    // Debugging Role Code and Module Name Text
    print("Role Code: ${_offlineLoggedInData.details[0].roleCode}");
    print("Module Name: ${edt_ModuleName.text}");

    if (_offlineLoggedInData.details[0].roleCode.toLowerCase() == "developer") {
      if (edt_ModuleName.text.isEmpty) {
        DropDownValue = true;
      } else {
        print("Module Name is empty.");
      }
    } else {
      print("Role Code is not 'developer'.");
    }

    DateTime FbrazilianDate =
        new DateFormat("dd-MM-yyyy").parse(edt_Voucher_date.text);
    DateTime NbrazilianDate = new DateFormat("dd-MM-yyyy").parse(
        selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString()); //selectedDate;

    print("abcd" +
        FbrazilianDate.toString() +
        "abcdefgh" +
        NbrazilianDate.toString());

    if (edt_CustomerpkID.text.toString() != "") {
      if (edt_EstimatedHrs.text.toString() != "") {
        if (edt_WorkedHrs.text.toString() != "") {
          if (edt_TransactionNotes.text.toString() != "") {
            if (FbrazilianDate.compareTo(NbrazilianDate) == 0) {
              if (DropDownValue == false) {
                showCommonDialogWithTwoOptions(
                    context, "Are you sure you want to Save this record ?",
                    negativeButtonTitle: "No",
                    positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                  _mainBloc.add(SharvayaDailyActivitySaveCallEvent(
                      SharvayaDailyActivitySaveRequest(
                          pkID: pkID.toString(),
                          ActivityDate: edt_Reverse_Voucher_date.text,
                          TaskCategoryID: edt_ExpenseTypepkID.text,
                          CustomerID: edt_CustomerpkID.text,
                          TaskDescription: edt_TransactionNotes.text,
                          EstHours: edt_EstimatedHrs.text,
                          TaskDuration: edt_WorkedHrs.text,
                          ToDOID: "0",
                          LoginUserID: LoginUserID,
                          CompanyId: CompanyID.toString(),
                          ModuleID: edt_ModulePkID.text == "0"
                              ? "0"
                              : edt_ModulePkID.text)));
                });
              } else {
                showCommonDialogWithSingleOption(
                    context, "Module Name Selection Is Required !",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                });
              }
            } else {
              showCommonDialogWithSingleOption(
                  context, "Due Date Is Not Valid !", positiveButtonTitle: "OK",
                  onTapOfPositiveButton: () {
                Navigator.of(context).pop();
              });
            }
          } else {
            showCommonDialogWithSingleOption(context, "Description Is Required",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.of(context).pop();
            });
          }
        } else {
          showCommonDialogWithSingleOption(context, "Task Duration Is Required",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }
      } else {
        showCommonDialogWithSingleOption(context, "Estimated Time Is Required",
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

  Future<bool> _onBackPressed() async {
    navigateTo(context, DailyActivityForSharvayaListScreen.routeName);
  }

  void _onBankVoucherSaveResponse(
      SharvayaDailyActivitySaveResponseState state) {
    showCommonDialogWithSingleOption(
        context, state.response.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
      navigateTo(context, DailyActivityForSharvayaListScreen.routeName,
          clearAllStack: true);
    });
  }

  void fillData() async {
    pkID = _editModel.pkID;
    edt_Voucher_date.text = _editModel.activityDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_Voucher_date.text = _editModel.activityDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_EstimatedHrs.text = _editModel.estHours.toString();
    edt_WorkedHrs.text = _editModel.taskDuration.toString();
    edt_EmployeeList.text = _editModel.employeeName;
    edt_EmployeeUserID.text = _editModel.employeeID.toString();
    edt_ExpenseType.text = _editModel.taskCategory.toString();
    edt_ExpenseTypepkID.text = _editModel.taskCategoryID.toString();
    edt_CustomerName.text = _editModel.customerName.toString();
    edt_CustomerpkID.text = _editModel.customerID.toString();
    edt_TransactionNotes.text = _editModel.taskDescription.toString();
    edt_ModulePkID.text = _editModel.moduleID.toString();
    edt_ModuleName.text = _editModel.moduleName;
  }
}
