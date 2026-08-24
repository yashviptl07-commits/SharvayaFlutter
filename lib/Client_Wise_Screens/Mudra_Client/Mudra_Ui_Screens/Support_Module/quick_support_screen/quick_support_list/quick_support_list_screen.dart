// ignore_for_file: non_constant_identifier_names

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Atttend_Visit/Mudra_Attend_Visit_Add_Update_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_quick_suport_request/Mudra_quick_suport_list_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_quick_suport_response/Mudra_quick_suport_list_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Bloc_Event_State/mudra_bloc.dart';
import 'package:soleoserp/blocs/other/bloc_modules/followup/followup_bloc.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/followup_history_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
//import 'package:whatsapp_share/whatsapp_share.dart';

class QuickSupportListScreen extends BaseStatefulWidget {
  static const routeName = '/QuickSupportListScreen';

  @override
  _QuickSupportListScreenState createState() => _QuickSupportListScreenState();
}

class _QuickSupportListScreenState extends BaseState<QuickSupportListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MudraBloc _mainBloc;
  int _pageNo = 0;
  MudraQuickSupportListResponse _FollowupListResponse;

  // FollowerEmployeeListResponse _FollowerEmployeeListResponse;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  bool expanded = true;
  bool isListExist = false;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;
  ALL_Name_ID SelectedStatus;
  final TextEditingController edt_FollowupStatus = TextEditingController();
  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  int selected = 0; //attention
  bool isExpand = false;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  var _url = "https://api.whatsapp.com/send?phone=91";
  bool isDeleteVisible = true;
  int TotalCount = 0;
  final TextEditingController PuchInTime = TextEditingController();
  final TextEditingController PuchOutTime = TextEditingController();
  double CardViewHeight = 45.00;
  final TextEditingController edt_Application = TextEditingController();
  final TextEditingController edt_SerialNo = TextEditingController();
  final TextEditingController edt_FollowUpDate = TextEditingController();
  final TextEditingController edt_ReverseFollowUpDate = TextEditingController();
  final TextEditingController edt_Status = TextEditingController();
  final TextEditingController edt_employeeName = TextEditingController();
  final TextEditingController edt_employeeID = TextEditingController();
  final TextEditingController edt_filter_customerName = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_PreferedTime = TextEditingController();
  final TextEditingController edt_PreferedTime_To = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];
  List<ALL_Name_ID> arr_EmployeeList = [];

  @override
  void initState() {
    super.initState();

    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    edt_employeeName.text = _offlineLoggedInData.details[0].employeeName;
    edt_employeeID.text = _offlineLoggedInData.details[0].employeeID.toString();
    edt_filter_customerName.text = "";

    FetchFollowupPriorityDetails();

    _mainBloc = MudraBloc(baseBloc);

    edt_Status.text = "active";

    FetchFollowupStatusDetails();
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text = _offlineLoggedInData.details[0].userID;

    isExpand = false;
    edt_CustomerName.text = "";

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);

    edt_FollowUpDate.text = selectedDate.day.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.year.toString();
    edt_ReverseFollowUpDate.text = selectedDate.year.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.day.toString();

    _mainBloc.add(MudraQuickSupportVisitListEvent(
        1,
        MudraQuickSupportListRequest(
            VisitStatus: edt_Status.text,
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            PageNo: 1.toString(),
            PageSize: 10.toString(),
            CompanyId: CompanyID.toString(),
            EmployeeID: edt_employeeID.text)));
    /*  edt_Status.addListener(() {
      _FollowupBloc.add(QuickFollowupListRequestEvent(QuickFollowupListRequest(
          FollowupStatus: edt_Status.text,
          */ /*FollowupDate:edt_ReverseFollowUpDate.text*/ /* CompanyId:
              CompanyID.toString())));
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc
        ..add(MudraQuickSupportVisitListEvent(
            1,
            MudraQuickSupportListRequest(
                VisitStatus: edt_Status.text,
                LoginUserID: LoginUserID,
                SearchKey: edt_CustomerName.text,
                PageNo: 1.toString(),
                PageSize: 10.toString(),
                CompanyId: CompanyID.toString(),
                EmployeeID: edt_employeeID.text))),
      child: BlocConsumer<MudraBloc, MudraStates>(
        builder: (BuildContext context, MudraStates state) {
          if (state is MudraQuickSupportListResponseState) {
            _onFollowupListCallSuccess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MudraQuickSupportListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MudraStates state) {
          if (state is MudraAttendVisitAddUpdateSaveResponseState) {
            _onBankVoucherSaveResponse(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MudraAttendVisitAddUpdateSaveResponseState) {
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
        appBar: NewGradientAppBar(
          title: Text('Quick Support List'),
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
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _mainBloc.add(MudraQuickSupportVisitListEvent(
                        1,
                        MudraQuickSupportListRequest(
                            VisitStatus: edt_Status.text,
                            LoginUserID: LoginUserID,
                            SearchKey: edt_CustomerName.text,
                            PageNo: 1.toString(),
                            PageSize: 10.toString(),
                            CompanyId: CompanyID.toString(),
                            EmployeeID: edt_employeeID.text)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 25,
                    ),
                    child: Column(
                      children: [Expanded(child: _buildFollowupList())],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
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
                          ListTile(title: _SearchCustomer()),
                          ListTile(title: _buildEmplyeeListView()),
                          ListTile(
                            title: CustomDropDown1("Status",
                                enable1: false,
                                title: "Status",
                                hintTextvalue: "Tap to Select Status",
                                icon: Icon(Icons.arrow_drop_down),
                                controllerForLeft: edt_Status,
                                Custom_values1:
                                    arr_ALL_Name_ID_For_Folowup_Priority),
                          ),
                          ListTile(
                            //leading: Icon(Icons.edit),
                            title: Container(
                              margin: EdgeInsets.only(top: 20, bottom: 10),
                              child: Center(
                                  child: Row(
                                children: [
                                  Flexible(
                                    child: getCommonButton(baseTheme, () {
                                      Navigator.pop(context);

                                      _mainBloc.add(
                                          MudraQuickSupportVisitListEvent(
                                              1,
                                              MudraQuickSupportListRequest(
                                                  VisitStatus: edt_Status.text,
                                                  LoginUserID: LoginUserID,
                                                  SearchKey:
                                                      edt_CustomerName.text,
                                                  PageNo: 1.toString(),
                                                  PageSize: 10.toString(),
                                                  CompanyId:
                                                      CompanyID.toString(),
                                                  EmployeeID:
                                                      edt_employeeID.text)));
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
                          ),
                          Container(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Image.asset(
                CUSTOM_SETTING,
                width: 32,
                height: 32,
              ),
              backgroundColor: colorPrimary,
            ),
          ],
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: LoginUserID),
      ),
    );
  }

  ///builds inquiry list
  Widget _buildFollowupList() {
    if (isListExist) {
      return ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildFollowupListItem(index);
        },
        shrinkWrap: true,
        itemCount: _FollowupListResponse.details.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_SEARCH_RESULT_FOUND, height: 200, width: 200),
      );
    }
  }

  ///builds row item view of inquiry list
  Widget _buildFollowupListItem(int index) {
    //FilterDetails model = _FollowupListResponse.details[index];

    return ExpantionCustomer(context, index);
  }

  ///builds inquiry row items title and value's common view
  Widget _buildTitleWithValueView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: _fontSize_Label,
                color: Color(0xFF504F4F),
                /*fontWeight: FontWeight.bold,*/
                fontStyle: FontStyle
                    .italic) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
        SizedBox(
          height: 3,
        ),
        Text(value,
            style: TextStyle(
                fontSize: _fontSize_Title,
                color:
                    colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            )
      ],
    );
  }

  ///updates data of inquiry list
  void _onFollowupListCallSuccess(MudraQuickSupportListResponseState state) {
    //print("Response326584"+state.quickFollowupListResponse.details[0].customerName.toString());

    if (state.response.details.length != 0) {
      //_FollowupListResponse = state.quickFollowupListResponse;

      for (int i = 0; i < state.response.details.length; i++) {
        /* QuickFollowupListResponseDetails quickFollowupListResponseDetails = QuickFollowupListResponseDetails();
            quickFollowupListResponseDetails.customerName*/

        _FollowupListResponse = state.response;
      }

      if (_FollowupListResponse != null) {
        isListExist = true;
        TotalCount = state.response.totalCount;
      } else {
        isListExist = false;
        TotalCount = 0;
      }
    } else {
      isListExist = false;
    }
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onFollowupListPagination() {
    _mainBloc.add(MudraQuickSupportVisitListEvent(
        _pageNo + 1,
        MudraQuickSupportListRequest(
            VisitStatus: edt_Status.text,
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            PageNo: (_pageNo + 1).toString(),
            PageSize: 10.toString(),
            CompanyId: CompanyID.toString(),
            EmployeeID: edt_employeeID.text)));
  }

  ExpantionCustomer(BuildContext context, int index) {
    MudraQuickSupportListResponseDetails model =
        _FollowupListResponse.details[index];

    return Container(
        padding: EdgeInsets.all(10),
        child: ExpansionTileCard(
          initialElevation: 5.0,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          elevation: 1,
          elevationCurve: Curves.easeInOut,
          shadowColor: Color(0xFF504F4F),
          baseColor: Colors.grey.shade200,
          expandedColor: colorTileBG,
          leading: CircleAvatar(
              backgroundColor: Color(0xFF504F4F),
              child: Image.network(
                "http://demo.sharvayainfotech.in/images/profile.png",
                height: 35,
                fit: BoxFit.fill,
                width: 35,
              )),
          title: Text(
            model.customerName,
            style: TextStyle(color: Colors.black),
          ),
          subtitle: GestureDetector(
            child: Text(
              model.complaintNo,
              style: TextStyle(
                color: Color(0xFF504F4F),
                fontSize: _fontSize_Title,
              ),
            ),
          ),
          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            Container(
                margin: EdgeInsets.all(20),
                child: Container(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Customer Name ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(model.customerName,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Date ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.visitDate.getFormattedDate(
                                                fromFormat:
                                                    "yyyy-MM-ddTHH:mm:ss",
                                                toFormat: "dd-MM-yyyy "),
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Complaint #	",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorPrimary,
                                            fontSize: _fontSize_Label,
                                            letterSpacing: .3)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(model.complaintNo,
                                        style: TextStyle(
                                            color: Color(title_color),
                                            fontSize: _fontSize_Title,
                                            letterSpacing: .3)),
                                  ],
                                ),
                              ]),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Status",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(model.complaintStatus,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Visit Type ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(model.visitType,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Charge Type		",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(model.visitChargeType.toString(),
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Assigned From	",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.complaintCreatedBy.toString(),
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Assigned To	",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.complaintAssignedTo
                                                .toString(),
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Sch.Time In",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(model.timeFrom.toString(),
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Sch.Time Out",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(model.timeTo.toString(),
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            edt_Status.text == "completestatus"
                ? Container()
                : ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonHeight: 52.0,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                        model.timeFrom.toString() == ""
                            ? GestureDetector(
                                onTap: () {

                                  _mainBloc.add(
                                      MudraAttendVisitAddUpdateSaveCallEvent(
                                          MudraAttendVisitSaveRequest(
                                              pkID: model.pkID.toString(),
                                              ComplaintNo: model.complaintID
                                                  .toString(),
                                              VisitDate: model
                                                  .visitDate
                                                  .toString(),
                                              ComplaintStatus:
                                              model
                                                  .complaintStatus
                                                  .toString(),
                                              CustomerID: model
                                                  .customerID
                                                  .toString(),
                                              VisitCharge:
                                              model
                                                  .visitCharge
                                                  .toString(),
                                              FromKMS:
                                              model.fromKMS.toString(),
                                              VisitType: model
                                                  .visitType
                                                  .toString(),
                                              ServiceTag: model
                                                  .serviceTag
                                                  .toString(),
                                              VisitNotes: model
                                                  .visitNotes
                                                  .toString(),
                                              EngineerNotes: model.engineerNotes
                                                  .toString(),
                                              VisitChargeType: model
                                                  .visitChargeType
                                                  .toString(),
                                              ToKMS: model.toKMS.toString(),
                                              TimeFrom: selectedTime.hour
                                                  .toString() +
                                                  ":" +
                                                  selectedTime
                                                      .minute
                                                      .toString(),
                                              TimeTo: model.timeTo.toString(),
                                              LoginUserID:
                                              LoginUserID.toString(),
                                              VisitDocument: "",
                                              CompanyId:
                                              CompanyID.toString())));
                                },
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.login,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                    ),
                                    Text(
                                      'PunchIn',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        model.timeFrom.toString() != ""
                            ? GestureDetector(
                                onTap: () {
                                  if (model.timeFrom != "") {

                                    _mainBloc.add(MudraAttendVisitAddUpdateSaveCallEvent(
                                        MudraAttendVisitSaveRequest(
                                            pkID: model.pkID.toString(),
                                            ComplaintNo:
                                            model.complaintID.toString(),
                                            VisitDate:
                                            model.visitDate.toString(),
                                            ComplaintStatus: model
                                                .complaintStatus
                                                .toString(),
                                            CustomerID:
                                            model.customerID.toString(),
                                            VisitCharge:
                                            model.visitCharge.toString(),
                                            FromKMS: model.fromKMS.toString(),
                                            VisitType:
                                            model.visitType.toString(),
                                            ServiceTag:
                                            model.serviceTag.toString(),
                                            VisitNotes:
                                            model.visitNotes.toString(),
                                            EngineerNotes: model.engineerNotes
                                                .toString(),
                                            VisitChargeType: model
                                                .visitChargeType
                                                .toString(),
                                            ToKMS: model.toKMS.toString(),
                                            TimeFrom:
                                            model.timeFrom.toString(),
                                            TimeTo: selectedTime.hour
                                                .toString() +
                                                ":" +
                                                selectedTime.minute
                                                    .toString(),
                                            LoginUserID:
                                            LoginUserID.toString(),
                                            VisitDocument: "",
                                            CompanyId:
                                            CompanyID.toString())));
                                  } else {
                                    showCommonDialogWithSingleOption(
                                        context, "Punch In Is Required",
                                        positiveButtonTitle: "OK",
                                        onTapOfPositiveButton: () {
                                      Navigator.of(context).pop();
                                    });
                                  }
                                },
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.logout,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                    ),
                                    Text(
                                      'PunchOut',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ]),
          ],
        ));
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  FetchFollowupStatusDetails() {
    arr_ALL_Name_ID_For_Folowup_Status.clear();
    for (var i = 0; i < 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Todays";
      } else if (i == 1) {
        all_name_id.Name = "Missed";
      } else if (i == 2) {
        all_name_id.Name = "Future";
      } else if (i == 3) {
        all_name_id.Name = "completestatus";
      }
      arr_ALL_Name_ID_For_Folowup_Status.add(all_name_id);
    }
  }

  Future<void> MoveTofollowupHistoryPage(String inquiryNo, String CustomerID) {
    navigateTo(context, FollowupHistoryScreen.routeName,
            arguments: FollowupHistoryScreenArguments(inquiryNo, CustomerID))
        .then((value) {});
  }

  showcustomdialogPunchIn({
    BuildContext context1,
    TextEditingController followupDate,
    TextEditingController reversefollowupDate,
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
                    "Add Details",
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    /* TextField(
                        controller: edt_Application,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Tap to enter Application",
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF000000),
                        ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
                    ),*/
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              // _selectDate(context1, followupDate);

                              DateTime selectedDate = DateTime.now();

                              final DateTime picked = await showDatePicker(
                                  context: context1,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101));
                              if (picked != null && picked != selectedDate)
                                setState(() {
                                  selectedDate = picked;
                                  edt_FollowUpDate.text =
                                      selectedDate.day.toString() +
                                          "-" +
                                          selectedDate.month.toString() +
                                          "-" +
                                          selectedDate.year.toString();

                                  print("Dateee" + edt_FollowUpDate.text);
                                  /* edt_ReverseFollowUpDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();*/
                                });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Text("FollowUp Date *",
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
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            edt_FollowUpDate.text == null ||
                                                    edt_FollowUpDate.text == ""
                                                ? "DD-MM-YYYY"
                                                : edt_FollowUpDate.text,
                                            style: baseTheme.textTheme.headline3
                                                .copyWith(
                                                    color:
                                                        edt_FollowUpDate.text ==
                                                                    null ||
                                                                edt_FollowUpDate
                                                                        .text ==
                                                                    ""
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
                              height: CardViewHeight,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                        enabled: true,
                                        controller: edt_Application,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          hintText: "Tap to enter Application",
                                          labelStyle: TextStyle(
                                            color: Color(0xFF000000),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
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
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text("Serial No",
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
                              height: CardViewHeight,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                        enabled: true,
                                        controller: edt_SerialNo,
                                        decoration: InputDecoration(
                                          hintText: "Tap to enter SerialNo",
                                          labelStyle: TextStyle(
                                            color: Color(0xFF000000),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
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
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(90, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(24.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {});
                          // _productList[index1].SerialNo = edt_Application.text;
                          Navigator.pop(context123);
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(color: colorWhite),
                        ))
                  ],
                )),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        F_datecontroller.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        /* edt_ReverseFollowUpDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();*/
      });
  }

  FetchFollowupPriorityDetails() {
    arr_ALL_Name_ID_For_Folowup_Priority.clear();
    for (var i = 0; i <= 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "active";
      } else if (i == 1) {
        all_name_id.Name = "todays";
      } else if (i == 2) {
        all_name_id.Name = "missed";
      } else if (i == 3) {
        all_name_id.Name = "future";
      } else if (i == 4) {
        all_name_id.Name = "completestatus";
      }
      arr_ALL_Name_ID_For_Folowup_Priority.add(all_name_id);
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
      //margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                lable: "Select $Category"),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("Select Status",
                          style: TextStyle(
                              fontSize: 12,
                              color: colorPrimary,
                              fontWeight: FontWeight
                                  .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                          ),
                    ),
                  ]),
                  SizedBox(
                    height: 5,
                  ),
                  Card(
                    elevation: 5,
                    color: colorLightGray,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      // padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: edt_Status,
                              enabled: false,
                              style: TextStyle(fontSize: 15),
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Select",
                              ),
                            ),
                            // dropdown()
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmplyeeListView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);

        showcustomdialogWithTWOName(
            values: arr_EmployeeList,
            context1: context,
            controller: edt_employeeName,
            controller1: edt_employeeID,
            lable: "Select Employee");
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("Select Employee",
                    style: TextStyle(
                        fontSize: 12,
                        color: colorPrimary,
                        fontWeight: FontWeight
                            .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                    ),
              ),
            ]),
            SizedBox(
              height: 5,
            ),
            Card(
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                // padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: edt_employeeName,
                        enabled: false,
                        style: TextStyle(fontSize: 15),
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Select",
                        ),
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
      ),
    );
  }

  Widget _SearchCustomer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text("Search Customer",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
        ]),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            // padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: edt_filter_customerName,
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
                        hintText: "Search Customer"),
                  ),
                  // dropdown()
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _onBankVoucherSaveResponse(
      MudraAttendVisitAddUpdateSaveResponseState state) {
    showCommonDialogWithSingleOption(context,
        state.mudraAttendVisitSaveResponse.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, QuickSupportListScreen.routeName,
          clearAllStack: true);
    });
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_EmployeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id1 = ALL_Name_ID();
        all_name_id1.Name = state.details[i].employeeName;
        all_name_id1.Name1 = state.details[i].pkID.toString();
        all_name_id1.MenuName = state.details[i].userID;
        arr_EmployeeList.add(all_name_id1);
      }
    }
  }
}
