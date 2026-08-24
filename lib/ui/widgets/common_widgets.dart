import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:intl/intl.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:ntp/ntp.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/Mudra_Attend_Visit_Module/mudra_Attend_visit_list_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/Mudra_Complaint_Module/Mudra_Complaint_List_Screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/quick_support_screen/quick_support_list/quick_support_list_screen.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/list/acurabath_qt_list_screen.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/custom_text_editing_controller.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/dimen_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Background.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/customer/list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/purchase_bill/list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ACCURABATH/accurabath_complaint/accurabath_complaint_listing_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Attend_Visit/Attend_Visit_List/attend_visit_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Complaint/complaint_pagination_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerList/customer_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Daily_Activity_For_Sharvaya/Daily_Activity_For_Sharvaya_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Installation/installation_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Material_Inward/Material_Inward/Material_Inward_Header_Screen/Material_Inward_Header_List_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/OfficeTODO/office_to_do.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_Order_screens/purchase_order_list_screen/Po_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_bill_screens/purchase_bill_list_screen/purchase_bill_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_order_approval/purchase_order_approval_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Repairing/repairing_header_screen/repairing_header_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Service_Report/Service_Report_Header/Service_Report_Header_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/to_do_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Visitor_Info_Screens/visitor_info_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/asset_screen/asset_issue_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/asset_screen/asset_return_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/attendance/employee_attendance_list_general.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/bank_voucher1/BankVoucher_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/cash_voucher/cash_voucher_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/daily_activity/daily_activity_list/daily_activity_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/dash_board_widgets/toDo_sharvaya_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/employee/employee_list/employee_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Expense_Tracking_nikhil/expense_tracking_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/expense/expense_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/external_lead/external_lead_list/external_lead_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/final_checking/final_checking_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/followup_pagination_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/general_followup/general_followup_list_for_almighty_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/general_followup/general_followup_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/hema_auto_attend_visit/hema_attend_visit_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/Mudra_inquiry_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/leave_request/leave_request_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/leave_request_approval/leave_approval_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/loan/loan_list/loan_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/loan_approval/loan_approval_list/loan_approval_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/maintenance/maintenance_list/maintenance_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/manage_accounts/credit_notes_screens/credit_notes_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/manage_accounts/debit_notes_screens/debit_notes_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/manage_accounts/journal_coucher_screen/journal_coucher_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/manage_accounts/petty_cash_screen/petty_cash_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/manage_accounts/trial_balance_sheet_screen/trial_balance_sheet_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_indent_approval_screen/material_indent_approval_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_outward_screen/mo_header_screen/header_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/missed_punch/missed_punch_list/missed_punch_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/missed_punch_approval/missed_punch_approval_list/missed_punch_approval_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/multiple_expense/me_approval/me_approval_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/multiple_expense/me_header/me_header_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/packing_checklist/packing_checklist_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/pay_slip_screen/pay_slip_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/product_master/product_master_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/production_activity/production_activity_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quick_followup/quick_followup_list/quick_followup_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quick_inquiry/quick_inquiry_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salary_upad/salary_upad_list/salary_upad_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sale_bill_list/sales_bill_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/sales_order_approval/sales_order_approval_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/sales_target/sales_target_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/salesorder_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/short_invoice/short_invoice_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller/telecaller_list/telecaller_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller_new/telecaller_new_pagintion.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/vk_sound_complaint/vk_sound_list/vk_sound_complain_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/authentication/first_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

double sizeboxsize = 20;
double _fontSize_Label = 10;
double _fontSize_Title = 15;
int label_color = 0x66666666;
int title_color = 0xFF000000;

List<ALL_Name_ID> DASHBOARD_WIDGET;

List<ALL_Name_ID> SALES;
List<ALL_Name_ID> Leads;
List<ALL_Name_ID> AccountList;

List<ALL_Name_ID> HR;
List<ALL_Name_ID> Purchase;

List<ALL_Name_ID> Office;
List<ALL_Name_ID> Support;
List<ALL_Name_ID> Production;
List<ALL_Name_ID> Dealer;

final primary = Colors.indigo;
final secondary = Colors.black;
final background = Colors.white10;

LoginUserDetialsResponse _offlineLoggedInData =
    SharedPrefHelper.instance.getLoginUserData();
CompanyDetailsResponse _offlineCompanyData =
    SharedPrefHelper.instance.getCompanyData();

Widget getCommonTextFormField(
  BuildContext context,
  ThemeData baseTheme, {
  String title: "",
  String hint: "",
  TextInputAction textInputAction: TextInputAction.next,
  bool obscureText: false,
  EdgeInsetsGeometry contentPadding: const EdgeInsets.only(top: 0, bottom: 10),
  int maxLength: 1000,
  TextAlign textAlign: TextAlign.left,
  TextEditingController controller,
  TextInputType keyboardType,
  FormFieldValidator<String> validator,
  int maxLines: 1,
  Function(String) onSubmitted,
  Function(String) onTextChanged,
  TextStyle titleTextStyle,
  TextCapitalization textCapitalization = TextCapitalization.none,
  TextStyle inputTextStyle,
  List<TextInputFormatter> inputFormatter,
  bool readOnly: false,
  Widget suffixIcon,
  Color labelColor: colorPrimary,
}) {
  if (titleTextStyle == null) {
    titleTextStyle = baseTheme.textTheme.subtitle1;
  }
  if (inputTextStyle == null) {
    inputTextStyle = baseTheme.textTheme.subtitle2;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title.isNotEmpty
          ? Container(
              child: /*Text(
          title,
          style: titleTextStyle,
        ),*/
                  Text(
              title,
              style: TextStyle(
                color: labelColor,
                fontSize: 18,
              ),
            ))
          : Container(),
      TextFormField(
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatter,
        keyboardType: keyboardType,
        style: inputTextStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        cursorColor: colorPrimaryLight,
        textInputAction: textInputAction,
        obscureText: obscureText,
        readOnly: readOnly,
        maxLength: maxLength,
        controller: controller,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: inputTextStyle.copyWith(color: colorGray),
          isDense: true,
          suffixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
          contentPadding: EdgeInsets.only(bottom: 10, top: 15),
          suffixIcon: suffixIcon,
          counterText: "",
          errorStyle: baseTheme.textTheme.subtitle1.copyWith(
              color: Colors.red, fontSize: CAPTION_SMALLER_TEXT_FONT_SIZE),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorGrayDark, width: 0.4),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorPrimaryLight, width: 1),
          ),
        ),
        validator: validator,
        onChanged: onTextChanged,
        onFieldSubmitted: onSubmitted,
      )
    ],
  );
}

Widget getCommonTextFormFieldFloating(BuildContext context, ThemeData baseTheme,
    {String title: "",
    TextInputAction textInputAction: TextInputAction.next,
    bool obscureText: false,
    EdgeInsetsGeometry contentPadding:
        const EdgeInsets.only(top: 0, bottom: 14),
    int maxLength: 1000,
    TextEditingController controller,
    TextInputType keyboardType,
    FormFieldValidator<String> validator,
    int maxLines: 1,
    Function(String) onSubmitted,
    Function(String) onTextChanged,
    EdgeInsetsGeometry margin: const EdgeInsets.only(top: 30),
    TextStyle titleTextStyle,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextStyle inputTextStyle,
    List<TextInputFormatter> inputFormatters,
    bool readOnly: false,
    double labelHeight: 0.4,
    Widget suffixIcon}) {
  if (titleTextStyle == null) {
    titleTextStyle =
        baseTheme.textTheme.bodyText2.copyWith(height: labelHeight);
  }
  if (inputTextStyle == null) {
    inputTextStyle = baseTheme.textTheme.bodyText1;
  }
  if (onSubmitted == null && textInputAction == TextInputAction.next) {
    onSubmitted = (value) {
      FocusScope.of(context).nextFocus();
    };
  }
  return Container(
    margin: margin,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: TextFormField(
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            cursorColor: colorPrimaryLight,
            keyboardType: keyboardType,
            style: inputTextStyle,
            maxLines: maxLines,
            textInputAction: textInputAction,
            obscureText: obscureText,
            readOnly: readOnly,
            maxLength: maxLength,
            controller: controller,
            obscuringCharacter: "*",
            decoration: InputDecoration(
              labelText: title,
              hintStyle: titleTextStyle,
              labelStyle: titleTextStyle,
              suffixIcon: suffixIcon,
              counterText: "",
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: contentPadding,
              errorStyle: baseTheme.textTheme.subtitle1.copyWith(
                  color: Colors.red, fontSize: CAPTION_SMALLER_TEXT_FONT_SIZE),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorTextTitleGray, width: 0.4),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorPrimaryLight, width: 1),
              ),
            ),
            validator: validator,
            onChanged: onTextChanged,
          ),
          margin: EdgeInsets.only(top: 0),
        )
      ],
    ),
  );
}

Widget getCommonTextFormFieldFloatingWithCustomError(
    BuildContext context, ThemeData baseTheme,
    {String title: "",
    TextInputAction textInputAction: TextInputAction.next,
    bool obscureText: false,
    EdgeInsetsGeometry contentPadding:
        const EdgeInsets.only(top: 0, bottom: 14),
    int maxLength: 1000,
    CustomTextEditingController customController,
    TextInputType keyboardType,
    GestureTapCallback onTap,
    Function validator,
    int maxLines: 1,
    Function(String) onSubmitted,
    Function(String) onTextChanged,
    FocusNode focusNode,
    EdgeInsetsGeometry margin: const EdgeInsets.only(top: 30),
    TextStyle titleTextStyle,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextStyle inputTextStyle,
    List<TextInputFormatter> inputFormatters,
    bool readOnly: false,
    double labelHeight: 0.4,
    Widget suffixIcon}) {
  if (titleTextStyle == null) {
    titleTextStyle =
        baseTheme.textTheme.bodyText2.copyWith(height: labelHeight);
  }
  if (inputTextStyle == null) {
    inputTextStyle = baseTheme.textTheme.bodyText1;
  }

  final Widget widget = StatefulBuilder(
      builder: (BuildContext context, StateSetter updateWidget) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: TextFormField(
              textCapitalization: textCapitalization,
              inputFormatters: inputFormatters,
              cursorColor: colorPrimaryLight,
              focusNode: focusNode,
              keyboardType: keyboardType,
              style: inputTextStyle,
              maxLines: maxLines,
              textInputAction: textInputAction,
              obscureText: obscureText,
              readOnly: readOnly,
              onFieldSubmitted: onSubmitted,
              onSaved: onSubmitted,
              maxLength: maxLength,
              onTap: onTap,
              controller: customController.controller,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                labelText: title,
                hintStyle: titleTextStyle,
                labelStyle: titleTextStyle,
                suffixIcon: (suffixIcon != null || customController.showError)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          suffixIcon == null
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: suffixIcon),
                          SizedBox(
                            width: customController.showError ? 5 : 0,
                          ),
                          customController.showError
                              ? Container(
                                  width: TEXT_FORM_FIELD_SUFFIX_ICON,
                                  child: Image.asset(
                                    IC_ERROR,
                                    width: TEXT_FORM_FIELD_SUFFIX_ICON,
                                    height: TEXT_FORM_FIELD_SUFFIX_ICON,
                                  ))
                              : Container(),
                        ],
                      )
                    : null,
                counterText: "",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                contentPadding: contentPadding,
                errorStyle: baseTheme.textTheme.subtitle1.copyWith(
                    color: Colors.red,
                    fontSize: CAPTION_SMALLER_TEXT_FONT_SIZE),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorTextTitleGray, width: 0.4),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorPrimaryLight, width: 1),
                ),
              ),
              validator: (value) {
                updateWidget(() {
                  if (validator(value) != null) {
                    customController.showError = true;
                  } else {
                    customController.showError = false;
                  }
                });
                return validator(value);
              },
              onChanged: onTextChanged,
            ),
            margin: EdgeInsets.only(top: 0),
          )
        ],
      ),
    );
  });
  return widget;
}

