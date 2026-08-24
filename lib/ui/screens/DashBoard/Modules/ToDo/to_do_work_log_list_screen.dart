import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/todo/todo_bloc.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_worklog_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_worklog_list_response.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class ToDoWorkLogScreenArguments {
  String InqNo;
  ToDoWorkLogScreenArguments(this.InqNo);
}

class ToDoWorkLogScreen extends BaseStatefulWidget {
  static const routeName = '/ToDoWorkLogScreen';
  final ToDoWorkLogScreenArguments arguments;

  ToDoWorkLogScreen(this.arguments);
  @override
  _ToDoWorkLogScreenState createState() => _ToDoWorkLogScreenState();
}

class _ToDoWorkLogScreenState extends BaseState<ToDoWorkLogScreen>
    with BasicScreen, WidgetsBindingObserver {
  ToDoBloc _FollowupBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  String InqNo;
  String CustomerID;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;

  List<WorkLogDetails> arrTotdoList =[];

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    screenStatusBarColor = colorPrimary;
    _FollowupBloc = ToDoBloc(baseBloc);
    InqNo = widget.arguments.InqNo;
    _FollowupBloc
      .add(ToDoWorkLogListEvent(ToDoWorkLogListRequest(
          HeaderID: InqNo,
          CompanyId: CompanyID.toString(),
          LoginUserID: LoginUserID)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc..add(ToDoWorkLogListEvent(ToDoWorkLogListRequest(
          HeaderID: InqNo,
          CompanyId: CompanyID.toString(),
          LoginUserID: LoginUserID))),
      child: BlocConsumer<ToDoBloc, ToDoStates>(
        builder: (BuildContext context, ToDoStates state) {
          if (state is ToDoWorkLogListState) {
            _onSearchInquiryListCallSuccess(state.toDoWorkLogListResponse);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ToDoWorkLogListState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ToDoStates state) {},
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        NewGradientAppBar(
          title: Text('Work Log'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 15,
            ),
            child: Column(
              children: [Expanded(child: _buildInquiryList())],
            ),
          ),
        ),
      ],
    );
  }

  ///builds header and title view

  ///builds inquiry list
  Widget _buildInquiryList() {

    if (arrTotdoList.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _buildSearchInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: arrTotdoList.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_DATA_ANIMATED
            /*height: 200,
              width: 200*/
            ),
      );
    }
  }

  Widget _buildSearchInquiryListItem(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.02;
    double fontSize = screenWidth * 0.04;
    double fontSizeLabel = screenWidth * 0.037;

    WorkLogDetails model = arrTotdoList[index];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey[50],
        elevation: 8,
        shadowColor: Colors.blue[600],
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow1("Action : ", model.actionTaken.isNotEmpty ? model.actionTaken : "-", fontSizeLabel, fontSizeLabel * 1.1),
              _buildDetailRow1("Description : ", model.actionDescription ?? "-",  fontSizeLabel, fontSizeLabel * 1.1),
              _buildDetailRow1("Remarks : ", model.remarks.isNotEmpty ? model.remarks : "-",  fontSizeLabel, fontSizeLabel * 1.1),
              _buildDetailRow1("Initiated By : ", model.createdBy.isNotEmpty ? model.createdBy : "-",  fontSizeLabel, fontSizeLabel * 1.1),
              _buildDetailRow1("Initiated On : ", model.createdDate.getFormattedDate(fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ?? "-",  fontSizeLabel, fontSizeLabel * 1.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow1(String label, String value, double labelFontSize, double valueFontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle(labelFontSize)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.black87, fontSize: valueFontSize)),
          ),
        ],
      ),
    );
  }

  // Helper styles
  TextStyle _labelStyle(double fontSize) => TextStyle(
    color: Colors.blueAccent,
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
  );

  TextStyle _valueStyle(double fontSize) => TextStyle(
    color: Colors.black87,
    fontSize: fontSize,
  );

  /* ///builds row item view of inquiry list
  Widget _buildSearchInquiryListItem(int index) {
    WorkLogDetails model = arrTotdoList[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                Color(0xffffff8d),
                Color(0xffffff8d),
                Color(0xffb9f6ca),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Action",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color(label_color),
                              fontSize: _fontSize_Label,
                              letterSpacing: .3)),
                      SizedBox(
                        width: 5,
                      ),
                      Text(model.actionTaken == "" ? "N/A" : model.actionTaken,
                          style: TextStyle(
                              color: Color(title_color),
                              fontSize: _fontSize_Title,
                              letterSpacing: .3))
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: _buildTitleWithValueView(
                    "Description",
                    model.actionDescription.getFormattedDate(
                            fromFormat: "yyyy-MM-ddTHH:mm:ss",
                            toFormat: "dd-MM-yyyy") ??
                        "-"),
              ),
            ]),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            _buildTitleWithValueView(
                "Remarks",
                *//*model.referenceName ?? "-" *//*
                model.remarks == "" || model.remarks == null
                    ? '-'
                    : model.remarks),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            *//* Row(children: [
                  Expanded(
                   // child: _buildTitleWithValueView("No Followup", model.noFollowup.toString()),
                    child: _buildTitleWithValueView("No Followup", model.noFollowup.toString() == "false" ? 'no' : "yes"),
                  ),
                  Expanded(
                    child: _buildTitleWithValueView(
                        "Closer Reason", *//* *//*model.noFollClosureName ?? "-" *//* *//*
                        model.noFollClosureName == "--Not Available--" ||
                            model.noFollClosureName == null ? '-' : model
                            .noFollClosureName),
                  ),
                ]), *//*
            _buildTitleWithValueView(
                "Initiated By	",
                *//*model.referenceName ?? "-" *//*
                model.fromEmployeeName == "" || model.fromEmployeeName == null
                    ? '-'
                    : model.fromEmployeeName),
            _buildTitleWithValueView(
                "Initiated On	",
                *//*model.referenceName ?? "-" *//*
                model.createdDate.getFormattedDate(
                        fromFormat: "yyyy-MM-ddTHH:mm:ss",
                        toFormat: "dd-MM-yyyy hh:mm:ss a") ??
                    "-"),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
          ]),
        ),
      ),
    );
  }

  ///calls search list api

  Widget _buildTitleWithValueView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: _fontSize_Label,
                color: Color(0xFF504F4F),
                *//*fontWeight: FontWeight.bold,*//* fontStyle: FontStyle
                    .italic) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
        SizedBox(
          height: 3,
        ),
        Text(value,
            style: TextStyle(
                fontSize: _fontSize_Title,
                color:
                    colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            )
      ],
    );
  }*/

  void _onSearchInquiryListCallSuccess(
      ToDoWorkLogListResponse toDoWorkLogListResponse) {
    arrTotdoList.clear();
    for(int i=0;i<toDoWorkLogListResponse.details.length;i++)
      {
        WorkLogDetails workLogDetails = toDoWorkLogListResponse.details[i];
        arrTotdoList.add(workLogDetails);
      }
   // _searchCustomerListResponse = toDoWorkLogListResponse;
  }
}
