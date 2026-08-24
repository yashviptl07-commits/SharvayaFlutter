import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/other/all_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/other/city_list_request.dart';
import 'package:soleoserp/models/api_requests/other/country_list_request.dart';
import 'package:soleoserp/models/api_requests/other/state_list_request.dart';
import 'package:soleoserp/models/api_requests/visitor_info_requests/visitor_info_add_update_requests.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/city_api_response.dart';
import 'package:soleoserp/models/api_responses/other/country_list_response.dart';
import 'package:soleoserp/models/api_responses/other/state_list_response.dart';
import 'package:soleoserp/models/api_responses/other/all_employee_List_response.dart';
import 'package:soleoserp/models/api_responses/visitor_info_response/visitor_info_list_response.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Visitor_Info_Screens/visitor_info_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:intl/intl.dart';

class VisitorInfoAddEditScreenArguments {
  VisitorInfoListApiResponseDetails editModel;
  VisitorInfoAddEditScreenArguments(this.editModel);
}

class VisitorInfoAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/VisitorInfoAddEditScreen';
  final VisitorInfoAddEditScreenArguments arguments;

  VisitorInfoAddEditScreen(this.arguments);

  @override
  _VisitorInfoAddEditScreenState createState() =>
      _VisitorInfoAddEditScreenState();
}