Widget getCommonBoxTextFormField(
  ThemeData baseTheme, {
  String title: "",
  TextInputAction textInputAction: TextInputAction.next,
  bool obscureText: false,
  EdgeInsetsGeometry contentPadding: const EdgeInsets.all(5),
  int maxLength: 1000,
  double spaceBetweenTitleBox: 0,
  TextEditingController controller,
  TextInputType keyboardType,
  FormFieldValidator<String> validator,
  Function(String) onSubmitted,
  Function(String) onTextChanged,
  EdgeInsetsGeometry margin: const EdgeInsets.only(top: 30),
  TextStyle titleTextStyle,
  TextCapitalization textCapitalization = TextCapitalization.none,
  TextStyle inputTextStyle,
  int maxLines: 3,
  Color enabledBorderColor: colorGrayDark,
  Color focusedBorderColor: colorPrimaryDark,
  double boxRadius: 0,
  TextAlign textAlign = TextAlign.start,
  List<TextInputFormatter> inputFormatters,
}) {
  if (titleTextStyle == null) {
    titleTextStyle = baseTheme.textTheme.subtitle2;
  }
  if (inputTextStyle == null) {
    inputTextStyle = baseTheme.textTheme.bodyText2;
  }

  return Container(
    margin: margin,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isEmpty
            ? Container()
            : Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  title,
                  style: titleTextStyle,
                ),
              ),
        Container(
          margin: EdgeInsets.only(top: spaceBetweenTitleBox),
          child: TextFormField(
            textCapitalization: textCapitalization,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            style: inputTextStyle,
            textInputAction: textInputAction,
            obscureText: obscureText,
            maxLength: maxLength,
            textAlign: textAlign,
            controller: controller,
            obscuringCharacter: "*",
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              counterText: "",
              errorStyle: baseTheme.textTheme.subtitle1.copyWith(
                  color: Colors.red, fontSize: CAPTION_SMALLER_TEXT_FONT_SIZE),
              contentPadding: contentPadding,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: enabledBorderColor, width: 0.4),
                  borderRadius: BorderRadius.circular(boxRadius)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: focusedBorderColor, width: 1),
                  borderRadius: BorderRadius.circular(boxRadius)),
            ),
            validator: validator,
            onChanged: onTextChanged,
            onFieldSubmitted: onSubmitted,
          ),
        )
      ],
    ),
  );
}

Widget getCommonBottomSheetTitleView({
  @required ThemeData baseTheme,
  @required BuildContext context,
  @required String title,
  String actionTitle = "",
  GestureTapCallback onActionButtonTap,
}) {
  return Container(
    height: 35,
    margin: const EdgeInsets.only(top: 5),
    child: Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Container(
          width: double.maxFinite,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: baseTheme.textTheme.bodyText1,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Image.asset(IC_CLOSE),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            InkWell(
              onTap: onActionButtonTap,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  actionTitle,
                  style: baseTheme.textTheme.caption,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget getCircleImage(String url, double radius,
    {String errorPlaceHolderImage = IC_USER_IMAGE_PLACEHOLDER,
    Widget loader,
    Color errorPlaceHolderBackgroundColor: Colors.transparent,
    File imageFile,
    Color loaderColor: colorPrimaryDark}) {
  if (url == null) {
    url = "";
  }
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: imageFile == null
        ? Image.network(
            url,
            width: radius,
            height: radius,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                  child: Container(
                height: radius,
                width: radius,
                decoration: BoxDecoration(
                    color: errorPlaceHolderBackgroundColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          errorPlaceHolderImage,
                        ))),
              ));
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return loader == null
                  ? Container(
                      width: radius,
                      height: radius,
                      child: Stack(
                        children: [
                          Center(
                              child: Container(
                            height: radius,
                            width: radius,
                            decoration: BoxDecoration(
                                color: errorPlaceHolderBackgroundColor,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      errorPlaceHolderImage,
                                    ))),
                          )),
                          Center(
                            child: Container(
                              width: radius / 2,
                              height: radius / 2,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      loaderColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : loader;
            },
          )
        : Image.file(
            imageFile,
            fit: BoxFit.cover,
            width: radius,
            height: radius,
          ),
  );
}

Widget getSquareImage(String url, double width, double height,
    {String errorPlaceHolderImage = IC_USER_IMAGE_PLACEHOLDER,
    Widget loader,
    Color errorPlaceHolderBackgroundColor = Colors.transparent,
    Color loaderColor: colorPrimaryDark}) {
  if (url == null) {
    url = "";
  }
  return Container(
    width: width,
    height: height,
    color: errorPlaceHolderBackgroundColor,
    child: Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Center(
            child: Container(
          height: width,
          width: height,
          decoration: BoxDecoration(
              color: errorPlaceHolderBackgroundColor,
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    errorPlaceHolderImage,
                  ))),
        ));
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return loader == null
            ? Container(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    Center(
                        child: Image.asset(
                      errorPlaceHolderImage,
                      height: width,
                      color: errorPlaceHolderBackgroundColor,
                      fit: BoxFit.cover,
                      width: width,
                    )),
                    Center(
                      child: Container(
                        width: width / 2,
                        height: height / 2,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(loaderColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : loader;
      },
    ),
  );
}

Widget getCommonImage(String path,
    {double width: double.maxFinite,
    double height,
    BoxFit fit: BoxFit.fitWidth,
    Widget errorWidget}) {
  return Image.network(
    path,
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (context, error, stackTrace) {
      print("Error loading image - $path\n$error");
      if (errorWidget != null) {
        return errorWidget;
      }
      return Container();
    },
  );
}

Widget getCommonEmptyView({message: "No data found"}) {
  return Center(
    child: Text(
      message,
      style: TextStyle(fontSize: 16),
    ),
  );
}

Widget getCommonDivider({double thickness, double width: double.maxFinite}) {
  if (thickness == null) {
    thickness = COMMON_DIVIDER_THICKNESS;
  }
  return Container(
    height: thickness,
    color: colorGray,
    width: width,
  );
}

Widget getCommonVerticalDivider(
    {double thickness, double height: double.maxFinite}) {
  if (thickness == null) {
    thickness = COMMON_DIVIDER_THICKNESS;
  }
  return Container(
    width: thickness,
    color: colorGray,
    height: height,
  );
}

///add here common header if app have in each screen
Widget getCommonHeaderLogo() {
  //TODO
}

Widget getCommonButtonWithImage(
    ThemeData baseTheme, Function onPressed, String text, String image,
    {Color textColor: colorWhite,
    Color backGroundColor: colorPrimary,
    double elevation: 5.0,
    double radius: COMMON_BUTTON_RADIUS}) {
  return Container(
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(90, 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(COMMON_BUTTON_RADIUS),
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              image,
              height: 22,
              fit: BoxFit.fitHeight,
            ),
          ),
          Text(
            text,
            style: baseTheme.textTheme.button.copyWith(color: textColor),
          ),
        ],
      ),
    ),
    /* RaisedButton(
      onPressed: onPressed,
      padding: EdgeInsets.only(left: 20.0, right: 10),
      color: backGroundColor,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(COMMON_BUTTON_RADIUS))),
      elevation: elevation,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              image,
              height: 22,
              fit: BoxFit.fitHeight,
            ),
          ),
          Text(
            text,
            style: baseTheme.textTheme.button.copyWith(color: textColor),
          ),
        ],
      ),
    ),*/
  );
}

Widget getCommonButton(ThemeData baseTheme, Function onPressed, String text,
    {Color textColor: colorWhite,
    Color backGroundColor: colorPrimary,
    double elevation: 0.0,
    bool showOnlyBorder: false,
    Color borderColor: colorPrimary,
    double textSize: BUTTON_TEXT_FONT_SIZE,
    double width: double.maxFinite,
    double height: COMMON_BUTTON_HEIGHT,
    double radius: COMMON_BUTTON_RADIUS}) {
  if (!showOnlyBorder) {
    borderColor = backGroundColor;
  }
  return Container(
    width: width,
    height: height,
    child: /*RaisedButton(
      onPressed: onPressed,
      color: backGroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          side: BorderSide(width: showOnlyBorder ? 2 : 0, color: borderColor)),
      elevation: elevation,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: baseTheme.textTheme.button
            .copyWith(color: textColor, fontSize: textSize),
      ),
    ),*/

        ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(90, 15),
        backgroundColor: backGroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            side:
                BorderSide(width: showOnlyBorder ? 2 : 0, color: borderColor)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: baseTheme.textTheme.button
            .copyWith(color: textColor, fontSize: textSize),
      ),
    ),
  );
}

