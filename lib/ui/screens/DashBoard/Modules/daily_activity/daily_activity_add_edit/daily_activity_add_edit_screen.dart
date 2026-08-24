import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:http/http.dart' as http;
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:soleoserp/blocs/other/bloc_modules/dailyactivity/dailyactivity_bloc.dart';
import 'package:soleoserp/blocs/other/bloc_modules/expense/expense_bloc.dart';
import 'package:soleoserp/models/api_requests/daily_activity/daily_activity_save_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/task_category_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/daily_activity/daily_activity_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/daily_activity/daily_activity_list/daily_activity_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/General_Constants.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/image_full_screen.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class AddUpdateDailyActivityRequestScreenArguments {
  DailyActivityDetails editModel;
  String ListDate;

  AddUpdateDailyActivityRequestScreenArguments(this.editModel, this.ListDate);
}

class DailyActivityAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/DailyActivityAddEditScreen';
  final AddUpdateDailyActivityRequestScreenArguments arguments;

  DailyActivityAddEditScreen(this.arguments);

  @override
  _DailyActivityAddEditScreenState createState() =>
      _DailyActivityAddEditScreenState();
}

class _DailyActivityAddEditScreenState
    extends BaseState<DailyActivityAddEditScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  DailyActivityScreenBloc _expenseBloc;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  bool _isForUpdate;
  int ExpensepkID = 0;
  DailyActivityDetails _editModel;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  FocusNode _notesFocusNode;
  int _currentHours = 1;
  int _currentMinutes = 0;
  String _ListDate = "";
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeaveType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SelectTask = [];

  // Selected work type
  int _selectedWorkTypeId = 0;
  int _selectedTaskTypeId = 0;

  final TextEditingController edt_ExpenseDateController =
      TextEditingController();
  final TextEditingController edt_ReverseExpenseDateController =
      TextEditingController();
  final TextEditingController edt_ExpenseNotes = TextEditingController();
  final TextEditingController edt_ExpenseType = TextEditingController();
  final TextEditingController edt_ExpenseTypepkID = TextEditingController();
  final TextEditingController edt_ExpenseAmount = TextEditingController();
  final TextEditingController edt_Mibutes = TextEditingController();
  final TextEditingController edt_TaskId = TextEditingController();
  final TextEditingController edt_TaskName = TextEditingController();

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);
    _expenseBloc = DailyActivityScreenBloc(baseBloc);
    _notesFocusNode = FocusNode();

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _updateDateTexts(selectedDate);

    _isForUpdate = widget.arguments.editModel != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData(_editModel);
    } else {
      _ListDate = widget.arguments.ListDate;
      edt_ExpenseDateController.text = _ListDate.getFormattedDate(
          fromFormat: "yyyy-MM-dd", toFormat: "dd-MM-yyyy");
      edt_ReverseExpenseDateController.text = _ListDate;
      edt_ExpenseAmount.text = "1";
      edt_Mibutes.text = "0";
      _currentHours = 1;
      _currentMinutes = 0;
    }
  }

  @override
  void dispose() {
    _notesFocusNode?.dispose();
    super.dispose();
  }

  void _updateDateTexts(DateTime date) {
    edt_ExpenseDateController.text =
        "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    edt_ReverseExpenseDateController.text =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _expenseBloc,
      child: BlocConsumer<DailyActivityScreenBloc, DailyActivityScreenStates>(
        builder: (BuildContext context, DailyActivityScreenStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return currentState is TaskCategoryCallResponseState;
        },
        listener: (BuildContext context, DailyActivityScreenStates state) {
          if (state is TaskCategoryCallResponseState) {
            _onLeaveRequestTypeSuccessResponse(state);
          }
          if (state is ToDoListCallResponseState) {
            _onToDoListCallResponseStateResponse(state);
          }

          if (state is DailyActivitySaveCallResponseState) {
            _onLeaveSaveStatusCallSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          return currentState is TaskCategoryCallResponseState ||
              currentState is ToDoListCallResponseState ||
              currentState is DailyActivitySaveCallResponseState;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        appBar: _buildCompactAppBar(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateField(),
                SizedBox(height: 16),
                _buildWorkTypeField(),
                SizedBox(height: 16),
                _buildDurationField(),
                SizedBox(height: 16),
                _buildNotesField(),
                _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                        "VELI-NERP-ABVP-WEJK"
                    ? Column(
                        children: [
                          SizedBox(height: 16),
                          _buildTaskSelectionField(),
                        ],
                      )
                    : Container(),
                SizedBox(height: 24),
                _buildSubmitButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Compact App Bar
  PreferredSizeWidget _buildCompactAppBar() {
    return NewGradientAppBar(
      title: Text(
        _isForUpdate ? 'Edit Activity' : 'New Activity',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      gradient: LinearGradient(
        colors: [Color(0xff108dcf), Color(0xff0066b3), Color(0xff108dcf)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => _onBackPressed(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.home, color: Colors.white, size: 22),
          onPressed: () {
            navigateTo(context, HomeScreen.routeName, clearAllStack: true);
          },
        ),
      ],
    );
  }

  // Compact Date Field
  Widget _buildDateField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade100, blurRadius: 5, offset: Offset(0, 2))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectDate(context, edt_ExpenseDateController),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFF108dcf), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Activity Date",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                      SizedBox(height: 2),
                      Text(
                        edt_ExpenseDateController.text.isEmpty
                            ? "Select Date"
                            : edt_ExpenseDateController.text,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Compact Work Type Field
  Widget _buildWorkTypeField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade100, blurRadius: 5, offset: Offset(0, 2))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _expenseBloc.add(TaskCategoryListCallEvent(TaskCategoryListRequest(
                pkID: "", CompanyId: CompanyID.toString())));
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.work_outline,
                    color: Colors.orange.shade700, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Type of Work",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                      SizedBox(height: 2),
                      Text(
                        edt_ExpenseType.text.isEmpty
                            ? "Select Work Type"
                            : edt_ExpenseType.text,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: edt_ExpenseType.text.isEmpty
                              ? Colors.grey.shade500
                              : Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Compact Work Type Field
  Widget _buildTaskSelectionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade100, blurRadius: 5, offset: Offset(0, 2))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _expenseBloc.add(ToDoListCallEvent(
                1,
                ToDoListApiRequest(
                    TaskStatus: "Pending",
                    Month: "",
                    Year: "",
                    OwnerShip: "---All---",
                    OwnerShipName: _offlineLoggedInData.details[0].employeeName,
                    LoginUserID: LoginUserID,
                    CompanyId: CompanyID.toString())));
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.work_outline,
                    color: Colors.orange.shade700, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Task",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                      SizedBox(height: 2),
                      Text(
                        edt_TaskName.text.isEmpty
                            ? "Select Task"
                            : edt_TaskName.text,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: edt_TaskName.text.isEmpty
                              ? Colors.grey.shade500
                              : Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Compact Duration Field
  Widget _buildDurationField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade100, blurRadius: 5, offset: Offset(0, 2))
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined, color: Colors.purple, size: 20),
                SizedBox(width: 8),
                Text("Work Duration",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF108dcf).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Total: ${_currentHours}h ${_currentMinutes > 0 ? '${_currentMinutes}m' : ''}",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF108dcf),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildCompactDurationPicker(
                  label: "Hrs",
                  value: _currentHours,
                  onChanged: (val) {
                    setState(() {
                      _currentHours = val;
                      edt_ExpenseAmount.text = val.toString();
                    });
                  },
                  maxValue: 24,
                  color: Color(0xFF108dcf),
                ),
                SizedBox(width: 12),
                _buildCompactDurationPicker(
                  label: "Min",
                  value: _currentMinutes,
                  onChanged: (val) {
                    setState(() {
                      _currentMinutes = val;
                      edt_Mibutes.text = val.toString();
                    });
                  },
                  maxValue: 59,
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDurationPicker({
    String label,
    int value,
    Function(int) onChanged,
    int maxValue,
    Color color,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCompactBtn(Icons.remove, () {
              if (value > 0) onChanged(value - 1);
            }, color),
            Text(
              "$value $label",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
            _buildCompactBtn(Icons.add, () {
              if (value < maxValue) onChanged(value + 1);
            }, color),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactBtn(IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  // Compact Notes Field
  Widget _buildNotesField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade100, blurRadius: 5, offset: Offset(0, 2))
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description_outlined, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text("Work Notes",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text("Required",
                      style:
                          TextStyle(fontSize: 9, color: Colors.red.shade600)),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextFormField(
                controller: edt_ExpenseNotes,
                focusNode: _notesFocusNode,
                minLines: 3,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Describe your work...",
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Compact Submit Button
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _validateAndSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF108dcf),
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          _isForUpdate ? 'UPDATE ACTIVITY' : 'SAVE ACTIVITY',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
    );
  }

  void _validateAndSave() {
    int hours = edt_ExpenseAmount.text.isNotEmpty
        ? int.parse(edt_ExpenseAmount.text.toString().trim())
        : 0;

    if (edt_ExpenseDateController.text.toString().isEmpty) {
      _showErrorDialog("Please select a date");
    } else if (edt_ExpenseType.text.isEmpty) {
      _showErrorDialog("Please select work type");
    } else if (edt_ExpenseAmount.text.isEmpty || hours == 0) {
      _showErrorDialog("Please enter work hours");
    } else if (hours > 24) {
      _showErrorDialog("Work hours cannot exceed 24 hours");
    } else if (edt_ExpenseNotes.text.isEmpty) {
      _showErrorDialog("Please add work notes");
    } else {
      _showConfirmationDialog();
    }
  }

  void _showErrorDialog(String message) {
    showCommonDialogWithSingleOption(context, message,
        positiveButtonTitle: "OK");
  }

  void _runAfterBuild(VoidCallback action) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      action();
    });
  }

  void _showConfirmationDialog() {
    showCommonDialogWithTwoOptions(
      context,
      "Are you sure you want to save these details?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.of(context).pop();
        _saveActivity();
      },
    );
  }

  void _saveActivity() {
    _expenseBloc.add(
      DailyActivitySaveByNameCallEvent(
        ExpensepkID,
        DailyActivitySaveRequest(
          CompanyId: CompanyID.toString(),
          ActivityDate: edt_ReverseExpenseDateController.text,
          TaskCategoryID: edt_ExpenseTypepkID.text,
          TaskDuration: "${edt_ExpenseAmount.text}.${edt_Mibutes.text}",
          LoginUserID: LoginUserID,
          TaskDescription: edt_ExpenseNotes.text,
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, DailyActivityListScreen.routeName,
        arguments: AddUpdateDailyActivityListScreenArguments(
            edt_ReverseExpenseDateController.text));
    return false;
  }

  void fillData(DailyActivityDetails expenseDetails) async {
    edt_ExpenseDateController.text = expenseDetails.createdDate
        .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_ReverseExpenseDateController.text = expenseDetails.createdDate
        .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_ExpenseNotes.text = expenseDetails.taskDescription;
    edt_ExpenseType.text =
        expenseDetails.taskCategoryName == "--Not Available--" ||
                expenseDetails.taskCategoryName == "N/A"
            ? ""
            : expenseDetails.taskCategoryName;
    edt_ExpenseTypepkID.text = expenseDetails.taskCategoryID.toString();
    ExpensepkID = expenseDetails.pkID;

    List<String> splitMinute =
        expenseDetails.taskDuration.toString().split(".");
    edt_ExpenseAmount.text = splitMinute[0].toString();
    edt_Mibutes.text = splitMinute.length > 1 ? splitMinute[1].toString() : "0";

    _currentHours = int.parse(splitMinute[0].toString());
    _currentMinutes =
        splitMinute.length > 1 ? int.parse(splitMinute[1].toString()) : 0;
    selectedDate = _parseDate(edt_ReverseExpenseDateController.text);
  }

  DateTime _parseDate(String dateStr) {
    List<String> parts = dateStr.split('-');
    if (parts.length == 3) {
      return DateTime(
          int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    }
    return DateTime.now();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController dateController) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Color(0xFF108dcf),
            colorScheme: ColorScheme.light(
              primary: Color(0xFF108dcf),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _updateDateTexts(picked);
      });
    }
  }

  void _onLeaveRequestTypeSuccessResponse(TaskCategoryCallResponseState state) {
    if (state.taskCategoryResponse.details.isNotEmpty) {
      arr_ALL_Name_ID_For_LeaveType.clear();
      for (var i = 0; i < state.taskCategoryResponse.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.taskCategoryResponse.details[i].taskCategoryName;
        all_name_id.pkID = state.taskCategoryResponse.details[i].pkID;
        arr_ALL_Name_ID_For_LeaveType.add(all_name_id);
      }
      _runAfterBuild(_showWorkTypeDialog);
    }
  }

  void _onToDoListCallResponseStateResponse(ToDoListCallResponseState state) {
    if (state.response.details.isNotEmpty) {
      arr_ALL_Name_ID_For_SelectTask.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].taskDescription;
        all_name_id.pkID = state.response.details[i].pkID;
        arr_ALL_Name_ID_For_SelectTask.add(all_name_id);
      }
      _runAfterBuild(_showTaskListDialog);
    }
  }

  void _showTaskListDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF108dcf),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.work, color: Colors.white, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Select Task",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Colors.white, size: 22),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: arr_ALL_Name_ID_For_SelectTask.length,
                  itemBuilder: (context, index) {
                    ALL_Name_ID type = arr_ALL_Name_ID_For_SelectTask[index];
                    bool isSelected = type.pkID == _selectedTaskTypeId;
                    return Card(
                      elevation: isSelected ? 2 : 0,
                      margin: EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: isSelected
                              ? Color(0xFF108dcf)
                              : Colors.grey.shade300,
                          child:
                              Icon(Icons.work, color: Colors.white, size: 16),
                        ),
                        title: Text(type.Name,
                            style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal)),
                        trailing: isSelected
                            ? Icon(Icons.check_circle,
                                color: Color(0xFF108dcf), size: 20)
                            : null,
                        onTap: () {
                          setState(() {
                            edt_TaskName.text = type.Name;
                            edt_TaskId.text = type.pkID.toString();
                            _selectedTaskTypeId = type.pkID;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWorkTypeDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF108dcf),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.work, color: Colors.white, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Select Work Type",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Colors.white, size: 22),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: arr_ALL_Name_ID_For_LeaveType.length,
                  itemBuilder: (context, index) {
                    ALL_Name_ID type = arr_ALL_Name_ID_For_LeaveType[index];
                    bool isSelected = type.pkID == _selectedWorkTypeId;
                    return Card(
                      elevation: isSelected ? 2 : 0,
                      margin: EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: isSelected
                              ? Color(0xFF108dcf)
                              : Colors.grey.shade300,
                          child:
                              Icon(Icons.work, color: Colors.white, size: 16),
                        ),
                        title: Text(type.Name,
                            style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal)),
                        trailing: isSelected
                            ? Icon(Icons.check_circle,
                                color: Color(0xFF108dcf), size: 20)
                            : null,
                        onTap: () {
                          setState(() {
                            edt_ExpenseType.text = type.Name;
                            edt_ExpenseTypepkID.text = type.pkID.toString();
                            _selectedWorkTypeId = type.pkID;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onLeaveSaveStatusCallSuccess(DailyActivitySaveCallResponseState state) {
    String msg = _isForUpdate
        ? "Activity Updated Successfully!"
        : "Activity Added Successfully!";

    _runAfterBuild(() {
      showCommonDialogWithSingleOption(
        context,
        msg,
        positiveButtonTitle: "OK",
        onTapOfPositiveButton: () {
          navigateTo(context, DailyActivityListScreen.routeName,
              arguments: AddUpdateDailyActivityListScreenArguments(
                  edt_ReverseExpenseDateController.text));
        },
      );
    });
  }
}
