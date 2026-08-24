import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class VehicleListDropDownScreenArgument {
  List<ALL_Name_ID> editModel;
  String Title;
  String SubTitle;
  String hintTitle;

  VehicleListDropDownScreenArgument(
      this.editModel, this.Title, this.SubTitle, this.hintTitle);
}

class VehicleListDropDownScreen extends BaseStatefulWidget {
  static const routeName = '/VehicleListDropDown';
  final VehicleListDropDownScreenArgument arguments;
  VehicleListDropDownScreen(this.arguments);

  @override
  _VehicleListDropDownScreenState createState() =>
      _VehicleListDropDownScreenState();
}

class _VehicleListDropDownScreenState
    extends BaseState<VehicleListDropDownScreen>
    with BasicScreen, WidgetsBindingObserver {

  bool _isSearching = false; // Flag for toggling search
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Category = [];
  List<ALL_Name_ID> _allUsers = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;

    arr_ALL_Name_ID_For_Category = widget.arguments.editModel;
    _allUsers = widget.arguments.editModel;
  }

  @override
  Widget buildBody(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: colorWhite,
          elevation: 0,
          title: _isSearching
              ? TextField(
            controller: _searchController,
            autofocus: true,
            style: TextStyle(color: Colors.black, fontSize: 18),
            decoration: InputDecoration(
              hintText: "Search ${widget.arguments.hintTitle}...",
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              _runFilter(value);
            },
          )
              : Text(
            widget.arguments.Title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          leading: Container(
            margin: EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop("clear");
              },
            ),
          ),
          actions: <Widget>[
            _isSearching
                ? IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _runFilter(""); // Reset search filter
                });
              },
            )
                : IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },),SizedBox(width: 10)
          ],
        ),
        body: Container(
          color: colorWhite,
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 15,
          ),
          child: Column(
            children: [
              Expanded(child: _buildInquiryList())
            ],
          ),
        ),
      );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 20),
          child: Text(widget.arguments.SubTitle,
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: Colors.grey.shade200,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      _runFilter(value);
                    },
                    decoration: InputDecoration(
                      hintText: widget.arguments.hintTitle,
                      border: InputBorder.none,
                    ),
                    style: baseTheme.textTheme.subtitle2
                        .copyWith(color: colorBlack),
                  ),
                ),
                Icon(
                  Icons.search,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    return arr_ALL_Name_ID_For_Category.isNotEmpty
        ? ListView.builder(
      itemBuilder: (context, index) {
        return _buildSearchInquiryListItem(index);
      },
      shrinkWrap: true,
      itemCount: arr_ALL_Name_ID_For_Category.length,
    )
        : Text(
      'No results found',
      style: TextStyle(fontSize: 24),
    );
  }

  ///builds row item view of inquiry list
  Widget _buildSearchInquiryListItem(int index) {
    ALL_Name_ID model = arr_ALL_Name_ID_For_Category[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(model);
        },
        child: Card(
          elevation: 10,
          shadowColor: Colors.blue,
          color: Colors.grey[100],
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
            child: Text(
              model.Name,
              style: baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
          ),
          margin: EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  void _runFilter(String query) {
    List<ALL_Name_ID> temp = [];
    _allUsers.forEach((item) {
      if (item.Name.toLowerCase().contains(query.toLowerCase())) {
        temp.add(item);
      }
    });
    setState(() {
      arr_ALL_Name_ID_For_Category = temp;
    });
  }
}