Widget getCommonAppBar(
  BuildContext context,
  ThemeData baseTheme,
  String title, {
  VoidCallback onTapOfBack,
  bool showBack = true,
  bool showHome = false, // Optional future home icon
}) {
  return Container(
    height: DEFAULT_APP_BAR_HEIGHT,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    color: colorPrimary,
    child: Row(
      children: [
        InkWell(
          onTap: () {
            if (onTapOfBack != null) {
              onTapOfBack();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Text(
            title,
            style: baseTheme.textTheme.headline6?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

///This Widgets For Login Screens
///_________________________________________________
Widget buildLogoImage(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
    height: 80.0,
    width: 250.0,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/custom_logo_icon/soleos_logo.png'),
        fit: BoxFit.fill,
      ),
      shape: BoxShape.rectangle,
    ),
  );
}

Widget buildLoginTitle() {
  return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Text(
        'Login',
        maxLines: 20,
        style: TextStyle(
            fontSize: 35.0, fontWeight: FontWeight.bold, color: Colors.black),
      ));
}

Widget buildLoginSubTitle() {
  return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Text(
        'Log in to your existing account ',
        maxLines: 20,
        style: TextStyle(
            fontSize: 15.0, fontWeight: FontWeight.w300, color: Colors.black),
      ));
}

Widget buildUserNameTextFiled(
    {TextEditingController userName_Controller,
    String labelName,
    Icon icon,
    int maxline,
    bool enablevalue,
    ThemeData
        baseTheme} /*String Username,TextEditingController edt_UserName*/) {
  return Container(
/*
    margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
*/
    child: TextFormField(
      style: baseTheme.textTheme.bodyText1,
      enabled: enablevalue,
      controller: userName_Controller,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      maxLines: maxline,
      //initialValue: userName_Controller.text,
      decoration: InputDecoration(
        labelText: labelName,
        labelStyle: TextStyle(
          color: Color(0xFF000000),
        ),
        suffixIcon: icon,
        /*Icon(
          Icons.person,
        ),*/
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

Widget buildUserNameTextFiledRounded(
    {TextEditingController userName_Controller,
    String labelName,
    Icon icon,
    int maxline,
    bool enablevalue,
    ThemeData
        baseTheme} /*String Username,TextEditingController edt_UserName*/) {
  return Container(
/*
    margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
*/
    child: TextFormField(
      style: baseTheme.textTheme.bodyText1,
      enabled: enablevalue,
      controller: userName_Controller,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      maxLines: maxline,
      //initialValue: userName_Controller.text,
      decoration: InputDecoration(
        labelText: labelName,
        labelStyle: TextStyle(
          color: Color(0xFF000000),
        ),
        suffixIcon: icon,
        /*Icon(
          Icons.person,
        ),*/
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
      ),
    ),
  );
}

Widget build_Dropdown_label(
    {TextEditingController userName_Controller,
    String labelName,
    Icon icon,
    int maxline,
    bool enablevalue} /*String Username,TextEditingController edt_UserName*/) {
  return Container(
    child: TextFormField(
      enabled: enablevalue,
      controller: userName_Controller,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      maxLines: maxline,
      //initialValue: userName_Controller.text,
      decoration: InputDecoration(
        labelText: labelName,
        labelStyle: TextStyle(
          color: Color(0xFF000000),
        ),
        suffixIcon: icon,
        /*Icon(
          Icons.person,
        ),*/
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

Widget buildPasswordTextFiled(
    {TextEditingController user_password_Controller}) {
  return Container(
    margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
    child: TextFormField(
      controller: user_password_Controller,
      obscureText: true,
      cursorColor: Colors.black,
      // initialValue: user_password_Controller.text,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Color(0xFF000000),
        ),
        suffixIcon: Icon(
          Icons.lock,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

Widget buildForgotTitle() {
  return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Forget Password ?',
          maxLines: 20,
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.w300, color: Colors.black),
        ),
      ));
}

Widget buildLoginButton(BuildContext context, Function onPressed) {
  return Container(
    width: double.infinity,
    height: 50.0,
    margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 60.0),
    child: TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFF27442)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed: onPressed,
      child: Text('Login'),
    ),
  );
}

Widget buildLoginWithGoogleButton(BuildContext context) {
  return Container(
    width: double.infinity,
    height: 50.0,
    margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
    child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: () async {},
        child: Stack(
          children: [
            Container(
                margin: EdgeInsets.only(left: 25.0),
                alignment: Alignment.centerLeft,
                child: ImageIcon(
                  AssetImage('assets/images/custom_logo_icon/google_icon.png'),
                )
                /*Image.network(
                  'https://www.pngfind.com/pngs/m/34-344426_google-icon-logo-black-and-white-johns-hopkins.png',
                 ),*/
                ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Sign in with Google',
              ),
            ),
            //Icon(FlutterIcons.ac_unit_mdi),
            // Text('Sign in with Google'),
          ],
        )),
  );
}

Widget buildRegisterbTitle(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(left: 40.0, right: 30.0, top: 30.0),
    child: Row(
      children: [
        Text(
          "Don't have an account ? ",
          maxLines: 20,
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.w300, color: Colors.black),
        ),
        InkWell(
          child: Text(
            "Register Here ",
            maxLines: 20,
            style: TextStyle(
                fontSize: 15.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          onTap: () {},
        )
      ],
    ),
  );
}

///_________________________________________________

///This Widget is For dashboard Screen
makeDashboardItem(
    String title, IconData icon, BuildContext context, String ImageURL) {
  return Container(
      child: new InkWell(
    onTap: () {
      if (title == "Customer") {
        //Navigator.pushReplacementNamed(context, "/Customer");
        //Get.to(Customer());
        SharedPrefHelper.instance.prefs.getString("Is_Dealer") == "Dealer"
            ? navigateTo(context, DCustomerListScreen.routeName)
            : navigateTo(context, CustomerListScreen.routeName);
      } else if (title == "Product") {
        // navigateTo(context, CustomerPaginationListScreen .routeName);
        navigateTo(context, ProductMasterListScreen.routeName,
            clearAllStack: true);

        //Navigator.pushReplacementNamed(context, "/Inquiry");
      } else if (title == "BlueToneInquiry") {
        // navigateTo(context, CustomerPaginationListScreen .routeName);
        navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);

        //Navigator.pushReplacementNamed(context, "/Inquiry");
      } else if (title == "Inquiry") {
        // navigateTo(context, CustomerPaginationListScreen .routeName);
        navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);

        //Navigator.pushReplacementNamed(context, "/Inquiry");
      } else if (title == "Mudra Inquiry") {
        // navigateTo(context, CustomerPaginationListScreen .routeName);
        navigateTo(context, MudraInquiryListScreen.routeName,
            clearAllStack: true);

        //Navigator.pushReplacementNamed(context, "/Inquiry");
      } else if (title == "BlueToneQuickInquiry") {
        // navigateTo(context, CustomerPaginationListScreen .routeName);
        navigateTo(context, QuickInquiryScreen.routeName, clearAllStack: true);

        //Navigator.pushReplacementNamed(context, "/Inquiry");
      }

      //BlueToneQuickInquiry
      else if (title == "Quick Inquiry") {
        navigateTo(context, QuickInquiryScreen.routeName, clearAllStack: true);
      } else if (title == "Follow-up") {
        navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);
      } else if (title == "Follow-Up") {
        navigateTo(context, GeneralFollowupListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Quick Follow-up") {
        navigateTo(context, QuickFollowupListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Leave Request") {
        navigateTo(context, LeaveRequestListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Leave Approval") {
        navigateTo(context, LeaveRequestApprovalListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Attendance") {
        navigateTo(context, AttendanceListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Expense") {
        navigateTo(context, ExpenseListScreen.routeName, clearAllStack: true);
      } else if (title == "Expense Tracking") {
        navigateTo(context, ExpenseTrackingListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Visitor Management") {
        navigateTo(context, VisitorInfoListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Daily Activities") {
        navigateTo(context, DailyActivityListScreen.routeName,
            clearAllStack: true);
      } else if (title == "To-Do") {
        navigateTo(context, ToDoListScreen.routeName, clearAllStack: true);
      } else if (title == "Activity Summary") {
        navigateTo(context, OfficeToDoScreen.routeName, clearAllStack: true);
      } else if (title == "Quotation") {
        navigateTo(context, QuotationListScreen.routeName, clearAllStack: true);
      } else if (title == "Service Report") {
        navigateTo(context, ServiceReportListScreens.routeName,
            clearAllStack: true);
      } else if (title == "Short Invoice") {
        navigateTo(context, ShortInvoiceListScreen.routeName,
            clearAllStack: true);
      } else if (title == "New Quotation") {
        if (SharedPrefHelper.instance
                    .getLoginUserData()
                    .details[0]
                    .serialKey
                    .toUpperCase() ==
                "GR5T-E7K3-EN2G-LAP4" ||
            SharedPrefHelper.instance
                    .getLoginUserData()
                    .details[0]
                    .serialKey
                    .toUpperCase() ==
                "GRON-N793-EN2P-LLP6" ||
            SharedPrefHelper.instance
                    .getLoginUserData()
                    .details[0]
                    .serialKey
                    .toUpperCase() ==
                "TEST-0000-GREE-EDGE") {
          navigateTo(context, GreenEdgeQuotationListScreen.routeName,
              clearAllStack: true);
        } else {
          navigateTo(context, QuotationListScreen.routeName,
              clearAllStack: true);
        }
      }
      //Acura Quotation
      else if (title == "Acura Quotation") {
        navigateTo(context, AcurabathQuotationListScreen.routeName,
            clearAllStack: true);
      } else if (title == "SalesOrder") {
        navigateTo(context, SalesOrderListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Sales Order Approval") {
        navigateTo(context, SalesOrderApprovalListScreen.routeName,
            clearAllStack: true);
      }
      //
      else if (title == "SalesBill") {
        navigateTo(context, SalesBillListScreen.routeName, clearAllStack: true);
      } else if (title == "BankVoucher") {
        SharedPrefHelper.instance.prefs.getString("Is_Dealer") == "Dealer"
            ? navigateTo(context, MayankBankVoucherListScreen.routeName,
                clearAllStack: true)
            : navigateTo(context, MayankBankVoucherListScreen.routeName,
                clearAllStack: true);
      } else if (title == "Complaint") {
        if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "DHSI-09RY-BATH-ACCU" ||
            _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                "TEST-0000-ACBF-0214") {
          navigateTo(context, AccurabathComplaintListScreen.routeName,
              clearAllStack: true);
        } else {
          navigateTo(context, ComplaintPaginationListScreen.routeName,
              clearAllStack: true);
        }
      } else if (title == "Attend Visit") {
        if (SharedPrefHelper.instance
                    .getLoginUserData()
                    .details[0]
                    .serialKey
                    .toUpperCase() ==
                "DOL2-6UH7-PH03-IN5H" ||
            SharedPrefHelper.instance
                    .getLoginUserData()
                    .details[0]
                    .serialKey
                    .toUpperCase() ==
                "TEST-0000-DOLF-0205") {
          //TEST-0000-DOLF-0205
          navigateTo(context, AttendVisitListScreen.routeName,
              clearAllStack: true);
        } else if (SharedPrefHelper.instance
                .getLoginUserData()
                .details[0]
                .serialKey
                .toUpperCase() ==
            "HEMA-AUTO-SI08-NVRL") {
          navigateTo(context, HemaAttendVisitListScreen.routeName,
              clearAllStack: true);
        } else {
          navigateTo(context, AttendVisitListScreen.routeName,
              clearAllStack: true);
        }
        //
      } else if (title == "Agni AttendVisit") {
        navigateTo(context, HemaAttendVisitListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Employee") {
        navigateTo(context, EmployeeListScreen.routeName, clearAllStack: true);
      } else if (title == "Loan Installments") {
        navigateTo(context, LoanListScreen.routeName, clearAllStack: true);
      } else if (title == "Loan Approval") {
        navigateTo(context, LoanApprovalListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Missed Punch") {
        navigateTo(context, MissedPunchListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Missed Punch Approval") {
        navigateTo(context, MissedPunchApprovalListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Salary Adv/Upad") {
        navigateTo(context, SalaryUpadListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Maintenance Contract") {
        navigateTo(context, MaintenanceListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Portal Leads") {
        navigateTo(context, ExternalLeadListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Packing Checklist") {
        navigateTo(context, PackingChecklistScreen.routeName,
            clearAllStack: true);
      } else if (title == "Final Checking") {
        navigateTo(context, FinalCheckingListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Installation") {
        navigateTo(context, InstallationListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Production Activity") {
        navigateTo(context, ProductionActivityListScreen.routeName,
            clearAllStack: true);
      } else if (title == "TeleCaller") {
        navigateTo(context, TeleCallerListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Tele Caller") {
        navigateTo(context, TeleCallerNewListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Purchase Order") {
        navigateTo(context, PoListScreen.routeName, clearAllStack: true);
      } else if (title == "Purchase Order Approval") {
        navigateTo(context, PurchaseOrderApprovalListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Purchase Bill") {
        SharedPrefHelper.instance.prefs.getString("Is_Dealer") == "Dealer"
            ? navigateTo(context, DPurchaseListScreen.routeName,
                clearAllStack: true)
            : navigateTo(context, PurchaseBillListScreen.routeName,
                clearAllStack: true);
      } else if (title == "CashVoucher") {
        SharedPrefHelper.instance.prefs.getString("Is_Dealer") == "Dealer"
            ? navigateTo(context, MayankCashVoucherListScreen.routeName,
                clearAllStack: true)
            : navigateTo(context, MayankCashVoucherListScreen.routeName,
                clearAllStack: true);
      } else if (title == "Material Inward") {
        navigateTo(context, MaterialInwardListScreens.routeName,
            clearAllStack: true);
      } else if (title == "Material Outward") {
        navigateTo(context, MaterialOutwardListMainScreen.routeName,
            clearAllStack: true);
      } else if (title == "Material Indent Approval") {
        navigateTo(context, MaterialIndentApprovalScreen.routeName,
            clearAllStack: true);
      } else if (title == "Sales Target") {
        navigateTo(context, SalesTargetListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Technical Visit") {
        navigateTo(context, VkSoundComplaintPaginationListScreen.routeName,
            clearAllStack: true);
      } else if (title == "MudraComplaint") {
        navigateTo(context, MudraCompliantListScreen.routeName,
            clearAllStack: true);
      } else if (title == "MudraAttendVisit") {
        navigateTo(context, MudraAttendListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Quick Visit") {
        navigateTo(context, QuickSupportListScreen.routeName,
            clearAllStack: true);
      } else if (title == "BankVoucher") {
        navigateTo(context, MayankBankVoucherListScreen.routeName,
            clearAllStack: true);
      } else if (title == "CashVoucher") {
        navigateTo(context, MayankCashVoucherListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Sharvaya Daily Activities") {
        navigateTo(context, DailyActivityForSharvayaListScreen.routeName,
            clearAllStack: true);
      } else if (title == "To-Do Widget") {
        navigateTo(context, SharvayaToDoWidgetListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Repairing") {
        navigateTo(context, RepairingListMainScreen.routeName,
            clearAllStack: true);
      } else if (title == "Pay Slip") {
        navigateTo(context, PaySlipListScreen.routeName, clearAllStack: true);
      } else if (title == "Credit Note") {
        navigateTo(context, CreditNotesListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Debit Note") {
        navigateTo(context, DebitNotesListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Petty Cash") {
        navigateTo(context, PettyCashListScreen.routeName, clearAllStack: true);
      } else if (title == "Multiple Expense") {
        navigateTo(context, MultiExpenseListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Multiple Expense Approval") {
        navigateTo(context, MultiExpenseApprovalScreen.routeName,
            clearAllStack: true);
      } else if (title == "Journal Voucher") {
        navigateTo(context, JournalVoucherListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Asset Issue") {
        navigateTo(context, AssetIssueListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Asset Return") {
        navigateTo(context, AssetReturnListScreen.routeName,
            clearAllStack: true);
      } else if (title == "Existing Lead") {
        navigateTo(context, InquiryListScreen.routeName, clearAllStack: true);
      } else if (title == "Lead Generation") {
        navigateTo(context, QuickInquiryScreen.routeName, clearAllStack: true);
      } else if (title == "Existing Visit") {
        navigateTo(context, GeneralFollowupListForAlmightyScreen.routeName,
            clearAllStack: true);
      } else if (title == "Visit Punch In/Out") {
        navigateTo(context, QuickFollowupListScreen.routeName,
            clearAllStack: true);
      }
    },
    child: Center(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Center(child: Image.asset(ImageURL, height: 30, fit: BoxFit.fill)),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: Text(title,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: title.length > 10 ? 9 : 10.0,
                      color: colorPrimary)),
            )
          ],
        ),
      ),
    ),
  ));
}

colorCombination(String title) {
  if (title == "Customer") {
    return colorYellow;
  } else if (title == "Follow-up") {
    return colorGreen;
  } else if (title == "Inquiry") {
    return colorOrange;
  } else if (title == "Attendance") {
    return colorPresentDay;
  } else if (title == "Expense") {
    return colorRedProgress;
  } else if (title == "LeaveApproval") {
    return colorGreen;
  } else if (title == "LeaveRequest") {
    return colorGray;
  } else {
    return colorWhite;
  }
}

void getcurrentTimeInfo(BuildContext context) async {
  DateTime startDate = await NTP.now();
  print('NTP DateTime: ${startDate} ${DateTime.now()}');

  var now = startDate;
  var formatter = new DateFormat('yyyy-MM-ddTHH');
  String currentday = formatter.format(now);
  String PresentDate1 = formatter.format(DateTime.now());
  print(
      'NTP DateTime123456: ${DateTime.parse(currentday)} ${DateTime.parse(PresentDate1)}');

  if (DateTime.parse(currentday) == DateTime.parse(PresentDate1)) {
    navigateTo(context, AttendanceListScreen.routeName, clearAllStack: true);
  } else {
    return showCommonDialogWithSingleOption(
      context,
      "Your Device DateTime is not correct as per current DateTime , Kindly Update Your Device Time !",
      positiveButtonTitle: "OK",
    );
  }
}

void getcurrentTimeInfoFromMain(BuildContext context) async {
  DateTime startDate = await NTP.now();
  print('NTP DateTime: ${startDate} ${DateTime.now()}');
  /* var PresentDate = startDate.year.toString() +
      "-" +
      startDate.month.toString() +
      "-" +
      startDate.day.toString();*/
  var now = startDate;
  var formatter = new DateFormat('yyyy-MM-ddTHH');
  String currentday = formatter.format(now);
  String PresentDate1 = formatter.format(DateTime.now());
  print(
      'NTP DateTime123456: ${DateTime.parse(currentday)} ${DateTime.parse(PresentDate1)}');

  if (DateTime.parse(currentday) != DateTime.parse(PresentDate1)) {
    //  navigateTo(context, AttendanceListScreen.routeName, clearAllStack: true);
    return showCommonDialogWithSingleOption(context,
        "Your Device DateTime is not correct as per current DateTime , Kindly Update Your Device Time !",
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    });
  }
}

getSaleListFromDashBoard(List<ALL_Name_ID> Sale) {
  SALES = Sale;
  return SALES;
}

getLeadListFromDashBoard(List<ALL_Name_ID> Leads1) {
  Leads = Leads1;
  return Leads;
}

getDashBoardWidget(List<ALL_Name_ID> DASHBOARD_WIDGET1) {
  DASHBOARD_WIDGET = DASHBOARD_WIDGET1;
  return DASHBOARD_WIDGET;
}

getAccountListFromDashBoard(List<ALL_Name_ID> AccountList1) {
  AccountList = AccountList1;
  return Leads;
}

getHRListFromDashBoard(List<ALL_Name_ID> HR1) {
  HR = HR1;
  return HR;
}

getPurchaseListFromDashBoard(List<ALL_Name_ID> Purchase1) {
  Purchase = Purchase1;
  return Purchase;
}

getSupportListFromDashBoard(List<ALL_Name_ID> Support1) {
  Support = Support1;
  return Support;
}

getOfficeListFromDashBoard(List<ALL_Name_ID> Office1) {
  Office = Office1;
  return Office;
}

getProductionListFromDashBoard(List<ALL_Name_ID> Production1) {
  Production = Production1;
  return Production;
}

getDealerListFromDashBoard(List<ALL_Name_ID> Dealer1) {
  Dealer = Dealer1;
  return Dealer;
}

Widget build_Drawer({BuildContext context, String UserName, String RolCode}) {
  return Drawer(
    child: Background(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            color: colorPrimary,
          ),
          accountName: Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              "User Id : " +
                  SharedPrefHelper.instance
                      .getLoginUserData()
                      .details[0]
                      .userID,
              style: TextStyle(color: Colors.white),
            ),
          ),
          accountEmail: Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              "User Role : " +
                  SharedPrefHelper.instance
                      .getLoginUserData()
                      .details[0]
                      .roleCode,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          currentAccountPicture: Container(
            child: Card(
              elevation: 5,
              color: colorWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Image.network(
                  SharedPrefHelper.instance
                          .getCompanyData()
                          .details[0]
                          .siteURL +
                      "images/CompanyLogo/CompanyLogo.png",
                ),
              ),
            ),
          ),
          currentAccountPictureSize: const Size.square(85),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 8, right: 8),
                child: Card(
                  elevation: 5,
                  color: colorVeryLightCardBG,
                  child: Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Serial Key : " +
                              SharedPrefHelper.instance
                                  .getLoginUserData()
                                  .details[0]
                                  .serialKey,
                          style: TextStyle(fontSize: 12, color: colorBlack),
                        ),
                        Text(
                            "Company name : " +
                                SharedPrefHelper.instance
                                    .getLoginUserData()
                                    .details[0]
                                    .companyName,
                            style: TextStyle(fontSize: 12, color: colorBlack)),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard, color: colorPrimary),
                title: Text("DashBoard",
                    softWrap: true,
                    style: new TextStyle(
                        fontSize: 15.0,
                        color: colorPrimary,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  navigateTo(context, HomeScreen.routeName);
                },
              ),
              Leads.length != 0
                  ? ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.center,
                      leading: Image.asset(
                        DASHBOARD_LEAD,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("Leads",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Leads.length != 0
                            ? getLeadList(Leads, context)
                            : Container(),
                      ],
                      trailing: Icon(
                        Icons.account_tree,
                        color: colorPrimary,
                      ))
                  : Container(),
              Dealer.length != 0
                  ? ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.center,
                      leading: Icon(Icons.dashboard, color: colorPrimary),
                      title: Text("Dealer",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Dealer.length != 0
                            ? getDealerList(Dealer, context)
                            : Container(),
                      ],
                      trailing: Icon(
                        Icons.account_tree,
                        color: colorPrimary,
                      ))
                  : Container(),
              SALES.length != 0
                  ? ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.center,
                      leading: Image.asset(
                        DASHBOARD_SALES,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("Sales",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        SALES.length != 0
                            ? getSalesList(SALES, context)
                            : Container(),
                      ],
                      trailing: Icon(
                        Icons.account_tree,
                        color: colorPrimary,
                      ))
                  : Container(),
              Production.length != 0
                  ? ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.center,
                      leading: Image.asset(
                        DASHBOARD_PRODUCTION,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("Production",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Production.length != 0
                            ? getProductionList(Production, context)
                            : Container(),
                      ],
                      trailing: Icon(
                        Icons.account_tree,
                        color: colorPrimary,
                      ))
                  : Container(),
              AccountList.length != 0
                  ? ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.center,
                      leading: Image.asset(
                        DASHBOARD_ACCOUNT,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("Account",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        AccountList.length != 0
                            ? getAccountList(AccountList, context)
                            : Container(),
                      ],
                      trailing: Icon(
                        Icons.account_tree,
                        color: colorPrimary,
                      ))
                  : Container(),
              HR.length != 0
                  ? ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.center,
                      leading: Image.asset(
                        DASHBOARD_HR,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("HR",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        HR.length != 0 ? getHRList(HR, context) : Container(),
                      ],
                      trailing: Icon(
                        Icons.account_tree,
                        color: colorPrimary,
                      ))
                  : Container(),
              Purchase.length != 0
                  ? ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.center,
                      leading: Image.asset(
                        DASHBOARD_PURCHASE,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("Purchase",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Purchase.length != 0
                            ? getPurchaseList(Purchase, context)
                            : Container(),
                      ],
                      trailing: Icon(
                        Icons.account_tree,
                        color: colorPrimary,
                      ))
                  : Container(),
              Office.length != 0
                  ? ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.center,
                      leading: Image.asset(
                        DASHBOARD_OFFICE,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("Office",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Office.length != 0
                            ? getOfficeList(Office, context)
                            : Container(),
                      ],
                      trailing: Icon(
                        Icons.account_tree,
                        color: colorPrimary,
                      ))
                  : Container(),
              Support.length != 0
                  ? ExpansionTile(
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      expandedAlignment: Alignment.center,
                      leading: Image.asset(
                        DASHBOARD_SUPPORT,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("Support",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Support.length != 0
                            ? getSupportList(Support, context)
                            : Container(),
                      ],
                      trailing: Icon(
                        Icons.account_tree,
                        color: colorPrimary,
                      ))
                  : Container(),
              _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                      "BLG3-AF78-TO5F-NW16"
                  ? Container()
                  : ListTile(
                      leading: Icon(Icons.login_outlined, color: colorPrimary),
                      title: Text("LogOut",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        SharedPrefHelper.instance
                            .putBool(SharedPrefHelper.IS_LOGGED_IN_DATA, false);

                        final service = FlutterBackgroundService();
                        service.invoke("stopService");
                        navigateTo(context, FirstScreen.routeName,
                            clearAllStack: true);
                      },
                    ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                final url =
                    'https://docs.google.com/document/d/1Vaw_raFxfDK8Rj7nWsteafX8k47h0N3Ye0irNAV8oK4/edit?usp=sharing';

                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false,
                  );
                }
              },
              child: Text(
                "Terms & Condition",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    decoration: TextDecoration.underline),
              ),
            ),
            Text(
              " | ",
              style: TextStyle(
                fontSize: 12,
                color: colorPrimary,
                letterSpacing: 0.5,
              ),
            ),
            InkWell(
              onTap: () async {
                final url =
                    'https://docs.google.com/document/d/13HliC_idDq4G-06Ii8z0gyzsXYZgSbvfzYThxTmQRpc/edit?usp=sharing';

                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false,
                  );
                }
              },
              child: Text(
                "Privacy Policy",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "PowerBy : SharvayaInfotech",
              style: TextStyle(fontSize: 10, color: colorPrimary),
            ))
      ],
    )),
  );
}

getLeadList(List<ALL_Name_ID> sale, BuildContext context) {
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: sale.length,
    itemBuilder: (context, i) {
      return ListTile(
          leading: Image.asset(sale[i].Name1, height: 32, fit: BoxFit.fill),
          title: Text(sale[i].Name,
              softWrap: true,
              style: new TextStyle(fontSize: 15.0, color: colorPrimary)),
          onTap: () {
            if (sale[i].Name == "Customer")
              navigateTo(context, CustomerListScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Product")
              navigateTo(context, ProductMasterListScreen.routeName,
                  clearAllStack: true);
            //Product
            if (sale[i].Name == "Inquiry")
              navigateTo(context, InquiryListScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Mudra Inquiry")
              navigateTo(context, MudraInquiryListScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Quick Inquiry")
              navigateTo(context, QuickInquiryScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Follow-Up")
              navigateTo(context, GeneralFollowupListScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Quotation")
              navigateTo(context, QuotationListScreen.routeName,
                  clearAllStack: true);

            if (sale[i].Name == "New Quotation")
              navigateTo(context, GreenEdgeQuotationListScreen.routeName,
                  clearAllStack: true);

            if (sale[i].Name == "Acura Quotation")
              navigateTo(context, AcurabathQuotationListScreen.routeName,
                  clearAllStack: true);

            if (sale[i].Name == "SalesBill")
              navigateTo(context, SalesBillListScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Portal Leads")
              navigateTo(context, ExternalLeadListScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Tele Caller") {
              navigateTo(context, TeleCallerNewListScreen.routeName,
                  clearAllStack: true);
            }
            if (sale[i].Name == "TeleCaller") {
              navigateTo(context, TeleCallerListScreen.routeName,
                  clearAllStack: true);
            }
            if (sale[i].Name == "Quick Follow-up")
              navigateTo(context, QuickFollowupListScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Asset Issue")
              navigateTo(context, AssetIssueListScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Asset Return")
              navigateTo(context, AssetReturnListScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Existing Lead")
              navigateTo(context, InquiryListScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Lead Generation")
              navigateTo(context, QuickInquiryScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Existing Visit")
              navigateTo(
                  context, GeneralFollowupListForAlmightyScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Visit Punch In/Out")
              navigateTo(context, QuickFollowupListScreen.routeName,
                  clearAllStack: true);
            if (_offlineLoggedInData.details[0].serialKey.toLowerCase() ==
                "al2m-7ig1-h8s2-t0y3") {
              if (sale[i].Name == "Attendance")
                navigateTo(context, AttendanceListScreen.routeName,
                    clearAllStack: true);
            }
          });
    },
  );
}

getDashBoardWidgetList(List<ALL_Name_ID> sale, BuildContext context) {
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: sale.length,
    itemBuilder: (context, i) {
      return ListTile(
          leading: Image.asset(sale[i].Name1, height: 32, fit: BoxFit.fill),
          title: Text(sale[i].Name,
              softWrap: true,
              style: new TextStyle(fontSize: 15.0, color: colorPrimary)),
          onTap: () {
            if (sale[i].Name == "Follow-up")
              navigateTo(context, FollowupListScreen.routeName,
                  clearAllStack: true);
          });
    },
  );
}

getDealerList(List<ALL_Name_ID> sale, BuildContext context) {
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: sale.length,
    itemBuilder: (context, i) {
      return ListTile(
          leading: Image.asset(sale[i].Name1, height: 32, fit: BoxFit.fill),
          title: Text(sale[i].Name,
              softWrap: true,
              style: new TextStyle(fontSize: 15.0, color: colorPrimary)),
          onTap: () {
            if (sale[i].Name == "Customer") {
              navigateTo(context, DCustomerListScreen.routeName,
                  clearAllStack: true);
            }
            //test

            /*if (sale[i].Name == "SalesBill") {
              navigateTo(context, DSaleBillListScreen.routeName,
                  clearAllStack: true);
            }*/

            if (sale[i].Name == "SalesBill") {
              navigateTo(context, SalesBillListScreen.routeName,
                  clearAllStack: true);
            }
            if (sale[i].Name == "BankVoucher") {
              navigateTo(context, MayankBankVoucherListScreen.routeName,
                  clearAllStack: true);
            }
            if (sale[i].Name == "CashVoucher") {
              navigateTo(context, MayankCashVoucherListScreen.routeName,
                  clearAllStack: true);
            }
            if (sale[i].Name == "Purchase Bill") {
              navigateTo(context, DPurchaseListScreen.routeName,
                  clearAllStack: true);
            }
          });
    },
  );
}

getSalesList(List<ALL_Name_ID> leads, BuildContext context) {
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: leads.length,
    itemBuilder: (context, i) {
      return ListTile(
          leading: Image.asset(leads[i].Name1, height: 32, fit: BoxFit.fill),
          title: Text(leads[i].Name,
              softWrap: true,
              style: new TextStyle(fontSize: 15.0, color: colorPrimary)),
          onTap: () {
            if (leads[i].Name == "SalesBill")
              navigateTo(context, SalesBillListScreen.routeName,
                  clearAllStack: true);
            if (leads[i].Name == "SalesOrder")
              navigateTo(context, SalesOrderListScreen.routeName,
                  clearAllStack: true);
            else if (leads[i].Name == "Sales Target")
              navigateTo(context, SalesTargetListScreen.routeName,
                  clearAllStack: true);
            if (leads[i].Name == "Short Invoice")
              navigateTo(context, ShortInvoiceListScreen.routeName,
                  clearAllStack: true);
            if (leads[i].Name == "Sales Order Approval")
              navigateTo(context, SalesOrderApprovalListScreen.routeName,
                  clearAllStack: true);
          });
    },
  );
}

getProductionList(List<ALL_Name_ID> sale, BuildContext context) {
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: sale.length,
    itemBuilder: (context, i) {
      return ListTile(
          leading: Image.asset(sale[i].Name1, height: 32, fit: BoxFit.fill),
          title: Text(sale[i].Name,
              softWrap: true,
              style: new TextStyle(fontSize: 15.0, color: colorPrimary)),
          onTap: () {
            if (sale[i].Name == "Packing Checklist")
              navigateTo(context, PackingChecklistScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Final Checking")
              navigateTo(context, FinalCheckingListScreen.routeName,
                  clearAllStack: true);
            if (sale[i].Name == "Installation") {
              navigateTo(context, InstallationListScreen.routeName,
                  clearAllStack: true);
            }
            if (sale[i].Name == "Material Indent Approval") {
              navigateTo(context, MaterialIndentApprovalScreen.routeName,
                  clearAllStack: true);
            }

            if (sale[i].Name == "Production Activity") {
              navigateTo(context, ProductionActivityListScreen.routeName,
                  clearAllStack: true);
            }
          });
    },
  );
}

getPurchaseList(List<ALL_Name_ID> Purchase, BuildContext context) {
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: Purchase.length,
    itemBuilder: (context, i) {
      return ListTile(
          leading: Image.asset(Purchase[i].Name1, height: 32, fit: BoxFit.fill),
          title: Text(Purchase[i].Name,
              softWrap: true,
              style: new TextStyle(fontSize: 15.0, color: colorPrimary)),
          onTap: () {
            if (Purchase[i].Name == "Purchase Order")
              navigateTo(context, PoListScreen.routeName, clearAllStack: true);
            if (Purchase[i].Name == "Purchase Order Approval")
              navigateTo(context, PurchaseOrderApprovalListScreen.routeName,
                  clearAllStack: true);
            if (Purchase[i].Name == "Purchase Bill")
              navigateTo(context, PurchaseBillListScreen.routeName,
                  clearAllStack: true);
          });
    },
  );
}

getAccountList(List<ALL_Name_ID> AccountList, BuildContext context) {
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: AccountList.length,
    itemBuilder: (context, i) {
      return ListTile(
          leading:
              Image.asset(AccountList[i].Name1, height: 32, fit: BoxFit.fill),
          title: Text(AccountList[i].Name,
              softWrap: true,
              style: new TextStyle(fontSize: 15.0, color: colorPrimary)),
          onTap: () {
            if (AccountList[i].Name == "BankVoucher")
              navigateTo(context, MayankBankVoucherListScreen.routeName,
                  clearAllStack: true);
            if (AccountList[i].Name == "CashVoucher")
              navigateTo(context, MayankCashVoucherListScreen.routeName,
                  clearAllStack: true);
            if (AccountList[i].Name == "Credit Note")
              navigateTo(context, CreditNotesListScreen.routeName,
                  clearAllStack: true);
            if (AccountList[i].Name == "Debit Note")
              navigateTo(context, DebitNotesListScreen.routeName,
                  clearAllStack: true);
            if (AccountList[i].Name == "Petty Cash")
              navigateTo(context, PettyCashListScreen.routeName,
                  clearAllStack: true);
            if (AccountList[i].Name == "Journal Voucher")
              navigateTo(context, JournalVoucherListScreen.routeName,
                  clearAllStack: true);
            if (AccountList[i].Name == "Multiple Expense")
              navigateTo(context, MultiExpenseListScreen.routeName,
                  clearAllStack: true);
            if (AccountList[i].Name == "Multiple Expense Approval")
              navigateTo(context, MultiExpenseApprovalScreen.routeName,
                  clearAllStack: true);
          });
    },
  );
}

getHRList(List<ALL_Name_ID> HR, BuildContext context) {
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: HR.length,
    itemBuilder: (context, i) {
      return ListTile(
          leading: Image.asset(HR[i].Name1, height: 32, fit: BoxFit.fill),
          title: Text(HR[i].Name,
              softWrap: true,
              style: new TextStyle(fontSize: 15.0, color: colorPrimary)),
          onTap: () {
            if (HR[i].Name == "Leave Request")
              navigateTo(context, LeaveRequestListScreen.routeName,
                  clearAllStack: true);
            if (HR[i].Name == "Leave Approval")
              navigateTo(context, LeaveRequestApprovalListScreen.routeName,
                  clearAllStack: true);

            if (_offlineLoggedInData.details[0].serialKey.toLowerCase() !=
                "al2m-7ig1-h8s2-t0y3") {
              if (HR[i].Name == "Attendance")
                navigateTo(context, AttendanceListScreen.routeName,
                    clearAllStack: true);
            }

            if (HR[i].Name == "Expense")
              navigateTo(context, ExpenseListScreen.routeName,
                  clearAllStack: true);
            if (HR[i].Name == "Expense Tracking")
              navigateTo(context, ExpenseTrackingListScreen.routeName,
                  clearAllStack: true);
            if (HR[i].Name == "BankVoucher")
              navigateTo(context, MayankBankVoucherListScreen.routeName,
                  clearAllStack: true);
            if (HR[i].Name == "Employee")
              navigateTo(context, EmployeeListScreen.routeName,
                  clearAllStack: true);
            if (HR[i].Name == "Loan Approval")
              navigateTo(context, LoanApprovalListScreen.routeName,
                  clearAllStack: true);

            if (HR[i].Name == "Missed Punch")
              navigateTo(context, MissedPunchListScreen.routeName,
                  clearAllStack: true);

            if (HR[i].Name == "Missed Punch Approval")
              navigateTo(context, MissedPunchApprovalListScreen.routeName,
                  clearAllStack: true);

            if (HR[i].Name == "Loan Installments")
              navigateTo(context, LoanListScreen.routeName,
                  clearAllStack: true);
            if (HR[i].Name == "Loan Approval")
              navigateTo(context, LoanApprovalListScreen.routeName,
                  clearAllStack: true);

            if (HR[i].Name == "Salary Adv/Upad")
              navigateTo(context, SalaryUpadListScreen.routeName,
                  clearAllStack: true);

            if (HR[i].Name == "Pay Slip")
              navigateTo(context, PaySlipListScreen.routeName,
                  clearAllStack: true);
          });
    },
  );
}

getOfficeList(List<ALL_Name_ID> HR, BuildContext context) {
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: HR.length,
    itemBuilder: (context, i) {
      return ListTile(
          leading: Container(
              height: 32,
              width: 32,
              child: Image.asset(
                HR[i].Name1,
              )),
          title: Text(HR[i].Name,
              softWrap: true,
              style: new TextStyle(fontSize: 15.0, color: colorPrimary)),
          onTap: () {
            if (HR[i].Name == "Daily Activities")
              navigateTo(context, DailyActivityListScreen.routeName,
                  clearAllStack: true);
            if (HR[i].Name == "Sharvaya Daily Activities")
              navigateTo(context, DailyActivityForSharvayaListScreen.routeName,
                  clearAllStack: true);
            if (HR[i].Name == "To-Do")
              navigateTo(context, ToDoListScreen.routeName,
                  clearAllStack: true);

            if (HR[i].Name == "Visitor Management")
              navigateTo(context, VisitorInfoListScreen.routeName,
                  clearAllStack: true);
          });
    },
  );
}

getSupportList(List<ALL_Name_ID> Support, BuildContext context) {
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: Support.length,
    itemBuilder: (context, i) {
      return ListTile(
          leading: Image.asset(Support[i].Name1, height: 32, fit: BoxFit.fill),
          title: Text(Support[i].Name,
              softWrap: true,
              style: new TextStyle(fontSize: 15.0, color: colorPrimary)),
          onTap: () {
            if (Support[i].Name == "Quick Visit") {
              navigateTo(context, QuickSupportListScreen.routeName,
                  clearAllStack: true);
            } else if (Support[i].Name == "MudraAttendVisit") {
              navigateTo(context, MudraAttendListScreen.routeName,
                  clearAllStack: true);
            } else if (Support[i].Name == "MudraComplaint") {
              navigateTo(context, MudraCompliantListScreen.routeName,
                  clearAllStack: true);
            }

            if (Support[i].Name == "Complaint") {
              if (_offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                      "DHSI-09RY-BATH-ACCU" ||
                  _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                      "TEST-0000-ACBF-0214") {
                navigateTo(context, AccurabathComplaintListScreen.routeName,
                    clearAllStack: true);
              } else {
                navigateTo(context, ComplaintPaginationListScreen.routeName,
                    clearAllStack: true);
              }
            }

            if (Support[i].Name == "Technical Visit") {
              navigateTo(
                  context, VkSoundComplaintPaginationListScreen.routeName,
                  clearAllStack: true);
            }
            if (Support[i].Name == "Attend Visit") {
              if (SharedPrefHelper.instance
                      .getLoginUserData()
                      .details[0]
                      .serialKey
                      .toUpperCase() ==
                  "HEMA-AUTO-SI08-NVRL") {
                navigateTo(context, HemaAttendVisitListScreen.routeName,
                    clearAllStack: true);
              } else {
                navigateTo(context, AttendVisitListScreen.routeName,
                    clearAllStack: true);
              }
            } else if (Support[i].Name == "Agni AttendVisit") {
              navigateTo(context, HemaAttendVisitListScreen.routeName,
                  clearAllStack: true);
            }
            if (Support[i].Name == "Maintenance Contract")
              navigateTo(context, MaintenanceListScreen.routeName,
                  clearAllStack: true);
            if (Support[i].Name == "Service Report")
              navigateTo(context, ServiceReportListScreens.routeName,
                  clearAllStack: true);
          });
    },
  );
}

ExpantionCustomer(BuildContext context, int index, customerdetails) {
  return ExpansionTile(
    //gif: 'lib/assets/gifs/bg_gif.gif',
    title: Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Customer",
            style: TextStyle(
              fontFamily: 'BalooBhai',
              fontSize: _fontSize_Label,
              color: Color(label_color),
            ),
          ),
          Text(
            customerdetails[index].customerName,
            style: TextStyle(
                fontFamily: 'BalooBhai',
                fontSize: _fontSize_Title,
                color: Color(title_color)),
          ),
        ],
      ),
    ),
    children: <Widget>[
      Container(
          margin: EdgeInsets.only(left: 50),
          child:
              /*Text("Content goes over here !",
              style: TextStyle(
                  fontFamily: 'BalooBhai',
                  fontSize: 20,
                  color: Colors.black)),*/
              Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("GST No  ",
                                      style: TextStyle(
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          fontStyle: FontStyle.italic,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].gSTNO == ""
                                          ? "N/A"
                                          : customerdetails[index].gSTNO,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Category  ",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].customerType == ""
                                          ? "N/A"
                                          : customerdetails[index].customerType,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Source",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index]
                                                  .customerSourceName ==
                                              "--Not Available--"
                                          ? "N/A"
                                          : customerdetails[index]
                                              .customerSourceName,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              ))
                        ]),
                    SizedBox(
                      height: sizeboxsize,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Contact No1.",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].contactNo1 == ""
                                          ? "N/A"
                                          : customerdetails[index].contactNo1,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Contact No2.",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].contactNo2 == ""
                                          ? "N/A"
                                          : customerdetails[index].contactNo2,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              ))
                        ]),
                    SizedBox(
                      height: sizeboxsize,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Email",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].emailAddress == ""
                                          ? "N/A"
                                          : customerdetails[index].emailAddress,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              ))
                        ]),
                    SizedBox(
                      height: sizeboxsize,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Address",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].address == ""
                                          ? "N/A"
                                          : customerdetails[index].address,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              ))
                        ]),
                    SizedBox(
                      height: sizeboxsize,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Area",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].area == ""
                                          ? "N/A"
                                          : customerdetails[index].area,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Pin-Code",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].pinCode == ""
                                          ? "N/A"
                                          : customerdetails[index].pinCode,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("City",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].cityName == ""
                                          ? "N/A"
                                          : customerdetails[index].cityName,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              ))
                        ]),
                    SizedBox(
                      height: sizeboxsize,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("State",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].stateName == ""
                                          ? "N/A"
                                          : customerdetails[index].stateName,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Country",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].countryName == ""
                                          ? "N/A"
                                          : customerdetails[index].countryName,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("WebSite",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].websiteAddress ==
                                              ""
                                          ? "N/A"
                                          : customerdetails[index]
                                              .websiteAddress,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              ))
                        ]),
                    SizedBox(
                      height: sizeboxsize,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Created By",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].createdBy == ""
                                          ? "N/A"
                                          : customerdetails[index].createdBy,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              ))
                        ]),
                    SizedBox(
                      height: sizeboxsize,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Created Date",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(label_color),
                                          fontSize: _fontSize_Label,
                                          letterSpacing: .3)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      customerdetails[index].createdDate == ""
                                          ? "N/A"
                                          : customerdetails[index].createdDate,
                                      style: TextStyle(
                                          color: Color(title_color),
                                          fontSize: _fontSize_Title,
                                          letterSpacing: .3)),
                                ],
                              )),
                          /* Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: <Widget>[
                                    Text("Created By",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            letterSpacing: .3)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(Customerdetails[index].createdBy == "" ?"N/A" : Customerdetails[index].createdBy,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            letterSpacing: .3)),
                                  ],
                                )
                            )*/
                        ]),
                    SizedBox(
                      height: sizeboxsize,
                    ),
                  ],
                ),
              ),
            ],
          ))
    ],
  );
}

