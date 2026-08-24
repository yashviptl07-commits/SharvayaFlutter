// ignore_for_file: missing_return

import 'dart:io';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Complaint_Delete_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Complaint_List_Screen_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Complaint_List_Screen_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Bloc_Event_State/mudra_bloc.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/Mudra_Complaint_Module/Mudra_Complaint_Add_Edit_Screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/Mudra_Complaint_Module/Mudra_Complaint_History_List.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class MudraCompliantListScreen extends BaseStatefulWidget {
  static const routeName = '/MudraCompliantListScreen';

  @override
  _MudraCompliantListScreenScreen createState() =>
      _MudraCompliantListScreenScreen();
}

class _MudraCompliantListScreenScreen
    extends BaseState<MudraCompliantListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MudraBloc _mudraBloc;
  Function refreshList;
  MudraComplaintListResponse _listResponse;
  int _pageNo = 0;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  double CardViewHieght = 50;
  bool isDeleteVisible = true;
  int selected = 0;
  bool isExpand = false;
  double _fontSize_Label = 12;
  double _fontSize_Title = 15;
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_LeadStatus = TextEditingController();

  /*List<ALLNameApiModel> vehicalFeaturesList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_select_vehicle = [];*/

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  List<File> documentList = [];
  int FinalTotalCount = 0;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];

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
    isExpand = false;
    edt_CustomerName.text = "";
    LeadStatus();
    edt_LeadStatus.text = "ALL Leads";
    _mudraBloc.add(MudraBankVoucherListEvent(
        1,
        MudraComplaintListRequest(
            pkID: "0",
            CustomerID: "0",
            ComplaintStatus:
                edt_LeadStatus.text == "ALL Leads" ? "" : edt_LeadStatus.text,
            ComplaintType: "",
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            PageNo: 1.toString(),
            PageSize: 10.toString(),
            CompanyId: CompanyID.toString())));

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mudraBloc
        ..add(MudraBankVoucherListEvent(
            1,
            MudraComplaintListRequest(
                pkID: "0",
                CustomerID: "0",
                ComplaintStatus: edt_LeadStatus.text == "ALL Leads"
                    ? ""
                    : edt_LeadStatus.text,
                ComplaintType: "",
                LoginUserID: LoginUserID,
                SearchKey: edt_CustomerName.text,
                PageNo: 1.toString(),
                PageSize: 10.toString(),
                CompanyId: CompanyID.toString()))),
      child: BlocConsumer<MudraBloc, MudraStates>(
        builder: (BuildContext context, MudraStates state) {
          if (state is MudraBankVoucherListResponseState) {
            _onMudraCompaintListResponseSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MudraBankVoucherListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MudraStates state) {
          if (state is MudraCompaintDeleteResponseState) {
            _onDeleteBankVoucher(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MudraCompaintDeleteResponseState) {
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
          title: Text('Register Complaint'),
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
                  Icons.water_damage_sharp,
                  color: colorWhite,
                  size: 30,
                ),
                onPressed: () {
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                }),
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _mudraBloc.add(MudraBankVoucherListEvent(
                        1,
                        MudraComplaintListRequest(
                            pkID: "0",
                            CustomerID: "0",
                            ComplaintStatus: edt_LeadStatus.text == "ALL Leads"
                                ? ""
                                : edt_LeadStatus.text,
                            ComplaintType: "",
                            LoginUserID: LoginUserID,
                            SearchKey: edt_CustomerName.text,
                            PageNo: 1.toString(),
                            PageSize: 10.toString(),
                            CompanyId: CompanyID.toString())));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        // _buildSearchView(),
                        /*Align(
                          alignment: Alignment.center,
                          child: Card(
                            color: colorPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              height: 35,
                              width: 200,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Count : ",
                                      //TotalCount.toString(),

                                      style: TextStyle(
                                          color: colorWhite,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      FinalTotalCount.toString(),
                                      //TotalCount.toString(),
                                      style: TextStyle(
                                          color: colorWhite,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),*/
                        Expanded(child: _buildInquiryList())
                      ],
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
            FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () {
                /* edt_FollowupEmployeeList.text = "";
                _onTapOfSearchView();*/
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
                          /*ListTile(
                            // leading: Icon(Icons.copy),
                            title: _buildSearchView(),
                          ),*/
                          Container(
                            height: 10,
                          ),
                          ListTile(
                            // leading: Icon(Icons.copy),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Search content",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF000000),
                                        fontWeight: FontWeight
                                            .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

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
                                          child: TextField(
                                            controller: edt_CustomerName,
                                            style: TextStyle(
                                                color: Colors
                                                    .black, // <-- Change this

                                                fontWeight: FontWeight.bold),
                                            decoration: new InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  left: 15,
                                                  bottom: 11,
                                                  top: 11,
                                                  right: 15),
                                              hintText: "Tap to search content",
                                            ),
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
                          ),
                          Container(
                            height: 10,
                          ),
                          ListTile(
                            //leading: Icon(Icons.edit),
                            title: Center(
                                child: Row(
                              children: [
                                Flexible(
                                  child: getCommonButton(baseTheme, () {
                                    Navigator.pop(context);
                                    _mudraBloc.add(MudraBankVoucherListEvent(
                                        1,
                                        MudraComplaintListRequest(
                                            pkID: "0",
                                            CustomerID: "0",
                                            ComplaintStatus:
                                                edt_LeadStatus.text ==
                                                        "ALL Leads"
                                                    ? ""
                                                    : edt_LeadStatus.text,
                                            ComplaintType: "",
                                            LoginUserID: LoginUserID,
                                            SearchKey: edt_CustomerName.text,
                                            PageNo: 1.toString(),
                                            PageSize: 10.toString(),
                                            CompanyId: CompanyID.toString())));
                                    // navigateTo(context, Invoice_ADD_EDIT.routeName);
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
              },
              label: Image.asset(
                CUSTOM_SETTING,
                color: Colors.white,
                height: 32,
                width: 32,
              ),
              backgroundColor: colorPrimary,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                navigateTo(context, MudraComplaintAddEdit.routeName,
                    clearAllStack: true);
              },
              label: Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
              backgroundColor: colorPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> MoveTofollowupHistoryPage(String inquiryNo) {
    navigateTo(context, MudraComplaintHistoryScreen.routeName,
            arguments: MudraComplaintHistoryScreenArguments(inquiryNo))
        .then((value) {});
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        showcustomdialogWithOnlyName(
            values: arr_ALL_Name_ID_For_LeadStatus,
            context1: context,
            controller: edt_LeadStatus,
            lable: "Select Lead Status");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Select Status",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
            Icon(
              Icons.filter_list_alt,
              color: colorPrimary,
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
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
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
                      controller: edt_LeadStatus,
                      enabled: false,
                      /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
                      style: TextStyle(
                          color: Colors.black, // <-- Change this
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
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
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  LeadStatus() {
    arr_ALL_Name_ID_For_LeadStatus.clear();
    for (var i = 0; i < 8; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "ALL Leads";
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
      arr_ALL_Name_ID_For_LeadStatus.add(all_name_id);
    }
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    MudraComplaintListResponseDetails model = _listResponse.details[index];

    return Container(
        padding: EdgeInsets.all(15),
        child: ExpansionTileCard(
          // key:Key(index.toString()),
          initialElevation: 5.0,
          elevation: 5.0,
          elevationCurve: Curves.easeInOut,
          shadowColor: Color(0xFF504F4F),
          baseColor: model.complaintStatus == "Open"
              ? colorWhite
              : model.complaintStatus == "Inward"
                  ? colorGray
                  : model.complaintStatus == "In-Process"
                      ? colorGreenLight
                      : model.complaintStatus == "Waiting On  Customer"
                          ? colorOrange
                          : model.complaintStatus == "Waiting On Order"
                              ? colorYellow
                              : model.complaintStatus == "Re-Open"
                                  ? Colors.blue.shade100
                                  : model.complaintStatus == "Close"
                                      ? colorGreen
                                      : Color(0xFFC1E0FA),
          expandedColor: Color(0xFFC1E0FA),
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
                                        Text("Visit Status ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(model.visitStatus,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Visibility(
                                      visible: true,
                                      child: GestureDetector(
                                        onTap: () async {
                                          //await _makePhoneCall(model.contactNo1);
                                          //await _makeSms(model.contactNo1);
                                          //  _launchURL(model.contactNo1);
                                          MoveTofollowupHistoryPage(
                                              model.pkID.toString());
                                        },
                                        child: Column(
                                          children: [
                                            Text("History ",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: colorPrimary,
                                                    fontSize: _fontSize_Label,
                                                    letterSpacing: .3)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              width: 38,
                                              height: 38,
                                              decoration: const BoxDecoration(
                                                  color: colorWhite,
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Image.asset(
                                                    HISTORY_ICON,
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
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
                                        Text("Category ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(model.complaintCategory,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
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
                                        Text("Complaint Notes ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.complaintNotes == ""
                                                ? "N/A"
                                                : model.complaintNotes,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
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
                                        Text("Ref.#",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.referenceNo == null
                                                ? "N/A"
                                                : model.referenceNo,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
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
                                        Text("Assign From",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.assignFrom == null
                                                ? "N/A"
                                                : model.assignFrom,
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
                                        Text("Assign To",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.employeeName == null
                                                ? "N/A"
                                                : model.employeeName,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              Text(
                                  model.complaintStatus == null
                                      ? "N/A"
                                      : model.complaintStatus,
                                  style: TextStyle(
                                      color: model.complaintStatus == "Open"
                                          ? colorGreenDark
                                          : colorRedDark,
                                      fontSize: _fontSize_Title,
                                      letterSpacing: .3)),
                            ],
                          ),
                          SizedBox(
                            height: sizeboxsize,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Sch.Time",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: colorPrimary,
                                      fontSize: _fontSize_Label,
                                      letterSpacing: .3)),
                              SizedBox(
                                width: 5,
                              ),
                              Text(model.timeFrom + " - " + model.timeTo,
                                  style: TextStyle(
                                      color: Color(title_color),
                                      fontSize: _fontSize_Title,
                                      letterSpacing: .3)),
                            ],
                          ),
                          SizedBox(
                            height: sizeboxsize,
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
                                        Text("Schedule Date",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.preferredDate == null
                                                ? "N/A"
                                                : model.preferredDate
                                                        .getFormattedDate(
                                                            fromFormat:
                                                                "yyyy-MM-ddTHH:mm:ss",
                                                            toFormat:
                                                                "dd-MM-yyyy") ??
                                                    "-",
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
                                        Text("Complaint Date",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.complaintDate == null
                                                ? "N/A"
                                                : model.complaintDate
                                                        .getFormattedDate(
                                                            fromFormat:
                                                                "yyyy-MM-ddTHH:mm:ss",
                                                            toFormat:
                                                                "dd-MM-yyyy") ??
                                                    "-",
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
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
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
                    height: 45,
                    margin: EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          _onTapOfEditVehicleFuel(model);
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.edit,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Update',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: colorWhite),
                            ),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                isDeleteVisible == true
                    ? Flexible(
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.only(right: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              showCommonDialogWithTwoOptions(context,
                                  "Are you sure you want to delete this record?",
                                  negativeButtonTitle: "No",
                                  positiveButtonTitle: "Yes",
                                  onTapOfPositiveButton: () {
                                Navigator.of(context).pop();
                                _mudraBloc.add(MudraComplaintDeleteEvent(
                                    MudraComplaintDeleteDeleteRequest(
                                  pkID: model.pkID,
                                  CompanyId: CompanyID,
                                )));
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.delete,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: colorWhite),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height: 15,
            )
          ],
        ));
  }

  void _onInquiryListPagination() {
    _mudraBloc.add(MudraBankVoucherListEvent(
        _pageNo + 1,
        MudraComplaintListRequest(
            pkID: "0",
            CustomerID: "0",
            ComplaintStatus:
                edt_LeadStatus.text == "ALL Leads" ? "" : edt_LeadStatus.text,
            ComplaintType: "",
            LoginUserID: LoginUserID,
            SearchKey: edt_CustomerName.text,
            PageNo: (_pageNo + 1).toString(),
            PageSize: 10.toString(),
            CompanyId: CompanyID.toString())));
  }

  Widget _buildInquiryList() {
    if (_listResponse == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
          scrollInfo,
        )) {
          _onInquiryListPagination();
          return true;
        } else {
          return false;
        }
      },
      child: ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _listResponse.details.length,
      ),
    );
  }

  void _onMudraCompaintListResponseSuccess(
      MudraBankVoucherListResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _listResponse = state.response;
      } else {
        _listResponse.details.addAll(state.response.details);
      }
      FinalTotalCount = state.response.totalCount;

      _pageNo = state.newPage;
    }
  }

  void _onTapOfEditVehicleFuel(MudraComplaintListResponseDetails model) {
    navigateTo(context, MudraComplaintAddEdit.routeName,
            arguments: MudraComplaintAddEditArguments2(model))
        .then((value) {
      _mudraBloc.add(MudraBankVoucherListEvent(
          1,
          MudraComplaintListRequest(
              pkID: "0",
              CustomerID: "0",
              ComplaintStatus:
                  edt_LeadStatus.text == "ALL Leads" ? "" : edt_LeadStatus.text,
              ComplaintType: "",
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              PageNo: 1.toString(),
              PageSize: 10.toString(),
              CompanyId: CompanyID.toString())));
    });
  }

  void _onDeleteBankVoucher(MudraCompaintDeleteResponseState state) {
    showCommonDialogWithSingleOption(context, state.response,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);

      _mudraBloc.add(MudraBankVoucherListEvent(
          1,
          MudraComplaintListRequest(
              pkID: "0",
              CustomerID: "0",
              ComplaintStatus:
                  edt_LeadStatus.text == "ALL Leads" ? "" : edt_LeadStatus.text,
              ComplaintType: "",
              LoginUserID: LoginUserID,
              SearchKey: edt_CustomerName.text,
              PageNo: 1.toString(),
              PageSize: 10.toString(),
              CompanyId: CompanyID.toString())));
    });
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }
}
