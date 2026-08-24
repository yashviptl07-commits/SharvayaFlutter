import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/todo/todo_bloc.dart';
import 'package:soleoserp/models/api_requests/ToDo_request/to_do_delete_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_header_save_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_module_sharing_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/todo_widget_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/api_responses/to_do/todo_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/to_do_work_log_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/dash_board_widgets/toDo_sharvaya_add_edit.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';


class SharvayaToDoWidgetListScreen extends BaseStatefulWidget {
  static const routeName = '/SharvayaToDoWidgetListScreen';

  @override
  _SharvayaToDoWidgetListScreenState createState() => _SharvayaToDoWidgetListScreenState();
}

class _SharvayaToDoWidgetListScreenState extends BaseState<SharvayaToDoWidgetListScreen>
    with BasicScreen, WidgetsBindingObserver {
  ToDoBloc _ToDoBloc;
  int _pageNo = 0;
  ToDoListResponse _FollowupListResponse;
  bool expanded = true;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;
  ALL_Name_ID SelectedStatus;
  final TextEditingController edt_FollowupStatus = TextEditingController();
  final TextEditingController edt_OwnerShip = TextEditingController();
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_OwnerShip = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  TimeOfDay selectedTime = TimeOfDay.now();

  int CompanyID = 0;
  String LoginUserID = "";
  int TotalCount = 0;
  final TextEditingController edt_FollowupEmployeeList =
  TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
  TextEditingController();
  final TextEditingController edt_EmployeeUserName = TextEditingController();
  TextEditingController Remarks = TextEditingController();

  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);
    _ToDoBloc = ToDoBloc(baseBloc);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    //_offlineFollowerEmployeeListData = SharedPrefHelper.instance.getALLEmployeeList();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();

    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text =
        _offlineLoggedInData.details[0].employeeID.toString();
    FetchFollowupStatusDetails();
    WhoIsCreatedStatusDetails();
    edt_FollowupStatus.text = "Todays";
    edt_OwnerShip.text = "---All---";

    edt_EmployeeUserName.text = LoginUserID;

    edt_FollowupStatus.addListener(followupStatusListener);
    edt_FollowupEmployeeList.addListener(followupStatusListener);
    edt_FollowupEmployeeUserID.addListener(followupStatusListener);
    edt_EmployeeUserName.addListener(followupStatusListener);

    getUserRights(_menuRightsResponse);
  }

  followupStatusListener() {
    print("Current Text is ${edt_FollowupStatus.text}");
    _ToDoBloc.add(ToDoWidgetListCallEvent(
        1,
        ToDoWidgetListApiRequest(
            TaskStatus: edt_FollowupStatus.text,
            Month: "",
            Year: "",
            OwnerShip:
            edt_OwnerShip.text == "---All---" ? "" : edt_OwnerShip.text,
            OwnerShipName: edt_FollowupEmployeeList.text,
            LoginUserID: edt_EmployeeUserName.text,
            CompanyId: CompanyID.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _ToDoBloc
        ..add(ToDoWidgetListCallEvent(
            1,
            ToDoWidgetListApiRequest(
                TaskStatus: edt_FollowupStatus.text,
                Month: "",
                Year: "",
                OwnerShip:
                edt_OwnerShip.text == "---All---" ? "" : edt_OwnerShip.text,
                OwnerShipName: edt_FollowupEmployeeList.text,
                LoginUserID: edt_EmployeeUserName.text,
                CompanyId: CompanyID.toString()))),
      child: BlocConsumer<ToDoBloc, ToDoStates>(
        builder: (BuildContext context, ToDoStates state) {
          if (state is ToDoWidgetListCallResponseState) {
            _onFollowupListCallSuccess(state);
          }

          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ToDoWidgetListCallResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ToDoStates state) {
          if (state is ToDoSaveHeaderState) {
            _OnSaveToDoHeaderResponse(state);
          }

          if (state is ToDoDeleteResponseState) {
            _OnDeleteTodoResponse(state);
          }

          if(state is ToDoModuleSharingListResponseState)
          {
            _onToDoModuleSharingListResponseState(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ToDoSaveHeaderState ||
              currentState is ToDoDeleteResponseState ||
              currentState is ToDoModuleSharingListResponseState
          ) {
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
          title: Text('To-Do Widget list'),
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
                navigateTo(context, HomeScreen.routeName,
                    clearAllStack: true);
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: colorWhite,
                ),
                onPressed: () {
                  return showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Wrap(
                          children: [
                            ListTile(
                              // leading: Icon(Icons.share),
                              title: Center(
                                child: Text(
                                  "~~~Filter~~~",
                                  style: TextStyle(color: colorPrimary),
                                ),
                              ),
                            ),
                            Container(
                              height: 2,
                              color: colorLightGray,
                            ),
                            Container(
                              height: 5,
                            ),
                            Column(children: [
                              _buildEmplyeeListView(),
                              SizedBox(height: 10),
                              _buildSearchView(),
                              SizedBox(height: 10),
                              _buildWhoCreateView(),
                            ]),
                            Container(
                              height: 25,
                            ),
                            ListTile(
                              //leading: Icon(Icons.edit),
                              title: Center(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: getCommonButton(baseTheme, () {
                                          Navigator.pop(context);
                                          _ToDoBloc.add(ToDoWidgetListCallEvent(
                                              1,
                                              ToDoWidgetListApiRequest(
                                                  TaskStatus: edt_FollowupStatus.text,
                                                  Month: "",
                                                  Year: "",
                                                  OwnerShip: edt_OwnerShip.text ==
                                                      "---All---"
                                                      ? ""
                                                      : edt_OwnerShip.text,
                                                  OwnerShipName:
                                                  edt_FollowupEmployeeList.text,
                                                  LoginUserID:
                                                  edt_EmployeeUserName.text,
                                                  CompanyId: CompanyID.toString())));
                                        }, "Submit", radius: 15),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: getCommonButton(baseTheme, () {
                                          Navigator.pop(context);
                                        }, "Close", radius: 15),
                                      ),
                                    ],
                                  )),
                            ),
                            Container(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
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
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _ToDoBloc.add(ToDoWidgetListCallEvent(
                        1,
                        ToDoWidgetListApiRequest(
                            TaskStatus: edt_FollowupStatus.text,
                            Month: "",
                            Year: "",
                            OwnerShip: edt_OwnerShip.text == "---All---"
                                ? ""
                                : edt_OwnerShip.text,
                            OwnerShipName: edt_FollowupEmployeeList.text,
                            LoginUserID: edt_EmployeeUserName.text,
                            CompanyId: CompanyID.toString())));

                    getUserRights(_menuRightsResponse);
                  },
                  child: Column(
                    children: [
                      Expanded(child: _buildFollowupList())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton:
        IsAddRights == true
            ? FloatingActionButton(
          onPressed: (){
            navigateTo(context, SharvayaToDoWidgetAddEditScreen.routeName, clearAllStack: true);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        )
            : Container(),
      ),
    );
  }

  Widget _buildSearchView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Text("Status",
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

          ),
        ),
        InkWell(
          onTap: () {
            showcustomdialogWithOnlyName(
                values: arr_ALL_Name_ID_For_Folowup_Status,
                context1: context,
                controller: edt_FollowupStatus,
                lable: "Select Status");
          },
          child: Card(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
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
                    child: TextField(
                      controller: edt_FollowupStatus,
                      enabled: false,
                      style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
          ),
        ),
      ],
    );
  }

  Widget _buildWhoCreateView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Text("OwnerShip",
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

          ),
        ),
        InkWell(
          onTap: () {
            showcustomdialogWithOnlyName(
                values: arr_ALL_Name_ID_For_OwnerShip,
                context1: context,
                controller: edt_OwnerShip,
                lable: "Select OwnerShip");
          },
          child: Card(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
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
                    child: TextField(
                      controller: edt_OwnerShip,
                      enabled: false,
                      style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
          ),
        ),
      ],
    );
  }

  ///builds inquiry list
  Widget _buildFollowupList() {
    if (_FollowupListResponse == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
          scrollInfo,
        )) {
          _onFollowupListPagination();
          return true;
        } else {
          return false;
        }
      },
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _buildFollowupListItem(index);
        },
        shrinkWrap: true,
        itemCount: _FollowupListResponse.details.length,
      ),
    );
  }

  ///builds row item view of inquiry list
  Widget _buildFollowupListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ///updates data of inquiry list
  void _onFollowupListCallSuccess(ToDoWidgetListCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _FollowupListResponse = state.response;
      } else {
        _FollowupListResponse.details.addAll(state.response.details);
      }
      if (_FollowupListResponse.details.length != 0) {
        TotalCount = state.response.totalCount;
      } else {
        TotalCount = 0;
      }

      _pageNo = state.newPage;
    }
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onFollowupListPagination() {
    if (_FollowupListResponse.details.length <
        _FollowupListResponse.totalCount) {
      _ToDoBloc.add(ToDoWidgetListCallEvent(
          1,
          ToDoWidgetListApiRequest(
              TaskStatus: edt_FollowupStatus.text,
              Month: "",
              Year: "",
              OwnerShip:
              edt_OwnerShip.text == "---All---" ? "" : edt_OwnerShip.text,
              OwnerShipName: edt_FollowupEmployeeList.text,
              LoginUserID: edt_EmployeeUserName.text,
              CompanyId: CompanyID.toString())));
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  Widget ExpantionCustomer(BuildContext context, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.04;
    double fontSize = screenWidth * 0.04; // Consistent font size for all texts
    double fontSizeTitle = screenWidth * 0.045;
    double fontSizeLabel = screenWidth * 0.037;

    ToDoDetails model = _FollowupListResponse.details[index];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[50],
        elevation: 8,
        shadowColor: Colors.blue[600],
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customer Name", style: _labelStyle(fontSize)),
                  Text(
                    model.CustomerName.isNotEmpty ? model.CustomerName : model.taskDescription,
                    overflow: TextOverflow.ellipsis,
                    style: _valueStyle(fontSize),
                  ),
                ],
              ),
              Divider(thickness: 1.0, color: Colors.grey[300]),

              // Priority
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Priority : ", style: _labelStyle(fontSize)),
                  SizedBox(height: 4),
                  _buildPriorityBadge(model.priority),
                ],
              ),
              SizedBox(height: 8),

              // Other Details
              _buildDetailRow1("Start Date : ", model.startDate.getFormattedDate(fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ?? "-",  fontSizeLabel, fontSizeLabel * 1.1),
              _buildDetailRow1("Due Date : ", model.dueDate.getFormattedDate(fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ?? "-",  fontSizeLabel, fontSizeLabel * 1.1),
              _buildDetailRow1("Assign To : ", model.employeeName.isNotEmpty ? model.employeeName : "-",  fontSizeLabel, fontSizeLabel * 1.1),
              _buildDetailRow1("Status : ", model.taskStatus.isNotEmpty ? model.taskStatus : "-",  fontSizeLabel, fontSizeLabel * 1.1),
              _buildDetailRow1("Task Description : ", model.taskDescription.isNotEmpty ? model.taskDescription : "-", fontSizeLabel, fontSizeLabel * 1.1),
              _buildDetailRow1("Initiated By : ", model.fromEmployeeName, fontSizeLabel, fontSizeLabel * 1.1),
              _buildDetailRow1("Completion Date : ", model.completionDate != null && model.completionDate != "1900-01-01T00:00:00"
                  ? model.completionDate.getFormattedDate(fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy")
                  : "N/A",  fontSizeLabel, fontSizeLabel * 1.1),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(Icons.history, "History", () {
                    MoveTofollowupHistoryPage(model.pkID.toString());
                  }, fontSize),
                  SizedBox(width: 20),
                  if (IsEditRights)
                    _buildActionButton(Icons.edit, "Edit", () {
                      _onTaptocallTagEmpList(model);
                    }, fontSize),
                  if (IsDeleteRights)
                    SizedBox(width: 20),
                  if (IsDeleteRights)
                    _buildActionButton(Icons.delete, "Delete", () {
                      showCommonDialogWithTwoOptions(
                        context,
                        "Are you sure you want to delete this record?",
                        negativeButtonTitle: "No",
                        positiveButtonTitle: "Yes",
                        onTapOfPositiveButton: () {
                          Navigator.of(context).pop();
                          _ToDoBloc.add(ToDoDeleteEvent(
                            model.pkID,
                            ToDoDeleteRequest(CompanyId: CompanyID.toString()),
                          ));
                        },
                      );
                    }, fontSize, color: Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow1(String label, String value, double labelFontSize, double valueFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle(labelFontSize)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.black87, fontSize: valueFontSize)),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color backgroundColor;
    Color textColor;

    switch (priority) {
      case "High":
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case "Medium":
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        break;
      case "Low":
        backgroundColor = Colors.green;
        textColor = Colors.black;
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
    }

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(
          priority,
          style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

// Helper for action buttons
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap, double fontSize, {Color color = Colors.black}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: fontSize * 1.2),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: fontSize)),
        ],
      ),
    );
  }