///Customer ADD_EDIT Screen
Container MyCustomDropDown(String dropdownValue, Function getDetails) {
  return Container(
      child: DropdownButton<String>(
    isExpanded: true,
    value: dropdownValue,
    icon: const Icon(Icons.arrow_downward),
    iconSize: 24,
    elevation: 16,
    style: const TextStyle(color: Colors.deepPurple),
    underline: Container(
      height: 2,
      color: Colors.deepPurpleAccent,
    ),
    items: <String>['One', 'Two', 'Free', 'Four']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: (String newValue) {
      getDetails(() {
        dropdownValue = newValue;
      });
    },
  ));
}

Widget buildCustomerTextFiled(
    {TextEditingController
        userName_Controller} /*String Username,TextEditingController edt_UserName*/) {
  return Container(
    margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
    child: TextFormField(
      controller: userName_Controller,
      cursorColor: Colors.black,
      //initialValue: userName_Controller.text,
      decoration: InputDecoration(
        labelText: "User Name",
        labelStyle: TextStyle(
          color: Color(0xFF000000),
        ),
        suffixIcon: Icon(
          Icons.person,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

Widget buildContactNo1TextFiled(
    {TextEditingController
        userName_Controller} /*String Username,TextEditingController edt_UserName*/) {
  return Container(
    margin: const EdgeInsets.only(left: 20.0, top: 10.0),
    child: TextFormField(
      controller: userName_Controller,
      cursorColor: Colors.black,
      //initialValue: userName_Controller.text,
      decoration: InputDecoration(
        labelText: "Contact No1",
        labelStyle: TextStyle(
          color: Color(0xFF000000),
        ),
        suffixIcon: Icon(
          Icons.phone_android,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

Widget buildContactNo2TextFiled(
    {TextEditingController
        userName_Controller} /*String Username,TextEditingController edt_UserName*/) {
  return Container(
    margin: const EdgeInsets.only(right: 20.0, top: 10.0),
    child: TextFormField(
      controller: userName_Controller,
      cursorColor: Colors.black,
      //initialValue: userName_Controller.text,
      decoration: InputDecoration(
        labelText: "Contact No2",
        labelStyle: TextStyle(
          color: Color(0xFF000000),
        ),
        suffixIcon: Icon(
          Icons.phone_android,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

Widget buildGSTTextFiled(
    {TextEditingController
        userName_Controller} /*String Username,TextEditingController edt_UserName*/) {
  return Container(
    margin: const EdgeInsets.only(left: 20.0, top: 10.0),
    child: TextFormField(
      controller: userName_Controller,
      cursorColor: Colors.black,
      //initialValue: userName_Controller.text,
      decoration: InputDecoration(
        labelText: "GST No",
        labelStyle: TextStyle(
          color: Color(0xFF000000),
        ),
        suffixIcon: Icon(
          Icons.phone_android,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

Widget buildPANTextFiled(
    {TextEditingController
        userName_Controller} /*String Username,TextEditingController edt_UserName*/) {
  return Container(
    margin: const EdgeInsets.only(right: 20.0, top: 10.0),
    child: TextFormField(
      controller: userName_Controller,
      cursorColor: Colors.black,
      //initialValue: userName_Controller.text,
      decoration: InputDecoration(
        labelText: "PAN No",
        labelStyle: TextStyle(
          color: Color(0xFF000000),
        ),
        suffixIcon: Icon(
          Icons.phone_android,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

Widget buildEmailTextFiled(
    {TextEditingController
        userName_Controller} /*String Username,TextEditingController edt_UserName*/) {
  return Container(
    margin: const EdgeInsets.only(left: 20.0, top: 10.0),
    child: TextFormField(
      controller: userName_Controller,
      cursorColor: Colors.black,
      //initialValue: userName_Controller.text,
      decoration: InputDecoration(
        labelText: "Email ID",
        labelStyle: TextStyle(
          color: Color(0xFF000000),
        ),
        suffixIcon: Icon(
          Icons.phone_android,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

Widget buildWebSiteTextFiled(
    {TextEditingController
        userName_Controller} /*String Username,TextEditingController edt_UserName*/) {
  return Container(
    margin: const EdgeInsets.only(right: 20.0, top: 10.0),
    child: TextFormField(
      controller: userName_Controller,
      cursorColor: Colors.black,
      //initialValue: userName_Controller.text,
      decoration: InputDecoration(
        labelText: "WebSite",
        labelStyle: TextStyle(
          color: Color(0xFF000000),
        ),
        suffixIcon: Icon(
          Icons.phone_android,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

Container getDropDown(List<String> data, String selected, BuildContext context,
    ThemeData baseTheme, Function f) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 12, right: 20),
            child: DropdownButton(
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
/*
                underline: Container(),
*/
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                icon: Container(
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(0 / 360),
                    child: Center(
                      child: Image.asset(
                        IC_DROP_DOWN_ARROW,
                        width: 20,
                        height: 20,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                isExpanded: true,
                value: selected,
                items: <String>['One', 'Two', 'Free', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),

                /*data
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: baseTheme.textTheme.bodyText1)))
                    .toList()*/
                onChanged: f),
          ),
        ),
      ],
    ),
  );
}

showcustomdialog(
    {List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    TextEditingController controllerID,
    TextEditingController controller2,
    String lable,
    Function onValueSelected}) async {
  await showDialog(
    barrierDismissible: false,
    context: context1,
    builder: (BuildContext context123) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colorPrimary, //                   <--- border color
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  lable,
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ))),
        children: [
          SizedBox(
              width: MediaQuery.of(context123).size.width,
              child: Column(
                children: [
                  SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(children: <Widget>[
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context1).pop();
                                controller.text = values[index].Name;
                                if (controller2 != null) {
                                  controller2.text = values[index].Name1 == null
                                      ? ""
                                      : values[index].Name1;
                                }
                                if (onValueSelected != null) {
                                  onValueSelected();
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 25, top: 10, bottom: 10, right: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorPrimary),
                                      width: 10.0,
                                      height: 10.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1.5),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      values[index].Name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: colorPrimary, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: values.length,
                        ),
                      ])),
                ],
              )),
        ],
      );
    },
  );
}

Future<String> showcustomdialogWithOnlyName({
  List<ALL_Name_ID> values,
  BuildContext context1,
  TextEditingController controller,
  String lable,
  VoidCallback onValueSelected, // Added this parameter
}) async {
  return await showDialog<String>(
    barrierDismissible: false,
    context: context1,
    builder: (BuildContext context123) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        title: Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorPrimary),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              lable,
              style:
                  TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        children: [
          SizedBox(
            width: MediaQuery.of(context123).size.width,
            child: Column(
              children: [
                SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: values.length,
                        itemBuilder: (ctx, index) {
                          return InkWell(
                            onTap: () {
                              controller.text = values[index].Name;
                              Navigator.of(context1).pop(values[index].Name);
                              if (onValueSelected != null) {
                                onValueSelected();
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 25, top: 10, bottom: 10, right: 10),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorPrimary,
                                    ),
                                    width: 10.0,
                                    height: 10.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1.5),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    values[index].Name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: colorPrimary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context1).pop();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFF27442),
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Color(0xFFF27442)),
                      ),
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

showcustomdialogWithTWOName({
  List<ALL_Name_ID> values,
  BuildContext context1,
  TextEditingController controller,
  TextEditingController controller1,
  String lable,
  Function onValueSelected,
}) async {
  await showDialog(
    barrierDismissible: false,
    context: context1,
    builder: (BuildContext context123) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 4,
        backgroundColor: Colors.white,
        child: Container(
          width: MediaQuery.of(context123).size.width * 0.85,
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.of(context123).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: EdgeInsets.fromLTRB(20, 16, 12, 16),
                decoration: BoxDecoration(
                  color: const Color(0xff0066b3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lable,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context1).pop(),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: values.length,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                if (controller != null) {
                                  controller.text = values[index].Name;
                                }
                                if (controller1 != null) {
                                  controller1.text = values[index].Name1 ?? "";
                                }
                                Navigator.of(context1).pop();
                                if (onValueSelected != null) {
                                  onValueSelected();
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 8,
                                  top: 4,
                                  bottom: 4,
                                  right: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF2F5FA),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff0066b3),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        values[index].Name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xff1A2332),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
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
                      const SizedBox(height: 12),
                      // Close Button
                      GestureDetector(
                        onTap: () => Navigator.of(context1).pop(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(
                              "Close",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

/*showcustomdialogWithID(
    {List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    TextEditingController controllerID,
    String lable}) async {
  await showDialog(
    barrierDismissible: false,
    context: context1,
    builder: (BuildContext context123) {
      return SimpleDialog(
        title: Text(lable),
        children: [
          SizedBox(
              width: MediaQuery.of(context123).size.width,
              child: Column(
                children: [
                  SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(children: <Widget>[
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context1).pop();
                                controller.text = values[index].Name;
                                controllerID.text =
                                    values[index].pkID.toString();
                                print(
                                    "IDSS : " + values[index].pkID.toString());
                              },
                              child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(values[index].Name)),
                            );


                          },
                          itemCount: values.length,
                        ),
                      ])),
                ],
              )),

        ],
      );
    },
  );
}*/

showcustomdialogWithID(
    {List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    TextEditingController controllerID,
    String lable}) async {
  await showDialog(
    barrierDismissible: false,
    context: context1,
    builder: (BuildContext context123) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colorPrimary, //                   <--- border color
              ),
              borderRadius: BorderRadius.all(Radius.circular(
                      15.0) //                 <--- border radius here
                  ),
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  lable,
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ))),
        children: [
          SizedBox(
              width: MediaQuery.of(context123).size.width,
              child: Column(
                children: [
                  SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(children: <Widget>[
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context1).pop();
                                controller.text = values[index].Name;
                                controllerID.text =
                                    values[index].pkID.toString();

                                print(
                                    "IDSS : " + values[index].pkID.toString());
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 25, top: 10, bottom: 10, right: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorPrimary), //Change color
                                      width: 10.0,
                                      height: 10.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1.5),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        values[index].Name,
                                        style: TextStyle(
                                            color: colorPrimary, fontSize: 12),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: values.length,
                        ),
                      ])),
                ],
              )),
        ],
      );
    },
  );
}

showcustomdialogWithLargeNameID(
    {List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    TextEditingController controllerID,
    String lable}) async {
  await showDialog(
    barrierDismissible: false,
    context: context1,
    builder: (BuildContext context123) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colorPrimary, //                   <--- border color
              ),
              borderRadius: BorderRadius.all(Radius.circular(
                      15.0) //                 <--- border radius here
                  ),
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  lable,
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ))),
        children: [
          SizedBox(
              width: MediaQuery.of(context123).size.width,
              child: Column(
                children: [
                  SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(children: <Widget>[
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context1).pop();
                                controller.text = values[index].Name;
                                controllerID.text =
                                    values[index].pkID.toString();

                                print(
                                    "IDSS : " + values[index].pkID.toString());
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 25, top: 10, bottom: 10, right: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorPrimary), //Change color
                                      width: 10.0,
                                      height: 10.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1.5),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        values[index].Name,
                                        style: TextStyle(
                                            color: colorPrimary, fontSize: 12),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            /* return SimpleDialogOption(
                              onPressed: () => {
                                controller.text = values[index].Name,
                                controller2.text = values[index].Name1,
                              Navigator.of(context1).pop(),


                            },
                              child: Text(values[index].Name),
                            );*/
                          },
                          itemCount: values.length,
                        ),
                      ])),
                ],
              )),
          /*Center(
            child: Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  color: Color(0xFFF27442),
                  borderRadius: BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Color(0xFFF27442))),
              //color: Color(0xFFF27442),
              child: GestureDetector(
                child: Text(
                  "Close",
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),*/
        ],
      );
    },
  );
}

showcustomdialogWithOtherCharges(
    {List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    TextEditingController controllerID,
    TextEditingController controller1,
    TextEditingController controller2,
    TextEditingController controller3,
    TextEditingController controller4,
    String lable}) async {
  await showDialog(
    barrierDismissible: false,
    context: context1,
    builder: (BuildContext context123) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colorPrimary, //                   <--- border color
              ),
              borderRadius: BorderRadius.all(Radius.circular(
                      15.0) //                 <--- border radius here
                  ),
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  lable,
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ))),
        children: [
          SizedBox(
              width: MediaQuery.of(context123).size.width,
              child: Column(
                children: [
                  SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(children: <Widget>[
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context1).pop();
                                controller.text = values[index].Name;
                                controllerID.text =
                                    values[index].pkID.toString();
                                controller1.text = values[index].TaxRate;
                                controller2.text = values[index].Taxtype;
                                controller3.text =
                                    values[index].isChecked.toString();

                                print(
                                    "IDSS : " + values[index].pkID.toString());
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 25, top: 10, bottom: 10, right: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorPrimary), //Change color
                                      width: 10.0,
                                      height: 10.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1.5),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Text(
                                        values[index].Name,
                                        softWrap: true,
                                        style: TextStyle(color: colorPrimary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            /* return SimpleDialogOption(
                              onPressed: () => {
                                controller.text = values[index].Name,
                                controller2.text = values[index].Name1,
                              Navigator.of(context1).pop(),


                            },
                              child: Text(values[index].Name),
                            );*/
                          },
                          itemCount: values.length,
                        ),
                      ])),
                ],
              )),
          /*Center(
            child: Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  color: Color(0xFFF27442),
                  borderRadius: BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Color(0xFFF27442))),
              //color: Color(0xFFF27442),
              child: GestureDetector(
                child: Text(
                  "Close",
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),*/
        ],
      );
    },
  );
}

