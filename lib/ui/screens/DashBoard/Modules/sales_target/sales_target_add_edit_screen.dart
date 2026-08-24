import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/salesorder/salesorder_bloc.dart';
import 'package:soleoserp/models/api_requests/sales_target/sales_target_add_edit_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/sales_target/sales_target_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/search_followup_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/search_inquiry_product_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/sales_target/sales_target_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
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

class SalesTargetAddEditScreenArguments {
  SalesTargetListResponseDetails editModel;
  SalesTargetAddEditScreenArguments(this.editModel);
}

class SalesTargetAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/SalesTargetAddEditScreen';
  final SalesTargetAddEditScreenArguments arguments;

  SalesTargetAddEditScreen(this.arguments);

  @override
  _SalesTargetAddEditScreenState createState() =>
      _SalesTargetAddEditScreenState();
}

class _SalesTargetAddEditScreenState extends BaseState<SalesTargetAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  SalesOrderBloc _salesOrderBloc;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  bool _isForUpdate;
  FocusNode PicCodeFocus;
  SearchDetails _searchDetails;
  ProductSearchDetails _searchDetailsForProduct;
  FocusNode myFocusNode;
  int pkID = 0;
  SalesTargetListResponseDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  // Product Rate variable
  double _productRate = 0.0;

  /// Controllers
  final TextEditingController edt_from_date = TextEditingController();
  final TextEditingController edt_Reverse_from_date = TextEditingController();
  final TextEditingController edt_to_date = TextEditingController();
  final TextEditingController edt_Reverse_to_date = TextEditingController();
  final TextEditingController edt_employeeName = TextEditingController();
  final TextEditingController edt_employeePkID = TextEditingController();
  final TextEditingController edt_customerPkID = TextEditingController();
  final TextEditingController edt_customerName = TextEditingController();
  final TextEditingController edt_productPkID = TextEditingController();
  final TextEditingController edt_productName = TextEditingController();
  final TextEditingController edt_salesTargetType = TextEditingController();
  final TextEditingController edt_targetQty = TextEditingController();
  final TextEditingController edt_qtyAmount = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Employee = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];

  String _selectedFilterStatus = "Quantity";
  final List<String> _filterStatusList = [
    "Quantity",
  ];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _salesOrderBloc = SalesOrderBloc(baseBloc);
    myFocusNode = FocusNode();
    PicCodeFocus = FocusNode();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    edt_employeeName.text = _offlineLoggedInData.details[0].employeeName;
    edt_employeePkID.text =
        _offlineLoggedInData.details[0].employeeID.toString();

    // Add listeners for auto-calculation
    edt_targetQty.addListener(_calculateQtyAmount);
    edt_productPkID.addListener(_calculateQtyAmount);

    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      edt_from_date.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_Reverse_from_date.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      edt_to_date.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_Reverse_to_date.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    PicCodeFocus.dispose();
    edt_targetQty.removeListener(_calculateQtyAmount);
    edt_productPkID.removeListener(_calculateQtyAmount);
  }

  // ==================== AUTO-CALCULATION METHOD ====================
  void _calculateQtyAmount() {
    // Get target quantity
    double targetQty = double.tryParse(edt_targetQty.text) ?? 0.0;

    // If product rate is available, calculate amount
    if (_productRate > 0 && targetQty > 0) {
      print("object");
      double amount = targetQty * _productRate;
      edt_qtyAmount.text = amount.toStringAsFixed(2);
    } else if (targetQty == 0) {
      edt_qtyAmount.text = "0.00";
    }
    // If no product rate, keep the existing amount
  }

  // ==================== UPDATE PRODUCT RATE ====================
  void _updateProductRate(double rate) {
    _productRate = rate;
    // Recalculate when product rate is updated
    _calculateQtyAmount();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _salesOrderBloc,
      child: BlocConsumer<SalesOrderBloc, SalesOrderStates>(
        builder: (BuildContext context, SalesOrderStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, SalesOrderStates state) {
          if (state is SalesTargetAddUpdateResponseState) {
            _onSalesTargetAddUpdateResponseStateSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SalesTargetAddUpdateResponseState) {
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
          title: Text(
            _isForUpdate ? 'Edit Sales Target' : 'Add New Sales Target',
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              navigateTo(context, SalesTargetListScreen.routeName,
                  clearAllStack: true);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home_outlined,
                  color: Colors.white, size: 24),
              onPressed: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                EdgeInsets.symmetric(horizontal: r.s(16), vertical: r.s(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Employee Field
                _buildEmployeeField(r),
                SizedBox(height: r.s(16)),

                // Customer Field
                _buildCustomerField(r),
                SizedBox(height: r.s(16)),

                // Product Field
                _buildProductField(r),
                SizedBox(height: r.s(16)),

                // From Date & To Date Row
                Row(
                  children: [
                    Expanded(child: _buildFromDateField(r)),
                    SizedBox(width: r.s(12)),
                    Expanded(child: _buildToDateField(r)),
                  ],
                ),
                SizedBox(height: r.s(16)),

                // Target Qty & Amount Row
                Row(
                  children: [
                    Expanded(child: _buildTargetQtyField(r)),
                    SizedBox(width: r.s(12)),
                    Expanded(child: _buildQtyAmountField(r)),
                  ],
                ),
                SizedBox(height: r.s(16)),

                // Target Type Filter
                _buildTargetTypeFilter(r),
                SizedBox(height: r.s(24)),

                // Save Button
                _buildSaveButton(r),
                SizedBox(height: r.s(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== UI COMPONENTS ====================

  Widget _buildEmployeeField(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Employee *",
          style: TextStyle(
            fontSize: r.f(12),
            color: const Color(0xff0066b3),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.s(6)),
        InkWell(
          onTap: () {
            showCustomDialogWithIDForScreen(
              values: arr_ALL_Name_ID_For_Employee,
              context1: context,
              controller: edt_employeeName,
              controllerID: edt_employeePkID,
              label: "Select Employee",
            );
          },
          child: Container(
            height: r.s(48),
            padding: EdgeInsets.symmetric(horizontal: r.s(14)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r.s(12)),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.person_outline,
                    color: const Color(0xff0066b3), size: r.s(20)),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Text(
                    edt_employeeName.text.isEmpty
                        ? "Select Employee"
                        : edt_employeeName.text,
                    style: TextStyle(
                      color: edt_employeeName.text.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                      fontSize: r.f(13),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down,
                    color: const Color(0xff0066b3), size: r.s(24)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerField(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer *",
          style: TextStyle(
            fontSize: r.f(12),
            color: const Color(0xff0066b3),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.s(6)),
        InkWell(
          onTap: _onTapOfSearchView,
          child: Container(
            height: r.s(48),
            padding: EdgeInsets.symmetric(horizontal: r.s(14)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r.s(12)),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.business_outlined,
                    color: const Color(0xff0066b3), size: r.s(20)),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Text(
                    edt_customerName.text.isEmpty
                        ? "Search Customer"
                        : edt_customerName.text,
                    style: TextStyle(
                      color: edt_customerName.text.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                      fontSize: r.f(13),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.search,
                    color: const Color(0xff0066b3), size: r.s(20)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductField(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Product *",
          style: TextStyle(
            fontSize: r.f(12),
            color: const Color(0xff0066b3),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.s(6)),
        InkWell(
          onTap: _onTapOfProductSearchView,
          child: Container(
            height: r.s(48),
            padding: EdgeInsets.symmetric(horizontal: r.s(14)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r.s(12)),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_2_outlined,
                    color: const Color(0xff0066b3), size: r.s(20)),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Text(
                    edt_productName.text.isEmpty
                        ? "Search Product"
                        : edt_productName.text,
                    style: TextStyle(
                      color: edt_productName.text.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                      fontSize: r.f(13),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Show rate indicator if product is selected
                if (_productRate > 0)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: r.s(8), vertical: r.s(2)),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(r.s(10)),
                    ),
                    child: Text(
                      "₹${_productRate.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: r.f(10),
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Icon(Icons.search,
                    color: const Color(0xff0066b3), size: r.s(20)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFromDateField(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "From Date *",
          style: TextStyle(
            fontSize: r.f(12),
            color: const Color(0xff0066b3),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.s(6)),
        InkWell(
          onTap: () => _selectFromDate(context, edt_from_date),
          child: Container(
            height: r.s(48),
            padding: EdgeInsets.symmetric(horizontal: r.s(14)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r.s(12)),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    color: const Color(0xff0066b3), size: r.s(18)),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Text(
                    edt_from_date.text.isEmpty
                        ? "DD-MM-YYYY"
                        : edt_from_date.text,
                    style: TextStyle(
                      color: edt_from_date.text.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                      fontSize: r.f(13),
                      fontWeight: FontWeight.w500,
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

  Widget _buildToDateField(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "To Date *",
          style: TextStyle(
            fontSize: r.f(12),
            color: const Color(0xff0066b3),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.s(6)),
        InkWell(
          onTap: () => _selectToDate(context, edt_to_date),
          child: Container(
            height: r.s(48),
            padding: EdgeInsets.symmetric(horizontal: r.s(14)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r.s(12)),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    color: const Color(0xff0066b3), size: r.s(18)),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Text(
                    edt_to_date.text.isEmpty ? "DD-MM-YYYY" : edt_to_date.text,
                    style: TextStyle(
                      color: edt_to_date.text.isEmpty
                          ? Colors.grey.shade500
                          : Colors.black87,
                      fontSize: r.f(13),
                      fontWeight: FontWeight.w500,
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

  Widget _buildTargetQtyField(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Targeted Quantity *",
          style: TextStyle(
            fontSize: r.f(12),
            color: const Color(0xff0066b3),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.s(6)),
        Container(
          height: r.s(48),
          padding: EdgeInsets.symmetric(horizontal: r.s(14)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(r.s(12)),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.numbers,
                  color: const Color(0xff0066b3), size: r.s(18)),
              SizedBox(width: r.s(10)),
              Expanded(
                child: TextField(
                  controller: edt_targetQty,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: "0.00",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400, fontSize: r.f(13)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: r.f(14), color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQtyAmountField(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quantity Amount *",
          style: TextStyle(
            fontSize: r.f(12),
            color: const Color(0xff0066b3),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.s(6)),
        Container(
          height: r.s(48),
          padding: EdgeInsets.symmetric(horizontal: r.s(14)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(r.s(12)),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.currency_rupee,
                  color: const Color(0xff0066b3), size: r.s(18)),
              SizedBox(width: r.s(10)),
              Expanded(
                child: TextField(
                  controller: edt_qtyAmount,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: "0.00",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400, fontSize: r.f(13)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: r.f(14), color: Colors.black87),
                  readOnly:
                      true, // Make it read-only since it's auto-calculated
                ),
              ),
              // Show auto-calculate indicator
              if (_productRate > 0)
                Tooltip(
                  message: "Auto-calculated from product rate",
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.orange.shade700,
                    size: r.s(16),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTargetTypeFilter(_R r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Target Type",
          style: TextStyle(
            fontSize: r.f(12),
            color: const Color(0xff0066b3),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: r.s(8)),
        Container(
          height: r.s(40),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filterStatusList.length,
            separatorBuilder: (_, __) => SizedBox(width: r.s(8)),
            itemBuilder: (_, i) {
              final status = _filterStatusList[i];
              final isSelected = _selectedFilterStatus == status;
              final color = _getStatusColor(status);
              return GestureDetector(
                onTap: () => _onStatusChipTapped(status),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: r.s(18)),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? color : color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(r.s(20)),
                    border: Border.all(
                      color: isSelected ? color : color.withOpacity(0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: r.f(12),
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : color,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(_R r) {
    return Container(
      width: double.infinity,
      height: r.s(50),
      child: ElevatedButton(
        onPressed: _onTapOfSaveVehiclePunchAPICall,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff0066b3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.s(12)),
          ),
          elevation: 4,
        ),
        child: Text(
          _isForUpdate ? "Update Target" : "Save Target",
          style: TextStyle(
            fontSize: r.f(16),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ==================== HELPER METHODS ====================

  void _onStatusChipTapped(String status) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedFilterStatus = status;
      edt_salesTargetType.text = status;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'quantity':
        return Colors.green.shade600;
      default:
        return Colors.blueGrey.shade600;
    }
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Employee.clear();

    if (state.details != null) {
      if (_offlineLoggedInData.details[0].roleCode.toLowerCase().trim() ==
          "admin") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "ALL";
        all_name_id.Name1 = "";
        arr_ALL_Name_ID_For_Employee.add(all_name_id);
      }

      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].pkID.toString();
        arr_ALL_Name_ID_For_Employee.add(all_name_id);
      }
    }
  }

  Future<void> showCustomDialogWithIDForScreen({
    List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    TextEditingController controllerID,
    String label,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: const Color(0xff0066b3),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(height: 8),
                Container(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: values.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context123).pop();
                          controller.text = values[index].Name;
                          controllerID.text = values[index].pkID.toString();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xff0066b3),
                                ),
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.only(right: 12),
                              ),
                              Expanded(
                                child: Text(
                                  values[index].Name,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context123).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: const Color(0xff0066b3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchFollowupCustomerScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        edt_customerPkID.text = _searchDetails.value.toString();
        edt_customerName.text = _searchDetails.label.toString();
        setState(() {});
      }
    });
  }

  Future<void> _onTapOfProductSearchView() async {
    navigateTo(
      context,
      SearchInquiryProductScreen.routeName,
    ).then((value) {
      if (value != null) {
        _searchDetailsForProduct = ProductSearchDetails();
        _searchDetailsForProduct = value;
        setState(() {
          edt_productName.text =
              _searchDetailsForProduct.productName.toString();
          edt_productPkID.text = _searchDetailsForProduct.pkID.toString();
          // Update product rate from search result (if available)
          double rate = _searchDetailsForProduct.unitPrice ?? 0.0;
          _updateProductRate(rate);
        });
      }
    });
  }

  Future<void> _selectFromDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_from_date.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_Reverse_from_date.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Future<void> _selectToDate(
      BuildContext context, TextEditingController T_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_to_date.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_Reverse_to_date.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  _onTapOfSaveVehiclePunchAPICall() async {
    // Validation
    if (edt_employeePkID.text.isEmpty || edt_employeePkID.text == "0") {
      showCommonDialogWithSingleOption(
        context,
        "Please select Employee",
        positiveButtonTitle: "OK",
        onTapOfPositiveButton: () => Navigator.pop(context),
      );
      return;
    }

    if (edt_customerPkID.text.isEmpty || edt_customerPkID.text == "0") {
      showCommonDialogWithSingleOption(
        context,
        "Please select Customer",
        positiveButtonTitle: "OK",
        onTapOfPositiveButton: () => Navigator.pop(context),
      );
      return;
    }

    if (edt_productPkID.text.isEmpty || edt_productPkID.text == "0") {
      showCommonDialogWithSingleOption(
        context,
        "Please select Product",
        positiveButtonTitle: "OK",
        onTapOfPositiveButton: () => Navigator.pop(context),
      );
      return;
    }

    if (edt_targetQty.text.isEmpty ||
        double.tryParse(edt_targetQty.text) == 0) {
      showCommonDialogWithSingleOption(
        context,
        "Please enter valid Targeted Quantity",
        positiveButtonTitle: "OK",
        onTapOfPositiveButton: () => Navigator.pop(context),
      );
      return;
    }

    if (edt_qtyAmount.text.isEmpty ||
        double.tryParse(edt_qtyAmount.text) == 0) {
      showCommonDialogWithSingleOption(
        context,
        "Please enter valid Quantity Amount",
        positiveButtonTitle: "OK",
        onTapOfPositiveButton: () => Navigator.pop(context),
      );
      return;
    }

    // Show confirmation dialog
    showCommonDialogWithTwoOptions(
      context,
      "Are you sure you want to save this Sales Target?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.of(context).pop();

        _salesOrderBloc.add(SalesTargetAddUpdateCallEvent(
            SalasTargetAddUpdateRequest(
                pkID: pkID.toString(),
                EmployeeID: edt_employeePkID.text,
                FromDate: edt_Reverse_from_date.text,
                ToDate: edt_Reverse_to_date.text,
                TargetAmount: edt_targetQty.text ?? '0.00',
                BrandID: "0",
                ProductGroupID: "0",
                ProductID: edt_productPkID.text,
                CustomerID: edt_customerPkID.text,
                IncentivePer: "0",
                IncentiveAmt: "0",
                LoginUserID: LoginUserID,
                TargetType: _selectedFilterStatus == "Quantity"
                    ? "Q"
                    : _selectedFilterStatus,
                Amount: edt_qtyAmount.text ?? '0.00',
                CompanyId: CompanyID.toString())));
      },
    );
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, SalesTargetListScreen.routeName, clearAllStack: true);
    return false;
  }

  void _onSalesTargetAddUpdateResponseStateSuccess(
      SalesTargetAddUpdateResponseState state) async {
    navigateTo(context, SalesTargetListScreen.routeName, clearAllStack: true);
  }

  void fillData() async {
    pkID = _editModel.pkID;
    edt_from_date.text = _editModel.fromDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_from_date.text = _editModel.fromDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_to_date.text = _editModel.toDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_to_date.text = _editModel.toDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_employeeName.text = _editModel.employeeName;
    edt_employeePkID.text = _editModel.employeeId.toString();
    edt_customerPkID.text = _editModel.customerId.toString();
    edt_customerName.text = _editModel.customerName;
    edt_productPkID.text = _editModel.productId.toString();
    edt_productName.text = _editModel.productName;
    edt_salesTargetType.text = _editModel.targetType;
    edt_targetQty.text = _editModel.targetAmount.toString();
    edt_qtyAmount.text = _editModel.qtyAmount.toString();
    _selectedFilterStatus = _editModel.targetType;

    // Set product rate for editing
    _productRate = _editModel.qtyAmount /
        (_editModel.targetAmount > 0 ? _editModel.targetAmount : 1);
  }
}
