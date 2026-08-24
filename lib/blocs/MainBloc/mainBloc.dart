import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/Model_Classis_Fro_ODB/bank_voucher_detail_model.dart';
import 'package:soleoserp/models/api_requests/Expense_Tracking_nikhil/expense_tracking_list_requests.dart';
import 'package:soleoserp/models/api_requests/Expense_Tracking_nikhil/expense_tracking_save_requests.dart';
import 'package:soleoserp/models/api_requests/Material_Indent_request/Material_Indent_approval_update_request.dart';
import 'package:soleoserp/models/api_requests/Material_Indent_request/Material_Indent_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Get_FetDetail_By_OrdedNo_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Get_OrdedNo_From_TheCustomerId_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Location_List_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Material_Inward_Customer_List_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Material_Inward_Delete_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Material_Inward_Details_LIst_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Material_Inward_List_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Material_Inward_Master_Save_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/detail_delete_inward.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/materail_outward_export_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_add_update_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_delete_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_details_delete_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_details_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_document_delete_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_document_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_document_upload_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_expoet_save_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_for_get_so_by_fetchTyoe_details_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_for_get_so_details_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_for_get_so_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_list_request.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_BankVoucher_Delete_Request.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_BankVoucher_List_Request.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_Bank_Voucher_Add_Update_request.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_Bank_Voucher_Details_Delete_Request.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_Bank_Voucher_Details_List_request.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_Bank_Voucher_Pending_Amount_request.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_Bank_Voucher_details_Add_update_request.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Maynak_Inq_No_request.dart';
import 'package:soleoserp/models/api_requests/Reports/customer_list.dart';
import 'package:soleoserp/models/api_requests/SalesBill/sale_bill_email_content_request.dart';
import 'package:soleoserp/models/api_requests/SalesBill/sales_bill_inq_QT_SO_NO_list_Request.dart';
import 'package:soleoserp/models/api_requests/SalesOrder/multi_no_to_product_details_request.dart';
import 'package:soleoserp/models/api_requests/constant_master/constant_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_paggination_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:soleoserp/models/api_requests/followup/quick_followup_report_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_product_search_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_status_list_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_add_update_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_chacklist_dropdown.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_delete_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_details_delete_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_details_list_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_list_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/master_maintenance_contactList%20_dropdown.dart';
import 'package:soleoserp/models/api_requests/manage_accounts_request/dbcr_list_request/dbcr_list_request.dart';
import 'package:soleoserp/models/api_requests/manage_accounts_request/journalVoucher_mstAsset_list_request/journalVoucher_mstAsset_list_request.dart';
import 'package:soleoserp/models/api_requests/manage_accounts_request/petty_cash_list_request/petty_cash_list_request.dart';
import 'package:soleoserp/models/api_requests/manage_accounts_request/trialBalance_list_request/trialBalance_list_request.dart';
import 'package:soleoserp/models/api_requests/moduleAttachments/module_attachment_item_wise_delete_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_add_update_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_approval_list_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_approval_update_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_delete_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_details_delete_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multi_expense_list_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multiple_expense_expenseMode_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/multiple_expense_expenseType_request.dart';
import 'package:soleoserp/models/api_requests/multi_expense_request/office_refType_from_customerID_request.dart';
import 'package:soleoserp/models/api_requests/other/all_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/other/bank_name_drop_down_request.dart';
import 'package:soleoserp/models/api_requests/other/city_list_request.dart';
import 'package:soleoserp/models/api_requests/other/country_list_request.dart';
import 'package:soleoserp/models/api_requests/other/locationList_request.dart';
import 'package:soleoserp/models/api_requests/other/near_by_pincode_request.dart';
import 'package:soleoserp/models/api_requests/other/state_list_request.dart';
import 'package:soleoserp/models/api_requests/pay_slip_request/pay_slip_list_request.dart';
import 'package:soleoserp/models/api_requests/product/product_master_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_add_update_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_delete_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_details_add_update_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_details_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_list_screen_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_purchase_TOD_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_purchase_ac_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/PO_approval_update_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/Po_approval_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/Po_header_add_update_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/Po_header_delete_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/Po_header_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_details_add_upadte_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_details_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_driver_no_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_drp_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_load_to_indent_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_shipment_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_shipment_sav_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_tanker_no_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/qt_Organization_drop_down_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_kind_att_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:soleoserp/models/api_requests/quotation/save_email_content_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_add_update_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_delete_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_details_delete_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_details_list_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_list_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_log_list_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder_Approval/sales_order_approval_status_list_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sales_bill_generate_pdf_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/sales_order_generate_pdf_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/shipment/so_shipment_address_drop_down_api_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/so_currency_list_request.dart';
import 'package:soleoserp/models/api_requests/service_report_request/service_report_add_update_request.dart';
import 'package:soleoserp/models/api_requests/service_report_request/service_report_delete_request.dart';
import 'package:soleoserp/models/api_requests/service_report_request/service_report_details_delete_request.dart';
import 'package:soleoserp/models/api_requests/service_report_request/service_report_details_list_request.dart';
import 'package:soleoserp/models/api_requests/service_report_request/service_report_list_request.dart';
import 'package:soleoserp/models/api_requests/service_report_request/service_report_machibe_type_request.dart';
import 'package:soleoserp/models/api_requests/sharvaya_daily_activity/module_dropdown_request.dart';
import 'package:soleoserp/models/api_requests/sharvaya_daily_activity/sharvaya_daily_activity_add_edit_request.dart';
import 'package:soleoserp/models/api_requests/sharvaya_daily_activity/sharvaya_daily_activity_delete_request.dart';
import 'package:soleoserp/models/api_requests/sharvaya_daily_activity/sharvaya_daily_activity_list_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_add_update.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_assembly_load_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_delete_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_details_add_update_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_details_list_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_export_add_update_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_export_list_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_list_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_shipment_add_update_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_shipment_address_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/task_category_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/transection_mode_list_request.dart';
import 'package:soleoserp/models/api_requests/visitor_info_requests/visitor_info_add_update_requests.dart';
import 'package:soleoserp/models/api_requests/visitor_info_requests/visitor_info_delete_requests.dart';
import 'package:soleoserp/models/api_requests/visitor_info_requests/visitor_info_list_requests.dart';
import 'package:soleoserp/models/api_responses/Material_Indent_response/Material_Indent_approval_update_response.dart';
import 'package:soleoserp/models/api_responses/Material_Indent_response/Material_Indent_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Get_FetDetail_By_OrdedNo_Responset.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Get_OrdedNo_From_TheCustomerId_Response.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Location_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Material_Inward_Customer_List_Responce.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Material_Inward_Details_LIst_Responce.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Material_Inward_Master_Save_Responce.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Material_Inward_list_Responce.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/imaterial_outward_document_delete_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/materail_outward_export_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_add_update_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_details_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_document_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_for_get_so_details_by_fetchType_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_for_get_so_details_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_for_get_so_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_list_response.dart';
import 'package:soleoserp/models/api_responses/Mayank_BankVoucher_Response/Bank_Voucher_details_List_response.dart';
import 'package:soleoserp/models/api_responses/Mayank_BankVoucher_Response/Mayank_BankVoucher_List_Respnse.dart';
import 'package:soleoserp/models/api_responses/Mayank_BankVoucher_Response/Mayank_Bank_Voucher_Add_Edit_response.dart';
import 'package:soleoserp/models/api_responses/Mayank_BankVoucher_Response/Mayank_Bank_Voucher_Amount_response.dart';
import 'package:soleoserp/models/api_responses/Mayank_BankVoucher_Response/Mayank_Bank_voucher_details_Add_Edit_response.dart';
import 'package:soleoserp/models/api_responses/Mayank_BankVoucher_Response/Maynak_Inq_No_response.dart';
import 'package:soleoserp/models/api_responses/SaleBill/sale_bill_email_content_response.dart';
import 'package:soleoserp/models/api_responses/SaleBill/sales_bill_INQ_QT_SO_NO_list_response.dart';
import 'package:soleoserp/models/api_responses/SaleOrder/multi_no_to_product_details_response.dart';
import 'package:soleoserp/models/api_responses/constant_master/constant_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_details_api_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/followup/quick_followup_report_list_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_list_reponse.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_status_list_response.dart';
import 'package:soleoserp/models/api_responses/maintenance/maintenance_add_update_response.dart';
import 'package:soleoserp/models/api_responses/maintenance/maintenance_chacklist_dropdown_response.dart';
import 'package:soleoserp/models/api_responses/maintenance/maintenance_details_list_response.dart';
import 'package:soleoserp/models/api_responses/maintenance/maintenance_list_response.dart';
import 'package:soleoserp/models/api_responses/maintenance/master_maintenance_contactList%20_dropdown_response.dart';
import 'package:soleoserp/models/api_responses/maintenance/master_maintenance_contactList%20_dropdown_response1.dart';
import 'package:soleoserp/models/api_responses/manage_accounts_response/asset_list_response/asset_issue_list_response.dart';
import 'package:soleoserp/models/api_responses/manage_accounts_response/asset_list_response/asset_return_list_response.dart';
import 'package:soleoserp/models/api_responses/manage_accounts_response/credit_notes_list_response/credit_notes_list_response.dart';
import 'package:soleoserp/models/api_responses/manage_accounts_response/debit_notes_list_response/debit_notes_list_response.dart';
import 'package:soleoserp/models/api_responses/manage_accounts_response/journal_voucher_list_response/journal_voucher_list_response.dart';
import 'package:soleoserp/models/api_responses/manage_accounts_response/petty_cash_list_response/petty_cash_list_response.dart';
import 'package:soleoserp/models/api_responses/manage_accounts_response/trial_balance_list_response/trial_balance_list_response.dart';
import 'package:soleoserp/models/api_responses/moduleAttachments/module_attachment_item_wise_delete_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_add_update_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_approval_list_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_approval_update_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_details_list_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_list_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multiple_expense_expenseMode_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multiple_expense_expenseType_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/office_refType_from_customerID_response.dart';
import 'package:soleoserp/models/api_responses/other/MultiNoToProductDetailsFromQuotationResponse.dart';
import 'package:soleoserp/models/api_responses/other/all_employee_List_response.dart';
import 'package:soleoserp/models/api_responses/other/bank_name_drop_down_response.dart';
import 'package:soleoserp/models/api_responses/other/city_api_response.dart';
import 'package:soleoserp/models/api_responses/other/country_list_response.dart';
import 'package:soleoserp/models/api_responses/other/dashBoard_locationList_reponse.dart';
import 'package:soleoserp/models/api_responses/other/locatioLog_response.dart';
import 'package:soleoserp/models/api_responses/other/near_by_pincode_details_response.dart';
import 'package:soleoserp/models/api_responses/other/near_by_pincode_summary_response.dart';
import 'package:soleoserp/models/api_responses/other/state_list_response.dart';
import 'package:soleoserp/models/api_responses/pay_slip_response/pay_slip_list_response.dart';
import 'package:soleoserp/models/api_responses/product_master/product_master_list_response.dart';
import 'package:soleoserp/models/api_responses/purchase_bill_screen/purchase_bill_TOD_response.dart';
import 'package:soleoserp/models/api_responses/purchase_bill_screen/purchase_bill_add_update_response.dart';
import 'package:soleoserp/models/api_responses/purchase_bill_screen/purchase_bill_details_fom_grn_response.dart';
import 'package:soleoserp/models/api_responses/purchase_bill_screen/purchase_bill_details_fom_purchase_order_response.dart';
import 'package:soleoserp/models/api_responses/purchase_bill_screen/purchase_bill_details_list_response.dart';
import 'package:soleoserp/models/api_responses/purchase_bill_screen/purchase_bill_list_screen_response.dart';
import 'package:soleoserp/models/api_responses/purchase_bill_screen/purchase_bill_purchase_ac_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/PO_add_update_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/PO_approval_list_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/po_details_list_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/po_driver_no_list_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/po_drp_list_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/po_indent_load_to_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/po_tanker_No_list_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/purchase_order_list_screen_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/purchase_order_shipment_response.dart';
import 'package:soleoserp/models/api_responses/quotation/qt_Organization_drop_down_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_kind_att_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_project_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_terms_condition_response.dart';
import 'package:soleoserp/models/api_responses/quotation/save_email_content_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_add_update_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_details_list_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_list_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_log_list_response.dart';
import 'package:soleoserp/models/api_responses/salesOrder_Approval/salesOrder_approval_status_list_response.dart';
import 'package:soleoserp/models/api_responses/saleBill/sales_bill_generate_pdf_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/salesOrder_Product_Save_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/sales_order_pdf_generate_pdf_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/shipment/so_shipment_address_drop_down_api_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/so_currency_list_response.dart';
import 'package:soleoserp/models/api_responses/service_report_response/service_report_add_update_response.dart';
import 'package:soleoserp/models/api_responses/service_report_response/service_report_details_list_request.dart';
import 'package:soleoserp/models/api_responses/service_report_response/service_report_list_response.dart';
import 'package:soleoserp/models/api_responses/service_report_response/service_report_machibe_type_response.dart';
import 'package:soleoserp/models/api_responses/sharvaya_daily_activity%202/modules_dropdown_response.dart';
import 'package:soleoserp/models/api_responses/sharvaya_daily_activity%202/sharvaya_daily_activity_response.dart';
import 'package:soleoserp/models/api_responses/sharvaya_daily_activity%202/sharvaya_daily_activity_save_response.dart';
import 'package:soleoserp/models/api_responses/short_invoice_response/short_invoice_add_update_response.dart';
import 'package:soleoserp/models/api_responses/short_invoice_response/short_invoice_assembly_load_response.dart';
import 'package:soleoserp/models/api_responses/short_invoice_response/short_invoice_details_list_response.dart';
import 'package:soleoserp/models/api_responses/short_invoice_response/short_invoice_export_list_response.dart';
import 'package:soleoserp/models/api_responses/short_invoice_response/short_invoice_list_response.dart';
import 'package:soleoserp/models/api_responses/short_invoice_response/short_invoice_shipment_address_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/task_category_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/transection_mode_list_response.dart';
import 'package:soleoserp/models/api_responses/visitor_info_response/visitor_info_add_update_response.dart';
import 'package:soleoserp/models/api_responses/visitor_info_response/visitor_info_list_response.dart';
import 'package:soleoserp/models/common/Maintenance_product_model.dart';
import 'package:soleoserp/models/common/MaterialOutwardDetailsTable.dart';
import 'package:soleoserp/models/common/Material_Inward_Product_table.dart';
import 'package:soleoserp/models/common/Short_Invoice_Table.dart';
import 'package:soleoserp/models/common/generic_addtional_calculation/generic_addtional_amount_calculation.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:soleoserp/models/common/multiple_expense_table.dart';
import 'package:soleoserp/models/common/purchase_bill_table.dart';
import 'package:soleoserp/models/common/purchase_order_teble.dart';
import 'package:soleoserp/models/common/repairing_table.dart';
import 'package:soleoserp/models/common/workNotes_model.dart';
import 'package:soleoserp/repositories/repository.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/sales_order_payment_schedule.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:http/http.dart' as http;

import '../../models/api_requests/Expense_Tracking_nikhil/expense_tracking_list_requests.dart';
import '../../models/api_requests/Expense_Tracking_nikhil/expense_tracking_save_requests.dart';
import '../../models/api_responses/Expense_Tracking_nikhil/expense_tracking_list_responses.dart';
import '../../models/api_responses/Expense_Tracking_nikhil/expense_tracking_save_responses.dart';

part 'main_events.dart';
part 'main_states.dart';

