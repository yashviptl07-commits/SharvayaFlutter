import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:soleoserp/blocs/other/bloc_modules/followup/followup_bloc.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_source_list_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_delete_image_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_image_list_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_inquiry_by_customer_id_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_save_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_type_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_status_list_request.dart';
import 'package:soleoserp/models/api_requests/other/Campaign_List.dart';
import 'package:soleoserp/models/api_requests/other/Common_CompanyDetails.dart';
import 'package:soleoserp/models/api_requests/other/closer_reason_list_request.dart';
import 'package:soleoserp/models/api_requests/telecaller/tele_caller_followup_save_request.dart';
import 'package:soleoserp/models/api_requests/third_party_api_request/third_party_api_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_filter_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/pushnotification/get_report_to_token_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/search_followup_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/general_followup/general_followup_list_for_almighty_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/general_followup/general_followup_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/General_Constants.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/image_full_screen.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:permission_handler/permission_handler.dart'
as permissionHandler;


class AddUpdateFollowupScreenArguments {
  FilterDetails editModel;
  String FollowupStatus;
  String ScreenName;

  AddUpdateFollowupScreenArguments(this.editModel,this.FollowupStatus,this.ScreenName);
}



class FollowUpAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/FollowUpAddEditScreen';
  final AddUpdateFollowupScreenArguments arguments;


  FollowUpAddEditScreen(this.arguments);

  @override
  _FollowUpAddEditScreenScreenState createState() =>
      _FollowUpAddEditScreenScreenState();
}