showcustomdialogWithMultipleID(
    {List<ALL_Name_ID> values,
    BuildContext context1,
    TextEditingController controller,
    TextEditingController controllerID,
    TextEditingController controller2,
    String lable}) async {
  await showDialog(
    barrierDismissible: false,
    context: context1,
    builder: (BuildContext context123) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colorPrimary, //                   <--- border color
              ),
              borderRadius: BorderRadius.all(Radius.circular(
                      15.0) //                 <--- border radius here
                  ),
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  lable,
                  softWrap: true,
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ))),
        children: [
          SizedBox(
              width: MediaQuery.of(context123).size.width,
              child: Column(
                children: [
                  SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(children: <Widget>[
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context1).pop();
                                controller.text = values[index].Name;
                                controllerID.text =
                                    values[index].pkID.toString();
                                controller2.text =
                                    values[index].Name1.toString();
                                print(
                                    "IDSS : " + values[index].pkID.toString());
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 25, top: 10, bottom: 10, right: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    /*Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorPrimary), //Change color
                                      width: 10.0,
                                      height: 10.0,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1.5),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),*/
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      child: Icon(
                                        Icons.ac_unit,
                                        color: colorPrimary,
                                        size: 10,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      child: Flexible(
                                        child: Text(
                                          values[index].Name,
                                          softWrap: true,
                                          style: TextStyle(
                                              color: colorPrimary,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            /* return SimpleDialogOption(
                              onPressed: () => {
                                controller.text = values[index].Name,
                                controller2.text = values[index].Name1,
                              Navigator.of(context1).pop(),


                            },
                              child: Text(values[index].Name),
                            );*/
                          },
                          itemCount: values.length,
                        ),
                      ])),
                ],
              )),
          /*Center(
            child: Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  color: Color(0xFFF27442),
                  borderRadius: BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Color(0xFFF27442))),
              //color: Color(0xFFF27442),
              child: GestureDetector(
                child: Text(
                  "Close",
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),*/
        ],
      );
    },
  );
}

