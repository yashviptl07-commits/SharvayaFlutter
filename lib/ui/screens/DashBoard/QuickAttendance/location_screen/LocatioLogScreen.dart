import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/other/all_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/other/locationList_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/locatioLog_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/location_screen/locationtracking%20_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class LocationLogListMainScreen extends BaseStatefulWidget {
  static const routeName = '/LocationLogListMainScreen';

  @override
  _LocationLogListMainScreenState createState() =>
      _LocationLogListMainScreenState();
}

class _LocationLogListMainScreenState
    extends BaseState<LocationLogListMainScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;

  DashboardLocationLogListResponse _listResponse;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";

  final TextEditingController edt_assignTo = TextEditingController();
  final TextEditingController edt_assignToId = TextEditingController();
  final TextEditingController edt_SlipDate = TextEditingController();
  final TextEditingController edt_Reverse_SlipDate = TextEditingController();
  List<ALL_Name_ID> arr_ALL_Name_ID_For_AssignTo = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int selected = 0;

  /// Flag to avoid multiple simultaneous API calls
  bool _isCallingLocationApi = false;

  // pagination state
  bool _isLoadingMore = false;
  bool _hasMore = true;

  // Optional auto-refresh timer (used only when started)
  Timer _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorAbsentfDay;

    // Load saved login & company data (synchronous helper in your project)
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    // Defensive assignments
    if (_offlineCompanyData != null &&
        _offlineCompanyData.details != null &&
        _offlineCompanyData.details.isNotEmpty) {
      CompanyID = _offlineCompanyData.details[0].pkId;
    } else {
      CompanyID = 0;
    }

    if (_offlineLoggedInData != null &&
        _offlineLoggedInData.details != null &&
        _offlineLoggedInData.details.isNotEmpty) {
      LoginUserID = _offlineLoggedInData.details[0].userID ?? "";
    } else {
      LoginUserID = "";
    }

    _mainBloc = MainBloc(baseBloc);

    // initialize date text fields
    edt_SlipDate.text =
        "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
    edt_Reverse_SlipDate.text =
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
  }

  @override
  void dispose() {
    // dispose controllers and close bloc
    edt_assignTo.dispose();
    edt_assignToId.dispose();
    edt_SlipDate.dispose();
    edt_Reverse_SlipDate.dispose();
    _cancelAutoRefreshTimer();
    try {
      _mainBloc?.close();
    } catch (e) {
      // ignore
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: true,
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          // We rely on listener for data-handling; return container UI
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          // keep builds controlled by super.build(context)
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          // Employee list response
          if (state is ALL_EmployeeNameListResponseState) {
            _onAssignToResponse(state);
          }

          // Location log list response (full result)
          if (state is LocationLogListResponseState) {
            _onLocationLogListResponseSuccess(state);
          }

          // If your bloc provides a separate pagination response state,
          // add handling here (e.g. LocationLogListPaginationResponseState).
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ALL_EmployeeNameListResponseState ||
              currentState is LocationLogListResponseState) {
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
        appBar: AppBar(
          elevation: 3,
          backgroundColor: Colors.indigo.shade700,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
          title: const Text(
            'Location Off Log Screen',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
            onPressed: () {
              navigateTo(context, LocationListMainScreen.routeName,
                  clearAllStack: true);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white, size: 28),
              onPressed: () => _callLocationAPI(),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AssignTo(
                  "Employee Selection",
                  enable1: false,
                  title: "Employee",
                  hintTextvalue: "--- Select ---",
                  controllerForLeft: edt_assignTo,
                  controllerpkID: edt_assignToId,
                  Custom_values1: arr_ALL_Name_ID_For_AssignTo,
                ),
                SlipDate(),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: _buildLocationLogList(),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget AssignTo(String ContactPerson,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(title,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
          SizedBox(height: 6),
          InkWell(
            onTap: () {
              // fetch employee list
              _mainBloc.add(ALLEmployeeNameCallEvent(
                  ALLEmployeeNameRequest(CompanyId: CompanyID.toString())));
            },
            child: Card(
              elevation: 3,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      controllerForLeft.text.isEmpty
                          ? hintTextvalue
                          : controllerForLeft.text,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    )),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAssignToResponse(ALL_EmployeeNameListResponseState state) {
    arr_ALL_Name_ID_For_AssignTo.clear();
    if (state?.all_employeeList_Response?.details != null) {
      for (var e in state.all_employeeList_Response.details) {
        arr_ALL_Name_ID_For_AssignTo
            .add(ALL_Name_ID(Name: e.employeeName, pkID: e.pkID));
      }
    }

    showcustomdialogWithIDForLocation(
      values: arr_ALL_Name_ID_For_AssignTo,
      context1: context,
      controller: edt_assignTo,
      controllerID: edt_assignToId,
      lable: "Select Employee",
      onValueSelected: () {
        _pageResetAndCall();
        _startAutoRefreshTimer();
      },
    );
  }

  /// Reset pagination and call API
  void _pageResetAndCall() {
    if (edt_assignToId.text.isEmpty || edt_Reverse_SlipDate.text.isEmpty) {
      // show a toast or snackbar if needed
      return;
    }
    _isLoadingMore = false;
    _hasMore = true;
    _isCallingLocationApi = false;
    _callLocationAPI();
  }

  void _callLocationAPI() {
    if (edt_assignToId.text.isEmpty || edt_Reverse_SlipDate.text.isEmpty) {
      return; // Prevent empty API calls
    }

    if (_isCallingLocationApi) return;
    _isCallingLocationApi = true;

    // Using the same request object as your original code
    _mainBloc.add(LocationLogListCallEvent(DashboardLocationListRequest(
      pkID: "0",
      LoginUserID: LoginUserID,
      EmployeeID: edt_assignToId.text,
      LogDate: edt_Reverse_SlipDate.text,
      CompanyId: CompanyID,
    )));

    // safety unlock in case no response
    Future.delayed(Duration(seconds: 20), () {
      _isCallingLocationApi = false;
    });
  }

  /// Start auto refresh timer (30s). It will call only if employee & date set.
  void _startAutoRefreshTimer() {
    _cancelAutoRefreshTimer();
    _autoRefreshTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (edt_assignToId.text.isNotEmpty &&
          edt_Reverse_SlipDate.text.isNotEmpty) {
        _callLocationAPI();
      }
    });
  }

  /// Cancel timer helper
  void _cancelAutoRefreshTimer() {
    if (_autoRefreshTimer != null && _autoRefreshTimer.isActive) {
      _autoRefreshTimer.cancel();
      _autoRefreshTimer = null;
    }
  }

  showcustomdialogWithIDForLocation({
    List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    TextEditingController controllerID,
    String lable,
    VoidCallback onValueSelected,
  }) async {
    TextEditingController searchController = TextEditingController();
    List<ALL_Name_ID> filteredValues = List.from(values ?? []);

    void filterSearch(String query) {
      filteredValues = (values ?? [])
          .where((item) =>
              item.Name.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    }

    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return StatefulBuilder(
          builder: (context123, setState123) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context123).size.height * 0.85),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Title
                      Text(lable,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorPrimary)),

                      SizedBox(height: 15),

                      /// Search Bar
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12)),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search...",
                              icon: Icon(Icons.search, color: Colors.grey)),
                          onChanged: (value) {
                            setState123(() {
                              filterSearch(value);
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 15),

                      /// List
                      Expanded(
                        child: filteredValues.isEmpty
                            ? Center(
                                child: Text("No records found",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14)))
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredValues.length,
                                itemBuilder: (ctx, index) {
                                  return InkWell(
                                    onTap: () {
                                      controller.text =
                                          filteredValues[index].Name;
                                      controllerID.text =
                                          filteredValues[index].pkID.toString();
                                      Navigator.of(context1).pop();
                                      if (onValueSelected != null)
                                        onValueSelected();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 6),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4,
                                                offset: Offset(0, 2)),
                                          ]),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              radius: 6,
                                              backgroundColor: colorPrimary),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                                filteredValues[index].Name,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: colorPrimary)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                      ),

                      SizedBox(height: 10),

                      /// Cancel
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () => Navigator.pop(context1),
                            child: Text("CANCEL",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget SlipDate() {
    return Container(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("Select Date",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black))),
          SizedBox(height: 6),
          InkWell(
            onTap: () => _selectSlipDate(),
            child: Card(
              elevation: 3,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      edt_SlipDate.text.isEmpty
                          ? "YYYY-MM-DD"
                          : edt_SlipDate.text,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    )),
                    Icon(Icons.calendar_today_outlined),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectSlipDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        edt_SlipDate.text = "${picked.day}-${picked.month}-${picked.year}";
        edt_Reverse_SlipDate.text =
            "${picked.year}-${picked.month}-${picked.day}";
      });

      // immediate fetch & start auto-refresh if employee already selected
      _callLocationAPI();
      if (edt_assignToId.text.isNotEmpty) {
        _startAutoRefreshTimer();
      }
    }
  }

  Future<bool> _onBackPressed() async {
    _cancelAutoRefreshTimer();
    navigateTo(context, LocationListMainScreen.routeName, clearAllStack: true);
    return false;
  }

  Widget _buildLocationLogList() {
    if (_listResponse == null) {
      // show a friendly placeholder
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
              "Please select Employee & Date then tap 'See Users' to load logs.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700])),
        ),
      );
    }

    if (_listResponse.details == null || _listResponse.details.isEmpty) {
      return Center(child: Text("No logs found for selected date/employee."));
    }

    return RefreshIndicator(
      onRefresh: () async {
        // refresh current data
        _pageResetAndCall();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (shouldPaginate(scrollInfo) && !_isLoadingMore && _hasMore) {
            _onInquiryListPagination();
            return true;
          } else {
            return false;
          }
        },
        child: ListView.builder(
          key: Key('selected $selected'),
          padding: EdgeInsets.symmetric(vertical: 8),
          shrinkWrap: true,
          itemCount: _listResponse.details.length + (_isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _listResponse.details.length) {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()));
            }
            return _buildInquiryListItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    DashboardLocationLogListResponseDetails model =
        _listResponse.details[index];

    // Safe display values
    final message = model.message ?? "-";
    final deviceName = model.deviceName ?? "-";
    final dateTimeStr = model.logDateTime ?? "";

    String formattedDate = dateTimeStr;
    try {
      formattedDate = dateTimeStr.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy hh:mm:ss");
    } catch (e) {
      // fallback to raw string
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Card(
          elevation: 5,
          color: Colors.grey[200],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (message.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(left: 6, top: 4, bottom: 4),
                    child: Text(message,
                        style: TextStyle(color: colorBlack, fontSize: 15))),
              if (deviceName.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(left: 6, top: 4, bottom: 4),
                    child: Text(deviceName,
                        style: TextStyle(color: colorBlack, fontSize: 15))),
              Padding(
                  padding: const EdgeInsets.only(left: 6, top: 4, bottom: 4),
                  child: Text(formattedDate,
                      style: TextStyle(color: colorBlack, fontSize: 14))),
            ]),
          ),
        ));
  }

  void _onLocationLogListResponseSuccess(LocationLogListResponseState state) {
    // Replace dataset (first page)
    setState(() {
      _listResponse = state.all_employeeList_Response;
      _isLoadingMore = false;
      _hasMore = _listResponse != null &&
          _listResponse.details != null &&
          _listResponse.details.isNotEmpty;
    });
    // free call lock
    _isCallingLocationApi = false;
  }

  void _onInquiryListPagination() {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    // If your server requires page numbers, modify DashboardLocationListRequest to include PageNo.
    _mainBloc.add(LocationLogListCallEvent(DashboardLocationListRequest(
        pkID: "0",
        LoginUserID: LoginUserID,
        EmployeeID: edt_assignToId.text,
        LogDate: edt_Reverse_SlipDate.text,
        CompanyId: CompanyID)));
  }
}
