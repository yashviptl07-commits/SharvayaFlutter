import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soleoserp/blocs/other/bloc_modules/attendance_employee/attendance_bloc.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/attendance/employee_attandance_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/dialog_utils.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/image_full_screen.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:table_calendar/table_calendar.dart';

// ─── Design tokens ───────────────────────────────────────────────────────────
const _kPrimary = Color(0xFF0066B3);
const _kAccent = Color(0xFF62BB47);
const _kSky = Color(0xFF108DCF);
const _kSurface = Color(0xFFF4F7FB);
const _kCard = Colors.white;
const _kTextDark = Color(0xFF1A2332);
const _kTextMid = Color(0xFF5B6F8A);
const _kTextLight = Color(0xFF9EB0C4);
const _kPunch = Color(0xFF0066B3);
const _kPunchOut = Color(0xFF62BB47);
const _kLunch = Color(0xFFFF8C42);
const _kWeekend = Color(0xFFE53935);
// ─────────────────────────────────────────────────────────────────────────────

class AttendanceListScreen extends BaseStatefulWidget {
  static const routeName = '/attendancelistscreen';

  @override
  _AttendanceListScreenState createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends BaseState<AttendanceListScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  AttendanceBloc _attendanceBloc;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  List<ALL_Name_ID> _listFilteredDistrict = [];
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  DateTime selectedDate;

  SharedPreferences prefs;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Attendance_EmplyeeList = [];
  final TextEditingController edt_AttendanceEmployeeList =
      TextEditingController();
  final TextEditingController edt_AttendanceUSERID = TextEditingController();
  final TextEditingController edt_AttendanceEmployeeID =
      TextEditingController();
  final TextEditingController edt_DateFilter = TextEditingController();

  bool isvisible_Out_time = false;
  bool isEnableAddEdit = false;
  int CompanyID = 0;
  String LoginUserID = "";
  String NetWorkImageURL = "";

  // Weekend config: 0 = no weekends, 1 = Sunday only, 2 = Sat+Sun
  int _weekendMode = 1;
  List<int> _weekendDays = [DateTime.sunday];

  // Animation
  AnimationController _animController;
  Animation<double> _fadeAnim;
  Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    selectedDate = DateTime.now();
    edt_DateFilter.text = DateTime.now().toString();

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    NetWorkImageURL =
        _offlineCompanyData.details[0].siteURL.toString() + "/attendenceimage/";
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _onAttendanceEmployeeListCallSuccess(_offlineFollowerEmployeeListData);

