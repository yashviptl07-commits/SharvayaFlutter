import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:soleoserp/models/api_responses/customer/customer_details_api_response.dart';
import 'package:soleoserp/models/common/contact_model.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'add_contact_screen.dart';

class ContactsListScreen extends BaseStatefulWidget {
  static const routeName = '/_contactsListListScreen';

  @override
  _ContactsListScreenState createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends BaseState<ContactsListScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<ContactModel> _contactsList = [];
  CustomerDetails _editModel;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    getContacts();
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Column(
        children: [
          getCommonAppBar(context, baseTheme, "Contacts List", showBack: true,
              onTapOfBack: () {
            Navigator.pop(context, _editModel);
          }),
          Expanded(
            child: Stack(
              children: [
                _buildContactsListView(),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: colorPrimary,
                    onPressed: () async {
                      await navigateTo(context, AddContactScreen.routeName);
                      getContacts();
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    Navigator.pop(context, _editModel);
    return Future.value(false);
  }

  Widget _buildContactsListView() {
    if (_contactsList.length != 0) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _buildInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _contactsList.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_DATA_ANIMATED),
      );
    }
  }

  Future<void> getContacts() async {
    _contactsList.clear();
    _contactsList.addAll(await OfflineDbHelper.getInstance().getContacts());
    setState(() {});
  }

  Future<void> _onTapOfEditContact(int index) async {
    await navigateTo(context, AddContactScreen.routeName,
        arguments: AddContactScreenArguments(_contactsList[index]));
    getContacts();
  }

  Future<void> _onTapOfDeleteContact(int index) async {
    await OfflineDbHelper.getInstance().deleteContact(_contactsList[index].id);
    setState(() {
      _contactsList.removeAt(index);
    });
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.04;
    double fontSizeLabel = screenWidth * 0.037;
    double fontSize = screenWidth * 0.04;
    ContactModel model = _contactsList[index];

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[50],
        elevation: 8,
        shadowColor: Colors.blue[600],
        child: Padding(
          padding: EdgeInsets.only(left: padding, right: padding, top: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customer Name", style: _labelStyle(fontSize)),
                  Text(
                    model.ContactPerson1,
                    overflow: TextOverflow.ellipsis,
                    style: _valueStyle(fontSize),
                  ),
                ],
              ),
              Divider(thickness: 1.0, color: Colors.grey[300]),
              Padding(
                padding: EdgeInsets.only(top: padding / 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Contact No	: ", model.ContactNumber1,
                        fontSizeLabel, fontSizeLabel * 1.1),
                    _buildDetailRow("Email : ", model.ContactEmail1,
                        fontSizeLabel, fontSizeLabel * 1.1),
                    _buildDetailRow(
                        "Designation : ",
                        model.ContactDesignationName,
                        fontSizeLabel,
                        fontSizeLabel * 1.1),
                  ],
                ),
              ),
              Divider(thickness: 1.0, color: Colors.grey[300]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _onTapOfEditContact(index),
                    icon: Icon(Icons.edit, size: 20),
                    label: Text("Update"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      showCommonDialogWithTwoOptions(
                        context,
                        "Are you sure you want to delete this record?",
                        negativeButtonTitle: "No",
                        positiveButtonTitle: "Yes",
                        onTapOfPositiveButton: () {
                          Navigator.of(context).pop();
                          _onTapOfDeleteContact(index);
                        },
                      );
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
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _valueStyle(double fontSize) => TextStyle(
        color: Colors.black87,
        fontSize: fontSize,
      );

// Helper styles for labels and titles
  TextStyle _labelStyle(double fontSize) => TextStyle(
        color: Colors.blueAccent,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      );

  Widget _buildDetailRow(
      String label, String value, double labelFontSize, double valueFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle(labelFontSize)),
          Expanded(
            child: Text(value,
                style:
                    TextStyle(color: Colors.black87, fontSize: valueFontSize)),
          ),
        ],
      ),
    );
  }
}