class _FollowUpAddEditScreenScreenState extends BaseState<FollowUpAddEditScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // FollowupTypeListResponse _offlineFollowupTypeListResponseData;
  // InquiryStatusListResponse _offlineInquiryLeadStatusData;

  final TextEditingController edt_FollowupType = TextEditingController();
  final TextEditingController edt_FollowupTypepkID = TextEditingController();

  final TextEditingController edt_FollowUpDate = TextEditingController();
  final TextEditingController edt_ReverseFollowUpDate = TextEditingController();

  final TextEditingController edt_CustomerMoNO = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_FollowupInquiryStatusType =
  TextEditingController();
  final TextEditingController edt_FollowupInquiryStatusTypepkID =
  TextEditingController();

  final TextEditingController edt_CloserReasonStatusType =
  TextEditingController();
  final TextEditingController edt_CloserReasonStatusTypepkID =
  TextEditingController();

  final TextEditingController edt_Priority = TextEditingController();
  final TextEditingController edt_InqNo = TextEditingController();
  final TextEditingController edt_FollowupNotes = TextEditingController();
  final TextEditingController edt_NextFollowupDate = TextEditingController();
  final TextEditingController edt_ReverseNextFollowupDate =
  TextEditingController();

  final TextEditingController edt_PreferedTime = TextEditingController();
  final TextEditingController edt_LeadStatus = TextEditingController();



  List<ALL_Name_ID> arr_ALL_Name_ID_For_FolowupType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_FolowupInquiryStatusType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_CloserReasonStatusType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_InquiryNoListType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_FolowupInquiryByCustomerID = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];
  List<ALL_Name_ID> arr_All_DisQualifiedList = [];
  List<ALL_Name_ID> arr_All_Employee_List = [];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  SearchDetails _searchDetails;
  FollowupBloc _FollowupBloc;
  int savepkID = 0;
  bool _isForUpdate;
  bool _isInqury_details_Exist;

  FilterDetails _editModel;
  double _rating;
  bool _isSwitched;
  File _selectedImageFile;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;


  int CompanyID = 0;
  String LoginUserID = "";
  bool is_closer_reasonVisible;

  String GetImageNamefromEditMode = "";
  FocusNode NotesFocusNode;


  Location location = new Location();
  WhatsAppApiRequest whatsAppApiRequest;

  bool _serviceEnabled;

  bool is_LocationService_Permission;
  bool SaveSucess;
  bool is_Storage_Service_Permission;
  String ReportToToken = "";

  String WhatsAppApiKey = "";
  String WhatsAppApiMessage = "";


  String _FollowupStatus = "Todays";

  String MapAPIKey = "";

  String Address="";


  double CardViewHeight = 45.00;

  final TextEditingController edt_DisQualifiedName = TextEditingController();
  final TextEditingController edt_DisQualifiedID = TextEditingController();
  final TextEditingController edt_DisqualifiedRemarks = TextEditingController();
  final TextEditingController edt_QualifiedEmplyeeName = TextEditingController();
  final TextEditingController edt_QualifiedEmplyeeID = TextEditingController();
  bool isqualified = false;
  bool isDisqualified = false;
  bool isInProcess = false;
  FollowerEmployeeListResponse _offlineALLEmployeeListData;
  bool isTelecallerFollowup = false;

  bool ISFOREDIT_EXTID = false;

  bool permissionGranted;
  geolocator.Position _currentPosition;



  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    //_getStoragePermission();
    getLocationLivePermission();
    getAddressFromLatLong();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    MapAPIKey = _offlineCompanyData.details[0].MapApiKey;
    getAddressFromLatLong();
    whatsAppApiRequest = new WhatsAppApiRequest();

    SaveSucess = false;
    _FollowupBloc = FollowupBloc(baseBloc);
    NotesFocusNode = FocusNode();
    _offlineALLEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _onFollowerEmployeeListByStatusCallSuccess(_offlineALLEmployeeListData);

    FetchFollowupPriorityDetails();
    LeadStatus();
    FetchFollowupStatusDetails();
    edt_Priority.addListener(() {
      NotesFocusNode.requestFocus();
    });


    _FollowupBloc.add(CommonCompanyDetailsRequestCallEvent(CommonCompanyDetailsRequest(
        CompanyId: CompanyID.toString())));
 _FollowupBloc.add(GetReportToTokenRequestEvent(GetReportToTokenRequest(
        CompanyId: CompanyID.toString(),
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString())));
    _isForUpdate = widget.arguments.editModel != null;
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      _FollowupStatus = widget.arguments.FollowupStatus;

      print("slfsdjkf" + widget.arguments.editModel.extpkID.toString());
      isTelecallerFollowup = widget.arguments.editModel.extpkID!=0?true:false;

      fillData();
    }
    else {

      isTelecallerFollowup = false;
      _rating = 4.0;
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

      String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour = selectedTime.hourOfPeriod <= 9
          ? "0" + selectedTime.hourOfPeriod.toString()
          : selectedTime.hourOfPeriod.toString();
      String beforZerominute = selectedTime.minute <= 9
          ? "0" + selectedTime.minute.toString()
          : selectedTime.minute.toString();

      edt_PreferedTime.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;

      setState(() {});
    }

    _isSwitched = false;
    _isInqury_details_Exist = false;
    is_closer_reasonVisible = false;


    edt_FollowupInquiryStatusType.addListener(() {
      if (edt_FollowupInquiryStatusType.text == "Close - Lost") {
        is_closer_reasonVisible = true;
      } else {
        is_closer_reasonVisible = false;
      }
      setState(() {});
    });
    isExistINQFromEDIT();
    if (SaveSucess == true) {
      _onOldState();
    }

    edt_LeadStatus.addListener(() {
      if (edt_LeadStatus.text == "Qualified") {
        isqualified = true;
        isDisqualified = false;
        isInProcess = false;

      } else if (edt_LeadStatus.text == "Disqualified") {
        //isqualified = "Disqualified";
        isDisqualified = true;
        isqualified = false;
        isInProcess = false;

      } else if (edt_LeadStatus.text == "InProcess") {
        // isqualified = "In-Process";
        isInProcess = true;
        isqualified = false;
        isDisqualified = false;

      }
      setState(() {});
    });
  }

  bool IsFollowpDetails = true;



  @override
  void dispose() {
    super.dispose();
    NotesFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc,
      child: BlocConsumer<FollowupBloc, FollowupStates>(
        builder: (BuildContext context, FollowupStates state) {
          if (state is FollowupInquiryNoListCallResponseState) {
            _onInquiryNoListTypeCallSuccess(state);
          }
          if (state is FollowupCustomerListByNameCallResponseState) {
            _onInquiryListByNumberCallSuccess(state);
          }
          if (state is GetReportToTokenResponseState) {
            _onGetTokenfromReportopersonResult(state);
          }

          if (state is CampaignListResponseState) {
            _onGetCampaignListResult(state);
          }
          if (state is CommonCompanyDetailsResponseState) {
            _onGetCommonCompanyDetailsResult(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is FollowupCustomerListByNameCallResponseState ||
              currentState is FollowupInquiryStatusListCallResponseState ||
              currentState is FollowupInquiryNoListCallResponseState ||
              currentState is GetReportToTokenResponseState ||
              currentState is CampaignListResponseState ||
              currentState is CommonCompanyDetailsResponseState
          ) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, FollowupStates state) {
          if (state is FollowupInquiryByCustomerIdCallResponseState) {
            _onFollowupInquiryByCustomerIDCallSuccess(state);
          }
          if (state is FollowupSaveCallResponseState) {
            _onFollowupSaveCallSuccess(state);
          }
          if (state is FollowupImageDeleteCallResponseState) {
            _OnDeleteFollowupImageResponseSucess(state);
          }
          if (state is FollowupUploadImageFromMainFollowupCallResponseState) {
            _OnFollowupImageUploadSucessResponse(state);
          }

          if (state is FollowupTypeListCallResponseState) {
            _onFollowupListTypeCallSuccess(state);
          }
          if (state is InquiryLeadStatusListCallResponseState) {
            _onLeadStatusListTypeCallSuccess(state);
          }
          if (state is CloserReasonListCallResponseState) {
            _onCloserReasonStatusListTypeCallSuccess(state);
          }
          if (state is FCMNotificationResponseNewState) {
            _onRecevedNotification(state);
          }
          if (state is TeleCallerFollowupSaveResponseState) {
            _OnTeleCallerFollowupSaveResponse(state);
          }
          if (state is CustomerSourceCallEventResponseState) {
            _onDisQualifiedResonResult(state);
          }
          if (state is WhatsAppApiResponseState) {
            _onWhatsAppApi(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is FollowupInquiryByCustomerIdCallResponseState ||
              currentState is FollowupSaveCallResponseState ||
              currentState is FollowupImageDeleteCallResponseState ||
              currentState is FollowupUploadImageFromMainFollowupCallResponseState ||
              currentState is FollowupTypeListCallResponseState ||
              currentState is InquiryLeadStatusListCallResponseState ||
              currentState is CloserReasonListCallResponseState ||
              currentState is FCMNotificationResponseNewState ||
              currentState is TeleCallerFollowupSaveResponseState ||
              currentState is CustomerSourceCallEventResponseState ||
              currentState is WhatsAppApiResponseState
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text('Followup List'),
          gradient:
          LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: colorWhite,
            ),
            onPressed: () {
              if(_isForUpdate==true)
              {
                Navigator.of(context).pop(widget.arguments.FollowupStatus);
              }
              else
              {
                if(widget.arguments.ScreenName == "Almighty"){
                  navigateTo(context, GeneralFollowupListForAlmightyScreen.routeName, clearAllStack: true);
                }else{
                  navigateTo(context, GeneralFollowupListScreen.routeName, clearAllStack: true);
                }
              }
            },
          ),
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
              margin: EdgeInsets.all(Constant.CONTAINERMARGIN),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                            elevation: 20,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      IsFollowpDetails = !IsFollowpDetails;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        Text("Followup Details ",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: colorPrimary,
                                                fontWeight: FontWeight.bold)),
                                        Spacer(),
                                        IsFollowpDetails == true
                                            ? Icon(Icons.arrow_circle_down_rounded)
                                            : Icon(
                                          Icons.arrow_circle_up_rounded,
                                          color: colorPrimary,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: IsFollowpDetails,
                                  child: ManageFollowupDetails(),
                                ),
                              ],
                            )),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Visibility(
                            visible: false,
                            child: RatingStar()),
                        isTelecallerFollowup==true?Container():SwitchNoFollowup(),
                        isTelecallerFollowup==true?LeadStatusDetails():Container(),

                        SizedBox(
                          width: 20,
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            getAddressFromLatLong();
                            print("RatingValue " +
                                "Rate : " +
                                _rating.toInt().toString());
                            int nofollowupvalue = 0;
                            if (_isSwitched == false) {
                              nofollowupvalue = 0;
                            } else {
                              nofollowupvalue = 1;
                            }

                            print("SwitchValue " +
                                "Switch : " +
                                nofollowupvalue.toString());

                            _FollowupBloc.add(CampaignListRequestCallEvent(CampaignListRequest(
                                CampaignSubject: edt_FollowupType.text == "Visit" ? "Followup - Visit" :
                                edt_FollowupType.text == "Telephonic" ? "Followup - Telephonic" :
                                edt_FollowupType.text,
                                CompanyId: CompanyID.toString(),
                                LoginUserID: LoginUserID)));

                            if (edt_CustomerName.text != "") {
                              if (edt_FollowupType.text != "") {
                                if (edt_Priority.text != "") {
                                  if (edt_FollowupNotes.text != "") {
                                    if (edt_NextFollowupDate.text != "") {


                                      String FollowupPriorityDetails = "";

                                      if (_offlineLoggedInData
                                          .details[0].serialKey
                                          .toUpperCase() ==
                                          "DOL2-6UH7-PH03-IN5H"||_offlineLoggedInData
                                          .details[0].serialKey
                                          .toUpperCase() ==
                                          "TEST-0000-SI0F-0208" ) {
                                        if (edt_Priority.text == "Hot") {
                                          FollowupPriorityDetails = "1";
                                        } else if (edt_Priority.text == "Cold") {
                                          FollowupPriorityDetails = "2";
                                        } else if (edt_Priority.text == "Warm") {
                                          FollowupPriorityDetails = "3";
                                        }
                                      } else {
                                        if (edt_Priority.text == "High") {
                                          FollowupPriorityDetails = "1";
                                        } else if (edt_Priority.text ==
                                            "Medium") {
                                          FollowupPriorityDetails = "2";
                                        } else if (edt_Priority.text == "Low") {
                                          FollowupPriorityDetails = "3";
                                        }
                                      }


                                      DateTime FbrazilianDate =
                                      new DateFormat("dd-MM-yyyy")
                                          .parse(edt_FollowUpDate.text);
                                      DateTime NbrazilianDate =
                                      new DateFormat("dd-MM-yyyy")
                                          .parse(edt_NextFollowupDate.text);

                                      if (FbrazilianDate.isBefore(
                                          NbrazilianDate)) {
                                        showCommonDialogWithTwoOptions(context,
                                            "Are you sure you want to Save this Follow-Up?",
                                            negativeButtonTitle: "No",
                                            positiveButtonTitle: "Yes",
                                            onTapOfPositiveButton: () {
                                              Navigator.of(context).pop();
                                              String Msg = _isForUpdate == true
                                                  ? "Followup Information. Updated Successfully"
                                                  : "Followup Information. Added Successfully";



                                              if(_isForUpdate==true)
                                              {

                                                if(_editModel.extpkID.toString()!="0")
                                                {


                                                  _FollowupBloc.add(TeleCallerFollowupSaveRequestEvent(context,_editModel.pkID,TeleCallerFollowupSaveRequest(
                                                    pkID: "0",
                                                    ExtpkID: _editModel.extpkID.toString(),
                                                    FollowupDate: edt_ReverseFollowUpDate.text,
                                                    FollowupSource: edt_FollowupType.text,
                                                    InquiryStatusID: edt_FollowupTypepkID.text.toString()!=""||edt_FollowupTypepkID.text.toString()!="null"?edt_FollowupTypepkID.text.toString():"",

                                                    MeetingNotes: edt_FollowupNotes.text,
                                                    NextFollowupDate: edt_ReverseNextFollowupDate.text,
                                                    PreferredTime: edt_PreferedTime.text,
                                                    LeadStatus: edt_LeadStatus.text,
                                                    NoFollClosureID: edt_DisQualifiedID.text,
                                                    AssignToEmployee: edt_QualifiedEmplyeeID.text,
                                                    LoginUserID: LoginUserID,
                                                    CompanyId: CompanyID.toString(),


                                                  )));
                                                }
                                                else
                                                {
                                                  _FollowupBloc.add(FollowupSaveByNameCallEvent(
                                                      Msg,
                                                      context,
                                                      savepkID,
                                                      FollowupSaveApiRequest(
                                                          pkID: savepkID.toString(),
                                                          FollowupDate: edt_ReverseFollowUpDate
                                                              .text,
                                                          CustomerID:
                                                          edt_CustomerpkID.text,
                                                          InquiryNo:
                                                          edt_InqNo.text == "null"
                                                              ? ""
                                                              : edt_InqNo.text,
                                                          MeetingNotes:
                                                          edt_FollowupNotes.text,
                                                          NextFollowupDate:
                                                          edt_ReverseNextFollowupDate
                                                              .text,
                                                          Rating: _rating
                                                              .toInt()
                                                              .toString(),
                                                          FollowupTypeId:
                                                          edt_FollowupTypepkID.text == "null"
                                                              ? ""
                                                              : edt_FollowupTypepkID
                                                              .text,
                                                          LoginUserID: LoginUserID,
                                                          Address: Address,
                                                          NoFollowup: nofollowupvalue
                                                              .toString(),
                                                          InquiryStatusId: edt_FollowupInquiryStatusTypepkID.text == "null"
                                                              ? ""
                                                              : edt_FollowupInquiryStatusTypepkID
                                                              .text,
                                                          Latitude: _currentPosition.latitude.toString(),
                                                          Longitude: _currentPosition.longitude.toString(),
                                                          PreferredTime:
                                                          edt_PreferedTime.text,
                                                          ClosureReasonId:
                                                          edt_CloserReasonStatusTypepkID.text == "null"
                                                              ? ""
                                                              : edt_CloserReasonStatusTypepkID.text,
                                                          CompanyId: CompanyID.toString(),
                                                          FollowupPriority: FollowupPriorityDetails,
                                                          FollowUpImage: "")));
                                                }

                                              }
                                              else
                                              {
                                                _FollowupBloc.add(FollowupSaveByNameCallEvent(
                                                    Msg,
                                                    context,
                                                    savepkID,
                                                    FollowupSaveApiRequest(
                                                        pkID: savepkID.toString(),
                                                        FollowupDate: edt_ReverseFollowUpDate
                                                            .text,
                                                        CustomerID:
                                                        edt_CustomerpkID.text,
                                                        InquiryNo:
                                                        edt_InqNo.text == "null"
                                                            ? ""
                                                            : edt_InqNo.text,
                                                        MeetingNotes:
                                                        edt_FollowupNotes.text,
                                                        NextFollowupDate:
                                                        edt_ReverseNextFollowupDate
                                                            .text,
                                                        Rating: _rating
                                                            .toInt()
                                                            .toString(),
                                                        FollowupTypeId:
                                                        edt_FollowupTypepkID.text == "null"
                                                            ? ""
                                                            : edt_FollowupTypepkID
                                                            .text,
                                                        LoginUserID: LoginUserID,
                                                        Address: Address,
                                                        NoFollowup: nofollowupvalue
                                                            .toString(),
                                                        InquiryStatusId: edt_FollowupInquiryStatusTypepkID.text == "null"
                                                            ? ""
                                                            : edt_FollowupInquiryStatusTypepkID
                                                            .text,
                                                        Latitude: _currentPosition.latitude.toString(),
                                                        Longitude: _currentPosition.longitude.toString(),
                                                        PreferredTime:
                                                        edt_PreferedTime.text,
                                                        ClosureReasonId:
                                                        edt_CloserReasonStatusTypepkID.text == "null"
                                                            ? ""
                                                            : edt_CloserReasonStatusTypepkID.text,
                                                        CompanyId: CompanyID.toString(),
                                                        FollowupPriority: FollowupPriorityDetails,
                                                        FollowUpImage: "")));
                                              }




                                            });
                                      } else {
                                        if (FbrazilianDate.isAtSameMomentAs(
                                            NbrazilianDate)) {
                                          showCommonDialogWithTwoOptions(
                                              context,
                                              "Are you sure you want to Save this Follow-Up?",
                                              negativeButtonTitle: "No",
                                              positiveButtonTitle: "Yes",
                                              onTapOfPositiveButton: () {
                                                Navigator.of(context).pop();
                                                String Msg = _isForUpdate == true
                                                    ? "Followup Information. Updated Successfully"
                                                    : "Followup Information. Added Successfully";

                                                if(_isForUpdate==true)
                                                {
                                                  if(_editModel.extpkID.toString()!="0")
                                                  {
                                                    _FollowupBloc.add(TeleCallerFollowupSaveRequestEvent(context,_editModel.pkID,TeleCallerFollowupSaveRequest(
                                                      pkID: "0",
                                                      ExtpkID: _editModel.extpkID.toString(),
                                                      FollowupDate: edt_ReverseFollowUpDate.text,
                                                      FollowupSource: edt_FollowupType.text,
                                                      InquiryStatusID: edt_FollowupTypepkID.text.toString()!=""||edt_FollowupTypepkID.text.toString()!="null"?edt_FollowupTypepkID.text.toString():"",
                                                      MeetingNotes: edt_FollowupNotes.text,
                                                      NextFollowupDate: edt_ReverseNextFollowupDate.text,
                                                      PreferredTime: edt_PreferedTime.text,
                                                      LeadStatus: edt_LeadStatus.text,
                                                      NoFollClosureID: edt_DisQualifiedID.text,
                                                      AssignToEmployee: edt_QualifiedEmplyeeID.text,
                                                      LoginUserID: LoginUserID,
                                                      CompanyId: CompanyID.toString(),

                                                    )));
                                                  }
                                                  else
                                                  {
                                                    _FollowupBloc.add(FollowupSaveByNameCallEvent(
                                                        Msg,
                                                        context,
                                                        savepkID,
                                                        FollowupSaveApiRequest(
                                                            pkID: savepkID.toString(),
                                                            FollowupDate:
                                                            edt_ReverseFollowUpDate
                                                                .text,
                                                            CustomerID:
                                                            edt_CustomerpkID.text,
                                                            InquiryNo:
                                                            edt_InqNo.text == "null"
                                                                ? ""
                                                                : edt_InqNo.text,
                                                            MeetingNotes:
                                                            edt_FollowupNotes.text,
                                                            NextFollowupDate:
                                                            edt_ReverseNextFollowupDate
                                                                .text,
                                                            Rating: _rating
                                                                .toInt()
                                                                .toString(),
                                                            FollowupTypeId:
                                                            edt_FollowupTypepkID.text == "null"
                                                                ? ""
                                                                : edt_FollowupTypepkID
                                                                .text,
                                                            LoginUserID: LoginUserID,
                                                            Address: Address,
                                                            NoFollowup: nofollowupvalue
                                                                .toString(),
                                                            InquiryStatusId:
                                                            edt_FollowupInquiryStatusTypepkID.text == "null"
                                                                ? ""
                                                                : edt_FollowupInquiryStatusTypepkID
                                                                .text,
                                                            Latitude: _currentPosition.latitude.toString(),
                                                            Longitude: _currentPosition.longitude.toString(),
                                                            PreferredTime:
                                                            edt_PreferedTime.text,
                                                            ClosureReasonId:
                                                            edt_CloserReasonStatusTypepkID.text == "null"
                                                                ? ""
                                                                : edt_CloserReasonStatusTypepkID.text,
                                                            CompanyId: CompanyID.toString(),
                                                            FollowupPriority: FollowupPriorityDetails,
                                                            FollowUpImage: "")));

                                                  }
                                                }
                                                else
                                                {
                                                  _FollowupBloc.add(FollowupSaveByNameCallEvent(
                                                      Msg,
                                                      context,
                                                      savepkID,
                                                      FollowupSaveApiRequest(
                                                          pkID: savepkID.toString(),
                                                          FollowupDate:
                                                          edt_ReverseFollowUpDate
                                                              .text,
                                                          CustomerID:
                                                          edt_CustomerpkID.text,
                                                          InquiryNo:
                                                          edt_InqNo.text == "null"
                                                              ? ""
                                                              : edt_InqNo.text,
                                                          MeetingNotes:
                                                          edt_FollowupNotes.text,
                                                          NextFollowupDate:
                                                          edt_ReverseNextFollowupDate
                                                              .text,
                                                          Rating: _rating
                                                              .toInt()
                                                              .toString(),
                                                          FollowupTypeId:
                                                          edt_FollowupTypepkID.text == "null"
                                                              ? ""
                                                              : edt_FollowupTypepkID
                                                              .text,
                                                          LoginUserID: LoginUserID,
                                                          Address:Address,
                                                          NoFollowup: nofollowupvalue
                                                              .toString(),
                                                          InquiryStatusId:
                                                          edt_FollowupInquiryStatusTypepkID.text == "null"
                                                              ? ""
                                                              : edt_FollowupInquiryStatusTypepkID
                                                              .text,
                                                          Latitude: _currentPosition.latitude.toString(),
                                                          Longitude: _currentPosition.longitude.toString(),
                                                          PreferredTime:
                                                          edt_PreferedTime.text,
                                                          ClosureReasonId:
                                                          edt_CloserReasonStatusTypepkID.text == "null"
                                                              ? ""
                                                              : edt_CloserReasonStatusTypepkID.text,
                                                          CompanyId: CompanyID.toString(),
                                                          FollowupPriority: FollowupPriorityDetails,
                                                          FollowUpImage: "")));

                                                }






                                              });
                                        } else {
                                          showCommonDialogWithSingleOption(
                                              context,
                                              "Next Followup Date Should be greater than Followup Date !",
                                              positiveButtonTitle: "OK");
                                        }
                                      }


                                    } else {
                                      showCommonDialogWithSingleOption(context,
                                          "Next FollowupDate is required!",
                                          positiveButtonTitle: "OK");
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(
                                        context, "Followup Notes is required!",
                                        positiveButtonTitle: "OK");
                                  }
                                } else {
                                  showCommonDialogWithSingleOption(
                                      context, "Please Select Priority!",
                                      positiveButtonTitle: "OK");
                                }
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Please Select Followup Type!",
                                    positiveButtonTitle: "OK");
                              }
                            } else {
                              showCommonDialogWithSingleOption(
                                  context, "Select Proper Customer From List!",
                                  positiveButtonTitle: "OK");
                            }
                          },
                          child: Card(
                              elevation: 10,
                              color: colorPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Center(
                                  child: Text("Save",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )),
                        ),



                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                      ]))),
        ),
      ),
    );
  }


  Future<bool> _onBackPressed() {
    if(_isForUpdate==true)
    {
      Navigator.of(context).pop(widget.arguments.FollowupStatus);
    }
    else
    {
      if(widget.arguments.ScreenName == "Almighty"){
        navigateTo(context, GeneralFollowupListForAlmightyScreen.routeName, clearAllStack: true);
      }else{
        navigateTo(context, GeneralFollowupListScreen.routeName, clearAllStack: true);
      }
    }
  }

  Future<bool> _onOldState() {
    Navigator.of(context).pop();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: selectedDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
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
      });
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
      });
  }

  Future<void> _selectTime(
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

        edt_PreferedTime.text = beforZeroHour +
            ":" +
            beforZerominute +
            " " +
            AM_PM; //picked_s.periodOffset.toString();
      });
  }

  FetchFollowupPriorityDetails() {
    if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
        "dol2-6uh7-ph03-in5h") {
      arr_ALL_Name_ID_For_Folowup_Priority.clear();
      for (var i = 0; i < 3; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();

        if (i == 0) {
          all_name_id.Name = "Hot";
        } else if (i == 1) {
          all_name_id.Name = "Cold";
        } else if (i == 2) {
          all_name_id.Name = "Warm";
        }
        arr_ALL_Name_ID_For_Folowup_Priority.add(all_name_id);
      }
    } else {
      arr_ALL_Name_ID_For_Folowup_Priority.clear();
      for (var i = 0; i < 3; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();

        if (i == 0) {
          all_name_id.Name = "High";
        } else if (i == 1) {
          all_name_id.Name = "Medium";
        } else if (i == 2) {
          all_name_id.Name = "Low";
        }
        arr_ALL_Name_ID_For_Folowup_Priority.add(all_name_id);
      }
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


  Future<void> _onTapOfSearchView() async {
    if (_isForUpdate == false) {
      navigateTo(context, SearchFollowupCustomerScreen.routeName).then((value) {
        if (value != null) {
          _searchDetails = value;
          edt_CustomerpkID.text = _searchDetails.value.toString();
          edt_CustomerName.text = _searchDetails.label.toString();
          edt_CustomerMoNO.text = _searchDetails.ContactNo1.toString();

          _FollowupBloc.add(SearchFollowupCustomerListByNameCallEvent(
              CustomerLabelValueRequest(
                  CompanyId: CompanyID.toString(),
                  LoginUserID: "admin",
                  word: _searchDetails.value.toString())));

          _FollowupBloc.add(FollowupInquiryByCustomerIDCallEvent(
              FollowerInquiryByCustomerIDRequest(
                CompanyId: CompanyID.toString(),
                CustomerID: edt_CustomerpkID.text,
              )));
        }
        print("CustomerInfo : " +
            edt_CustomerName.text.toString() +
            " CustomerID : " +
            edt_CustomerpkID.text.toString());
      });
    }
  }

  void _onInquiryListByNumberCallSuccess(
      FollowupCustomerListByNameCallResponseState state) {}

  void _onGetTokenfromReportopersonResult(GetReportToTokenResponseState state) {
    ReportToToken = state.response.details[0].reportPersonTokenNo;
  }

  void _onGetCampaignListResult(CampaignListResponseState state) {
    for(int i=0;i<state.response.details.length;i++){
      WhatsAppApiMessage = state.response.details[i].campaignHeader;
    }
  }

  void _onGetCommonCompanyDetailsResult(CommonCompanyDetailsResponseState state) {
    for(int i=0;i<state.response.details.length;i++){
      WhatsAppApiKey = state.response.details[i].wSPAuthKey;
    }
  }

  void _onFollowupSaveCallSuccess(FollowupSaveCallResponseState state) async {
    // if( state.followupSaveResponse.details[0].column2==" state.followupSaveResponse.details[0].column2")
    print("FollowupSav123" +
        " Response : " +
        state.followupSaveResponse.details[0].column2);

    String notiTitle = "FollowUp";
    String updatemsg = _isForUpdate == true ? " Updated " : " Created ";

    ///state.inquiryHeaderSaveResponse.details[0].column3;
    String notibody = "FollowUp " +
        updatemsg +
        " For " +
        edt_CustomerName.text +
        " By " +
        _offlineLoggedInData.details[0].employeeName;


    final Map<String, dynamic> message = {
      'message': {
        'token': ReportToToken,
        "notification": {"body": notibody, "title": notiTitle},
        'data': {
          "body": notibody,
          "title": notiTitle,
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        },
      }
    };

    if(ReportToToken!="")
    {
      if(_offlineLoggedInData.details[0].serialKey.toUpperCase()!="BLG3-AF78-TO5F-NW16")
      {
        _FollowupBloc.add(FCMNotificationRequestNewEvent(message));
      }
    }

    if (_selectedImageFile != null) {

      File filerty = File(_selectedImageFile.path);

      final extension = p.extension(filerty.path);

      int timestamp1 = DateTime.now().millisecondsSinceEpoch;

      String followup_fileName = "Follow_Up"+
          "_" +
          state.followupSaveResponse.details[0].column3.toString() + "_" +
          DateTime.now().day.toString() +
          "_" +
          DateTime.now().month.toString() +
          "_" +
          DateTime.now().year.toString() +
          "_" +
          timestamp1.toString() +
          extension;

      /* _FollowupBloc.add(FollowupUploadImageNameFromMainFollowupCallEvent(
          state.context,
          _selectedImageFile,
          FollowUpUploadImageAPIRequest(
              CompanyId: CompanyID.toString(),
              LoginUserId: LoginUserID,
              pkID: "0",
              fileName: followup_fileName,
              FollowupID:
                  state.followupSaveResponse.details[0].column3.toString(),
              InquiryNo: edt_InqNo.text.toString() != ""
                  ? edt_InqNo.text.toString()
                  : "",
              Type: "0",
              file: _selectedImageFile)));*/
    } else {
      String Msg = _isForUpdate == true
          ? "Followup Information. Updated Successfully"
          : "Followup Information. Added Successfully";


      // bool isTaptoEvent = false;
      showCommonDialogWithSingleOption(context, Msg,
          positiveButtonTitle: "OK", onTapOfPositiveButton: ()  {
            // navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);
            //isTaptoEvent = true;
            if(_isForUpdate==true)
            {
              Navigator.pop(context);
              Navigator.of(state.context).pop(widget.arguments.FollowupStatus);
            }
            else
            {
              if(widget.arguments.ScreenName == "Almighty"){
                navigateTo(context, GeneralFollowupListForAlmightyScreen.routeName, clearAllStack: true);

              }else{
                navigateTo(context, GeneralFollowupListScreen.routeName, clearAllStack: true);

              }
            }


          });
    }
  }

  void _onFollowupListTypeCallSuccess(FollowupTypeListCallResponseState state) {
    if (state.followupTypeListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_FolowupType.clear();
      for (var i = 0; i < state.followupTypeListResponse.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.followupTypeListResponse.details[i].inquiryStatus;
        all_name_id.pkID = state.followupTypeListResponse.details[i].pkID;
        arr_ALL_Name_ID_For_FolowupType.add(all_name_id);
      }

      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_FolowupType,
          context1: context,
          controller: edt_FollowupType,
          controllerID: edt_FollowupTypepkID,
          lable: "Select Followup Type");

    }
  }

  void _onCloserReasonStatusListTypeCallSuccess(
      CloserReasonListCallResponseState state) {
    if (state.closerReasonListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_CloserReasonStatusType.clear();
      for (var i = 0; i < state.closerReasonListResponse.details.length; i++) {
        print("CloserReasonStatus : " +
            state.closerReasonListResponse.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.closerReasonListResponse.details[i].inquiryStatus;
        all_name_id.pkID = state.closerReasonListResponse.details[i].pkID;
        arr_ALL_Name_ID_For_CloserReasonStatusType.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_CloserReasonStatusType,
          context1: context,
          controller: edt_CloserReasonStatusType,
          controllerID: edt_CloserReasonStatusTypepkID,
          lable: "Select DisQualified Reason");
    }
  }

  void _onInquiryNoListTypeCallSuccess(
      FollowupInquiryNoListCallResponseState state) {
    if (state.followupInquiryNoListResponse.details != null) {
      arr_ALL_Name_ID_For_InquiryNoListType.clear();
      for (var i = 0;
      i < state.followupInquiryNoListResponse.details.length;
      i++) {
        print("InquiryNoStatus : " +
            state.followupInquiryNoListResponse.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.followupInquiryNoListResponse.details[i].inquiryNo;
        all_name_id.Name1 = state
            .followupInquiryNoListResponse.details[i].inquiryStatus
            .toString();
        all_name_id.pkID =
            state.followupInquiryNoListResponse.details[i].inquiryStatusID;
        arr_ALL_Name_ID_For_InquiryNoListType.add(all_name_id);
      }
    }
  }

  void _onRecevedNotification(FCMNotificationResponseNewState state) {}

  Widget CustomDropDown1(String Category,
      {bool enable1,
        Icon icon,
        String title,
        String hintTextvalue,
        TextEditingController controllerForLeft,
        List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                lable: "Select $Category"),
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
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap:
                () =>
            CreateDialogDropdown(Category),
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
                              .bold)
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
                              )
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

  Widget showcustomdialogWithMultiID1(String Category,
      {bool enable1,
        Icon icon,
        String title,
        String hintTextvalue,
        TextEditingController controllerForLeft,
        TextEditingController controller1,
        TextEditingController controllerpkID,
        List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithMultipleID(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                controller2: controller1,
                controllerID: controllerpkID,
                lable: "Select $Category"),
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
  }

  void fillData() {
    if (_editModel.followupDate == "") {
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
    } else {
      edt_FollowUpDate.text = _editModel.followupDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_ReverseFollowUpDate.text = _editModel.followupDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    }
    if (_editModel.nextFollowupDate == "") {
      selectedDate = DateTime.now();

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
    } else {
      edt_NextFollowupDate.text = _editModel.nextFollowupDate.getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
      edt_ReverseNextFollowupDate.text = _editModel.nextFollowupDate
          .getFormattedDate(
          fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    }

    if (_editModel.preferredTime == "") {
      TimeOfDay selectedTime = TimeOfDay.now();

      String AM_PM = selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
      String beforZeroHour = selectedTime.hourOfPeriod <= 9
          ? "0" + selectedTime.hourOfPeriod.toString()
          : selectedTime.hourOfPeriod.toString();
      String beforZerominute = selectedTime.minute <= 9
          ? "0" + selectedTime.minute.toString()
          : selectedTime.minute.toString();

      edt_PreferedTime.text =
          beforZeroHour + ":" + beforZerominute + " " + AM_PM;
    } else {
      edt_PreferedTime.text = _editModel.preferredTime;
    }

    if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
        "dol2-6uh7-ph03-in5h") {
      if (_editModel.followupPriority == 1) {
        edt_Priority.text = "Hot";
      } else if (_editModel.followupPriority == 2) {
        edt_Priority.text = "Cold";
      } else {
        edt_Priority.text = "Warm";
      }
    } else {
      if (_editModel.followupPriority == 1) {
        edt_Priority.text = "High";
      } else if (_editModel.followupPriority == 2) {
        edt_Priority.text = "Medium";
      } else {
        edt_Priority.text = "Low";
      }
    }

    edt_CustomerName.text = _editModel.customerName;
    edt_CustomerpkID.text = _editModel.customerID.toString();

    savepkID = _editModel.pkID.toInt();
    edt_InqNo.text = _editModel.inquiryNo;
    edt_FollowupInquiryStatusType.text = _editModel.inquiryStatusDesc;
    edt_FollowupInquiryStatusTypepkID.text =
        _editModel.inquiryStatusDescID.toString();

    print("InqExistt" + "INQNO : " + _editModel.inquiryNo);

    edt_FollowupNotes.text = _editModel.meetingNotes;

    edt_CloserReasonStatusTypepkID.text = _editModel.noFollClosureID.toString();
    edt_FollowupType.text = _editModel.inquiryStatus.toString()=="--Not Available--"?"":_editModel.inquiryStatus.toString();
    edt_FollowupTypepkID.text = _editModel.inquiryStatusID.toString();
    print("RARINGG" + "Rate : " + _editModel.rating.toDouble().toString());

    _rating = _editModel.rating == null || _editModel.rating == 0
        ? 0.00
        : _editModel.rating.toDouble();

    if (_editModel.noFollowup == 0) {
      _isSwitched = false;
    } else {
      _isSwitched = true;
    }


    _FollowupBloc.add(
        FollowupInquiryByCustomerIDCallEvent(FollowerInquiryByCustomerIDRequest(
          CompanyId: CompanyID.toString(),
          CustomerID: edt_CustomerpkID.text,
        )));


    _FollowupBloc.add(FollowupImageListRequestEvent(_editModel.pkID,FollowupImageListRequest(CompanyId: CompanyID.toString(),FollowUpID: "")));
    edt_QualifiedEmplyeeName.text = _editModel.AssignedToName.toString();
    edt_QualifiedEmplyeeID.text = _editModel.AssignedToID.toString();
    edt_LeadStatus.text = _editModel.LeadStatus.toString()==""?"InProcess":_editModel.LeadStatus.toString();

  }

  Widget RatingStar() {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text("Rating",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: RatingBar.builder(
                initialRating: _rating,
                itemCount: 5,
                itemSize: 40,
                itemPadding: EdgeInsets.only(left: 15, right: 15),
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      );
                    case 1:
                      return Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.redAccent,
                      );
                    case 2:
                      return Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    case 3:
                      return Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                      );
                    case 4:
                      return Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      );
                    default:
                      return Container();
                  }
                },
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                  print("DefaultRating" + "Default : " + rating.toString());
                },
              ),
            ),
          ],
        ));
  }

  Widget SwitchNoFollowup() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("No Followup",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            child: Switch(
              value: _isSwitched,
              activeColor: Colors.green,
              inactiveTrackColor: Colors.red,
              onChanged: (value) {
                print("_isSwitchedVALUE : $value");
                setState(() {
                  _isSwitched = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onFollowupInquiryByCustomerIDCallSuccess(
      FollowupInquiryByCustomerIdCallResponseState state) {
    _isForUpdate == true
        ? edt_FollowupInquiryStatusTypepkID.text
        : edt_FollowupInquiryStatusTypepkID.text = "";
    _isForUpdate == true
        ? edt_FollowupInquiryStatusType.text
        : edt_FollowupInquiryStatusType.text = "";

    _isInqury_details_Exist = false;

    if (state.followupInquiryByCustomerIDResponse.details != null) {
      arr_ALL_Name_ID_For_FolowupInquiryByCustomerID.clear();
      for (var i = 0;
      i < state.followupInquiryByCustomerIDResponse.details.length;
      i++) {
        print("InquiryStatus : " +
            state.followupInquiryByCustomerIDResponse.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.followupInquiryByCustomerIDResponse.details[i].inquiryNo;
        all_name_id.Name1 =
            state.followupInquiryByCustomerIDResponse.details[i].inquiryStatus;
        all_name_id.pkID = state
            .followupInquiryByCustomerIDResponse.details[i].inquiryStatusID;
        arr_ALL_Name_ID_For_FolowupInquiryByCustomerID.add(all_name_id);
        _isInqury_details_Exist = true;
      }
    } else {
      arr_ALL_Name_ID_For_FolowupInquiryByCustomerID.clear();
      _isInqury_details_Exist = false;
    }

    setState(() {});
  }

  void isExistINQFromEDIT() {
    if (edt_InqNo.text != "") {
      _isInqury_details_Exist = true;
    } else {
      _isInqury_details_Exist = false;
    }
    setState(() {});
  }

  _OnDeleteFollowupImageResponseSucess(
      FollowupImageDeleteCallResponseState state) {
    print("ImageDeleteSucess" +
        state.followupDeleteImageResponse.details[0].column2.toString());
    _isForUpdate = false;
    setState(() {});
  }

  _OnFollowupImageUploadSucessResponse(
      FollowupUploadImageFromMainFollowupCallResponseState state) async {
    //print("ImageUploadSucess"+ state.followupImageUploadResponse.details[0].column1);
    /* showCommonDialogWithSingleOption(context, Msg,
         positiveButtonTitle: "OK", onTapOfPositiveButton: () {
           _selectedImageFile.delete(recursive: true);
           //navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);
           Navigator.of(context).pop();

         });*/
    /* String Msg = _isForUpdate == true
        ? "Followup Information. Updated Successfully"
        : "Followup Information. Added Successfully";
    await showCommonDialogWithSingleOption(Globals.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);
    });*/


    String Msg = _isForUpdate == true
        ? "Followup Information. Updated Successfully"
        : "Followup Information. Added Successfully";


    // bool isTaptoEvent = false;
    showCommonDialogWithSingleOption(context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: ()  {
          // navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);
          //isTaptoEvent = true;
          if(_isForUpdate==true)
          {
            // Navigator.pop(context);
            Navigator.of(state.context).pop(widget.arguments.FollowupStatus);
          }
          else
          {
            if(widget.arguments.ScreenName == "Almighty"){
              navigateTo(context, GeneralFollowupListForAlmightyScreen.routeName, clearAllStack: true);
            }else{
              navigateTo(context, GeneralFollowupListScreen.routeName, clearAllStack: true);
            }
          }

        });


    // Navigator.of(context).pop();
  }

  CreateDialogDropdown(String category) {
    if (category == "Inquiry Status") {
      _FollowupBloc.add(InquiryLeadStatusTypeListByNameCallEvent(
          FollowupInquiryStatusTypeListRequest(
              CompanyId: CompanyID.toString(),
              pkID: "",
              StatusCategory: "Inquiry",
              LoginUserID: LoginUserID,
              SearchKey: "")));
    } else if (category == "Followup Type") {
      _FollowupBloc.add(FollowupTypeListByNameCallEvent(FollowupTypeListRequest(
          CompanyId: CompanyID.toString(),
          pkID: "",
          StatusCategory: "FollowUp",
          LoginUserID: LoginUserID,
          SearchKey: "")));
    } else {
      _FollowupBloc
        ..add(CloserReasonTypeListByNameCallEvent(CloserReasonTypeListRequest(
            CompanyId: CompanyID.toString(),
            pkID: "",
            StatusCategory: "DisQualifiedReason",
            LoginUserID: LoginUserID,
            SearchKey: "")));
    }
  }

  void _onLeadStatusListTypeCallSuccess(
      InquiryLeadStatusListCallResponseState state) {
    if (state.inquiryStatusListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_FolowupInquiryStatusType.clear();
      for (var i = 0; i < state.inquiryStatusListResponse.details.length; i++) {
        print("InquiryStatus : " +
            state.inquiryStatusListResponse.details[i].inquiryStatus);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.inquiryStatusListResponse.details[i].inquiryStatus;
        all_name_id.pkID = state.inquiryStatusListResponse.details[i].pkID;
        arr_ALL_Name_ID_For_FolowupInquiryStatusType.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_FolowupInquiryStatusType,
          context1: context,
          controller: edt_FollowupInquiryStatusType,
          controllerID: edt_FollowupInquiryStatusTypepkID,
          lable: "Select Inquiry Status");
    }
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


  void getLocationLivePermission() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      checkPermissionStatus();
      return Future.error('Location services are disabled.');
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      //permission = await Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        print("A12215534" +
            "Location permissions are  denied, we cannot request permissions.");

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
      geolocator.Position position = await geolocator.Geolocator.getCurrentPosition();
      _currentPosition = position;
      print("CurrentLatLong" +
          position.latitude.toString() +
          " , " +
          position.longitude.toString());


      geolocator.Geolocator
          .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best, forceAndroidLocationManager: true)
          .then((geolocator.Position position) {
        setState(() {
          _currentPosition = position;
          getAddressFromLatLong();
        });
      }).catchError((e) {
        print(e);
      });



      /* location.onLocationChanged.listen((LocationData currentLocation) {
        // Use current location

        SharedPrefHelper.instance.setLatitude(currentLocation.latitude.toString());
        SharedPrefHelper.instance.setLongitude(currentLocation.longitude.toString());
      });*/
    }


    if (permission == geolocator.LocationPermission.always) {
      geolocator.Position position = await geolocator.Geolocator.getCurrentPosition();
      _currentPosition = position;
      print("CurrentLatLong" +
          position.latitude.toString() +
          " , " +
          position.longitude.toString());


      geolocator.Geolocator
          .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best, forceAndroidLocationManager: true)
          .then((geolocator.Position position) {
        setState(() {
          _currentPosition = position;
          getAddressFromLatLong();
        });
      }).catchError((e) {
        print(e);
      });



      /* location.onLocationChanged.listen((LocationData currentLocation) {
        // Use current location

        SharedPrefHelper.instance.setLatitude(currentLocation.latitude.toString());
        SharedPrefHelper.instance.setLongitude(currentLocation.longitude.toString());
      });*/
    }

  }

  void checkPermissionStatus() async {
    if (!await location.serviceEnabled()) {
      // location.requestService();

      if (Platform.isAndroid) {
        location.requestService();
        /*showCommonDialogWithSingleOption(Globals.context,
            "Can't get current location, Please make sure you enable GPS and try again !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          AppSettings.openLocationSettings();
          Navigator.pop(context);
        });*/
      }
    }
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
      // openAppSettings();
      is_LocationService_Permission = false;
      await Permission.location.request();
    }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
      openAppSettings();
    }
    if (PermanentlyDenied == true) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      is_LocationService_Permission = false;
      openAppSettings();
    }

    if (granted == true) {
      // The OS restricts access, for example because of parental controls.
      is_LocationService_Permission = true;


    }
  }

  void getAddressFromLatLong() async {
    if (MapAPIKey != "") {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: double.parse(SharedPrefHelper.instance.getLatitude()),
          longitude: double.parse(SharedPrefHelper.instance.getLongitude()),
          googleMapApiKey: MapAPIKey);

      Address = data.address;

    }
  }



  void _OnTeleCallerFollowupSaveResponse(TeleCallerFollowupSaveResponseState state) {
    String Msg = _isForUpdate == true
        ? "Followup Information. Updated Successfully"
        : "Followup Information. Added Successfully";
    showCommonDialogWithSingleOption(context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: ()  {
          Navigator.pop(context);
          Navigator.of(state.context).pop(widget.arguments.FollowupStatus);
        });
  }


  ManageFollowupDetails() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              _selectDate(context, edt_FollowUpDate);
            },
            child: TextFormField(
                controller: edt_FollowUpDate,
                enabled: false,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today_outlined),
                    border: UnderlineInputBorder(),
                    labelText: 'Followup Date *',
                    hintText: "DD-MM-YYYY"),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF000000),
                )),
          ),
          SizedBox(
            height: 20,
          ),

          InkWell(
            onTap: () {
              _onTapOfSearchView();
            },
            child: TextFormField(
                controller: edt_CustomerName,
                enabled: false,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Customer Name *',
                    hintText: "Tap to select Name"),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF000000),
                )),
          ),

          Visibility(
            visible: _isInqury_details_Exist,
            child: InkWell(
              onTap: () {
                showcustomdialogWithMultipleID(
                    values: arr_ALL_Name_ID_For_FolowupInquiryByCustomerID,
                    context1: context,
                    controller: edt_InqNo,
                    controller2: edt_FollowupInquiryStatusType,
                    controllerID: edt_FollowupInquiryStatusTypepkID,
                    lable: "Select Inquiry No");
              },
              child: Container(
                margin: EdgeInsets.only(top:20,bottom: 20),
                child: TextFormField(
                    controller: edt_InqNo,
                    enabled: false,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                        border: UnderlineInputBorder(),
                        labelText: 'Inquiry No',
                        hintText: "Select Number"),
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF000000),
                    )),
              ),
            ),
          ),


          Visibility(
            visible: _isInqury_details_Exist,
            child: InkWell(
              onTap: () {
                _FollowupBloc.add(InquiryLeadStatusTypeListByNameCallEvent(
                    FollowupInquiryStatusTypeListRequest(
                        CompanyId: CompanyID.toString(),
                        pkID: "",
                        StatusCategory: "Inquiry",
                        LoginUserID: LoginUserID,
                        SearchKey: "")));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextFormField(
                    controller: edt_FollowupInquiryStatusType,
                    enabled: false,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                        border: UnderlineInputBorder(),
                        labelText: 'Inquiry Status',
                        hintText: "Select Status"),
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF000000),
                    )),
              ),
            ),
          ),


          Visibility(
            visible: is_closer_reasonVisible,
            child: InkWell(
              onTap: () {
                _FollowupBloc
                  ..add(CloserReasonTypeListByNameCallEvent(CloserReasonTypeListRequest(
                      CompanyId: CompanyID.toString(),
                      pkID: "",
                      StatusCategory: "DisQualifiedReason",
                      LoginUserID: LoginUserID,
                      SearchKey: "")));
              },
              child: Container(
                child: TextFormField(
                    controller: edt_CloserReasonStatusType,
                    enabled: false,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                        border: UnderlineInputBorder(),
                        labelText: 'Closer Reason',
                        hintText: "Select Reason"),
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF000000),
                    )),
              ),
            ),
          ),



          InkWell(
            onTap: () {
              // isAllEditable == true ? _onTapOfSearchView() : Container();

              _FollowupBloc.add(FollowupTypeListByNameCallEvent(FollowupTypeListRequest(
                  CompanyId: CompanyID.toString(),
                  pkID: "",
                  StatusCategory: "FollowUp",
                  LoginUserID: LoginUserID,
                  SearchKey: "")));
            },
            child: Container(
              margin: EdgeInsets.only(top:20,bottom: 20),
              child: TextFormField(
                  controller: edt_FollowupType,
                  enabled: false,
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                      border: UnderlineInputBorder(),
                      labelText: 'Followup Type',
                      hintText: "Select Type"),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  )),
            ),
          ),



          InkWell(
            onTap: () {

              showcustomdialogWithOnlyName(
                  values: arr_ALL_Name_ID_For_Folowup_Priority,
                  context1: context,
                  controller: edt_Priority,
                  lable: "Select Priority");
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                  controller: edt_Priority,
                  enabled: false,
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                      border: UnderlineInputBorder(),
                      labelText: 'Priority',
                      hintText: "Select Priority"),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  )),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text("Followup Notes *",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight
                        .bold)
            ),
          ),
          TextFormField(
            controller: edt_FollowupNotes,
            minLines: 2,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Enter Notes',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: new BorderSide(color: colorPrimary),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  _selectNextFollowupDate(context, edt_NextFollowupDate);
                },
                child: TextFormField(
                    controller: edt_NextFollowupDate,
                    enabled: false,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                        border: UnderlineInputBorder(),
                        labelText: 'Next Followup Date *',
                        hintText: "DD-MM-YYYY"),
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF000000),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _selectTime(context, edt_PreferedTime);
                },
                child: TextFormField(
                    controller: edt_PreferedTime,
                    enabled: false,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.watch_later_outlined),
                        border: UnderlineInputBorder(),
                        labelText: 'Preferred Time',
                        hintText: "HH:MM"),
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF000000),
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              setState(() {
                IsFollowpDetails = false;
              });
            },
            child: Card(
                elevation: 10,
                color: colorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  margin:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Center(
                    child: Text("Next",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                )),
          ),
        ],
      ),
    );
  }


  LeadStatus() {
    arr_ALL_Name_ID_For_LeadStatus.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Disqualified";
      } else if (i == 1) {
        all_name_id.Name = "Qualified";
      } else if (i == 2) {
        all_name_id.Name = "InProcess";
      }
      arr_ALL_Name_ID_For_LeadStatus.add(all_name_id);
    }
  }

  void _onDisQualifiedResonResult(CustomerSourceCallEventResponseState state) {
    arr_All_DisQualifiedList.clear();
    for (int i = 0; i < state.sourceResponse.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = state.sourceResponse.details[i].inquiryStatus;
      all_name_id.pkID = state.sourceResponse.details[i].pkID;
      arr_All_DisQualifiedList.add(all_name_id);
    }
    showcustomdialogWithID(
        values: arr_All_DisQualifiedList,
        context1: context,
        controller: edt_DisQualifiedName,
        controllerID: edt_DisQualifiedID,
        lable: "Select DisQualified Reason ");
  }


  LeadStatusDetails() {
    return Visibility(
      visible: isTelecallerFollowup,
      child: Container(
        child: Column(children: [
          GestureDetector(
            onTap: () =>  showcustomdialogWithOnlyName(
                values: arr_ALL_Name_ID_For_LeadStatus,
                context1: context,
                controller: edt_LeadStatus,
                lable: "Select Lead Status"),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text("Lead Status *",
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
                    color: colorTileBG,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      height: CardViewHeight,
                      padding:
                      EdgeInsets.only(left: 20, right: 20),
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                controller: edt_LeadStatus,
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: "Select Lead Status",
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
          ),
          isDisqualified == false ? LeadQualified() : Container(),
          isDisqualified == true
              ? LeadDisQualified()
              : Container(),
          // isDisqualified == false ? LeadInProcess() : Container(),
          SizedBox(
            width: 20,
            height: 15,
          ),
        ],),
      ),
    );
  }
  LeadDisQualified() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text("DisQualified Reason *",
                        style: TextStyle(
                            fontSize: 12,
                            color: colorPrimary,
                            fontWeight: FontWeight
                                .bold)
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () =>  _FollowupBloc.add(CustomerSourceCallEvent(
                        CustomerSourceRequest(
                            companyId: CompanyID,
                            StatusCategory: "DisQualifiedReason",
                            pkID: "",
                            LoginUserID: LoginUserID,
                            SearchKey: ""))),
                    child: Card(
                      elevation: 5,
                      color: colorTileBG,
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
                                  controller: edt_DisQualifiedName,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: "Select DisQualified Reason",
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
                            Icon(
                              Icons.arrow_drop_down,
                              color: colorGrayDark,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
  LeadQualified() {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>  showcustomdialogWithID(
                values: arr_All_Employee_List,
                context1: context,
                controller: edt_QualifiedEmplyeeName,
                controllerID: edt_QualifiedEmplyeeID,
                lable: "Select Employee "),
            child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text("Assign To *",
                          style: TextStyle(
                              fontSize: 12,
                              color: colorPrimary,
                              fontWeight: FontWeight
                                  .bold)
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 5,
                      color: colorTileBG,
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
                                  controller: edt_QualifiedEmplyeeName,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: "Select Assign To",
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
                            Icon(
                              Icons.arrow_drop_down,
                              color: colorGrayDark,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
  LeadInProcess() {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => showcustomdialogWithID(
                values: arr_All_Employee_List,
                context1: context,
                controller: edt_QualifiedEmplyeeName,
                controllerID: edt_QualifiedEmplyeeID,
                lable: "Select Employee ")
            ,
            child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text("Assign To *",
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
                      color: colorTileBG,
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
                                  controller: edt_QualifiedEmplyeeName,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: "Select Assign To",
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
                )),
          ),
          SizedBox(
            width: 20,
            height: 10,
          ),
        ],
      ),
    );
  }



  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse offlineALLEmployeeListData) {
    arr_All_Employee_List.clear();
    for (int i = 0; i < offlineALLEmployeeListData.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = offlineALLEmployeeListData.details[i].employeeName;
      all_name_id.pkID = offlineALLEmployeeListData.details[i].pkID;
      arr_All_Employee_List.add(all_name_id);
    }
  }

  void _onWhatsAppApi(WhatsAppApiResponseState state) {
    print("fcm_notification" +
        state.response.data.toString() +
        state.response.errorCode.toString() +
        state.response.errorMessage.toString());
  }

}