    screenStatusBarColor = _kPrimary;
    _attendanceBloc = AttendanceBloc(baseBloc);
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];

    prefsData();
    edt_AttendanceUSERID.text = LoginUserID;
    edt_AttendanceEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName.toString();
    edt_AttendanceEmployeeID.text =
        _offlineLoggedInData.details[0].employeeID.toString();
    edt_AttendanceUSERID.addListener(followerEmployeeList);

    getcurrentTimeInfo();
    _animController.forward();
    _loadAttendance();
  }

  /// Sets _weekendMode and _weekendDays together.
  void _applyWeekendMode(int mode) {
    _weekendMode = mode;
    if (mode == 0) {
      _weekendDays = [];
    } else if (mode == 1) {
      _weekendDays = [DateTime.sunday];
    } else {
      _weekendDays = [DateTime.saturday, DateTime.sunday];
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _loadAttendance() {
    _attendanceBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
        Month: "",
        Year: "",
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
  }

  prefsData() async {
    prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) => newMap[key.toString()] = map[key]);
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) => newMap[DateTime.parse(key)] = map[key]);
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _attendanceBloc,
      child: BlocConsumer<AttendanceBloc, AttendanceStates>(
        builder: (BuildContext context, AttendanceStates state) {
          return super.build(context);
        },
        buildWhen: (_, currentState) => false,
        listener: (context, state) {
          if (state is AttendanceListCallResponseState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _onInquiryListCallSuccess(state);
            });
          }
        },
        listenWhen: (_, currentState) =>
            currentState is AttendanceListCallResponseState,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: _kSurface,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: RefreshIndicator(
                color: _kPrimary,
                onRefresh: () async {
                  _attendanceBloc.add(AttendanceCallEvent(AttendanceApiRequest(
                      pkID: "",
                      EmployeeID:
                          _offlineLoggedInData.details[0].employeeID.toString(),
                      Month: "",
                      Year: "",
                      CompanyId: _offlineCompanyData.details[0].pkId.toString(),
                      LoginUserID: LoginUserID)));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildEmployeeSelector(),
                            const SizedBox(height: 16),
                            _buildCalendarCard(),
                            const SizedBox(height: 16),
                            if (isvisible_Out_time) _buildDetailsCard(),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_kSky, _kPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
              color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 6))
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
          child: Row(
            children: [
              Builder(
                builder: (ctx) => GestureDetector(
                  onTap: () => Scaffold.of(ctx).openDrawer(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.menu_rounded,
                        color: Colors.white, size: 22),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Attendance',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3)),
                    SizedBox(height: 2),
                    Text('Track your daily presence',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 12.5)),
                  ],
                ),
              ),
              _buildStatChip(),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => navigateTo(context, HomeScreen.routeName,
                    clearAllStack: true),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.home_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip() {
    final count = _events.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        const Icon(Icons.check_circle_outline_rounded,
            color: Colors.white, size: 15),
        const SizedBox(width: 5),
        Text('$count days',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }

  // ─── Employee Selector ───────────────────────────────────────────────────
  Widget _buildEmployeeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Employee',
            style: TextStyle(
                fontSize: 12,
                color: _kTextMid,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => showcustomdialogWithMultipleID(
              values: arr_ALL_Name_ID_For_Attendance_EmplyeeList,
              context1: context,
              controller: edt_AttendanceEmployeeList,
              controllerID: edt_AttendanceEmployeeID,
              controller2: edt_AttendanceUSERID,
              lable: "Select Employee"),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
                color: _kCard,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 12,
                      offset: Offset(0, 4))
                ]),
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [_kSky, _kPrimary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edt_AttendanceEmployeeList.text.isNotEmpty
                          ? edt_AttendanceEmployeeList.text
                          : 'Tap to select employee',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: edt_AttendanceEmployeeList.text.isNotEmpty
                              ? _kTextDark
                              : _kTextLight),
                    ),
                    if (edt_AttendanceEmployeeID.text.isNotEmpty)
                      Text('ID: ${edt_AttendanceEmployeeID.text}',
                          style:
                              const TextStyle(fontSize: 11, color: _kTextMid)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: _kSurface, borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  const Icon(Icons.swap_vert_rounded,
                      size: 14, color: _kPrimary),
                  const SizedBox(width: 4),
                  const Text('Change',
                      style: TextStyle(
                          fontSize: 11,
                          color: _kPrimary,
                          fontWeight: FontWeight.w600)),
                ]),
              )
            ]),
          ),
        ),
      ],
    );
  }

  // ─── Weekend Toggle Chips ────────────────────────────────────────────────
  Widget _buildWeekendToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          const Text('Weekends:',
              style: TextStyle(
                  fontSize: 12, color: _kTextMid, fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          _weekendChip('None', 0),
          const SizedBox(width: 6),
          _weekendChip('Sun', 1),
          const SizedBox(width: 6),
          _weekendChip('Sat+Sun', 2),
        ],
      ),
    );
  }

  Widget _weekendChip(String label, int mode) {
    final selected = _weekendMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _applyWeekendMode(mode)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? _kPrimary : _kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? _kPrimary : const Color(0xFFDDE3EC),
              width: 1.2),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : _kTextMid),
        ),
      ),
    );
  }

  // ─── Calendar Legend ─────────────────────────────────────────────────────
  Widget _buildCalendarLegend() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendDot(_kPunch, 'Punch In'),
          const SizedBox(width: 16),
          _legendDot(_kPunchOut, 'Punch Out'),
          if (_weekendMode > 0) ...[
            const SizedBox(width: 16),
            _legendDot(_kWeekend.withOpacity(0.7), 'Weekend',
                shape: BoxShape.rectangle),
          ],
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label,
      {BoxShape shape = BoxShape.circle}) {
    return Row(children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            color: color,
            shape: shape,
            borderRadius:
                shape == BoxShape.rectangle ? BorderRadius.circular(2) : null),
      ),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(fontSize: 11, color: _kTextMid)),
    ]);
  }

  // ─── Calendar Card ───────────────────────────────────────────────────────
  Widget _buildCalendarCard() {
    // Determine weekend text color
    final Color weekendTextColor =
        _weekendDays.isEmpty ? _kTextDark : _kWeekend;

    return Container(
      decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4))
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // ── Weekend toggle inside the card ──
            _buildWeekendToggle(),

            TableCalendar(
              initialSelectedDay: DateTime.now(),
              events: _events,
              endDay: DateTime.now(),

              // ── Dynamic weekend days ──
              weekendDays: _weekendDays,

              initialCalendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              calendarStyle: CalendarStyle(
                canEventMarkersOverflow: true,
                markersMaxAmount: 2,
                // Extra bottom cell padding so dots never get clipped
                cellMargin: const EdgeInsets.fromLTRB(4, 4, 4, 2),
                todayColor: _kPrimary.withOpacity(0.12),
                selectedColor: _kPrimary,
                todayStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: _kPrimary),
                selectedStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white),
                weekdayStyle: const TextStyle(fontSize: 13, color: _kTextDark),
                // Weekend text color driven by _weekendDays
                weekendStyle: TextStyle(fontSize: 13, color: weekendTextColor),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonVisible: false,
                titleTextStyle: const TextStyle(
                    color: _kTextDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
                leftChevronIcon:
                    const Icon(Icons.chevron_left, color: _kPrimary, size: 20),
                rightChevronIcon:
                    const Icon(Icons.chevron_right, color: _kPrimary, size: 20),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: const TextStyle(
                    color: _kTextMid,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
                // DOW weekend label color also driven by _weekendDays
                weekendStyle: TextStyle(
                    color: _weekendDays.isEmpty ? _kTextMid : _kWeekend,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events, holidays) {
                setState(() {
                  isEnableAddEdit = true;
                  _selectedEvents = events;
                  isvisible_Out_time = _selectedEvents.isNotEmpty;

                  if (_offlineLoggedInData.details[0].roleCode == 'admin' ||
                      _offlineLoggedInData.details[0].roleCode == 'hradmin') {
                    isEnableAddEdit = true;
                  } else {
                    final formatter = DateFormat('yyyy-MM-dd');
                    final currentday = formatter.format(DateTime.now());
                    final presentDate1 =
                        formatter.format(_controller.selectedDay);
                    if (DateTime.parse(presentDate1) ==
                        DateTime.parse(currentday)) {
                      isEnableAddEdit =
                          events.isEmpty || events[1].toString().isEmpty;
                    } else {
                      isEnableAddEdit = false;
                    }
                  }
                });

                if (events.isNotEmpty) _animController.forward(from: 0.6);
              },
              builders: CalendarBuilders(
                // ── Selected day ──
                selectedDayBuilder: (context, date, events) => Container(
                    // bottom:10 gives room for dots below the circle
                    margin: const EdgeInsets.fromLTRB(4, 4, 4, 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_kSky, _kPrimary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(date.day.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14))),

                // ── Today ──
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.fromLTRB(4, 4, 4, 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: _kPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _kPrimary, width: 1.5)),
                    child: Text(date.day.toString(),
                        style: const TextStyle(
                            color: _kPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14))),

                // ── Dots ──
                markersBuilder: (context, date, events, holidays) {
                  if (events.isEmpty) return [];

                  final hasIn =
                      events.isNotEmpty && events[0].toString().isNotEmpty;
                  final hasOut =
                      events.length > 1 && events[1].toString().isNotEmpty;

                  return [
                    Positioned(
                      bottom: 5,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (hasIn)
                            Container(
                              width: 6,
                              height: 6,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _kPunch,
                                // White outline so dots pop on any bg
                                border:
                                    Border.all(color: Colors.white, width: 0.8),
                              ),
                            ),
                          if (hasOut)
                            Container(
                              width: 6,
                              height: 6,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 1.5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _kPunchOut,
                                border:
                                    Border.all(color: Colors.white, width: 0.8),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
              calendarController: _controller,
            ),

            // ── Legend ──
            _buildCalendarLegend(),
          ],
        ),
      ),
    );
  }

  // ─── Details Card ─────────────────────────────────────────────────────────
  Widget _buildDetailsCard() {
    final hasOut =
        _selectedEvents.length > 1 && _selectedEvents[1].toString().isNotEmpty;
    final hasNotes =
        _selectedEvents.length > 2 && _selectedEvents[2].toString().isNotEmpty;
    final showLunch = _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208" ||
        _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "BINE-KARS-EDJT-CVPL";
    final hasLunchIn = showLunch &&
        _selectedEvents.length > 3 &&
        _selectedEvents[3].toString().isNotEmpty;
    final hasLunchOut = showLunch &&
        _selectedEvents.length > 4 &&
        _selectedEvents[4].toString().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [_kSky, _kPrimary],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat('EEEE, MMM d').format(_controller.selectedDay),
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: _kTextDark),
          ),
        ]),
        const SizedBox(height: 12),

        // ── Punch row ──
        Row(children: [
          Expanded(
            child: _buildTimeChip(
              label: 'Punch In',
              time: _selectedEvents.isNotEmpty
                  ? _selectedEvents[0].toString()
                  : '--:--',
              icon: Icons.login_rounded,
              color: _kPunch,
              onTap: () => _showImageDialog(
                  'Punch-In Image',
                  _selectedEvents.length > 5
                      ? _selectedEvents[5].toString()
                      : '',
                  _selectedEvents.length > 9
                      ? _selectedEvents[9].toString()
                      : ''),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTimeChip(
              label: 'Punch Out',
              time: hasOut ? _selectedEvents[1].toString() : '--:--',
              icon: Icons.logout_rounded,
              color: _kPunchOut,
              faded: !hasOut,
              onTap: hasOut
                  ? () => _showImageDialog(
                      'Punch-Out Image',
                      _selectedEvents.length > 6
                          ? _selectedEvents[6].toString()
                          : '',
                      _selectedEvents.length > 10
                          ? _selectedEvents[10].toString()
                          : '')
                  : null,
            ),
          ),
        ]),

        // ── Lunch row ──
        if (showLunch && (hasLunchIn || hasLunchOut)) ...[
          const SizedBox(height: 12),
          Row(children: [
            if (hasLunchIn)
              Expanded(
                child: _buildTimeChip(
                  label: 'Lunch In',
                  time: _selectedEvents[3].toString(),
                  icon: Icons.restaurant_rounded,
                  color: _kLunch,
                  onTap: () => _showImageDialog(
                      'Lunch-In Image',
                      _selectedEvents.length > 7
                          ? _selectedEvents[7].toString()
                          : '',
                      _selectedEvents.length > 11
                          ? _selectedEvents[11].toString()
                          : ''),
                ),
              ),
            if (hasLunchIn && hasLunchOut) const SizedBox(width: 12),
            if (hasLunchOut)
              Expanded(
                child: _buildTimeChip(
                  label: 'Lunch Out',
                  time: _selectedEvents[4].toString(),
                  icon: Icons.restaurant_menu_rounded,
                  color: _kLunch,
                  onTap: () => _showImageDialog(
                      'Lunch-Out Image',
                      _selectedEvents.length > 8
                          ? _selectedEvents[8].toString()
                          : '',
                      _selectedEvents.length > 12
                          ? _selectedEvents[12].toString()
                          : ''),
                ),
              ),
            if (hasLunchIn && !hasLunchOut) const Expanded(child: SizedBox()),
          ]),
        ],

        // ── Notes ──
        if (hasNotes) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: _kCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8F0FA), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 8,
                      offset: Offset(0, 2))
                ]),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: const Color(0xFFF0F6FF),
                    borderRadius: BorderRadius.circular(8)),
                child:
                    const Icon(Icons.notes_rounded, color: _kPrimary, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Notes',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _kTextMid,
                              letterSpacing: 0.3)),
                      const SizedBox(height: 3),
                      Text(_selectedEvents[2].toString(),
                          style: const TextStyle(
                              fontSize: 13, color: _kTextDark, height: 1.4)),
                    ]),
              ),
            ]),
          ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTimeChip({
    @required String label,
    @required String time,
    @required IconData icon,
    @required Color color,
    bool faded = false,
    VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: faded ? const Color(0xFFF8FAFC) : _kCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: faded ? const Color(0xFFEEF0F4) : color.withOpacity(0.2),
                width: 1.5),
            boxShadow: faded
                ? []
                : [
                    BoxShadow(
                        color: color.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color:
                      faded ? const Color(0xFFEEF0F4) : color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: faded ? _kTextLight : color, size: 15),
            ),
            const Spacer(),
            if (onTap != null)
              Icon(Icons.photo_camera_outlined,
                  color: color.withOpacity(0.6), size: 13),
          ]),
          const SizedBox(height: 10),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: faded ? _kTextLight : _kTextMid,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2)),
          const SizedBox(height: 3),
          Text(time,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: faded ? _kTextLight : color)),
        ]),
      ),
    );
  }

  void _showImageDialog(String title, String imageFileName, String address) {
    bool isImageExist = imageFileName.isNotEmpty && imageFileName != "null";
    final imageURL =
        isImageExist ? NetWorkImageURL + imageFileName : NO_ImageNetWorkURL;
    showDialog(
        context: context,
        builder: (_) => imageDialogForAttendance(
            title, imageURL, context, isImageExist, address));
  }

  static imageDialogForAttendance(
      text, path, context, bool isImageExist, String Address) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      backgroundColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              decoration: const BoxDecoration(
                color: Color(0xff0066b3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text ?? 'Image Details',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Body
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isImageExist && path != null && path.isNotEmpty)
                        Container(
                          height: 220,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xffF2F5FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: ImageFullScreenWrapperWidget(
                                child: Image.network(
                                  path,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, exception, stackTrace) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(NO_IMAGE_FOUND,
                                            height: 80, width: 80),
                                        const SizedBox(height: 8),
                                        Text("No Image Available",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade500)),
                                      ],
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: const Color(0xff0066b3),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text("Loading...",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade500)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xffF2F5FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported_outlined,
                                  size: 48, color: Colors.grey.shade400),
                              const SizedBox(height: 8),
                              Text("No Image Uploaded",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Address
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffF2F5FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 16, color: Color(0xff0066b3)),
                              const SizedBox(width: 8),
                              const Text("Address",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0066b3))),
                            ]),
                            const SizedBox(height: 8),
                            Text(
                              Address == null || Address.isEmpty
                                  ? "No Address Found"
                                  : Address,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── FABs ─────────────────────────────────────────────────────────────────
  Widget _buildFABs() {
    return FloatingActionButton(
      heroTag: "btn1",
      backgroundColor: _kPrimary,
      elevation: 4,
      onPressed: isEnableAddEdit ? _showAddDialog : null,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  // ─── Logic ────────────────────────────────────────────────────────────────
  void _onInquiryListCallSuccess(AttendanceListCallResponseState state) {
    _listFilteredDistrict.clear();
    final updatedEvents = <DateTime, List<dynamic>>{};

    for (var i = 0; i < state.response.details.length; i++) {
      final d = state.response.details[i];
      updatedEvents[DateTime.parse(d.presenceDate)] = [
        d.timeIn.toString(),
        d.timeOut.toString(),
        d.notes.toString(),
        d.LunchIn.toString(),
        d.LunchOut.toString(),
        d.ImageURL_In.toString(),
        d.ImageURL_OUT.toString(),
        d.LunchIMageURL_in.toString(),
        d.LunchIMageURL_Out.toString(),
        d.LocationAddress_IN.toString(),
        d.LocationAddress_OUT.toString(),
        d.LocationAddress_LunchIN.toString(),
        d.LocationAddress_LunchOUT.toString(),
      ];
    }

    _events = updatedEvents;
    if (prefs != null) {
      prefs.setString("events", json.encode(encodeMap(_events)));
    }

    if (mounted) setState(() {});
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _showAddDialog() {
    final formatter = DateFormat('yyyy-MM-dd');
    final currentday = formatter.format(DateTime.now());
    final presentDate1 = formatter.format(_controller.selectedDay);
    final presentDate =
        '${_controller.selectedDay.year}-${_controller.selectedDay.month}-${_controller.selectedDay.day}';

    void navigate() {
      navigateTo(context, AttendanceAdd_EditScreen.routeName,
              arguments: AddUpdateAttendanceArguments(
                  _selectedEvents, edt_AttendanceEmployeeID.text, presentDate))
          .then((value) {
        _attendanceBloc.add(AttendanceCallEvent(AttendanceApiRequest(
            pkID: "",
            EmployeeID: _offlineLoggedInData.details[0].employeeID.toString(),
            Month: "",
            Year: "",
            CompanyId: CompanyID.toString(),
            LoginUserID: LoginUserID)));
        if (value != null) _selectedEvents = value;
        _events[_controller.selectedDay] = [_selectedEvents];
        prefs.setString("events", json.encode(encodeMap(_events)));
      });
    }

    if (_offlineLoggedInData.details[0].roleCode == 'admin' ||
        _offlineLoggedInData.details[0].roleCode == 'hradmin') {
      navigate();
    } else if (DateTime.parse(presentDate1) == DateTime.parse(currentday)) {
      navigate();
    }
  }

  void _onAttendanceEmployeeListCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Attendance_EmplyeeList.clear();
    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID item = ALL_Name_ID();
        item.Name = state.details[i].employeeName;
        item.Name1 = state.details[i].userID;
        item.pkID = state.details[i].pkID;
        arr_ALL_Name_ID_For_Attendance_EmplyeeList.add(item);
      }
    }
  }

  void followerEmployeeList() {
    _attendanceBloc.add(AttendanceCallEvent(AttendanceApiRequest(
        pkID: "",
        EmployeeID: edt_AttendanceEmployeeID.text,
        Month: "",
        Year: "",
        CompanyId: CompanyID.toString(),
        LoginUserID: LoginUserID)));
    setState(() {});
  }

  void getcurrentTimeInfo() async {
    DateTime startDate = await NTP.now();
    print('NTP DateTime: $startDate ${DateTime.now()}');
  }
}
