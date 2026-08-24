import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/blocs/other/bloc_modules/attend_visit/attend_visit_bloc.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_no_list_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_source_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/transection_mode_list_request.dart';
import 'package:soleoserp/models/api_responses/attendVisit/attend_visit_list_response.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/models/hema_automation/api_request/quick_complaint/quick_complaint_save_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/hema_auto_attend_visit/hema_attend_visit_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/other_screens/dropdownscreen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_filds.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;

class QuickAddUpdateComplaintScreenArguments {
  AttendVisitDetails editModel;
  List<File> documentList;

  QuickAddUpdateComplaintScreenArguments(this.editModel, this.documentList);
}

class HemaAttendVisitAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/HemaAttendVisitAddEditScreen';
  final QuickAddUpdateComplaintScreenArguments arguments;

  HemaAttendVisitAddEditScreen(this.arguments);

  @override
  BaseState<HemaAttendVisitAddEditScreen> createState() =>
      _HemaAttendVisitAddEditScreenState();
}

class _HemaAttendVisitAddEditScreenState
    extends BaseState<HemaAttendVisitAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  AttendVisitBloc _complaintScreenBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  final List<String> _types = ['Free', 'Charged'];
  bool isTapLiveLocation = false;
  List<ALL_Name_ID> fileListName = [];
  List<File> MultipleVideoList = [];
  final imagepicker = ImagePicker();
  bool permissionGranted;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController edt_FollowUpDate = TextEditingController();
  final TextEditingController edt_ReverseFollowUpDate = TextEditingController();
  final TextEditingController edt_NextFollowupDate = TextEditingController();
  final TextEditingController edt_ReverseNextFollowupDate =
      TextEditingController();
  final TextEditingController edt_ComplaintNo = TextEditingController();
  final TextEditingController edt_Complaint_NoID = TextEditingController();
  final TextEditingController edt_satus = TextEditingController();
  final TextEditingController edt_satusID = TextEditingController();
  final TextEditingController edt_Type = TextEditingController();
  final TextEditingController edt_ComplaintNotes = TextEditingController();
  final TextEditingController edt_VisitNotes = TextEditingController();
  final TextEditingController edt_TransectionName = TextEditingController();
  final TextEditingController edt_TransectionID = TextEditingController();
  final TextEditingController edt_Amount = TextEditingController();
  final TextEditingController edt_CustomerID = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadSource = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Charge_Type = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TransectionMode = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ComplaintNoList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Customer = [];

  bool IsCharged = false;
  bool _isForUpdate = false;
  bool isvisible_Out_time = false;
  String Address_In = "";
  String Latitude_In = "";
  String Longitude_In = "";
  String Time_In = "";
  String Address_Out = "";
  String Latitude_Out = "";
  String Longitude_Out = "";
  String Time_Out = "";
  bool isPunchInHide = false;
  bool isPunchOutHide = false;
  AttendVisitDetails _editModel;
  int savepkID = 0;

  bool is_LocationService_Permission;
  Location location = new Location();

  final TextEditingController edt_FromTime = TextEditingController();
  final TextEditingController edt_ToTime = TextEditingController();

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _complaintScreenBloc = AttendVisitBloc(baseBloc);

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
      print("Update");
    } else {
      print("Add");
      edt_Type.text = "Free";

      selectedDate = DateTime.now();
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
      edt_NextFollowupDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_ReverseNextFollowupDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      setState(() {});
    }

    TimeOfDay selectedTime1234 = TimeOfDay.now();
    String AM_PM123 =
        selectedTime1234.periodOffset.toString() == "12" ? "PM" : "AM";
    String beforZeroHour123 = selectedTime1234.hourOfPeriod <= 9
        ? "0" + selectedTime1234.hourOfPeriod.toString()
        : selectedTime1234.hourOfPeriod.toString();
    String beforZerominute123 = selectedTime1234.minute <= 9
        ? "0" + selectedTime1234.minute.toString()
        : selectedTime1234.minute.toString();
    edt_FromTime.text =
        beforZeroHour123 + ":" + beforZerominute123 + " " + AM_PM123;

    TimeOfDay selectedToTime =
        TimeOfDay.fromDateTime(DateTime.now().add(Duration(hours: 1)));
    String AM_PMToTime =
        selectedToTime.periodOffset.toString() == "12" ? "PM" : "AM";
    String beforZeroHourToTime = selectedToTime.hourOfPeriod <= 9
        ? "0" + selectedToTime.hourOfPeriod.toString()
        : selectedToTime.hourOfPeriod.toString();
    String beforZerominuteToTime = selectedToTime.minute <= 9
        ? "0" + selectedToTime.minute.toString()
        : selectedToTime.minute.toString();
    edt_ToTime.text =
        beforZeroHourToTime + ":" + beforZerominuteToTime + " " + AM_PMToTime;

    edt_Type.addListener(() {
      if (edt_Type.text == "Charged") {
        IsCharged = true;
      } else {
        IsCharged = false;
      }

      setState(() {});
    });
  }

  void fillData() {
    savepkID = _editModel.pkID.toInt();

    edt_FollowUpDate.text = _editModel.visitDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_ReverseFollowUpDate.text = _editModel.visitDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_NextFollowupDate.text = _editModel.nextVisitDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_ReverseNextFollowupDate.text = _editModel.nextVisitDate
        .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_ComplaintNo.text = _editModel.complaintNo;
    edt_Complaint_NoID.text = _editModel.visitID.toString();
    edt_Type.text = _editModel.visitType;
    edt_ComplaintNotes.text = _editModel.complaintNotes;
    edt_VisitNotes.text = _editModel.visitNotes;
    edt_TransectionName.text = _editModel.visitChargeType;
    edt_Amount.text = _editModel.visitCharge.toStringAsFixed(2);
    edt_CustomerID.text = _editModel.customerID.toString();
    edt_CustomerName.text = _editModel.customerName;
    edt_ToTime.text = _editModel.timeTo;
    edt_FromTime.text = _editModel.timeFrom;

    edt_ComplaintNo.text = _editModel.complaintNo.toString();
    edt_satus.text = _editModel.complaintStatus;

    edt_VisitNotes.text = _editModel.visitNotes;
    Address_In = _editModel.locationAddressIN;
    Latitude_In = _editModel.latitudeIN;
    Longitude_In = _editModel.longitudeIN;
    Time_In = _editModel.timeIn;
    Address_Out = _editModel.locationAddressOUT;
    Latitude_Out = _editModel.latitudeOUT;
    Longitude_Out = _editModel.longitudeOUT;
    Time_Out = _editModel.timeOut;

    if (widget.arguments.documentList.isNotEmpty) {
      MultipleVideoList.clear();
      for (int i = 0; i < widget.arguments.documentList.length; i++) {
        MultipleVideoList.add(widget.arguments.documentList[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _complaintScreenBloc,
      child: BlocConsumer<AttendVisitBloc, AttendVisitStates>(
        builder: (BuildContext context, AttendVisitStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, AttendVisitStates state) {
          if (state is CustomerSourceCallEventResponseState) {
            _onLeadSourceListTypeCallSuccess(state);
          }

          if (state is TransectionModeResponseState) {
            _OnTransectionModeSucess(state);
          }
          if (state is ComplaintNoListCallResponseState) {
            _OnComplaintNoListResponseSucess(state);
          }
          if (state is FollowupCustomerListByNameCallResponseState) {
            _OnCustomerListResponseSuccess(state);
          }
          if (state is QuickComplaintSaveResponseState) {
            _OnVisitSaveSucess(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is AttendVisitDeleteResponseState ||
              currentState is CustomerSourceCallEventResponseState ||
              currentState is TransectionModeResponseState ||
              currentState is ComplaintNoListCallResponseState ||
              currentState is FollowupCustomerListByNameCallResponseState ||
              currentState is QuickComplaintSaveResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double deviceWidth = screenSize.width;
    double smallFontSize = deviceWidth * 0.04;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text('Attend Visit Details'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: colorWhite,
              ),
              onPressed: () {
                navigateTo(context, HemaAttendVisitListScreen.routeName,
                    clearAllStack: true);
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () {
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () async {
                            if (Time_In == "" && Address_In == "") {
                              Time_In = selectedTime.hour.toString() +
                                  ":" +
                                  selectedTime.minute.toString();
                              getLocationLivePermission456();
                              isPunchInHide = true;
                            } else {
                              isPunchInHide = false;
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Card(
                                  elevation: 5,
                                  color: Time_In == "" || Address_In == ""
                                      ? colorRed
                                      : colorGreen,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Container(
                                    height: 40,
                                    width: 140,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Punch In ",
                                              style: TextStyle(
                                                  color: colorWhite,
                                                  // <-- Change this
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _isForUpdate == true
                          ? Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  if (Address_Out == "") {
                                    if (Time_In != "" &&
                                        Address_In != "" &&
                                        edt_CustomerName.text != "") {
                                      Time_Out = selectedTime.hour.toString() +
                                          ":" +
                                          selectedTime.minute.toString();
                                      getLocationLivePermissionOut();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        duration: const Duration(seconds: 2),
                                        content: Text(
                                            "Punch-In & Audit Activity Is Not Complete "),
                                      ));
                                    }
                                    isPunchOutHide = true;
                                  } else {
                                    isPunchOutHide = false;
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Card(
                                        elevation: 5,
                                        color:
                                            Time_Out == "" || Address_Out == ""
                                                ? colorRed
                                                : colorGreen,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          height: 40,
                                          width: 140,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Punch Out",
                                                    style: TextStyle(
                                                        color: colorWhite,
                                                        // <-- Change this
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  buildDatePickerField(
                    label: "Visit Date *",
                    controller: edt_FollowUpDate,
                    revController: edt_ReverseFollowUpDate,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Visit Timing *",
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      buildTimeBox(
                        context: context,
                        controller: edt_FromTime,
                        onTap: () => _selectFromTime(context, edt_FromTime),
                      ),
                      SizedBox(width: 5),
                      buildTimeBox(
                        context: context,
                        controller: edt_ToTime,
                        onTap: () => _selectToTime(context, edt_ToTime),
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  buildCommonDropDown(
                    label: "Customer *",
                    context: context,
                    hintText: "--- Select ---",
                    nameController: edt_CustomerName,
                    idController: edt_CustomerID,
                    CommonList: arr_ALL_Name_ID_For_Customer,
                    customSetState: setState,
                    onTap: () {
                      _complaintScreenBloc.add(
                          SearchFollowupCustomerListByNameCallEvent(
                              CustomerLabelValueRequest(
                                  word: "",
                                  CompanyId: CompanyID.toString(),
                                  LoginUserID: LoginUserID)));
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  buildCommonDropDown(
                    label: "Complaint *",
                    context: context,
                    hintText: "--- Select ---",
                    nameController: edt_ComplaintNo,
                    idController: edt_Complaint_NoID,
                    CommonList: arr_ALL_Name_ID_For_ComplaintNoList,
                    customSetState: setState,
                    onTap: () {
                      if (edt_CustomerName.text != "") {
                        _complaintScreenBloc.add(ComplaintNoListCallEvent(
                            ComplaintNoListRequest(
                                CustomerID: edt_CustomerID.text,
                                CompanyId: CompanyID.toString())));
                      } else {
                        showCustomSnackBar(
                          context,
                          message: "Customer selection is required !!",
                          iconColor: Colors.green,
                          backgroundColor: Colors.grey.shade200,
                          fontSize: 16.0,
                        );
                      }
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  buildTextFieldForLargeBox(
                    label: "Complaint Notes",
                    hintText: "Complaint Notes",
                    context: context,
                    controller: edt_ComplaintNotes,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the product application";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  buildCommonDropDown(
                    label: "Status *",
                    context: context,
                    hintText: "--- Select ---",
                    nameController: edt_satus,
                    idController: edt_satusID,
                    CommonList: arr_ALL_Name_ID_For_LeadSource,
                    customSetState: setState,
                    onTap: () {
                      _complaintScreenBloc.add(CustomerSourceCallEvent(
                          CustomerSourceRequest(
                              pkID: "0",
                              StatusCategory: "ComplaintStatus",
                              companyId: CompanyID,
                              LoginUserID: LoginUserID,
                              SearchKey: "")));
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  buildDropdownField(
                    context: context,
                    label: "Visit Type",
                    items: _types,
                    onChanged: (value) {
                      setState(() {
                        edt_Type.text = value;
                      });
                    },
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  buildTextFieldForLargeBox(
                    label: "Visit Notes *",
                    hintText: "Enter Notes",
                    context: context,
                    controller: edt_VisitNotes,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the visit notes";
                      }
                      return null;
                    },
                  ),
                  Visibility(
                    visible: edt_Type.text == "Charged",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenSize.height * 0.02),
                        buildCommonDropDown(
                          label: "Charge Type *",
                          context: context,
                          hintText: "--- Select ---",
                          nameController: edt_TransectionName,
                          idController: edt_TransectionID,
                          CommonList: arr_ALL_Name_ID_For_TransectionMode,
                          customSetState: setState,
                          onTap: () {
                            _complaintScreenBloc.add(TransectionModeCallEvent(
                                TransectionModeListRequest(
                                    CompanyID: CompanyID.toString())));
                          },
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        buildTextFieldForDecimal(
                          label: "Visit Charge *",
                          hintText: "Enter Visit Charge",
                          context: context,
                          controller: edt_Amount,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter the visit charges";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Time_In != "" &&
                          Address_In != "" &&
                          edt_CustomerName.text != "" &&
                          _isForUpdate == true
                      ? Column(
                          children: [
                            buildDatePickerField(
                              label: "Next Visit Date *",
                              controller: edt_NextFollowupDate,
                              revController: edt_ReverseNextFollowupDate,
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                          ],
                        )
                      : Container(),
                  Attachments(),
                  SizedBox(height: screenSize.height * 0.03),
                  buildCommonButton(
                      context: context,
                      text: _isForUpdate == true ? "Update" : "Add",
                      onPressed: _onTapOfSaveAPICall),
                  SizedBox(height: screenSize.height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTapOfSaveAPICall() async {
    if (Address_In != "") {
      if (_formKey.currentState.validate()) {
        showCommonDialogWithTwoOptions(
            context, "Are You Sure You Want To Save This Record ?",
            negativeButtonTitle: "No",
            positiveButtonTitle: "Yes", onTapOfPositiveButton: () async {
          Navigator.of(context).pop();

          List<File> tempMultipleVideoList = [];

          if (MultipleVideoList.length != 0) {
            for (int i = 0; i < MultipleVideoList.length; i++) {
              final extension = p.extension(MultipleVideoList[i].path);
              if (extension.toString() == ".jpg" ||
                  extension.toString() == ".jpeg") {
                final dir = await getTemporaryDirectory();
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
                final dir = await getTemporaryDirectory();
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

          _complaintScreenBloc.add(QuickComplaintSaveRequestCallEvent(
              savepkID,
              tempMultipleVideoList,
              QuickComplaintSaveRequest(
                pkID: savepkID.toString(),
                ComplaintNo: edt_Complaint_NoID.text,
                CustomerID: edt_CustomerID.text,
                VisitDate: edt_ReverseFollowUpDate.text,
                TimeFrom: edt_FromTime.text,
                TimeTo: edt_ToTime.text,
                VisitNotes: edt_VisitNotes.text,
                VisitType: edt_Type.text == null ? "" : edt_Type.text,
                VisitChargeType: edt_TransectionName.text,
                VisitCharge: edt_Amount.text == "" ? "0.00" : edt_Amount.text,
                ComplaintStatus: edt_satus.text,
                TimeIn: Time_In == "00:00:00" ? "" : Time_In,
                TimeOut: Time_Out == "00:00:00" ? "" : Time_Out,
                Latitude_IN: Latitude_In,
                Longitude_IN: Longitude_In,
                Latitude_OUT: Latitude_Out,
                Longitude_OUT: Longitude_Out,
                LocationAddress_IN: Address_In,
                LocationAddress_OUT: Address_Out,
                NextVisitDate: edt_ReverseNextFollowupDate.text,
                LoginUserID: LoginUserID,
                CompanyId: CompanyID.toString(),
              )));
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: const Duration(seconds: 1),
        content: Text("Punch In Is Required"),
      ));
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

  Widget buildDatePickerField({
    String label,
    TextEditingController controller,
    TextEditingController revController,
    String hintText = "YYYY-MM-DD",
    IconData icon = Icons.calendar_today_outlined,
  }) {
    Size screenSize = MediaQuery.of(context).size;
    double deviceWidth = screenSize.width;
    double smallFontSize = deviceWidth * 0.04;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01),
          child: Text(
            label,
            style: TextStyle(
              fontSize: smallFontSize,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade100,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => _selectDate(context, controller, revController),
            child: Container(
              height: deviceWidth * 0.15,
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.text.isEmpty ? hintText : controller.text,
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(icon, color: Colors.black),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
      BuildContext context,
      TextEditingController controller,
      TextEditingController revController) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}-${picked.month}-${picked.year}";
        revController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  void _onLeadSourceListTypeCallSuccess(
      CustomerSourceCallEventResponseState state) {
    if (state.sourceResponse.details.length != 0) {
      arr_ALL_Name_ID_For_LeadSource.clear();
      if (state.sourceResponse.details.isNotEmpty) {
        for (var i = 0; i < state.sourceResponse.details.length; i++) {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name = state.sourceResponse.details[i].inquiryStatus;
          all_name_id.pkID = state.sourceResponse.details[i].pkID;
          arr_ALL_Name_ID_For_LeadSource.add(all_name_id);
        }

        if (arr_ALL_Name_ID_For_LeadSource.length != 0) {
          navigateTo(context, VehicleListDropDownScreen.routeName,
                  arguments: VehicleListDropDownScreenArgument(
                      arr_ALL_Name_ID_For_LeadSource,
                      "Status List",
                      "Three Chars To Search Status",
                      "Tap To Enter Status"))
              .then((value) {
            if (value.toString() == "clear") {
              edt_satus.text = "";
              edt_satusID.text = "0";
            } else {
              ALL_Name_ID model = value;
              edt_satus.text = model.Name;
              edt_satusID.text = model.pkID.toString();
            }

            setState(() {});
          });
        }
      }
    }
  }

  void _OnTransectionModeSucess(TransectionModeResponseState state) {
    if (state.transectionModeListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_TransectionMode.clear();
      if (state.transectionModeListResponse.details.isNotEmpty) {
        for (var i = 0;
            i < state.transectionModeListResponse.details.length;
            i++) {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name =
              state.transectionModeListResponse.details[i].walletName;
          all_name_id.pkID = state.transectionModeListResponse.details[i].pkID;
          arr_ALL_Name_ID_For_TransectionMode.add(all_name_id);
        }

        if (arr_ALL_Name_ID_For_TransectionMode.length != 0) {
          navigateTo(context, VehicleListDropDownScreen.routeName,
                  arguments: VehicleListDropDownScreenArgument(
                      arr_ALL_Name_ID_For_TransectionMode,
                      "Charge Type List",
                      "Three Chars To Search Charge Type",
                      "Tap To Enter Charge Type"))
              .then((value) {
            if (value.toString() == "clear") {
              edt_TransectionName.text = "";
              edt_TransectionID.text = "0";
            } else {
              ALL_Name_ID model = value;
              edt_TransectionName.text = model.Name.toString();
              edt_TransectionID.text = model.pkID.toString();
            }

            setState(() {});
          });
        }
      }
    }
  }

  void _OnCustomerListResponseSuccess(
      FollowupCustomerListByNameCallResponseState state) {
    arr_ALL_Name_ID_For_Customer.clear();
    if (state.response.details.isNotEmpty) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].label;
        all_name_id.pkID = state.response.details[i].value;
        arr_ALL_Name_ID_For_Customer.add(all_name_id);
      }

      if (arr_ALL_Name_ID_For_Customer.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_Customer,
                    "Customer List",
                    "Three Chars To Search Customer",
                    "Tap To Enter Customer"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_CustomerName.text = "";
            edt_CustomerID.text = "0";
          } else {
            ALL_Name_ID model = value;
            edt_CustomerName.text = model.Name.toString();
            edt_CustomerID.text = model.pkID.toString();
          }

          setState(() {});
        });
      }
    }
  }

  void _OnComplaintNoListResponseSucess(
      ComplaintNoListCallResponseState state) {
    arr_ALL_Name_ID_For_ComplaintNoList.clear();
    if (state.response.details.isNotEmpty) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].complaintNo;
        all_name_id.pkID = state.response.details[i].visitID;
        arr_ALL_Name_ID_For_ComplaintNoList.add(all_name_id);
      }

      if (arr_ALL_Name_ID_For_ComplaintNoList.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_ComplaintNoList,
                    "Complaint List",
                    "Three Chars To Search Complaint",
                    "Tap To Enter Complaint"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_ComplaintNo.text = "";
            edt_Complaint_NoID.text = "0";
          } else {
            ALL_Name_ID model = value;
            edt_ComplaintNo.text = model.Name.toString();
            edt_Complaint_NoID.text = model.pkID.toString();
          }

          setState(() {});
        });
      }
    }
  }

  void checkPermissionStatus() async {
    bool granted = await Permission.location.isGranted;
    bool Denied = await Permission.location.isDenied;
    bool PermanentlyDenied = await Permission.location.isPermanentlyDenied;

    print("PermissionStatus" +
        "Granted : " +
        granted.toString() +
        " Denied : " +
        Denied.toString() +
        " PermanentlyDenied : " +
        PermanentlyDenied.toString());

    if (Denied == true) {
      is_LocationService_Permission = false;
      await Permission.storage.request();
    }
    if (await Permission.location.isRestricted) {
      openAppSettings();
    }
    if (PermanentlyDenied == true) {
      is_LocationService_Permission = false;
      openAppSettings();
    }
    if (granted == true) {
      is_LocationService_Permission = true;
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HemaAttendVisitListScreen.routeName,
        clearAllStack: true);
  }

  void _OnVisitSaveSucess(QuickComplaintSaveResponseState state) {
    showCommonDialogWithSingleOption(
        Globals.context, state.response.details[0].column2,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, HemaAttendVisitListScreen.routeName,
          clearAllStack: true);
    });
  }

  Future<void> _selectFromTime(
      BuildContext context, TextEditingController F_datecontroller) async {
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

        String AM_PM =
            selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
        String beforZeroHour = selectedTime.hourOfPeriod <= 9
            ? "0" + selectedTime.hourOfPeriod.toString()
            : selectedTime.hourOfPeriod.toString();
        String beforZerominute = selectedTime.minute <= 9
            ? "0" + selectedTime.minute.toString()
            : selectedTime.minute.toString();

        edt_FromTime.text = beforZeroHour + ":" + beforZerominute + " " + AM_PM;
      });
  }

  Future<void> _selectToTime(
      BuildContext context, TextEditingController F_datecontroller) async {
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

        String AM_PM =
            selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
        String beforZeroHour = selectedTime.hourOfPeriod <= 9
            ? "0" + selectedTime.hourOfPeriod.toString()
            : selectedTime.hourOfPeriod.toString();
        String beforZerominute = selectedTime.minute <= 9
            ? "0" + selectedTime.minute.toString()
            : selectedTime.minute.toString();

        edt_ToTime.text = beforZeroHour + ":" + beforZerominute + " " + AM_PM;
      });
  }

  void getLocationLivePermission456() async {
    baseBloc.emit(ShowProgressIndicatorState(true));

    bool serviceEnabled =
        await geolocator.Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      checkPermissionStatus();
      baseBloc.emit(ShowProgressIndicatorState(false));
      return Future.error('Location services are disabled.');
    }

    geolocator.LocationPermission permission =
        await geolocator.Geolocator.checkPermission();

    if (permission == geolocator.LocationPermission.denied ||
        permission == geolocator.LocationPermission.deniedForever) {
      print(
          "A12215534 Location permissions are denied, we cannot request permissions.");
      permission = await geolocator.Geolocator.requestPermission();
      baseBloc.emit(ShowProgressIndicatorState(false));
      return Future.error('Location permissions are denied');
    }

    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition();

    Latitude_In = position.latitude.toString();
    Longitude_In = position.longitude.toString();

    print("CurrentLatLong $Latitude_In, $Longitude_In");

    List<geo.Placemark> placemark = await geo.placemarkFromCoordinates(
      double.parse(Latitude_In),
      double.parse(Longitude_In),
    );

    Address_In =
        "${placemark[0].name}, ${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country},";

    setState(() {});

    baseBloc.emit(ShowProgressIndicatorState(false));
    isTapLiveLocation = true;
  }

  void getLocationLivePermissionOut() async {
    baseBloc.emit(ShowProgressIndicatorState(true));

    bool serviceEnabled;
    geolocator.LocationPermission permission;

    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      checkPermissionStatus();
      return Future.error('Location services are disabled.');
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      print("A12215534" +
          "Location permissions are permanently denied, we cannot request permissions.");

      permission = await geolocator.Geolocator.requestPermission();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == geolocator.LocationPermission.whileInUse) {
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition();

      Latitude_Out = position.latitude.toString();
      Longitude_Out = position.longitude.toString();

      print("CurrentLatLong" +
          Latitude_Out.toString() +
          " , " +
          Longitude_Out.toString());
      List<geo.Placemark> placemark = [];

      double lat = Latitude_Out != "" ? double.parse(Latitude_Out) : 0.00;
      double lang = Longitude_Out != "" ? double.parse(Longitude_Out) : 0.00;

      placemark = await geo.placemarkFromCoordinates(lat, lang);
      Address_Out =
          "${placemark[0].name}, ${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country},";
      setState(() {});
    }

    if (permission == geolocator.LocationPermission.always) {
      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition();

      Latitude_Out = position.latitude.toString();
      Longitude_Out = position.longitude.toString();

      print("CurrentLatLong" +
          Latitude_Out.toString() +
          " , " +
          Longitude_Out.toString());
      List<geo.Placemark> placemark = [];

      double lat = Latitude_Out != "" ? double.parse(Latitude_Out) : 0.00;
      double lang = Longitude_Out != "" ? double.parse(Longitude_Out) : 0.00;

      placemark = await geo.placemarkFromCoordinates(lat, lang);
      Address_Out =
          "${placemark[0].name}, ${placemark[0].street}, ${placemark[0].subLocality}, ${placemark[0].locality}, ${placemark[0].administrativeArea}, ${placemark[0].country},";
    }

    baseBloc.emit(ShowProgressIndicatorState(false));

    isTapLiveLocation = true;
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
                                              bool ISDuplicate = false;

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

                          // print("sdjdsfj" + MultipleVideoList[index].path);
                          // OpenFile.open(MultipleVideoList[index].path);
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
                        /* decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: colorLightGray,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),*/
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

    // For Android 12 and below (API < 33)
    if (android.version.sdkInt < 33) {
      permissionHandler.PermissionStatus status =
          await permissionHandler.Permission.storage.request();

      if (status.isGranted) {
        setState(() {
          permissionGranted = true;
        });
      } else if (status.isPermanentlyDenied) {
        _showPermissionDialog(
          'Storage Permission Required',
          'Storage permission is needed for temporary image processing. Please enable it in app settings.',
        );
      } else {
        setState(() {
          permissionGranted = false;
        });
      }
    } else {
      // For Android 13+ - NO STORAGE PERMISSIONS NEEDED!
      // Camera photos are saved to app-specific cache automatically
      setState(() {
        permissionGranted = true;
      });
    }
  }

// Helper method to show permission dialog
  void _showPermissionDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                permissionHandler.openAppSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }
}
