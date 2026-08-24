import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/visitor_info_requests/visitor_info_delete_requests.dart';
import 'package:soleoserp/models/api_requests/visitor_info_requests/visitor_info_list_requests.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/api_responses/visitor_info_response/visitor_info_list_response.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Visitor_Info_Screens/visitor_info_add_update_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitorInfoListScreen extends BaseStatefulWidget {
  static const routeName = '/VisitorInfoListScreen';

  @override
  _VisitorInfoListScreenState createState() => _VisitorInfoListScreenState();
}

class _VisitorInfoListScreenState extends BaseState<VisitorInfoListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  VisitorInfoListApiResponse _visitorInfoListApiResponse;
  int _pageNo = 1;
  bool hasMoreData = true;
  final int pageSize = 10;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  MenuRightsResponse _menuRightsResponse;

  final TextEditingController edt_Search = TextEditingController();
  bool _isSearching = false;

  int CompanyID = 0;
  String LoginUserID = "";
  String SiteURL = "";
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;
  int TotalCount = 0;
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _mainBloc = MainBloc(baseBloc);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;

    getUserRights(_menuRightsResponse);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc
        ..add(VisitorInfoListCallRequestEvent(
          1,
          VisitorInfoListApiRequest(
            pkID: "0",
            LoginUserID: LoginUserID,
            SearchKey: "",
            PageNo: "1",
            PageSize: pageSize.toString(),
            CompanyId: CompanyID.toString(),
          ),
        )),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is VisitorInfoListCallResponseState) {
            _onVisitorInfoListCallResponseState(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return currentState is VisitorInfoListCallResponseState ||
              currentState is UserMenuRightsResponseState;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is VisitorInfoDeleteCallResponseState) {
            _onVisitorInfoDeleteCallResponseState(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          return currentState is VisitorInfoDeleteCallResponseState;
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
          title: _isSearching
              ? TextField(
                  controller: edt_Search,
                  autofocus: true,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: "Search Visitors...",
                    hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    _onSearchChanged(value);
                  },
                )
              : Text(
                  'Visitor Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 0.5,
                  ),
                ),
          gradient: LinearGradient(
            colors: [
              Color(0xff108dcf),
              Color(0xff0066b3),
              Color(0xff62bb47),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          elevation: 4,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              navigateTo(context, HomeScreen.routeName, clearAllStack: true);
            },
          ),
          actions: <Widget>[
            _isSearching
                ? IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        edt_Search.clear();
                        _onSearchChanged("");
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.search, color: Colors.white, size: 28),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
            if (IsAddRights && !_isSearching)
              IconButton(
                icon: Icon(Icons.add_circle_outline,
                    color: Colors.white, size: 28),
                onPressed: () async {
                  navigateTo(context, VisitorInfoAddEditScreen.routeName,
                      clearAllStack: true);
                },
              ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _pageNo = 1;
                    _visitorInfoListApiResponse = null;
                    hasMoreData = true;
                    _mainBloc.add(VisitorInfoListCallRequestEvent(
                      1,
                      VisitorInfoListApiRequest(
                        pkID: "0",
                        LoginUserID: LoginUserID,
                        SearchKey: edt_Search.text,
                        PageNo: "1",
                        PageSize: pageSize.toString(),
                        CompanyId: CompanyID.toString(),
                      ),
                    ));
                  },
                  color: colorPrimary,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: _buildVisitorList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchChanged(String searchKey) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _pageNo = 1;
      _visitorInfoListApiResponse = null;
      hasMoreData = true;
      _mainBloc.add(
        VisitorInfoListCallRequestEvent(
          1,
          VisitorInfoListApiRequest(
            pkID: "0",
            LoginUserID: LoginUserID,
            SearchKey: searchKey,
            PageNo: "1",
            PageSize: pageSize.toString(),
            CompanyId: CompanyID.toString(),
          ),
        ),
      );
    });
  }

  void _onVisitorInfoListCallResponseState(
      VisitorInfoListCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _visitorInfoListApiResponse = state.response;
      } else {
        _visitorInfoListApiResponse.details.addAll(state.response.details);
      }
      if (_visitorInfoListApiResponse.details.isNotEmpty) {
        TotalCount = state.response.totalCount;
      } else {
        TotalCount = 0;
      }
      _pageNo = state.newPage;
    }
  }

  void _onVisitorListPagination() {
    if (_visitorInfoListApiResponse.details.length <
        _visitorInfoListApiResponse.totalCount) {
      _mainBloc.add(VisitorInfoListCallRequestEvent(
        _pageNo + 1,
        VisitorInfoListApiRequest(
          pkID: "0",
          LoginUserID: LoginUserID,
          SearchKey: edt_Search.text,
          PageNo: (_pageNo + 1).toString(),
          PageSize: pageSize.toString(),
          CompanyId: CompanyID.toString(),
        ),
      ));
    }
  }

  Widget _buildVisitorList() {
    if (_visitorInfoListApiResponse == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
            ),
            SizedBox(height: 16),
            Text(
              "Loading visitors...",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_visitorInfoListApiResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              "No Visitors Found",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              edt_Search.text.isEmpty
                  ? "Tap + to add your first visitor"
                  : "Try adjusting your search",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(scrollInfo)) {
          _onVisitorListPagination();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _visitorInfoListApiResponse.details.length,
        padding: EdgeInsets.only(bottom: 16),
        itemBuilder: (context, index) {
          return _buildVisitorCard(_visitorInfoListApiResponse.details[index]);
        },
      ),
    );
  }

  Widget _buildVisitorCard(VisitorInfoListApiResponseDetails model) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored left accent bar
              Container(
                width: 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff108dcf), Color(0xff62bb47)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header row: name + meeting badge + action icons ──
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildHeaderDetails(model)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 8),
                              // Edit / Delete icons
                              if (IsEditRights || IsDeleteRights)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (IsEditRights)
                                      _buildActionIcon(
                                        icon: Icons.edit,
                                        color: colorPrimary,
                                        onTap: () => _onEditVisitor(model),
                                      ),
                                    if (IsEditRights && IsDeleteRights)
                                      const SizedBox(width: 6),
                                    if (IsDeleteRights)
                                      _buildActionIcon(
                                        icon: Icons.delete,
                                        color: Colors.redAccent,
                                        onTap: () => _confirmDelete(model),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
                      Divider(
                          thickness: 1, height: 1, color: Colors.grey.shade200),

                      // ── Documents ──
                      _buildImageButtonsSection(model),

                      const SizedBox(height: 14),

                      // ── Details section ──
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow("Purpose", model.purposeOfVisit),
                            _buildDetailRow("Meeting With", model.employeeName),
                            _buildDetailRow("Designation", model.designation),
                            if (model.visitorEmail?.isNotEmpty ?? false)
                              _buildDetailRow("Email", model.visitorEmail),
                            // Address: label on its own line, full address below
                            if (model.address?.isNotEmpty ?? false)
                              _buildAddressRow(model.address),
                          ],
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
    );
  }

  // ── Image preview section ─────────────────────────────────────────────────

  Widget _buildImageButtonsSection(VisitorInfoListApiResponseDetails model) {
    final String visitorImageUrl = (model.visitorImage ?? "").isNotEmpty
        ? "$SiteURL/${model.visitorImage}"
        : "";
    final String documentImageUrl = (model.visitorDocument ?? "").isNotEmpty
        ? "$SiteURL/${model.visitorDocument}"
        : "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Text(
          "Visitor Documents",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildImagePreviewTile(
                title: "Visitor Photo",
                imageUrl: visitorImageUrl,
                placeholderIcon: Icons.person,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildImagePreviewTile(
                title: "Document",
                imageUrl: documentImageUrl,
                placeholderIcon: Icons.insert_drive_file,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreviewTile({
    String title,
    String imageUrl,
    IconData placeholderIcon,
  }) {
    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black45,
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: hasImage ? () => _showImageFullScreen(imageUrl, title) : null,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hasImage
                    ? colorPrimary.withOpacity(0.4)
                    : Colors.grey.shade300,
                width: 1.5,
              ),
              color: hasImage ? Colors.transparent : Colors.grey.shade100,
            ),
            clipBehavior: Clip.hardEdge,
            child: hasImage
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(colorPrimary),
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image,
                                  size: 32, color: Colors.grey.shade400),
                              const SizedBox(height: 4),
                              Text(
                                "Failed to load",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // "Tap to view" gradient hint at the bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.55),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.zoom_in,
                                  size: 13, color: Colors.white),
                              const SizedBox(width: 3),
                              Text(
                                "Tap to view",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(placeholderIcon,
                          size: 32, color: Colors.grey.shade400),
                      const SizedBox(height: 5),
                      Text(
                        "Not Available",
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  void _showImageFullScreen(String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: PhotoView(
                    imageProvider: NetworkImage(imageUrl),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.9),
                    ),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2.0,
                    initialScale: PhotoViewComputedScale.contained,
                    loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image,
                              color: Colors.white54, size: 60),
                          const SizedBox(height: 12),
                          Text(
                            "Unable to load image",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Close button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ),
              // Title
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Action icon ──────────────────────────────────────────────────────────

  Widget _buildActionIcon({
    IconData icon,
    Color color,
    VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: color,
        ),
      ),
    );
  }

  void _confirmDelete(VisitorInfoListApiResponseDetails model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Confirm Delete",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this visitor record?",
            style: TextStyle(color: Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              child:
                  Text("Cancel", style: TextStyle(color: Colors.grey.shade600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                _mainBloc.add(
                  VisitorInfoDeleteCallRequestEvent(
                    VisitorInfoDeleteApiRequest(
                      pkID: model.pkID.toString(),
                      CompanyId: CompanyID.toString(),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderDetails(VisitorInfoListApiResponseDetails model) {
    final String contact = model.visitorContact ?? "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Visitor Name
        Text(
          model.visitorName ?? "N/A",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),

        // Contact Number — tappable to open phone dialer
        GestureDetector(
          onTap: contact.isNotEmpty ? () => _launchDialer(contact) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: contact.isNotEmpty
                  ? Color(0xff108dcf).withOpacity(0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: contact.isNotEmpty
                    ? Color(0xff108dcf).withOpacity(0.35)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  contact.isNotEmpty ? Icons.phone_in_talk : Icons.phone,
                  size: 16,
                  color: contact.isNotEmpty ? Color(0xff108dcf) : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  contact.isNotEmpty ? contact : "N/A",
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        contact.isNotEmpty ? Color(0xff108dcf) : Colors.black54,
                    fontWeight: FontWeight.w600,
                    decoration: contact.isNotEmpty
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
                if (contact.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.call, size: 13, color: Color(0xff108dcf)),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Company Name
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.business, size: 16, color: Colors.blueGrey),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                model.companyName ?? "N/A",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Date and Time Row
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 15, color: Colors.orange),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      model.visitDate?.getFormattedDate(
                            fromFormat: "yyyy-MM-ddTHH:mm:ss",
                            toFormat: "dd-MM-yyyy",
                          ) ??
                          "N/A",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 15, color: Colors.teal),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      model.visitTime ?? "N/A",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Opens the phone dialer with [number].
  void _launchDialer(String number) async {
    final uri = Uri(scheme: 'tel', path: number.trim());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Detail row: label (fixed width) | value — both on the same line for short values.
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black45,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            ":",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black45,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? "N/A",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Address row: "Address" label on its own line, full address below in a
  /// slightly indented, styled block so long addresses are always fully visible.
  Widget _buildAddressRow(String address) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Color(0xff0066b3)),
              const SizedBox(width: 4),
              Text(
                "Address",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xff0066b3).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0xff0066b3).withOpacity(0.15),
              ),
            ),
            child: Text(
              address,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return Future.value(false);
  }

  void _onEditVisitor(VisitorInfoListApiResponseDetails model) {
    navigateTo(context, VisitorInfoAddEditScreen.routeName,
        arguments: VisitorInfoAddEditScreenArguments(model));
  }

  void _onVisitorInfoDeleteCallResponseState(
      VisitorInfoDeleteCallResponseState state) {
    showCommonDialogWithSingleOption(
      context,
      state.response,
      positiveButtonTitle: "OK",
      onTapOfPositiveButton: () {
        navigateTo(context, VisitorInfoListScreen.routeName,
            clearAllStack: true);
      },
    );
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "pgVisitorInfo") {
        _mainBloc.add(UserMenuRightsRequestEvent(
          menuRightsResponse.details[i].menuId.toString(),
          UserMenuRightsRequest(
            MenuID: menuRightsResponse.details[i].menuId.toString(),
            CompanyId: CompanyID.toString(),
            LoginUserID: LoginUserID,
          ),
        ));
        break;
      }
    }
  }

  void _OnMenuRightsSuccess(UserMenuRightsResponseState state) {
    for (int i = 0; i < state.userMenuRightsResponse.details.length; i++) {
      IsAddRights =
          state.userMenuRightsResponse.details[i].addFlag1.toLowerCase() ==
              "true";
      IsEditRights =
          state.userMenuRightsResponse.details[i].editFlag1.toLowerCase() ==
              "true";
      IsDeleteRights =
          state.userMenuRightsResponse.details[i].delFlag1.toLowerCase() ==
              "true";
    }
  }
}
