import 'dart:io';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:soleoserp/Clients/BlueTone/Customer/blue_tone_customer_add_edit.dart';
import 'package:soleoserp/blocs/other/bloc_modules/customer/customer_bloc.dart';
import 'package:soleoserp/models/api_requests/customer/city_code_to_customer_list_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_delete_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_fetch_document_api_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_paggination_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/city_code_to_customer_list_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_details_api_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_fetch_document_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/common/contact_model.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/customer_add_edit.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerList/Customer_history_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerList/search_customer_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/ui/widgets/new_common_widget.dart';
import 'package:soleoserp/utils/broadcast_msg/make_call.dart';
import 'package:soleoserp/utils/broadcast_msg/share_msg.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

///import 'package:whatsapp_share/whatsapp_share.dart';hatsapp_share/whatsapp_share.dart';
import '../../../home_screen.dart';

class CustomerListScreen extends BaseStatefulWidget {
  static const routeName = '/CustomerListScreen';

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

enum Share {
  facebook,
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
  share_system,
  share_instagram,
  share_telegram
}

class _CustomerListScreenState extends BaseState<CustomerListScreen>
    with BasicScreen, WidgetsBindingObserver {
  CustomerBloc _CustomerBloc;
  int _pageNo = 0;
  CustomerDetailsResponse _inquiryListResponse;
  bool expanded = true;
  double sizeboxsize = 12;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  SearchDetails _searchDetails;
  String foos = 'One';
  int selected = 0; //attention
  bool isExpand = false;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  MenuRightsResponse _menuRightsResponse;
  int CompanyID = 0;
  String LoginUserID = "";
  List<ContactModel> _contactsList = [];

  bool isDeleteVisible = true;
  List<CustomerFetchDocumentResponseDetails> documentAPIList = [];

  @override
  void initState() {
    super.initState();

    screenStatusBarColor = Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _CustomerBloc = CustomerBloc(baseBloc);

    isExpand = false;
    getContacts();
    _CustomerBloc
      ..add(CustomerListCallEvent(
          1,
          CustomerPaginationRequest(
              companyId: CompanyID,
              loginUserID: LoginUserID,
              CustomerID: "",
              ListMode: "",
              lstcontact: _contactsList)));

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc
        ..add(CustomerListCallEvent(
            _pageNo + 1,
            CustomerPaginationRequest(
                companyId: CompanyID,
                loginUserID: LoginUserID,
                CustomerID: "",
                ListMode: "",
                lstcontact: _contactsList))),
      child: BlocConsumer<CustomerBloc, CustomerStates>(
        builder: (BuildContext context, CustomerStates state) {
          if (state is CustomerListCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          if (state is SearchCustomerListByNumberCallResponseState) {
            _onInquiryListByNumberCallSuccess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is CustomerListCallResponseState ||
              currentState is SearchCustomerListByNumberCallResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, CustomerStates state) {
          if (state is CustomerDeleteCallResponseState) {
            _onCustomerDeleteCallSucess(state, context);
          }

          if (state is CustomerOnlyFetchDocumentResponseState) {
            _onFetchCustomer_ONly_document_List(state);
          }
          if (state is CustomerFetchDocumentResponseState) {
            _onFetchCustomer_document_List(state);
          }

          if (state is CityCodeToCustomerListResponseState) {
            _OnCityCodetoCustomerDetails(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is CustomerDeleteCallResponseState ||
              currentState is CustomerOnlyFetchDocumentResponseState ||
              currentState is CustomerFetchDocumentResponseState ||
              currentState is CityCodeToCustomerListResponseState) {
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
          title: Text('Customer List'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: colorWhite,
                  size: 30,
                ),
                onPressed: () {
                  _onTapOfSearchView();
                }),
            SizedBox(
              width: 10,
            ),
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                  size: 30,
                ),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                }),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _CustomerBloc.add(CustomerListCallEvent(
                        1,
                        CustomerPaginationRequest(
                            companyId: CompanyID,
                            loginUserID: LoginUserID,
                            CustomerID: "",
                            ListMode: "")));
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
                        Expanded(child: _buildInquiryList())
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: IsAddRights == true
            ? FloatingActionButton(
                onPressed: () async {
                  await _onTapOfDeleteALLContact();

                  if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                      "BLG3-AF78-TO5F-NW16") {
                    navigateTo(context, BlueToneCustomer_ADD_EDIT.routeName);
                  } else {
                    navigateTo(context, Customer_ADD_EDIT.routeName);
                  }
                },
                child: const Icon(Icons.add),
                backgroundColor: colorPrimary,
              )
            : Container(),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (_inquiryListResponse == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
              scrollInfo,
            ) &&
            _searchDetails == null) {
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
        itemCount: _inquiryListResponse.details.length,
      ),
    );
  }

