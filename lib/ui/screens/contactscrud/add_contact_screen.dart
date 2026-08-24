import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/other/bloc_modules/customer/customer_bloc.dart';
import 'package:soleoserp/models/api_requests/other/designation_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/contact_model.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_filds.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class AddContactScreenArguments {
  ContactModel model;

  AddContactScreenArguments(this.model);
}

class AddContactScreen extends BaseStatefulWidget {
  static const routeName = '/addContactsScreen';
  final AddContactScreenArguments arguments;

  AddContactScreen(this.arguments);

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends BaseState<AddContactScreen>
    with BasicScreen, WidgetsBindingObserver {
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _designationController = TextEditingController();
  TextEditingController _designationCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isForUpdate = false;
  String LoginUserID = "";
  CustomerBloc _CustomerBloc;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Designation = [];
  bool emailValid;
  bool IsConforomedtoExitScreen;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    emailValid = false;
    IsConforomedtoExitScreen = false;
    if (widget.arguments != null) {
      isForUpdate = true;
      _nameController.text = widget.arguments.model.ContactPerson1;
      _emailController.text = widget.arguments.model.ContactEmail1;
      _mobileController.text = widget.arguments.model.ContactNumber1;
      _designationController.text =
          widget.arguments.model.ContactDesignationName;
      _designationCode.text = widget.arguments.model.ContactDesigCode1;
    }
    _CustomerBloc = CustomerBloc(baseBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc,
      child: BlocConsumer<CustomerBloc, CustomerStates>(
        builder: (BuildContext context, CustomerStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, CustomerStates state) {
          if (state is DesignationListEventResponseState) {
            _onDesignationCallSuccess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is DesignationListEventResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        getCommonAppBar(
            context, baseTheme, "${isForUpdate ? "Update" : "Add"} Contact",
            showBack: true, showHome: true),
        Expanded(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTextField(
                    label: "Customer Name *",
                    hint: "Enter Customer Name",
                    controller: _nameController,
                    icon: Icons.person,
                    context: context,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the customer name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextField(
                    label: "Contact No *",
                    hint: "Enter Contact No",
                    controller: _mobileController,
                    icon: Icons.phone,
                    context: context,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the contact no";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextField(
                    label: "Email Address",
                    hint: "Enter Email Address",
                    controller: _emailController,
                    icon: Icons.email,
                    context: context,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the email address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildCommonDropDown(
                    label: "Designation",
                    context: context,
                    nameController: _designationController,
                    idController: _designationCode,
                    hintText: "--- Select ---",
                    CommonList: arr_ALL_Name_ID_For_Designation,
                    onTap: () {
                      _CustomerBloc.add(DesignationCallEvent(
                          DesignationApiRequest(
                              DesigCode: "",
                              CompanyId: _offlineCompanyData.details[0].pkId
                                  .toString())));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  buildCommonButton(
                      text: isForUpdate == true ? "Update" : "Add",
                      context: context,
                      onPressed: _onTapOfAdd),
                ],
              ),
            ),
          )),
        ),
      ],
    );
  }

  _onTapOfAdd() {
    if (_formKey.currentState.validate()) {
      showCommonDialogWithTwoOptions(
          context, "Are you sure you want to Save Contact Details ?",
          negativeButtonTitle: "No",
          positiveButtonTitle: "Yes", onTapOfPositiveButton: () async {
        if (isForUpdate) {
          await OfflineDbHelper.getInstance().updateContact(ContactModel(
              "0",
              "0",
              _designationController.text.toString().trim(),
              _designationCode.text.toString().trim(),
              "0",
              _nameController.text.toString().trim(),
              _mobileController.text.toString().trim(),
              _emailController.text.toString().trim(),
              "admin",
              id: widget.arguments.model.id));
        } else {
          await OfflineDbHelper.getInstance().insertContact(ContactModel(
              "0",
              "0",
              _designationController.text.toString().trim(),
              _designationCode.text.toString().trim(),
              "0",
              _nameController.text.toString().trim(),
              _mobileController.text.toString().trim(),
              _emailController.text.toString().trim(),
              "admin"));
        }
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    }
  }

  void _onDesignationCallSuccess(DesignationListEventResponseState state) {
    arr_ALL_Name_ID_For_Designation.clear();

    if (state.designationApiResponse.details.isNotEmpty) {
      for (var item in state.designationApiResponse.details) {
        arr_ALL_Name_ID_For_Designation.add(
          ALL_Name_ID()
            ..Name = item.designation
            ..Name1 = item.desigCode,
        );
      }

      showCustomDialog(
        context: context,
        label: "Select Designation",
        values: arr_ALL_Name_ID_For_Designation,
        nameController: _designationController,
        idController: _designationCode,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No designations found")),
      );
    }
  }

  void showCustomDialog({
    BuildContext context,
    String label,
    List<ALL_Name_ID> values,
    TextEditingController nameController,
    TextEditingController idController,
  }) {
    TextEditingController searchController = TextEditingController();
    List<ALL_Name_ID> filteredList = List.from(values);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Column(
                children: [
                  Text(label,
                      style: TextStyle(
                          color: colorPrimary, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (val) {
                      setState(() {
                        filteredList = values
                            .where((item) => item.Name.toLowerCase()
                                .contains(val.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ],
              ),
              content: SizedBox(
                height: 300,
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      onTap: () {
                        nameController.text = filteredList[index].Name;
                        idController.text = filteredList[index].Name1 ?? "";
                        Navigator.pop(context);
                      },
                      title: Text(filteredList[index].Name),
                      leading: Icon(Icons.person, color: colorPrimary),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("CLOSE", style: TextStyle(color: colorPrimary)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget CustomDropDownWithAPI({
    String label,
    TextEditingController nameController,
    TextEditingController idController,
    List<ALL_Name_ID> valueList,
    VoidCallback onFetch,
    BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colorPrimary)),
        ),
        SizedBox(height: 6),
        InkWell(
          onTap: () {
            onFetch(); // Trigger API call via Bloc
          },
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: colorLightGray,
            child: Container(
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nameController,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: "Tap to select",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  if (nameController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        nameController.clear();
                        idController.clear();
                      },
                      child: Icon(Icons.close, color: Colors.grey),
                    )
                  else
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