// Helper styles
  TextStyle _labelStyle(double fontSize) => TextStyle(
    color: Colors.blueAccent,
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
  );

  TextStyle _valueStyle(double fontSize) => TextStyle(
    color: Colors.black87,
    fontSize: fontSize,
  );



  Widget dropdown() {
    return GestureDetector(
      onTap: () => showcustomdialog(
          values: arr_ALL_Name_ID_For_Folowup_Status,
          context1: context,
          controller: edt_FollowupStatus,
          lable: "Select Status"),
      child: Container(
        child: buildUserNameTextFiledRounded(
            enablevalue: false,
            userName_Controller: edt_FollowupStatus,
            labelName: "Followup Status",
            icon: Icon(Icons.arrow_drop_down),
            maxline: 1,
            baseTheme: baseTheme),
      ),
    );
  }

  Future<void> _onTapOfSearchView(BuildContext context) async {}

  FetchFollowupStatusDetails() {
    arr_ALL_Name_ID_For_Folowup_Status.clear();
    for (var i = 0; i < 6; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "todays";
      } else if (i == 1) {
        all_name_id.Name = "Pending";
      } else if (i == 2) {
        all_name_id.Name = "Completed";
      } else if (i == 3) {
        all_name_id.Name = "Pending-OverDue";
      } else if (i == 4) {
        all_name_id.Name = "Completed-OverDue";
      } else if (i == 5) {
        all_name_id.Name = "future";
      }
      arr_ALL_Name_ID_For_Folowup_Status.add(all_name_id);
    }
  }

  WhoIsCreatedStatusDetails() {
    arr_ALL_Name_ID_For_OwnerShip.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "---All---";
      } else if (i == 1) {
        all_name_id.Name = "initiate";
      } else if (i == 2) {
        all_name_id.Name = "assign";
      }
      arr_ALL_Name_ID_For_OwnerShip.add(all_name_id);
    }
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        // all_name_id.Name1 = state.details[i].;
        all_name_id.pkID = state.details[i].pkID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
  }

  Widget _buildEmplyeeListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Text("Employee List",
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

          ),
        ),
        InkWell(
          onTap: () {
            showcustomdialogWithID(
                values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
                context1: context,
                controller: edt_FollowupEmployeeList,
                controllerID: edt_FollowupEmployeeUserID,
                lable: "Select Employee");
          },
          child: Card(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
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
                    child: TextField(
                      controller: edt_FollowupEmployeeList,
                      enabled: false,
                      style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onTaptocallTagEmpList(ToDoDetails model) {

    _ToDoBloc.add(ToDoModuleSharingListApiRequestEvent(ToDoModuleSharingListApiRequest(
      Module:"todo",
      ParentID:model.pkID.toString(),
      CompanyId:CompanyID.toString(),
    ),model));
  }


  void _onToDoModuleSharingListResponseState(ToDoModuleSharingListResponseState state) {

    List<ALL_Name_ID> tempList=[];

    if(state.response.details.isNotEmpty)
    {

      for(int i=0;i<state.response.details.length;i++)
      {
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name = state.response.details[i].employeeName;
        all_name_id.pkID = state.response.details[i].employeeID;
        all_name_id.isChecked = true;


        print("oopsadad" + state.response.details[i].employeeName);


        tempList.add(all_name_id);


      }

      _onTapOfEditCustomer(state.todoDetails,tempList);

    }
    else
    {
      _onTapOfEditCustomer(state.todoDetails,tempList);

    }
  }


  void _onTapOfEditCustomer(ToDoDetails model,List<ALL_Name_ID> tagEmployeeList) {
    navigateTo(context, SharvayaToDoWidgetAddEditScreen.routeName,
        arguments: SharvayaToDoWidgetAddEditScreenArguments(edt_FollowupStatus.text,
            edt_FollowupEmployeeUserID.text, model,tagEmployeeList))
        .then((value) {
      setState(() {
        ALL_Name_ID all_name_id = value;
        edt_FollowupStatus.text = all_name_id.Name;
        edt_FollowupEmployeeUserID.text = all_name_id.Name1;
        _ToDoBloc.add(ToDoWidgetListCallEvent(
            1,
            ToDoWidgetListApiRequest(
                TaskStatus: edt_FollowupStatus.text,
                Month: "",
                Year: "",
                OwnerShip:
                edt_OwnerShip.text == "---All---" ? "" : edt_OwnerShip.text,
                OwnerShipName: edt_FollowupEmployeeList.text,
                LoginUserID: edt_EmployeeUserName.text,
                CompanyId: CompanyID.toString())));
      });
    });
  }

  Future<void> MoveTofollowupHistoryPage(String inquiryNo) {
    navigateTo(context, ToDoWorkLogScreen.routeName,
        arguments: ToDoWorkLogScreenArguments(inquiryNo))
        .then((value) {});
  }

  doSomething() {
    print("ddf" + "Deleted");
  }

  showcustomdialog123({
    BuildContext context1,
    ToDoDetails finalCheckingItems,
    int index1,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorPrimary, //                   <--- border color
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                    15.0) //                 <--- border radius here
                ),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Remarks",
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 7, right: 7, top: 5),
                            child: TextFormField(
                              controller: Remarks,
                              minLines: 2,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  hintText: 'Enter Description',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    getCommonButton(baseTheme, () {
                      if (Remarks.text != "") {
                        Navigator.pop(context123);

                        String AM_PM =
                        selectedTime.periodOffset.toString() == "12"
                            ? "PM"
                            : "AM";
                        String beforZeroHour = selectedTime.hourOfPeriod <= 9
                            ? "0" + selectedTime.hourOfPeriod.toString()
                            : selectedTime.hourOfPeriod.toString();
                        String beforZerominute = selectedTime.minute <= 9
                            ? "0" + selectedTime.minute.toString()
                            : selectedTime.minute.toString();

                        String TimeHour =
                            beforZeroHour + ":" + beforZerominute + " " + AM_PM;
                        _ToDoBloc.add(ToDoSaveHeaderEvent(
                            context,
                            finalCheckingItems.pkID,
                            ToDoHeaderSaveRequest(
                                Priority: "Medium",
                                TaskDescription: Remarks.text,
                                Location: finalCheckingItems.location,
                                TaskCategoryID: finalCheckingItems
                                    .taskCategoryId
                                    .toString(),
                                StartDate: finalCheckingItems.startDate
                                    .getFormattedDate(
                                    fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                    toFormat: "yyyy-MM-dd") +
                                    " " +
                                    TimeHour,
                                DueDate: finalCheckingItems.dueDate
                                    .getFormattedDate(
                                    fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                    toFormat: "yyyy-MM-dd") +
                                    " " +
                                    TimeHour,
                                CompletionDate: finalCheckingItems.startDate
                                    .getFormattedDate(
                                    fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                    toFormat: "yyyy-MM-dd"),
                                LoginUserID: LoginUserID,
                                EmployeeID:
                                finalCheckingItems.employeeID.toString(),
                                Reminder: "",
                                ReminderMonth: "",
                                Latitude: "",
                                Longitude: "",
                                ClosingRemarks:
                                finalCheckingItems.closingRemarks,
                                CompanyId: CompanyID.toString())));
                      } else {
                        commonalertbox("Remarks should not Empty");
                      }
                    }, "Submit Details",
                        backGroundColor: colorPrimary,
                        textColor: colorWhite,
                        width: 200)
                  ],
                )),
          ],
        );
      },
    );
  }

  Widget commonalertbox(String msg,
      {GestureTapCallback onTapofPositive, bool useRootNavigator = true}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ab) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 10,
            actions: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colorPrimary, width: 2.00),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Alert!",
                  style: TextStyle(
                    fontSize: 20,
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.center,
                //margin: EdgeInsets.only(left: 10),
                child: Text(
                  msg,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                height: 1.00,
                thickness: 2.00,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: onTapofPositive ??
                        () {
                      Navigator.of(context, rootNavigator: useRootNavigator)
                          .pop();
                    },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }

  void _OnSaveToDoHeaderResponse(ToDoSaveHeaderState state) {
    Remarks.text = "";
    commonalertbox(state.toDoSaveHeaderResponse.details[0].column2,
        onTapofPositive: () {
          _ToDoBloc.add(ToDoWidgetListCallEvent(
              1,
              ToDoWidgetListApiRequest(
                  TaskStatus: edt_FollowupStatus.text,
                  Month: "",
                  Year: "",
                  OwnerShip:
                  edt_OwnerShip.text == "---All---" ? "" : edt_OwnerShip.text,
                  OwnerShipName: edt_FollowupEmployeeList.text,
                  LoginUserID: edt_EmployeeUserName.text,
                  CompanyId: CompanyID.toString())));
          Navigator.pop(context);
        });
  }

  void _OnDeleteTodoResponse(ToDoDeleteResponseState state) {
    print("DeleteAPIResponse" +
        "DeleteMsg : " +
        state.toDoDeleteResponse.details[0].column1);

    _ToDoBloc.add(ToDoWidgetListCallEvent(
        1,
        ToDoWidgetListApiRequest(
            TaskStatus: edt_FollowupStatus.text,
            Month: "",
            Year: "",
            OwnerShip:
            edt_OwnerShip.text == "---All---" ? "" : edt_OwnerShip.text,
            OwnerShipName: edt_FollowupEmployeeList.text,
            LoginUserID: edt_EmployeeUserName.text,
            CompanyId: CompanyID.toString())));
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgToDO") {
        _ToDoBloc.add(UserMenuRightsRequestEvent(
            menuRightsResponse.details[i].menuId.toString(),
            UserMenuRightsRequest(
                MenuID: menuRightsResponse.details[i].menuId.toString(),
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID)));
        break;
      }
    }
  }

  void _OnMenuRightsSucess(UserMenuRightsResponseState state) {
    for (int i = 0; i < state.userMenuRightsResponse.details.length; i++) {
      print("DSFsdfkk" +
          " MenuName :" +
          state.userMenuRightsResponse.details[i].addFlag1.toString());

      IsAddRights = state.userMenuRightsResponse.details[i].addFlag1
          .toLowerCase()
          .toString() ==
          "true"
          ? true
          : false;
      IsEditRights = state.userMenuRightsResponse.details[i].editFlag1
          .toLowerCase()
          .toString() ==
          "true"
          ? true
          : false;
      IsDeleteRights = state.userMenuRightsResponse.details[i].delFlag1
          .toLowerCase()
          .toString() ==
          "true"
          ? true
          : false;
    }
  }
}