import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/product_master/product_master_bloc.dart';
import 'package:soleoserp/models/api_requests/product/product_delete_request.dart';
import 'package:soleoserp/models/api_requests/product/product_master_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/api_responses/product_master/product_master_list_response.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/product_master/product_master_add_update_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class _R {
  final double sw;
  final double sh;
  final double px;

  _R(BuildContext context)
      : sw = MediaQuery.of(context).size.width,
        sh = MediaQuery.of(context).size.height,
        px = MediaQuery.of(context).size.width / 390;

  double s(double v) => (v * px).clamp(v * 0.75, v * 1.35);
  double f(double v) => (v * px).clamp(v * 0.82, v * 1.20);
}

class ProductMasterListScreen extends BaseStatefulWidget {
  static const routeName = '/ProductMasterListScreen';

  @override
  _ProductMasterListScreenState createState() =>
      _ProductMasterListScreenState();
}

class _ProductMasterListScreenState extends BaseState<ProductMasterListScreen>
    with BasicScreen, WidgetsBindingObserver {
  static const int _minSearchLength = 3;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  String LoginUserID;
  String CompanyID;
  ManagePurchaseBloc _inquiryBloc;
  int _pageNo = 0;
  ProductMasterResponseDetails _searchDetails;
  ProductMasterResponse _inquiryListResponse;
  int selected = 0;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;
  MenuRightsResponse _menuRightsResponse;

  final TextEditingController _searchCtrl = TextEditingController();
  Timer _debounceTimer;
  int _searchQueryToken = 0;
  FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    _inquiryBloc = ManagePurchaseBloc(baseBloc);

    _searchFocusNode = FocusNode();

    getUserRights(_menuRightsResponse);
    _fetchList();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchCtrl.dispose();
    _searchFocusNode?.dispose();
    super.dispose();
  }

  void _fetchList({int pageNo = 1, String searchKey}) {
    final query = (searchKey ?? _searchCtrl.text).trim();
    _inquiryBloc.add(ProductMasterListEvent(
        pageNo,
        ProductMasterListRequest(
            ProductID: "0",
            ListMode: "L",
            SearchKey: query,
            PageNo: pageNo.toString(),
            PageSize: "10",
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString())));
  }

  void _onSearchChanged(String value) {
    final query = value.trim();
    if (_debounceTimer?.isActive ?? false) _debounceTimer.cancel();

    if (query.isEmpty) {
      setState(() {});
      _fetchList(pageNo: 1, searchKey: "");
      return;
    }

    if (query.length < _minSearchLength) {
      setState(() {});
      return;
    }

    final currentToken = ++_searchQueryToken;
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      if (!mounted || currentToken != _searchQueryToken) return;
      _fetchList(pageNo: 1, searchKey: query);
    });
  }

  void _clearSearch() {
    _searchCtrl.clear();
    _debounceTimer?.cancel();
    _searchQueryToken++;
    _fetchList(pageNo: 1, searchKey: "");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<ManagePurchaseBloc, ProductMasterState>(
        builder: (BuildContext context, ProductMasterState state) {
          if (state is ProductMasterResponseState) {
            _OnProductListResponse(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ProductMasterResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ProductMasterState state) {
          if (state is ProductDeleteResponseState) {
            _onDeleteBankVoucher(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ProductDeleteResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final r = _R(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: const Color(0xffF2F5FA),
        appBar: NewGradientAppBar(
          title: const Text(
            'Product List',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            if (IsAddRights == true &&
                (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                        "TEST-0000-SI0F-0208" ||
                    _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                        "BINE-KARS-EDJT-CVPL"))
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 24),
                onPressed: () {
                  navigateTo(context, ProductMasterAddEdit.routeName);
                },
              ),
            IconButton(
              icon: const Icon(Icons.home_outlined,
                  color: Colors.white, size: 24),
              onPressed: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: LoginUserID),
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchPanel(context, r),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xff0066b3),
                  onRefresh: () async {
                    getUserRights(_menuRightsResponse);
                    _fetchList();
                  },
                  child: _buildProductList(context, r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchPanel(BuildContext context, _R r) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(10), r.s(12), r.s(10)),
        child: Container(
          height: r.s(44),
          padding: EdgeInsets.symmetric(horizontal: r.s(12)),
          decoration: BoxDecoration(
            color: const Color(0xffF2F5FA),
            borderRadius: BorderRadius.circular(r.s(10)),
            border: Border.all(color: const Color(0xffDDE3EF)),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade500, size: r.s(20)),
              SizedBox(width: r.s(10)),
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  focusNode: _searchFocusNode,
                  autofocus: false,
                  textInputAction: TextInputAction.search,
                  onChanged: (v) {
                    _onSearchChanged(v);
                    setState(() {});
                  },
                  onSubmitted: (v) {
                    _debounceTimer?.cancel();
                    _searchQueryToken++;
                    FocusScope.of(context).unfocus();
                    final query = v.trim();
                    if (query.isEmpty || query.length >= _minSearchLength) {
                      _fetchList(pageNo: 1, searchKey: query);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400, fontSize: r.f(13)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: r.f(13), color: Colors.black87),
                ),
              ),
              if (_searchCtrl.text.isNotEmpty)
                GestureDetector(
                  onTap: _clearSearch,
                  child: Icon(Icons.close,
                      size: r.s(16), color: Colors.grey.shade500),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(BuildContext context, _R r) {
    if (_inquiryListResponse == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_inquiryListResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND,
                height: r.s(180), width: r.s(180)),
            Text(
              "No Products Found",
              style: TextStyle(
                  fontSize: r.f(14),
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(scrollInfo) && _searchDetails == null) {
          _onInquiryListPagination();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
        itemCount: _inquiryListResponse.details.length,
        itemBuilder: (ctx, i) => _buildProductCard(ctx, r, i),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, _R r, int index) {
    final model = _inquiryListResponse.details[index];
    bool showActions =
        _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "TEST-0000-SI0F-0208" ||
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "BINE-KARS-EDJT-CVPL";

    return Card(
      margin: EdgeInsets.only(bottom: r.s(10)),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.s(14))),
      elevation: 3,
      shadowColor: Colors.blue.withOpacity(0.12),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Product Name
          Container(
            width: double.infinity,
            padding:
                EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(12)),
            decoration: BoxDecoration(
              color: const Color(0xff0066b3).withOpacity(0.05),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(r.s(14))),
            ),
            child: Row(
              children: [
                Container(
                  width: r.s(36),
                  height: r.s(36),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff0066b3).withOpacity(0.1),
                  ),
                  child: Icon(Icons.inventory_2_outlined,
                      size: r.s(18), color: const Color(0xff0066b3)),
                ),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.productName ?? "N/A",
                        style: TextStyle(
                            fontSize: r.f(14),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff0066b3)),
                      ),
                      SizedBox(height: r.s(2)),
                      Text(
                        model.productAlias ?? "N/A",
                        style:
                            TextStyle(fontSize: r.f(11), color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Product Image (if available)
          if (model.productImage != null && model.productImage.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(r.s(12)),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(r.s(10)),
                  child: Image.network(
                    _offlineCompanyData.details[0].siteURL + model.productImage,
                    height: r.s(100),
                    width: r.s(100),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: r.s(100),
                        width: r.s(100),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(r.s(10)),
                        ),
                        child: Icon(Icons.image_not_supported,
                            size: r.s(40), color: Colors.grey.shade400),
                      );
                    },
                  ),
                ),
              ),
            ),
          // Info Cards
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(12), r.s(8), r.s(12), r.s(8)),
            child: Row(
              children: [
                Expanded(
                  child: _infoChip(r, Icons.inventory, "Opening",
                      model.openingSTK?.toString() ?? "0"),
                ),
                SizedBox(width: r.s(8)),
                Expanded(
                  child: _infoChip(r, Icons.check_circle, "Closing",
                      model.closingSTK?.toString() ?? "0"),
                ),
                SizedBox(width: r.s(8)),
                Expanded(
                  child: _infoChip(r, Icons.currency_rupee, "Price",
                      "₹${model.unitPrice?.toString() ?? "0"}"),
                ),
              ],
            ),
          ),
          // Additional Details
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(12), r.s(4), r.s(12), r.s(8)),
            child: Column(
              children: [
                _detailRow(r, "Group", model.productGroupName ?? "N/A",
                    Icons.groups_outlined),
                SizedBox(height: r.s(6)),
                _detailRow(r, "Brand", model.brandName ?? "N/A",
                    Icons.branding_watermark_outlined),
                SizedBox(height: r.s(6)),
                Row(
                  children: [
                    Expanded(
                      child: _detailRow(
                          r,
                          "Unit Price",
                          "₹${model.unitPrice?.toString() ?? "0"}",
                          Icons.currency_rupee),
                    ),
                    Expanded(
                      child: _detailRow(
                          r,
                          "Tax Rate",
                          "${model.taxRate?.toString() ?? "0"}%",
                          Icons.percent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Action Buttons
          if (IsEditRights == true || IsDeleteRights == true)
            if (showActions)
              Padding(
                padding: EdgeInsets.fromLTRB(r.s(12), r.s(4), r.s(12), r.s(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (IsEditRights == true)
                      GestureDetector(
                        onTap: () => _onTapOfEditCustomer(model),
                        child: Container(
                          padding: EdgeInsets.all(r.s(6)),
                          child: Icon(Icons.edit_outlined,
                              size: r.s(18), color: const Color(0xff0066b3)),
                        ),
                      ),
                    if (IsDeleteRights == true)
                      GestureDetector(
                        onTap: () => _showDeleteConfirmation(model.pkID),
                        child: Container(
                          padding: EdgeInsets.all(r.s(6)),
                          child: Icon(Icons.delete_outline,
                              size: r.s(18), color: Colors.red.shade400),
                        ),
                      ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget _infoChip(_R r, IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: r.s(8)),
      decoration: BoxDecoration(
        color: const Color(0xffF2F5FA),
        borderRadius: BorderRadius.circular(r.s(10)),
      ),
      child: Column(
        children: [
          Icon(icon, size: r.s(16), color: const Color(0xff0066b3)),
          SizedBox(height: r.s(4)),
          Text(
            label,
            style: TextStyle(fontSize: r.f(9), color: Colors.grey.shade500),
          ),
          SizedBox(height: r.s(2)),
          Text(
            value,
            style: TextStyle(
                fontSize: r.f(12),
                fontWeight: FontWeight.bold,
                color: const Color(0xff1A2332)),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _detailRow(_R r, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: r.s(12), color: const Color(0xff0066b3)),
        SizedBox(width: r.s(6)),
        Text(
          "$label: ",
          style: TextStyle(fontSize: r.f(10), color: Colors.grey.shade500),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontSize: r.f(11),
                fontWeight: FontWeight.w500,
                color: const Color(0xff1A2332)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(int id) {
    showCommonDialogWithTwoOptions(
      context,
      "Are you sure you want to delete this product?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.of(context).pop();
        _inquiryBloc.add(ProductDeleteDeleteEvent(
          ProductDeleteRequest(pkID: id, CompanyId: CompanyID),
        ));
      },
    );
  }

  void _onInquiryListPagination() {
    _inquiryBloc.add(ProductMasterListEvent(
        _pageNo + 1,
        ProductMasterListRequest(
            ProductID: "0",
            ListMode: "L",
            SearchKey: _searchCtrl.text.trim(),
            PageNo: (_pageNo + 1).toString(),
            PageSize: "10",
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString())));
  }

  void _OnProductListResponse(ProductMasterResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _searchDetails = null;
        _inquiryListResponse = state.response;
      } else {
        _inquiryListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
  }

  void _onTapOfEditCustomer(ProductMasterResponseDetails model) {
    navigateTo(context, ProductMasterAddEdit.routeName,
            arguments: ProductMasterAddEditArguments(model))
        .then((value) => _fetchList(pageNo: 1));
  }

  void _onDeleteBankVoucher(ProductDeleteResponseState state) {
    showCommonDialogWithSingleOption(context, state.response,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);
      _fetchList(pageNo: 1);
    });
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return false;
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      if (menuRightsResponse.details[i].menuName == "lnkProudct1") {
        _inquiryBloc.add(UserMenuRightsRequestEvent(
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
