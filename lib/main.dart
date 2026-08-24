import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Material_Inward/Material_Inward/Material_Inward_Detail_Screen/test_add_edit_inward.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Material_Inward/Material_Inward/Material_Inward_Detail_Screen/test_list_inward.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Material_Inward/Material_Inward/Material_Inward_Header_Screen/Material_Inward_Header_Add_Edit_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Material_Inward/Material_Inward/Material_Inward_Header_Screen/Material_Inward_Header_List_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_Order_screens/PO_generate_via_indent/pending_po_generate_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_Order_screens/purchase_order_list_screen/po_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_order_approval/purchase_order_approval_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Service_Report/Service_Report_Details/service_report_details_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Service_Report/Service_Report_Header/Service_Report_Header_Add_Update.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Service_Report/Service_Report_Header/Service_Report_Header_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Visitor_Info_Screens/visitor_info_add_update_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Visitor_Info_Screens/visitor_info_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/asset_screen/asset_issue_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/asset_screen/asset_return_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/attendance/employee_attendance_list_general.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/general_followup/general_followup_list_for_almighty_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/manage_accounts/credit_notes_screens/credit_notes_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/manage_accounts/debit_notes_screens/debit_notes_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/manage_accounts/journal_coucher_screen/journal_coucher_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/manage_accounts/petty_cash_screen/petty_cash_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_indent_approval_screen/material_indent_approval_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/multiple_expense/me_approval/me_approval_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/multiple_expense/me_detail/me_details_add_update.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/multiple_expense/me_detail/me_details_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/multiple_expense/me_header/me_header_add_update.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/multiple_expense/me_header/me_header_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/other_screens/dropdownscreen.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_add_edit/hpl_addtional_charges/hpl_quotation_summary_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_add_edit/hpl_products/hpl_old_quotation_product_add_edit_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_add_edit/hpl_products/hpl_old_quotation_product_list_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_add_edit/hpl_qt_assembly/hpl_qt_assembly_add_edit_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_add_edit/hpl_qt_assembly/hpl_qt_assembly_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_add_edit/hpl_quotation_add_edit_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_add_edit/hpl_quotation_general_customer_search_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_add_edit/hpl_specification/hpl_specification_add_edit_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_add_edit/hpl_specification/hpl_specification_list_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_quotation_list_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Hpl_Client/Hpl_quotation_Screen/hpl_search_quotation_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/Mudra_Attend_Visit_Module/mudra_Attend_visit_Add_Edit_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/Mudra_Attend_Visit_Module/mudra_Attend_visit_list_screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/Mudra_Complaint_Module/Mudra_Complaint_Add_Edit_Screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/Mudra_Complaint_Module/Mudra_Complaint_History_List.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/Mudra_Complaint_Module/Mudra_Complaint_List_Screen.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Ui_Screens/Support_Module/quick_support_screen/quick_support_list/quick_support_list_screen.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/add_edit/acurabath_qt_assembly/acurabath_qt_assambly_add_edit_screen.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/add_edit/acurabath_qt_assembly/acurabath_qt_assambly_list_screen.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/add_edit/acurabath_qt_general_cust_search.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/add_edit/acurabath_qt_other_charges/acurabath_qt_other_charges.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/add_edit/acurabath_qt_specification/acurabath_specification_add_edit_screen.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/add_edit/acurabath_qt_specification/acurabath_specification_list_screen.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/add_edit/acurabth_qt_add_edit_screen.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/add_edit/acurabth_qt_products_crud/acurabath_qt_product_add_edit_screen.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/add_edit/acurabth_qt_products_crud/acurabath_qt_product_list.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/list/acurabath_qt_list_screen.dart';
import 'package:soleoserp/Clients/Acurabath/Quotation/list/acurabath_qt_search_screen.dart';
import 'package:soleoserp/Clients/BlueTone/Customer/blue_tone_customer_add_edit.dart';
import 'package:soleoserp/Clients/BlueTone/Customer/bt_country_list_screen.dart';
import 'package:soleoserp/Clients/BlueTone/Inquiry/AddEdit/bluetone_inquiry_add_edit.dart';
import 'package:soleoserp/Clients/BlueTone/Inquiry/Product/bluetone_inquiry_product_list.dart';
import 'package:soleoserp/Clients/BlueTone/Inquiry/Product/product_price_list_screen.dart';
import 'package:soleoserp/Clients/BlueTone/followup_notification_details/followup_notification_details_screen.dart';
import 'package:soleoserp/repositories/api_client.dart';
import 'package:soleoserp/ui/res/localizations/app_localizations.dart';
import 'package:soleoserp/ui/res/style_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/bank_voucher/add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/bank_voucher/list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/cash_voucher/add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/cash_voucher/list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/customer/add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/customer/list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/purchase_bill/add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/purchase_bill/list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/purchase_bill/other_charges/add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/purchase_bill/product_details/purchase_details_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/purchase_bill/product_details/purchase_details_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/sales_bill/add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/sales_bill/list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/sales_bill/other_charges/add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/sales_bill/product_details/add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Dealer/sales_bill/product_details/list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Intermet_Speed_Test_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ACCURABATH/accurabath_complaint/Followup_History/complaint_followup_history.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ACCURABATH/accurabath_complaint/Followup_dialog/complaint_to_followup.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ACCURABATH/accurabath_complaint/accurabath_complaint_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ACCURABATH/accurabath_complaint/accurabath_complaint_listing_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Attend_Visit/Attend_Visit_Add_Edit/attend_visit_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Attend_Visit/Attend_Visit_List/attend_visit_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Attend_Visit/Attend_Visit_List/attend_visit_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Complaint/complaint_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Complaint/complaint_pagination_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Complaint/complaint_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Complaint/digital_signature.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Complaint/search_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/country_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/customer_add_edit.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/distict_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_city_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_country_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_state_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_taluka_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerList/Customer_history_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerList/customer_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerList/search_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Daily_Activity_For_Sharvaya/Daily_Activity_For_Sharvaya_Add_Update.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Daily_Activity_For_Sharvaya/Daily_Activity_For_Sharvaya_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_add_edit/greenEdge_addtional_charges/greenEdge_quotation_summary_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_add_edit/greenEdge_products/greenEdge_old_quotation_product_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_add_edit/greenEdge_products/greenEdge_old_quotation_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_add_edit/greenEdge_qt_assembly/greenEdge_qt_assembly_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_add_edit/greenEdge_qt_assembly/greenEdge_qt_assembly_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_add_edit/greenEdge_quotation_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_add_edit/greenEdge_quotation_general_customer_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_add_edit/greenEdge_specification/greenEdge_specification_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_add_edit/greenEdge_specification/greenEdge_specification_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/greenEdge_quotation_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/GreenEdge_quotation/search_greenEdge_quotation_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Installation/installation_add.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Installation/installation_city_search.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Installation/installation_country_search.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Installation/installation_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Installation/installation_search_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Installation/installation_state_search.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Installation/search_installation.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/OfficeTODO/activity_summary.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/OfficeTODO/office_Followup/office_followup_add_edit.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/OfficeTODO/office_to_do.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/OfficeTODO/office_to_do_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/OfficeTODO/task_category_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/OfficeTODO/to_do_employee_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_Order_screens/addtional_charges/po_summary_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_Order_screens/products/po_product_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_Order_screens/products/po_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_Order_screens/purchase_order_list_screen/Po_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_bill_screens/purchase_bill_add_edit/purchase_bill_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_bill_screens/purchase_bill_add_edit/purchase_bill_db_details/pb_add_edit_product_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_bill_screens/purchase_bill_add_edit/purchase_bill_db_details/pb_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_bill_screens/purchase_bill_add_edit/purchase_bill_db_details/purchase_bill_summary_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_bill_screens/purchase_bill_list_screen/purchase_bill_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Repairing/repairing_header_screen/repairing_details_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Repairing/repairing_header_screen/repairing_header_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Repairing/repairing_header_screen/repairing_header_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/to_do_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/to_do_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/to_do_serach_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/ToDo/to_do_work_log_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/attendance/employee_attandance_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/bank_voucher/bank_voucher_add_edit/bank_voucher_add_edit.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/bank_voucher/bank_voucher_list/bank_voucher_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/bank_voucher/bank_voucher_list/search_bank_voucher_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/bank_voucher1/BankVoucher_Add_Edit.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/bank_voucher1/BankVoucher_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/bank_voucher1/bank_details_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/bank_voucher1/bank_voucher_deials_add_edit_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/cash_voucher/cash_voucher_details_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/cash_voucher/cash_voucher_details_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/cash_voucher/cash_voucher_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/cash_voucher/cash_vouher_add_edit.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/daily_activity/daily_activity_add_edit/daily_activity_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/daily_activity/daily_activity_list/daily_activity_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/daily_activity/daily_activity_list/search_daily_activity_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/dash_board_widgets/toDo_sharvaya_add_edit.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/dash_board_widgets/toDo_sharvaya_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/dash_board_widgets/test_tag.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/dolphin_complaint_visit/dolphin_complaint_list/dolphin_complaint_visit_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/employee/employee_list/employee_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/employee/employee_list/employee_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/expense/expense_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/expense/expense_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/external_lead/FollowupDialog/external_lead_followup_dialog.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/external_lead/external_lead_add_edit/external_lead_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/external_lead/external_lead_list/external_lead_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/external_lead/external_lead_list/search_external_lead_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/final_checking/final_checking_add.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/final_checking/final_checking_item_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/final_checking/final_checking_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/final_checking/search_finalchecking.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/followup_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/followup_history_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/followup_pagination_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/search_followup_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/telecaller_followup_history_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/hema_auto_attend_visit/hema_attend_visit_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/hema_auto_attend_visit/hema_attend_visit_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/Followup_dialog/followup_inquiry_detail_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/add_inquiry_product_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/customer_search/customer_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_add_edit.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_fillter/FollowupFromInquiry.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_fillter/inquiry_filter_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_product_shortcut_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/inquiry_share_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/search_inquiry_product_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/search_inquiry_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/leave_request/leave_request_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/leave_request/leave_request_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/leave_request_approval/leave_approval_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/loan/loan_list/loan_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/loan/loan_list/loan_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/loan_approval/loan_approval_list/loan_approval_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/maintenance/maintenance_add_update/maintenance_add_update_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/maintenance/maintenance_add_update/maintenance_product_add_update.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/maintenance/maintenance_add_update/maintenance_product_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/maintenance/maintenance_list/maintenance_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/maintenance/maintenance_list/maintenance_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_outward_screen/mo_details_screens/details_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_outward_screen/mo_details_screens/details_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_outward_screen/mo_header_screen/header_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_outward_screen/mo_header_screen/header_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/missed_punch/missed_punch_list/missed_punch_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/missed_punch/missed_punch_list/missed_punch_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/missed_punch_approval/missed_punch_approval_list/missed_punch_approval_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/packing_checklist/packing_asambly_crud/packing_assambly_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/packing_checklist/packing_asambly_crud/packing_assambly_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/packing_checklist/packing_checklist_add.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/packing_checklist/packing_checklist_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/packing_checklist/region/country_list_for_packing.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/packing_checklist/search_packingchecklist_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/pay_slip_screen/pay_slip_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/product_master/product_master_add_update_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/product_master/product_master_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/production_activity/production_activity_add.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/production_activity/production_activity_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quick_followup/quick_followup_add_edit/quick_followup_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quick_followup/quick_followup_list/quick_followUp_report_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quick_followup/quick_followup_list/quick_followup_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quick_inquiry/quick_inquiry_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quick_inquiry/search_quick_inquiry_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/addtional_charges/quotation_summary_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/products/old_quotation_product_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/products/old_quotation_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/qt_assembly/qt_assembly_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/qt_assembly/qt_assembly_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/quotation_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/quotation_general_customer_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/specification/specification_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/specification/specification_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/quotation_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quotation/search_quotation_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/reports_screen/customer_reports_screen/Main_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/reports_screen/inquiry_list_screen/Inquiry_reports_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/reports_screen/man_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salary_upad/salary_upad_list/salary_upad_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salary_upad/salary_upad_list/salary_upad_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sale_bill_list/sales_bill_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sale_bill_list/search_sales_bill_sceen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/module_no_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/sale_bill_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/sales_bill_db_details/sales_bill_summary_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/sales_bill_db_details/sb_add_edit_product_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/sales_bill_db_details/sb_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/sb_assembly/sb_assembly_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/sales_target/sales_target_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/sales_target/sales_target_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/addtional_charges/sales_order_summary_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/country_selection.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/products/so_product_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/products/so_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/sales_order_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/so_assembly/so_assembly_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/salesorder_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/search_salesorder_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/short_invoice/short_invoice_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/short_invoice/short_invoice_manan_design/addtional_charges/short_invoice_summary_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/short_invoice/short_invoice_manan_design/products/short_invoice_product_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/short_invoice/short_invoice_manan_design/products/short_invoice_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/short_invoice/short_invoice_manan_design/short_invoice_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller/FollowUpDialog/telecaller_followup_ADD_EDIT_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller/telecaller_add_edit/company_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller/telecaller_add_edit/telecaller_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller/telecaller_list/telecaller_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller/telecaller_list/telecaller_list_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller_new/telecaller_new_add.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/telecaller_new/telecaller_new_pagintion.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/vk_sound_complaint/vk_sound_add_edit/vk_sound_complain_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/vk_sound_complaint/vk_sound_list/vk_complaint_history_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/vk_sound_complaint/vk_sound_list/vk_sound_complain_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/daily_report_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/general_quick_attendance.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/location_screen/LocatioLogScreen.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/near_by_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/punch_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/punch_screen_for_binekar.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/quick_attendance.dart';
import 'package:soleoserp/ui/screens/DashBoard/QuickAttendance/sales_order_dashBoard.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/authentication/first_screen.dart';
import 'package:soleoserp/ui/screens/authentication/serial_key_screen.dart';
import 'package:soleoserp/ui/screens/authentication/terms_condition_pdf_viewer.dart';
import 'package:soleoserp/ui/screens/splash_screen.dart';
import 'package:soleoserp/utils/PDFViewer/pdf_viewer_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'TestingLocation/location_service/logic/location_controller/location_controller_cubit.dart';
import 'TestingLocation/location_service/repository/location_service_repository.dart';
import 'ui/screens/DashBoard/Modules/general_followup/general_followup_list_screen.dart';
import 'ui/screens/DashBoard/Modules/sales_order_approval/sales_order_approval_list_screen.dart';
import 'ui/screens/contactscrud/add_contact_screen.dart';
import 'ui/screens/contactscrud/contacts_crud_demo.dart';
import 'ui/screens/contactscrud/contacts_list_screen.dart';
import 'utils/offline_db_helper.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Expense_Tracking_nikhil/expense_tracking_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Expense_Tracking_nikhil/expense_tracking_Add.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