class MainBloc extends Bloc<MainEvents, MainStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  MainBloc(this.baseBloc) : super(MainInitialState());

  @override
  Stream<MainStates> mapEventToState(MainEvents event) async* {
    /// sets state based on events
    if (event is MayankBankVoucherListEvent) {
      yield* _mapMayankBankVoucherListEventState(event);
    }
    if (event is MayankBankVoucherDeleteEvent) {
      yield* _mapMayankBankVoucherDeleteEventState(event);
    }
    if (event is MayankSearchBankVoucherCustomerListByNameCallEvent) {
      yield* _mapFollowupCustomerListByNameCallEventToState(event);
    }
    if (event is MayankTransectionModeCallEvent) {
      yield* _mapTransectionModeCallEventToState(event);
    }
    if (event is MayankBankVoucherModeCallEvent) {
      yield* _mapBankVoucherModeCallEventToState(event);
    }
    if (event is MayankBankVoucherAmountCallEvent) {
      yield* _mapBankVoucherAmountCallEventToState(event);
    }
    if (event is MayankBankVoucherSaveCallEvent) {
      yield* _mapSavedBankVoucherCallEventToState(event);
    }
    if (event is MayankBankVoucherDetailsListEvent) {
      yield* _mapMayankBankVoucherDetailsListEventState(event);
    }
    if (event is MayankBankVoucherDeleteDetailsEvent) {
      yield* _mapMayankBankVoucherDeleteDetailsEventState(event);
    }
    if (event is MayankBankVoucherDetailsAddEditEvent) {
      yield* _mapMayankBankVoucherDetailsAddEditEventState(event);
    }
    if (event is MayankBankVoucherDetailsAddEditEvent1) {
      yield* _mapMayankBankVoucherDetailsAddEditEventState1(event);
    }
    if (event is PurchaseBillListRequestEvent) {
      yield* _mapPurchaseBillListEventState1(event);
    }
    if (event is PurchaseBillDeleteRequestEvent) {
      yield* _mapPurchaseBillDeleteEventState(event);
    }
    if (event is GetPBProductListEvent) {
      yield* _mapGetPBProductListEventState(event);
    }
    if (event is InsertPBProductEvent) {
      yield* _map_insertPBProductEventState(event);
    }
    if (event is PBProductOneDeleteEvent) {
      yield* _mapPBOneProductDeleteEventState(event);
    }
    if (event is PurchaseOrderListEvent) {
      yield* _mapPurchaseOrderListEventState1(event);
    }
    if (event is PurchaseOrderDeleteCallEvent) {
      yield* _mapPurchaseOrderDeleteCallEventState(event);
    }
    if (event is POApprovalListRequestEvent) {
      yield* _mapPOListRequestEventToState(event);
    }
    if (event is POApprovalSaveRequestEvent) {
      yield* _mapPoApprovalSaveRequestEventToState(event);
    }
    if (event is POApprovalStatusListRequestEvent) {
      yield* _mapPOApprovalStatusListRequestEventToState(event);
    }
    if (event is PODrpListRequestEvent) {
      yield* _mapPODrpListRequestEventToState(event);
    }
    if (event is SearchCustomerListByNameCallEvent) {
      yield* _mapSearchCustomerListByNameCallEventToState(event);
    }
    if (event is TaskCategoryListCallEvent) {
      yield* _mapTaskCategoryCallEventToState(event);
    }
    if (event is ModulesDropDownListRequestEvent) {
      yield* _mapModulesDropDownListCallEventToState(event);
    }
    if (event is SharvayaDailyActivityListEvent) {
      yield* _mapSharvayaDailyActivityListEventState(event);
    }
    if (event is SharvayaDailyActivityDeleteEvent) {
      yield* _mapSharvayaDailyActivityDeleteEventState(event);
    }
    if (event is SharvayaDailyActivitySaveCallEvent) {
      yield* _mapSharvayaDailyActivitySaveEventState(event);
    }
    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }
    if (event is PoKindAttListCallEvent) {
      yield* _mapPoKindAttListCallEventToState(event);
    }
    if (event is PoProjectListCallEvent) {
      yield* _mapPoProjectListCallEventToState(event);
    }
    if (event is PoTermsConditionCallEvent) {
      yield* _mapPoTermsConditionEventToState(event);
    }
    if (event is CustomerReportsListCallEvent) {
      yield* _mapCustomerReportsListCallEventToState(event);
    }
    if (event is InquiryListReportCallEvent) {
      yield* _mapInquiryListCallEventToState(event);
    }
    if (event is QuotationReportListCallEvent) {
      yield* _mapQuotationReportListCallEventToState(event);
    }
    if (event is MaterialOutwardListCallEvent) {
      yield* _mapMaterialOutwardCallEventToState(event);
    }
    if (event is MaterialOutwardDeleteCallEvent) {
      yield* _mapMaterialOutwardDeleteEventState(event);
    }
    if (event is MaterialOutwardAddEditCallEvent) {
      yield* _mapMaterialOutwardAddEditEventToState(event);
    }
    if (event is MaterialOutwardExportListRequestEvent) {
      yield* _mapMaterialOutwardExportListRequestEventToState(event);
    }
    if (event is MaterialOutwardGetSoNoRequestEvent) {
      yield* _mapMaterialOutwardGetSoNoRequestEventToState(event);
    }
    if (event is MaterialOutwardGetDetailsSoNoRequestEvent) {
      yield* _mapMaterialOutwardGetDetailsSoNoRequestEventToState(event);
    }
    if (event is GetMaterialOutwardProductListEvent) {
      yield* _mapGetMaterialOutwardProductListEventState(event);
    }
    if (event is MaterialOutwardProductOneDeleteEvent) {
      yield* _mapMaterialOutwardOneProductDeleteEventState(event);
    }
    if (event is MaterialOutwardConstantRequestEvent) {
      yield* _mapConstantRequestEventToState(event);
    }
    if (event is MaterialOutwardDetailsDeleteCallEvent) {
      yield* _mapMaterialOutwardDetailsDeleteEventState(event);
    }
    if (event is MaterialOutwardDetailsListCallEvent) {
      yield* _mapMaterialOutwardDetailsListEventState(event);
    }
    if (event is MaterialOutwardGetDetailsOutwardNoByFetchTypeRequestEvent) {
      yield* _mapMaterialOutwardGetDetailsOutwardNoByFetchTypeRequestEventToState(
          event);
    }
    if (event is SalesBillPDFGenerateCallEvent) {
      yield* _mapSalesBillPDFGenerateCallEventToState(event);
    }
    if (event is InvoiceDocumentListRequestEvent) {
      yield* _mapVehicleDocumentListEventState(event);
    }
    /*if (event is InvoiceDocumentOnlyNameListRequestEvent) {
      yield* _mapInvoiceDocumentOnlyNameListRequestEventState(event);
    }*/
    if (event is InvoiceDocumentOnlyNameListRequestEvent1) {
      yield* _mapInvoiceDocumentOnlyNameListRequestEventState1(event);
    }
    if (event is ModuleAttachmentsItemWiseDeleteRequestEvent) {
      yield* _mapModuleAttachmentsItemWiseDeleteRequestEventToState(event);
    }
    if (event is DefDocumentListRequestEvent) {
      yield* _mapVehicleDefDocumentListEventState(event);
    }
    if (event is MaintenanceTermsConditionCallEvent) {
      yield* _mapQuotationTermsConditionEventToState(event);
    }
    if (event is GetMaintenanceProductTableEvent) {
      yield* _mapGetMaintenanceProductListEventState(event);
    }
    if (event is MaintenanceOneProductDeleteEvent) {
      yield* _mapMaintenanceOneProductDeleteEventState(event);
    }

    ///Maintenance
    //_mapMaintenanceListCallEventToState
    if (event is MaintenanceListCallEvent) {
      yield* _mapMaintenanceListCallEventToState(event);
    }
    if (event is MaintenanceDeleteCallEvent) {
      yield* _mapMaintenanceDetailsDeleteEventState(event);
    }
    if (event is MaintenanceAddUpdateRequestCallEvent) {
      yield* _mapMaintenanceAddEditEventToState(event);
    }
    if (event is MaintenanceCheckListDRPRequestCallEvent) {
      yield* _mapMaintenanceCheckListDRPRequestCallEventToState(event);
    }
    if (event is MasterMaintenanceCheckListRequestCallEvent) {
      yield* _mapMasterMaintenanceCheckListRequestCallEventToState(event);
    }
    if (event is MasterMaintenanceCheckListRequestCallEvent1) {
      yield* _mapMasterMaintenanceCheckListRequestCallEventToState1(event);
    }
    if (event is InquiryLeadStatusTypeListByNameCallEvent) {
      yield* _mapFollowupInquiryStatusListCallEventToState(event);
    }
    if (event is MaintenanceDetailsListCallEvent) {
      yield* _mapMaintenanceDetailsListEventState(event);
    }
    if (event is ALLEmployeeNameCallEvent) {
      yield* _mapALLEmployeeNameListCallEventToState(event);
    }
    if (event is RepairingListCallEvent) {
      yield* _mapRepairingListCallEventToState(event);
    }
    if (event is RepairingDeleteCallEvent) {
      yield* _mapRepairingDetailsDeleteEventState(event);
    }
    if (event is RepairingAddUpdateRequestCallEvent) {
      yield* _mapRepairingAddEditEventToState(event);
    }
    if (event is RepairingListByDRPNameCallEvent) {
      yield* _mapRepairingListDRPCallEventToState(event);
    }
    if (event is UpdateAuditActivityDetailsTableEvent) {
      yield* _mapUpdateAuditActivityDetailsTableEventState(event);
    }
    if (event is RepairingDetailsListCallEvent) {
      yield* _mapRepairingDetailsListEventState(event);
    }
    if (event is RepairingLogListCallEvent) {
      yield* _mapRepairingLogListCallEventToState(event);
    }
    if (event is MaterialInwardListMeetCallEvent) {
      yield* _mapMaterialInwardListCallEventToStateMeet(event);
    }
    if (event is MaterialInwardDeleteCallEvent) {
      yield* _mapMaterialInwardDeleteEventState(event);
    }
    if (event is MaterialInwardCustomerListCallEvent) {
      yield* _mapCustomerListCallEventToState(event);
    }
    if (event is MaterialInwardMasterSaveEvent) {
      yield* _MaterialInwarddetailssaveState(event);
    }
    if (event is MaterialInwardDetailsListEvent) {
      yield* _mapMaterialInwardDetailsListEventState(event);
    }
    if (event is MaterialInwardDetailsDeleteEvent) {
      yield* _mapMaterialInwardDetailsDeleteEventState(event);
    }
    if (event is MaterialInwardDetailsListCallEvent) {
      yield* _mapMaterialInwardDetailsListCallEventToState(event);
    }
    if (event is LocationListCallEvent) {
      yield* _mapLocationListCallEventToState(event);
    }
    if (event is LocationLogListCallEvent) {
      yield* _mapLocationLogListCallEventToState(event);
    }
    if (event is MaterialInwardGetPoNoRequestEvent) {
      yield* _mapMaterialInwardGetPoNoRequestEventToState(event);
    }
    if (event is MaterialInwardGetDetailsPoNoRequestEvent) {
      yield* _mapMaterialInwardGetPoNoEventToState(event);
    }

    ///Service Report
    if (event is ServiceReportListEvent) {
      yield* _mapServiceReportListEventState1(event);
    }
    if (event is ServiceReportDeleteRequestEvent) {
      yield* _mapServiceReportDeleteEventState(event);
    }
    if (event is ServiceReportAddUpdateRequestEvent) {
      yield* _mapServiceReportAddUpdateRequestEventToState(event);
    }
    if (event is MachineTypeListCallEvent) {
      yield* _mapMachineTypeListCallEventToState(event);
    }
    if (event is ServiceReportDetailsListRequestEvent) {
      yield* _mapServiceReportDetailsListRequestEventToState(event);
    }
    if (event is ShortInvoiceListRequestEvent) {
      yield* _mapShortInvoiceListEventState1(event);
    }
    if (event is ShortInvoiceDeleteRequestEvent) {
      yield* _mapShortInvoiceDeleteEventState(event);
    }
    if (event is DeleteGenericAdditionalChargesEvent) {
      yield* _mapDeleteGenericAdditionalChargesEventToState(event);
    }
    if (event is PaymentScheduleListEvent) {
      yield* _mapPaymentScheduleListEventState(event);
    }
    if (event is PaymentScheduleDeleteAllItemEvent) {
      yield* _mapPaymentScheduleDeleteAllEventState(event);
    }
    if (event is GenericOtherChargeCallEvent) {
      yield* _mapGenericOtherChargeCallEventToState(event);
    }
    if (event is SaleBill_INQ_QT_SO_NO_ListRequestEvent) {
      yield* _mapSaleBill_INQ_QT_SO_NO_ListEventState(event);
    }
    if (event is AddGenericAdditionalChargesEvent) {
      yield* mapAddGeneric(event);
    }
    if (event is SaleOrderBankDetailsListRequestEvent) {
      yield* _map_bankDetailsEvent_state(event);
    }
    if (event is SaleOrderBankDetailsListDialogRequestEvent) {
      yield* _map_bankDetailsWithDialogEvent_state(event);
    }
    if (event is QuotationProjectListCallEvent) {
      yield* _mapQuotationProjectListCallEventToState(event);
    }
    if (event is QuotationTermsConditionCallEvent) {
      yield* _mapQuotationTermsConditionEventToState1(event);
    }
    if (event is SalesBillEmailContentRequestEvent) {
      yield* _mapSalesBillEmailContentEventState(event);
    }
    if (event is PaymentScheduleDeleteEvent) {
      yield* _mapPaymentScheduleDeleteEventState(event);
    }
    if (event is PaymentScheduleEvent) {
      yield* _mapPaymentScheduleEventState(event);
    }
    if (event is SearchCustomerListByNumberCallEvent) {
      yield* _mapSearchCustomerListByNumberCallEventToState(event);
    }
    if (event is MultiNoToProductDetailsRequestEvent) {
      yield* _mapMultiNoToProductDetailsRequestEventState(event);
    }
    if (event is SalesOrderAddressDropDownRequestEvent) {
      yield* _mapSalesOrderAddressDropDownRequestEventToState(event);
    }
    if (event is QuotationOtherChargeCallEvent) {
      yield* _mapQuotationOtherChargeListEventToState(event);
    }
    if (event is SalesOrderAddressORGDropDownRequestEvent) {
      yield* _mapSalesOrderAddressOrgDropDownRequestEventToState(event);
    }
    if (event is SaveEmailContentRequestEvent) {
      yield* _mapSaveEmailContentRequestEventState(event);
    }
    if (event is PaymentScheduleEditEvent) {
      yield* _mapPaymentScheduleEditEventState(event);
    }
    if (event is GetSIProductListEvent) {
      yield* _mapGetSIProductListEventState(event);
    }
    if (event is SIProductOneDeleteEvent) {
      yield* _mapSIOneProductDeleteEventState(event);
    }
    if (event is InsertProductEvent) {
      yield* _map_InsertProductEventState(event);
    }
    if (event is QuotationOtherCharge1CallEvent) {
      yield* _mapQuotationOtherCharge1ListEventToState(event);
    }
    if (event is GetGenericAdditionalChargesEvent) {
      yield* _mapGetGenericAdditionalChargesEventToState(event);
    }
    if (event is DeleteAllQuotationProductEvent) {
      yield* _mapDeleteAllQuotationProductEventState(event);
    }
    if (event is ShortInvoiceShipmentListRequestEvent) {
      yield* _mapShortInvoiceShipmentListListEventToState(event);
    }
    if (event is ShortInvoiceExportListRequestEvent) {
      yield* _mapShortInvoiceExportListListEventToState(event);
    }
    if (event is ShortInvoiceDetailsListRequestEvent) {
      yield* _mapShortInvoiceDetailsListRequestEventToState(event);
    }
    if (event is ShortInvoiceAddUpdateRequestEvent) {
      yield* _mapShortInvoiceAddUpdateEventToState(event);
    }
    if (event is ShortInvoiceProductSaveCallEvent) {
      yield* _mapShortInvoiceProductSaveCallEventState(event);
    }
    if (event is ShortInvoiceExportAddUpdateRequestEvent) {
      yield* _mapShortInvoiceExportAddUpdateCallEventState(event);
    }
    if (event is ShortInvoiceShipmentAddUpdateRequestEvent) {
      yield* _mapShortInvoiceShipmentAddUpdateCallEventState(event);
    }
    if (event is ShortInvoiceDetailsDeleteCallEvent) {
      yield* _mapShortInvoiceDetailsDeleteEventState(event);
    }
    if (event is ProductListRequestEvent) {
      yield* _mapProductMasterListEventToState(event);
    }
    if (event is ShortInvoiceAssemblyLoadListRequestEvent) {
      yield* _mapShortInvoiceAssemblyLoadListEventToState(event);
    }
    if (event is ShortInvoiceProductListRequestEvent) {
      yield* _mapShortInvoiceProductListEventToState(event);
    }
    if (event is PurchaseBillAddUpdateRequestEvent) {
      yield* _mapPurchaseBillAddUpdateEventToState(event);
    }
    if (event is PurchaseBillDetailsListRequestEvent) {
      yield* _mapPurchaseBillDetailsListRequestEventToState(event);
    }
    if (event is PurchaseBillDetailsDeleteCallEvent) {
      yield* _mapPurchaseBillDetailsDeleteEventState(event);
    }
    if (event is PurchaseBillDetailsAddUpdateCallEvent) {
      yield* _mapPurchaseBillDetailsAddUpdateCallEventState(event);
    }
    if (event is MultiNoToProductDetailsFromGrnRequestEvent) {
      yield* _mapMultiNoToProductDetailsFromGrnEventState(event);
    }
    if (event is MultiNoToProductDetailsFromPurchaseOrderRequestEvent) {
      yield* _mapMultiNoToProductDetailsFromPurchaseOrderEventState(event);
    }
    if (event is PurchaseBillACRequestEvent) {
      yield* _mapPurchaseBillACEventState(event);
    }
    if (event is PurchaseBillTODRequestEvent) {
      yield* _mapPurchaseBillTODEventState(event);
    }
    if (event is GetPOProductListEvent) {
      yield* _mapGetPOProductListEventState(event);
    }
    if (event is POProductOneDeleteEvent) {
      yield* _mapPOOneProductDeleteEventState(event);
    }
    if (event is ConstantRequestEvent) {
      yield* _mapConstantRequestNewEventToState(event);
    }
    if (event is InsertPOProductEvent) {
      yield* _map_insertPOProductEventState(event);
    }
    if (event is QuotationKindAttListCallEvent) {
      yield* _mapQuotationKindAttListCallEventToState(event);
    }
    if (event is QuotationOrganizationListRequestEvent) {
      yield* _mapQuotationOrganizationListRequestEventToState(event);
    }
    if (event is PurchaseOrderAddUpdateRequestEvent) {
      yield* _mapPurchaseOrderAddUpdateEventToState(event);
    }
    if (event is PurchaseOrderDetailsListRequestEvent) {
      yield* _mapPurchaseOrderDetailsListRequestEventToState(event);
    }
    if (event is PurchaseOrderDetailsDeleteCallEvent) {
      yield* _mapPurchaseOrderDetailsDeleteEventState(event);
    }
    if (event is PurchaseOrderDetailsAddUpdateCallEvent) {
      yield* _mapPurchaseOrderDetailsAddUpdateCallEventState(event);
    }
    if (event is PurchaseOrderShipmentListRequestEvent) {
      yield* _mapPurchaseOrderShipmentListEventToState(event);
    }
    if (event is PurchaseOrderShipmentAddUpdateRequestEvent) {
      yield* _mapPurchaseOrderShipmentAddUpdateCallEventState(event);
    }
    if (event is POFromTheIndentNumberEvent) {
      yield* _mapPOFromTheIndentNumberEventState(event);
    }
    if (event is PoTankerDrpListRequestEvent) {
      yield* _mapPoTankerDrpListEventState(event);
    }
    if (event is PoDriverDrpListRequestEvent) {
      yield* _mapPoDriverDrpListEventState(event);
    }
    if (event is PaySlipListListCallEvent) {
      yield* _mapPaySlipListListCallEventToState(event);
    }
    if (event is SalesOrderPDFGenerateCallEvent) {
      yield* _mapSalesOrderPDFGenerateCallEventToState(event);
    }
    if (event is VisitorInfoListCallRequestEvent) {
      yield* _mapVisitorInfoListCallRequestEventToState(event);
    }
    if (event is VisitorInfoDeleteCallRequestEvent) {
      yield* _mapVisitorInfoDeleteCallRequestEventToState(event);
    }
    if (event is VisitorInfoAddUpdateCallRequestEvent) {
      yield* _mapVisitorInfoAddUpdateCallRequestEventToState(event);
    }
    if (event is CountryCallEvent) {
      yield* _mapCountryListCallEventToState(event);
    }
    if (event is StateCallEvent) {
      yield* _mapStateListCallEventToState(event);
    }
    if (event is CityCallEvent) {
      yield* _mapCityListCallEventToState(event);
    }
    if (event is SOCustomerNearByPinCodeSummaryRequestEvent) {
      yield* _mapSOCustomerNearByPinCodeSummaryRequestEventToState(event);
    }
    if (event is SOCustomerNearByPinCodeDetailsRequestEvent) {
      yield* _mapSOCustomerNearByPinCodeDetailsRequestEventToState(event);
    }
    if (event is InquiryProductSearchNameCallEvent) {
      yield* _mapInquiryProductSearchCallEventToState(event);
    }
    if (event is SOCurrencyListRequestEvent) {
      yield* _mapSOCurrencyListRequestEventToState(event);
    }
    if (event is MaterialIndentListRequestEvent) {
      yield* _mapMaterialIndentListRequestEventState(event);
    }
    if (event is MaterialIndentApprovalUpdateRequestEvent) {
      yield* _mapMaterialIndentApprovalUpdateRequestEventToState(event);
    }
    if (event is MultiExpenseListRequestEvent) {
      yield* _mapMultiExpenseListRequestEventToState(event);
    }
    if (event is MultiExpenseDeleteRequestEvent) {
      yield* _mapMultiExpenseDeleteRequestEventToState(event);
    }
    if (event is MultiExpenseAddUpdateRequestEvent) {
      yield* _mapMultiExpenseAddUpdateRequestEventToState(event);
    }
    if (event is MultiExpenseADetailsListRequestEvent) {
      yield* _mapMultiExpenseDetailsListRequestEventToState(event);
    }
    if (event is MultiExpenseTypeListRequestEvent) {
      yield* _mapMultiExpenseTypeListRequestEventToState(event);
    }
    if (event is MultiExpenseModeListRequestEvent) {
      yield* _mapMultiExpenseModeListRequestEventToState(event);
    }
    if (event is ExpenseCustomerListCallRequestEvent) {
      yield* _mapExpenseCustomerListCallEventToState(event);
    }
    if (event is DebitCreditNotesListCallRequestEvent) {
      yield* _mapDebitCreditNotesListCallRequestForDbEventToState(event);
    }
    if (event is DebitCreditNotesListCallRequestEvent) {
      yield* _mapDebitCreditNotesListCallRequestForCrEventToState(event);
    }
    if (event is JournalVoucherMstAssetListCallRequestEvent) {
      yield* _mapJournalVoucherMstAssetListCallRequestForJVEventToState(event);
    }
    if (event is AssetIssueListCallRequestEvent) {
      yield* _mapAssetIssueListCallRequestEventToState(event);
    }
    if (event is PettyCashListCallRequestEvent) {
      yield* _mapPettyCashListCallRequestEventToState(event);
    }
    if (event is AssetReturnListCallRequestEvent) {
      yield* _mapAssetReturnListCallRequestEventToState(event);
    }
    if (event is OfficeRefTypeFromCustomerIDRequestEvent) {
      yield* _mapOfficeRefTypeFromCustomerIDRequestEventToState(event);
    }
    if (event is MultiExpenseApprovalListRequestEvent) {
      yield* _mapMultiExpenseApprovalListRequestEventToState(event);
    }
    if (event is MultiExpenseApprovalStatusListRequestEvent) {
      yield* _mapMultiExpenseApprovalStatusListRequestEventToState(event);
    }
    if (event is MultiExpenseApprovalUpdateRequestEvent) {
      yield* _mapMultiExpenseApprovalUpdateRequestEventToState(event);
    }
    if (event is QuickFollowupReportListRequestEvent) {
      yield* _mapQuickFollowupReportListRequestEventToState(event);
    }
    if (event is ExpenseTrackingListCallEvent) {
      yield* _mapExpenseTrackingListCallEventToState(event);
    }
    if (event is ExpenseTrackingSaveCallEvent) {
      yield* _mapExpenseTrackingSaveCallEventToState(event);
    }
  }

  ///event functions to states implementation
  Stream<MainStates> _mapMayankBankVoucherListEventState(
      MayankBankVoucherListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MayankBankVoucherListResponse response =
          await userRepository.MayankBankVoucherList(
              event.pageNo, event.mayankBankVoucherListRequest);
      yield MayankBankVoucherListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMayankBankVoucherDeleteEventState(
      MayankBankVoucherDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository.MayankBankVoucherDeleteAPI(
          event.mayankBankVoucherDeleteRequest);
      yield MayankBankVoucherDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapFollowupCustomerListByNameCallEventToState(
      MayankSearchBankVoucherCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield MayankBankVoucherCustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapTransectionModeCallEventToState(
      MayankTransectionModeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      TransectionModeListResponse bankVoucherDeleteResponse =
          await userRepository.getTransectionModeList(event.request);
      yield MayankTransectionModeResponseState(bankVoucherDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapBankVoucherModeCallEventToState(
      MayankBankVoucherModeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MayankBankVoucherInqNoResponse bankVoucherDeleteResponse =
          await userRepository.getBankVoucherModeList(event.request);
      yield MayankBankVoucherModeResponseState(bankVoucherDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  
  Stream<MainStates> _mapBankVoucherAmountCallEventToState(
      MayankBankVoucherAmountCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MayankBankVoucherAmountResponse bankVoucherDeleteResponse =
          await userRepository.getBankVoucherAmountList(event.request);
      yield MayankBankVoucherAmountResponseState(bankVoucherDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSavedBankVoucherCallEventToState(
      MayankBankVoucherSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MayankBankVoucherAddEditResponse bankVoucherDeleteResponse =
          await userRepository
              .getbankvoucherSaveedit(event.mayankBankVoucherAddEditRequest);

      if (bankVoucherDeleteResponse.details[0].column1.toString() != "-1") {
        ///Details Delete

        MayankBankVoucherDetailsListRequest
            mayankBankVoucherDetailsListRequest =
            MayankBankVoucherDetailsListRequest(
                ParentID: bankVoucherDeleteResponse.details[0].column4,
                InvoiceNo: "",
                LoginUserID: event.mayankBankVoucherAddEditRequest.LoginUserID,
                CompanyId: event.mayankBankVoucherAddEditRequest.CompanyId);

        MayankBankVoucherDetailsListResponse respotemplist =
            await userRepository.MayankBankVoucherDetailsList(
                0, mayankBankVoucherDetailsListRequest);

        if (respotemplist.details.length != 0) {
          for (int i = 0; i < respotemplist.details.length; i++) {
            MayankBankVoucherDeleteDetailsRequest
                mayankBankVoucherDeleteDetailsRequest =
                MayankBankVoucherDeleteDetailsRequest(
                    pkID: respotemplist.details[i].pkID,
                    CompanyId: event.mayankBankVoucherAddEditRequest.CompanyId
                        .toString());

            String respotempdelete =
                await userRepository.MayankBankVoucherDeleteDetailsAPI(
                    mayankBankVoucherDeleteDetailsRequest);

            print("deletemaintenacne" + respotempdelete.toString());
          }
        }

        ///Details Save

        List<BankVoucherDetailsTable> temp =
            await OfflineDbHelper.getInstance().getBankVoucher();

        if (temp.length != 0) {
          temp.forEach((element) {
            element.ParentID =
                bankVoucherDeleteResponse.details[0].column4.toString();
            element.LoginUserID =
                event.mayankBankVoucherAddEditRequest.LoginUserID;
            element.CompanyId =
                event.mayankBankVoucherAddEditRequest.CompanyId.toString();
          });
          await userRepository.MayankBankVoucherAddEditDetailsAPI1(temp);
        }
      }

      yield MayankBankVoucherSaveResponseState(bankVoucherDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMayankBankVoucherDetailsListEventState(
      MayankBankVoucherDetailsListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MayankBankVoucherDetailsListResponse response =
          await userRepository.MayankBankVoucherDetailsList(
              event.pageNo, event.mayankBankVoucherDetailsListRequest);

      if (response.details.length != 0) {
        await OfflineDbHelper.getInstance().deleteAllBankVoucher();
        for (var i = 0; i < response.details.length; i++) {
          String InvoiceNo = response.details[i].invoiceNo;
          String Amount = response.details[i].amount.toString();

          await OfflineDbHelper.getInstance()
              .insertBankVoucher(BankVoucherDetailsTable(
            "0",
            "",
            InvoiceNo,
            Amount,
            "",
            "",
          ));
        }
      }

      yield MayankBankVoucherDetailsListResponseState(
          "Detail Added Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMayankBankVoucherDeleteDetailsEventState(
      MayankBankVoucherDeleteDetailsEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository.MayankBankVoucherDeleteDetailsAPI(
          event.mayankBankVoucherDeleteDetailsRequest);
      yield MayankBankVoucherDeleteDetailsResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMayankBankVoucherDetailsAddEditEventState(
      MayankBankVoucherDetailsAddEditEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MayankBankVoucherDetailsAddEditResponse respo =
          await userRepository.MayankBankVoucherAddEditDetailsAPI(
              event.mayankBankVoucherDetailsAddEditRequest);
      yield MayankBankVoucherDetailsAddEditResponseState(event.context, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMayankBankVoucherDetailsAddEditEventState1(
      MayankBankVoucherDetailsAddEditEvent1 event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MayankBankVoucherDetailsAddEditResponse respo =
          await userRepository.MayankBankVoucherAddEditDetailsAPI1(
              event._contactsList);
      yield MayankBankVoucherDetailsAddEditResponseState1(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  /// Purchase_Order AND Purchase_Bill
  Stream<MainStates> _mapPurchaseBillListEventState1(
      PurchaseBillListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PurchaseBillListResponse respo = await userRepository.PurchaseBillAPI(
          event.pageNo, event.purchaseBillListRequest);
      yield PurchaseBillListResponseState(event.pageNo, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseBillDeleteEventState(
      PurchaseBillDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository
          .getPurchaseBillDeleteApi(event.purchaseBillDeleteDeleteRequest);
      yield PurchaseBillDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapGetPBProductListEventState(
      GetPBProductListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<PurchaseBillTable> response =
          await OfflineDbHelper.getInstance().getPurchaseBillProduct();
      yield GetPBProductListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _map_insertPBProductEventState(
      InsertPBProductEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteALLPurchaseBillProduct();
      await OfflineDbHelper.getInstance().deleteALLGenericAddditionalCharges();

      for (int i = 0; i < event.quotationTable.length; i++) {
        await OfflineDbHelper.getInstance()
            .insertPurchaseBillProduct(PurchaseBillTable(
          event.quotationTable[i].pkID, //int pkID,
          event.quotationTable[i].InvoiceNo, //String InvoiceNo,
          event.quotationTable[i].OrderNo, //String OrderNo,
          event.quotationTable[i].ProductID, //int ProductID,
          event.quotationTable[i].ProductName, //String ProductName,
          event.quotationTable[i]
              .ProductSpecification, //String ProductSpecification,
          event.quotationTable[i].LocationID, //int LocationID,
          event.quotationTable[i].TaxType, //int TaxType,
          event.quotationTable[i].Qty, //double Qty,
          event.quotationTable[i].Rate, //double Rate,
          event.quotationTable[i].DiscountPer, //double DiscountPer,
          event.quotationTable[i].DiscountAmt, //double DiscountAmt,
          event.quotationTable[i].NetRate, //double NetRate,
          event.quotationTable[i].Amount, //double Amount,
          event.quotationTable[i].CGSTPer, //double CGSTPer,
          event.quotationTable[i].SGSTPer, //double SGSTPer,
          event.quotationTable[i].IGSTPer, //double IGSTPer,
          event.quotationTable[i].CGSTAmt, //double CGSTAmt,
          event.quotationTable[i].SGSTAmt, //double SGSTAmt,
          event.quotationTable[i].IGSTAmt, //double IGSTAmt,
          event.quotationTable[i].AddTaxPer, //double AddTaxPer,
          event.quotationTable[i].AddTaxAmt, //double AddTaxAmt,
          event.quotationTable[i].NetAmt, //double NetAmt,
          event.quotationTable[i].HeaderDiscAmt, //double HeaderDiscAmt,
          event.quotationTable[i].Unit, //String Unit,
          event.quotationTable[i].StateCode, //int StateCode,
          event.quotationTable[i].LoginUserID, //String LoginUserID,
          event.quotationTable[i].CompanyId, //String CompanyId,
        ));
      }

      yield InsertProductSuccessResponseState("Inserted Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPBOneProductDeleteEventState(
      PBProductOneDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .deletePurchaseBillProduct(event.tableId);
      yield SIProductOneDeleteState("Product Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSearchCustomerListByNameCallEventToState(
      SearchCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield SearchCustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapTaskCategoryCallEventToState(
      TaskCategoryListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      TaskCategoryResponse customerDeleteResponse = await userRepository
          .taskCategoryDetails(event.taskCategoryListRequest);
      yield TaskCategoryCallResponseState(customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapModulesDropDownListCallEventToState(
      ModulesDropDownListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ModulesDropDownListResponse customerDeleteResponse =
          await userRepository.ModulesDropDownListApi(
              event.taskCategoryListRequest);
      yield ModulesDropDownListResponseState(customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSharvayaDailyActivityListEventState(
      SharvayaDailyActivityListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      SharvayaDailyActivityListResponse response =
          await userRepository.SharvayaDailyActivity(
              event.pageNo, event.sharvayaDailyActivityListRequest);
      yield SharvayaDailyActivityListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSharvayaDailyActivityDeleteEventState(
      SharvayaDailyActivityDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository.SharvayaDailyActivityDeleteAPI(
          event.sharvayaDailyActivityDeleteRequest);
      yield SharvayaDailyActivityDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSharvayaDailyActivitySaveEventState(
      SharvayaDailyActivitySaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      SharvayaDailyActivitySaveResponse respo =
          await userRepository.SharvayaDailyActivitySaveAPI(
              event.sharvayaDailyActivitySaveRequest);
      yield SharvayaDailyActivitySaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapUserMenuRightsRequestEventState(
      UserMenuRightsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      UserMenuRightsResponse respo = await userRepository.user_menurightsapi(
          event.MenuID, event.userMenuRightsRequest);
      yield UserMenuRightsResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPoKindAttListCallEventToState(
      PoKindAttListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationKindAttListResponse response =
          await userRepository.getQuotationKindAttList(event.request);
      yield PoKindAttListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPoProjectListCallEventToState(
      PoProjectListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationProjectListResponse response =
          await userRepository.getQuotationProjectList(event.request);
      yield PoProjectListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPoTermsConditionEventToState(
      PoTermsConditionCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationTermsCondtionResponse response =
          await userRepository.getQuotationTermConditionList(event.request);
      yield PoTermsConditionResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///Reports
  Stream<MainStates> _mapCustomerReportsListCallEventToState(
      CustomerReportsListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerDetailsResponse response =
          await userRepository.getCustomerReportsList(
              event.pageNo, event.customerPaginationRequest);
      yield CustomerReportsCallState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapInquiryListCallEventToState(
      InquiryListReportCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryListResponse response = await userRepository.getInquiryList(
          event.pageNo, event.inquiryListApiRequest);
      yield InquiryListResponseCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapQuotationReportListCallEventToState(
      QuotationReportListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationListResponse response = await userRepository.getQuotationList(
          event.pageNo, event.quotationListApiRequest);
      yield QuotationReportListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  /// outward
  Stream<MainStates> _mapMaterialOutwardCallEventToState(
      MaterialOutwardListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MaterialOutwardListMainResponse response =
          await userRepository.getMaterialOutwardList(
              event.pageNo, event.materialOutwardListRequest);
      yield MaterialOutwardListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialOutwardDeleteEventState(
      MaterialOutwardDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository
          .getMaterialOutwardDelete(event.materialOutwardDeleteRequest);
      yield MaterialOutwardDeleteCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialOutwardAddEditEventToState(
      MaterialOutwardAddEditCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MaterialOutwardAddUpdateResponse materialOutwardAddUpdateResponse =
          await userRepository
              .getMaterialOutwardAddEdit(event.materialOutwardAddUpdateRequest);

      MaterialOutwardExportSaveRequest materialOutwardExportSaveRequest =
          MaterialOutwardExportSaveRequest();

      materialOutwardExportSaveRequest.OutwardNo =
          materialOutwardAddUpdateResponse.details[0].column3;
      materialOutwardExportSaveRequest.PreCarrBy =
          event.materialOutwardExportSaveRequest.PreCarrBy;
      materialOutwardExportSaveRequest.PreCarrRecPlace =
          event.materialOutwardExportSaveRequest.PreCarrRecPlace;
      materialOutwardExportSaveRequest.FlightNo =
          event.materialOutwardExportSaveRequest.FlightNo;
      materialOutwardExportSaveRequest.PortOfLoading =
          event.materialOutwardExportSaveRequest.PortOfLoading;
      materialOutwardExportSaveRequest.PortOfDispatch =
          event.materialOutwardExportSaveRequest.PortOfDispatch;
      materialOutwardExportSaveRequest.PortOfDestination =
          event.materialOutwardExportSaveRequest.PortOfDestination;
      materialOutwardExportSaveRequest.MarksNo =
          event.materialOutwardExportSaveRequest.MarksNo;
      materialOutwardExportSaveRequest.Packages =
          event.materialOutwardExportSaveRequest.Packages;
      materialOutwardExportSaveRequest.NetWeight =
          event.materialOutwardExportSaveRequest.NetWeight;
      materialOutwardExportSaveRequest.GrossWeight =
          event.materialOutwardExportSaveRequest.GrossWeight;
      materialOutwardExportSaveRequest.PackageType =
          event.materialOutwardExportSaveRequest.PackageType;
      materialOutwardExportSaveRequest.FreeOnBoard =
          event.materialOutwardExportSaveRequest.FreeOnBoard;
      materialOutwardExportSaveRequest.LoginUserID =
          event.materialOutwardExportSaveRequest.LoginUserID;
      materialOutwardExportSaveRequest.CompanyId =
          event.materialOutwardExportSaveRequest.CompanyId;

      await userRepository.getMaterialOutwardExportSaveAPI(
          materialOutwardAddUpdateResponse.details[0].column3,
          materialOutwardExportSaveRequest);

      if (materialOutwardAddUpdateResponse.details.length != 0) {
        //await OfflineDbHelper.getInstance().deleteALLAuditActivityDetailsTable();

        for (var i = 0;
            i < materialOutwardAddUpdateResponse.details.length;
            i++) {
          MaterialOutwardDetailsDeleteRequest
              materialOutwardDetailsDeleteRequest =
              MaterialOutwardDetailsDeleteRequest(
            OutwardNo: materialOutwardAddUpdateResponse.details[0].column3,
            CompanyId: event.materialOutwardAddUpdateRequest.CompanyId,
          );

          await userRepository.getMaterialOutwardDetailsDelete(
              materialOutwardDetailsDeleteRequest);

          /// save

          List<MaterialOutwardTable> materialOutwardInsert =
              await OfflineDbHelper.getInstance().getMaterialOutwardProduct();

          List<MaterialOutwardTable> tempquotationSpecList = [];

          if (materialOutwardInsert.length != 0) {
            for (int j = 0; j < materialOutwardInsert.length; j++) {
              tempquotationSpecList.add(MaterialOutwardTable(
                materialOutwardInsert[j].pkID, //int    pkID,
                materialOutwardAddUpdateResponse
                    .details[0].column3, //String OutwardNo,
                materialOutwardInsert[j].ProductID, //int    ProductID,
                materialOutwardInsert[j].ProductName, //String ProductName,
                materialOutwardInsert[j].Quantity, //double Quantity,
                materialOutwardInsert[j]
                    .ProductSpecification, //String ProductSpecification,
                materialOutwardInsert[j]
                    .QuantityWeight, //double QuantityWeight,
                materialOutwardInsert[j].SerialNo, //String SerialNo,
                materialOutwardInsert[j].BoxNo, //String BoxNo,
                materialOutwardInsert[j].Unit, //String Unit,
                materialOutwardInsert[j].UnitRate, //double UnitRate,
                materialOutwardInsert[j]
                    .DiscountPercent, //double DiscountPercent,
                materialOutwardInsert[j].NetRate, //double NetRate,
                materialOutwardInsert[j].Amount, //double Amount,
                materialOutwardInsert[j].TaxRate, //double TaxRate,
                materialOutwardInsert[j].TaxAmount, //double TaxAmount,
                materialOutwardInsert[j].NetAmount, //double NetAmount,
                materialOutwardInsert[j].OrderNo, //String OrderNo,
                materialOutwardInsert[j].LocationID, //int    LocationID,
                materialOutwardInsert[j].IGSTPer, //double IGSTPer,
                materialOutwardInsert[j].DiscountAmt, //double DiscountAmt,
                materialOutwardInsert[j].SGSTAmt, //double SGSTAmt,
                materialOutwardInsert[j].CGSTAmt, //double CGSTAmt,
                materialOutwardInsert[j].IGSTAmt, //double IGSTAmt,
                materialOutwardInsert[j]
                    .SampleQuantity, //double SampleQuantity,
                materialOutwardInsert[j].DateCode, //String DateCode,
                materialOutwardInsert[j].TaxType, //int    TaxType,
                materialOutwardInsert[j].SGSTPer, //double SGSTPer,
                materialOutwardInsert[j].CGSTPer, //double CGSTPer,
                materialOutwardInsert[j].StateCode, //int    StateCode,
                materialOutwardInsert[j].LoginUserID, //String LoginUserID,
                materialOutwardInsert[j].CompanyId, //String CompanyId,
              ));
            }
            await userRepository
                .getMaterialOutwardDetailsAddUpdate(tempquotationSpecList);
          }
        }
      }

      if (materialOutwardAddUpdateResponse.details[0].column1.toString() !=
          "-1") {
        await userRepository.InvoiceDocumentDeleteAPI(
            MaterialOutwardDocumentDeleteRequest(
                KeyValue: materialOutwardAddUpdateResponse.details[0].column3
                    .toString(),
                ModuleName: "outward",
                LoginUserID: event.materialOutwardAddUpdateRequest.LoginUserID,
                CompanyId: event.materialOutwardAddUpdateRequest.CompanyId
                    .toString()));

        await userRepository.InvoiceDocumentDeleteAPI(
            MaterialOutwardDocumentDeleteRequest(
                KeyValue: materialOutwardAddUpdateResponse.details[0].column3
                    .toString(),
                ModuleName: "outward-sales",
                LoginUserID: event.materialOutwardAddUpdateRequest.LoginUserID,
                CompanyId: event.materialOutwardAddUpdateRequest.CompanyId
                    .toString()));

        if (event.invoiceDocumentList.length != 0) {
          for (int i = 0; i < event.invoiceDocumentList.length; i++) {
            print("sfdsdssf789" + event.invoiceDocumentList[i].path.toString());

            if (event.invoiceDocumentList[i].path != "") {
              var getextention =
                  event.invoiceDocumentList[i].path.split('/').last.split(".");
              await userRepository.getinvoicedocumentuploadapi(
                event.invoiceDocumentList[i],
                MaterialOutwardDocumentUploadRequest(
                  pkID: "0",
                  ModuleName: "outward",
                  DocName: "Outward" +
                      "-" +
                      materialOutwardAddUpdateResponse.details[0].column3
                          .toString() +
                      "-" +
                      event.invoiceDocumentList[i].path
                          .split('/')
                          .last
                          .toString()
                          .trim(),
                  KeyValue: materialOutwardAddUpdateResponse.details[0].column3
                      .toString(),
                  LoginUserID:
                      event.materialOutwardAddUpdateRequest.LoginUserID,
                  CompanyId: event.materialOutwardAddUpdateRequest.CompanyId
                      .toString(),
                ),
              );
            }
          }
        }

        if (event.invoiceDocumentList1.length != 0) {
          for (int i = 0; i < event.invoiceDocumentList1.length; i++) {
            print(
                "sfdsdssf789" + event.invoiceDocumentList1[i].path.toString());

            if (event.invoiceDocumentList1[i].path != "") {
              var getextention =
                  event.invoiceDocumentList1[i].path.split('/').last.split(".");
              await userRepository.getinvoicedocumentuploadapi(
                event.invoiceDocumentList1[i],
                MaterialOutwardDocumentUploadRequest(
                  pkID: "0",
                  ModuleName: "outward-sales",
                  DocName: "Outward-sales" +
                      "-" +
                      materialOutwardAddUpdateResponse.details[0].column3
                          .toString() +
                      "-" +
                      event.invoiceDocumentList1[i].path
                          .split('/')
                          .last
                          .toString()
                          .trim(),
                  KeyValue: materialOutwardAddUpdateResponse.details[0].column3
                      .toString(),
                  LoginUserID:
                      event.materialOutwardAddUpdateRequest.LoginUserID,
                  CompanyId: event.materialOutwardAddUpdateRequest.CompanyId
                      .toString(),
                ),
              );
            }
          }
        }
      }

      yield MaterialOutwardAddUpdateCallResponseState(
          materialOutwardAddUpdateResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialOutwardExportListRequestEventToState(
      MaterialOutwardExportListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaterialOutwardExportListMainResponse response =
          await userRepository.getMaterialOutwardExportListAPI(event.request);

      yield MaterialOutwardExportListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialOutwardGetSoNoRequestEventToState(
      MaterialOutwardGetSoNoRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaterialOutwardPendingSalesOrderListResponse response =
          await userRepository.getMaterialOutwardGetSoNoAPI(
              event.materialOutwardPendingSalesOrderListRequest);

      yield MaterialOutwardGetSoNoResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialOutwardGetDetailsSoNoRequestEventToState(
      MaterialOutwardGetDetailsSoNoRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaterialOutwardPendingSalesOrderDetailsListResponse response =
          await userRepository.getMaterialOutwardGetDetailsSoNoAPI(
              event.materialOutwardPendingSalesOrderDetailsListRequest);

      yield MaterialOutwardGetDetailsSoNoResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapGetMaterialOutwardProductListEventState(
      GetMaterialOutwardProductListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<MaterialOutwardTable> response =
          await OfflineDbHelper.getInstance().getMaterialOutwardProduct();

      yield GetMaterialOutwardProductListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialOutwardOneProductDeleteEventState(
      MaterialOutwardProductOneDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .deleteMaterialOutwardProduct(event.tableId);

      yield SBMaterialOutwardOneDeleteState("Product Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapConstantRequestEventToState(
      MaterialOutwardConstantRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ConstantResponse respo =
          await userRepository.getConstantAPI(event.CompanyID, event.request);
      yield MaterialOutwardConstantResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialOutwardDetailsDeleteEventState(
      MaterialOutwardDetailsDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository.getMaterialOutwardDetailsDelete(
          event.materialOutwardDetailsDeleteRequest);
      yield MaterialOutwardDetailsDeleteCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialOutwardDetailsListEventState(
      MaterialOutwardDetailsListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaterialOutwardDetailsListResponse response =
          await userRepository.getMaterialOutwardDetailsList(
              event.materialOutwardDetailsListRequest);

      if (response.details.length != 0) {
        await OfflineDbHelper.getInstance().deleteALLMaterialOutwardProduct();

        for (var i = 0; i < response.details.length; i++) {
          int DisPer = response.details[i].discountPercent;

          await OfflineDbHelper.getInstance()
              .insertMaterialOutwardProduct(MaterialOutwardTable(
            response.details[i].pkID, //int pkID,
            response.details[i].outwardNo, //String OutwardNo,
            response.details[i].productID, //int ProductID,
            response.details[i].productName, //String ProductName,
            response.details[i].quantity, //double Quantity,
            response
                .details[i].productSpecification, //String ProductSpecification,
            response.details[i].quantityWeight, //double QuantityWeight,
            response.details[i].serialNo, //String SerialNo,
            response.details[i].boxNo, //String BoxNo,
            response.details[i].unit, //String Unit,
            response.details[i].unitRate, //double UnitRate,
            DisPer.toDouble(), //double DiscountPercent,
            response.details[i].netRate, //double NetRate,
            response.details[i].amount, //double Amount,
            response.details[i].taxRate, //double TaxRate,
            response.details[i].taxAmount, //double TaxAmount,
            response.details[i].netAmount, //double NetAmount,
            response.details[i].orderNo, //String OrderNo,
            response.details[i].locationID, //int LocationID,
            response.details[i].iGSTPer, //double IGSTPer,
            response.details[i].discountAmt, //double DiscountAmt,
            response.details[i].sGSTAmt, //double SGSTAmt,
            response.details[i].cGSTAmt, //double CGSTAmt,
            response.details[i].iGSTAmt, //double IGSTAmt,
            response.details[i].sampleQuantity, //double SampleQuantity,
            response.details[i].dateCode, //String DateCode,
            response.details[i].taxType, //int TaxType,
            response.details[i].sGSTPer, //double SGSTPer,
            response.details[i].cGSTPer, //double CGSTPer,
            event.StateCode, //int StateCode,
            event.LoginUserId, //String LoginUserID,
            event.materialOutwardDetailsListRequest
                .CompanyId, //String CompanyId,
          ));
        }
      }

      yield MaterialOutwardDetailsListCallResponseState(
          event.StateCode, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates>
      _mapMaterialOutwardGetDetailsOutwardNoByFetchTypeRequestEventToState(
          MaterialOutwardGetDetailsOutwardNoByFetchTypeRequestEvent
              event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaterialOutwardPendingSalesOrderDetailsByFetchTypeListResponse response =
          await userRepository
              .getMaterialOutwardGetDetailsOutwardNoByFetchTypeAPI(event
                  .materialOutwardPendingSalesOrderByFetchTypeDetailsListRequest);

      yield MaterialOutwardGetDetailsOutwardNoBYFetchTypeResponseState(
          response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSalesBillPDFGenerateCallEventToState(
      SalesBillPDFGenerateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesBillPDFGenerateResponse response =
          await userRepository.getSalesBillPDFGenerate(event.request);
      yield SalesBillPDFGenerateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapVehicleDocumentListEventState(
      InvoiceDocumentListRequestEvent event) async* {
    try {
      print("uuuuuuu");
      baseBloc.emit(ShowProgressIndicatorState(true));

      //call your api as follows
      MaterialOutwardDocumentListResponse response =
          await userRepository.InvoiceDocumentListAPI(
              event.vehicleModuleListRequest);

      List<File> DocumentList = [];
      for (int i = 0; i < response.details.length; i++) {
        /*File file = await userRepository.getDocumentFile(
            event.SiteURL + "/ModuleDocs/", response.details[i].docName);*/

        try {
          String uriString = event.SiteURL +
              "/ModuleDocs/" +
              response.details[i].docName; // Uri string

          try {
            Directory dir = await path_provider.getTemporaryDirectory();
            dir.exists();
            String pathName = path.join(dir.path, response.details[i].docName);

            await Dio().download(uriString, pathName);
            print("Download Completed.");

            File file = await toFile(pathName);
            DocumentList.add(file);
          } catch (e) {
            print("Download Failed.\n\n" + e.toString());
          }
        } on UnsupportedError catch (e) {
          print(e.message); // Unsupported error for uri not supported
        } on IOException catch (e) {
          print(e); // IOException for system error
        } catch (e) {
          print(e); // General exception
        }
      }

      yield InvoiceDocumentListResponseState(
          response, event.paginationmodel, DocumentList);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  /*Stream<MainStates> _mapInvoiceDocumentOnlyNameListRequestEventState(
      InvoiceDocumentOnlyNameListRequestEvent event) async* {
    try {
      print("uuuuuuu");
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaterialOutwardDocumentListResponse response =
          await userRepository.InvoiceDocumentListAPI(
              event.vehicleModuleListRequest);

      yield InvoiceDocumentOnlyNameListResponseState(
          response, event.paginationmodel, );
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

  Stream<MainStates> _mapInvoiceDocumentOnlyNameListRequestEventState1(
      InvoiceDocumentOnlyNameListRequestEvent1 event) async* {
    try {
      print("uuuuuuu");
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaterialOutwardDocumentListResponse response =
          await userRepository.InvoiceDocumentListAPI(
              event.vehicleModuleListRequest);

      MaterialOutwardExportListMainResponse responseExport =
          await userRepository
              .getMaterialOutwardExportListAPI(event.soExportListRequest);

      yield InvoiceDocumentOnlyNameListResponseState1(
          response, event.paginationmodel, responseExport);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapModuleAttachmentsItemWiseDeleteRequestEventToState(
      ModuleAttachmentsItemWiseDeleteRequestEvent event) async* {
    try {
      print("uuuuuuu");
      baseBloc.emit(ShowProgressIndicatorState(true));

      //call your api as follows
      ModuleAttachmentItemWiseDeleteResponse signatureListResponse =
          await userRepository.moduleattachmentdeleteItemWiseAPI(
              event.moduleAttachmentsItemWiseDeleteRequest);

      yield ModuleAttachmentItemWiseDeleteResponseState(signatureListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapVehicleDefDocumentListEventState(
      DefDocumentListRequestEvent event) async* {
    try {
      print("uuuuuuu");
      baseBloc.emit(ShowProgressIndicatorState(true));

      //call your api as follows
      MaterialOutwardDocumentListResponse response =
          await userRepository.InvoiceDocumentListAPI(
              event.vehicleModuleListRequest);

      MaterialOutwardExportListMainResponse responseExport =
          await userRepository
              .getMaterialOutwardExportListAPI(event.soExportListRequest);

      List<File> DocumentList = [];
      List<File> DocumentListForSlip = [];

      for (int i = 0; i < response.details.length; i++) {
        String uriString = event.SiteURL +
            "/ModuleDocs/" +
            response.details[i].docName; // Uri string

        /*File file = await userRepository.getDocumentFile(
            event.SiteURL + "/ModuleDocs/", response.details[i].docName);*/

        try {
          String uriString = event.SiteURL +
              "/ModuleDocs/" +
              response.details[i].docName; // Uri string

          try {
            Directory dir = await path_provider.getTemporaryDirectory();
            dir.exists();
            String pathName = path.join(dir.path, response.details[i].docName);

            await Dio().download(uriString, pathName);
            print("Download Completed.");

            File file = await toFile(pathName);
            DocumentList.add(file);
          } catch (e) {
            print("Download Failed.\n\n" + e.toString());
          }
        } on UnsupportedError catch (e) {
          print(e.message); // Unsupported error for uri not supported
        } on IOException catch (e) {
          print(e); // IOException for system error
        } catch (e) {
          print(e); // General exception
        }
      }

      MaterialOutwardModuleListRequest invoiceModuleListRequest1 =
          MaterialOutwardModuleListRequest(
              pkID: "0",
              SearchKey: "",
              ModuleName: "outward-sales",
              DocName: "",
              KeyValue: event.vehicleModuleListRequest.KeyValue,
              LoginUserID: event.vehicleModuleListRequest.LoginUserID,
              CompanyId: event.vehicleModuleListRequest.CompanyId.toString());

      MaterialOutwardDocumentListResponse response1 =
          await userRepository.InvoiceDocumentListAPI(
              invoiceModuleListRequest1);

      for (int i = 0; i < response1.details.length; i++) {
        String uriString = event.SiteURL +
            "/ModuleDocs/" +
            response1.details[i].docName; // Uri string

        /*File file = await userRepository.getDocumentFile(
            event.SiteURL + "/ModuleDocs/", response.details[i].docName);*/

        try {
          String uriString = event.SiteURL +
              "/ModuleDocs/" +
              response1.details[i].docName; // Uri string

          try {
            Directory dir = await path_provider.getTemporaryDirectory();
            dir.exists();
            String pathName = path.join(dir.path, response1.details[i].docName);

            await Dio().download(uriString, pathName);
            print("Download Completed.");

            File file = await toFile(pathName);
            DocumentListForSlip.add(file);
          } catch (e) {
            print("Download Failed.\n\n" + e.toString());
          }
        } on UnsupportedError catch (e) {
          print(e.message); // Unsupported error for uri not supported
        } on IOException catch (e) {
          print(e); // IOException for system error
        } catch (e) {
          print(e); // General exception
        }
      }

      yield DefDocumentListResponseState(response, event.vehicleDefDetails,
          DocumentList, DocumentListForSlip, responseExport);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapQuotationTermsConditionEventToState(
      MaintenanceTermsConditionCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationTermsCondtionResponse response =
          await userRepository.getQuotationTermConditionList(event.request);
      yield MaintenanceTermsConditionResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapGetMaintenanceProductListEventState(
      GetMaintenanceProductTableEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      List<MaintenanceProductModel> response =
          await OfflineDbHelper.getInstance().getMaintenanceProduct();
      yield GetMaintenanceProductListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaintenanceOneProductDeleteEventState(
      MaintenanceOneProductDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteQuotationProduct(event.tableid);
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield MaintenanceOneProductDeleteState("Product Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///Maintenance
  Stream<MainStates> _mapMaintenanceListCallEventToState(
      MaintenanceListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaintenanceListResponse response = await userRepository
          .getMaintenanceList(event.pageNo, event.maintenanceListRequest);
      yield MaintenanceListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaintenanceDetailsDeleteEventState(
      MaintenanceDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository
          .getMaintenanceDetailsDelete(event.maintenanceDeleteRequest);
      yield MaintenanceDeleteCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaintenanceAddEditEventToState(
      MaintenanceAddUpdateRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MaintenanceAddUpdateResponse response = await userRepository
          .getMaintenanceAddEdit(event.maintenanceAddEditRequest);

      if (response.details[0].column1.toString() != "-1") {
        /// delete
        MaintenanceDetailsDeleteRequest maintenanceDetailsDeleteRequest =
            MaintenanceDetailsDeleteRequest(
          InquiryNo: response.details[0].column3,
          CompanyId: event.maintenanceAddEditRequest.CompanyId,
        );
        await userRepository
            .getMaintenanceDetailsDeleteApi(maintenanceDetailsDeleteRequest);

        ///Save
        List<MaintenanceProductModel> maintenanceProductModel =
            await OfflineDbHelper.getInstance().getMaintenanceProduct();

        List<MaintenanceProductModel> maintenanceProductModelData = [];

        if (maintenanceProductModel.length != 0) {
          for (int i = 0; i < maintenanceProductModel.length; i++) {
            maintenanceProductModelData.add(MaintenanceProductModel(
              maintenanceProductModel[i].pkID, //pkID
              response.details[0].column3, //InquiryNo
              maintenanceProductModel[i].ProductID, //ProductID
              maintenanceProductModel[i].ProductName, //ProductName
              maintenanceProductModel[i].UnitPrice, //UnitPrice
              maintenanceProductModel[i].TaxRate, //TaxRate
              maintenanceProductModel[i].Quantity, //Quantity
              maintenanceProductModel[i].TotalAmount, //TotalAmount
              maintenanceProductModel[i].StartDate, //StartDate
              maintenanceProductModel[i].EndDate, //EndDate
              maintenanceProductModel[i].OrderNo, //OrderNo
              maintenanceProductModel[i].SerialKey, //SerialKey
              maintenanceProductModel[i].ContractMonth, //ContractMonth
              maintenanceProductModel[i].LoginUserID, //LoginUserID
              maintenanceProductModel[i].CompanyId, //CompanyId
            ));
          }
          await userRepository
              .getMaintenanceDetailsAddUpdate(maintenanceProductModelData);
        }
      }

      yield MaintenanceAddUpdateCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaintenanceCheckListDRPRequestCallEventToState(
      MaintenanceCheckListDRPRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaintenanceCheckListDRPResponse response = await userRepository
          .getMaintenanceCheckListDRP(event.maintenanceCheckListDRPRequest);
      yield MaintenanceCheckListDRPResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMasterMaintenanceCheckListRequestCallEventToState(
      MasterMaintenanceCheckListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MasterMaintenanceCheckListResponse response =
          await userRepository.getMasterMaintenanceCheckList(
              event.masterMaintenanceCheckListRequest);
      yield MasterMaintenanceCheckListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMasterMaintenanceCheckListRequestCallEventToState1(
      MasterMaintenanceCheckListRequestCallEvent1 event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MasterMaintenanceCheckListResponse1 response =
          await userRepository.getMasterMaintenanceCheckList1(
              event.masterMaintenanceCheckListRequest);
      yield MasterMaintenanceCheckListResponseState1(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapFollowupInquiryStatusListCallEventToState(
      InquiryLeadStatusTypeListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryStatusListResponse response =
          await userRepository.getFollowupInquiryStatusList(
              event.followupInquiryStatusTypeListRequest);
      yield InquiryLeadStatusListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaintenanceDetailsListEventState(
      MaintenanceDetailsListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaintenanceDetailsListResponse response = await userRepository
          .getMaintenanceDetailsList(event.maintenanceDetailsListRequest);

      if (response.details.length != 0) {
        await OfflineDbHelper.getInstance().deleteALLMaintenanceProduct();

        for (var i = 0; i < response.details.length; i++) {
          double TotalValue =
              (response.details[i].quantity * response.details[i].unitPrice);

          await OfflineDbHelper.getInstance()
              .insertMaintenanceProduct(MaintenanceProductModel(
            response.details[i].pkID.toString(), //String pkID,
            response.details[0].inquiryNo, //String InquiryNo,
            response.details[i].productID.toString(), //String ProductID,
            response.details[i].productName, //String ProductName,
            response.details[i].unitPrice.toString(), //String UnitPrice,
            "0.00", //String TaxRate,
            response.details[i].quantity.toString(), //String Quantity,
            TotalValue.toString(), //String TotalAmount,
            response.details[i].startDate, //String StartDate,
            response.details[i].endDate, //String EndDate,
            response.details[i].orderNo, //String OrderNo,
            response.details[i].serialKey, //String SerialKey,
            "0", //String ContractMont
            event.LoginUserId, //String LoginUserID,
            event.maintenanceDetailsListRequest.CompanyId,
          ));
        }
      }

      yield MaintenanceDetailsListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapALLEmployeeNameListCallEventToState(
      ALLEmployeeNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ALL_EmployeeList_Response response =
          await userRepository.getALLEmployeeList(event.allEmployeeNameRequest);
      yield ALL_EmployeeNameListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///Repairing
  Stream<MainStates> _mapRepairingListCallEventToState(
      RepairingListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      RepairingListResponse response = await userRepository.getRepairingListAPI(
          event.pageNo, event.repairingListRequest);
      yield RepairingListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapRepairingDetailsDeleteEventState(
      RepairingDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository
          .getRepairingDetailsDelete(event.repairingDeleteRequest);
      yield RepairingDeleteCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapRepairingAddEditEventToState(
      RepairingAddUpdateRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      RepairingAddUpdateResponse response = await userRepository
          .getRepairingAddEditAPI(event.repairingAddEditRequest);

      if (response.details[0].column1.toString() != "-1") {
        /// delete
        RepairingDetailsDeleteRequest repairingDetailsDeleteRequest =
            RepairingDetailsDeleteRequest(
          RepairingNo: response.details[0].column3,
          CompanyId: event.repairingAddEditRequest.CompanyId,
        );
        await userRepository
            .getRepairingDetailsDeleteApi(repairingDetailsDeleteRequest);

        ///Save
        List<RepairingDetailsTable> maintenanceProductModel =
            await OfflineDbHelper.getInstance().getRepairing();

        List<RepairingDetailsTable> maintenanceProductModelData = [];

        if (maintenanceProductModel.length != 0) {
          for (int i = 0; i < maintenanceProductModel.length; i++) {
            maintenanceProductModelData.add(RepairingDetailsTable(
              maintenanceProductModel[i].pkID, //String pkID,
              response.details[0].column1.toString(), //String ParentID,
              response.details[0].column3, //String RepairingNo,
              maintenanceProductModel[i].CheckListID, //String CheckListID,
              maintenanceProductModel[i].CheckListName, //String CheckListName,
              maintenanceProductModel[i].CheckFlag, //String CheckFlag,
              maintenanceProductModel[i].LoginUserID, //LoginUserID
              maintenanceProductModel[i].CompanyId, //CompanyId
            ));
          }
          await userRepository
              .getRepairingDetailsAddUpdate(maintenanceProductModelData);
        }
      }

      yield RepairingAddUpdateCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapRepairingListDRPCallEventToState(
      RepairingListByDRPNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaintenanceCheckListDRPResponse response =
          await userRepository.getMaintenanceCheckListDRP(
              event.followupInquiryStatusTypeListRequest);
      yield RepairingListCallDRPResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapUpdateAuditActivityDetailsTableEventState(
      UpdateAuditActivityDetailsTableEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().updateRepairing(RepairingDetailsTable(
          event.auditActivityDetailsTable.pkID, //String pkID,
          event.auditActivityDetailsTable.ParentID, //String ParentID,
          event.auditActivityDetailsTable.RepairingNo, //String RepairingNo,
          event.auditActivityDetailsTable.CheckListID, //String CheckListID,
          event.auditActivityDetailsTable.CheckListName, //String CheckListName,
          event.auditActivityDetailsTable.CheckFlag, //String CheckFlag,
          event.auditActivityDetailsTable.LoginUserID, //String LoginUserID,
          event.auditActivityDetailsTable.CompanyId, //String CompanyId,
          id: event.auditActivityDetailsTable.id));

      yield UpdateAuditActivityDetailsTableState(
          event.context, "Updated Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapRepairingDetailsListEventState(
      RepairingDetailsListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      RepairingDetailsListResponse response = await userRepository
          .getRepairingDetailsList(event.maintenanceDetailsListRequest);

      if (response.details.length != 0) {
        await OfflineDbHelper.getInstance().deleteALLRepairing();

        for (var i = 0; i < response.details.length; i++) {
          await OfflineDbHelper.getInstance()
              .insertRepairing(RepairingDetailsTable(
            response.details[i].pkID.toString(), //String pkID,
            response.details[i].parentID.toString(), //String ParentID,
            response.details[i].repairingNo, //String RepairingNo,
            response.details[i].checkListID.toString(), //String CheckListID,
            response.details[i].checkDesc, //String CheckListName,
            response.details[i].checkFlag.toString(), //String CheckFlag,
            event.LoginUserId, //String LoginUserID,
            event.maintenanceDetailsListRequest.CompanyId,
          ));
        }
      }

      yield RepairingDetailsListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapRepairingLogListCallEventToState(
      RepairingLogListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      RepairingLogListResponse response = await userRepository
          .getRepairingLogListAPI(event.repairingLogListRequest);
      yield RepairingLogListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  /// Material inward

  Stream<MainStates> _mapMaterialInwardListCallEventToStateMeet(
      MaterialInwardListMeetCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MaterialInwardListMeetResponse response =
          await userRepository.materialInwardListMeet(
              event.pageNo, event.materialInwardListRequestMeet);
      yield MaterialInwardListCallMeetResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialInwardDeleteEventState(
      MaterialInwardDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository
          .getMaterialInwardDelete(event.materialInwardDeleteRequest);
      yield MaterialInwardDeleteCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapCustomerListCallEventToState(
      MaterialInwardCustomerListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MaterialInwardCustomerListResponce response = await userRepository
          .getCustomerListApi(event.materialInwardCustomerListRequest);
      yield MaterialInwardCustomerListCallState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _MaterialInwarddetailssaveState(
      MaterialInwardMasterSaveEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaterialInwardMasterSaveResponce materialInwardAddUpdateResponse =
          await userRepository.MaterialInwardetailssave(
              event.materialInwardMasterSaveRequest);

      if (materialInwardAddUpdateResponse.details.length != 0) {
        //await OfflineDbHelper.getInstance().deleteALLAuditActivityDetailsTable();

        for (var i = 0;
            i < materialInwardAddUpdateResponse.details.length;
            i++) {
          MaterialInwardDetailsDeleteRequest
              materialInwardDetailsDeleteRequest =
              MaterialInwardDetailsDeleteRequest(
            InwardNo: materialInwardAddUpdateResponse.details[0].column3,
            CompanyId: event.materialInwardMasterSaveRequest.CompanyId,
          );

          await userRepository.getMaterialInwardDetailsDelete(
              materialInwardDetailsDeleteRequest);

          /// save

          List<MaterialInwardTable> materialInwardTable =
              await OfflineDbHelper.getInstance().getMaterialinwardProducts();

          List<MaterialInwardTable> tempMaterialInwardTable = [];

          if (materialInwardTable.length != 0) {
            for (int j = 0; j < materialInwardTable.length; j++) {
              tempMaterialInwardTable.add(MaterialInwardTable(
                materialInwardTable[j].RowNum, //"0",//String RowNum,
                materialInwardTable[j].pkID, //"0",//String pkID,
                event.materialInwardMasterSaveRequest
                    .LoginUserID, //LoginUserID,//String LoginUserID,
                event.materialInwardMasterSaveRequest
                    .CompanyId, //CompanyID.toString(),//String CompanyId,
                materialInwardAddUpdateResponse
                    .details[0].column3, //"",//String InwardNo,
                materialInwardTable[j].InwardDate, //"",//String InwardDate,
                materialInwardTable[j]
                    .DateCode, //edt_datecode.text,//String DateCode,
                materialInwardTable[j].CustomerID, //"",//String CustomerID,
                materialInwardTable[j].CustomerName, //"",//String CustomerName,
                materialInwardTable[j]
                    .ProductID, //productID.toString(),//String ProductID,
                materialInwardTable[j]
                    .ProductName, //_productNameController.text,//String ProductName,
                materialInwardTable[j]
                    .ProductNameLong, //"",//String ProductNameLong,
                materialInwardTable[j]
                    .ProductSpecification, //Specification,//String ProductSpecification,
                materialInwardTable[j]
                    .Quantity, //quantity.toString(),//String Quantity,
                materialInwardTable[j].Unit, //unit,//String Unit,
                materialInwardTable[j]
                    .UnitRate, //unitRate.toString(),//String UnitRate,
                materialInwardTable[j]
                    .DiscountPercent, //disc.toString(),//String DiscountPercent,
                materialInwardTable[j]
                    .DiscountAmt, //discAmount.toString(),//String DiscountAmt,
                materialInwardTable[j]
                    .NetRate, //netRate.toString(),//String NetRate,
                materialInwardTable[j]
                    .Amount, //netAmount.toString(),//String Amount,
                materialInwardTable[j]
                    .TaxType, //ISTaxType.toString(),//String TaxType,
                materialInwardTable[j]
                    .TaxRate, //taxPer.toString(),//String TaxRate,
                materialInwardTable[j]
                    .TaxAmount, //taxAmount.toString(),//String TaxAmount,
                materialInwardTable[j]
                    .NetAmount, //netAmount.toString(),//String NetAmount,
                materialInwardTable[j]
                    .CGSTPer, //CGSTPer.toString(),//String CGSTPer,
                materialInwardTable[j]
                    .CGSTAmt, //CGSTAmount.toString(),//String CGSTAmt,
                materialInwardTable[j]
                    .SGSTPer, //SGSTPer.toString(),//String SGSTPer,
                materialInwardTable[j]
                    .SGSTAmt, //SGSTAmount.toString(),//String SGSTAmt,
                materialInwardTable[j]
                    .IGSTPer, //IGSTPer.toString(),//String IGSTPer,
                materialInwardTable[j]
                    .IGSTAmt, //IGSTAmount.toString(),//String IGSTAmt,
                materialInwardTable[j].OrderNo, //"",//String OrderNo,
                materialInwardTable[j]
                    .StateCode, //StateCode.toString(),//String StateCode
                materialInwardTable[j]
                    .LocationID, //StateCode.toString(),//String StateCode
                materialInwardTable[j]
                    .SampleQuantity, //StateCode.toString(),//String StateCode
              ));
            }
            await userRepository
                .getMaterialInwardDetailsAddUpdate(tempMaterialInwardTable);
          }
        }
      }

      yield MaterialInwardMasterSaveState(materialInwardAddUpdateResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialInwardDetailsListEventState(
      MaterialInwardDetailsListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<MaterialInwardTable> response =
          await OfflineDbHelper.getInstance().getMaterialinwardProducts();

      yield MaterialInwardDetailsListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialInwardDetailsDeleteEventState(
      MaterialInwardDetailsDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .deleteMaterialInwardProductsProducts(event.tableId);

      yield MaterialInwardDetailsOneDeleteState("Product Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialInwardDetailsListCallEventToState(
      MaterialInwardDetailsListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MaterialInwardDetailListResponse response =
          await userRepository.getMaterialInwardDetailsListApi(
              event.materialInwardDetailListRequest);

      if (response.details.length != 0) {
        await OfflineDbHelper.getInstance()
            .deleteallMaterialInwardProductsProducts();

        for (var i = 0; i < response.details.length; i++) {
          await OfflineDbHelper.getInstance()
              .insertMaterialinwardProduct(MaterialInwardTable(
            "0", //String pkID,
            response.details[i].pkID.toString(), //String pkID,
            event.LoginUserId, //String LoginUserID,
            event.materialInwardDetailListRequest.CompanyId, //String CompanyId,
            response.details[i].inwardNo, //String IndentNo,
            "",
            response.details[i].dateCode,
            "",
            "",
            response.details[i].productID.toString(), //String ProductID,
            response.details[i].productName, //String ProductName,
            "", //String ProductNameLong,
            "",
            response.details[i].quantity.toString(), //String ProductNameLong,
            response.details[i].unit, //String Unit,
            response.details[i].unitRate.toString(), //String UnitRate,
            response.details[i].discountPercent.toString(), //String UnitRate,
            response.details[i].discountAmt.toString(), //String UnitRate,
            response.details[i].netRate.toString(), //String UnitRate,
            response.details[i].amount.toString(),
            response.details[i].taxType.toString(),
            response.details[i].taxRate.toString(), //String TaxRate,
            response.details[i].taxAmount.toString(), //String NetRate,
            response.details[i].netAmount.toString(), //String NetRate,
            response.details[i].cGSTPer.toString(), //String NetRate,
            response.details[i].cGSTAmt.toString(), //String NetRate,
            response.details[i].sGSTPer.toString(), //String NetRate,
            response.details[i].sGSTPer.toString(), //String NetRate,
            response.details[i].iGSTPer.toString(), //String NetRate,
            response.details[i].iGSTAmt.toString(), //String NetRate,
            response.details[i].orderNo.toString(), //String NetRate,
            event.StateCode, //String StateCode,
            event.LocationID, //String StateCode,
            response.details[i].sampleQuantity.toString(), //String StateCode,
          ));
        }
      }

      yield MaterialInwardDetailsListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialInwardGetPoNoRequestEventToState(
      MaterialInwardGetPoNoRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaterialInwardPendingPurchaseOrderListResponse response =
          await userRepository.getMaterialInwardGetPoNoAPI(
              event.mIGetOrderNoFromTheCustomerIdRequest);

      yield MaterialInwardGetPoNoResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialInwardGetPoNoEventToState(
      MaterialInwardGetDetailsPoNoRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MIGetFetDetailByOrderNoListResponse response =
          await userRepository.getMIGetFetDetailByOrderNoAPI(
              event.mIGetFetDetailByOrderNoListRequest);

      yield MaterialInwardGetDetailsPoNoResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  // Purchase Order

  Stream<MainStates> _mapPurchaseOrderListEventState1(
      PurchaseOrderListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PurchaseOrderListResponse respo = await userRepository.PurchaseOrderAPI(
          event.pageNo, event.purchaseOrderListRequest);
      yield PurchaseOrderListResponseState(event.pageNo, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseOrderDeleteCallEventState(
      PurchaseOrderDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository
          .getPurchaseOrderDelete(event.materialInwardDeleteRequest);
      yield PurchaseOrderDeleteCallState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPOListRequestEventToState(
      POApprovalListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      POApprovalListResponse response =
          await userRepository.getPOApprovalListAPI(event.poApprovalRequest);
      yield POApprovalListResponseState(
          response, int.parse(event.poApprovalRequest.PageNo));
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPoApprovalSaveRequestEventToState(
      POApprovalSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      String response = await userRepository
          .getPOApprovalSaveAPI(event.poApprovalSaveRequest);
      yield POApprovalSaveResponseState(response, event.context);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPOApprovalStatusListRequestEventToState(
      POApprovalStatusListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesOrderApprovalStatusListResponse response = await userRepository
          .getPurchaseOrderApprovalStatusListAPI(event.statusListRequest);
      yield POApprovalStatusListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPODrpListRequestEventToState(
      PODrpListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PODrpListResponse response =
          await userRepository.getPODrpListAPI(event.poApprovalRequest);
      yield PODrpListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  /// ServiceReport
  Stream<MainStates> _mapServiceReportListEventState1(
      ServiceReportListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ServiceReportListResponse respo = await userRepository
          .getServiceReportAPI(event.pageNo, event.serviceReportListRequest);
      yield ServiceReportListResponseState(event.pageNo, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapServiceReportDeleteEventState(
      ServiceReportDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository
          .getServiceReportDeleteApi(event.serviceReportDeleteRequest);
      yield ServiceReportDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapServiceReportAddUpdateRequestEventToState(
      ServiceReportAddUpdateRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ServiceReportAddUpdateResponse response = await userRepository
          .getServiceReportAddUpdateApi(event.serviceReportAddUpdateRequest);

      if (response.details.length != 0) {
        for (var i = 0; i < response.details.length; i++) {
          ServiceReportDetailsDeleteRequest materialInwardDetailsDeleteRequest =
              ServiceReportDetailsDeleteRequest(
            ServiceNo: response.details[0].column3,
            CompanyId: event.serviceReportAddUpdateRequest.CompanyId,
          );

          await userRepository.getServiceReportDetailsDelete(
              materialInwardDetailsDeleteRequest);

          /// save

          List<WorkNotesTable> workNotesTable =
              await OfflineDbHelper.getInstance().getWorkNotes();

          List<WorkNotesTable> tempWorkNotesTableTable = [];

          if (workNotesTable.length != 0) {
            for (int j = 0; j < workNotesTable.length; j++) {
              tempWorkNotesTableTable.add(WorkNotesTable(
                workNotesTable[j].pkID, //String pkID,
                workNotesTable[j].SrNo, //String SrNo,
                response.details[0].column3, //String ServiceNo,
                workNotesTable[j].WorkNotes, //String WorkNotes,
                workNotesTable[j].LoginUserID, //String LoginUserID,
                workNotesTable[j].CompanyId, //String CompanyId,
              ));
            }
            await userRepository
                .getServiceReportDetailsAddUpdateApi(tempWorkNotesTableTable);
          }
        }
      }

      yield ServiceReportAddUpdateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMachineTypeListCallEventToState(
      MachineTypeListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MachineMasterListRequestResponse response = await userRepository
          .getMachineTypeListApi(event.machineMasterListRequest);
      yield MachineTypeResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapServiceReportDetailsListRequestEventToState(
      ServiceReportDetailsListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ServiceReportDetailsListResponse response =
          await userRepository.getServiceReportDetailsListApi(
              event.serviceReportDetailsListRequest);

      if (response.details.length != 0) {
        await OfflineDbHelper.getInstance().deleteAllWorkNotes();

        for (var i = 0; i < response.details.length; i++) {
          await OfflineDbHelper.getInstance().insertWorkNotes(WorkNotesTable(
            "0", //pkID,
            response.details[i].srNo.toString(), //SrNo,
            response.details[i].serviceNo, //ServiceNo,
            response.details[i].workNotes, //WorkNotes,
            event.LoginUserID, //LoginUserID,
            event.serviceReportDetailsListRequest.CompanyId, //CompanyId,
          ));
        }
      }

      yield ServiceReportDetailsListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  /// ShortInvoice
  Stream<MainStates> _mapShortInvoiceListEventState1(
      ShortInvoiceListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ShortInvoiceListResponse respo = await userRepository
          .getShortInvoiceListAPI(event.pageNo, event.shortInvoiceListRequest);
      yield ShortInvoiceListResponseState(event.pageNo, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapShortInvoiceDeleteEventState(
      ShortInvoiceDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository
          .getShortInvoiceDeleteApi(event.shortInvoiceDeleteRequest);
      yield ShortInvoiceDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapDeleteGenericAdditionalChargesEventToState(
      DeleteGenericAdditionalChargesEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteALLGenericAddditionalCharges();
      yield DeleteAllGenericAdditionalChargesState("Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPaymentScheduleListEventState(
      PaymentScheduleListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<SoPaymentScheduleTable> response =
          await OfflineDbHelper.getInstance().getPaymentScheduleItems();
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield PaymentScheduleListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPaymentScheduleDeleteAllEventState(
      PaymentScheduleDeleteAllItemEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteAllPaymentScheduleItems();
      yield PaymentScheduleDeleteAllResponseState(
          "Deleted All Item in Table Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapGenericOtherChargeCallEventToState(
      GenericOtherChargeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield GenericOtherCharge1ListResponseState(
          quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSaleBill_INQ_QT_SO_NO_ListEventState(
      SaleBill_INQ_QT_SO_NO_ListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesBill_INQ_QT_SO_NO_ListResponse response =
          await userRepository.getINQ_QT_SO_NO_API(event.request);
      yield SalesBill_INQ_QT_SO_NO_ListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> mapAddGeneric(
      AddGenericAdditionalChargesEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .insertGenericAddditionalCharges(GenericAddditionalCharges(
        event.genericAddditionalCharges.DiscountAmt,
        event.genericAddditionalCharges.ChargeID1,
        event.genericAddditionalCharges.ChargeAmt1,
        event.genericAddditionalCharges.ChargeID2,
        event.genericAddditionalCharges.ChargeAmt2,
        event.genericAddditionalCharges.ChargeID3,
        event.genericAddditionalCharges.ChargeAmt3,
        event.genericAddditionalCharges.ChargeID4,
        event.genericAddditionalCharges.ChargeAmt4,
        event.genericAddditionalCharges.ChargeID5,
        event.genericAddditionalCharges.ChargeAmt5,
        event.genericAddditionalCharges.ChargeName1,
        event.genericAddditionalCharges.ChargeName2,
        event.genericAddditionalCharges.ChargeName3,
        event.genericAddditionalCharges.ChargeName4,
        event.genericAddditionalCharges.ChargeName5,
      ));

      yield AddGenericAdditionalChargesState("Added SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _map_bankDetailsEvent_state(
      SaleOrderBankDetailsListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      BankNameDropDownResponse response =
          await userRepository.getBankDetailsAPI(event.request);
      yield BankDetailsListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _map_bankDetailsWithDialogEvent_state(
      SaleOrderBankDetailsListDialogRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      BankNameDropDownResponse response =
          await userRepository.getBankDetailsAPI(event.request);
      yield BankDetailsDialogListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapQuotationProjectListCallEventToState(
      QuotationProjectListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationProjectListResponse response =
          await userRepository.getQuotationProjectList(event.request);
      yield QuotationProjectListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapQuotationTermsConditionEventToState1(
      QuotationTermsConditionCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationTermsCondtionResponse response =
          await userRepository.getQuotationTermConditionList(event.request);
      yield QuotationTermsCondtionResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSalesBillEmailContentEventState(
      SalesBillEmailContentRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaleBillEmailContentResponse response =
          await userRepository.getEmailContentAPI(event.request);
      yield SaleBillEmailContentResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPaymentScheduleDeleteEventState(
      PaymentScheduleDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deletePaymentScheduleItem(event.id);
      yield PaymentScheduleDeleteResponseState("Deleted Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPaymentScheduleEventState(
      PaymentScheduleEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().insertPaymentScheduleItems(
          SoPaymentScheduleTable(
              event.soPaymentScheduleTable.amount,
              event.soPaymentScheduleTable.dueDate,
              event.soPaymentScheduleTable.revdueDate));
      yield PaymentScheduleResponseState("Added Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSearchCustomerListByNumberCallEventToState(
      SearchCustomerListByNumberCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerDetailsResponse response =
          await userRepository.getCustomerListSearchByNumber(event.request);
      yield SearchCustomerListByNumberCallResponseState(
          event.IsFromDialog, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiNoToProductDetailsRequestEventState(
      MultiNoToProductDetailsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MultiNoToProductDetailsResponse response =
          await userRepository.getProductDetailsFrom_No(event.request);
      yield MultiNoToProductDetailsResponseState(
          event.FromWhichScreen, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSalesOrderAddressDropDownRequestEventToState(
      SalesOrderAddressDropDownRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesOrderAddressDropDownResponse response = await userRepository
          .getSOShipmentAddressDropdown(event.salesOrderAddressDropDownRequest);
      yield SalesOrderAddressDropDownResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapQuotationOtherChargeListEventToState(
      QuotationOtherChargeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield QuotationOtherChargeListResponseState(
          event.headerDiscountController, quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSalesOrderAddressOrgDropDownRequestEventToState(
      SalesOrderAddressORGDropDownRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesOrderAddressDropDownResponse response = await userRepository
          .getSOShipmentAddressDropdown(event.salesOrderAddressDropDownRequest);
      yield SalesOrderAddressORGDropDownResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSaveEmailContentRequestEventState(
      SaveEmailContentRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaveEmailContentResponse response =
          await userRepository.getSaveEmailContentAPI(event.request);
      yield SaveEmailContentResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPaymentScheduleEditEventState(
      PaymentScheduleEditEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance()
          .updatePaymentScheduleItems(event.soPaymentScheduleTable);
      yield PaymentScheduleEditResponseState("Updated Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapGetSIProductListEventState(
      GetSIProductListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<ShortInvoiceTable> response =
          await OfflineDbHelper.getInstance().getShortInvoiceList();
      yield GetSIProductListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSIOneProductDeleteEventState(
      SIProductOneDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteShortInvoice(event.tableId);
      yield SIProductOneDeleteState("Product Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _map_InsertProductEventState(
      InsertProductEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteAllShortInvoices();
      await OfflineDbHelper.getInstance().deleteALLGenericAddditionalCharges();

      for (int i = 0; i < event.quotationTable.length; i++) {
        await OfflineDbHelper.getInstance()
            .insertShortInvoice(ShortInvoiceTable(
          event.quotationTable[i].pkID, //int pkID,
          event.quotationTable[i].InvoiceNo, //String InvoiceNo,
          event.quotationTable[i].DocRefNo, //String DocRefNo,
          event.quotationTable[i].ProductID, //int ProductID,
          event.quotationTable[i].ProductName, //String ProductName,
          event.quotationTable[i]
              .ProductSpecification, //String ProductSpecification,
          event.quotationTable[i].LocationID, //int LocationID,
          event.quotationTable[i].TaxType, //int TaxType,
          event.quotationTable[i].PendingQty, //double PendingQty,
          event.quotationTable[i].UnitQty, //double UnitQty,
          event.quotationTable[i].Qty, //double Qty,
          event.quotationTable[i].Unit, //String Unit,
          event.quotationTable[i].Rate, //double Rate,
          event.quotationTable[i].DiscountPer, //double DiscountPer,
          event.quotationTable[i].DiscountAmt, //double DiscountAmt,
          event.quotationTable[i].NetRate, //double NetRate,
          event.quotationTable[i].Amount, //double Amount,
          event.quotationTable[i].CGSTPer, //double CGSTPer,
          event.quotationTable[i].SGSTPer, //double SGSTPer,
          event.quotationTable[i].IGSTPer, //double IGSTPer,
          event.quotationTable[i].CGSTAmt, //double CGSTAmt,
          event.quotationTable[i].SGSTAmt, //double SGSTAmt,
          event.quotationTable[i].IGSTAmt, //double IGSTAmt,
          event.quotationTable[i].AddTaxPer, //double AddTaxPer,
          event.quotationTable[i].AddTaxAmt, //double AddTaxAmt,
          event.quotationTable[i].NetAmt, //double NetAmt,
          event.quotationTable[i].HeaderDiscAmt, //double HeaderDiscAmt,
          event.quotationTable[i].ForOrderNo, //String ForOrderNo,
          event.quotationTable[i].NetWt, //String NetWt,
          event.quotationTable[i].BocNo, //String BocNo,
          event.quotationTable[i].GrossWt, //String GrossWt,
          event.quotationTable[i].StateCode, //int StateCode,
          event.quotationTable[i].LoginUserID, //String LoginUserID,
          event.quotationTable[i].CompanyId, //String CompanyId,
        ));
      }

      yield InsertProductSuccessResponseState("Inserted Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapQuotationOtherCharge1ListEventToState(
      QuotationOtherCharge1CallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield QuotationOtherCharge1ListResponseState(
          quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapGetGenericAdditionalChargesEventToState(
      GetGenericAdditionalChargesEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      List<GenericAddditionalCharges> quotationOtherChargesListResponse =
          await OfflineDbHelper.getInstance().getGenericAddditionalCharges();

      GenericAddditionalCharges genericAddditionalCharges;
      for (int i = 0; i < quotationOtherChargesListResponse.length; i++) {
        genericAddditionalCharges = quotationOtherChargesListResponse[i];
      }
      yield GetGenericAdditionalChargesState(genericAddditionalCharges);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapDeleteAllQuotationProductEventState(
      DeleteAllQuotationProductEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteALLSalesOrderProduct();
      yield DeleteALLQuotationProductTableState(
          "Deleted All Item in Table Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapShortInvoiceShipmentListListEventToState(
      ShortInvoiceShipmentListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ShortInvoiceShipmentListResponse response =
          await userRepository.getShortInvoiceShipmentListApi(event.request);
      yield ShortInvoiceShipmentListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapShortInvoiceExportListListEventToState(
      ShortInvoiceExportListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ShortInvoiceExportListResponse response =
          await userRepository.getShortInvoiceExportListApi(event.request);
      yield ShortInvoiceExportListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapShortInvoiceDetailsListRequestEventToState(
      ShortInvoiceDetailsListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ShortInvoiceDetailsListResponse response =
          await userRepository.getShortInvoiceDetailsListApi(event.request);

      if (response.details.length != 0) {
        await OfflineDbHelper.getInstance().deleteAllShortInvoices();

        for (var i = 0; i < response.details.length; i++) {
          await OfflineDbHelper.getInstance()
              .insertShortInvoice(ShortInvoiceTable(
            response.details[i].pkID, //int pkID,
            response.details[i].invoiceNo, //String InvoiceNo,
            response.details[i].docRefNo, //String DocRefNo,
            response.details[i].productID, //int ProductID,
            response.details[i].productName, //String ProductName,
            response
                .details[i].productSpecification, //String ProductSpecification,
            response.details[i].locationID, //int LocationID,
            response.details[i].taxType, //int TaxType,
            response.details[i].pendingQty, //double PendingQty,
            response.details[i].unitQty, //double UnitQty,
            response.details[i].qty, //double Qty,
            response.details[i].unit, //String Unit,
            response.details[i].rate, //double Rate,
            response.details[i].discountPer, //double DiscountPer,
            response.details[i].discountAmt, //double DiscountAmt,
            response.details[i].netRate, //double NetRate,
            response.details[i].amount, //double Amount,
            response.details[i].cGSTPer, //double CGSTPer,
            response.details[i].sGSTPer, //double SGSTPer,
            response.details[i].iGSTPer, //double IGSTPer,
            response.details[i].cGSTAmt, //double CGSTAmt,
            response.details[i].sGSTAmt, //double SGSTAmt,
            response.details[i].iGSTAmt, //double IGSTAmt,
            response.details[i].addTaxPer, //double AddTaxPer,
            response.details[i].addTaxAmt, //double AddTaxAmt,
            response.details[i].netAmt, //double NetAmt,
            response.details[i].headerDiscAmt, //double HeaderDiscAmt,
            response.details[i].forOrderNo, //String ForOrderNo,
            response.details[i].netWT.toString(), //String NetWt,
            response.details[i].boxNo, //String BocNo,
            response.details[i].grossWT.toString(), //String GrossWt,
            event.StateCode, //int StateCode,
            event.LoginUserId, //String LoginUserID,
            event.request.CompanyId, //String CompanyId,
          ));
        }
      }

      yield ShortInvoiceDetailsListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapShortInvoiceAddUpdateEventToState(
      ShortInvoiceAddUpdateRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ShortInvoiceAddUpdateResponse response =
          await userRepository.getShortInvoiceAddUpdateApi(event.request);
      yield ShortInvoiceAddUpdateResponseState(event.context, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapShortInvoiceProductSaveCallEventState(
      ShortInvoiceProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaleOrderProductSaveResponse response = await userRepository
          .getShortInvoiceProductAddUpdateApi(event.arrSalesOrderProductList);
      yield ShortInvoiceProductSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapShortInvoiceExportAddUpdateCallEventState(
      ShortInvoiceExportAddUpdateRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaleOrderProductSaveResponse response =
          await userRepository.getShortInvoiceExportAddUpdateApi(event.request);
      yield ShortInvoiceExportAddUpdateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapShortInvoiceShipmentAddUpdateCallEventState(
      ShortInvoiceShipmentAddUpdateRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaleOrderProductSaveResponse response = await userRepository
          .getShortInvoiceShipmentAddUpdateApi(event.request);
      yield ShortInvoiceShipmentAddUpdateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapShortInvoiceDetailsDeleteEventState(
      ShortInvoiceDetailsDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository.getShortInvoiceDetailsDeleteApi(
          event.shortInvoiceDetailsListRequest);
      yield ShortInvoiceDetailsDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapProductMasterListEventToState(
      ProductListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ProductMasterResponse respo = await userRepository
          .getProductListAPi(event.productMasterListRequest);

      yield ProductMainListResponseState(respo);
    } catch (error, stacktrace) {
      print(error.toString());

      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapShortInvoiceAssemblyLoadListEventToState(
      ShortInvoiceAssemblyLoadListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ShortInvoiceAssemblyLoadResponse respo =
          await userRepository.getShortInvoiceAssemblyLoadListAPi(
              event.shortInvoiceAssemblyLoadRequest);

      yield ShortInvoiceAssemblyLoadListResponseState(
          event.finishProductID, respo);
    } catch (error, stacktrace) {
      print(error.toString());

      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapShortInvoiceProductListEventToState(
      ShortInvoiceProductListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ProductMasterResponse respo = await userRepository
          .getProductListAPi(event.productMasterListRequest);

      yield ShortInvoiceProductMainListResponseState(respo);
    } catch (error, stacktrace) {
      print(error.toString());

      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseBillAddUpdateEventToState(
      PurchaseBillAddUpdateRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PurchaseBillAddUpdateResponse response =
          await userRepository.getPurchaseBillAddUpdateApi(event.request);
      yield PurchaseBillAddUpdateResponseState(event.context, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseBillDetailsListRequestEventToState(
      PurchaseBillDetailsListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PurchaseBillDetailsListResponse response =
          await userRepository.getPurchaseBillDetailsListApi(event.request);

      if (response.details.length != 0) {
        await OfflineDbHelper.getInstance().deleteALLPurchaseBillProduct();

        for (var i = 0; i < response.details.length; i++) {
          await OfflineDbHelper.getInstance()
              .insertPurchaseBillProduct(PurchaseBillTable(
            response.details[i].pkID, //int pkID,
            response.details[i].invoiceNo, //String InvoiceNo,
            response.details[i].orderNo, //String OrderNo,
            response.details[i].productID, //int ProductID,
            response.details[i].productName, //String ProductName,
            response
                .details[i].productSpecification, //String ProductSpecification,
            response.details[i].locationID, //int LocationID,
            response.details[i].taxType, //int TaxType,
            response.details[i].qty, //double Qty,
            response.details[i].rate, //double Rate,
            response.details[i].discountPer, //double DiscountPer,
            response.details[i].discountAmt, //double DiscountAmt,
            response.details[i].netRate, //double NetRate,
            response.details[i].amount, //double Amount,
            response.details[i].cGSTPer, //double CGSTPer,
            response.details[i].sGSTPer, //double SGSTPer,
            response.details[i].iGSTPer, //double IGSTPer,
            response.details[i].cGSTAmt, //double CGSTAmt,
            response.details[i].sGSTAmt, //double SGSTAmt,
            response.details[i].iGSTAmt, //double IGSTAmt,
            response.details[i].addTaxPer, //double AddTaxPer,
            response.details[i].addTaxAmt, //double AddTaxAmt,
            response.details[i].netAmt, //double NetAmt,
            response.details[i].headerDiscAmt, //double HeaderDiscAmt,
            response.details[i].unit, //String Unit,
            event.StateCode, //int StateCode,
            event.LoginUserId, //String LoginUserID,
            event.request.CompanyId, //String CompanyId,
          ));
        }
      }

      yield PurchaseBillDetailsListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseBillDetailsDeleteEventState(
      PurchaseBillDetailsDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository.getPurchaseBillDetailsDeleteApi(
          event.shortInvoiceDetailsListRequest);
      yield PurchaseBillDetailsDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseBillDetailsAddUpdateCallEventState(
      PurchaseBillDetailsAddUpdateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PurchaseBillAddUpdateResponse response = await userRepository
          .getPurchaseBillDetailsAddUpdateApi(event.arrSalesOrderProductList);
      yield PurchaseBillProductSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiNoToProductDetailsFromGrnEventState(
      MultiNoToProductDetailsFromGrnRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MultiNoToProductDetailsFromGRNResponse response = await userRepository
          .getMultiNoToProductDetailsFromGrnApi(event.request);
      yield MultiNoToProductDetailsFromGrnResponseState(
          event.FromWhichScreen, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiNoToProductDetailsFromPurchaseOrderEventState(
      MultiNoToProductDetailsFromPurchaseOrderRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MultiNoToProductDetailsFromPurchaseOrderResponse response =
          await userRepository
              .getMultiNoToProductDetailsFromPurchaseOrderApi(event.request);
      yield MultiNoToProductDetailsFromPurchaseOrderResponseState(
          event.FromWhichScreen, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseBillACEventState(
      PurchaseBillACRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PurchaseBillACResponse response =
          await userRepository.getPurchaseBillACApi(event.request);
      yield PurchaseBillACResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseBillTODEventState(
      PurchaseBillTODRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PurchaseBillTODResponse response =
          await userRepository.getPurchaseBillTODApi(event.request);
      yield PurchaseBillTODResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapGetPOProductListEventState(
      GetPOProductListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<PurchaseOrderTable> response =
          await OfflineDbHelper.getInstance().getPurchaseOrderProduct();
      yield GetPOProductListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPOOneProductDeleteEventState(
      POProductOneDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .deletePurchaseOrderProduct(event.tableId);
      yield SIProductOneDeleteState("Product Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapConstantRequestNewEventToState(
      ConstantRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ConstantResponse respo =
          await userRepository.getConstantAPI(event.CompanyID, event.request);
      yield ConstantResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _map_insertPOProductEventState(
      InsertPOProductEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteALLPurchaseOrderProduct();
      await OfflineDbHelper.getInstance().deleteALLGenericAddditionalCharges();

      for (int i = 0; i < event.quotationTable.length; i++) {
        await OfflineDbHelper.getInstance()
            .insertPurchaseOrderProduct(PurchaseOrderTable(
          event.quotationTable[i].PurchaseOrderNo, //String PurchaseOrderNo,
          event.quotationTable[i]
              .ProductSpecification, //String ProductSpecification,
          event.quotationTable[i].ProductID, //int ProductID,
          event.quotationTable[i].ProductName, //String ProductName,
          event.quotationTable[i].Unit, //String Unit,
          event.quotationTable[i].Quantity, //double Quantity,
          event.quotationTable[i].UnitRate, //double UnitRate,
          event.quotationTable[i].DiscountPercent, //double DiscountPercent,
          event.quotationTable[i].DiscountAmt, //double DiscountAmt,
          event.quotationTable[i].NetRate, //double NetRate,
          event.quotationTable[i].Amount, //double Amount,
          event.quotationTable[i].TaxRate, //double TaxRate,
          event.quotationTable[i].TaxAmount, //double TaxAmount,
          event.quotationTable[i].NetAmount, //double NetAmount,
          event.quotationTable[i].TaxType, //int TaxType,
          event.quotationTable[i].CGSTPer, //double CGSTPer,
          event.quotationTable[i].SGSTPer, //double SGSTPer,
          event.quotationTable[i].IGSTPer, //double IGSTPer,
          event.quotationTable[i].CGSTAmt, //double CGSTAmt,
          event.quotationTable[i].SGSTAmt, //double SGSTAmt,
          event.quotationTable[i].IGSTAmt, //double IGSTAmt,
          event.quotationTable[i].StateCode, //int StateCode,
          event.quotationTable[i].pkID, //int pkID,
          event.quotationTable[i].LoginUserID, //String LoginUserID,
          event.quotationTable[i].CompanyId, //String CompanyId,
          event.quotationTable[i].BundleId, //int BundleId,
          event.quotationTable[i].HeaderDiscAmt, //double HeaderDiscAmt,
          event.quotationTable[i].DeliveryDate, //String DeliveryDate,
          event.quotationTable[i].DocRef, //String DocRef,
        ));
      }

      yield InsertProductSuccessResponseState("Inserted Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapQuotationKindAttListCallEventToState(
      QuotationKindAttListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationKindAttListResponse response =
          await userRepository.getQuotationKindAttList(event.request);
      yield QuotationKindAttListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapQuotationOrganizationListRequestEventToState(
      QuotationOrganizationListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOrganizationListResponse response =
          await userRepository.getQuotationOrganizationListAPI(
              event.quotationOrganazationListRequest);
      yield QuotationOrganizationListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///PurchaseOrder

  Stream<MainStates> _mapPurchaseOrderAddUpdateEventToState(
      PurchaseOrderAddUpdateRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PurchaseOrderAddUpdateResponse response =
          await userRepository.getPurchaseOrderAddUpdateApi(event.request);
      yield PurchaseOrderAddUpdateResponseState(event.context, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseOrderDetailsListRequestEventToState(
      PurchaseOrderDetailsListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PurchaseOrderDetailsListResponse response =
          await userRepository.getPurchaseOrderDetailsListApi(event.request);

      if (response.details.length != 0) {
        await OfflineDbHelper.getInstance().deleteALLPurchaseOrderProduct();

        for (var i = 0; i < response.details.length; i++) {
          await OfflineDbHelper.getInstance().insertPurchaseOrderProduct(
              PurchaseOrderTable(
                  response.details[i].orderNo, //String PurchaseOrderNo,
                  response.details[i]
                      .productSpecification, //String ProductSpecification,
                  response.details[i].productID, //int ProductID,
                  response.details[i].productName, //String ProductName,
                  response.details[i].unit, //String Unit,
                  response.details[i].quantity, //double Quantity,
                  response.details[i].unitRate, //double UnitRate,
                  response.details[i].discountPercent, //double DiscountPercent,
                  response.details[i].discountAmt, //double DiscountAmt,
                  response.details[i].netRate, //double NetRate,
                  response.details[i].amount, //double Amount,
                  response.details[i].taxRate, //double TaxRate,
                  response.details[i].taxAmount, //double TaxAmount,
                  response.details[i].netAmount, //double NetAmount,
                  response.details[i].taxType.toInt(), //int TaxType,
                  response.details[i].cGSTPer, //double CGSTPer,
                  response.details[i].sGSTPer, //double SGSTPer,
                  response.details[i].iGSTPer, //double IGSTPer,
                  response.details[i].cGSTAmt, //double CGSTAmt,
                  response.details[i].sGSTAmt, //double SGSTAmt,
                  response.details[i].iGSTAmt, //double IGSTAmt,
                  event.StateCode, //int StateCode,
                  response.details[i].pkID, //int pkID,
                  event.LoginUserId, //String LoginUserID,
                  event.request.CompanyId, //String CompanyId,
                  0, //int BundleId,
                  0.00, //double HeaderDiscAmt,
                  response.details[i].deliveryDate, //String DeliveryDate,
                  response.details[i].indentNo //String DocRef,
                  ));
        }
      }

      yield PurchaseOrderDetailsListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseOrderDetailsDeleteEventState(
      PurchaseOrderDetailsDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository.getPurchaseOrderDetailsDeleteApi(
          event.shortInvoiceDetailsListRequest);
      yield PurchaseOrderDetailsDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseOrderDetailsAddUpdateCallEventState(
      PurchaseOrderDetailsAddUpdateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PurchaseOrderAddUpdateResponse response = await userRepository
          .getPurchaseOrderDetailsAddUpdateApi(event.arrSalesOrderProductList);
      yield PurchaseOrderProductSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseOrderShipmentListEventToState(
      PurchaseOrderShipmentListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PurchaseOrderShipmentListResponse response =
          await userRepository.getPurchaseOrderShipmentListApi(event.request);
      yield PurchaseOrderShipmentListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPurchaseOrderShipmentAddUpdateCallEventState(
      PurchaseOrderShipmentAddUpdateRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PurchaseOrderAddUpdateResponse response = await userRepository
          .getPurchaseOrderShipmentAddUpdateApi(event.request);
      yield PurchaseOrderShipmentAddUpdateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPOFromTheIndentNumberEventState(
      POFromTheIndentNumberEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PoFromTheIndentListResponse response =
          await userRepository.getPOFromTheIndentNumberApi(event.request);
      yield POFromTheIndentNumberState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPoTankerDrpListEventState(
      PoTankerDrpListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      POTankerListResponse response =
          await userRepository.getPoTankerListApi(event.request);
      yield PoTankerListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPoDriverDrpListEventState(
      PoDriverDrpListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PODriverListResponse response =
          await userRepository.getPoDriverListApi(event.request);
      yield PoDriverListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapLocationListCallEventToState(
      LocationListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      DashboardLocationListResponse response =
          await userRepository.getLocationListAPI(event.allEmployeeNameRequest);
      yield LocationListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapLocationLogListCallEventToState(
      LocationLogListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      DashboardLocationLogListResponse response = await userRepository
          .getLocationLogListAPI(event.allEmployeeNameRequest);
      yield LocationLogListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPaySlipListListCallEventToState(
      PaySlipListListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PaySlipListResponse respo =
          await userRepository.getPaySlipListAPi(event.paySlipListRequest);

      yield PaySlipListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(error.toString());
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSalesOrderPDFGenerateCallEventToState(
      SalesOrderPDFGenerateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesOrderPDFGenerateResponse response =
          await userRepository.getSalesOrderPDFGenerate(event.request);
      yield SalesOrderPDFGenerateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapVisitorInfoListCallRequestEventToState(
      VisitorInfoListCallRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      VisitorInfoListApiResponse response = await userRepository
          .getVisitorInfoListApi(event.pageNo, event.visitorInfoListApiRequest);
      yield VisitorInfoListCallResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapVisitorInfoDeleteCallRequestEventToState(
      VisitorInfoDeleteCallRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository
          .getVisitorInfoDeleteAPI(event.visitorInfoDeleteApiRequest);
      yield VisitorInfoDeleteCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapVisitorInfoAddUpdateCallRequestEventToState(
      VisitorInfoAddUpdateCallRequestEvent event) async* {
    try {
      debugPrint("🔹 VisitorInfoAddUpdate EVENT TRIGGERED");
      debugPrint("📦 Request Data: ${event.request.toJson()}");
      debugPrint("🖼 VisitorImage: ${event.request.VisitorImage?.path}");
      debugPrint("📄 VisitorDocument: ${event.request.VisitorDocument?.path}");

      baseBloc.emit(ShowProgressIndicatorState(true));

      var responseJson = await userRepository.getVisitorInfoAddUpdateAPI(
        event.request,
        file: event.request.VisitorImage,
        file1: event.request.VisitorDocument,
      );

      debugPrint("✅ API RESPONSE (BLoC): $responseJson");

      yield VisitorInfoAddUpdateCallResponseState(responseJson);
    } catch (error, stacktrace) {
      debugPrint("❌ ERROR (BLoC): $error");
      debugPrint("🧵 STACKTRACE: $stacktrace");
      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapCountryListCallEventToState(
      CountryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CountryListResponse respo =
          await userRepository.country_list_call(event.countryListRequest);
      yield CountryListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapStateListCallEventToState(
      StateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      StateListResponse respo =
          await userRepository.state_list_call(event.stateListRequest);
      yield StateListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapCityListCallEventToState(CityCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CityApiRespose respo =
          await userRepository.city_list_details(event.cityApiRequest);
      yield CityListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSOCustomerNearByPinCodeSummaryRequestEventToState(
      SOCustomerNearByPinCodeSummaryRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      SOCustomerNearByPinCodeSummaryResponse response =
          await userRepository.getSOCustomerNearByPinCodeSummaryApi(
              event.sOCustomerNearByPinCodeCommonRequest);
      yield SOCustomerNearByPinCodeSummaryResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSOCustomerNearByPinCodeDetailsRequestEventToState(
      SOCustomerNearByPinCodeDetailsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      SOCustomerNearByPinCodeDetailsResponse response =
          await userRepository.getSOCustomerNearByPinCodeDetailsApi(
              event.sOCustomerNearByPinCodeCommonRequest);
      yield SOCustomerNearByPinCodeDetailsResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapInquiryProductSearchCallEventToState(
      InquiryProductSearchNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryProductSearchResponse response = await userRepository
          .getInquiryProductSearchList(event.inquiryProductSearchRequest);
      yield InquiryProductSearchResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapSOCurrencyListRequestEventToState(
      SOCurrencyListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SOCurrencyListResponse inquiryDeleteResponse =
          await userRepository.SOCurrencyListAPI(event.request);
      yield SOCurrencyListResponseState(inquiryDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialIndentListRequestEventState(
      MaterialIndentListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaterialIndentListResponse response =
          await userRepository.getMaterialIndentListApi(
              event.pageNo, event.materialIndentListRequest);
      yield MaterialIndentListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMaterialIndentApprovalUpdateRequestEventToState(
      MaterialIndentApprovalUpdateRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MaterialIndentApprovalUpdateResponse response =
          await userRepository.getMaterialIndentApprovalUpdateApi(
              event.materialIndentApprovalUpdateRequest);
      yield MaterialIndentApprovalUpdateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiExpenseListRequestEventToState(
      MultiExpenseListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MultiExpenseListResponse response = await userRepository
          .getMultiExpenseList(event.pageNo, event.multiExpenseListRequest);
      yield MultiExpenseListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiExpenseDeleteRequestEventToState(
      MultiExpenseDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String response = await userRepository
          .getMultiExpenseDeleteAPI(event.multiExpenseDeleteRequest);
      yield MultiExpenseDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiExpenseDetailsListRequestEventToState(
      MultiExpenseADetailsListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MultipleExpenseDetailsListResponse multipleExpenseDetailsListResponse =
          await userRepository
              .getMultiExpenseDetailsListApi(event.multiExpenseListRequest);

      if (multipleExpenseDetailsListResponse.details.isNotEmpty) {
        await OfflineDbHelper.getInstance().deleteAllMultipleExpense();

        for (var item in multipleExpenseDetailsListResponse.details) {
          File localVoucherFile;

          if (item.voucher != null && item.voucher.isNotEmpty) {
            try {
              final baseUrl = event.SiteURL;

              String cleanBase = baseUrl.endsWith("/")
                  ? baseUrl.substring(0, baseUrl.length - 1)
                  : baseUrl;
              String cleanVoucher = item.voucher.startsWith("/")
                  ? item.voucher.substring(1)
                  : item.voucher;
              String voucherUrl = "$cleanBase/otherImages/$cleanVoucher";

              print("🔗 Voucher URL trying to download: $voucherUrl");

              var response = await http.get(Uri.parse(voucherUrl));
              if (response.statusCode == 200) {
                String ext = "jpg";
                final lastDot = cleanVoucher.lastIndexOf('.');
                if (lastDot != -1 && lastDot < cleanVoucher.length - 1) {
                  ext =
                      cleanVoucher.substring(lastDot + 1).toLowerCase().trim();
                }

                final contentType =
                    response.headers['content-type']?.toLowerCase() ?? "";
                if (contentType.contains('pdf')) {
                  ext = "pdf";
                }

                final dir = await getApplicationDocumentsDirectory();
                final filePath = '${dir.path}/voucher_${item.pkID}.$ext';
                localVoucherFile = File(filePath);
                await localVoucherFile.writeAsBytes(response.bodyBytes);

                print("✅ Saved voucher locally: $filePath");
              } else {
                print(
                    "Failed to download voucher for pkID ${item.pkID}. Status: ${response.statusCode}");
              }
            } catch (e) {
              print("Error downloading voucher for pkID ${item.pkID}: $e");
            }
          }

          await OfflineDbHelper.getInstance().insertMultipleExpense(
            MultipleExpenseTable(
              item.pkID?.toString() ?? "", //pkID,
              item.refpkID?.toString() ?? "", //RefpkID,
              item.expenseTypeId?.toString() ?? "", //ExpenseTypeId,
              item.amount?.toString() ?? "", //Amount,
              item.remarks ?? "", //Remarks,
              item.toLoc ?? "", //ToLocation,
              item.fromLoc ?? "", //FromLocation,
              localVoucherFile, //Voucher,
              item.expenseDateDetail ?? "", //ExpenseDateDetail,
              event.multiExpenseListRequest.LoginUserID, //LoginUserID,
              event.multiExpenseListRequest.CompanyId, //CompanyId,
              item.expenseTypeName ?? "", //ExpenseTypeName,
            ),
          );
        }
      }

      yield MultiExpenseADetailsListResponseState(
          multipleExpenseDetailsListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiExpenseAddUpdateRequestEventToState(
      MultiExpenseAddUpdateRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      // Step 1: Call API to add/update the main expense record
      MultiExpenseAddUpdateResponse response = await userRepository
          .getMultiExpenseAddUpdateApi(event.multiExpenseAddUpdateRequest);

      // Step 2: Check if main record creation was successful
      if (response.details.isNotEmpty &&
          response.details[0].column1.toString() != "-1") {
        /// Delete previous details
        MulExpenseDetailDeleteRequest deleteRequest =
            MulExpenseDetailDeleteRequest(
          pkID: response.details[0].column3,
          CompanyId: event.multiExpenseAddUpdateRequest.CompanyId,
        );

        await userRepository.getMulExpenseDetailDeleteApi(deleteRequest);

        /// Step 3: Fetch offline expense data to upload as details
        List<MultipleExpenseTable> offlineExpenses =
            await OfflineDbHelper.getInstance().getMultipleExpense();

        if (offlineExpenses.isNotEmpty) {
          for (int i = 0; i < offlineExpenses.length; i++) {
            MultipleExpenseTable item = offlineExpenses[i];

            // Prepare new expense detail object with correct RefpkID
            MultipleExpenseTable expenseToUpload = MultipleExpenseTable(
              parseInt(item.pkID).toString(), //pkID,
              parseInt(response.details[0].column3).toString(), //RefpkID,
              parseInt(item.ExpenseTypeId).toString(), //ExpenseTypeId,
              parseDouble(item.Amount).toString(), //Amount,
              item.Remarks?.toString() ?? "", //Remarks,
              item.ToLocation?.toString() ?? "", //ToLocation,
              item.FromLocation?.toString() ?? "", //FromLocation,
              item.Voucher, //Voucher,
              item.ExpenseDateDetail?.toString() ?? "", //ExpenseDateDetail,
              event.multiExpenseAddUpdateRequest.LoginUserID, //LoginUserID,
              event.multiExpenseAddUpdateRequest.CompanyId, //CompanyId,
              item.ExpenseTypeName?.toString() ?? "", //ExpenseTypeName,
            );

            await userRepository
                .getMulExpenseDetailAddUpdate([expenseToUpload]);
          }
        }
      }

      /// Step 4: Yield success state
      yield MultiExpenseAddUpUpdateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(Exception(error.toString())));
      debugPrint(stacktrace.toString());
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiExpenseTypeListRequestEventToState(
      MultiExpenseTypeListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MultiExpenseTypeListResponse response = await userRepository
          .getMultiExpenseTypeListApi(event.multiExpenseTypeListRequest);

      yield MultiExpenseTypeListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiExpenseModeListRequestEventToState(
      MultiExpenseModeListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MultiExpenseModeListResponse response = await userRepository
          .getMultiExpenseModeListApi(event.multiExpenseModeListRequest);

      yield MultiExpenseModeListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapExpenseCustomerListCallEventToState(
      ExpenseCustomerListCallRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerDetailsResponse response = await userRepository
          .getExpenseCustomerList(event.customerPaginationRequest);

      yield ExpenseCustomerListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapDebitCreditNotesListCallRequestForDbEventToState(
      DebitCreditNotesListCallRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      DebitNotesListResponse response = await userRepository
          .getDebitNotesListApi(event.debitCreditNotesListRequest);

      yield DebitNotesListCallResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapDebitCreditNotesListCallRequestForCrEventToState(
      DebitCreditNotesListCallRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CreditNotesListResponse response = await userRepository
          .getCreditNotesListApi(event.debitCreditNotesListRequest);

      yield CreditNotesListCallResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapJournalVoucherMstAssetListCallRequestForJVEventToState(
      JournalVoucherMstAssetListCallRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      JournalVoucherListResponse response = await userRepository
          .getJournalVoucherListApi(event.journalVoucherMstAssetListRequest);

      yield JournalVoucherListCallResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapAssetIssueListCallRequestEventToState(
      AssetIssueListCallRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AssetIssueListResponse response = await userRepository
          .getAssetIssueListApi(event.journalVoucherMstAssetListRequest);

      yield AssetIssueListCallResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapPettyCashListCallRequestEventToState(
      PettyCashListCallRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PettyCashListResponse response =
          await userRepository.getPettyCashListApi(event.pettyCashListRequest);

      yield PettyCashListCallResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapAssetReturnListCallRequestEventToState(
      AssetReturnListCallRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AssetReturnListResponse response = await userRepository
          .getAssetReturnListApi(event.journalVoucherMstAssetListRequest);

      yield AssetReturnListCallResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapOfficeRefTypeFromCustomerIDRequestEventToState(
      OfficeRefTypeFromCustomerIDRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      OfficeRefTypeFromCustomerIDResponse response =
          await userRepository.getOfficeRefTypeFromCustomerIDApi(
              event.officeRefTypeFromCustomerIDRequest);

      yield OfficeRefTypeFromCustomerIDResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiExpenseApprovalListRequestEventToState(
      MultiExpenseApprovalListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MultipleExpenseApprovalListResponse response =
          await userRepository.getMultipleExpenseApprovalListApi(
              event.multiExpenseApprovalListRequest);

      yield MultiExpenseApprovalListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiExpenseApprovalStatusListRequestEventToState(
      MultiExpenseApprovalStatusListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      SalesOrderApprovalStatusListResponse response = await userRepository
          .getMultiExpenseApprovalStatusListAPI(event.statusListRequest);

      yield MultiExpenseApprovalStatusListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapMultiExpenseApprovalUpdateRequestEventToState(
      MultiExpenseApprovalUpdateRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MultipleExpenseApprovalUpdateResponse response =
          await userRepository.getMultipleExpenseApprovalUpdateApi(
              event.multiExpenseApprovalUpdateRequest);

      yield MultiExpenseApprovalUpdateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapQuickFollowupReportListRequestEventToState(
      QuickFollowupReportListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      QuickFollowupReportListResponse response = await userRepository
          .getQuickFollowupReportListAPI(event.quickFollowupReportListRequest);
      yield QuickFollowupReportListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapExpenseTrackingListCallEventToState(
      ExpenseTrackingListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ExpenseTrackingListResponse response = await userRepository
          .getExpenseTrackingList(event.expenseTrackingListRequest);
      yield ExpenseTrackingListResponseState(1, response); // default to page 1
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MainStates> _mapExpenseTrackingSaveCallEventToState(
      ExpenseTrackingSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ExpenseTrackingSaveResponse response = await userRepository
          .getExpenseTrackingSave(event.expenseTrackingSaveRequest);
      yield ExpenseTrackingSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