Widget EditText(BuildContext context,
    {String title: "",
    String hint: "",
    TextInputAction textInputAction: TextInputAction.next,
    bool obscureText: false,
    EdgeInsetsGeometry contentPadding:
        const EdgeInsets.only(top: 0, bottom: 10),
    int maxLength: 1000,
    TextAlign textAlign: TextAlign.left,
    TextEditingController controller,
    TextInputType keyboardType,
    FormFieldValidator<String> validator,
    int maxLines: 1,
    Function(String) onSubmitted,
    Function(String) onTextChanged,
    TextStyle titleTextStyle,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextStyle inputTextStyle,
    List<TextInputFormatter> inputFormatter,
    bool readOnly: false,
    double radius: 10,
    double boxheight: 35,
    Color cardColor: colorLightGray,
    double FontSize: 13,
    double HintFontSize: 13,
    double elivation: 3,
    Function onPressed,
    Widget suffixIcon}) {
  return GestureDetector(
    onTap: onPressed,
    child: Card(
        elevation: elivation,
        color: cardColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: Container(
          height: boxheight,
          padding: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                  textCapitalization: textCapitalization,
                  inputFormatters: inputFormatter,
                  keyboardType: keyboardType,
                  style: inputTextStyle,
                  textAlign: textAlign,
                  maxLines: maxLines,
                  cursorColor: colorPrimaryLight,
                  textInputAction: textInputAction,
                  obscureText: obscureText,
                  readOnly: readOnly,
                  maxLength: maxLength,
                  controller: controller,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle:
                        TextStyle(color: colorGrayDark, fontSize: HintFontSize),
                    isDense: true,
                    border: InputBorder.none,
                    suffixIconConstraints:
                        BoxConstraints(maxHeight: 30, maxWidth: 30),
                    contentPadding: EdgeInsets.only(bottom: 10, top: 15),
                    counterText: "",
                  ),
                  validator: validator,
                  onChanged: onTextChanged,
                  onFieldSubmitted: onSubmitted,
                ),
              ),
              Container(margin: EdgeInsets.only(right: 10), child: suffixIcon)
            ],
          ),
        )),
  );
}