class _VisitorInfoAddEditScreenState extends BaseState<VisitorInfoAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  int CompanyID = 0;
  String LoginUserID = "";
  String SiteURL = "";
  bool _isForUpdate;
  int pkID = 0;
  VisitorInfoListApiResponseDetails _editModel;
  File _visitorImageFile;
  File _visitorDocumentFile;
  bool _isLoadingImage = false;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  static const String _defaultCountryName = "India";
  static const String _defaultCountryCode = "IND";

  // ── Text Editing Controllers ──────────────────────────────────────────────
  final TextEditingController edt_visitorNo = TextEditingController();
  final TextEditingController edt_visitorDate = TextEditingController();
  final TextEditingController edt_revVisitorDate = TextEditingController();
  final TextEditingController edt_visitorTime = TextEditingController();
  final TextEditingController edt_CustomerID = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_contactNo = TextEditingController();
  final TextEditingController edt_emailAddress = TextEditingController();
  final TextEditingController edt_visitorNotes = TextEditingController();
  final TextEditingController edt_departmentName = TextEditingController();
  final TextEditingController edt_departmentID = TextEditingController();
  final TextEditingController edt_meetingToID = TextEditingController();
  final TextEditingController edt_meetingToName = TextEditingController();
  final TextEditingController edt_companyName = TextEditingController();
  final TextEditingController edt_companyContact = TextEditingController();
  final TextEditingController edt_address = TextEditingController();
  final TextEditingController edt_countryName = TextEditingController();
  final TextEditingController edt_countryID = TextEditingController();
  final TextEditingController edt_stateName = TextEditingController();
  final TextEditingController edt_stateID = TextEditingController();
  final TextEditingController edt_cityName = TextEditingController();
  final TextEditingController edt_cityID = TextEditingController();
  final TextEditingController edt_pinCode = TextEditingController();

  // ── Dropdown caches ───────────────────────────────────────────────────────
  List<Details> arr_ALL_Name_ID_For_Employee = [];
  List<SearchCountryDetails> arr_ALL_Name_ID_For_Country = [];
  List<SearchStateDetails> arr_ALL_Name_ID_For_State = [];
  List<SearchCityDetails> arr_ALL_Name_ID_For_City = [];

  // ── Load-tracking flags ───────────────────────────────────────────────────

  /// Country code whose states are currently stored in [arr_ALL_Name_ID_For_State].
  String _cachedStateCountryCode = "";

  /// A StateCallEvent is currently in-flight.
  bool _isFetchingStates = false;

  /// A CityCallEvent is currently in-flight.
  bool _isFetchingCities = false;

  /// Open the state sheet as soon as the next state-response lands.
  bool _pendingShowStateSheet = false;

  /// Open the city sheet as soon as the next city-response lands.
  bool _pendingShowCitySheet = false;

  // ═══════════════════════════════════════════════════════════════════════════
  //  LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    _mainBloc = MainBloc(baseBloc);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;
    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      // ── Defaults ──────────────────────────────────────────────────────────
      edt_visitorDate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
      edt_revVisitorDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      edt_visitorTime.text = DateFormat('HH:mm').format(DateTime.now());
      edt_countryName.text = _defaultCountryName;
      edt_countryID.text = _defaultCountryCode;

      // ── Pre-fetch Indian states ───────────────────────────────────────────
      // addPostFrameCallback guarantees the BlocConsumer listener is fully
      // registered before we dispatch the event, so the response is never lost.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _fetchStatesForCountry(_defaultCountryCode, pendingShow: false);
        }
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  BLoC WIRING
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (ctx, _) => super.build(ctx),
        buildWhen: (_, __) => false,
        listener: _onBlocState,
        listenWhen: (_, current) =>
            current is VisitorInfoAddUpdateCallResponseState ||
            current is ALL_EmployeeNameListResponseState ||
            current is CountryListEventResponseState ||
            current is StateListEventResponseState ||
            current is CityListEventResponseState,
      ),
    );
  }

  void _onBlocState(BuildContext context, MainStates state) {
    if (state is VisitorInfoAddUpdateCallResponseState) {
      _onVisitorInfoAddUpdateResponseState(state);
    } else if (state is ALL_EmployeeNameListResponseState) {
      _onALL_EmployeeNameListResponseState(state);
    } else if (state is CountryListEventResponseState) {
      _onCountryListEventResponseState(state);
    } else if (state is StateListEventResponseState) {
      _onStateListEventResponseState(state);
    } else if (state is CityListEventResponseState) {
      _onCityListEventResponseState(state);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  BODY
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 25),
            onPressed: () => navigateTo(
                context, VisitorInfoListScreen.routeName,
                clearAllStack: true),
          ),
          title: Text(
            _isForUpdate ? 'Edit Visitor Info' : 'Add Visitor Info',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          backgroundColor: colorVeryLightGray,
          foregroundColor: colorPrimary,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.home_filled, color: Colors.black, size: 25),
              onPressed: () => navigateTo(context, HomeScreen.routeName,
                  clearAllStack: true),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTextFieldWithLabel("Visitor No", edt_visitorNo,
                  hint: "Auto-generated",
                  enabled: false,
                  icon: Icons.confirmation_num),
              SizedBox(height: 15),
              _buildDateField("Visitor Date", edt_visitorDate,
                  icon: Icons.calendar_today, isRequired: true),
              SizedBox(height: 15),
              _buildTimeField("Visitor Time", edt_visitorTime,
                  icon: Icons.access_time, isRequired: true),
              SizedBox(height: 15),
              _buildTextFieldWithLabel("Visitor Name", edt_CustomerName,
                  hint: "Enter visitor name",
                  icon: Icons.person,
                  isRequired: true),
              SizedBox(height: 15),
              _buildTextFieldWithLabel("Contact No", edt_contactNo,
                  hint: "Enter contact number",
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone,
                  isRequired: true),
              SizedBox(height: 15),
              _buildTextFieldWithLabel("Email Address", edt_emailAddress,
                  hint: "Enter email address",
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email),
              SizedBox(height: 15),
              _buildDropdownField(
                "Meeting To",
                edt_meetingToName,
                edt_meetingToID,
                "---Select Meeting To---",
                icon: Icons.flag,
                isRequired: true,
                onTap: _getMeetingToTapHandler(),
              ),
              SizedBox(height: 15),
              _buildTextFieldWithLabel("Visitor Notes", edt_visitorNotes,
                  hint: "Enter purpose of visit/notes",
                  maxLines: 3,
                  icon: Icons.note,
                  isRequired: true),
              SizedBox(height: 15),

              // ── Company Details ───────────────────────────────────────────
              _buildSectionHeader("Company Details"),
              SizedBox(height: 10),
              _buildTextFieldWithLabel("Company Name", edt_companyName,
                  hint: "Enter company name",
                  icon: Icons.business,
                  isRequired: true),
              SizedBox(height: 15),
              _buildTextFieldWithLabel("Company Contact", edt_companyContact,
                  hint: "Enter company contact",
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone),
              SizedBox(height: 15),
              _buildTextFieldWithLabel("Address", edt_address,
                  hint: "Enter address",
                  maxLines: 2,
                  icon: Icons.location_on,
                  isRequired: true),
              SizedBox(height: 15),
              _buildDropdownField(
                "Country",
                edt_countryName,
                edt_countryID,
                "Country",
                icon: Icons.flag,
                onTap: _getCountryTapHandler(),
              ),
              SizedBox(height: 15),
              _buildDropdownField(
                "State",
                edt_stateName,
                edt_stateID,
                "State",
                icon: Icons.map,
                onTap: _getStateTapHandler(),
              ),
              SizedBox(height: 15),
              _buildDropdownField(
                "City",
                edt_cityName,
                edt_cityID,
                "City",
                icon: Icons.location_city,
                onTap: _getCityTapHandler(),
              ),
              SizedBox(height: 15),
              _buildTextFieldWithLabel("Pin Code", edt_pinCode,
                  hint: "Enter pin code",
                  keyboardType: TextInputType.number,
                  icon: Icons.pin),
              SizedBox(height: 20),

              // ── Images ───────────────────────────────────────────────────
              _buildSectionHeaderRequired("Visitor Images"),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageContainer(
                    "Visitor Image",
                    _visitorImageFile,
                    () => _pickImage(0),
                    (_editModel?.visitorImage?.isNotEmpty ?? false)
                        ? "$SiteURL${_editModel.visitorImage}"
                        : null,
                  ),
                  _buildImageContainer(
                    "Visitor Document",
                    _visitorDocumentFile,
                    () => _pickImage(1),
                    (_editModel?.visitorDocument?.isNotEmpty ?? false)
                        ? "$SiteURL${_editModel.visitorDocument}"
                        : null,
                  ),
                ],
              ),
              SizedBox(height: 30),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onTapOfSaveVisitorInfoAPICall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Text(
                    _isForUpdate ? "Update" : "Save",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  WIDGET BUILDERS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLabel(String label, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4),
      child: RichText(
        text: TextSpan(
          text: label,
          style: TextStyle(
              fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600),
          children: isRequired
              ? [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
          color: colorPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Text(title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: colorPrimary)),
    );
  }

  Widget _buildSectionHeaderRequired(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
          color: colorPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: RichText(
        text: TextSpan(
          text: title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: colorPrimary),
          children: [
            TextSpan(
              text: ' *',
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(
    String label,
    TextEditingController controller, {
    String hint,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    int maxLines = 1,
    IconData icon,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          color: enabled ? Colors.white : Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: colorPrimary, size: 20),
                  SizedBox(width: 10),
                ],
                Expanded(
                  child: TextField(
                    enabled: enabled,
                    controller: controller,
                    keyboardType: keyboardType,
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      color: enabled ? Colors.black87 : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    TextEditingController controller, {
    IconData icon,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        InkWell(
          onTap: () => _selectDate(context, controller),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: colorPrimary, size: 20),
                    SizedBox(width: 10),
                  ],
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "DD-MM-YYYY",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                  Icon(Icons.calendar_month, color: colorPrimary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(
    String label,
    TextEditingController controller, {
    IconData icon,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        InkWell(
          onTap: () => _selectTime(context, controller),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: colorPrimary, size: 20),
                    SizedBox(width: 10),
                  ],
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "HH:MM",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                  Icon(Icons.access_time, color: colorPrimary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    TextEditingController nameController,
    TextEditingController idController,
    String apiName, {
    IconData icon,
    VoidCallback onTap,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        InkWell(
          onTap: onTap,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: colorPrimary, size: 20),
                    SizedBox(width: 10),
                  ],
                  Expanded(
                    child: TextField(
                      enabled: false,
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Select $label",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                  nameController.text.isNotEmpty
                      ? InkWell(
                          onTap: () => _clearDropdownField(
                            nameController: nameController,
                            idController: idController,
                            apiName: apiName,
                          ),
                          child: Icon(Icons.close, color: Colors.red),
                        )
                      : Icon(Icons.arrow_drop_down, color: colorPrimary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
      edt_revVisitorDate.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      controller.text =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _pickImage(int type) async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Pick from Gallery'),
              onTap: () async {
                Navigator.pop(ctx);
                final f = await picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 80);
                if (f != null) {
                  setState(() => type == 0
                      ? _visitorImageFile = File(f.path)
                      : _visitorDocumentFile = File(f.path));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(ctx);
                final f = await picker.pickImage(
                    source: ImageSource.camera, imageQuality: 80);
                if (f != null) {
                  setState(() => type == 0
                      ? _visitorImageFile = File(f.path)
                      : _visitorDocumentFile = File(f.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.black87,
      duration: Duration(seconds: 2),
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  CENTRALIZED FETCH HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  void _fetchStatesForCountry(String countryCode, {bool pendingShow = false}) {
    _isFetchingStates = true;
    if (pendingShow) _pendingShowStateSheet = true;
    _mainBloc.add(StateCallEvent(
      StateListRequest(
        CompanyId: CompanyID.toString(),
        CountryCode: countryCode,
        word: "",
        Search: "",
      ),
    ));
  }

  void _fetchCitiesForState(String stateCode, {bool pendingShow = false}) {
    _isFetchingCities = true;
    if (pendingShow) _pendingShowCitySheet = true;
    _mainBloc.add(CityCallEvent(
      CityApiRequest(
        StateCode: stateCode,
        CompanyID: CompanyID.toString(),
        CityName: "",
      ),
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  DROPDOWN TAP HANDLERS
  // ═══════════════════════════════════════════════════════════════════════════

  VoidCallback _getMeetingToTapHandler() {
    return () {
      _mainBloc.add(ALLEmployeeNameCallEvent(
          ALLEmployeeNameRequest(CompanyId: CompanyID.toString())));
    };
  }

  VoidCallback _getCountryTapHandler() {
    return () {
      _mainBloc.add(CountryCallEvent(CountryListRequest(
          CountryCode: "", CompanyID: CompanyID.toString())));
    };
  }

  VoidCallback _getStateTapHandler() {
    return () {
      final countryCode = edt_countryID.text.trim();

      // ── Guard ─────────────────────────────────────────────────────────────
      if (countryCode.isEmpty) {
        showSnackBar("Please select a country first");
        return;
      }

      // ── Case 1: states already cached for this country → show immediately ─
      if (arr_ALL_Name_ID_For_State.isNotEmpty &&
          _cachedStateCountryCode == countryCode) {
        _showStateSelectionSheet();
        return;
      }

      // ── Case 2: a fetch is in-flight → mark pending and notify the user ───
      // The response handler will open the sheet automatically.
      if (_isFetchingStates) {
        _pendingShowStateSheet = true;
        showSnackBar("Loading states, please wait…");
        return;
      }

      // ── Case 3: nothing cached, nothing in-flight → start fetch now ───────
      _fetchStatesForCountry(countryCode, pendingShow: true);
    };
  }

  VoidCallback _getCityTapHandler() {
    return () {
      final stateCode = edt_stateID.text.trim();

      // ── Guard ─────────────────────────────────────────────────────────────
      if (stateCode.isEmpty) {
        showSnackBar("Please select a state first");
        return;
      }

      // ── Case 1: cities already cached → show immediately ──────────────────
      if (arr_ALL_Name_ID_For_City.isNotEmpty) {
        _showCitySelectionSheet();
        return;
      }

      // ── Case 2: fetch in-flight ────────────────────────────────────────────
      if (_isFetchingCities) {
        _pendingShowCitySheet = true;
        showSnackBar("Loading cities, please wait…");
        return;
      }

      // ── Case 3: fetch now ──────────────────────────────────────────────────
      _fetchCitiesForState(stateCode, pendingShow: true);
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SELECTION SHEET OPENERS
  // ═══════════════════════════════════════════════════════════════════════════

  void _showStateSelectionSheet() {
    _showSelectionBottomSheet<SearchStateDetails>(
      title: "Select State",
      items: arr_ALL_Name_ID_For_State,
      getName: (item) => item.label,
      onItemSelected: (item) {
        setState(() {
          edt_stateName.text = item.label;
          edt_stateID.text = item.value.toString();
          edt_cityName.clear();
          edt_cityID.clear();
          arr_ALL_Name_ID_For_City.clear();
        });
        // Silently pre-load cities for this state
        _fetchCitiesForState(item.value.toString(), pendingShow: false);
      },
    );
  }

  void _showCitySelectionSheet() {
    _showSelectionBottomSheet<SearchCityDetails>(
      title: "Select City",
      items: arr_ALL_Name_ID_For_City,
      getName: (item) => item.cityName,
      onItemSelected: (item) {
        setState(() {
          edt_cityName.text = item.cityName;
          edt_cityID.text = item.cityCode.toString();
        });
      },
    );
  }

  void _clearDropdownField({
    TextEditingController nameController,
    TextEditingController idController,
    String apiName,
  }) {
    setState(() {
      nameController.clear();
      idController.clear();
      if (apiName == "Country") {
        edt_stateName.clear();
        edt_stateID.clear();
        edt_cityName.clear();
        edt_cityID.clear();
        arr_ALL_Name_ID_For_State.clear();
        arr_ALL_Name_ID_For_City.clear();
        _cachedStateCountryCode = "";
      } else if (apiName == "State") {
        edt_cityName.clear();
        edt_cityID.clear();
        arr_ALL_Name_ID_For_City.clear();
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  BLoC RESPONSE HANDLERS
  // ═══════════════════════════════════════════════════════════════════════════

  void _onALL_EmployeeNameListResponseState(
      ALL_EmployeeNameListResponseState state) {
    arr_ALL_Name_ID_For_Employee = state.all_employeeList_Response.details;
    _showSelectionBottomSheet<Details>(
      title: "Select Person",
      items: arr_ALL_Name_ID_For_Employee,
      getName: (item) => item.employeeName,
      onItemSelected: (item) {
        setState(() {
          edt_meetingToID.text = item.pkID.toString();
          edt_meetingToName.text = item.employeeName;
        });
      },
    );
  }

  void _onCountryListEventResponseState(CountryListEventResponseState state) {
    arr_ALL_Name_ID_For_Country = state.countrylistresponse.details;
    _showSelectionBottomSheet<SearchCountryDetails>(
      title: "Select Country",
      items: arr_ALL_Name_ID_For_Country,
      getName: (item) => item.countryName,
      onItemSelected: (item) {
        setState(() {
          edt_countryName.text = item.countryName;
          edt_countryID.text = item.countryCode;
          // Clear dependent fields
          edt_stateName.clear();
          edt_stateID.clear();
          edt_cityName.clear();
          edt_cityID.clear();
          arr_ALL_Name_ID_For_State.clear();
          arr_ALL_Name_ID_For_City.clear();
          _cachedStateCountryCode = "";
        });
        // Silently pre-load states for the newly selected country
        _fetchStatesForCountry(item.countryCode, pendingShow: false);
      },
    );
  }

  void _onStateListEventResponseState(StateListEventResponseState state) {
    // Cache states and record which country they belong to
    arr_ALL_Name_ID_For_State = state.statelistresponse.details;
    _cachedStateCountryCode = edt_countryID.text.trim();
    _isFetchingStates = false;

    // Open the sheet only when the user is actively waiting for it
    if (_pendingShowStateSheet) {
      _pendingShowStateSheet = false;
      _showStateSelectionSheet();
    }
  }

  void _onCityListEventResponseState(CityListEventResponseState state) {
    arr_ALL_Name_ID_For_City = state.cityApiRespose.details;
    _isFetchingCities = false;

    // Open the sheet only when the user is actively waiting for it
    if (_pendingShowCitySheet) {
      _pendingShowCitySheet = false;
      _showCitySelectionSheet();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  GENERIC SELECTION BOTTOM SHEET
  // ═══════════════════════════════════════════════════════════════════════════

  void _showSelectionBottomSheet<T>({
    String title,
    List<T> items,
    String Function(T) getName,
    Function(T) onItemSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        List<T> filtered = List.from(items);
        final searchCtrl = TextEditingController();

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              height: MediaQuery.of(ctx).size.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),

                  // Search
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        hintText: "Search $title...",
                        prefixIcon: Icon(Icons.search, color: colorPrimary),
                        suffixIcon: searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  searchCtrl.clear();
                                  setModalState(
                                      () => filtered = List.from(items));
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      onChanged: (v) {
                        setModalState(() {
                          filtered = v.isEmpty
                              ? List.from(items)
                              : items
                                  .where((e) => getName(e)
                                      .toLowerCase()
                                      .contains(v.toLowerCase()))
                                  .toList();
                        });
                      },
                    ),
                  ),

                  // List
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off,
                                    size: 50, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  searchCtrl.text.isEmpty
                                      ? "No items available"
                                      : "No results for '${searchCtrl.text}'",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final item = filtered[i];
                              return ListTile(
                                title: Text(getName(item),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black87)),
                                trailing: Icon(Icons.chevron_right,
                                    color: Colors.grey),
                                onTap: () {
                                  onItemSelected(item);
                                  Navigator.pop(ctx);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SAVE / UPDATE
  // ═══════════════════════════════════════════════════════════════════════════

  void _onTapOfSaveVisitorInfoAPICall() {
    if (edt_visitorDate.text.trim().isEmpty) {
      showSnackBar("Visitor Date is required");
      return;
    }
    if (edt_visitorTime.text.trim().isEmpty) {
      showSnackBar("Visitor Time is required");
      return;
    }
    if (edt_CustomerName.text.trim().isEmpty) {
      showSnackBar("Visitor Name is required");
      return;
    }
    if (edt_contactNo.text.trim().isEmpty) {
      showSnackBar("Contact Number is required");
      return;
    }
    if (edt_meetingToName.text.trim().isEmpty) {
      showSnackBar("Meeting To is required");
      return;
    }
    if (edt_visitorNotes.text.trim().isEmpty) {
      showSnackBar("Visitor Notes is required");
      return;
    }
    if (edt_companyName.text.trim().isEmpty) {
      showSnackBar("Company Name is required");
      return;
    }
    if (edt_address.text.trim().isEmpty) {
      showSnackBar("Address is required");
      return;
    }

    final bool imgOk = _visitorImageFile != null ||
        (_isForUpdate && (_editModel?.visitorImage?.isNotEmpty ?? false));
    final bool docOk = _visitorDocumentFile != null ||
        (_isForUpdate && (_editModel?.visitorDocument?.isNotEmpty ?? false));
    if (!imgOk) {
      showSnackBar("Visitor Image is required");
      return;
    }
    if (!docOk) {
      showSnackBar("Visitor Document is required");
      return;
    }

    showCommonDialogWithTwoOptions(
      context,
      _isForUpdate
          ? "Are you sure you want to update this visitor info?"
          : "Are you sure you want to save this visitor info?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.of(context).pop();
        _callVisitorInfoAddUpdateAPI();
      },
    );
  }

  void _onVisitorInfoAddUpdateResponseState(
      VisitorInfoAddUpdateCallResponseState state) {
    final message = state.response.details[0].column2;
    showCommonDialogWithSingleOption(context, message,
        positiveButtonTitle: "OK",
        onTapOfPositiveButton: () => navigateTo(
            context, VisitorInfoListScreen.routeName,
            clearAllStack: true));
  }

  void _callVisitorInfoAddUpdateAPI() {
    String v(String val) =>
        (val == null || val.trim().isEmpty) ? "" : val.trim();

    String visitDate = edt_revVisitorDate.text.trim();
    if (visitDate.isEmpty) {
      visitDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    _mainBloc.add(VisitorInfoAddUpdateCallRequestEvent(
      VisitorInfoAddUpdateApiRequest(
        pkID: _isForUpdate ? pkID.toString() : "0",
        InquiryNo: v(edt_visitorNo.text),
        VisitDate: visitDate,
        VisitTime: v(edt_visitorTime.text),
        VisitorName: v(edt_CustomerName.text),
        VisitorContact: v(edt_contactNo.text),
        VisitorEmail: v(edt_emailAddress.text),
        PurposeOfVisit: v(edt_visitorNotes.text),
        CustomerID: "0",
        CompanyName: v(edt_companyName.text),
        CompanyContact: v(edt_companyContact.text),
        Address: v(edt_address.text),
        City: v(edt_cityID.text),
        State: v(edt_stateID.text),
        Pincode: v(edt_pinCode.text),
        Country: v(edt_countryID.text),
        EmployeeID: "0",
        Department: v(edt_departmentName.text),
        MeetingTo: v(edt_meetingToName.text),
        LoginUserID: LoginUserID,
        CompanyId: CompanyID.toString(),
        VisitorImage: _visitorImageFile,
        VisitorDocument: _visitorDocumentFile,
      ),
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  FILL DATA  (edit mode)
  // ═══════════════════════════════════════════════════════════════════════════

  void fillData() async {
    setState(() => _isLoadingImage = true);
    try {
      pkID = _editModel.pkID;
      edt_visitorNo.text = _editModel.inquiryNo ?? "";

      // ── Date ──────────────────────────────────────────────────────────────
      if (_editModel.visitDate?.isNotEmpty ?? false) {
        try {
          String raw = _editModel.visitDate.trim().split('T')[0];
          if (raw.contains(' ')) raw = raw.split(' ')[0];
          DateTime parsed;
          for (final fmt in ['yyyy-MM-dd', 'dd-MM-yyyy', 'dd/MM/yyyy']) {
            try {
              parsed = DateFormat(fmt).parseStrict(raw);
              break;
            } catch (_) {}
          }
          parsed ??= DateTime.parse(raw);
          edt_visitorDate.text = DateFormat('dd-MM-yyyy').format(parsed);
          edt_revVisitorDate.text = DateFormat('yyyy-MM-dd').format(parsed);
        } catch (_) {
          edt_visitorDate.text = _editModel.visitDate;
          edt_revVisitorDate.text = _editModel.visitDate;
        }
      }

      // ── Time ──────────────────────────────────────────────────────────────
      if (_editModel.visitTime?.isNotEmpty ?? false) {
        try {
          final raw = _editModel.visitTime.trim();
          DateTime parsed;
          for (final fmt in ['HH:mm', 'HH:mm:ss', 'hh:mm a', 'HH:mm:ss.SSS']) {
            try {
              parsed = DateFormat(fmt).parseStrict(raw);
              break;
            } catch (_) {}
          }
          parsed ??= DateTime.parse("2000-01-01 $raw");
          edt_visitorTime.text = DateFormat('hh:mm a').format(parsed);
        } catch (_) {
          edt_visitorTime.text = _editModel.visitTime;
        }
      }

      edt_CustomerID.text = _editModel.customerID?.toString() ?? "0";
      edt_CustomerName.text = _editModel.visitorName ?? "";
      edt_contactNo.text = _editModel.visitorContact ?? "";
      edt_emailAddress.text = _editModel.visitorEmail ?? "";
      edt_visitorNotes.text = _editModel.purposeOfVisit ?? "";
      edt_departmentName.text = _editModel.department ?? "";
      edt_meetingToName.text = _editModel.meetingTo ?? "";
      edt_companyName.text = _editModel.companyName ?? "";
      edt_companyContact.text = _editModel.companyContact ?? "";
      edt_address.text = _editModel.address ?? "";
      edt_countryName.text = _editModel.countryName ?? "";
      edt_countryID.text = _editModel.country?.toString() ?? "";
      edt_stateName.text = _editModel.stateName ?? "";
      edt_stateID.text = _editModel.state?.toString() ?? "";
      edt_cityName.text = _editModel.cityName ?? "";
      edt_cityID.text = _editModel.city?.toString() ?? "";
      edt_pinCode.text = _editModel.pincode ?? "";

      // Silently pre-load states & cities (post-frame so listener is active)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (edt_countryID.text.isNotEmpty) {
          _fetchStatesForCountry(edt_countryID.text.trim(), pendingShow: false);
        }
        if (edt_stateID.text.isNotEmpty) {
          _fetchCitiesForState(edt_stateID.text.trim(), pendingShow: false);
        }
      });

      // Load images
      if (_editModel.visitorImage?.isNotEmpty ?? false) {
        _loadImageFromUrl(_editModel.visitorImage, isVisitorImage: true);
      }
      if (_editModel.visitorDocument?.isNotEmpty ?? false) {
        _loadImageFromUrl(_editModel.visitorDocument, isVisitorImage: false);
      }
    } catch (e) {
      print("Error filling data: $e");
    } finally {
      setState(() => _isLoadingImage = false);
    }
  }

  Future<void> _loadImageFromUrl(String imageUrl,
      {bool isVisitorImage = true}) async {
    try {
      final String fullUrl = imageUrl.startsWith('http')
          ? imageUrl
          : imageUrl.startsWith('/')
              ? "$SiteURL$imageUrl"
              : "$SiteURL/images/$imageUrl";

      final response = await http.get(Uri.parse(fullUrl),
          headers: {'Accept': 'image/*'}).timeout(Duration(seconds: 30));

      if (response.statusCode == 200 && mounted) {
        final dir = await getTemporaryDirectory();
        final fileName = path.basename(imageUrl);
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        setState(() => isVisitorImage
            ? _visitorImageFile = file
            : _visitorDocumentFile = file);
      }
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, VisitorInfoListScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  IMAGE CONTAINER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildImageContainer(
      String label, File imageFile, Function onTap, String imageUrl) {
    final bool hasImage = imageFile != null || imageUrl != null;
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                  color: hasImage ? colorPrimary : Colors.grey.shade300,
                  width: 2),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _isLoadingImage
                  ? Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(colorPrimary)))
                  : imageFile != null
                      ? Image.file(imageFile, fit: BoxFit.cover)
                      : imageUrl != null
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, child, progress) {
                                if (progress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) =>
                                  _imagePlaceholder(label),
                            )
                          : _imagePlaceholder(label),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder(String label) {
    final bool isPhoto = label.contains("Image");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isPhoto ? Icons.add_a_photo : Icons.attach_file,
              size: 30, color: Colors.grey),
          SizedBox(height: 8),
          Text("Add ${isPhoto ? 'Photo' : 'Document'}",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
