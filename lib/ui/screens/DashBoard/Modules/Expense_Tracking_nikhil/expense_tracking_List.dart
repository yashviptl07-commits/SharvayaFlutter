import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/Expense_Tracking_nikhil/expense_tracking_list_requests.dart';
import 'package:soleoserp/models/api_requests/other/all_employee_list_request.dart';
import 'package:soleoserp/models/api_responses/Expense_Tracking_nikhil/expense_tracking_list_responses.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/all_employee_List_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Expense_Tracking_nikhil/expense_tracking_Add.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExpenseTrackingListScreen extends BaseStatefulWidget {
  static const routeName = '/ExpenseTrackingListScreen';

  @override
  _ExpenseTrackingListScreenState createState() =>
      _ExpenseTrackingListScreenState();
}

class _ExpenseTrackingListScreenState
    extends BaseState<ExpenseTrackingListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  ExpenseTrackingListResponse _listResponse;
  List<ExpenseTrackingListDetails> _expenseList = [];
  int _pageNo = 1;
  bool isSearching = false;

  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  bool isAdmin = false;

  final TextEditingController edt_assignTo = TextEditingController();
  final TextEditingController edt_assignToId = TextEditingController();
  final TextEditingController edt_SlipDate = TextEditingController();
  final TextEditingController edt_Reverse_SlipDate = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_AssignTo = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    isAdmin = viewvisiblitiyAsperClient(
      SerailsKey: _offlineLoggedInData.details[0].serialKey,
      RoleCode: _offlineLoggedInData.details[0].roleCode,
    );

    _mainBloc = MainBloc(baseBloc);

    edt_SlipDate.text =
        "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
    edt_Reverse_SlipDate.text =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    if (!isAdmin) {
      edt_assignToId.text = LoginUserID;
      edt_assignTo.text = _offlineLoggedInData.details[0].employeeName;
    }

    if (isAdmin) {
      edt_assignToId.text =
          _offlineLoggedInData.details[0].employeeID.toString();
      edt_assignTo.text = _offlineLoggedInData.details[0].employeeName;
    }

    _callExpenseTrackingListApi();
  }

  @override
  void dispose() {
    edt_assignTo.dispose();
    edt_assignToId.dispose();
    edt_SlipDate.dispose();
    edt_Reverse_SlipDate.dispose();
    _mainBloc?.close();
    super.dispose();
  }

  void _callExpenseTrackingListApi() {
    if (edt_assignToId.text.isEmpty && isAdmin) {}

    ExpenseTrackingListRequest request = ExpenseTrackingListRequest(
      CompanyID: CompanyID.toString(),
      EmployeeID: edt_assignToId.text,
      FromDate: edt_Reverse_SlipDate.text,
      ToDate: edt_Reverse_SlipDate.text,
      PageNo: _pageNo.toString(),
      PageSize: "1000",
      LoginUserID: LoginUserID,
    );

    _mainBloc.add(ExpenseTrackingListCallEvent(request));
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
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is ExpenseTrackingListResponseState) {
            _onExpenseTrackingListSuccess(state);
          }
          if (state is ALL_EmployeeNameListResponseState) {
            _onEmployeeListSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ExpenseTrackingListResponseState ||
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
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: NewGradientAppBar(
        title: Text('Expense Tracking'),
        gradient: LinearGradient(colors: [
          Color(0xff108dcf),
          Color(0xff0066b3),
          Color(0xff108dcf),
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
              ),
              onPressed: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateTo(context, ExpenseTrackingAddScreen.routeName).then((value) {
            _pageNo = 1;
            _callExpenseTrackingListApi();
          });
        },
        child: const Icon(Icons.play_arrow),
        backgroundColor: colorPrimary,
        tooltip: "Start Trip",
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _buildFilters(),
            SizedBox(height: 10),
            Expanded(child: _buildExpenseList()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        children: [
          if (isAdmin)
            _buildAssignTo(
              "Employee",
              edt_assignTo,
              edt_assignToId,
              arr_ALL_Name_ID_For_AssignTo,
              "Select Employee",
            ),
          if (isAdmin) SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Date",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
                SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    _selectDate(context);
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
                          Icon(Icons.calendar_today,
                              size: 18, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text(
                            edt_SlipDate.text,
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAssignTo(
      String title,
      TextEditingController controllerText,
      TextEditingController controllerId,
      List<ALL_Name_ID> valuesList,
      String hintText) {
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
          SizedBox(height: 4),
          InkWell(
            onTap: () {
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
                      controllerText.text.isEmpty
                          ? hintText
                          : controllerText.text,
                      style: TextStyle(
                          color: controllerText.text.isEmpty
                              ? Colors.grey
                              : Colors.black,
                          fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onExpenseTrackingListSuccess(ExpenseTrackingListResponseState state) {
    setState(() {
      if (_pageNo == 1) {
        _expenseList.clear();
      }
      if (state.expenseTrackingListResponse != null &&
          state.expenseTrackingListResponse.details != null) {
        _expenseList.addAll(state.expenseTrackingListResponse.details);
      }
    });
  }

  void _onEmployeeListSuccess(ALL_EmployeeNameListResponseState state) {
    arr_ALL_Name_ID_For_AssignTo.clear();
    ALL_EmployeeList_Response response = state.all_employeeList_Response;
    if (response != null && response.details != null) {
      for (int i = 0; i < response.details.length; i++) {
        arr_ALL_Name_ID_For_AssignTo.add(ALL_Name_ID(
          Name: response.details[i].employeeName,
          Name1: response.details[i].pkID.toString(),
          isChecked: false,
        ));
      }
      _showEmployeeDialog();
    }
  }

  void _showEmployeeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Employee"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: arr_ALL_Name_ID_For_AssignTo.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(arr_ALL_Name_ID_For_AssignTo[index].Name),
                  onTap: () {
                    setState(() {
                      edt_assignTo.text =
                          arr_ALL_Name_ID_For_AssignTo[index].Name;
                      edt_assignToId.text =
                          arr_ALL_Name_ID_For_AssignTo[index].Name1;
                    });
                    Navigator.pop(context);
                    _pageNo = 1;
                    _callExpenseTrackingListApi();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        edt_SlipDate.text =
            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
        edt_Reverse_SlipDate.text =
            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
      });
      _pageNo = 1;
      _callExpenseTrackingListApi();
    }
  }

  Widget _buildExpenseList() {
    if (_expenseList.isEmpty) {
      return Center(
        child: Text("No trips found.",
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      );
    }

    return ListView.builder(
      itemCount: _expenseList.length,
      itemBuilder: (context, index) {
        return _buildExpenseCard(_expenseList[index]);
      },
    );
  }

  Widget _buildExpenseCard(ExpenseTrackingListDetails detail) {
    String vType = _parseVehicleTypeFromTripID(detail.tripID);
    return InkWell(
      onTap: () {
        _openMapPopup(context, detail);
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text("Trip ID: ${detail.tripID}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorPrimary,
                            fontSize: 15)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(vType,
                        style: TextStyle(
                            color: Colors.green.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.green),
                  SizedBox(width: 6),
                  Expanded(
                      child: Text(
                          "Start: ${detail.startLatitude}, ${detail.startLongitude}",
                          style: TextStyle(fontSize: 13))),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.flag, size: 16, color: Colors.red),
                  SizedBox(width: 6),
                  Expanded(
                      child: Text(
                          "End: ${detail.endLatitude}, ${detail.endLongitude}",
                          style: TextStyle(fontSize: 13))),
                ],
              ),
              Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Distance: ${detail.totalDistanceKm} Km",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text("Time: ${_formatTime(detail.startTime)}",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String rawTime) {
    if (rawTime == null || rawTime.isEmpty) return "";
    try {
      DateTime dt = DateTime.parse(rawTime);
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return rawTime;
    }
  }

  String _parseVehicleTypeFromTripID(String tripID) {
    if (tripID == null || tripID.isEmpty) return "N/A";
    List<String> parts = tripID.split('_');
    if (parts.isNotEmpty) {
      String lastPart = parts.last.toUpperCase();
      if (lastPart == '2W' || lastPart == '4W') {
        return lastPart;
      }
    }
    return "N/A";
  }

  void _openMapPopup(BuildContext context, ExpenseTrackingListDetails detail) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return TripMapPopup(
          tripDetail: detail,
          companyId: CompanyID,
          loginUserId: LoginUserID,
        );
      },
    );
  }
}

class TripMapPopup extends StatefulWidget {
  final ExpenseTrackingListDetails tripDetail;
  final int companyId;
  final String loginUserId;

  TripMapPopup({this.tripDetail, this.companyId, this.loginUserId});

  @override
  _TripMapPopupState createState() => _TripMapPopupState();
}

class _TripMapPopupState extends State<TripMapPopup> {
  bool _isLoading = true;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildMarkersFromTripDetail();
    });
  }

  void _buildMarkersFromTripDetail() {
    Set<Marker> newMarkers = {};
    List<LatLng> polylineCoordinates = [];

    double startLat =
        double.tryParse(widget.tripDetail.startLatitude ?? "0") ?? 0.0;
    double startLng =
        double.tryParse(widget.tripDetail.startLongitude ?? "0") ?? 0.0;
    double endLat =
        double.tryParse(widget.tripDetail.endLatitude ?? "0") ?? 0.0;
    double endLng =
        double.tryParse(widget.tripDetail.endLongitude ?? "0") ?? 0.0;

    bool hasStart = startLat != 0.0 || startLng != 0.0;
    bool hasEnd = endLat != 0.0 || endLng != 0.0;

    if (hasStart) {
      LatLng startPos = LatLng(startLat, startLng);
      polylineCoordinates.add(startPos);
      newMarkers.add(Marker(
        markerId: MarkerId("trip_start"),
        position: startPos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: "Start Point",
          snippet: "Time: ${widget.tripDetail.startTime}",
        ),
      ));
    }

    if (hasEnd) {
      LatLng endPos = LatLng(endLat, endLng);
      polylineCoordinates.add(endPos);
      newMarkers.add(Marker(
        markerId: MarkerId("trip_end"),
        position: endPos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: "End Point",
          snippet: "Time: ${widget.tripDetail.endTime}",
        ),
      ));
    }

    Set<Polyline> newPolylines = {};
    if (polylineCoordinates.length >= 2) {
      newPolylines.add(Polyline(
        polylineId: PolylineId("trip_route"),
        color: Colors.blue,
        width: 4,
        points: polylineCoordinates,
      ));
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
        _polylines = newPolylines;
        _isLoading = false;
      });
      _moveCamera(polylineCoordinates);
    }
  }

  void _moveCamera(List<LatLng> points) async {
    if (points.isEmpty) return;

    try {
      final GoogleMapController controller = await _mapController.future;
      if (points.length == 1) {
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: points.first, zoom: 15),
        ));
      } else {
        double minLat = points.first.latitude;
        double maxLat = points.first.latitude;
        double minLng = points.first.longitude;
        double maxLng = points.first.longitude;

        for (var p in points) {
          if (p.latitude < minLat) minLat = p.latitude;
          if (p.latitude > maxLat) maxLat = p.latitude;
          if (p.longitude < minLng) minLng = p.longitude;
          if (p.longitude > maxLng) maxLng = p.longitude;
        }

        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        );

        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.all(16),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade700,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Trip Route",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Colors.white),
                  )
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(23.092458, 72.555963),
                      zoom: 10,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                    onMapCreated: (GoogleMapController controller) {
                      if (!_mapController.isCompleted) {
                        _mapController.complete(controller);
                      }
                    },
                    myLocationEnabled: false,
                    zoomControlsEnabled: true,
                  ),
                  if (_isLoading) Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