Directory _appDocsDir;
String TitleNotificationSharvaya = "";
String Latitude;
String Longitude;
bool is_LocationService_Permission;
ApiClient apiClient;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefHelper.createInstance();
  await OfflineDbHelper.createInstance();

  _appDocsDir = await getApplicationDocumentsDirectory();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      );
    }
  }

  runApp(MyApp());
}

void checkPermissionStatus() async {
  bool granted = await Permission.location.isGranted;
  bool Denied = await Permission.location.isDenied;
  bool PermanentlyDenied = await Permission.location.isPermanentlyDenied;

  if (Denied == true) {
    is_LocationService_Permission = false;
    await Permission.location.request();
  }
  if (await Permission.location.isRestricted) {
    await Permission.location.request();
  }
  if (PermanentlyDenied == true) {
    is_LocationService_Permission = false;
    await Permission.location.request();
  }

  if (granted == true) {
    is_LocationService_Permission = true;
  }
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();

  ///handles screen transaction based on route name
  static MaterialPageRoute globalGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PrivacyPolicyScreen.routeName:
        return getMaterialPageRoute(PrivacyPolicyScreen());
      case SplashScreen.routeName:
        return getMaterialPageRoute(SplashScreen());
      case SerialKeyScreen.routeName:
        return getMaterialPageRoute(SerialKeyScreen());
      case FirstScreen.routeName:
        return getMaterialPageRoute(FirstScreen());
      case HomeScreen.routeName:
        return getMaterialPageRoute(HomeScreen());
      case CountryListScreen.routeName:
        return getMaterialPageRoute(CountryListScreen());
      case Customer_ADD_EDIT.routeName:
        return getMaterialPageRoute(Customer_ADD_EDIT(settings.arguments));
      case BlueToneCustomer_ADD_EDIT.routeName:
        return getMaterialPageRoute(
            BlueToneCustomer_ADD_EDIT(settings.arguments));
      case ContactsCrudDemo.routeName:
        return getMaterialPageRoute(ContactsCrudDemo());
      case ContactsListScreen.routeName:
        return getMaterialPageRoute(ContactsListScreen());
      case AddContactScreen.routeName:
        return getMaterialPageRoute(AddContactScreen(settings.arguments));
      case FollowupListScreen.routeName:
        return getMaterialPageRoute(FollowupListScreen(settings.arguments));
      case FollowUpAddEditScreen.routeName:
        return getMaterialPageRoute(FollowUpAddEditScreen(settings.arguments));
      case ComplaintPaginationListScreen.routeName:
        return getMaterialPageRoute(ComplaintPaginationListScreen());
      case ComplaintAddEditScreen.routeName:
        return getMaterialPageRoute(ComplaintAddEditScreen(settings.arguments));
      case InquiryListScreen.routeName:
        return getMaterialPageRoute(InquiryListScreen(settings.arguments));
      case SearchInquiryScreen.routeName:
        return getMaterialPageRoute(SearchInquiryScreen(settings.arguments));
      case CustomerListScreen.routeName:
        return getMaterialPageRoute(CustomerListScreen());
      case SearchCustomerScreen.routeName:
        return getMaterialPageRoute(SearchCustomerScreen());
      case QuotationListScreen.routeName:
        return getMaterialPageRoute(QuotationListScreen());
      case SearchQuotationScreen.routeName:
        return getMaterialPageRoute(SearchQuotationScreen());
      case GreenEdgeQuotationListScreen.routeName:
        return getMaterialPageRoute(GreenEdgeQuotationListScreen());
      case SearchGreenEdgeQuotationScreen.routeName:
        return getMaterialPageRoute(SearchGreenEdgeQuotationScreen());
      case SalesOrderListScreen.routeName:
        return getMaterialPageRoute(SalesOrderListScreen());
      case SalesOrderApprovalListScreen.routeName:
        return getMaterialPageRoute(SalesOrderApprovalListScreen());
      case SearchSalesOrderScreen.routeName:
        return getMaterialPageRoute(SearchSalesOrderScreen());
      case ToDoListScreen.routeName:
        return getMaterialPageRoute(ToDoListScreen());
      case ToDoAddEditScreen.routeName:
        return getMaterialPageRoute(ToDoAddEditScreen(settings.arguments));
      case ToDoWorkLogScreen.routeName:
        return getMaterialPageRoute(ToDoWorkLogScreen(settings.arguments));
      case SearchTODOCustomerScreen.routeName:
        return getMaterialPageRoute(SearchTODOCustomerScreen());
      case ToDoEmployeeListScreen.routeName:
        return getMaterialPageRoute(ToDoEmployeeListScreen());
      case OfficeToDoScreen.routeName:
        return getMaterialPageRoute(OfficeToDoScreen());
      case OfficeToDoAddEditScreen.routeName:
        return getMaterialPageRoute(
            OfficeToDoAddEditScreen(settings.arguments));
      case SharvayaToDoWidgetListScreen.routeName:
        return getMaterialPageRoute(SharvayaToDoWidgetListScreen());
      case SharvayaToDoWidgetAddEditScreen.routeName:
        return getMaterialPageRoute(
            SharvayaToDoWidgetAddEditScreen(settings.arguments));
      case SearchCountryScreen.routeName:
        return getMaterialPageRoute(SearchCountryScreen(settings.arguments));
      case SearchStateScreen.routeName:
        return getMaterialPageRoute(SearchStateScreen(settings.arguments));
      case SearchDistrictScreen.routeName:
        return getMaterialPageRoute(SearchDistrictScreen(settings.arguments));
      case SearchTalukaScreen.routeName:
        return getMaterialPageRoute(SearchTalukaScreen(settings.arguments));
      case SearchCityScreen.routeName:
        return getMaterialPageRoute(SearchCityScreen(settings.arguments));
      case SearchFollowupCustomerScreen.routeName:
        return getMaterialPageRoute(SearchFollowupCustomerScreen());
      case AttendanceListScreen.routeName:
        return getMaterialPageRoute(AttendanceListScreen());
      case AttendanceAdd_EditScreen.routeName:
        return getMaterialPageRoute(
            AttendanceAdd_EditScreen(settings.arguments));
      case LeaveRequestListScreen.routeName:
        return getMaterialPageRoute(LeaveRequestListScreen());
      case LeaveRequestAddEditScreen.routeName:
        return getMaterialPageRoute(
            LeaveRequestAddEditScreen(settings.arguments));
      case LeaveRequestApprovalListScreen.routeName:
        return getMaterialPageRoute(LeaveRequestApprovalListScreen());
      case InquiryAddEditScreen.routeName:
        return getMaterialPageRoute(InquiryAddEditScreen(settings.arguments));

      case BlueToneInquiryAddEditScreen.routeName:
        return getMaterialPageRoute(
            BlueToneInquiryAddEditScreen(settings.arguments));

      case BlueToneInquiryProductListScreen.routeName:
        return getMaterialPageRoute(
            BlueToneInquiryProductListScreen(settings.arguments));
      case ProductPriceListScreen.routeName:
        return getMaterialPageRoute(ProductPriceListScreen(settings.arguments));

      case ExpenseListScreen.routeName:
        return getMaterialPageRoute(ExpenseListScreen());
      case ExpenseAddEditScreen.routeName:
        return getMaterialPageRoute(ExpenseAddEditScreen(settings.arguments));
      case SearchInquiryProductScreen.routeName:
        return getMaterialPageRoute(SearchInquiryProductScreen());
      //AddInquiryProductScreen
      case AddInquiryProductScreen.routeName:
        return getMaterialPageRoute(
            AddInquiryProductScreen(settings.arguments));
      case InquiryProductListScreen.routeName:
        return getMaterialPageRoute(
            InquiryProductListScreen(settings.arguments));
      case SearchInquiryCustomerScreen.routeName:
        return getMaterialPageRoute(SearchInquiryCustomerScreen());

      case FollowupHistoryScreen.routeName:
        return getMaterialPageRoute(FollowupHistoryScreen(settings.arguments));
      case DailyActivityListScreen.routeName:
        return getMaterialPageRoute(
            DailyActivityListScreen(settings.arguments));
      case SearchDailyActivityScreen.routeName:
        return getMaterialPageRoute(SearchDailyActivityScreen());
      case DailyActivityAddEditScreen.routeName:
        return getMaterialPageRoute(
            DailyActivityAddEditScreen(settings.arguments));
      case SalesBillListScreen.routeName:
        return getMaterialPageRoute(SalesBillListScreen());
      case InquiryShareScreen.routeName:
        return getMaterialPageRoute(InquiryShareScreen(settings.arguments));
      case BankVoucherListScreen.routeName:
        return getMaterialPageRoute(BankVoucherListScreen());
      case SearchBankVoucherScreen.routeName:
        return getMaterialPageRoute(SearchBankVoucherScreen());
      case BankVoucherAddEditScreen.routeName:
        return getMaterialPageRoute(
            BankVoucherAddEditScreen(settings.arguments));
      case SearchComplaintScreen.routeName:
        return getMaterialPageRoute(SearchComplaintScreen());
      case SearchComplaintCustomerScreen.routeName:
        return getMaterialPageRoute(SearchComplaintCustomerScreen());
      case AttendVisitListScreen.routeName:
        return getMaterialPageRoute(AttendVisitListScreen());
      case AttendVisitAddEditScreen.routeName:
        return getMaterialPageRoute(
            AttendVisitAddEditScreen(settings.arguments));
      case SearchAttendVisitScreen.routeName:
        return getMaterialPageRoute(SearchAttendVisitScreen());
      case QuickInquiryScreen.routeName:
        return getMaterialPageRoute(QuickInquiryScreen());
      case QuotationAddEditScreen.routeName:
        return getMaterialPageRoute(QuotationAddEditScreen(settings.arguments));
      case SearchQuotationCustomerScreen.routeName:
        return getMaterialPageRoute(SearchQuotationCustomerScreen());
      case GreenEdgeQuotationAddEditScreen.routeName:
        return getMaterialPageRoute(
            GreenEdgeQuotationAddEditScreen(settings.arguments));
      case SearchGreenEdgeQuotationCustomerScreen.routeName:
        return getMaterialPageRoute(SearchGreenEdgeQuotationCustomerScreen());
      case EmployeeListScreen.routeName:
        return getMaterialPageRoute(EmployeeListScreen());
      case SearchEmployeeScreen.routeName:
        return getMaterialPageRoute(SearchEmployeeScreen());
      case LoanListScreen.routeName:
        return getMaterialPageRoute(LoanListScreen());
      case SearchLoanScreen.routeName:
        return getMaterialPageRoute(SearchLoanScreen());
      case LoanApprovalListScreen.routeName:
        return getMaterialPageRoute(LoanApprovalListScreen());
      case MissedPunchListScreen.routeName:
        return getMaterialPageRoute(MissedPunchListScreen());
      case SearchMissedPunchScreen.routeName:
        return getMaterialPageRoute(SearchMissedPunchScreen());
      case SalaryUpadListScreen.routeName:
        return getMaterialPageRoute(SalaryUpadListScreen());
      case SearchSalaryUpadScreen.routeName:
        return getMaterialPageRoute(SearchSalaryUpadScreen());
      case MaintenanceListScreen.routeName:
        return getMaterialPageRoute(MaintenanceListScreen());
      case SearchMaintenanceScreen.routeName:
        return getMaterialPageRoute(SearchMaintenanceScreen());
      case ExternalLeadListScreen.routeName:
        return getMaterialPageRoute(ExternalLeadListScreen());
      case ExternalLeadAddEditScreen.routeName:
        return getMaterialPageRoute(
            ExternalLeadAddEditScreen(settings.arguments));
      case SearchExternalLeadScreen.routeName:
        return getMaterialPageRoute(
            SearchExternalLeadScreen(settings.arguments));
      case TeleCallerListScreen.routeName:
        return getMaterialPageRoute(TeleCallerListScreen());
      case SearchTeleCallerScreen.routeName:
        return getMaterialPageRoute(SearchTeleCallerScreen(settings.arguments));
      case TeleCallerAddEditScreen.routeName:
        return getMaterialPageRoute(
            TeleCallerAddEditScreen(settings.arguments));
      case SearchCompanyScreen.routeName:
        return getMaterialPageRoute(SearchCompanyScreen(settings.arguments));
      case DolphinComplaintVisitListScreen.routeName:
        return getMaterialPageRoute(DolphinComplaintVisitListScreen());

      case SearchCustomerQuickInquiryScreen.routeName:
        return getMaterialPageRoute(
            SearchCustomerQuickInquiryScreen(settings.arguments));

      case PackingChecklistScreen.routeName:
        return getMaterialPageRoute(PackingChecklistScreen());
      case SearchPackingChecklistScreen.routeName:
        return getMaterialPageRoute(SearchPackingChecklistScreen());
      case PackingChecklistAddScreen.routeName:
        return getMaterialPageRoute(
            PackingChecklistAddScreen(settings.arguments));
      case SearchCountryPackingScreen.routeName:
        return getMaterialPageRoute(
            SearchCountryPackingScreen(settings.arguments));
      case PackingAssamblyListScreen.routeName:
        return getMaterialPageRoute(
            PackingAssamblyListScreen(settings.arguments));
      case PackingAssamblyAddEditScreen.routeName:
        return getMaterialPageRoute(
            PackingAssamblyAddEditScreen(settings.arguments));
      case FinalCheckingListScreen.routeName:
        return getMaterialPageRoute(FinalCheckingListScreen());
      case FinalCheckingAddScreen.routeName:
        return getMaterialPageRoute(FinalCheckingAddScreen(settings.arguments));
      case SearchFinalCheckingScreen.routeName:
        return getMaterialPageRoute(SearchFinalCheckingScreen());
      case FinalCheckingItemScreen.routeName:
        return getMaterialPageRoute(FinalCheckingItemScreen());

      case InstallationListScreen.routeName:
        return getMaterialPageRoute(InstallationListScreen());
      case SearchInstallationScreen.routeName:
        return getMaterialPageRoute(SearchInstallationScreen());

      case InstallationAddScreen.routeName:
        return getMaterialPageRoute(InstallationAddScreen(settings.arguments));
      case InstallationSearchCustomerScreen.routeName:
        return getMaterialPageRoute(InstallationSearchCustomerScreen());
      case InstallationSearchCountryScreen.routeName:
        return getMaterialPageRoute(InstallationSearchCountryScreen());
      case InstallationStateSearchScreen.routeName:
        return getMaterialPageRoute(
            InstallationStateSearchScreen(settings.arguments));
      case InstallationCitySearch.routeName:
        return getMaterialPageRoute(InstallationCitySearch(settings.arguments));
      case ProductionActivityListScreen.routeName:
        return getMaterialPageRoute(
            ProductionActivityListScreen(settings.arguments));
      case ProductionActivityAdd.routeName:
        return getMaterialPageRoute(ProductionActivityAdd(settings.arguments));
      case QuickFollowupListScreen.routeName:
        return getMaterialPageRoute(QuickFollowupListScreen());

      case QuickFollowUpAddEditScreen.routeName:
        return getMaterialPageRoute(
            QuickFollowUpAddEditScreen(settings.arguments));

      case TeleCallerNewListScreen.routeName:
        return getMaterialPageRoute(TeleCallerNewListScreen());

      case TeleCallerAddEditNewScreen.routeName:
        return getMaterialPageRoute(
            TeleCallerAddEditNewScreen(settings.arguments));

      case SearchInquiryScreenFilter.routeName:
        return getMaterialPageRoute(SearchInquiryScreenFilter());

      case FollowUpInquiryAddEditScreen.routeName:
        return getMaterialPageRoute(
            FollowUpInquiryAddEditScreen(settings.arguments));

      case FollowUpFromInquiryAddEditScreen.routeName:
        return getMaterialPageRoute(
            FollowUpFromInquiryAddEditScreen(settings.arguments));

      case ProductHistoryScreen.routeName:
        return getMaterialPageRoute(ProductHistoryScreen(settings.arguments));

      case SearchSalesBillScreen.routeName:
        return getMaterialPageRoute(SearchSalesBillScreen());

      case MyDigitalSignature.routeName:
        return getMaterialPageRoute(MyDigitalSignature());

      case MissedPunchApprovalListScreen.routeName:
        return getMaterialPageRoute(MissedPunchApprovalListScreen());

      case SalesBillAddEditScreen.routeName:
        return getMaterialPageRoute(SalesBillAddEditScreen(settings.arguments));

      case SaleOrderNewAddEditScreen.routeName:
        return getMaterialPageRoute(
            SaleOrderNewAddEditScreen(settings.arguments));

      case ModuleNoListScreen.routeName:
        return getMaterialPageRoute(ModuleNoListScreen(settings.arguments));

      case AccurabathComplaintListScreen.routeName:
        return getMaterialPageRoute(AccurabathComplaintListScreen());
      case AccuraBathComplaintAddEditScreen.routeName:
        return getMaterialPageRoute(
            AccuraBathComplaintAddEditScreen(settings.arguments));

      case AccuraBathComplaintFollowupHistoryScreen.routeName:
        return getMaterialPageRoute(
            AccuraBathComplaintFollowupHistoryScreen(settings.arguments));

      case AccuraBathFollowUpFromComplaintAddEditScreen.routeName:
        return getMaterialPageRoute(
            AccuraBathFollowUpFromComplaintAddEditScreen(settings.arguments));

      case HemaAttendVisitListScreen.routeName:
        return getMaterialPageRoute(HemaAttendVisitListScreen());

      case HemaAttendVisitAddEditScreen.routeName:
        return getMaterialPageRoute(
            HemaAttendVisitAddEditScreen(settings.arguments));

      case DBankVoucherListScreen.routeName:
        return getMaterialPageRoute(DBankVoucherListScreen());
      case DBankVoucherAddEditScreen.routeName:
        return getMaterialPageRoute(DBankVoucherAddEditScreen());

      case DCashVoucherListScreen.routeName:
        return getMaterialPageRoute(DCashVoucherListScreen());
      case DCashVoucherAddEditScreen.routeName:
        return getMaterialPageRoute(DCashVoucherAddEditScreen());

      case DCustomerListScreen.routeName:
        return getMaterialPageRoute(DCustomerListScreen());
      case DCustomerAdd_Edit_Screen.routeName:
        return getMaterialPageRoute(DCustomerAdd_Edit_Screen());

      case DPurchaseListScreen.routeName:
        return getMaterialPageRoute(DPurchaseListScreen());
      case DPurchaseAddEditScreen.routeName:
        return getMaterialPageRoute(DPurchaseAddEditScreen());
      case DPurchaseProductListScreen.routeName:
        return getMaterialPageRoute(
            DPurchaseProductListScreen(settings.arguments));
      case DPurchaseProductAddEdit_screen.routeName:
        return getMaterialPageRoute(
            DPurchaseProductAddEdit_screen(settings.arguments));
      case DPurchaseOtherCharge_screen.routeName:
        return getMaterialPageRoute(
            DPurchaseOtherCharge_screen(settings.arguments));

      case DSaleBillListScreen.routeName:
        return getMaterialPageRoute(DSaleBillListScreen());
      case DSaleBillAddEditScreen.routeName:
        return getMaterialPageRoute(DSaleBillAddEditScreen(settings.arguments));
      case DSaleBillProductListScreen.routeName:
        return getMaterialPageRoute(
            DSaleBillProductListScreen(settings.arguments));
      case DSaleBillProductAddEditScreen.routeName:
        return getMaterialPageRoute(
            DSaleBillProductAddEditScreen(settings.arguments));
      case DSaleBillOtherChargeScreen.routeName:
        return getMaterialPageRoute(
            DSaleBillOtherChargeScreen(settings.arguments));
      case FollowUpFromTeleCallerddEditScreen.routeName:
        return getMaterialPageRoute(
            FollowUpFromTeleCallerddEditScreen(settings.arguments));

      case TeleCallerFollowupHistoryScreen.routeName:
        return getMaterialPageRoute(
            TeleCallerFollowupHistoryScreen(settings.arguments));

      case QuotationSpecificationAddEditScreen.routeName:
        return getMaterialPageRoute(
            QuotationSpecificationAddEditScreen(settings.arguments));

      case SpecificationListScreen.routeName:
        return getMaterialPageRoute(
            SpecificationListScreen(settings.arguments));

      case OldQuotationProductListScreen.routeName:
        return getMaterialPageRoute(
            OldQuotationProductListScreen(settings.arguments));

      case OldAddQuotationProductScreen.routeName:
        return getMaterialPageRoute(
            OldAddQuotationProductScreen(settings.arguments));

      case NewQuotationOtherChargeScreen.routeName:
        return getMaterialPageRoute(
            NewQuotationOtherChargeScreen(settings.arguments));

      //GreenEdge

      case GreenEdgeQuotationSpecificationAddEditScreen.routeName:
        return getMaterialPageRoute(
            GreenEdgeQuotationSpecificationAddEditScreen(settings.arguments));

      case GreenEdgeSpecificationListScreen.routeName:
        return getMaterialPageRoute(
            GreenEdgeSpecificationListScreen(settings.arguments));

      case OldGreenEdgeQuotationProductListScreen.routeName:
        return getMaterialPageRoute(
            OldGreenEdgeQuotationProductListScreen(settings.arguments));

      case OldAddGreenEdgeQuotationProductScreen.routeName:
        return getMaterialPageRoute(
            OldAddGreenEdgeQuotationProductScreen(settings.arguments));

      case NewGreenEdgeQuotationOtherChargeScreen.routeName:
        return getMaterialPageRoute(
            NewGreenEdgeQuotationOtherChargeScreen(settings.arguments));

      case QuickAttendanceScreen.routeName:
        return getMaterialPageRoute(QuickAttendanceScreen());

      case GeneralQuickAttendanceScreen.routeName:
        return getMaterialPageRoute(GeneralQuickAttendanceScreen());

      case NewSalesOrderOtherChargeScreen.routeName:
        return getMaterialPageRoute(
            NewSalesOrderOtherChargeScreen(settings.arguments));
      case SOProductListScreen.routeName:
        return getMaterialPageRoute(SOProductListScreen(settings.arguments));
      case SOAddEditScreen.routeName:
        return getMaterialPageRoute(SOAddEditScreen(settings.arguments));

      case SBProductListScreen.routeName:
        return getMaterialPageRoute(SBProductListScreen(settings.arguments));

      case SBAddEditScreen.routeName:
        return getMaterialPageRoute(SBAddEditScreen(settings.arguments));
      case NewSalesBillOtherChargeScreen.routeName:
        return getMaterialPageRoute(
            NewSalesBillOtherChargeScreen(settings.arguments));
      case QTAssemblyScreen.routeName:
        return getMaterialPageRoute(QTAssemblyScreen(settings.arguments));

      case QTAssemblyAddEditScreen.routeName:
        return getMaterialPageRoute(
            QTAssemblyAddEditScreen(settings.arguments));

      case GreenEdgeQTAssemblyScreen.routeName:
        return getMaterialPageRoute(
            GreenEdgeQTAssemblyScreen(settings.arguments));

      case GreenEdgeQTAssemblyAddEditScreen.routeName:
        return getMaterialPageRoute(
            GreenEdgeQTAssemblyAddEditScreen(settings.arguments));
      case SOAssemblyScreen.routeName:
        return getMaterialPageRoute(SOAssemblyScreen(settings.arguments));
      case SBAssemblyScreen.routeName:
        return getMaterialPageRoute(SBAssemblyScreen(settings.arguments));

      case OfficeFollowUpAddEditScreen.routeName:
        return getMaterialPageRoute(
            OfficeFollowUpAddEditScreen(settings.arguments));
      case ActivitySummary.routeName:
        return getMaterialPageRoute(ActivitySummary());
      case ProductMasterListScreen.routeName:
        return getMaterialPageRoute(ProductMasterListScreen());
      case ProductMasterAddEdit.routeName:
        return getMaterialPageRoute(ProductMasterAddEdit(settings.arguments));

      case SalesTargetListScreen.routeName:
        return getMaterialPageRoute(SalesTargetListScreen());
      case SalesTargetAddEditScreen.routeName:
        return getMaterialPageRoute(
            SalesTargetAddEditScreen(settings.arguments));

      case TaskCategoryScreen.routeName:
        return getMaterialPageRoute(TaskCategoryScreen(settings.arguments));

      case BTSearchCountryScreen.routeName:
        return getMaterialPageRoute(BTSearchCountryScreen(settings.arguments));
      case VkSoundComplaintPaginationListScreen.routeName:
        return getMaterialPageRoute(VkSoundComplaintPaginationListScreen());

      case VkComplaintAddEditScreen.routeName:
        return getMaterialPageRoute(
            VkComplaintAddEditScreen(settings.arguments));

      case VKComplaintHistoryScreen.routeName:
        return getMaterialPageRoute(
            VKComplaintHistoryScreen(settings.arguments));
      //BlueToneFollowupNotificationDetailScreen
      case BlueToneFollowupNotificationDetailScreen.routeName:
        return getMaterialPageRoute(
            BlueToneFollowupNotificationDetailScreen(settings.arguments));

      case AcurabathQuotationListScreen.routeName:
        return getMaterialPageRoute(AcurabathQuotationListScreen());
      case AcurabathSearchQuotationScreen.routeName:
        return getMaterialPageRoute(AcurabathSearchQuotationScreen());
      case AcurabathQuotationAddEditScreen.routeName:
        return getMaterialPageRoute(
            AcurabathQuotationAddEditScreen(settings.arguments));
      case AcurabathSearchQuotationCustomerScreen.routeName:
        return getMaterialPageRoute(AcurabathSearchQuotationCustomerScreen());
      case AcurabathOldQuotationProductListScreen.routeName:
        return getMaterialPageRoute(
            AcurabathOldQuotationProductListScreen(settings.arguments));
      case AccurabathOldAddQuotationProductScreen.routeName:
        return getMaterialPageRoute(
            AccurabathOldAddQuotationProductScreen(settings.arguments));
      case AcurabathNewQuotationOtherChargeScreen.routeName:
        return getMaterialPageRoute(
            AcurabathNewQuotationOtherChargeScreen(settings.arguments));
      case AcurabathSpecificationListScreen.routeName:
        return getMaterialPageRoute(
            AcurabathSpecificationListScreen(settings.arguments));
      case AcurabathQuotationSpecificationAddEditScreen.routeName:
        return getMaterialPageRoute(
            AcurabathQuotationSpecificationAddEditScreen(settings.arguments));
      case AcurabathQTAssemblyScreen.routeName:
        return getMaterialPageRoute(
            AcurabathQTAssemblyScreen(settings.arguments));
      case AcurabathQTAssemblyAddEditScreen.routeName:
        return getMaterialPageRoute(
            AcurabathQTAssemblyAddEditScreen(settings.arguments));

      case GeneralFollowupListScreen.routeName:
        return getMaterialPageRoute(
            GeneralFollowupListScreen(settings.arguments));

      case FollowUpFromExternalLeadAddEditScreen.routeName:
        return getMaterialPageRoute(
            FollowUpFromExternalLeadAddEditScreen(settings.arguments));

      case PDFViewerScreen.routeName:
        return getMaterialPageRoute(PDFViewerScreen(settings.arguments));

      /// Mudra Complaint And Visit
      case MudraCompliantListScreen.routeName:
        return getMaterialPageRoute(MudraCompliantListScreen());
      case MudraComplaintAddEdit.routeName:
        return getMaterialPageRoute(MudraComplaintAddEdit(settings.arguments));
      case MudraComplaintHistoryScreen.routeName:
        return getMaterialPageRoute(
            MudraComplaintHistoryScreen(settings.arguments));
      case MudraAttendListScreen.routeName:
        return getMaterialPageRoute(MudraAttendListScreen());
      case MudraAttendVisitAddEdit.routeName:
        return getMaterialPageRoute(
            MudraAttendVisitAddEdit(settings.arguments));

      /// purchase screens

      case PoListScreen.routeName:
        return getMaterialPageRoute(PoListScreen());
      case POAddEditScreen.routeName:
        return getMaterialPageRoute(POAddEditScreen(settings.arguments));

      case POProductListScreen.routeName:
        return getMaterialPageRoute(POProductListScreen(settings.arguments));
      case POProductAddEditScreen.routeName:
        return getMaterialPageRoute(POProductAddEditScreen(settings.arguments));
      case NewPoOtherChargeScreen.routeName:
        return getMaterialPageRoute(NewPoOtherChargeScreen(settings.arguments));
      case PendingPoForIndentListScreen.routeName:
        return getMaterialPageRoute(
            PendingPoForIndentListScreen(settings.arguments));

      /// Purchase Bill
      case PurchaseBillListScreen.routeName:
        return getMaterialPageRoute(PurchaseBillListScreen());
      case PurchaseBillAddEditScreen.routeName:
        return getMaterialPageRoute(
            PurchaseBillAddEditScreen(settings.arguments));
      case ModuleNoListScreen.routeName:
        return getMaterialPageRoute(ModuleNoListScreen(settings.arguments));
      case PBProductListScreen.routeName:
        return getMaterialPageRoute(PBProductListScreen(settings.arguments));
      case PBAddEditScreen.routeName:
        return getMaterialPageRoute(PBAddEditScreen(settings.arguments));
      case NewPurchaseBillOtherChargeScreen.routeName:
        return getMaterialPageRoute(
            NewPurchaseBillOtherChargeScreen(settings.arguments));

      /// Bank Voucher
      case MayankBankVoucherListScreen.routeName:
        return getMaterialPageRoute(MayankBankVoucherListScreen());
      case MayankBankVoucherAddEdit.routeName:
        return getMaterialPageRoute(
            MayankBankVoucherAddEdit(settings.arguments));
      case MaintenanceDetailsListScreen.routeName:
        return getMaterialPageRoute(
            MaintenanceDetailsListScreen(settings.arguments));
      case AddMaintenanceDetailsScreen.routeName:
        return getMaterialPageRoute(
            AddMaintenanceDetailsScreen(settings.arguments));

      /// Cash Voucher
      case MayankCashVoucherListScreen.routeName:
        return getMaterialPageRoute(MayankCashVoucherListScreen());
      case MayankCashVoucherAddEdit.routeName:
        return getMaterialPageRoute(
            MayankCashVoucherAddEdit(settings.arguments));
      case MaintenanceDetailsListScreen1.routeName:
        return getMaterialPageRoute(
            MaintenanceDetailsListScreen1(settings.arguments));
      case AddMaintenanceDetailsScreen1.routeName:
        return getMaterialPageRoute(
            AddMaintenanceDetailsScreen1(settings.arguments));

      /// Si Daily Activity
      case DailyActivityForSharvayaListScreen.routeName:
        return getMaterialPageRoute(
            DailyActivityForSharvayaListScreen(settings.arguments));
      case DailyActivityForSharvayaAddEdit.routeName:
        return getMaterialPageRoute(
            DailyActivityForSharvayaAddEdit(settings.arguments));

      case QuickSupportListScreen.routeName:
        return getMaterialPageRoute(QuickSupportListScreen());

      case PunchScreen.routeName:
        return getMaterialPageRoute(PunchScreen());

      case DailyReport.routeName:
        return getMaterialPageRoute(DailyReport());

      /// Hpl quotation
      case HplSearchQuotationScreen.routeName:
        return getMaterialPageRoute(HplSearchQuotationScreen());
      case HplQuotationListScreen.routeName:
        return getMaterialPageRoute(HplQuotationListScreen());
      case HplSearchQuotationCustomerScreen.routeName:
        return getMaterialPageRoute(HplSearchQuotationCustomerScreen());
      case HplQuotationAddEditScreen.routeName:
        return getMaterialPageRoute(
            HplQuotationAddEditScreen(settings.arguments));
      case HplSpecificationListScreen.routeName:
        return getMaterialPageRoute(
            HplSpecificationListScreen(settings.arguments));
      case HplQuotationSpecificationAddEditScreen.routeName:
        return getMaterialPageRoute(
            HplQuotationSpecificationAddEditScreen(settings.arguments));
      case HplQTAssemblyScreen.routeName:
        return getMaterialPageRoute(HplQTAssemblyScreen(settings.arguments));
      case HplQTAssemblyAddEditScreen.routeName:
        return getMaterialPageRoute(
            HplQTAssemblyAddEditScreen(settings.arguments));
      case HplOldQuotationProductListScreen.routeName:
        return getMaterialPageRoute(
            HplOldQuotationProductListScreen(settings.arguments));
      case HplOldAddQuotationProductScreen.routeName:
        return getMaterialPageRoute(
            HplOldAddQuotationProductScreen(settings.arguments));
      case HplNewQuotationOtherChargeScreen.routeName:
        return getMaterialPageRoute(
            HplNewQuotationOtherChargeScreen(settings.arguments));
      case TagEmployeeListScreen.routeName:
        return getMaterialPageRoute(TagEmployeeListScreen(settings.arguments));
      case CustomerHistoryScreen.routeName:
        return getMaterialPageRoute(CustomerHistoryScreen(settings.arguments));
      case VehicleListDropDownScreen.routeName:
        return getMaterialPageRoute(
            VehicleListDropDownScreen(settings.arguments));

      /// Speed Testing
      case InternetSpeedTester.routeName:
        return getMaterialPageRoute(InternetSpeedTester());

      case ReportListScreen.routeName:
        return getMaterialPageRoute(ReportListScreen());
      case MainReportListScreen.routeName:
        return getMaterialPageRoute(MainReportListScreen());
      case InquiryReportListScreen.routeName:
        return getMaterialPageRoute(InquiryReportListScreen());
      /*case QuotationReportListScreen.routeName:
          return getMaterialPageRoute(QuotationReportListScreen());*/

      ///outward
      case MaterialOutwardListMainScreen.routeName:
        return getMaterialPageRoute(MaterialOutwardListMainScreen());
      case MaterialOutwardAddEditMainScreen.routeName:
        return getMaterialPageRoute(
            MaterialOutwardAddEditMainScreen(settings.arguments));
      case MaterialOutwardProductListScreen.routeName:
        return getMaterialPageRoute(
            MaterialOutwardProductListScreen(settings.arguments));
      case MaterialOutwardDetailsAddEditScreen.routeName:
        return getMaterialPageRoute(
            MaterialOutwardDetailsAddEditScreen(settings.arguments));
      case PunchScreenForBinekar.routeName:
        return getMaterialPageRoute(PunchScreenForBinekar());

      ///AMC
      case MaintenanceAddEditScreen.routeName:
        return getMaterialPageRoute(
            MaintenanceAddEditScreen(settings.arguments));
      case MaintenanceProductListScreen.routeName:
        return getMaterialPageRoute(
            MaintenanceProductListScreen(settings.arguments));
      case MaintenanceProductAddEditScreen.routeName:
        return getMaterialPageRoute(
            MaintenanceProductAddEditScreen(settings.arguments));

      /// Repairing

      case RepairingListMainScreen.routeName:
        return getMaterialPageRoute(RepairingListMainScreen());
      case RepairingAddEditMainScreen.routeName:
        return getMaterialPageRoute(
            RepairingAddEditMainScreen(settings.arguments));
      case RepairingDetailsListScreen.routeName:
        return getMaterialPageRoute(
            RepairingDetailsListScreen(settings.arguments));
      case SearchCountryForGreenEdgeScreen.routeName:
        return getMaterialPageRoute(
            SearchCountryForGreenEdgeScreen(settings.arguments));

      /// Material Inward

      case MaterialInwardListScreens.routeName:
        return getMaterialPageRoute(MaterialInwardListScreens());
      case MaterialInwardAddEditMainScreen.routeName:
        return getMaterialPageRoute(
            MaterialInwardAddEditMainScreen(settings.arguments));
      case MaterialInwardProductListScreen.routeName:
        return getMaterialPageRoute(
            MaterialInwardProductListScreen(settings.arguments));
      case MaterialInwardDetailsAddEditScreen.routeName:
        return getMaterialPageRoute(
            MaterialInwardDetailsAddEditScreen(settings.arguments));

      /// Po Approval
      case PurchaseOrderApprovalListScreen.routeName:
        return getMaterialPageRoute(PurchaseOrderApprovalListScreen());

      /// Short Invoice
      case ShortInvoiceListScreen.routeName:
        return getMaterialPageRoute(ShortInvoiceListScreen());
      case ShortInvoiceNewAddEditScreen.routeName:
        return getMaterialPageRoute(
            ShortInvoiceNewAddEditScreen(settings.arguments));
      case ShortInvoiceProductListScreen.routeName:
        return getMaterialPageRoute(
            ShortInvoiceProductListScreen(settings.arguments));
      case ShortInvoiceAddEditScreen.routeName:
        return getMaterialPageRoute(
            ShortInvoiceAddEditScreen(settings.arguments));
      case NewShortInvoiceOtherChargeScreen.routeName:
        return getMaterialPageRoute(
            NewShortInvoiceOtherChargeScreen(settings.arguments));

      case ServiceReportListScreens.routeName:
        return getMaterialPageRoute(ServiceReportListScreens());
      case ServiceReportAddEditScreen.routeName:
        return getMaterialPageRoute(
            ServiceReportAddEditScreen(settings.arguments));
      case ServiceReportWorkNotesScreen.routeName:
        return getMaterialPageRoute(
            ServiceReportWorkNotesScreen(settings.arguments));
      // case LocationListMainScreen.routeName:
      //   return getMaterialPageRoute(LocationListMainScreen(settings.arguments));
      case LocationLogListMainScreen.routeName:
        return getMaterialPageRoute(LocationLogListMainScreen());
      case PaySlipListScreen.routeName:
        return getMaterialPageRoute(PaySlipListScreen());
      case VisitorInfoListScreen.routeName:
        return getMaterialPageRoute(VisitorInfoListScreen());
      case VisitorInfoAddEditScreen.routeName:
        return getMaterialPageRoute(
            VisitorInfoAddEditScreen(settings.arguments));
      case NearByPinCodeScreen.routeName:
        return getMaterialPageRoute(NearByPinCodeScreen());
      case SalesOrderDashboardScreen.routeName:
        return getMaterialPageRoute(SalesOrderDashboardScreen());
      case MaterialIndentApprovalScreen.routeName:
        return getMaterialPageRoute(MaterialIndentApprovalScreen());

      case MultiExpenseListScreen.routeName:
        return getMaterialPageRoute(MultiExpenseListScreen());
      case MultiExpenseAddEditScreen.routeName:
        return getMaterialPageRoute(
            MultiExpenseAddEditScreen(settings.arguments));
      case MultipleExpenseDetailsScreen.routeName:
        return getMaterialPageRoute(
            MultipleExpenseDetailsScreen(settings.arguments));
      case MultiExpenseDetailsAddEditScreen.routeName:
        return getMaterialPageRoute(
            MultiExpenseDetailsAddEditScreen(settings.arguments));
      case CreditNotesListScreen.routeName:
        return getMaterialPageRoute(CreditNotesListScreen());
      case DebitNotesListScreen.routeName:
        return getMaterialPageRoute(DebitNotesListScreen());
      case JournalVoucherListScreen.routeName:
        return getMaterialPageRoute(JournalVoucherListScreen());
      case PettyCashListScreen.routeName:
        return getMaterialPageRoute(PettyCashListScreen());
      case AssetIssueListScreen.routeName:
        return getMaterialPageRoute(AssetIssueListScreen());
      case AssetReturnListScreen.routeName:
        return getMaterialPageRoute(AssetReturnListScreen());
      case MultiExpenseApprovalScreen.routeName:
        return getMaterialPageRoute(MultiExpenseApprovalScreen());
      case QuickFollowUpReportScreen.routeName:
        return getMaterialPageRoute(QuickFollowUpReportScreen());
      case GeneralFollowupListForAlmightyScreen.routeName:
        return getMaterialPageRoute(
            GeneralFollowupListForAlmightyScreen(settings.arguments));
      case ExpenseTrackingListScreen.routeName:
        return getMaterialPageRoute(ExpenseTrackingListScreen());
      case ExpenseTrackingAddScreen.routeName:
        return getMaterialPageRoute(ExpenseTrackingAddScreen());

      default:
        return null;
    }
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: ScreenUtilInit(
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => LocationControllerCubit(
                  locationServiceRepository: LocationServiceRepository(),
                ),
              ),
            ],
            child: MaterialApp(
                onGenerateRoute: MyApp.globalGenerateRoute,
                debugShowCheckedModeBanner: false,
                supportedLocales: [
                  Locale('en', 'US'),
                ],
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  MonthYearPickerLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale.languageCode &&
                        supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                title: "Sharvaya ERP",
                theme: buildAppTheme(),
                initialRoute: getInitialRoute(TitleNotificationSharvaya)),
          );
        },
      ),
    );
  }

  ///returns initial route based on condition of logged in/out
  getInitialRoute(String titleNotificationSharvaya) {
    if (SharedPrefHelper.instance.isLogIn()) {
      return HomeScreen.routeName;
    } else if (SharedPrefHelper.instance.isRegisteredIn()) {
      return FirstScreen.routeName;
    } else if (SharedPrefHelper.instance.isTermsAndCondition()) {
      return SerialKeyScreen.routeName;
    }
    return PrivacyPolicyScreen.routeName;
  }
}

Future<String> getDeviceName() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceName;

  if (Platform.isAndroid != null) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceName = '${androidInfo.brand} ${androidInfo.model}';
  } else if (Platform.isIOS != null) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceName = iosInfo.name;
  } else {
    deviceName = 'Unknown Device';
  }

  return deviceName;
}