  ///builds row item view of inquiry list
  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ///updates data of inquiry list
  void _onInquiryListCallSuccess(CustomerListCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _searchDetails = null;
        _inquiryListResponse = state.response;
      } else {
        _inquiryListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }

    getUserRights(_menuRightsResponse);
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onInquiryListPagination() {
    _CustomerBloc.add(CustomerListCallEvent(
        _pageNo + 1,
        CustomerPaginationRequest(
            companyId: CompanyID,
            loginUserID: LoginUserID,
            CustomerID: "",
            ListMode: "",
            lstcontact: _contactsList)));
  }

  ExpantionCustomer(BuildContext context, int index) {
    CustomerDetails model = _inquiryListResponse.details[index];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTileCard(
        borderRadius: BorderRadius.circular(16),
        initialElevation: 2,
        elevationCurve: Curves.easeInOut,
        baseColor: Colors.white70,
        expandedColor: Colors.white70,
        title: Row(
          children: [
            Icon(Icons.assignment_ind, color: Color(0xff108dcf), size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.customerName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "ID: ${model.customerID}",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Icon(Icons.phone_android, size: 18, color: colorPrimary),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorBackGroundGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Mo. ${model.contactNo1}",
                    style: TextStyle(
                      color: colorPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        children: [
          Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildAmountCard("Closing", model.closing.toString(), Icons.lock,
                    Colors.indigo),
                buildAmountCard("Opening", model.opening.toString(),
                    Icons.lock_open, Colors.teal),
                buildAmountCard("Debit", model.debit.toString(),
                    Icons.arrow_downward, Colors.redAccent),
                buildAmountCard("Credit", model.credit.toString(),
                    Icons.arrow_upward, Colors.green),
              ],
            ),
          ),
          Divider(thickness: 1),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildActionButton(
                  icon: Icons.call,
                  label: "Call",
                  onTap: () => MakeCall.callto(model.contactNo1),
                ),
                _buildActionButton(
                  icon: Icons.message,
                  label: "Message",
                  onTap: () => ShareMsg.msg(context, model.contactNo1),
                ),
                _buildActionButton(
                  assetImage: LOCATION_ICON,
                  label: "Location",
                  onTap: () {
                    if (model.latitude != "" && model.longitude != "") {
                      MapsLauncher.launchCoordinates(
                        double.parse(model.latitude),
                        double.parse(model.longitude),
                        'Location In',
                      );
                    } else {
                      showCommonDialogWithSingleOption(
                        context,
                        "Location In Not Valid!",
                        positiveButtonTitle: "OK",
                        onTapOfPositiveButton: () =>
                            Navigator.of(context).pop(),
                      );
                    }
                  },
                ),
                _buildActionButton(
                  icon: Icons.people_alt_rounded,
                  label: "Near By City",
                  onTap: () {
                    _CustomerBloc.add(
                      CityCodeToCustomerListRequestEvent(
                        model.cityCode.toString(),
                        CityCodeToCustomerListRequest(
                          CityCode: model.cityCode.toString(),
                          LoginUserID: LoginUserID,
                          CompanyID: CompanyID.toString(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MultipleList(
                  label: "Category",
                  value:
                      model.customerType.isEmpty ? "N/A" : model.customerType,
                  icon: getIconForLabel("Category"),
                  label1: "Source",
                  value1: model.customerSourceName == "--Not Available--"
                      ? "N/A"
                      : model.customerSourceName,
                  icon1: getIconForLabel("Source"),
                ),
                SizedBox(height: 6),
                MultipleList(
                  label: "Mobile",
                  value: model.contactNo1.isEmpty ? "N/A" : model.contactNo1,
                  icon: getIconForLabel("Mobile"),
                  label1: "Email",
                  value1:
                      model.emailAddress.isEmpty ? "N/A" : model.emailAddress,
                  icon1: getIconForLabel("Email"),
                ),
                SizedBox(height: 6),
                MultipleList(
                  label: "City",
                  value: model.cityName.isEmpty ? "N/A" : model.cityName,
                  icon: getIconForLabel("City"),
                  label1: "PinCode",
                  value1: model.pinCode.isEmpty ? "N/A" : model.pinCode,
                  icon1: getIconForLabel("PinCode"),
                ),
                SizedBox(height: 6),
                MultipleList(
                  label: "State",
                  value: model.stateName.isEmpty ? "N/A" : model.stateName,
                  icon: getIconForLabel("State"),
                  label1: "Country",
                  value1: model.countryName.isEmpty ? "N/A" : model.countryName,
                  icon1: getIconForLabel("Country"),
                ),
                SizedBox(height: 6),
                MultipleList(
                  label: "Created By",
                  value: model.createdBy.isEmpty ? "N/A" : model.createdBy,
                  icon: getIconForLabel("Created By"),
                  label1: "Created date",
                  value1: model.createdDate.getFormattedDate(
                    fromFormat: "yyyy-MM-dd",
                    toFormat: "dd-MM-yyyy",
                  ),
                  icon1: getIconForLabel("Created date"),
                ),
                SizedBox(height: 6),
                ChetGptKiKrupa(
                  label: "Address",
                  value: model.address.isEmpty ? "N/A" : model.address,
                  icon: getIconForLabel("Address"),
                ),
                SizedBox(height: 6),
                IsEditRights == false && IsDeleteRights == false
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IsEditRights == true
                              ? ElevatedButton.icon(
                                  onPressed: () {
                                    _CustomerBloc.add(
                                        CustomerFetchDocumentApiRequestEvent(
                                            false,
                                            "FromEditAction",
                                            model,
                                            CustomerFetchDocumentApiRequest(
                                                CompanyID: CompanyID.toString(),
                                                CustomerID: model.customerID
                                                    .toString())));
                                  },
                                  icon: Icon(Icons.edit, size: 20),
                                  label: Text("Update"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade100,
                                    foregroundColor: colorPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(width: 10),
                          IsDeleteRights == true
                              ? ElevatedButton.icon(
                                  onPressed: () {
                                    _onTapOfDeleteInquiry(model.customerID);
                                  },
                                  icon: Icon(Icons.delete, size: 20),
                                  label: Text("Delete"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade100,
                                    foregroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildAmountCard(
      String title, String value, IconData icon, Color bgColor) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Icon getIconForLabel(String label) {
    switch (label) {
      case "Category":
        return Icon(Icons.source, color: Colors.teal);
      case "Source":
        return Icon(Icons.category, color: Colors.indigo);
      case "Mobile":
        return Icon(Icons.mobile_friendly, color: Colors.teal);
      case "Email":
        return Icon(Icons.email, color: Colors.indigo);
      case "City":
        return Icon(Icons.location_city, color: Colors.orange);
      case "PinCode":
        return Icon(Icons.pin_drop, color: Colors.purple);
      case "State":
        return Icon(Icons.account_balance, color: Colors.teal);
      case "Country":
        return Icon(Icons.public, color: Colors.indigo);
      case "Created By":
        return Icon(Icons.person, color: Colors.green);
      case "Created date":
        return Icon(Icons.calendar_today, color: Colors.red);
      case "Address":
        return Icon(Icons.location_on, color: Colors.blueGrey);
      default:
        return Icon(Icons.info_outline, color: Colors.grey);
    }
  }

  Widget _buildActionButton({
    IconData icon,
    String label,
    VoidCallback onTap,
    String assetImage,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 1,
            color: colorBackGroundGray,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: 50, // Slightly larger for tap friendliness
              height: 50,
              child: Center(
                child: icon != null
                    ? Icon(icon, size: 24, color: colorPrimary)
                    : (assetImage != null
                        ? Image.asset(assetImage, width: 26, height: 26)
                        : SizedBox()),
              ),
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: 60, // restrict width to avoid long labels overflow
            child: Text(
              label ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: colorPrimary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _onTapOfDeleteInquiry(int id) {
    print("CUSTID" + id.toString());
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this Customer?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      //_collapse();
      _CustomerBloc.add(CustomerDeleteByNameCallEvent(
          id, CustomerDeleteRequest(CompanyID: CompanyID.toString())));
      // _CustomerBloc..add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: CompanyID,loginUserID: LoginUserID,CustomerID: "",ListMode: "L")));
    });
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  ///navigates to search list screen
  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchCustomerScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        _CustomerBloc.add(SearchCustomerListByNumberCallEvent(
            CustomerSearchByIdRequest(
                companyId: CompanyID,
                loginUserID: LoginUserID,
                CustomerID: _searchDetails.value.toString())));
        //  _CustomerBloc.add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: 8033,loginUserID: "admin",CustomerID: "",ListMode: "L")));
      }
    });
  }

  ///updates data of inquiry list
  void _onInquiryListByNumberCallSuccess(
      SearchCustomerListByNumberCallResponseState state) {
    _inquiryListResponse = state.response;
  }

  void _onCustomerDeleteCallSucess(
      CustomerDeleteCallResponseState state, BuildContext context) {
    /* _inquiryListResponse.details
        .removeWhere((element) => element.customerID == state.id);*/

    print("CustomerDeleted" +
        state.customerDeleteResponse.details[0].column1.toString() +
        "");
    //baseBloc.refreshScreen();
    navigateTo(context, CustomerListScreen.routeName, clearAllStack: true);
  }

  void _onTapOfEditCustomer(CustomerDetails model,
      List<CustomerFetchDocumentResponseDetails> documentAPIList1) {
    if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "BLG3-AF78-TO5F-NW16" /*||
        _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
            "TEST-0000-SI0F-0208"*/
        ) {
      navigateTo(context, BlueToneCustomer_ADD_EDIT.routeName,
              arguments: AddUpdateBlueToneCustomerScreenArguments(
                  model, documentAPIList1))
          .then((value) {
        _CustomerBloc
          ..add(CustomerListCallEvent(
              1,
              CustomerPaginationRequest(
                  companyId: CompanyID,
                  loginUserID: LoginUserID,
                  CustomerID: "",
                  ListMode: "",
                  lstcontact: _contactsList)));
      });
    } else {
      navigateTo(context, Customer_ADD_EDIT.routeName,
              arguments:
                  AddUpdateCustomerScreenArguments(model, documentAPIList1))
          .then((value) {
        _CustomerBloc
          ..add(CustomerListCallEvent(
              1,
              CustomerPaginationRequest(
                  companyId: CompanyID,
                  loginUserID: LoginUserID,
                  CustomerID: "",
                  ListMode: "",
                  lstcontact: _contactsList)));
      });
    }
  }

  Future<void> MoveTofollowupHistoryPage(String CustomerID) {
    navigateTo(context, CustomerHistoryScreen.routeName,
            arguments: CustomerHistoryScreenArguments(CustomerID))
        .then((value) {});
  }

  Future<void> getContacts() async {
    _contactsList.clear();
    _contactsList.addAll(await OfflineDbHelper.getInstance().getContacts());
    setState(() {});
  }

  Future<void> _onTapOfDeleteALLContact() async {
    await OfflineDbHelper.getInstance().deleteContactTable();
  }

  void _onFetchCustomer_document_List(
      CustomerFetchDocumentResponseState state) {
    if (state.customerFetchDocumentResponse.details.length != 0) {
      if (state.FromWhichWidget == "FromAttachments") {
        if (state.customerFetchDocumentResponse.details.length != 0) {
          documentAPIList.clear();

          for (int i = 0;
              i < state.customerFetchDocumentResponse.details.length;
              i++) {
            CustomerFetchDocumentResponseDetails
                customerFetchDocumentResponseDetails =
                CustomerFetchDocumentResponseDetails();
            customerFetchDocumentResponseDetails.pkID =
                state.customerFetchDocumentResponse.details[i].pkID;
            customerFetchDocumentResponseDetails.customerID =
                state.customerFetchDocumentResponse.details[i].customerID;
            customerFetchDocumentResponseDetails.name =
                state.customerFetchDocumentResponse.details[i].name;
            ;
            customerFetchDocumentResponseDetails.customerName =
                state.customerFetchDocumentResponse.details[i].customerName;
            customerFetchDocumentResponseDetails.createdBy =
                state.customerFetchDocumentResponse.details[i].createdBy;
            customerFetchDocumentResponseDetails.createdDate =
                state.customerFetchDocumentResponse.details[i].createdDate;

            documentAPIList.add(customerFetchDocumentResponseDetails);
          }
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("View File"),
                      getCommonButton(baseTheme, () {
                        Navigator.pop(context);
                      }, "Close", width: 100, height: 30)
                    ],
                  ),
                  content: Container(
                      width: double.maxFinite,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            child: Row(
                              children: [
                                Card(
                                  elevation: 5,
                                  color: colorLightGray,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            urlToFile(
                                                _offlineCompanyData
                                                        .details[0].siteURL +
                                                    "/CustomerDocs/" +
                                                    documentAPIList[index]
                                                        .name
                                                        .toString(),
                                                documentAPIList[index].name);
                                          },
                                          child: Text(
                                            documentAPIList[index].name,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: colorPrimary),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: documentAPIList.length,
                      )),
                );
              });
        }
      } else {
        if (state.customerFetchDocumentResponse.details.length != 0) {
          documentAPIList.clear();

          for (int i = 0;
              i < state.customerFetchDocumentResponse.details.length;
              i++) {
            CustomerFetchDocumentResponseDetails
                customerFetchDocumentResponseDetails =
                CustomerFetchDocumentResponseDetails();
            customerFetchDocumentResponseDetails.pkID =
                state.customerFetchDocumentResponse.details[i].pkID;
            customerFetchDocumentResponseDetails.customerID =
                state.customerFetchDocumentResponse.details[i].customerID;
            customerFetchDocumentResponseDetails.name =
                state.customerFetchDocumentResponse.details[i].name;

            customerFetchDocumentResponseDetails.customerName =
                state.customerFetchDocumentResponse.details[i].customerName;
            customerFetchDocumentResponseDetails.createdBy =
                state.customerFetchDocumentResponse.details[i].createdBy;
            customerFetchDocumentResponseDetails.createdDate =
                state.customerFetchDocumentResponse.details[i].createdDate;

            documentAPIList.add(customerFetchDocumentResponseDetails);
          }

          _onTapOfEditCustomer(state.customerDetails, documentAPIList);
        } else {
          _onTapOfEditCustomer(state.customerDetails, documentAPIList);
        }
      }
    } else {
      /*  showCommonDialogWithSingleOption(context, "No Attachments Found !",
          positiveButtonTitle: "OK");*/

      _onTapOfEditCustomer(state.customerDetails, documentAPIList);
    }
  }

  urlToFile(String imageUrl, String filenamee) async {
    if (Uri.parse(imageUrl).isAbsolute == true) {
      try {
        http.Response response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode == 200) {
          Directory dir = await getApplicationDocumentsDirectory();
          dir.exists();
          String pathName = p.join(dir.path, filenamee);

          print("77575sdd7" + imageUrl);

          File file = new File(pathName);

          // var fileexist = file.exists();

          print("7757sds5sdd7" + file.path);

          try {
            await file.writeAsBytes(response.bodyBytes);
          } catch (e) {
            print("hdfhjfdhh" + e.toString());
          }
          OpenFile.open(file.path);
          // MultipleVideoList.add(file);
        }
      } catch (e) {
        print("775757" + e.toString());
      }

      setState(() {});
    }
  }

  void NearByCityDialog(BuildContext context,
      List<CityCodeToCustomerListResponseDetails> citytocustomerList) async {
    showNearByCityBottomSheet(context, citytocustomerList);
  }

  void showNearByCityBottomSheet(
    BuildContext context,
    List<CityCodeToCustomerListResponseDetails> citytocustomerList,
  ) async {
    final searchController = TextEditingController();
    List<CityCodeToCustomerListResponseDetails> filteredList = [
      ...citytocustomerList
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows full height expansion when needed[citation:1][citation:3]
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void performSearch(String query) {
              if (query.isEmpty) {
                setState(() {
                  filteredList = [...citytocustomerList];
                });
                return;
              }

              final searchLower = query.toLowerCase();
              setState(() {
                filteredList = citytocustomerList.where((customer) {
                  return customer.customerName
                              ?.toLowerCase()
                              .contains(searchLower) ==
                          true ||
                      customer.contactNo1
                              ?.toLowerCase()
                              .contains(searchLower) ==
                          true ||
                      customer.address?.toLowerCase().contains(searchLower) ==
                          true ||
                      customer.cityname?.toLowerCase().contains(searchLower) ==
                          true ||
                      customer.pinCode?.toLowerCase().contains(searchLower) ==
                          true;
                }).toList();
              });
            }

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header with title and close button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40), // Spacer for balance
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: colorPrimary, width: 1.5),
                          ),
                          child: Text(
                            "Near By Customers",
                            style: TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon:
                              Icon(Icons.close, color: colorPrimary, size: 24),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: performSearch,
                        decoration: InputDecoration(
                          hintText: "Search by name, mobile, city, pincode...",
                          border: InputBorder.none,
                          prefixIcon:
                              Icon(Icons.search, color: Colors.grey[500]),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear,
                                      color: Colors.grey[500]),
                                  onPressed: () {
                                    searchController.clear();
                                    performSearch('');
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Results count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Text(
                          "${filteredList.length} ${filteredList.length == 1 ? 'customer' : 'customers'} found",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        if (searchController.text.isNotEmpty)
                          Text(
                            "Search: \"${searchController.text}\"",
                            style: TextStyle(
                              color: colorPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Divider
                  const Divider(height: 1, thickness: 1),

                  // Customers List
                  Expanded(
                    child: filteredList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No customers found",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                  ),
                                ),
                                if (searchController.text.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "Try different search terms",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            itemCount: filteredList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (ctx, index) {
                              final model = filteredList[index];
                              return _buildCustomerCard(model, context);
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

  Widget _buildCustomerCard(
    CityCodeToCustomerListResponseDetails model,
    BuildContext context,
  ) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          // You can add additional logic here when a customer is selected
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[100]),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Name Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      model.customerName.isNotEmpty
                          ? model.customerName.substring(0, 1).toUpperCase()
                          : "N",
                      style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.customerName.isEmpty
                              ? "N/A"
                              : model.customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (model.contactNo1.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  model.contactNo1,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Address Section
              if (model.address.isNotEmpty)
                _buildInfoRow(
                  icon: Icons.location_on,
                  label: "Address",
                  value: model.address,
                ),
              if (model.address.isNotEmpty) const SizedBox(height: 12),

              // City & Pincode Row
              Row(
                children: [
                  if (model.cityname.isNotEmpty)
                    Expanded(
                      child: _buildInfoRow(
                        icon: Icons.location_city,
                        label: "City",
                        value: model.cityname,
                        compact: true,
                      ),
                    ),
                  if (model.cityname.isNotEmpty &&
                      model.pinCode?.isNotEmpty == true)
                    const SizedBox(width: 16),
                  if (model.pinCode?.isNotEmpty == true)
                    Expanded(
                      child: _buildInfoRow(
                        icon: Icons.numbers,
                        label: "PinCode",
                        value: model.pinCode,
                        compact: true,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    IconData icon,
    String label,
    String value,
    bool compact = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: compact ? 12 : 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: compact ? 13 : 14,
                ),
                maxLines: compact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _OnCityCodetoCustomerDetails(CityCodeToCustomerListResponseState state) {
    NearByCityDialog(context, state.response.details);
  }

  void _onFetchCustomer_ONly_document_List(
      CustomerOnlyFetchDocumentResponseState state) {
    if (state.FromWhichWidget == "FromAttachments") {
      if (state.customerFetchDocumentResponse.details.length != 0) {
        documentAPIList.clear();

        for (int i = 0;
            i < state.customerFetchDocumentResponse.details.length;
            i++) {
          CustomerFetchDocumentResponseDetails
              customerFetchDocumentResponseDetails =
              CustomerFetchDocumentResponseDetails();
          customerFetchDocumentResponseDetails.pkID =
              state.customerFetchDocumentResponse.details[i].pkID;
          customerFetchDocumentResponseDetails.customerID =
              state.customerFetchDocumentResponse.details[i].customerID;
          customerFetchDocumentResponseDetails.name =
              state.customerFetchDocumentResponse.details[i].name;
          ;
          customerFetchDocumentResponseDetails.customerName =
              state.customerFetchDocumentResponse.details[i].customerName;
          customerFetchDocumentResponseDetails.createdBy =
              state.customerFetchDocumentResponse.details[i].createdBy;
          customerFetchDocumentResponseDetails.createdDate =
              state.customerFetchDocumentResponse.details[i].createdDate;

          documentAPIList.add(customerFetchDocumentResponseDetails);
        }
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("View File"),
                    getCommonButton(baseTheme, () {
                      Navigator.pop(context);
                    }, "Close", width: 100, height: 30)
                  ],
                ),
                content: Container(
                    width: double.maxFinite,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          child: Row(
                            children: [
                              Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          urlToFile(
                                              _offlineCompanyData
                                                      .details[0].siteURL +
                                                  "/CustomerDocs/" +
                                                  documentAPIList[index]
                                                      .name
                                                      .toString(),
                                              documentAPIList[index].name);
                                        },
                                        child: Text(
                                          documentAPIList[index].name,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: colorPrimary),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: documentAPIList.length,
                    )),
              );
            });
      } else {
        showCommonDialogWithSingleOption(context, "No Attachments Found !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.pop(context);
        });
      }
    }
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);
      print("ldsj" +
          "MaenudNAme : " +
          menuRightsResponse.details[i].menuId.toString());

      if (menuRightsResponse.details[i].menuName == "lnkCustomer1") {
        _CustomerBloc.add(UserMenuRightsRequestEvent(
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
      print("DSFsdfkk" +
          " MenuName :" +
          state.userMenuRightsResponse.details[i].addFlag1.toString());

      IsAddRights = state.userMenuRightsResponse.details[i].addFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
      IsEditRights = state.userMenuRightsResponse.details[i].editFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
      IsDeleteRights = state.userMenuRightsResponse.details[i].delFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
    }
  }
}
