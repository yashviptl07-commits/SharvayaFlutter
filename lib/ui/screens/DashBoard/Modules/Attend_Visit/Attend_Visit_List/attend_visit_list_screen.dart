import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/attend_visit/attend_visit_bloc.dart';
import 'package:soleoserp/models/api_requests/AttendVisit/attend_visit_delete_request.dart';
import 'package:soleoserp/models/api_requests/AttendVisit/attend_visit_list_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_search_by_Id_request.dart';
import 'package:soleoserp/models/api_responses/attendVisit/attend_visit_list_response.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/complaint/complaint_search_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Attend_Visit/Attend_Visit_Add_Edit/attend_visit_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Attend_Visit/Attend_Visit_List/attend_visit_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/ui/widgets/new_common_widget.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class AttendVisitListScreen extends BaseStatefulWidget {
  static const routeName = '/AttendVisitListScreen';

  @override
  _AttendVisitListScreenState createState() => _AttendVisitListScreenState();
}

class _AttendVisitListScreenState extends BaseState<AttendVisitListScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  AttendVisitBloc _complaintScreenBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  MenuRightsResponse _menuRightsResponse;

  int CompanyID = 0;
  String LoginUserID = "";
  int _pageNo = 0;
  AttendVisitListResponse _inquiryListResponse;
  ComplaintSearchDetails _searchDetails;
  double sizeboxsize = 12;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  bool expanded = true;
  bool isDeleteVisible = true;
  int selected = 0;
  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);

    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text = _offlineLoggedInData.details[0].userID;

    _complaintScreenBloc = AttendVisitBloc(baseBloc);
    _complaintScreenBloc.add(AttendVisitListCallEvent(
        1,
        AttendVisitListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text)));
    getUserRights(_menuRightsResponse);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _complaintScreenBloc,
      child: BlocConsumer<AttendVisitBloc, AttendVisitStates>(
        builder: (BuildContext context, AttendVisitStates state) {
          if (state is AttendVisitListCallResponseState) {
            _onGetListCallSuccess(state);
          }
          if (state is AttendVisitSearchByIDResponseState) {
            _onSearchbyIDResponse(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is AttendVisitListCallResponseState ||
              currentState is AttendVisitSearchByIDResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, AttendVisitStates state) {
          if (state is AttendVisitDeleteResponseState) {
            _onDeleteCallSuccess(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is AttendVisitDeleteResponseState) {
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
        backgroundColor: Colors.blue.shade50,
        appBar: NewGradientAppBar(
          title: Text('Attend Visit List'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          leading: InkWell(
              onTap: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              },
              child: Icon(Icons.arrow_back_outlined)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: colorWhite,
                  size: 30,
                ),
                onPressed: () {
                  _onTapOfSearchView();
                }),
            IsAddRights == true
                ? IconButton(
                    icon: Icon(
                      Icons.add_circle_rounded,
                      color: colorWhite,
                      size: 30,
                    ),
                    onPressed: () {
                      navigateTo(context, AttendVisitAddEditScreen.routeName,
                          clearAllStack: true);
                    })
                : Container(),
            SizedBox(width: 10)
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _searchDetails = null;

                    _complaintScreenBloc.add(AttendVisitListCallEvent(
                        1,
                        AttendVisitListRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: edt_FollowupEmployeeUserID.text)));
                    getUserRights(_menuRightsResponse);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    child: Column(
                      children: [Expanded(child: _buildInquiryList())],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  void _onGetListCallSuccess(AttendVisitListCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _inquiryListResponse = state.response;
      } else {
        _inquiryListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
  }

  showcustomdialogofEmployeeDropDown(
      {List<ALL_Name_ID> values,
      BuildContext context1,
      TextEditingController controller,
      TextEditingController controllerID,
      TextEditingController controller2,
      String lable}) async {
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
                    lable,
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(children: <Widget>[
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context1).pop();
                                  controller.text = values[index].Name;
                                  controller2.text = values[index].Name1 == null
                                      ? ""
                                      : values[index].Name1;

                                  _complaintScreenBloc.add(
                                      AttendVisitListCallEvent(
                                          1,
                                          AttendVisitListRequest(
                                              CompanyId: CompanyID.toString(),
                                              LoginUserID: controller2.text)));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 25, top: 10, bottom: 10, right: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorPrimary), //Change color
                                        width: 10.0,
                                        height: 10.0,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 1.5),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        values[index].Name,
                                        style: TextStyle(color: colorPrimary),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: values.length,
                          ),
                        ])),
                  ],
                )),
          ],
        );
      },
    );
  }

  ///navigates to search list screen
  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchAttendVisitScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        _complaintScreenBloc.add(AttendVisitSearchByIDCallEvent(
            _searchDetails.pkID,
            ComplaintSearchByIDRequest(
                CompanyId: CompanyID.toString(),
                LoginUserID: edt_FollowupEmployeeUserID.text)));
      }
    });
  }

  void _onInquiryListPagination() {
    _complaintScreenBloc.add(AttendVisitListCallEvent(
        _pageNo + 1,
        AttendVisitListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: edt_FollowupEmployeeUserID.text)));
  }

  Widget _buildInquiryList() {
    if (_inquiryListResponse == null) {
      return Container();
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
              scrollInfo,
            ) &&
            _searchDetails == null) {
          _onInquiryListPagination();
          return true;
        } else {
          return false;
        }
      },
      child: ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          AttendVisitDetails model = _inquiryListResponse.details[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Visit ID and Complaint No
                  MultipleList(
                    label: "Visit Id",
                    value: model.visitID.toString(),
                    icon: Icon(Icons.badge, color: Colors.blueAccent),
                    label1: "Complaint No",
                    value1: model.complaintNo,
                    icon1:
                        Icon(Icons.format_list_numbered, color: Colors.green),
                  ),
                  SizedBox(height: 15),
                  // Customer Name and Complaint Date
                  MultipleList(
                    label: "Customer Name",
                    value: model.customerName,
                    icon: Icon(Icons.person, color: Colors.blueAccent),
                    label1: "Complaint Date",
                    value1: model.complaintDate.getFormattedDate(
                        fromFormat: "yyyy-MM-dd", toFormat: "dd-MM-yyyy"),
                    icon1: Icon(Icons.date_range, color: Colors.redAccent),
                  ),
                  SizedBox(height: 10),
                  // Compact More Details button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          showAnimatedDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context123) {
                              return SimpleDialog(
                                backgroundColor: Colors.blue.shade50,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                children: [
                                  SizedBox(
                                      width:
                                          MediaQuery.of(context123).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 15),
                                          buildDetailRow(
                                              "Visit Type",
                                              model.visitType,
                                              Icons.merge_type),
                                          buildDetailRow(
                                              "Charge Type",
                                              model.visitChargeType ?? "",
                                              Icons.merge_type),
                                          buildDetailRow(
                                              "Visit Charge",
                                              model.visitCharge.toString(),
                                              Icons.currency_rupee),
                                          buildDetailRow(
                                              "Assigned From",
                                              model.employeeName.toString(),
                                              Icons.person),
                                          buildDetailRow(
                                              "Assigned To",
                                              model.createdBy ?? "",
                                              Icons.person),
                                          buildDetailRow(
                                              "Attended On",
                                              model.preferredDate
                                                      ?.getFormattedDate(
                                                          fromFormat:
                                                              "yyyy-MM-dd",
                                                          toFormat:
                                                              "dd-MM-yyyy") ??
                                                  "",
                                              Icons.date_range),
                                          buildDetailRow(
                                              "Sch. Time",
                                              model.timeFrom +
                                                  "-" +
                                                  model.timeFrom,
                                              Icons.lock_clock),
                                          SizedBox(height: 20),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            child: getCommonButton(baseTheme,
                                                () {
                                              Navigator.pop(context123);
                                            }, "Close",
                                                backGroundColor: colorRED,
                                                radius: 10.0),
                                          ),
                                        ],
                                      )),
                                ],
                              );
                            },
                            animationType: DialogTransitionType.size,
                          );
                        },
                        icon: Icon(Icons.info, color: Colors.white, size: 18),
                        label: Text(
                          "More Details",
                          style: TextStyle(fontSize: 14), // Smaller text size
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5), // Less padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize:
                              Size(120, 30), // Adjust size of the button
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  // Edit and Delete Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IsEditRights == true
                          ? ElevatedButton.icon(
                              onPressed: () {
                                _onTapOfEditCustomer(model);
                              },
                              icon: Icon(Icons.edit, color: Colors.white),
                              label: Text("Edit"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            )
                          : Container(),
                      IsDeleteRights == true
                          ? ElevatedButton.icon(
                              onPressed: () {
                                showCommonDialogWithTwoOptions(context,
                                    "Are you sure you want to Delete this Attend Visit ?",
                                    negativeButtonTitle: "No",
                                    positiveButtonTitle: "Yes",
                                    onTapOfPositiveButton: () {
                                  Navigator.of(context).pop();
                                  _onTapOfDeleteInquiry(model.pkID);
                                });
                              },
                              icon: Icon(Icons.delete, color: Colors.white),
                              label: Text("Delete"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        shrinkWrap: true,
        itemCount: _inquiryListResponse.details.length,
      ),
    );
  }

  Widget buildDetailRow(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon,
              color: Colors.blueAccent, size: 18), // Icon before the text
          SizedBox(width: 10), // Space between icon and text
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.blueGrey[700],
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              textAlign:
                  TextAlign.right, // Align the value to the right for balance
            ),
          ),
        ],
      ),
    );
  }

  void _onDeleteCallSuccess(AttendVisitDeleteResponseState state) {
    _complaintScreenBloc.add(AttendVisitListCallEvent(
        1,
        AttendVisitListRequest(
            CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
  }

  void _onTapOfDeleteInquiry(int pkID) {
    _complaintScreenBloc.add(AttendVisitDeleteEvent(AttendVisitDeleteRequest(
        pkID: pkID.toString(), CompanyId: CompanyID.toString())));
  }

  void _onTapOfEditCustomer(AttendVisitDetails detail) {
    navigateTo(context, AttendVisitAddEditScreen.routeName,
            arguments: AddUpdateVisitScreenArguments(detail))
        .then((value) {
      _complaintScreenBloc.add(AttendVisitListCallEvent(
          1,
          AttendVisitListRequest(
              CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
    });
  }

  void _onSearchbyIDResponse(AttendVisitSearchByIDResponseState state) {
    _inquiryListResponse = state.complaintSearchByIDResponse;
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].userID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }

    setState(() {});
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "pgVisit") {
        _complaintScreenBloc.add(UserMenuRightsRequestEvent(
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