class CustomAnimatedPadding extends StatelessWidget {
  final Widget child;

  CustomAnimatedPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

Widget customAppBar(context, String title) {
  return NewGradientAppBar(
    gradient: LinearGradient(colors: [
      Color(0xff108dcf),
      Color(0xff0066b3),
      Color(0xff62bb47),
    ]),
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
        size: 15,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
    actions: <Widget>[
      IconButton(
          icon: Icon(
            Icons.water_damage_sharp,
            color: colorWhite,
            size: 20,
          ),
          onPressed: () {
            //_onTapOfLogOut();
            navigateTo(context, HomeScreen.routeName, clearAllStack: true);
          })
    ],
    title: Text(
      title,
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
    ),
  );
}

Widget space(double height, double width) {
  return SizedBox(
    height: height,
    width: width,
  );
}

Widget customTextLabel(String labelName,
    {Alignment alignment = Alignment.centerLeft,
    double leftPad = 0,
    double rightPad = 0,
    double bottomPad = 0,
    double topPad = 0}) {
  return Align(
    alignment: alignment,
    child: Container(
      padding: EdgeInsets.only(
          left: leftPad, right: rightPad, bottom: bottomPad, top: topPad),
      child: Row(
        children: [
          Text(labelName,
              style: TextStyle(
                  fontSize: 10,
                  color: colorBlack,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}

Widget customExpansionTileType1(String title, Column column, Icon icon,
    {Color color = Colors.white70, String image = ""}) {
  return Container(
    child: Card(
      // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff362d8b),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Theme(
          data: ThemeData().copyWith(
            visualDensity: VisualDensity(horizontal: -1.5, vertical: -1.5),
            dividerColor: Colors.transparent,
          ),
          child: ListTileTheme(
            dense: true,
            child: ExpansionTile(
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),

              leading: Container(
                  child: image != "" ? Image.asset(image, width: 27) : icon),

              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: column),
              ], // children:
            ),
          ),
        ),
        // height: 60,
      ),
    ),
  );
}

Widget commonalertbox(String msg, BuildContext context,
    {GestureTapCallback onTapofPositive, bool useRootNavigator = true}) {
  showDialog(
      context: context,
      builder: (BuildContext ab) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          actions: [
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue, width: 2.00),
              ),
              alignment: Alignment.center,
              child: Text(
                "Alert!",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.center,
              //margin: EdgeInsets.only(left: 10),
              child: Text(
                msg,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              height: 1.00,
              thickness: 2.00,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: onTapofPositive ??
                  () {
                    Navigator.of(context, rootNavigator: useRootNavigator)
                        .pop();
                  },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Ok",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      });
}
