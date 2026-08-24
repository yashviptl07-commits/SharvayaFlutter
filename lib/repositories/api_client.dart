import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/models/common/multiple_expense_table.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

import 'custom_exception.dart';
import 'error_response_exception.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class ApiClient {
  ///add end point of your apis as below
  static const END_POINT_MASTER_BASE_URL = 'BaseURL/SerialKey';

  static const END_POINT_LOGIN = 'Login/SerialKey';

  /// end point of login User Details
  static const END_POINT_LOGIN_USER_DETAILS = 'Login';
  static const END_POINT_LIST = 'users';
  static const END_POINT_CUSTOMER_CATEGORY = 'Customer/CategoryList';
  static const END_POINT_CUSTOMER_SOURCE = 'Customer/Source';
  static const END_POINT_COUNTRYLIST = 'Country/List';
  static const END_POINT_STATELIST = 'Customer/States/Search';
  static const END_POINT_CUSTOMER_PAGINATION = 'Customer';
  static const END_POINT_CUSTOMER_SEARCH = 'Customer/Search';
  static const END_POINT_CUSTOMER_SEARCH_BY_ID = 'Customer/';
  static const END_POINT_MENU_RIGHTS = "dashboard/MenuList";
  static const End_POINT_DISTRICT_LIST = "Customer/District/Search";
  static const END_POINT_TALUKA_LIST = "Customer/Taluka/Search";
  static const END_POINT_CITY_LIST = "Customer/Cities/Search";
  static const END_POINT_INQUIRY = 'Inquiry';
  static const END_POINT_QUOTATION = 'Quatation';
  static const END_POINT_SALESBILL = 'SalesBill';

  static const END_POINT_FOLLOWUP = 'FollowUp';
  static const END_POINT_TODO_WIDGET = 'Todo/Search';
  static const END_POINT_TODO_LIST = 'Todo/Search';

  static const END_POINT_INQUIRY_SEARCH_BY_NAME = 'Inquiry/SearchByName';
  static const END_POINT_INQUIRY_SEARCH_BY_PKID = 'Inquiry/';
  static const END_POINT_QUOTATION_SEARCH_BY_NAME = 'Quatation/Search';
  static const END_POINT_SALESORDER_PAGINATION = 'SalesOrder';
  static const END_POINT_INQUIRY_SEARCH_BY_INQUIRY_NO =
      'Inquiry/SearchByInquiryNo';
  static const END_POINT_QUOTATION_SEARCH_BY_QUOTATION_NO = 'Quatation/';
  static const END_POINT_SALESORDER_SEARCH_BY_NAME = 'SalesOrder/Search';
  static const END_POINT_QUOTATION_SEARCH_BY_SALESORDER_NO = 'SalesOrder/';
  static const END_POINT_FOLLOWUP_FILTER_PAGINATION = 'FollowUp/';
  static const END_POINT_FOLLOWUP_FILTER_PAGINATION_FOR_ALMIGHTY =
      'FollowUpForAlmighty/';
  static const END_POINT_FOLLOWUP_SEARCH_BY_STATUS = 'InquiryFollowUp/Status';
  static const END_POINT_FOLLOWER_EMPLOYEE_LIST =
      'Inquiry/EmployeeFollowerList';
  static const END_POINT_DESIGNATION_LIST = "Designation/List";
  static const END_POINT_CUSTOMER_ADD_EDIT = "Customer/";
  static const END_POINT_FOLLOWUP_TYPE_LIST =
      "Customer/Source"; //"Inquiry/Category";
  static const END_POINT_FOLLOWUP_INQUIRY_NO_LIST =
      "FollowUp/InquiryNoToFollowUp";
  static const END_POINT_FOLLOWUP_SAVE = "FollowUp/";
  static const END_POINT_FOLLOWUP_DELETE = "FollowUp/";
  static const END_POINT_EXPENSE_DELETE = "Expense/";
  static const END_POINT_INQUIRY_DELETE = "Inquiry/";
  static const END_POINT_LEAVE_REQUEST_DELETE = "LeaveRequest/";
  static const END_POINT_CUSTOMER_DELETE = "Customer/";
  static const END_POINT_ATTENDANCE_LIST = "DailyAttendance/List";
  static const END_POINT_ATTENDANCE_HOLIDAY_LIST = "Holiday/List";
  static const END_POINT_ATTENDANCE_SAVE = "DailyAttendance/0/Save";
  static const END_POINT_ATTENDANCE_DELETE = "Attendance/";
  static const END_POINT_LEAVE_REQUEST_PAGINATION = "LeaveRequest";
  static const END_POINT_LEAVE_REQUEST_TYPE = "LeaveRequest/Type";
  static const END_POINT_LEAVE_REQUEST_SAVE = "LeaveRequest/";
  static const END_POINT_EXPENSE_PAGINATION_FILTER = "Expense/Search";
  static const END_POINT_EXPENSE_TYPE = "/Expense/ExpenseType";
  static const END_POINT_EXPENSE_SAVE = "Expense/";
  static const END_POINT_EXPENSE_UPLOAD = "Expense/UploadImage";
  static const END_POINT_FOLLOWUP_UPLOAD = "FollowUp/UploadImage";
  static const END_POINT_EXPENSE_UPLOAD_SERVER = "Expense/";
  static const END_POINT_EXPENSE_DELETE_IMAGE = "Expense/";
  static const END_POINT_FOLLOWUP_INQUIRY_BY_CUSTOMER_ID =
      "Inquiry/FetchByCustomerID";
  static const END_POINT_PRODUCT_SEARCH = "Inquiry/Product/List";
  static const END_POINT_CUSTOMER_CONTACT_SAVE = "Customer/Contacts/INS_UPD";
  static const END_POINT_INQUIRY_HEADER_SAVE = "Inquiry/";
  static const END_POINT_INQUIRY_NO_TO_PRODUCT_LIST = "Inquiry/Products/1-1000";
  static const END_POINT_INQUIRY_NO_TO_DELETE_PRODUCT_LIST = "Inquiry/";
  static const END_POINT_CUSTOMER_ID_TO_CONTACT_DETAILS =
      "Customer/Contacts/Search";
  static const END_POINT_CUSTOMER_ID_TO_CONTACT_ALL_DELETE =
      "Customer/Contacts/";
  static const END_POINT_FOLLOWUP_IMAGE_DELETE_BY_PK_ID = "FollowUp/";
  static const END_POINT_INQUIRY_PRODUCT_SAVE = "Inquiry/Product/INS_UPD";
  static const END_POINT_FETCH_IMAGE_LIST_BY_EXPENSE_PKID =
      'Expense/0/ImageList';
  static const END_POINT_GOOGLE_PLACE_SEARCH =
      'https://maps.googleapis.com/maps/api/place/textsearch/json';
  static const END_POINT_DISTANCE_MATRIX =
      'https://maps.googleapis.com/maps/api/distancematrix/json';
  static const END_POINT_LOCATION_ADDRESS =
      'https://maps.google.com/maps/api/geocode/json';
  static const END_POINT_FOLLOWUP_HISTORY_LIST =
      "InquiryNo/FollowUpDetail"; //"Inquiry/Category";
  static const END_POINT_INQUIRY_NO_FOLLLOWUP_DETAILS =
      "InquiryNo/FollowUpDetail";
  static const END_POINT_DAILY_ACTIVITY_LIST_DETAILS = "DailyActivity";
  static const END_POINT_DAILY_ACTIVITY_DELETE = "DailyActivity/";
  static const END_POINT_TASK_CATEGORY = "DailyActivity/TaskCategoryList";
  static const END_POINT_DAILY_ACTIVITY_MODULE_DRP_DETAILS =
      "SIDailyActivity/ModuleList";
  static const END_POINT_DAILY_ACTIVITY_SAVE_DETAILS = "DailyActivity";
  static const END_POINT_TO_DO_SAVE = "Todo/";
  static const END_POINT_TO_DO_WORK_LOG = "TodoLog/List";
  static const END_POINT_SALES_BILL_SEARCH_BY_NAME = 'SalesBill/Search';
  static const END_POINT_QUOTATION_GENERATE_PDF = 'Quatation/GenerateQuotation';
  static const END_POINT_SALES_ORDER_GENERATE_PDF =
      'SalesOrder/GenerateSalesOrder';
  static const END_POINT_SALES_BILL_GENERATE_PDF =
      'SalesBill/GenerateSalesBill';
  static const END_POINT_INQUIRY_SHARE = "InquiryOwner/Share";
  static const END_POINT_ALL_EMPLOYEE_LIST = 'Inquiry/OrgEmployeeList';
  static const END_POINT_INQUIRY_SHARED_EMP_LIST = 'Inquiry/Share';
  static const END_POINT_BANK_VOUCHER_LIST_DETAILS = "FinancialTransaction";
  static const END_POINT_BANK_VOUCHER_SEARCH = 'FinancialTransaction/Search';
  static const END_POINT_TRANSECTION_MODE_LIST_DETAILS =
      "FinancialTransaction/Wallet";

  static const END_POINT_BANK_DROP_DOWN = 'SalesOrder/BankDetails';
  static const END_POINT_COMPLAINT_LIST_DETAILS = "Complaint";
  static const END_POINT_COMPLAINT_SEARCH_BY_NAME_DETAILS = "Complaint/Search";
  static const END_POINT_COMPLAINT_SEARCH_BY_ID_DETAILS = "Complaint";
  static const END_POINT_ACCURABATH_COMPLAINT_IMAGE_LIST =
      "ModuleAttachments/AttachmentsList";

  static const END_POINT_COMPLAINT_SAVE_DETAILS = "Complaint";
  static const END_POINT_ATTEND_VISIT_DETAILS = "ComplaintVisit";
  static const END_POINT_COMPLAINT_NO_LIST_DETAILS =
      "ComplaintVisit/CustomerID";
  static const END_POINT_ATTEND_VISIT_SAVE_DETAILS = "ComplaintVisit";
  static const END_POINT_ATTEND_VISIT_SEARCH_DETAILS = "ComplaintVisit/Search";
  static const END_POINT_QTNO_TO_PRODUCT_LIST = 'Quatation/Products';
  static const END_POINT_QUOTATION_PRODUCT_SAVE =
      "Quatation/ProductSaveByProdId";
  static const END_POINT_QUOTATION_SPEC_LIST =
      'ProSpec/'; //'Quatation/0/Specifications';
  static const END_POINT_QUOTATION_KIND_ATT_LIST = 'Quatation/KindlyAttention';
  static const END_POINT_QUOTATION_PROJECT_LIST = 'Quatation/ProjectList';
  static const END_POINT_QUOTATION_TERMS_CONDITION_LIST = 'Quatation/TNC';
  static const END_POINT_CUST_ID_TO_INQ_LIST =
      'Quatation/CustomerIdToInquiryNo';
  static const END_POINT_INQ_NO_PRODUCT_LIST =
      'Quatation/CustomerIdToInquiryDetail';
  static const END_POINT_QUOTATION_HEADER_REQUEST = "Quatation";
  static const END_POINT_QT_NO_TO_DELETE_PRODUCT_LIST = "Quatation/ProductDel";

  static const END_POINT_DELETE_QUOTATION = "Quatation/";

  static const END_POINT_EMPLOYEE_LIST_DETAILS = "Employee";
  static const END_POINT_EMPLOYEE_SEARCH_DETAILS = "Employee/SearchByName";
  static const END_POINT_EMPLOYEE_DELETE_DETAILS = "Employee";

  static const END_POINT_LOAN_LIST_DETAILS = "Loan";
  static const END_POINT_LOAN_SEARCH_DETAILS = "Loan/Search";
  static const END_POINT_LOAN_DELETE_DETAILS = "Loan";
  static const END_POINT_LOAN_APPROVAL_LIST_DETAILS = "Loan/ByApprovalStatus";
  static const END_POINT_LOAN_APPROVAL_SAVE_DETAILS = "Loan/";

  static const END_POINT_MISSED_PUNCH_LIST_DETAILS = "MissedPunch";
  static const END_POINT_MISSED_PUNCH_SEARCH_DETAILS = "MissedPunch/Search";
  static const END_POINT_MISSED_PUNCH_SEARCH_BY_ID_DETAILS = "MissedPunch/";
  static const END_POINT_MISSED_PUNCH_DELETE_BY_ID_DETAILS = "MissedPunch/";

  static const END_POINT_SALARY_UPAD_LIST_DETAILS = "Salary";
  static const END_POINT_MISSED_SALARY_UPAD_DELETE_BY_ID_DETAILS = "Salary";

  static const END_POINT_MAINTENANCE_LIST_DETAILS = "Maintenance/List";

  static const END_POINT_MAINTENANCE_SEARCH_DETAILS = "Maintanance/Search";
  static const END_POINT_MISSED_PUNCH_APPROVAL_LIST_DETAILS =
      "MissedPunch/ListByStatus";
  static const END_POINT_EXTERNAL_LEAD_SEARCH_DETAILS = "ExternalLead/Search";
  static const END_POINT_EXTERNAL_LEAD_SAVE_DETAILS = "ExternalLead";
  static const TAG = "ApiClient";
  static const END_POINT_EXTERNAL_LEAD_PAGINATION = 'ExternalLead';
  static const END_POINT_TELE_CALLER_PAGINATION = 'TeleCaller';
  static const END_POINT_TELE_CALLER_SEARCH_DETAILS = "TeleCaller/Search";
  static const END_POINT_TELE_CALLER_PAGINATION1 = 'TeleCaller123';
  static const END_POINT_DOLPHIN_ATTEND_VISIT_DETAILS = "DolComplaintVisit";
  static const END_POINT_DOLPHIN_COMPLAINT_VISIT_SEARCH_DETAILS =
      "DolComplaintVisit/Search";
  static const END_POINT_DOLPHIN_COMPLAINT_VISIT_SEARCH_ID_DETAILS =
      "DolComplaintVisit";
  static const END_POINT_DOLPHIN_COMPLAINT_VISIT_DELETE_DETAILS =
      "DolComplaintVisit/CompaintDel";
  static const END_POINT_DOLPHIN_COMPLAINT_VISIT_SAVE_DETAILS =
      "DolComplaintVisit";

  static const END_POINT_Packing_checklist_list = 'PackingCheckList';
  static const END_POINT_Final_Checking_List = 'FinalChecking';
  static const END_POINT_Production_Activity_List = 'Production/Filter';
  static const END_POINT_Installation_Search = 'Installation/Search';
  static const END_POINT_FinalChecking_Search = 'FinalChecking/Search';
  static const END_POINT_PackingChecklist_Search = 'PackingCheckList/Search';
  static const END_POINT_PackingChecklist_DELETE = 'PackingChecking';
  static const END_POINT_PackingOutWord_List = 'CustomerID/OrderNo';
  static const END_POINT_PackingProductAssamblyList =
      'PackingChecking/SalesOrderAssemblyList';
  static const END_POINT_Product_GroupDropDown =
      'PackingCheckList/ProductGroup';
  static const END_POINT_Product_DropDown = 'PackingCheckList/ProductNameList';
  static const END_POINT_PACKING_SAVE = 'PackingCheckList/';
  static const END_POINT_PACKING_ASSAMBLY_SAVE = 'PackinAssembly/0/DetailSave';
  static const END_POINT_PACKING_NO_LIST = 'CustomerID/PackingNoList';
  static const END_POINT_PACKING_ASSAMBLY_EDIT_MODE = 'PackingDetail/List';
  static const END_POINT_PACKING_ASSAMBLY_ALL_DELETE = 'PackingAssembly/';
  static const END_POINT_FINAL_CHECKING_ITEMS = 'CustomerID/CatDescSSRList';
  static const END_POINT_CHECKING_TO_CHECKING_ITEMS =
      'FinalCheckingDetail/List';
  static const END_POINT_FINAL_CHEKING_SAVE = 'FinalChecking/';
  static const END_POINT_FINAL_CHECKING_SUB_DETAILS_SAVE =
      'FinalCheckingDetail/0/DetailSave';
  static const END_POINT_FINAL_CHEKING_DELETE_ALL_ITEM = 'FinalCheckingDetail/';
  static const END_POINT_FINAL_CHEKING_DELETE_FROM_LIST_SCREEN =
      'FinalChecking/';

  static const END_POINT_Installation_List = 'Installation';
  static const END_POINT_Save_Installation_List = 'Installation';
  static const END_POINT_Delete_Installation = 'Installation';
  static const END_POINT_Installation_country = 'Customer/Country';
  static const END_POINT_Id_To_Outward = 'CustomerID/OutwardNoList';
  static const END_POINT_Installation_employee = 'Inquiry/OrgEmployeeList';
  static const END_POINT_Production_Typeofwork =
      'DailyActivity/TaskCategoryList';
  static const END_POINT_Production_packinglist = 'Production/PackingNoList';
  static const END_POINT_Production_Save = 'Production';
  static const END_POINT_QUICK_FOLLOWUP_LIST = 'FollowUp/ActiveStatus';
  static const END_POINT_QUICK_FOLLOWUP_SAVE = "QuickFollowUp/";
  static const END_POINT_TELE_CALLER_New_pagination = 'TeleCaller123';
  static const END_POINT_NEW_TELE_CALLER_SAVE = 'SwastikTeleCaller';
  static const END_POINT_INQUIRY_SEARCH_BY_FILLTER = 'Inquiry/SearchList';
  static const END_POINT_TELECALLER_IMG_UPLOAD = "TeleCaller/UploadImage";
  static const END_POINT_TELECALLER_IMAGE_DELETE_BY_PK_ID = "TeleCaller/";
  static const END_POINT_TO_DO_DELETE = "Todo";
  static const END_POINT_ATTEND_VISIT_DELETE = "ComplaintVisit/CompaintDel";
  static const END_POINT_SALES_BILL_BY_ID = "SalesBill/";
  static const END_POINT_MISSED_PUNCH_APPROVAL_SAVE = "MissedPunch/";
  static const END_POINT_SALES_ORDER_BANK_DETIALS = "OrganizationBank/List";
  static const END_POINT_SALES_BILL_EMAIL_CONTENT =
      "Quatation/0/GeneralEmailList";
  static const END_POINT_SALES_BILL_INQ_QT_SO_NO_LIST_API =
      "SalesBill/CustomerIDToModuleDetails";
  static const END_POINT_INQ_QT_SO_NO_PRODUCT_LIST_API =
      "SalesBill/FetDetailByInqQuotSo";
  /******************************Material Inward******************************/
  static const END_POINT_MATERIAL_INWARD_LIST = 'Inward';
  static const END_POINT_MATERIAL_OUTWARD_LIST = 'Outward';
  static const API_TOKEN_UPDATE = 'Common/UserWiseTokenUpdate';
  static const API_GET_REPORT_TO_TOKEN_API = 'GetToken/ReportPerson';
  static const API_UPLOAD_CUSTOMER_DOCUMENT = 'Customer/UploadAttachments';
  static const API_FETCH_CUSTOMER_DOCUMENT = 'Customer/AttachmentsList';
  static const API_DELETE_CUSTOMER_DOCUMENT = 'Customer/';
  static const END_POINT_ACCURABATH_COMPLAINT_FOLLOWUP_HISTORY_LIST =
      "ComplaintAcura/";

  static const END_POINT_ACCURABATH_COMPLAINT_SAVE_FOLLOWUP =
      "ComplaintAcura/0/FollowUp";
  static const END_POINT_ACCURABATH_COMPLAINT_EMPLOYEE_LIST =
      "ComplaintAcura/ServiceCenterlist";

  static const END_POINT_ACCURABATH_COMPLAINT_NO_DELETE_IMG =
      "ModuleAttachments/";

  static const END_POINT_ACCURABATH_COMPLAINT_NO_DELETE_VIDEO =
      "ComplaintAcura/";
  static const END_ACCURABATH_POINT_COMPLAINT_UPLOAD =
      "ModuleAttachments/UploadAttachments";

  static const END_ACCURABATH_POINT_COMPLAINT_UPLOAD_VIDEO =
      "ComplaintAcura/UploadVideoAttachments";
  static const END_GET_REGION_CODE = "Customer/Codes";

  static const END_POINT_SALES_ORDER_HEADER_SAVE_REQUEST = "SalesOrder/";
  static const END_POINT_QUICK_COMPLAINT_LIST_REQUEST =
      "QuickVisit/ActiveStatus";
  static const END_POINT_SALES_QUICK_COMPLAINT_SAVE_REQUEST = "QuickVisit/";

  static const END_POINT_PUNCH_ATTENDENCE_REQUEST =
      "DailyAttendanceModeNew/0/Save";

  static const END_POINT_SALES_ORDER_PRODUCT_SAVE = "SalesOrder/ProductSave";
  static const END_POINT_SALES_ORDER_PRODUCT_DELETE = "SalesOrder/";
  static const END_POINT_SAVE_EMAIL_CONTENT = "GeneralTemplate/0/Save";

  static const END_POINT_TELE_CALLER_FOLLOWUP_SAVE = 'InquiryFollowup/0/Save';
  static const END_POINT_TELE_CALLER_FOLLOWUP_FROM_FOLLOWUP_SAVE =
      'InquiryFollowup/';

  static const END_POINT_TELE_CALLER_FOLLOWUP_HISTORY =
      'FetchByExtpkID/1-100000';
  static const END_POINT_WITHOUT_IMAGE_SAVE_ATTENDANCE =
      'DailyAttendanceMode/0/Save';
  static const END_POINT_CONSTANT_MASTER = 'ConstantMaster/';

  static const END_POINT_USER_MENU_RIGHTS = 'MenuRights/';
  static const END_POINT_BULK_ASSIGN = '/ExternalLead/BulkAssign';

  static const END_POINT_ASSIGN_TO_NOTIFICATION = '/GetToken/ByEmployeeID';

  static const END_POINT_SB_HEADER_SAVE = 'SalesBill/';

  static const END_POINT_SALES_BILL_PRODUCT_SAVE = "SalesBill/";

  static const END_POINT_DELETE_SALES_ORDER = "SalesOrder/";

  static const END_POINT_SO_CURRENCY_LIST = "SalesOrder/Currency";

  static const END_POINT_SB_EXPORT_LIST = 'SalesBill/ExportList';
  static const END_POINT_SB_EXPORT_SAVE = 'SalesBillExport/0/Save';
  static const END_POINT_SB_HEADER_DELETE = 'SalesBill/';
  static const END_POINT_QT_SPECIFICATION_SAVE = 'Quatation/Product/Spec-Save/';

  static const END_POINT_PRODUCT_MASTER_LIST_API = 'Product/';

  static const END_POINT_PRODUCT_BRAND_LIST = 'ProductBrand/Brand';
  static const END_POINT_SALES_TARGET_PAGINATION = 'SalesTarget';
  static const END_POINT_SALES_TARGET_DELETE = 'SalesTarget/Delete';
  static const END_POINT_SALES_TARGET_ADD_EDIT = 'SalesTarget/AddEdit';

  static const END_POINT_BT_CUSTOMER_COUNTRY = 'BTCustomer/Country';

  static const END_POINT_SIZED_LIST_FROM_PRODUCTID = "InquiryBlue/ProductSize";
  static const END_POINT_INQ_NO_TO_PRODUCT_SIZED_LIST =
      "InquiryBlue/InquiryProductSize";

  static const END_POINT_OFFICE_TODO_LIST = 'Todo/SearchByRole';

  static const END_POINT_SIZEDLIST_INS_UPDATE_API = 'Inquiry/';

  static const END_POINT_SIZEDLIST_MULTI_DELETE_API = 'Inquiry/';

  static const END_POINT_LOGOUT_COUNT = 'LogOutCount/Count';

  static const END_POINT_FOLLOWUP_IMG_LIST = 'FollowUp/';
  static const END_POINT_FOLLOWUP_IMG_LIST_FOR_ALMIGHTY =
      'FollowUpForAlmighty/';

  static const END_POINT_CITY_CODE_TO_CUSTOMER_LIST = 'Customer/';
  static const END_POINT_VK_COMPLAIN_LIST = 'ComplaintQuick/';
  static const END_POINT_VK_COMPLAIN_SAVE = 'ComplaintQuick/';
  static const END_POINT_VK_COMPLAIN_PK_ID_TO_DETAILS = 'ComplaintQuick/';
  static const END_POINT_VK_COMPLAIN_DELETE = 'ComplaintQuick/';
  static const END_POINT_VK_COMPLAIN_HISTORY = 'ComplaintQuick/';
  static const END_POINT_SB_HEADERIDTOLIST = "SalesBill/";

  static const END_POINT_ACURABATH_OMPLAINT_LIST_DETAILS = "ComplaintAcura";
  static const END_POINT_ACURABATH_OMPLAINT_SAVE__DETAILS = "ComplaintAcura";
  static const END_POINT_ACURABATH_COMPLAINT_VIDEO_LIST =
      "ComplaintAcura/VideoAttachmentslist";

  static const END_POINT_SO_SHIPMENT_LIST = 'SalesOrderShipmentDetails';
  static const END_POINT_QUO_SHIPMENT_DELETE =
      'QuotationShipmentDetails/Delete';
  static const END_POINT_QUO_SHIPMENT_SAVE = 'QuotationShipmentDetails/Save';
  static const END_POINT_QUO_SHIPMENT_LIST = 'QuotationShipmentDetails/list';

  static const END_POINT_SO_EXPORT_LIST = 'SalesOrderExport';

  static const END_POINT_QT_ORGANIZATION_DROP_DOWN_LIST =
      "OrganizationStructure/";

  static const END_POINT_SB_ALL_PRODUCT_DELETE = 'SalesBill/';
  static const END_POINT_FOLLOWUP_PKID_TO_DETAILS = 'GetFollowUpDetailByPkID';

  static const END_POINT_SO_EXPORT_SAVE = 'SalesOrderExport/';
  static const END_POINT_FIXED_LEDGER_LIST = 'Customer/FixedLedger';
  static const END_POINT_SALES_ORDER_APPROVAL_LIST = 'SOApproval/ListbyStatus';
  static const END_POINT_SALES_ORDER_APPROVAL_SAVE = 'SOApproval/Update';
  static const END_POINT_SALES_ORDER_APPROVAL_STATUS =
      'Inquiry/SOApproval/Search';
  static const END_POINT_PURCHASE_ORDER_APPROVAL_STATUS =
      'Inquiry/POApproval/Search';
  static const END_POINT_MULTIPLE_EXPENSE_APPROVAL_STATUS =
      'Inquiry/ExpenseApproval/Search';

  static const END_POINT_DASHBOARD_COUNT = 'Dashboard/CRMActivitySummary';

  static const END_POINT_QT_REVISED_SAVE = "Quatation/Revision";

  static const END_POINT_QT_PK_ID_TO_DETAILS = "Quatation/";

  static const END_POINT_SALES_ORDER_ADDRESS_DROPDOWN =
      'ShipmentAddress/FetchByMode';

  static const END_POINT_MUDRA_COMPLAINT_LIST = 'MudraComplaint/List';
  static const END_MAYANK_MUDRA_COMPLAINT_DELETE = 'MudraComplaint/Delete';
  static const END_MAYANK_MUDRA_PROJECT_LIST = 'ProductGroup/List';
  static const END_MAYANK_MUDRA_SERVICE_TAG_LIST = 'ServiceTag/ListByCustomer';
  static const END_MAYANK_MUDRA_ASSIGN_TO_LIST = 'ActiveEmployee/List';
  static const END_MAYANK_MUDRA_COMPLAINT_SAVE = 'MudraComplaint/AddUpdate';
  static const END_MAYANK_MUDRA_COMPLAINT_HISTORY_SAVE =
      'MudraVisit/ListByComplaintNo';
  static const END_POINT_MUDRA_ATTEND_VISIT_LIST = 'MudraVisit/List';
  static const END_MAYANK_MUDRA_ATTEND_VISIT_DELETE = 'MudraVisit/Delete';
  static const END_MAYANK_MUDRA_ATTEND_VISIT_SAVE = 'MudraVisit/AddUpdate';
  static const END_POINT_GET_SUB_DETAILS_INQ_QT_NO_LIST =
      'QuatationList/InquiryNo';
  static const END_POINT_PURCHASE_BILL_LIST = 'PurchaseBill/List';
  static const END_POINT_PURCHASE_ORDER_LIST = 'PurchaseOrder/List';
  static const END_POINT_BANK_NAME_DROP_DOWN = 'OrganizationBank/List';
  static const END_POINT_BANK_NAME_MODE = 'FinancialTransaction/PendingInvList';
  static const END_POINT_BANK_NAME_AMOUNT =
      'FinancialTransaction/PendingInvAmt';
  static const END_POINT_MAYANK_BANK_VOUCHER_LIST = 'FinancialTransaction/List';
  static const END_MAYANK_BANK_VOUCHER_DELETE = 'FinancialTransaction/Delete';
  static const END_POINT_BANK_VOUCHER_ADD_EDIT_DETAILS =
      "FinancialTransaction/AddUpdate";
  static const END_POINT_MAYANK_BANK_VOUCHER__DETAILS_LIST =
      'FinancialTransactionDetail/List';
  static const END_MAYANK_BANK_VOUCHER_DELETE_DETAILS =
      'FinancialTransactionDetail/Delete';
  static const END_MAYANK_BANK_VOUCHER_ADD_EDIT_DETAILS =
      'FinancialTransactionDetail/AddUpdate';
  static const END_MAYANK_BANK_VOUCHER_ADD_EDIT_DETAILS1 =
      'FinancialTransactionDetail/Array/AddUpdate';

  static const END_POINT_DASHBOARD_DAILY_ATTENDANCE_MODEL =
      'DailyAttendanceModeV2/';
  static const END_POINT_SHARVAYA_DAILY_ACTIVITY_LIST = 'SIDailyActivity/List';
  static const END_POINT_SHARVAYA_DAILY_ACTIVITY_DELETE =
      'SIDailyActivity/Delete';
  static const END_POINT_SHARVAYA_DAILY_ACTIVITY_SAVE =
      'SIDailyActivity/AddUpdate';
  static const END_POINT_MUDRA_QUICK_SUPPORT_LIST = 'MudraVisit/ListByStatus';
  static const END_POINT_CUSTOMER_HISTORY_LIST = 'FollowUp/ListbyCustomerID';

  static const END_POINT_QT_FINISH_LIST = "Finish/List";
  static const END_POINT_QT_THICKNESS_LIST = "Thickness/List";
  static const END_POINT_QT_SIZE_LIST = "Size/List";
  static const END_POINT_QT_GRADE_LIST = "Grade/List";
  static const END_POINT_QT_DESIGN_LIST = "Design/List";
  static const END_POINT_SoNO_TO_PRODUCT_LIST = 'SalesOrderDetail/List';
  static const END_POINT_COMMON_COMPANY_DETAILS_DESIGN_LIST =
      "Common/CompanyDetails";
  static const END_POINT_SBNO_TO_PRODUCT_LIST = "SalesBillDetail/List";
  static const END_POINT_CAMPAIGN_LIST_DESIGN_LIST = "Campaign/List";
  static const END_POINT_TO_DO_MODULE_SHARING_LIST = "ModuleSharing/List";
  static const END_POINT_MODULE_SHARING_FOR_EMPLOYEE_SHARING =
      'TokensForTodo/List';
  static const END_POINT_TO_DO_MODULE_SHARING_SAVE = "ModuleSharing/AddUpdate";
  static const END_POINT_MATERIAL_OUTWARD_DETAILS = 'Outward/List';
  static const END_POINT_MATERIAL_OUTWARD_DELETE = 'Outward/Delete';
  static const END_POINT_MATERIAL_OUTWARD_ADD_UPDATE = "Outward/AddUpdate";
  static const END_POINT_MATERIAL_OUTWARD_EXPORT_LIST = 'OutwardExport/List';
  static const END_POINT_MATERIAL_OUTWARD_EXPORT_SAVE =
      'OutwardExport/AddUpdate';
  static const END_POINT_MATERIAL_OUTWARD_GET_SO_NO = 'PendingSalesOrder/List';
  static const END_POINT_MATERIAL_OUTWARD_GET_DETAILS_SO_NO =
      'SalesBill/FetDetailByInqQuotSo';
  static const END_POINT_MATERIAL_OUTWARD_DETAILS_DELETE =
      'OutwardDetail/Delete';
  static const END_POINT_MATERIAL_OUTWARD_DETAILS_ADD_UPDATE =
      'OutwardDetail/AddUpdate';
  static const END_POINT_MATERIAL_OUTWARD_DETAILS_LIST = 'OutwardDetail/List';
  static const END_POINT_MATERIAL_OUTWARD_GET_DETAILS_O_NO_BY_FETCHTYPE =
      'PendingSalesOrderDetail/List';
  static const END_POINT_INVOICE_DOCUMENT_LIST =
      'ModuleAttachments/AttachmentsList';
  static const END_POINT_MODULE_ATTACHMENT_ITEM_WISE_DELETE =
      'ModuleDocuments/DeletebypkID';
  static const END_POINT_INVOICE_DOCUMENT_UPLOAD =
      'ModuleAttachments/UploadAttachments';
  static const END_POINT_INVOICE_DOCUMENT_DELETE =
      "ModuleDocuments/DeletebyKeyValue";
  static const END_PRODUCT_MASTER_GROUP_DETAILS = 'ProductGroup/List';
  static const END_PRODUCT_MASTER_DELETE = 'Product/Delete';
  static const END_PRODUCT_MASTER_ADD_UPDATE = 'Product/AddUpdate';
  static const END_POINT_MAINTENANCE_DETAILS_DELETE = 'Maintenance/Delete';
  static const END_POINT_MAINTENANCE_ADD_UPDATE = "Maintenance/AddUpdate";
  static const END_POINT_MAINTENANCE_CHECKLIST_DRP_LIST_DETAILS =
      "ChecklistHead/List";
  static const END_POINT_MASTER_MAINTENANCE_CHECKLIST_LIST_DETAILS =
      "Maintenance/ContactList";

  static const END_POINT_MAINTENANCE_FOOTER_DETAILS_LIST =
      'MaintenanceDetail/List';
  static const END_POINT_MAINTENANCE_DETAILS_DELETE_API =
      'MaintenanceDetail/Delete';
  static const END_POINT_MAINTENANCE_DETAILS_ADD_UPDATE =
      'MaintenanceDetail/AddUpdate';
  static const END_POINT_REPAIRING_LIST_DETAILS = "Repairing/List";
  static const END_POINT_REPAIRING_DELETE_API = 'Repairing/Delete';
  static const END_POINT_REPAIRING_ADD_UPDATE = 'Repairing/AddUpdate';
  static const END_POINT_REPAIRING_DETAILS_DELETE_API =
      'RepairingDetail/Delete';
  static const END_POINT_REPAIRING_DETAILS_ADD_UPDATE =
      'RepairingDetail/AddUpdate';
  static const END_POINT_REPAIRING_FOOTER_DETAILS_LIST = 'RepairingDetail/List';
  static const END_POINT_REPAIRING_LOG_LIST_DETAILS = "RepairingLog/List";
  static const END_POINT_MATERIAL_INWARD_LISTS = 'Inward/List';
  static const END_POINT_MATERIAL_INWARD_DELETE = 'Inward/Delete';
  static const END_POINT_MATERIAL_INWARD_ADD_UPDATE = "Inward/AddUpdate";
  static const END_POINT_MATERIAL_INWARD_DETAILS_LIST = "InwardDetail/List";
  static const END_POINT_MATERIAL_INWARD_DETAILS_DELETE = 'InwardDetail/Delete';
  static const END_POINT_MATERIAL_INWARD_DETAILS_ADD_UPDATE =
      'InwardDetail/AddUpdate';
  static const END_POINT_CUSTOMER_PAGINATION_Meet = 'Customer/Search';
  static const END_POINT_LOCATION_LIST_DETAILS = 'Location/List';
  static const END_POINT_MATERIAL_INWARD_GET_PO_NO =
      'Inward/OrdedNoFromCustomerID';
  static const END_POINT_MATERIAL_INWARD_GET_DETAILS_SO_NO =
      'Inward/FetDetailByOrdedNo';
  static const END_POINT_PO_DELETE = 'PurchaseOrder/Delete';
  static const END_POINT_PO_APPROVAL_LIST = "/POApproval/ListbyStatus";
  static const END_POINT_PO_APPROVAL_SAVE = '/POApproval/Update';
  static const END_POINT_PO_DRP_LIST = "PurchaseOrderList/ByCustomerID";
  static const END_POINT_SERVICE_REPORT_LIST = 'ServiceMaster/List';
  static const END_POINT_SERVICE_REPORT_DELETE = 'ServiceMaster/Delete';
  static const END_POINT_MACHINE_MASTER_LIST_DETAILS = 'MachineMaster/List';
  static const END_POINT_SERVICE_REPORT_ADD_UPDATE = "ServiceMaster/AddUpdate";
  static const END_POINT_SERVICE_REPORT_DETAILS_LIST =
      "ServiceMasterDetail/List";
  static const END_POINT_SERVICE_REPORT_DETAILS_DELETE =
      'ServiceMasterDetail/Delete';
  static const END_POINT_SERVICE_REPORT_DETAILS_ADD_UPDATE =
      'ServiceMasterDetail/AddUpdate';
  static const END_POINT_SHORT_INVOICE_LIST = 'ShortInvoice/List';
  static const END_POINT_SHORT_INVOICE_DELETE = 'ShortInvocie/delete';
  static const END_POINT_SHORT_INVOICE_SHIPMENT_LIST =
      'ShortInvoice/ShipmentList';
  static const END_POINT_SHORT_INVOICE_EXPORT_LIST = 'ShortInvocie/ExportList';
  static const END_POINT_SHORT_INVOICE_DETAILS_LIST = 'ShortInvocieDetail/List';
  static const END_POINT_SHORT_INVOICE_ADD_UPDATE = 'ShortInvoice/Save';
  static const END_POINT_SHORT_INVOICE_PRODUCT_SAVE = "ShortInvocie/Detail";
  static const END_POINT_SHORT_INVOICE_EXPORT_SAVE = "ShortInvocieExport/Save";
  static const END_POINT_SHORT_INVOICE_SHIPMENT_SAVE =
      "ShortInvoiceShipment/Save";
  static const END_POINT_SHORT_INVOICE_DETAILS_DELETE =
      'ShortInvoice/DetailDelete';
  static const END_POINT_SHORT_INVOICE_ASSEMBLY_LOAD_LIST_API =
      'ShortInvoice/AssemblyList';
  static const END_POINT_PURCHASE_BILL_DELETE = 'PurchaseBill/delete';
  static const END_POINT_PURCHASE_BILL_ADD_UPDATE = 'PurchaseBill/Save';
  static const END_POINT_PURCHASE_BILL_DETAILS_LIST = 'PurchaseDetail/List';
  static const END_POINT_PURCHASE_BILL_DETAILS_DELETE =
      'PurchaseBill/DetailDelete';
  static const END_POINT_PURCHASE_BILL_AC_API = "PurchaseDropdown/List";
  static const END_POINT_PURCHASE_BILL_TOD_API = "State/List";
  static const END_POINT_PURCHASE_BILL_DETAILS_SAVE = "PurchaseBill/Detail";
  static const END_POINT_PURCHASE_ORDER_ADD_UPDATE = '/PurchaseOrder/AddUpdate';
  static const END_POINT_PURCHASE_ORDER_DETAILS_LIST =
      'PurchaseOrderDetail/List';
  static const END_POINT_PURCHASE_ORDER_DETAILS_DELETE =
      'PurchaseOrderDetail/Delete';
  static const END_POINT_PURCHASE_ORDER_DETAILS_SAVE =
      "/PurchaseOrderDetail/AddUpdate";
  static const END_POINT_PO_SHIPMENT_LIST = 'PurchaseOrderShipmentDetails/List';
  static const END_POINT_PO_SHIPMENT_SAVE =
      "PurchaseOrderShipmentDetails/AddUpdate";
  static const END_POINT_PENDING_INDENT_LIST =
      "PurchaseOrder/PendingIndentDetailList";
  static const END_POINT_DRIVER_LIST = "PurchaseOrderDriver/List";
  static const END_POINT_TANKER_LIST = "PurchaseOrderTanker/List";
  static const END_POINT_LOCATION_LIST = "EmployeeTracking/List";
  static const END_POINT_LOCATION_LOG_LIST = "EmployeeTrackingLog/List";
  static const END_POINT_PAY_SLIP_LIST_API = 'Payslip/List';
  static const END_POINT_VISITOR_INFO_LIST = 'VisitorInfo/List';
  static const END_POINT_VISITOR_INFO_DELETE = 'VisitorInfo/Delete';
  static const END_POINT_VISITOR_INFO_ADD_UPDATE = 'VisitorInfo/AddUpdate';
  static const END_POINT_SO_CUSTOMER_NEAR_BY_PIN_CODE_COMMON =
      "SOCustomer/NearByPincode";

  static const END_POINT_MATERIAL_INDENT_LIST = 'MaterialIndent/List';
  static const END_POINT_MATERIAL_INDENT_APPROVAL_UPDATE =
      'MaterialIndent/Approval_UPD';
  static const END_POINT_MULTI_EXPENSE_LIST = 'MulExpense/ListForProinst';
  static const END_POINT_MULTI_EXPENSE_DETAILS_LIST =
      'MulExpenseDetail/ListForProinst';
  static const END_POINT_MULTI_EXPENSE_DELETE = 'MulExpense/DeleteForProinst';
  static const END_POINT_MULTI_EXPENSE_ADD_UPDATE = 'MulExpense/SaveForProinst';
  static const END_POINT_MULTI_EXPENSE_DETAILS_DELETE =
      'MulExpenseDetail/DeleteForProinst';
  static const END_POINT_MULTI_EXPENSE_DETAILS_ADD_UPDATE =
      'MulExpenseDetail/SaveForProinst';
  static const END_POINT_MULTI_EXPENSE_MODE_LIST = 'drpExpenseMode/List';
  static const END_POINT_MULTI_EXPENSE_TYPE_LIST = 'drpExpenseDetail/List';
  static const END_POINT_DBCR_NOTES_LIST = 'DBCRNote/List';
  static const END_POINT_JOURNAL_VOUCHER_LIST = 'JournalVoucher/List';
  static const END_POINT_ASSET_ISSUE_LIST = 'AssetIssue/List';
  static const END_POINT_PETTY_CASH_LIST = 'PettyCash/List';
  static const END_POINT_ASSET_RETURN_LIST = 'AssetReturn/List';
  static const END_POINT_OFFICE_REF_TYPE_FROM_CUSTOMER_ID_LIST =
      'OfficeRefTypeFromCustomerID/ListForProinst';
  static const END_POINT_OFFICE_EXPENSE_APPROVAL_LIST =
      'OfficeExpenseApproval/ListForProinst';
  static const END_POINT_OFFICE_EXPENSE_APPROVAL_UPDATE =
      'OfficeExpenseApproval/SaveForProinst';
  static const END_POINT_QUICK_FOLLOWUP_REPORT_LIST =
      'QuickFollowupReport/List';

  static const END_POINT_EXPENSE_TRACKING_LIST = 'ExpenseTracking/List';
  static const END_POINT_EXPENSE_TRACKING_SAVE = 'ExpenseTracking/Save';

  final http.Client httpClient;

  ApiClient({this.httpClient});

  Future<dynamic> apiCallPost(
    String url,
    Map<String, dynamic> requestJsonMap, {
    bool showSuccessDialog = false,
  }) async {
    var responseJson;

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final baseUrl = SharedPrefHelper.instance.getBaseURL();
    final uri = Uri.parse('$baseUrl$url');

    debugPrint(
        "Api request url : $uri\nHeaders - $headers\nParams : $requestJsonMap");

    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        throw FetchDataException('No Internet Connection');
      }

      final response = await httpClient
          .post(
            uri,
            headers: headers,
            body: requestJsonMap == null ? null : jsonEncode(requestJsonMap),
          )
          .timeout(const Duration(seconds: 30));

      responseJson = await _response(
        response,
        showSuccessDialog: showSuccessDialog,
        requestandurl:
            "BaseURL (POST):\n$uri\nHeaders:\n$headers\nParams:\n$requestJsonMap",
      );
    } on TimeoutException {
      throw FetchDataException('Low Internet Connection');
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      throw FetchDataException(e.toString());
    }

    return responseJson;
  }

  Future<dynamic> apiCallPostforMultipleJSONArray(
    String url,
    dynamic jsontemparray, {
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    var BASE_URL = "";
    BASE_URL = SharedPrefHelper.instance.getBaseURL();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    debugPrint("Headers - $headers");
    String asd = json.encode(jsontemparray);

    debugPrint(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $asd" +
            json.encode(jsontemparray));
    try {
      final response = await httpClient
          .post(Uri.parse("$BASE_URL$url"),
              headers: headers,
              body: (jsontemparray == null) ? null : json.encode(jsontemparray))
          .timeout(const Duration(seconds: 60));
      String Reqwithurl =
          " \nBaseURL (POST JSON Array):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi request params :\n $asd";
      //,requestandurl:Reqwithurl
      responseJson = await _response(response,
          showSuccessDialog: showSuccessDialog, requestandurl: Reqwithurl);
    } on TimeoutException {
      String Reqwithurl =
          " \nBaseURL (POST):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi request params :\n $asd";
      return errorLogMailMethod("TimeoutException !", Reqwithurl,
          responseJson["ExceptionType"], responseJson["ExceptionMessage"]);
    }
    return responseJson;
  }

  ///POST api call with multipart and multiple image

  Future<dynamic> apiCallPostMultipart(
      String url, Map<String, dynamic> requestJsonMap,
      {List<File> imageFilesToUpload,
      String imageFieldKey = "image",
      bool showSuccessDialog: false}) async {
    var responseJson;

    var BASE_URL = "";
    BASE_URL = SharedPrefHelper.instance.getBaseURL();
    debugPrint("$BASE_URL$url\n$requestJsonMap");
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (!imageFilesToUpload[0].existsSync()) {
      debugPrint("file not exist");
    }

    debugPrint(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    log("Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    final request = http.MultipartRequest("POST", Uri.parse("$BASE_URL$url"));
    if (requestJsonMap != null) {
      request.fields.addAll(requestJsonMap);
    }
    request.headers.addAll(headers);

    if (imageFilesToUpload != null) {
      imageFilesToUpload.forEach((element) async {
        if (element != null) {
          var pic =
              await http.MultipartFile.fromPath(imageFieldKey, element.path);
          request.files.add(pic);
        }
      });
    }
    //upload kro?

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse)
          .timeout(const Duration(seconds: 120));

      String Reqwithurl =
          " \nBaseURL (POST FormData Request):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi Form request params :\n $requestJsonMap";
      //,requestandurl:Reqwithurl

      responseJson = await _responseLogin(response,
          showSuccessDialog: showSuccessDialog, requestandurl: Reqwithurl);
    } on TimeoutException {
      String Reqwithurl =
          " \nBaseURL (POST):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi request params :\n $requestJsonMap";
      return errorLogMailMethod("TimeoutException !", Reqwithurl,
          responseJson["ExceptionType"], responseJson["ExceptionMessage"]);
    }
    return responseJson;
  }

  Future<dynamic> apiCallPostMultipartBase64(
      String url, Map<String, dynamic> requestJsonMap,
      {
      /* String baseUrl = BASE_URL,*/
      String imageFieldKey = "image",
      bool showSuccessDialog: false}) async {
    var responseJson;

    var BASE_URL = "";
    BASE_URL = SharedPrefHelper.instance.getBaseURL();
    debugPrint("$BASE_URL$url\n$requestJsonMap");
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    debugPrint(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    final request = http.MultipartRequest("POST", Uri.parse("$BASE_URL$url"));
    if (requestJsonMap != null) {
      request.fields.addAll(requestJsonMap);
    }
    request.headers.addAll(headers);

    //upload kro?

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse)
          .timeout(const Duration(seconds: 120));

      String Reqwithurl =
          " \nBaseURL (POST FormData Request):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi Form request params :\n $requestJsonMap";
      //,requestandurl:Reqwithurl
      responseJson = await _responseLogin(response,
          showSuccessDialog: showSuccessDialog, requestandurl: Reqwithurl);
    } /*on SocketException {
      throw FetchDataException('No Internet Connection');
    } */
    on TimeoutException {
      //throw FetchDataException('Request time out');
      String Reqwithurl =
          " \nBaseURL (POST):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi request params :\n $requestJsonMap";
      return errorLogMailMethod("TimeoutException !", Reqwithurl,
          responseJson["ExceptionType"], responseJson["ExceptionMessage"]);
    }
    return responseJson;
  }

  ///POST api call pagination
  Future<dynamic> apiCallPostPagination(
    String url,
    String query,
    Map<String, dynamic> requestJsonMap, {
    /*String baseUrl = BASE_URL,*/
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    var geturl;
    var BASE_URL = "";
    BASE_URL = SharedPrefHelper.instance.getBaseURL();
    if (query.isNotEmpty) {
      geturl = '$BASE_URL$url/$query-10';
    } else {
      geturl = '$BASE_URL$url/0-10';
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    debugPrint("Headers - $headers");
    debugPrint(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .post(Uri.parse("$geturl"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));
      String Reqwithurl =
          " \nBaseURL (POST):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi request params :\n $requestJsonMap";
      //,requestandurl:Reqwithurl
      responseJson = await _response(response,
          showSuccessDialog: showSuccessDialog, requestandurl: Reqwithurl);
    } /*on SocketException {
      throw FetchDataException('No Internet Connection');
    } */
    on TimeoutException {
      //throw FetchDataException('Request time out');
      String Reqwithurl =
          " \nBaseURL (POST):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi request params :\n $requestJsonMap";
      return errorLogMailMethod("TimeoutException !", Reqwithurl,
          responseJson["ExceptionType"], responseJson["ExceptionMessage"]);
    }
    return responseJson;
  }

  ///handling whole response
  ///decrypts response and checks for all status code error
  ///returns "data" object response if status is success

  Future<dynamic> _response(http.Response response,
      {bool showSuccessDialog = false, String requestandurl = ""}) async {
    // log("Api response\n${response.body}");
    debugPrint("Api response\n${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        final data = responseJson["Data"];
        final message =
            responseJson["Message"] == null ? "" : responseJson["Message"];

        if (responseJson["Status"] == 1) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return data;
        }
        if (responseJson["Status"] == 2) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return data;
        }
        if (responseJson["Status"] == 3) {
          await showCommonDialogWithSingleOption(Globals.context, message,
              positiveButtonTitle: "OK");

          return data;
        }

        if (data is Map<String, dynamic>) {
          throw ErrorResponseException(data, message);
        }
        throw ErrorResponseException(null, message);
      case 400:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        // throw BadRequestException(message.toString());

        return errorLogMailMethod("BadRequestException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 401:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        //throw UnauthorisedException(message.toString());
        return errorLogMailMethod("UnauthorisedException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 403:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        // throw UnauthorisedException(message.toString());
        return errorLogMailMethod("UnauthorisedException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 404:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        // throw NotFoundException(message.toString());
        return errorLogMailMethod("NotFoundException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 500:
        var responseJson = json.decode(response.body);
        final message = responseJson["Message"];
        //  throw ServerErrorException(message.toString());
        return errorLogMailMethod("ServerErrorException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);
      default:
        var responseJson = json.decode(response.body);

        // throw FetchDataException('Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
        return errorLogMailMethod(
            "Error occurred while Communication with Server !",
            requestandurl,
            responseJson["ExceptionType"],
            responseJson["ExceptionMessage"]);
    }
  }

  Future<dynamic> _responseLogin(http.Response response,
      {bool showSuccessDialog = false, String requestandurl = ""}) async {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);

        return responseJson;

      case 400:
        var responseJson = json.decode(response.body);
        return errorLogMailMethod("BadRequestException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 401:
        var responseJson = json.decode(response.body);
        return errorLogMailMethod("UnauthorisedException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 403:
        var responseJson = json.decode(response.body);
        return errorLogMailMethod("UnauthorisedException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 404:
        var responseJson = json.decode(response.body);
        return errorLogMailMethod("NotFoundException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 500:
        var responseJson = json.decode(response.body);
        return errorLogMailMethod("ServerErrorException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      default:
        var responseJson = json.decode(response.body);
        return errorLogMailMethod(
            "Error occurred while Communication with Server !",
            requestandurl,
            responseJson["ExceptionType"],
            responseJson["ExceptionMessage"]);

      /* throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');*/
    }
  }

  Future<dynamic> api_call_fcm_notification(
    String url,
    Map<String, dynamic> requestJsonMap, {
    String baseUrl = "https://fcm.googleapis.com",
    bool showSuccessDialog = false,
    //dynamic jsontemparray,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization":
          "key =AAAA6_2q1Os:APA91bEmKXQUpXDgMIvRlTJSnWe6eesYX3qmmHFL5d9D74NN_t5UetJD0TH8Ft58p6vqqLJB-VMMPlbt4ZI7FiAR_QMMhAGjLhowt913GfB027K4vOsgntD9RztvGK0yv138bdoNTZaL",
    };
    debugPrint("Headers - $headers");
    //String asd = json.encode(jsontemparray);
    debugPrint(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap" /*+ "JSON Array $asd"*/);
    try {
      final response = await httpClient
          .post(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson = await _responseGoogle(response);
      //await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  Future<dynamic> api_call_fcm_notification_new(
    String url,
    Map<String, dynamic> requestJsonMap, {
    String baseUrl = "https://fcm.googleapis.com",
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    final String serverKey = await getAccessToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    debugPrint("Headers - $headers");
    //String asd = json.encode(jsontemparray);
    debugPrint(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .post(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson = await _responseGoogle(response);
      //await _response(response, showSuccessDialog: showSuccessDialog);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "e-office-desk-flutter",
      "private_key_id": "dee49b88aa4fda701ba25636836d5cb4a6bf7fd8",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCkch6ADZ5bnHGF\nxerUqS4SSo7O79XBztHqJv89POOS3ZZFJallYVjN/2coiyj7CUGH7btoyTijRoCn\nz+X2sEf0kK9gdbq7mQ0tM6ka0nr7uYZIYpLLDJfLtvzPIaKwGUIvjQ/Jmd8kKuau\no7iziv0TH2nwtuZKslued7nanisd343zNnNS22nXnKS/QR/blSesOp5ohPYegufk\nJlIQByXjF+TnRQNbOD3erERIG6U1BBm6ybZdWZCum5q9+nVr2TxaLphOTeBaVsac\n2s5cvSinw47bfpRZ0aVGAatK0/lRBstmlXD/p7D/Uy+8kHivB2EtBMugPT1WBUoE\n+iXGqjk/AgMBAAECggEAH45GjAwQ90NuBV2VUnmkfZ4RCWS8gBRP877H+9hTUzty\nOpKfjvS/Nchs4zrRAlskWBEmhVUXqT0+MvWSC2SIakXZYYk17AnSnXnsWVlKgEN5\noSpJQO2Js23J1XV+4ov2R2mqPeVpDGevHJQOPWXOanz8t1RhnLPdIOuYnnr7ix+s\nJn/FfuItz8tulpfxhOXX6U4hguJmZRTM8VWNx0OXm01JNdrRc01kE94XRIY2sclU\nEWkq0nmRbR0lY5+PY9heuuxgz7dfUyyhk5nxR/wNGsE9WRIMAIk0UtWDhq8kpHge\nCkgUuGKmlvpwcKAwvrMZa//KXkSUxa+SfQKT7KI4AQKBgQDXhCCol60o7zZUFt3G\nCB5X3H8YlfEmAqN9olruJ/HdSvV3Mj83qn3u3+UYUOFdHNhGOMk/N73i0NifhwX2\nUNEFPGCTRqfbQFZw2j6BkgeRM/70WviUHZLKHsh6RO+bjqtGVELupr0l1/ZEpkMu\n9HylK2WQkQ6RT6nbkzN3mzuIIQKBgQDDVhbZvaFK9t40mzolx0NqiUIkauzdos9q\nIdM5oWDecEytevdQ8JaoNhpS/xiBlJaJWvlgb8c+V0bWuHuZvmAaD+Y1UBzre3fF\nJRAmUe3VhbcVu3zHL2/wFCHv9eDg8VMAIyJTb+QM6XWFPlmi/jWPusHzceQGXEDi\nIy3ofGgVXwKBgQCTgeO4gNgMBG5y75OrTzM1f72d3kLHeVbdTppeFwj8JaoMg1+x\nggffz27GTdVyHaQJrCRSGJzm+XrK9WenR3lI1CJlqx6IemivpTDTDlgPkj8WkI1D\nE1q87ITa6wP0vJmN8W4+WfFsTXxJUGL7aGtHwYQqhp4p5xSjLQU1ABKnAQKBgEoZ\ndU+iNPZ4EbEJFZTRM0zNxs6D1Vj6cw5CyJr7EgEvvpasp/cHXU9wPqovZP96+2Qd\no64mmQGYICJCF3kqE9CvKVgeDOpziuq5dZfjyoIOWHahCeORpjf/myQpNOaABUlv\nCo12S59uTIuALIa9QlpEsWCFWsfi5SYjzD1+PAmnAoGBAL/na3HFfrrp2vvsRo+w\nCe0sH3Kfiugut41wtbl1cog370HCaRVeHucSmMxg97mNPScN7/KFBwpvkQqq0g9G\nJCKwK8EfWlM/dDFfCIJcXgQcj3+1cnvHzyiJ5EdUadDKsCnNk4chk9Xn4NKKB/94\ni2eaHQ6MAdCxLFeSjL+SIjwe\n-----END PRIVATE KEY-----\n",
      "client_email": "e-office-desk-flutter@appspot.gserviceaccount.com",
      "client_id": "100799278322772767315",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/e-office-desk-flutter%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();
    return credentials.accessToken.data;
  }

  Future<dynamic> _responseGoogle(http.Response response,
      {bool showSuccessDialog = false}) async {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        final data = responseJson; //["results"];

        return data;

      case 400:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 400"; //responseJson["Message"];
        throw BadRequestException(message.toString());
      case 401:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 401"; //responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 403:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 403"; //responseJson["Message"];
        throw UnauthorisedException(message.toString());
      case 404:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 404"; //responseJson["Message"];
        throw NotFoundException(message.toString());
      case 500:
        var responseJson = json.decode(response.body);
        final message =
            "RetriveDataFail With Status Code 500"; //responseJson["Message"];
        throw ServerErrorException(message.toString());
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> getUrlLocation(String url) async {
    final client = HttpClient();
    var uri = Uri.parse(url);
    var request = await client.getUrl(uri);
    request.followRedirects = false;
    var response = await request.close();

    while (response.isRedirect) {
      response.drain();
      final location = response.headers.value(HttpHeaders.locationHeader);
      if (location != null) {
        uri = uri.resolve(location);
        request = await client.getUrl(uri);
        request.followRedirects = false;
        response = await request.close();
        return response.statusCode;
      }
    }
  }

  Future<dynamic> MasterBaseURLAPI(
    String url,
    Map<String, dynamic> requestJsonMap, {
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    debugPrint("Headers - $headers");
    var BASE_URL = "";
    BASE_URL = "http://baseurl.sharvayainfotech.in/";
    log("Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    debugPrint(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");
    try {
      final response = await httpClient
          .post(Uri.parse("$BASE_URL$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));
      String Reqwithurl =
          " \nBaseURL (POST):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi request params :\n $requestJsonMap";
      responseJson = await _response(response,
          showSuccessDialog: showSuccessDialog, requestandurl: Reqwithurl);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      String Reqwithurl =
          " \nBaseURL (POST):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi request params :\n $requestJsonMap";
      return errorLogMailMethod("TimeoutException !", Reqwithurl,
          responseJson["ExceptionType"], responseJson["ExceptionMessage"]);
    }
    return responseJson;
  }

  Future<dynamic> apiCallPostForMassage(
    String url,
    Map<String, dynamic> requestJsonMap, {
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    var BASE_URL = "";
    BASE_URL = SharedPrefHelper.instance.getBaseURL();

    debugPrint("Headers - $headers");
    debugPrint(
        "Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    log("Api request url : $BASE_URL$url\nHeaders - $headers\nApi request params : $requestJsonMap");

    try {
      final response = await httpClient
          .post(Uri.parse("$BASE_URL$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));
      String Reqwithurl =
          " \nBaseURL (POST For Message Only ):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi request params :\n $requestJsonMap";

      responseJson = await _responseForAPIMessage(response,
          showSuccessDialog: showSuccessDialog, requestandurl: Reqwithurl);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      String Reqwithurl =
          " \nBaseURL (POST):\n $BASE_URL$url\n\nHeaders - $headers\n\nApi request params :\n $requestJsonMap";
      return errorLogMailMethod("TimeoutException !", Reqwithurl,
          responseJson["ExceptionType"], responseJson["ExceptionMessage"]);
    }
    return responseJson;
  }

  Future<dynamic> _responseForAPIMessage(http.Response response,
      {bool showSuccessDialog = false, String requestandurl}) async {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        final data = responseJson["Data"];
        final message =
            responseJson["Message"] == null ? "" : responseJson["Message"];

        if (responseJson["Status"] == 1) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return responseJson;
        }
        if (responseJson["Status"] == 2) {
          if (showSuccessDialog) {
            await showCommonDialogWithSingleOption(Globals.context, message,
                positiveButtonTitle: "OK");
          }

          return data;
        }
        if (responseJson["Status"] == 3) {
          await showCommonDialogWithSingleOption(Globals.context, message,
              positiveButtonTitle: "OK");

          return data;
        }

        if (data is Map<String, dynamic>) {
          throw ErrorResponseException(data, message);
        }
        throw ErrorResponseException(null, message);
      case 400:
        var responseJson = json.decode(response.body);
        return errorLogMailMethod("BadRequestException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 401:
        var responseJson = json.decode(response.body);
        return errorLogMailMethod("UnauthorisedException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 403:
        var responseJson = json.decode(response.body);
        return errorLogMailMethod("UnauthorisedException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 404:
        var responseJson = json.decode(response.body);
        return errorLogMailMethod("NotFoundException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      case 500:
        var responseJson = json.decode(response.body);
        return errorLogMailMethod("ServerErrorException !", requestandurl,
            responseJson["ExceptionType"], responseJson["ExceptionMessage"]);

      default:
        var responseJson = json.decode(response.body);

        return errorLogMailMethod(
            "Error occurred while Communication with Server !",
            requestandurl,
            responseJson["ExceptionType"],
            responseJson["ExceptionMessage"]);
    }
  }

  errorLogMailMethod(String label, String baseurlrequest, String exceptionType,
      String exceptiondetails) {
    String userFriendlyMessage = "Something went wrong. Please try again.";
    if (label.contains("BadRequestException")) {
      userFriendlyMessage = "Something went wrong. Please try again.";
    } else if (label.contains("UnauthorisedException")) {
      userFriendlyMessage = "Your session has expired. Please log in again.";
    } else if (label.contains("NotFoundException")) {
      userFriendlyMessage = "No data found.";
    } else if (label.contains("ServerErrorException")) {
      userFriendlyMessage =
          "We're unable to connect to the server right now. Please try again later.";
    } else if (label.contains("TimeoutException")) {
      userFriendlyMessage =
          "The request took too long. Please check your internet connection and try again.";
    }

    return showUserFriendlyErrorDialog(
      Globals.context,
      userFriendlyMessage,
      positiveButtonTitle: "OK",
      technicalDetails: "${label}\n${exceptiondetails?.toString() ?? ''}",
    );
  }

  ///ApiCallPostForHttp

  Future<dynamic> apiCallPostForHttp(
    String url,
    Map<String, dynamic> requestJsonMap, {
    String baseUrl = "http://whatsapp.servermsg.com/",
    bool showSuccessDialog = false,
  }) async {
    var responseJson;
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    debugPrint("Headers - $headers");
    debugPrint(
        "Api request url : $baseUrl$url\nHeaders - $headers\nApi request params : $requestJsonMap" /*+ "JSON Array $asd"*/);
    try {
      final response = await httpClient
          .post(Uri.parse("$baseUrl$url"),
              headers: headers,
              body:
                  (requestJsonMap == null) ? null : json.encode(requestJsonMap))
          .timeout(const Duration(seconds: 60));

      responseJson = await _responseGoogle(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request time out');
    }
    return responseJson;
  }

  Future<dynamic> apiCallPostWithFile(
    String url,
    Map<String, dynamic> requestJsonMap, {
    bool showSuccessDialog = false,
    File file,
    File file1,
  }) async {
    var responseJson;

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };

    final BASE_URL = SharedPrefHelper.instance.getBaseURL();

    try {
      final uri = Uri.parse("$BASE_URL$url");

      debugPrint("🚀 API CALL STARTED");
      debugPrint("🌐 URL: $BASE_URL$url");
      debugPrint("🧾 Headers: $headers");
      debugPrint("📦 Fields: $requestJsonMap");
      debugPrint("🖼 VisitorImage: ${file?.path}");
      debugPrint("📄 VisitorDocument: ${file1?.path}");

      final request = http.MultipartRequest('POST', uri);

      // 🔹 Add request fields
      request.fields.addAll(
        requestJsonMap.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      // 🔹 Visitor Image
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'VisitorImages', // ✅ API key
            file.path,
          ),
        );
        debugPrint("✅ VisitorImage attached");
      }

      // 🔹 Visitor Document
      if (file1 != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'VisitorDocument', // ✅ API key
            file1.path,
          ),
        );
        debugPrint("✅ VisitorDocument attached");
      }

      request.headers.addAll(headers);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📥 STATUS CODE: ${response.statusCode}");
      debugPrint("📥 RESPONSE BODY: ${response.body}");

      responseJson = await _response(
        response,
        showSuccessDialog: showSuccessDialog,
        requestandurl:
            "POST $BASE_URL$url\nHeaders: $headers\nBody: $requestJsonMap",
      );
    } on TimeoutException {
      throw FetchDataException('Request Timed Out');
    }

    return responseJson;
  }

  Future<dynamic> apiCallPostForExpenseFormData(
      String url, List<MultipleExpenseTable> request,
      {bool showSuccessDialog = false}) async {
    var BASE_URL = SharedPrefHelper.instance.getBaseURL();
    var responseJson;

    try {
      var uri = Uri.parse("$BASE_URL$url");
      var multipartRequest = http.MultipartRequest('POST', uri);

      // Loop through each expense row
      for (int i = 0; i < request.length; i++) {
        final item = request[i].toJson();
        item.forEach((key, value) {
          if (key != "Voucher" && value != null) {
            multipartRequest.fields.addAll({key: value.toString()});
          }
        });

        File file = request[i].Voucher;
        if (file != null && file.existsSync()) {
          multipartRequest.files.add(
            await http.MultipartFile.fromPath("Voucher", file.path),
          );
        }
      }
      var streamedResponse = await multipartRequest.send().timeout(
            const Duration(seconds: 60),
          );
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint(
          "FormData POST URL: $BASE_URL$url\nFields: ${multipartRequest.fields}\nFiles: ${multipartRequest.files.map((f) => f.filename).toList()}");

      // Parse response
      responseJson = await _response(
        response,
        showSuccessDialog: showSuccessDialog,
        requestandurl:
            "FormData POST URL: $BASE_URL$url\nFields: ${multipartRequest.fields}",
      );
    } on TimeoutException {
      return errorLogMailMethod(
          "TimeoutException !", "$BASE_URL$url", "", "Request timed out");
    } catch (error, stacktrace) {
      debugPrint(stacktrace.toString());
      return {"error": error.toString()};
    }

    return responseJson;
  }
}

