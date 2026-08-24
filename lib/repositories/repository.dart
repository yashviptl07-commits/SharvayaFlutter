import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Atttend_Visit/Mudra_AttendVisit_delete_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Atttend_Visit/Mudra_Attend_Visit_Add_Update_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Atttend_Visit/Mudra_Attend_Visit_List_Screen_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Assinto_DropDown_List_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Complaint_Add_Update_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Complaint_Delete_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_Complaint_List_Screen_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_History_List_Screen_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_SericeTag_DropDown_List_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_Complaint/Mudra_project_List_DropDown_Request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Request/Mudra_quick_suport_request/Mudra_quick_suport_list_request.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Attend_Visit_response/Mudra_Attend_Visit_list_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Attend_Visit_response/Mudra_Attend_Visit_save_Response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Assign_To_DropDown_List_Response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Complaint_List_Screen_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Complaint_Save_Response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Complsint_history_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_Project_List_DropDwon_Response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_Complait_response/Mudra_ServiceTag_DropDown_response.dart';
import 'package:soleoserp/Client_Wise_Screens/Mudra_Client/Mudra_Api_Request_Response/Mudra_Api_Response/Mudra_quick_suport_response/Mudra_quick_suport_list_response.dart';
import 'package:soleoserp/Clients/BlueTone/bluetone_model/SizedList/size_list_request.dart';
import 'package:soleoserp/Clients/BlueTone/bluetone_model/SizedList/size_list_response.dart';
import 'package:soleoserp/Clients/BlueTone/bluetone_model/api_request/Logout_Count/logout_count_request.dart';
import 'package:soleoserp/Clients/BlueTone/bluetone_model/api_request/SizedList_INS_UPD_API/sized_list_ins_update_api_request.dart';
import 'package:soleoserp/Clients/BlueTone/bluetone_model/api_request/Sized_multi_delete_API/sized_multi_delete_api_request.dart';
import 'package:soleoserp/Clients/BlueTone/bluetone_model/api_request/inquiry_no_to_fetch_product_sized_list_request.dart';
import 'package:soleoserp/Clients/BlueTone/bluetone_model/api_response/LogOut_Count/log_out_count_response.dart';
import 'package:soleoserp/Clients/BlueTone/bluetone_model/api_response/SizedList_INS_UPD_API/sized_list_ins_update_api_response.dart';
import 'package:soleoserp/Clients/BlueTone/bluetone_model/api_response/inquiry_no_to_fetch_product_sized_list_response.dart';
import 'package:soleoserp/models/Model_Classis_Fro_ODB/bank_voucher_detail_model.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/accurabath_complaint_followup_history_list_request.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/accurabath_complaint_followup_save_request.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/accurabath_complaint_image_upload_request.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/accurabath_complaint_list_request.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/accurabath_complaint_save_request.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/accurabath_emp_follower_list_request.dart';
import 'package:soleoserp/models/api_requests/Accurabath_complaint/fetch_accurabath_complaint_image_list_request.dart';
import 'package:soleoserp/models/api_requests/AttendVisit/attend_visit_delete_request.dart';
import 'package:soleoserp/models/api_requests/AttendVisit/attend_visit_list_request.dart';
import 'package:soleoserp/models/api_requests/AttendVisit/attend_visit_save_request.dart';
import 'package:soleoserp/models/api_requests/External_leads/region_code_request.dart';
import 'package:soleoserp/models/api_requests/Loan/loan_approval_save_request.dart';
import 'package:soleoserp/models/api_requests/ManageProductionRequest/MaterialInwardRequest/material_inward_list_request.dart';
import 'package:soleoserp/models/api_requests/ManageProductionRequest/MaterialOutward/material_outward_list_request.dart';
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
import 'package:soleoserp/models/api_requests/MissedPunch/missed_punch_approval_add_edit_request.dart';
import 'package:soleoserp/models/api_requests/MissedPunch/missed_punch_approval_request.dart';
import 'package:soleoserp/models/api_requests/MyGetPunching/my_get_punching_request.dart';
import 'package:soleoserp/models/api_requests/Reports/customer_list.dart';
import 'package:soleoserp/models/api_requests/SalesBill/sale_bill_email_content_request.dart';
import 'package:soleoserp/models/api_requests/SalesBill/sales_bill_inq_QT_SO_NO_list_Request.dart';
import 'package:soleoserp/models/api_requests/SalesBill/sales_bill_search_by_id_request.dart';
import 'package:soleoserp/models/api_requests/SalesOrder/multi_no_to_product_details_request.dart';
import 'package:soleoserp/models/api_requests/ToDo_request/to_do_delete_request.dart';
import 'package:soleoserp/models/api_requests/accurabath_complaint/accurabath_complaint_no_to_delete_image_request.dart';
import 'package:soleoserp/models/api_requests/accurabath_complaint/accurabath_complaint_no_to_delete_video_request.dart';
import 'package:soleoserp/models/api_requests/accurabath_complaint/accurabath_complaint_no_to_upload_video_request.dart';
import 'package:soleoserp/models/api_requests/accurabath_complaint/accurabath_complaint_videoList_request.dart';
import 'package:soleoserp/models/api_requests/api_token/api_token_update_request.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_list_request.dart';
import 'package:soleoserp/models/api_requests/attendance/attendance_save_request.dart';
import 'package:soleoserp/models/api_requests/attendance/attendnace_holiday_request.dart';
import 'package:soleoserp/models/api_requests/attendance/punch_attendence_save_request.dart';
import 'package:soleoserp/models/api_requests/attendance/punch_without_image_request.dart';
import 'package:soleoserp/models/api_requests/bank_voucher/bank_drop_down_request.dart';
import 'package:soleoserp/models/api_requests/bank_voucher/bank_voucher_delete_request.dart';
import 'package:soleoserp/models/api_requests/bank_voucher/bank_voucher_list_request.dart';
import 'package:soleoserp/models/api_requests/bank_voucher/bank_voucher_save_request.dart';
import 'package:soleoserp/models/api_requests/bank_voucher/bank_voucher_search_by_id_request.dart';
import 'package:soleoserp/models/api_requests/bank_voucher/bank_voucher_search_by_name_request.dart';
import 'package:soleoserp/models/api_requests/checking/checking_no_to_checking_items_request.dart';
import 'package:soleoserp/models/api_requests/checking/final_checking_delete_all_items_request.dart';
import 'package:soleoserp/models/api_requests/checking/final_checking_header_save_request.dart';
import 'package:soleoserp/models/api_requests/checking/final_checking_items_request.dart';
import 'package:soleoserp/models/api_requests/checking/final_checking_list_request.dart';
import 'package:soleoserp/models/api_requests/checking/search_finalchecking_request.dart';
import 'package:soleoserp/models/api_requests/company_details/company_details_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_delete_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_list_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_no_list_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_save_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_search_by_Id_request.dart';
import 'package:soleoserp/models/api_requests/complaint/complaint_search_request.dart';
import 'package:soleoserp/models/api_requests/constant_master/constant_request.dart';
import 'package:soleoserp/models/api_requests/customer/bt_country_list_request.dart';
import 'package:soleoserp/models/api_requests/customer/city_code_to_customer_list_request.dart';
import 'package:soleoserp/models/api_requests/customer/cust_id_inq_list_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_add_edit_api_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_category_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_delete_document_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_delete_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_fetch_document_api_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_history_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_id_to_contact_list_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_id_to_delete_all_contacts_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_paggination_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_source_list_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_upload_document_api_request.dart';
import 'package:soleoserp/models/api_requests/daily_activity/daily_activity_delete_request.dart';
import 'package:soleoserp/models/api_requests/daily_activity/daily_activity_list_request.dart';
import 'package:soleoserp/models/api_requests/daily_activity/daily_activity_save_request.dart';
import 'package:soleoserp/models/api_requests/dolphin_complaint/dolphin_complaint_search_request.dart';
import 'package:soleoserp/models/api_requests/dolphin_complaint/dolphin_complaint_visit_delete_request.dart';
import 'package:soleoserp/models/api_requests/dolphin_complaint/dolphin_complaint_visit_list_request.dart';
import 'package:soleoserp/models/api_requests/dolphin_complaint/dolphin_complaint_visit_save_request.dart';
import 'package:soleoserp/models/api_requests/dolphin_complaint/dolphin_complaint_visit_search_by_id_request.dart';
import 'package:soleoserp/models/api_requests/employee/employee_list_request.dart';
import 'package:soleoserp/models/api_requests/employee/employee_search_request.dart';
import 'package:soleoserp/models/api_requests/expense/expense_delete_image_request.dart';
import 'package:soleoserp/models/api_requests/expense/expense_image_upload_server_request.dart';
import 'package:soleoserp/models/api_requests/expense/expense_list_request.dart';
import 'package:soleoserp/models/api_requests/expense/expense_save_request.dart';
import 'package:soleoserp/models/api_requests/expense/expense_type_request.dart';
import 'package:soleoserp/models/api_requests/expense/expense_upload_image_request.dart';
import 'package:soleoserp/models/api_requests/expense/fetc_image_list_by_expense_pk_id_request.dart';
import 'package:soleoserp/models/api_requests/external_leads/assign_to_notification_request.dart';
import 'package:soleoserp/models/api_requests/external_leads/bulk_assign_request.dart';
import 'package:soleoserp/models/api_requests/external_leads/external_lead_list_request.dart';
import 'package:soleoserp/models/api_requests/external_leads/external_lead_save_request.dart';
import 'package:soleoserp/models/api_requests/external_leads/external_lead_search_request.dart';
import 'package:soleoserp/models/api_requests/followup/follow_up_count_for_the_almighty_request.dart';
import 'package:soleoserp/models/api_requests/followup/follow_up_for_the_almighty_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_count_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_delete_image_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_delete_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_filter_list_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_history_list_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_image_list_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_inquiry_by_customer_id_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_inquiry_no_list_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_list_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_pkId_details_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_save_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_type_list_request.dart';
import 'package:soleoserp/models/api_requests/followup/followup_upload_image_request.dart';
import 'package:soleoserp/models/api_requests/followup/quick_followup_list_request.dart';
import 'package:soleoserp/models/api_requests/followup/quick_followup_report_list_request.dart';
import 'package:soleoserp/models/api_requests/followup/search_followup_by_status_request.dart';
import 'package:soleoserp/models/api_requests/followup/telecaller_followup_history_request.dart';
import 'package:soleoserp/models/api_requests/general_telecaller_img_upload_request/telecaller_upload_img_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/InquiryShareModel.dart';
import 'package:soleoserp/models/api_requests/inquiry/Out_NO_From_Inquiry_requst.dart';
import 'package:soleoserp/models/api_requests/inquiry/inqiory_header_save_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_no_followup_details_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_no_to_delete_product.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_no_to_product_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_product_search_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_search_by_pk_id_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_share_emp_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/inquiry_status_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/mudra_inquiry_list_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/search_inquiry_fillter_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/search_inquiry_list_by_name_request.dart';
import 'package:soleoserp/models/api_requests/inquiry/search_inquiry_list_by_number_request.dart';
import 'package:soleoserp/models/api_requests/installation_request/city_search_installtion_request.dart';
import 'package:soleoserp/models/api_requests/installation_request/installation_country_request.dart';
import 'package:soleoserp/models/api_requests/installation_request/installation_customerid_to_outwardno_request.dart';
import 'package:soleoserp/models/api_requests/installation_request/installation_delete_request.dart';
import 'package:soleoserp/models/api_requests/installation_request/installation_employee_request.dart';
import 'package:soleoserp/models/api_requests/installation_request/installation_list_request.dart';
import 'package:soleoserp/models/api_requests/installation_request/installation_save_request.dart';
import 'package:soleoserp/models/api_requests/installation_request/installation_search_customer_request.dart';
import 'package:soleoserp/models/api_requests/installation_request/search_installation_request.dart';
import 'package:soleoserp/models/api_requests/leave_request/leave_approval_save_request.dart';
import 'package:soleoserp/models/api_requests/leave_request/leave_request_list_request.dart';
import 'package:soleoserp/models/api_requests/leave_request/leave_request_save_request.dart';
import 'package:soleoserp/models/api_requests/leave_request/leave_request_type_request.dart';
import 'package:soleoserp/models/api_requests/loan/loan_approval_list_request.dart';
import 'package:soleoserp/models/api_requests/loan/loan_list_request.dart';
import 'package:soleoserp/models/api_requests/loan/loan_search_request.dart';
import 'package:soleoserp/models/api_requests/login/login_user_details_api_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_add_update_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_chacklist_dropdown.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_delete_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_details_delete_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_details_list_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_list_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/maintenance_search_request.dart';
import 'package:soleoserp/models/api_requests/maintenance/master_maintenance_contactList%20_dropdown.dart';
import 'package:soleoserp/models/api_requests/manage_accounts_request/dbcr_list_request/dbcr_list_request.dart';
import 'package:soleoserp/models/api_requests/manage_accounts_request/journalVoucher_mstAsset_list_request/journalVoucher_mstAsset_list_request.dart';
import 'package:soleoserp/models/api_requests/manage_accounts_request/petty_cash_list_request/petty_cash_list_request.dart';
import 'package:soleoserp/models/api_requests/manage_accounts_request/trialBalance_list_request/trialBalance_list_request.dart';
import 'package:soleoserp/models/api_requests/maps/distance_matrix_api_request.dart';
import 'package:soleoserp/models/api_requests/maps/google_place_api_request.dart';
import 'package:soleoserp/models/api_requests/missedPunch/missed_punch_list_request.dart';
import 'package:soleoserp/models/api_requests/missedPunch/missed_punch_search_by_id_request.dart';
import 'package:soleoserp/models/api_requests/missedPunch/missed_punch_search_by_name_request.dart';
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
import 'package:soleoserp/models/api_requests/other/Campaign_List.dart';
import 'package:soleoserp/models/api_requests/other/Common_CompanyDetails.dart';
import 'package:soleoserp/models/api_requests/other/all_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/other/bank_name_drop_down_request.dart';
import 'package:soleoserp/models/api_requests/other/city_list_request.dart';
import 'package:soleoserp/models/api_requests/other/closer_reason_list_request.dart';
import 'package:soleoserp/models/api_requests/other/country_list_request.dart';
import 'package:soleoserp/models/api_requests/other/dasboard_count_request.dart';
import 'package:soleoserp/models/api_requests/other/designation_list_request.dart';
import 'package:soleoserp/models/api_requests/other/district_list_request.dart';
import 'package:soleoserp/models/api_requests/other/follower_employee_list_request.dart';
import 'package:soleoserp/models/api_requests/other/locationList_request.dart';
import 'package:soleoserp/models/api_requests/other/location_address_request.dart';
import 'package:soleoserp/models/api_requests/other/menu_rights_request.dart';
import 'package:soleoserp/models/api_requests/other/near_by_pincode_request.dart';
import 'package:soleoserp/models/api_requests/other/product_drop_down_request.dart';
import 'package:soleoserp/models/api_requests/other/product_group_drop_down_request.dart';
import 'package:soleoserp/models/api_requests/other/specification_list_request.dart';
import 'package:soleoserp/models/api_requests/other/state_list_request.dart';
import 'package:soleoserp/models/api_requests/other/taluka_api_request.dart';
import 'package:soleoserp/models/api_requests/packing/delete_all_packing_assambly_request.dart';
import 'package:soleoserp/models/api_requests/packing/out_word_no_list_request.dart';
import 'package:soleoserp/models/api_requests/packing/packing_assambly_edit_mode_request.dart';
import 'package:soleoserp/models/api_requests/packing/packing_check_list_delete_request.dart';
import 'package:soleoserp/models/api_requests/packing/packing_checklist_list.dart';
import 'package:soleoserp/models/api_requests/packing/packing_productassambly_list_request.dart';
import 'package:soleoserp/models/api_requests/packing/packing_save_request.dart';
import 'package:soleoserp/models/api_requests/packing/search_packingchecklist_request.dart';
import 'package:soleoserp/models/api_requests/pay_slip_request/pay_slip_list_request.dart';
import 'package:soleoserp/models/api_requests/product/product_add_update_screen.dart';
import 'package:soleoserp/models/api_requests/product/product_brand_list_request.dart';
import 'package:soleoserp/models/api_requests/product/product_delete_request.dart';
import 'package:soleoserp/models/api_requests/product/product_group_request.dart';
import 'package:soleoserp/models/api_requests/product/product_master_list_request.dart';
import 'package:soleoserp/models/api_requests/product_activity_request/productionActivity_save_request.dart';
import 'package:soleoserp/models/api_requests/product_activity_request/production_activity_delete_request.dart';
import 'package:soleoserp/models/api_requests/product_activity_request/production_activity_list_request.dart';
import 'package:soleoserp/models/api_requests/product_activity_request/production_packing_list_request.dart';
import 'package:soleoserp/models/api_requests/product_activity_request/typeofwork_request.dart';
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
import 'package:soleoserp/models/api_requests/quotation/acurabath_quotation_save_request.dart';
import 'package:soleoserp/models/api_requests/quotation/hpl_Design_dropDown_list.dart';
import 'package:soleoserp/models/api_requests/quotation/hpl_Grade_dropDown_list.dart';
import 'package:soleoserp/models/api_requests/quotation/hpl_Size_dropDown_list.dart';
import 'package:soleoserp/models/api_requests/quotation/hpl_Thickness_dropDown_list.dart';
import 'package:soleoserp/models/api_requests/quotation/hpl_finish_dropDown_list.dart';
import 'package:soleoserp/models/api_requests/quotation/new_quotation_product_save_request.dart';
import 'package:soleoserp/models/api_requests/quotation/new_quotation_product_save_request1.dart';
import 'package:soleoserp/models/api_requests/quotation/qt_Organization_drop_down_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/qt_spec_save_api_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quo_shipment_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quo_shipment_save_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quo_shipmnet_delete_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_delete_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_email_content_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_header_save_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_kind_att_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_no_to_product_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_no_to_product_list_request1.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_pdf_generate_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_pkId_details_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_product_delete_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:soleoserp/models/api_requests/quotation/revised_quotation_request.dart';
import 'package:soleoserp/models/api_requests/quotation/save_email_content_request.dart';
import 'package:soleoserp/models/api_requests/quotation/search_quotation_list_by_name_request.dart';
import 'package:soleoserp/models/api_requests/quotation/search_quotation_list_by_number_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_add_update_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_delete_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_details_delete_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_details_list_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_list_request.dart';
import 'package:soleoserp/models/api_requests/repairing_request/repairing_log_list_request.dart';
import 'package:soleoserp/models/api_requests/salary_upad/salary_upad_list_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/fixledger_list_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/headerToDetailsRequest.dart';
import 'package:soleoserp/models/api_requests/salesBill/sales_bill_generate_pdf_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sales_bill_list_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sales_bill_product_details_list_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sb_all_product_delete_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sb_delete_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sb_export_list_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sb_export_save_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sb_product_save_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/sb_save_request.dart';
import 'package:soleoserp/models/api_requests/salesBill/search_sale_bill_list_by_name_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/SO_Export/so_export_list_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/SO_Export/so_export_save_api.dart';
import 'package:soleoserp/models/api_requests/salesOrder/So%20_product_list.dart';
import 'package:soleoserp/models/api_requests/salesOrder/sale_order_header_save_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/sale_order_product_save_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/sales_order_all_product_delete_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/sales_order_delete_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/sales_order_generate_pdf_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/salesorder_list_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/search_salesorder_list_by_name_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/search_salesorder_list_by_number_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/shipment/so_shipment_address_drop_down_api_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/shipment/so_shipment_list_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/shipment/so_shipment_save_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/shipment/so_shipmnet_delete_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/so_currency_list_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/test.dart';
import 'package:soleoserp/models/api_requests/salesOrder_Approval/salesOder_approval_list_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder_Approval/salesOrder_approval_save_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder_Approval/sales_order_approval_status_list_request.dart';
import 'package:soleoserp/models/api_requests/sales_target/sales_target_add_edit_request.dart';
import 'package:soleoserp/models/api_requests/sales_target/sales_target_delete_request.dart';
import 'package:soleoserp/models/api_requests/sales_target/sales_target_list_request.dart';
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
import 'package:soleoserp/models/api_requests/swastick_telecaller_request/new_telecaller_save_request.dart';
import 'package:soleoserp/models/api_requests/swastick_telecaller_request/telecaller_new_pagination_request.dart';
import 'package:soleoserp/models/api_requests/telecaller/tele_caller_followup_save_request.dart';
import 'package:soleoserp/models/api_requests/telecaller/tele_caller_save_request.dart';
import 'package:soleoserp/models/api_requests/telecaller/tele_caller_search_by_name_request.dart';
import 'package:soleoserp/models/api_requests/telecaller/telecaller_delete_image_request.dart';
import 'package:soleoserp/models/api_requests/telecaller/telecaller_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/invoice_document_delete_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/invoice_document_upload_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/invoice_documnet_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/module_sharing_save_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/task_category_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_employee_not_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_header_save_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_module_sharing_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_save_sub_details_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/to_do_worklog_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/todo_widget_list_request.dart';
import 'package:soleoserp/models/api_requests/toDo_request/transection_mode_list_request.dart';
import 'package:soleoserp/models/api_requests/to_do_office/to_do_office_list_request.dart';
import 'package:soleoserp/models/api_requests/visitor_info_requests/visitor_info_add_update_requests.dart';
import 'package:soleoserp/models/api_requests/visitor_info_requests/visitor_info_delete_requests.dart';
import 'package:soleoserp/models/api_requests/visitor_info_requests/visitor_info_list_requests.dart';
import 'package:soleoserp/models/api_requests/vk_sound_complaint/vk_complain_history_request.dart';
import 'package:soleoserp/models/api_requests/vk_sound_complaint/vk_complain_pkid_to_details_request.dart';
import 'package:soleoserp/models/api_requests/vk_sound_complaint/vk_sound_complain_delete_request.dart';
import 'package:soleoserp/models/api_requests/vk_sound_complaint/vk_sound_complain_list_request.dart';
import 'package:soleoserp/models/api_requests/vk_sound_complaint/vk_sound_complaint_save_request.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/accurabath_complaint_followup_list_response.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/accurabath_complaint_followup_save_response.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/accurabath_complaint_list_response.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/accurabath_complaint_save_response.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/accurabth_complaint_upload_image_response.dart';
import 'package:soleoserp/models/api_responses/Accurabath_complaint/complaint_image_list_response.dart';
import 'package:soleoserp/models/api_responses/AttendVisit/attend_visit_delete_response.dart';
import 'package:soleoserp/models/api_responses/External_leads/region_response.dart';
import 'package:soleoserp/models/api_responses/Loan/loan_approval_save_response.dart';
import 'package:soleoserp/models/api_responses/ManageProductionResponse/Material%20Outward/material_outward_list_response.dart';
import 'package:soleoserp/models/api_responses/ManageProductionResponse/MaterialInward/material_inward_list_response.dart';
import 'package:soleoserp/models/api_responses/MasterBaseURL/master_base_url_response.dart';
import 'package:soleoserp/models/api_responses/Material_Indent_response/Material_Indent_approval_update_response.dart';
import 'package:soleoserp/models/api_responses/Material_Indent_response/Material_Indent_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Get_FetDetail_By_OrdedNo_Responset.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Get_OrdedNo_From_TheCustomerId_Response.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Location_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Material_Inward_Customer_List_Responce.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Material_Inward_Details_LIst_Responce.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Material_Inward_Master_Save_Responce.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Material_Inward_list_Responce.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/details_add_material_Inward.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/imaterial_outward_document_delete_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/materail_outward_export_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_add_update_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_details_add_update_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_details_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_document_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_document_upload_respnse.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_export_add_update_response.dart';
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
import 'package:soleoserp/models/api_responses/MissedPunch/missed_punch_add_edit_response.dart';
import 'package:soleoserp/models/api_responses/MyGetPunching/my_get_punching_response.dart';
import 'package:soleoserp/models/api_responses/SaleBill/sale_bill_email_content_response.dart';
import 'package:soleoserp/models/api_responses/SaleBill/sales_bill_INQ_QT_SO_NO_list_response.dart';
import 'package:soleoserp/models/api_responses/SaleOrder/multi_no_to_product_details_response.dart';
import 'package:soleoserp/models/api_responses/accurabath_complaint/accurabath_complaint_no_to_delete_image_response.dart';
import 'package:soleoserp/models/api_responses/accurabath_complaint/accurabath_complaint_videoList_Response.dart';
import 'package:soleoserp/models/api_responses/accurabath_complaint/accurabath_emp_list_response.dart';
import 'package:soleoserp/models/api_responses/accurabath_complaint/acurabath_complaint_no_to_delete_video_response.dart';
import 'package:soleoserp/models/api_responses/accurabath_complaint/acurabath_complaint_no_to_upload_video_response.dart';
import 'package:soleoserp/models/api_responses/attendVisit/attend_visit_list_response.dart';
import 'package:soleoserp/models/api_responses/attendVisit/attend_visit_save_response.dart';
import 'package:soleoserp/models/api_responses/attendance/attendance_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/attendance/attendance_holiday_response.dart';
import 'package:soleoserp/models/api_responses/attendance/attendance_response_list.dart';
import 'package:soleoserp/models/api_responses/attendance/attendance_save_response.dart';
import 'package:soleoserp/models/api_responses/attendance/punch_attendence_save_response.dart';
import 'package:soleoserp/models/api_responses/attendance/punch_without_image_response.dart';
import 'package:soleoserp/models/api_responses/bank_voucher/bank_drop_down_response.dart';
import 'package:soleoserp/models/api_responses/bank_voucher/bank_voucher_delete_response.dart';
import 'package:soleoserp/models/api_responses/bank_voucher/bank_voucher_list_response.dart';
import 'package:soleoserp/models/api_responses/bank_voucher/bank_voucher_save_response.dart';
import 'package:soleoserp/models/api_responses/bank_voucher/bank_voucher_search_by_name_response.dart';
import 'package:soleoserp/models/api_responses/checking/checking_no_to_checking_item_response.dart';
import 'package:soleoserp/models/api_responses/checking/final_checking_delete_all_item_response.dart';
import 'package:soleoserp/models/api_responses/checking/final_checking_items_response.dart';
import 'package:soleoserp/models/api_responses/checking/final_checking_list_response.dart';
import 'package:soleoserp/models/api_responses/checking/final_checking_sub_details_response.dart';
import 'package:soleoserp/models/api_responses/checking/final_cheking_header_save_response.dart';
import 'package:soleoserp/models/api_responses/checking/search_finalchecking_label_response.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/complaint/complaint_delete_response.dart';
import 'package:soleoserp/models/api_responses/complaint/complaint_list_response.dart';
import 'package:soleoserp/models/api_responses/complaint/complaint_no_list_response.dart';
import 'package:soleoserp/models/api_responses/complaint/complaint_save_response.dart';
import 'package:soleoserp/models/api_responses/complaint/complaint_search_response.dart';
import 'package:soleoserp/models/api_responses/constant_master/constant_response.dart';
import 'package:soleoserp/models/api_responses/customer/bt_country_list_response.dart';
import 'package:soleoserp/models/api_responses/customer/city_code_to_customer_list_response.dart';
import 'package:soleoserp/models/api_responses/customer/cust_id_to_inq_list_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_add_edit_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_category_list.dart';
import 'package:soleoserp/models/api_responses/customer/customer_contact_save_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_delete_document_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_delete_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_details_api_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_fetch_document_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_history_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_id_to_contact_list_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_id_to_delete_all_contact_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_source_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_upload_document_response.dart';
import 'package:soleoserp/models/api_responses/daily_activity/daily_activity_delete_response.dart';
import 'package:soleoserp/models/api_responses/daily_activity/daily_activity_list_response.dart';
import 'package:soleoserp/models/api_responses/daily_activity/daily_activity_save_response.dart';
import 'package:soleoserp/models/api_responses/dolphin_complaint/dolphin_complaint_search_response.dart';
import 'package:soleoserp/models/api_responses/dolphin_complaint/dolphin_complaint_visit_delete_response.dart';
import 'package:soleoserp/models/api_responses/dolphin_complaint/dolphin_complaint_visit_list_response.dart';
import 'package:soleoserp/models/api_responses/dolphin_complaint/dolphin_complaint_visit_save_response.dart';
import 'package:soleoserp/models/api_responses/employee/employee_list_response.dart';
import 'package:soleoserp/models/api_responses/expense/expense_delete_image_response.dart';
import 'package:soleoserp/models/api_responses/expense/expense_delete_response.dart';
import 'package:soleoserp/models/api_responses/expense/expense_image_upload_server_response.dart';
import 'package:soleoserp/models/api_responses/expense/expense_list_response.dart';
import 'package:soleoserp/models/api_responses/expense/expense_save_response.dart';
import 'package:soleoserp/models/api_responses/expense/expense_type_response.dart';
import 'package:soleoserp/models/api_responses/expense/expense_upload_image_response.dart';
import 'package:soleoserp/models/api_responses/external_leads/Bulk_Assign_response.dart';
import 'package:soleoserp/models/api_responses/external_leads/assign_to_notification_response.dart';
import 'package:soleoserp/models/api_responses/external_leads/external_lead_list_response.dart';
import 'package:soleoserp/models/api_responses/external_leads/external_lead_save_response.dart';
import 'package:soleoserp/models/api_responses/external_leads/external_leadsearch_response_by_name.dart';
import 'package:soleoserp/models/api_responses/external_leads/fetch_image_by_expense_pk_id_response.dart';
import 'package:soleoserp/models/api_responses/firebase_token/firebase_token_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_Image_Upload_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_delete_Image_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_delete_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_filter_list_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_history_list_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_image_list_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_inquiry_by_customer_id_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_inquiry_no_list_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_list_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_pkId_details_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_save_success_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_type_list_response.dart';
import 'package:soleoserp/models/api_responses/followup/quick_followup_list_response.dart';
import 'package:soleoserp/models/api_responses/followup/quick_followup_report_list_response.dart';
import 'package:soleoserp/models/api_responses/followup/telecaller_followup_history_response.dart';
import 'package:soleoserp/models/api_responses/general_telecaller_img_upload_response/telecaller_upload_img_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/Out_No_From_Inq_No_Response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inq_no_to_product_list_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_delete_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_header_save_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_list_reponse.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_no_to_delete_product_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_no_to_product_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_product_save_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_share_emp_list_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_share_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_status_list_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/mudra_inquiry_list_reponse.dart';
import 'package:soleoserp/models/api_responses/inquiry/search_inquiry_list_response.dart';
import 'package:soleoserp/models/api_responses/installation_response/Installation_customerid_to_outwardno_response.dart';
import 'package:soleoserp/models/api_responses/installation_response/installation_city_response.dart';
import 'package:soleoserp/models/api_responses/installation_response/installation_country_response.dart';
import 'package:soleoserp/models/api_responses/installation_response/installation_delete_response.dart';
import 'package:soleoserp/models/api_responses/installation_response/installation_employee_response.dart';
import 'package:soleoserp/models/api_responses/installation_response/installation_list_response.dart';
import 'package:soleoserp/models/api_responses/installation_response/installation_search_customer_response.dart';
import 'package:soleoserp/models/api_responses/installation_response/save_installation_response.dart';
import 'package:soleoserp/models/api_responses/installation_response/search_installation_label_response.dart';
import 'package:soleoserp/models/api_responses/installation_response/state_search_response.dart';
import 'package:soleoserp/models/api_responses/leave_request/leave_approval_save_response.dart';
import 'package:soleoserp/models/api_responses/leave_request/leave_request_delete_response.dart';
import 'package:soleoserp/models/api_responses/leave_request/leave_request_list_response.dart';
import 'package:soleoserp/models/api_responses/leave_request/leave_request_save_response.dart';
import 'package:soleoserp/models/api_responses/leave_request/leave_request_type_response.dart';
import 'package:soleoserp/models/api_responses/loan/loan_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/maintenance/Maintenance_details_add_update_response.dart';
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
import 'package:soleoserp/models/api_responses/maps/distance_matrix_api_response.dart';
import 'package:soleoserp/models/api_responses/maps/google_place_search_response.dart';
import 'package:soleoserp/models/api_responses/missed_punch/missed_punch_approval_list_response.dart';
import 'package:soleoserp/models/api_responses/missed_punch/missed_punch_list_response.dart';
import 'package:soleoserp/models/api_responses/missed_punch/missed_punch_search_by_name_response.dart';
import 'package:soleoserp/models/api_responses/moduleAttachments/module_attachment_item_wise_delete_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_add_update_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_approval_list_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_approval_update_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_details_list_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multi_expense_list_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multiple_expense_details_add_update_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multiple_expense_expenseMode_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/multiple_expense_expenseType_response.dart';
import 'package:soleoserp/models/api_responses/multi_expense_response/office_refType_from_customerID_response.dart';
import 'package:soleoserp/models/api_responses/other/Campaign_List_response.dart';
import 'package:soleoserp/models/api_responses/other/Common_CompanyDetails%20_response.dart';
import 'package:soleoserp/models/api_responses/other/MultiNoToProductDetailsFromInquiryResponse.dart';
import 'package:soleoserp/models/api_responses/other/MultiNoToProductDetailsFromQuotationResponse.dart';
import 'package:soleoserp/models/api_responses/other/MultiNoToProductDetailsFromSalesOrderResponse.dart';
import 'package:soleoserp/models/api_responses/other/all_employee_List_response.dart';
import 'package:soleoserp/models/api_responses/other/bank_name_drop_down_response.dart';
import 'package:soleoserp/models/api_responses/other/city_api_response.dart';
import 'package:soleoserp/models/api_responses/other/closer_reason_list_response.dart';
import 'package:soleoserp/models/api_responses/other/country_list_response.dart';
import 'package:soleoserp/models/api_responses/other/country_list_response_for_packing_checking.dart';
import 'package:soleoserp/models/api_responses/other/dashBoard_locationList_reponse.dart';
import 'package:soleoserp/models/api_responses/other/dashboard_count_response.dart';
import 'package:soleoserp/models/api_responses/other/designation_list_response.dart';
import 'package:soleoserp/models/api_responses/other/district_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/api_responses/other/locatioLog_response.dart';
import 'package:soleoserp/models/api_responses/other/location_address_response.dart';
import 'package:soleoserp/models/api_responses/other/menu_rights_response.dart';
import 'package:soleoserp/models/api_responses/other/near_by_pincode_details_response.dart';
import 'package:soleoserp/models/api_responses/other/near_by_pincode_summary_response.dart';
import 'package:soleoserp/models/api_responses/other/pagination_demo_list_response.dart';
import 'package:soleoserp/models/api_responses/other/product_drop_down_response.dart';
import 'package:soleoserp/models/api_responses/other/product_group_dropdown_response.dart';
import 'package:soleoserp/models/api_responses/other/specification_list_response.dart';
import 'package:soleoserp/models/api_responses/other/state_list_response.dart';
import 'package:soleoserp/models/api_responses/other/taluka_api_response.dart';
import 'package:soleoserp/models/api_responses/packing/delete_all_packing_assambly_response.dart';
import 'package:soleoserp/models/api_responses/packing/out_word_no_list_response.dart';
import 'package:soleoserp/models/api_responses/packing/packing_assambly_edit_mode_response.dart';
import 'package:soleoserp/models/api_responses/packing/packing_assambly_save_response.dart';
import 'package:soleoserp/models/api_responses/packing/packing_check_list_delete_response.dart';
import 'package:soleoserp/models/api_responses/packing/packing_checking_list.dart';
import 'package:soleoserp/models/api_responses/packing/packing_no_list_response.dart';
import 'package:soleoserp/models/api_responses/packing/packing_product_assambly_list_response.dart';
import 'package:soleoserp/models/api_responses/packing/packing_save_response.dart';
import 'package:soleoserp/models/api_responses/packing/search_packingchecklist_label_response.dart';
import 'package:soleoserp/models/api_responses/pay_slip_response/pay_slip_list_response.dart';
import 'package:soleoserp/models/api_responses/product_master/prduct_add_update_response.dart';
import 'package:soleoserp/models/api_responses/product_master/product_brand_list_response.dart';
import 'package:soleoserp/models/api_responses/product_master/product_group_list_response.dart';
import 'package:soleoserp/models/api_responses/product_master/product_master_list_response.dart';
import 'package:soleoserp/models/api_responses/production_activity_response/productactivity_typeofwork_response.dart';
import 'package:soleoserp/models/api_responses/production_activity_response/productionActivity_save_response.dart';
import 'package:soleoserp/models/api_responses/production_activity_response/production_activity_delete_reponse.dart';
import 'package:soleoserp/models/api_responses/production_activity_response/production_activity_list_response.dart';
import 'package:soleoserp/models/api_responses/production_activity_response/production_activity_packingno_response.dart';
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
import 'package:soleoserp/models/api_responses/quotation/acurabath_quotation_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/hpl_Design_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/hpl_Grade_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/hpl_Size_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/hpl_Thickness_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/hpl_finish_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/qt_Organization_drop_down_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/qt_spec_save_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quo_shipment_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_delete_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_email_content_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_header_save_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_kind_att_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_no_to_product_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_no_to_product_list_response1.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_pdf_generate_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_product_delete_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_product_save_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_product_save_response1.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_project_list_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_terms_condition_response.dart';
import 'package:soleoserp/models/api_responses/quotation/revised_quotation_response.dart';
import 'package:soleoserp/models/api_responses/quotation/save_email_content_response.dart';
import 'package:soleoserp/models/api_responses/quotation/search_quotation_list_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_add_update_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_details_add_update_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_details_list_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_list_response.dart';
import 'package:soleoserp/models/api_responses/repairing_response/repairing_log_list_response.dart';
import 'package:soleoserp/models/api_responses/saleBill/fixedledger_list_response.dart';
import 'package:soleoserp/models/api_responses/saleBill/headerToDetailsResponse.dart';
import 'package:soleoserp/models/api_responses/saleBill/sales_bill_generate_pdf_response.dart';
import 'package:soleoserp/models/api_responses/saleBill/sales_bill_list_response.dart';
import 'package:soleoserp/models/api_responses/saleBill/sales_bill_product_details_list_Response.dart';
import 'package:soleoserp/models/api_responses/saleBill/sb_delete_response.dart';
import 'package:soleoserp/models/api_responses/saleBill/sb_export_list_response.dart';
import 'package:soleoserp/models/api_responses/saleBill/sb_export_save_response.dart';
import 'package:soleoserp/models/api_responses/saleBill/sb_header_save_response.dart';
import 'package:soleoserp/models/api_responses/saleBill/sb_product_save_response.dart';
import 'package:soleoserp/models/api_responses/saleBill/search_sales_bill_search_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/sOProductListFromOrderNoListResponse.dart';
import 'package:soleoserp/models/api_responses/saleOrder/salesOrder_Product_Save_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/sales_order_delete_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/sales_order_header_save_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/sales_order_pdf_generate_pdf_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/sales_order_product_delete_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/salesorder_list_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/search_salesorder_list_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/shipment/so_shipment_address_drop_down_api_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/shipment/so_shipment_list_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/shipment/so_shipment_save_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/so_currency_list_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/so_export/so_export_list_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/so_export/so_export_save_response.dart';
import 'package:soleoserp/models/api_responses/salesOrder_Approval/salesOrder_Approval_List_Response.dart';
import 'package:soleoserp/models/api_responses/salesOrder_Approval/salesOrder_approval_status_list_response.dart';
import 'package:soleoserp/models/api_responses/sales_target/sales_target_add_update_response.dart';
import 'package:soleoserp/models/api_responses/sales_target/sales_target_list_response.dart';
import 'package:soleoserp/models/api_responses/service_report_response/service_report_add_update_response.dart';
import 'package:soleoserp/models/api_responses/service_report_response/service_report_details_add_update_response.dart';
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
import 'package:soleoserp/models/api_responses/swastik_telecaller_response/telecaller_new_pagination_response.dart';
import 'package:soleoserp/models/api_responses/telecaller/tele_caller_delete_image_response.dart';
import 'package:soleoserp/models/api_responses/telecaller/tele_caller_followup_save_response.dart';
import 'package:soleoserp/models/api_responses/telecaller/tele_caller_search_by_name_response.dart';
import 'package:soleoserp/models/api_responses/telecaller/telecaller_list_response.dart';
import 'package:soleoserp/models/api_responses/third_party_api_response/third_party_api_response.dart';
import 'package:soleoserp/models/api_responses/to_do/invoice_document_delete_response.dart';
import 'package:soleoserp/models/api_responses/to_do/invoice_document_upload_respnse.dart';
import 'package:soleoserp/models/api_responses/to_do/nvoice_document_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/task_category_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_delete_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_employee_noto_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_header_save_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_module_sharing_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_save_sub_details_response.dart';
import 'package:soleoserp/models/api_responses/to_do/to_do_worklog_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/todo_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do/transection_mode_list_response.dart';
import 'package:soleoserp/models/api_responses/to_do_office/to_do_office_list_response.dart';
import 'package:soleoserp/models/api_responses/visitor_info_response/visitor_info_add_update_response.dart';
import 'package:soleoserp/models/api_responses/visitor_info_response/visitor_info_list_response.dart';
import 'package:soleoserp/models/api_responses/vk_sound_complaint/vk_complain_history_response.dart';
import 'package:soleoserp/models/api_responses/vk_sound_complaint/vk_complain_pkid_to_details_response.dart';
import 'package:soleoserp/models/api_responses/vk_sound_complaint/vk_sound_complain_list_response.dart';
import 'package:soleoserp/models/api_responses/vk_sound_complaint/vk_sound_complaint_delete_response.dart';
import 'package:soleoserp/models/api_responses/vk_sound_complaint/vk_sound_complaint_save_response.dart';
import 'package:soleoserp/models/common/Maintenance_product_model.dart';
import 'package:soleoserp/models/common/MaterialOutwardDetailsTable.dart';
import 'package:soleoserp/models/common/Material_Inward_Product_table.dart';
import 'package:soleoserp/models/common/contact_model.dart';
import 'package:soleoserp/models/common/final_checking_items.dart';
import 'package:soleoserp/models/common/inquiry_product_model.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:soleoserp/models/common/multiple_expense_table.dart';
import 'package:soleoserp/models/common/packingProductAssamblyTable.dart';
import 'package:soleoserp/models/common/repairing_table.dart';
import 'package:soleoserp/models/common/workNotes_model.dart';
import 'package:soleoserp/models/hema_automation/api_request/quick_complaint/quick_complaint_list_request.dart';
import 'package:soleoserp/models/hema_automation/api_request/quick_complaint/quick_complaint_save_request.dart';
import 'package:soleoserp/models/hema_automation/api_response/quick_complaint/quick_complaint_list_response.dart';
import 'package:soleoserp/models/hema_automation/api_response/quick_complaint/quick_complaint_save_response.dart';
import 'package:soleoserp/models/pushnotification/fcm_notification_response.dart';
import 'package:soleoserp/models/pushnotification/get_report_to_token_request.dart';
import 'package:soleoserp/models/pushnotification/get_report_to_token_response.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:soleoserp/models/api_requests/Expense_Tracking_nikhil/expense_tracking_list_requests.dart';
import 'package:soleoserp/models/api_requests/Expense_Tracking_nikhil/expense_tracking_save_requests.dart';
import 'package:soleoserp/models/api_responses/Expense_Tracking_nikhil/expense_tracking_list_responses.dart';
import 'package:soleoserp/models/api_responses/Expense_Tracking_nikhil/expense_tracking_save_responses.dart';

import 'api_client.dart';
import 'error_response_exception.dart';

// will be user for user related api calling and data processing
class Repository {
  SharedPrefHelper prefs = SharedPrefHelper.instance;
  final ApiClient apiClient;

  CompanyDetailsResponse _offlineCompanyData;

  Repository({@required this.apiClient});

  static Repository getInstance() {
    return Repository(apiClient: ApiClient(httpClient: http.Client()));
  }

  ///add your functions of api calls as below

  Future<CompanyDetailsResponse> CompanyDetailsCallApi(
      CompanyDetailsApiRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOGIN, companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      CompanyDetailsResponse companyDetailsResponse =
          CompanyDetailsResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MasterBaseURLResponse> MasterBaseURLAPI(
      CompanyDetailsApiRequest companyDetailsApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.MasterBaseURLAPI(
          ApiClient.END_POINT_MASTER_BASE_URL,
          companyDetailsApiRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      MasterBaseURLResponse companyDetailsResponse =
          MasterBaseURLResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerCategoryResponse> customer_Category_List_call(
      CustomerCategoryRequest categoryResponse) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_CATEGORY, categoryResponse.toJson());
      CustomerCategoryResponse companyDetailsResponse =
          CustomerCategoryResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerSourceResponse> customer_Source_List_call(
      CustomerSourceRequest sourceRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_SOURCE, sourceRequest.toJson());
      CustomerSourceResponse customerSourceResponse =
          CustomerSourceResponse.fromJson(json);
      return customerSourceResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupHistoryListResponse> inquiry_no_to_followup_details(
      InquiryNoToFollowupDetailsRequest sourceRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQUIRY_NO_FOLLLOWUP_DETAILS,
          sourceRequest.toJson());
      FollowupHistoryListResponse customerSourceResponse =
          FollowupHistoryListResponse.fromJson(json);
      return customerSourceResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  ///Login USer APi Details as below
  Future<LoginUserDetialsResponse> loginUserDetailsCall(
      LoginUserDetialsAPIRequest loginUserDetialsAPIRequest) async {
    try {
      /*  String jsonString = await apiClient.apiCallLoginUSerPost(
          */ /*ApiClient.END_POINT_LOGIN_USER_DETAILS*/ /*
          "Login/" + loginUserDetialsAPIRequest.companyId.toString(),
          loginUserDetialsAPIRequest.toJson());
      print("json - $jsonString");
      List<dynamic> list = json.decode(jsonString);*/
      //return LoginUserDetials.fromJson(list[0]);

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOGIN_USER_DETAILS +
              "/" +
              loginUserDetialsAPIRequest.companyId.toString(),
          loginUserDetialsAPIRequest.toJson());
      LoginUserDetialsResponse loginUserDetialsResponse =
          LoginUserDetialsResponse.fromJson(json);
      return loginUserDetialsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
      //throw FetchDataException('No Internet Connection');
    }
  }

  Future<CustomerDetailsResponse> CustomerDetailsCall(
      CustomerPaginationRequest customerPaginationRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_PAGINATION + "/1-10",
          customerPaginationRequest.toJson());
      CustomerDetailsResponse customerDetailsResponse =
          CustomerDetailsResponse.fromJson(json);
      return customerDetailsResponse;

      /*String jsonString = await apiClient.apiCallCustomerPaginationPost(
          ApiClient.END_POINT_LOGIN_USER_DETAILS
          "Customer/1-10/",
          customerPaginationRequest.toJson());
      print("json - $jsonString");
      List<dynamic> list = json.decode(jsonString);
      //return CustomerDetailsFromJson(jsonString);*/ /*
      return CustomerDetailsResponse.fromJson(list[0]);*/
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CountryListResponse> country_list_call(
      CountryListRequest countryListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_COUNTRYLIST, countryListRequest.toJson());
      CountryListResponse countryListResponse =
          CountryListResponse.fromJson(json);
      return countryListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CountryListResponseForPacking> country_list_call_For_Packing(
      CountryListRequest countryListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_COUNTRYLIST, countryListRequest.toJson());
      CountryListResponseForPacking countryListResponse =
          CountryListResponseForPacking.fromJson(json);
      return countryListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<StateListResponse> state_list_call(
      StateListRequest stateListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_STATELIST, stateListRequest.toJson());
      StateListResponse stateListResponse = StateListResponse.fromJson(json);
      return stateListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerDetailsResponse> customer_list_pagination(
      CustomerPaginationRequest customerPaginationRequest, int query) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostPagination(
          ApiClient.END_POINT_CUSTOMER_PAGINATION,
          '$query',
          customerPaginationRequest.toJson());
      CustomerDetailsResponse customerDetailsResponse =
          CustomerDetailsResponse.fromJson(json);
      return customerDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> customer_search_label_value(
      CustomerLabelValueRequest customerLabelValueRequest) async {
    try {
      String jsonString = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_SEARCH,
          customerLabelValueRequest.toJson());
      print("CustomerLabeljson - $jsonString");
      // var list = json.decode(jsonString);
      return jsonString; //CustomerCategoryResponseFromJson(list);
      //  return LoginApiResponse.fromJson(list[0]);
      /* Future<CustomerCategoryResponse> itemsList = (await Future<CustomerCategoryResponse>.from(list.map((i) => LoginApiResponse.fromJson(i)))) as Future<CustomerCategoryResponse>;
      return itemsList;*/
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> customer_search_by_id(
      CustomerSearchByIdRequest customerSearchByIdRequest) async {
    try {
      String jsonString = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_SEARCH_BY_ID +
              customerSearchByIdRequest.CustomerID.toString(),
          customerSearchByIdRequest.toJson());
      print("CustomerLabeljson - $jsonString");
      // var list = json.decode(jsonString);
      return jsonString; //CustomerCategoryResponseFromJson(list);
      //  return LoginApiResponse.fromJson(list[0]);
      /* Future<CustomerCategoryResponse> itemsList = (await Future<CustomerCategoryResponse>.from(list.map((i) => LoginApiResponse.fromJson(i)))) as Future<CustomerCategoryResponse>;
      return itemsList;*/
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DistrictApiResponse> district_list_details(
      DistrictApiRequest districtApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.End_POINT_DISTRICT_LIST, districtApiRequest.toJson());
      DistrictApiResponse districtApiResponse =
          DistrictApiResponse.fromJson(json);
      return districtApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TalukaApiRespose> taluka_list_details(
      TalukaApiRequest talukaApiRequest) async {
    try {
      /*   String jsonString = await apiClient.apiCallPost(
          ApiClient.END_POINT_TALUKA_LIST, talukaApiRequest.toJson());
      print("End_POINT_DISTRICT_LIST - $jsonString");
      // var list = json.decode(jsonString);
      return jsonString; //CustomerCategoryResponseFromJson(list);
      //  return LoginApiResponse.fromJson(list[0]);
      */ /* Future<CustomerCategoryResponse> itemsList = (await Future<CustomerCategoryResponse>.from(list.map((i) => LoginApiResponse.fromJson(i)))) as Future<CustomerCategoryResponse>;
      return itemsList;*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TALUKA_LIST, talukaApiRequest.toJson());
      TalukaApiRespose talukaApiRespose = TalukaApiRespose.fromJson(json);
      return talukaApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CityApiRespose> city_list_details(
      CityApiRequest talukaApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CITY_LIST, talukaApiRequest.toJson());
      CityApiRespose cityApiRespose = CityApiRespose.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<OutWordNoListResponse> OutWordAPI(
      OutWordNoListRequest outWordNoListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PackingOutWord_List,
          outWordNoListRequest.toJson());
      OutWordNoListResponse cityApiRespose =
          OutWordNoListResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PackingNoListResponse> PackingNoListAPI(
      OutWordNoListRequest outWordNoListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PACKING_NO_LIST, outWordNoListRequest.toJson());
      PackingNoListResponse cityApiRespose =
          PackingNoListResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FinalCheckingItemsResponse> FinalCheckingItemsAPI(
      FinalCheckingItemsRequest finalCheckingItemsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FINAL_CHECKING_ITEMS,
          finalCheckingItemsRequest.toJson());
      FinalCheckingItemsResponse cityApiRespose =
          FinalCheckingItemsResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CheckingNoToCheckingItemsResponse> CheckingNoToCheckingItemsAPI(
      CheckingNoToCheckingItemsRequest finalCheckingItemsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CHECKING_TO_CHECKING_ITEMS,
          finalCheckingItemsRequest.toJson());
      CheckingNoToCheckingItemsResponse cityApiRespose =
          CheckingNoToCheckingItemsResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FinalCheckingHeaderSaveResponse> finalCheckingHeaderSaveApi(int pkID,
      FinalCheckingHeaderSaveRequest finalCheckingItemsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FINAL_CHEKING_SAVE + pkID.toString() + "/Save",
          finalCheckingItemsRequest.toJson());
      FinalCheckingHeaderSaveResponse cityApiRespose =
          FinalCheckingHeaderSaveResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FinalCheckingDeleteAllItemResponse> finalCheckingDeleteAllItemApi(
      String fcNo,
      FinalCheckingDeleteAllItemsRequest finalCheckingItemsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FINAL_CHEKING_DELETE_ALL_ITEM +
              fcNo.toString() +
              "/Del",
          finalCheckingItemsRequest.toJson());
      FinalCheckingDeleteAllItemResponse cityApiRespose =
          FinalCheckingDeleteAllItemResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FinalCheckingDeleteAllItemResponse> finalCheckingDeleteApi(int pkID,
      FinalCheckingDeleteAllItemsRequest finalCheckingItemsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FINAL_CHEKING_DELETE_FROM_LIST_SCREEN +
              pkID.toString() +
              "/Del",
          finalCheckingItemsRequest.toJson());
      FinalCheckingDeleteAllItemResponse cityApiRespose =
          FinalCheckingDeleteAllItemResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PackingProductAssamblyListResponse> PackingProductAssamblyListAPI(
      PackingProductAssamblyListRequest outWordNoListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PackingProductAssamblyList,
          outWordNoListRequest.toJson());
      PackingProductAssamblyListResponse cityApiRespose =
          PackingProductAssamblyListResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductGroupDropDownResponse> ProductGroupDropDownAPi(
      ProductGroupDropDownRequest outWordNoListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Product_GroupDropDown,
          outWordNoListRequest.toJson());
      ProductGroupDropDownResponse cityApiRespose =
          ProductGroupDropDownResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductDropDownResponse> ProductDropDownAPi(
      ProductDropDownRequest outWordNoListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Product_DropDown, outWordNoListRequest.toJson());
      ProductDropDownResponse cityApiRespose =
          ProductDropDownResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PackingSaveResponse> PackingSaveAPi(
      int pkID, PackingSaveRequest outWordNoListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PACKING_SAVE + pkID.toString() + "/Save",
          outWordNoListRequest.toJson());
      PackingSaveResponse cityApiRespose = PackingSaveResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<Delete_ALL_Assambly_Response> DeleteAllPackingAssamblyAPI(
      String PcNo, DeleteAllPakingAssamblyRequest outWordNoListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PACKING_ASSAMBLY_ALL_DELETE +
              PcNo.toString() +
              "/Del",
          outWordNoListRequest.toJson());
      Delete_ALL_Assambly_Response cityApiRespose =
          Delete_ALL_Assambly_Response.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PackingAssamblyEditModeResponse> PackingAssamblyEditModeAPI(
      PackingAssamblyEditModeRequest outWordNoListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PACKING_ASSAMBLY_EDIT_MODE,
          outWordNoListRequest.toJson());
      PackingAssamblyEditModeResponse cityApiRespose =
          PackingAssamblyEditModeResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryListResponse> getInquiryList(
      int pageNo, InquiryListApiRequest inquiryListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_INQUIRY}/$pageNo-10",
          inquiryListApiRequest.toJson());
      InquiryListResponse response = InquiryListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryListResponse1> getInquiryList1(
      int pageNo, InquiryListApiRequest1 inquiryListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_INQUIRY}/$pageNo-10",
          inquiryListApiRequest.toJson());
      InquiryListResponse1 response = InquiryListResponse1.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<OutNoFromInquiryNoResponse> getSubDetailsofInquiryQuotationNoList(
      OutNoFromInquiryNoRequest inquiryListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_GET_SUB_DETAILS_INQ_QT_NO_LIST,
          inquiryListApiRequest.toJson());

      OutNoFromInquiryNoResponse response =
          OutNoFromInquiryNoResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryProductSearchResponse> getInquiryProductSearchList(
      InquiryProductSearchRequest inquiryProductSearchRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PRODUCT_SEARCH,
          inquiryProductSearchRequest.toJson());
      InquiryProductSearchResponse response =
          InquiryProductSearchResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationOrganizationListResponse> getQuotationOrganizationListAPI(
      QuotationOrganazationListRequest quotationOrganazationListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QT_ORGANIZATION_DROP_DOWN_LIST + "1-100000",
          quotationOrganazationListRequest.toJson());
      QuotationOrganizationListResponse response =
          QuotationOrganizationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationSaveHeaderResponse> getQuotationHeaderSaveResponse(
      int pkID, QuotationHeaderSaveRequest inquiryProductSearchRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_QUOTATION_HEADER_REQUEST}/$pkID/Save",
          inquiryProductSearchRequest.toJson());
      QuotationSaveHeaderResponse response =
          QuotationSaveHeaderResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationSaveHeaderResponse> getAcurabathQuotationHeaderSaveResponse(
      int pkID,
      AccuraBathQuotationHeaderSaveRequest inquiryProductSearchRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_QUOTATION_HEADER_REQUEST}/$pkID/Save",
          inquiryProductSearchRequest.toJson());
      QuotationSaveHeaderResponse response =
          QuotationSaveHeaderResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryHeaderSaveResponse> getInquiryHeaderSave(
      int pkID, InquiryHeaderSaveRequest inquiryHeaderSaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQUIRY_HEADER_SAVE + pkID.toString() + "/Save",
          inquiryHeaderSaveRequest.toJson());
      InquiryHeaderSaveResponse response =
          InquiryHeaderSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryNoToProductResponse> getInquiryNoToProductList(
      InquiryNoToProductListRequest inquiryNoToProductListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQUIRY_NO_TO_PRODUCT_LIST,
          inquiryNoToProductListRequest.toJson());
      InquiryNoToProductResponse response =
          InquiryNoToProductResponse.fromJson(json);

      /* for (int i = 0; i < response.details.length; i++) {
        SizeListRequest sizeListRequest = SizeListRequest();
        sizeListRequest.ProductID = response.details[i].productID.toString();
        sizeListRequest.LoginUserID = inquiryNoToProductListRequest.LoginUserID;
        sizeListRequest.CompanyId = inquiryNoToProductListRequest.CompanyId;

        Map<String, dynamic> json1 = await apiClient.apiCallPost(
            ApiClient.END_POINT_SIZED_LIST_FROM_PRODUCTID,
            sizeListRequest.toJson());
        SizeListResponse response1 = SizeListResponse.fromJson(json1);

        for (int j = 0; j < response1.details.length; j++) {
          print("ProductIDtoSizedList" + response1.details[j].sizeName);

          await OfflineDbHelper.getInstance().insertProductPriceList(PriceModel(
              response.details[j].productID.toString(),
              response.details[j].productName.toString(),
              response1.details[j].sizeID.toString(),
              response1.details[j].sizeName.toString(),
              "false"));
        }
      }*/

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryNoToDeleteProductResponse> getInquiryNoToDeleteProductList(
      String InqNo,
      InquiryNoToDeleteProductRequest inquiryNoToDeleteProductRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQUIRY_NO_TO_DELETE_PRODUCT_LIST +
              InqNo +
              "/MultiProductDelete",
          inquiryNoToDeleteProductRequest.toJson());
      InquiryNoToDeleteProductResponse response =
          InquiryNoToDeleteProductResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationProductDeleteResponse> getQtNoToDeleteProductList(
      QuotationProductDeleteRequest quotationProductDeleteRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QT_NO_TO_DELETE_PRODUCT_LIST,
          quotationProductDeleteRequest.toJson());
      QuotationProductDeleteResponse response =
          QuotationProductDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryListResponse> getInquiryByPkID(String pkID,
      InquirySearchByPkIdRequest inquirySearchByPkIdRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQUIRY_SEARCH_BY_PKID + pkID,
          inquirySearchByPkIdRequest.toJson());
      InquiryListResponse response = InquiryListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryListResponse1> getInquiryByPkID1(String pkID,
      InquirySearchByPkIdRequest inquirySearchByPkIdRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQUIRY_SEARCH_BY_PKID + pkID,
          inquirySearchByPkIdRequest.toJson());
      InquiryListResponse1 response = InquiryListResponse1.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupListResponse> getFollowupList(
      int pageNo, FollowupListApiRequest followupListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_FOLLOWUP}/$pageNo-10",
          followupListApiRequest.toJson());
      FollowupListResponse response = FollowupListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryListResponse> getInquiryListSearchByNumber(
      SearchInquiryListByNumberRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQUIRY_SEARCH_BY_INQUIRY_NO, request.toJson());
      InquiryListResponse response = InquiryListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SearchInquiryListResponse> getInquiryListSearchByName(
      SearchInquiryListByNameRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQUIRY_SEARCH_BY_NAME, request.toJson());
      SearchInquiryListResponse response =
          SearchInquiryListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryListResponse> getInquiryListSearchByNameFillter(
      SearchInquiryListFillterByNameRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQUIRY_SEARCH_BY_FILLTER, request.toJson());
      InquiryListResponse response = InquiryListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerDetailsResponse> getCustomerList(
      int pageNo, CustomerPaginationRequest customerPaginationRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_PAGINATION}/$pageNo-10",
          customerPaginationRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print(
          "ToJSONRESPONSFG : " + customerPaginationRequest.toJson().toString());
      CustomerDetailsResponse response = CustomerDetailsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DailyActivityListResponse> getDailyActivityList(
      int pageNo, DailyActivityListRequest customerPaginationRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_DAILY_ACTIVITY_LIST_DETAILS}/$pageNo-10",
          customerPaginationRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print(
          "ToJSONRESPONSFG : " + customerPaginationRequest.toJson().toString());
      DailyActivityListResponse response =
          DailyActivityListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankVoucherListResponse> getBankVoucherList(
      int pageNo, BankVoucherListRequest customerPaginationRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_BANK_VOUCHER_LIST_DETAILS}/$pageNo-10",
          customerPaginationRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print(
          "ToJSONRESPONSFG : " + customerPaginationRequest.toJson().toString());
      BankVoucherListResponse response = BankVoucherListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<EmployeeListResponse> getEmployeeList(
      int pageNo, EmployeeListRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_EMPLOYEE_LIST_DETAILS}/$pageNo-10",
          employeeListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      EmployeeListResponse response = EmployeeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<EmployeeListResponse> getEmployeeListWithOneImage(
      int pageNo, EmployeeListRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_EMPLOYEE_LIST_DETAILS}/$pageNo-10000",
          employeeListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      EmployeeListResponse response = EmployeeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LoanListResponse> getLoanList(
      int pageNo, LoanListRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_LOAN_LIST_DETAILS}/$pageNo-10",
          employeeListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      LoanListResponse response = LoanListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaintenanceListResponse> getMaintenanceList(
      int pageNo, MaintenanceListRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MAINTENANCE_LIST_DETAILS,
          employeeListRequest.toJson());
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      MaintenanceListResponse response = MaintenanceListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaintenanceListResponse> getMaintenanceSearch(
      MaintenanceSearchRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_MAINTENANCE_SEARCH_DETAILS}",
          employeeListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      MaintenanceListResponse response = MaintenanceListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MissedPunchListResponse> getMissedPunchList(
      int pageNo, MissedPunchListRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_MISSED_PUNCH_LIST_DETAILS}/$pageNo-10",
          employeeListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      MissedPunchListResponse response = MissedPunchListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LoanListResponse> getSalaryUpadList(
      int pageNo, SalaryUpadListRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SALARY_UPAD_LIST_DETAILS}/$pageNo-10",
          employeeListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      LoanListResponse response = LoanListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<EmployeeListResponse> getEmployeeSearchResult(
      EmployeeSearchRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_EMPLOYEE_SEARCH_DETAILS,
          employeeListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      EmployeeListResponse response = EmployeeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LoanListResponse> getLoanSearchResult(
      LoanSearchRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOAN_SEARCH_DETAILS,
          employeeListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      LoanListResponse response = LoanListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MissedPunchListResponse> getMissedPunchSearchByID(int pkID,
      MissedPunchSearchByIDRequest missedPunchSearchByNameRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_MISSED_PUNCH_SEARCH_BY_ID_DETAILS}$pkID",
          missedPunchSearchByNameRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " +
          missedPunchSearchByNameRequest.toJson().toString());
      MissedPunchListResponse response = MissedPunchListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankVoucherDeleteResponse> getMissedDeleteByID(
      int pkID, BankVoucherDeleteRequest missedPunchSearchByNameRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_MISSED_PUNCH_DELETE_BY_ID_DETAILS}/$pkID/Delete",
          missedPunchSearchByNameRequest.toJson(),
          showSuccessDialog: true);
      print("ToJSONRESPONSFG : " +
          missedPunchSearchByNameRequest.toJson().toString());
      BankVoucherDeleteResponse response =
          BankVoucherDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankVoucherDeleteResponse> getsalaryUpadDelete(
      int pkID, BankVoucherDeleteRequest missedPunchSearchByNameRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_MISSED_SALARY_UPAD_DELETE_BY_ID_DETAILS}/$pkID/Del",
          missedPunchSearchByNameRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " +
          missedPunchSearchByNameRequest.toJson().toString());
      BankVoucherDeleteResponse response =
          BankVoucherDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MissedPunchSearchByNameResponse> getMissedPunchSearchByName(
      MissedPunchSearchByNameRequest missedPunchSearchByNameRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MISSED_PUNCH_SEARCH_DETAILS,
          missedPunchSearchByNameRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " +
          missedPunchSearchByNameRequest.toJson().toString());
      MissedPunchSearchByNameResponse response =
          MissedPunchSearchByNameResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LoanListResponse> getLoanApprovalList(
      LoanApprovalListRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOAN_APPROVAL_LIST_DETAILS,
          employeeListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      LoanListResponse response = LoanListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LoanApprovalSaveResponse> getLoanApprovalSAve(
      int pkID, LoanApprovalSaveRequest loanApprovalSaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOAN_APPROVAL_SAVE_DETAILS +
              pkID.toString() +
              "/LoanUpd",
          loanApprovalSaveRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + loanApprovalSaveRequest.toJson().toString());
      LoanApprovalSaveResponse response =
          LoanApprovalSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MissedPunchApprovalListResponse> getMissedPunchApprovalList(
      MissedPunchApprovalListRequest missedPunchApprovalListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MISSED_PUNCH_APPROVAL_LIST_DETAILS,
          missedPunchApprovalListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " +
          missedPunchApprovalListRequest.toJson().toString());
      MissedPunchApprovalListResponse response =
          MissedPunchApprovalListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MissedPunchApprovalSaveResponse> getMissedPunchApprovalSave(int pkID,
      MissedPunchApprovalSaveRequest missedPunchApprovalListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MISSED_PUNCH_APPROVAL_SAVE +
              pkID.toString() +
              "/ChangeApproval",
          missedPunchApprovalListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " +
          missedPunchApprovalListRequest.toJson().toString());
      MissedPunchApprovalSaveResponse response =
          MissedPunchApprovalSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ComplaintListResponse> getComplaintList(
      int pageNo, ComplaintListRequest complaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_COMPLAINT_LIST_DETAILS}/$pageNo-10",
          complaintListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintListRequest.toJson().toString());
      ComplaintListResponse response = ComplaintListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AccuraBathComplaintListResponse> getAccurabathComplaintList(int pageNo,
      AccuraBathComplaintListRequest accuraBathComplaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_ACURABATH_OMPLAINT_LIST_DETAILS}/$pageNo-10",
          accuraBathComplaintListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " +
          accuraBathComplaintListRequest.toJson().toString());
      AccuraBathComplaintListResponse response =
          AccuraBathComplaintListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FetchAccuraBathComplaintImageListResponse>
      AccuraBathComplaintImage_list_details(
          FetchAccuraBathComplaintImageListRequest
              fetchComplaintImageListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ACCURABATH_COMPLAINT_IMAGE_LIST,
          fetchComplaintImageListRequest.toJson());
      FetchAccuraBathComplaintImageListResponse cityApiRespose =
          FetchAccuraBathComplaintImageListResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AccurabathComplaintVideoListResponse>
      AccuraBathComplaint_Video_list_details(
          AccuraBathComplaintVideoListRequest
              accuraBathComplaintVideoListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ACURABATH_COMPLAINT_VIDEO_LIST,
          accuraBathComplaintVideoListRequest.toJson());
      AccurabathComplaintVideoListResponse cityApiRespose =
          AccurabathComplaintVideoListResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ComplaintSearchResponse> getComplaintSearchByName(
      ComplaintSearchRequest complaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_COMPLAINT_SEARCH_BY_NAME_DETAILS}",
          complaintListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintListRequest.toJson().toString());
      ComplaintSearchResponse response = ComplaintSearchResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ComplaintSearchResponse> getVisitSearchByName(
      ComplaintSearchRequest complaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_ATTEND_VISIT_SEARCH_DETAILS}",
          complaintListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintListRequest.toJson().toString());
      ComplaintSearchResponse response = ComplaintSearchResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DolphinComplaintSearchResponse> getDolphinComplaintSearchByName(
      DolphinComplaintSearchRequest complaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_DOLPHIN_COMPLAINT_VISIT_SEARCH_DETAILS}",
          complaintListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintListRequest.toJson().toString());
      DolphinComplaintSearchResponse response =
          DolphinComplaintSearchResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ComplaintListResponse> getComplaintSearchByID(
      int pkID, ComplaintSearchByIDRequest complaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_COMPLAINT_SEARCH_BY_ID_DETAILS}/$pkID",
          complaintListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintListRequest.toJson().toString());
      ComplaintListResponse response = ComplaintListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AttendVisitListResponse> getVisitSearchByID(
      int pkID, ComplaintSearchByIDRequest complaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_ATTEND_VISIT_SAVE_DETAILS}/$pkID",
          complaintListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintListRequest.toJson().toString());
      AttendVisitListResponse response = AttendVisitListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AttendVisitDeleteResponse> getAttendVisitDeleteAPI(
      AttendVisitDeleteRequest complaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_ATTEND_VISIT_DELETE}",
          complaintListRequest.toJson(),
          showSuccessDialog:
              true /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintListRequest.toJson().toString());
      AttendVisitDeleteResponse response =
          AttendVisitDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DolphinComplaintVisitListResponse> getDolphinComplaintVisitSearchByID(
      int pkID, DolphinComplaintSearchByIDRequest complaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_DOLPHIN_COMPLAINT_VISIT_SEARCH_ID_DETAILS}/$pkID",
          complaintListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintListRequest.toJson().toString());
      DolphinComplaintVisitListResponse response =
          DolphinComplaintVisitListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DolphinComplaintVisitSaveResponse> getDolphinComplaintVisitSave(
      int pkID, DolphinComplaintVisitSaveRequest complaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_DOLPHIN_COMPLAINT_VISIT_SAVE_DETAILS}/$pkID/Save",
          complaintListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintListRequest.toJson().toString());
      DolphinComplaintVisitSaveResponse response =
          DolphinComplaintVisitSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DolphinComplaintVisitDeleteResponse> getDolphinComplaintVisitDelete(
      DolphinComplaintVisitDeleteRequest complaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_DOLPHIN_COMPLAINT_VISIT_DELETE_DETAILS}",
          complaintListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintListRequest.toJson().toString());
      DolphinComplaintVisitDeleteResponse response =
          DolphinComplaintVisitDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ComplaintSaveResponse> getComplaintSave(
      int pkID, ComplaintSaveRequest complaintSaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_COMPLAINT_SAVE_DETAILS}/$pkID/Save",
          complaintSaveRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintSaveRequest.toJson().toString());
      ComplaintSaveResponse response = ComplaintSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ComplaintDeleteResponse> DeleteComplaintBypkID(
      int pkID, ComplaintDeleteRequest complaintDeleteRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_COMPLAINT_SEARCH_BY_ID_DETAILS}/$pkID/Delete",
          complaintDeleteRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintDeleteRequest.toJson().toString());
      ComplaintDeleteResponse response = ComplaintDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankVoucherListResponse> getBankVoucherSearchByIDResponse(
      int id, BankVoucherSearchByIDRequest customerPaginationRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_BANK_VOUCHER_LIST_DETAILS}/$id/Fetch",
          customerPaginationRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print(
          "ToJSONRESPONSFG : " + customerPaginationRequest.toJson().toString());
      BankVoucherListResponse response = BankVoucherListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerDetailsResponse> getCustomerListSearchByNumber(
      CustomerSearchByIdRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_SEARCH_BY_ID + request.CustomerID,
          request.toJson());
      CustomerDetailsResponse response = CustomerDetailsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FCMNotificationResponse> fcm_get_api(var request) async {
    try {
      Map<String, dynamic> json =
          await apiClient.api_call_fcm_notification("/fcm/send", request);

      print("ritu" + json.toString());
      FCMNotificationResponse response = FCMNotificationResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FCMNotificationResponse> fcm_get_api_New(var request) async {
    try {
      Map<String, dynamic> json = await apiClient.api_call_fcm_notification_new(
          "/v1/projects/e-office-desk-flutter/messages:send", request);

      print("ritu" + json.toString());
      FCMNotificationResponse response = FCMNotificationResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerLabelvalueRsponse> getCustomerListSearchByName(
      CustomerLabelValueRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_SEARCH, request.toJson());
      CustomerLabelvalueRsponse response =
          CustomerLabelvalueRsponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerLabelvalueRsponse> getTeleCallerCustomerListSearchByName(
      CustomerLabelValueRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_SEARCH, request.toJson());
      CustomerLabelvalueRsponse response =
          CustomerLabelvalueRsponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationNoToProductResponse> getQTNotoProductList(
      QuotationNoToProductListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QTNO_TO_PRODUCT_LIST, request.toJson());
      QuotationNoToProductResponse response =
          QuotationNoToProductResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationNoToProductResponse1> getQTNotoProductList1(
      QuotationNoToProductListRequest1 request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QTNO_TO_PRODUCT_LIST, request.toJson());
      QuotationNoToProductResponse1 response =
          QuotationNoToProductResponse1.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SpecificationListResponse> getProductSpecificationList(
      String ModuleName, SpecificationListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUOTATION_SPEC_LIST +
              ModuleName +
              "/Specifications",
          request.toJson());
      SpecificationListResponse response =
          SpecificationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationKindAttListResponse> getQuotationKindAttList(
      QuotationKindAttListApiRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUOTATION_KIND_ATT_LIST, request.toJson());
      QuotationKindAttListResponse response =
          QuotationKindAttListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationProjectListResponse> getQuotationProjectList(
      QuotationProjectListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUOTATION_PROJECT_LIST, request.toJson());
      QuotationProjectListResponse response =
          QuotationProjectListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationTermsCondtionResponse> getQuotationTermConditionList(
      QuotationTermsConditionRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUOTATION_TERMS_CONDITION_LIST, request.toJson());
      QuotationTermsCondtionResponse response =
          QuotationTermsCondtionResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustIdToInqListResponse> getCustIdToInqList(
      CustIdToInqListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUST_ID_TO_INQ_LIST, request.toJson());
      CustIdToInqListResponse response = CustIdToInqListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InqNoToProductListResponse> getInqNoProductList(
      InquiryNoToProductListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQ_NO_PRODUCT_LIST, request.toJson());
      InqNoToProductListResponse response =
          InqNoToProductListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankDorpDownResponse> getBankDropDown(
      BankDropDownRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_BANK_DROP_DOWN, request.toJson());
      BankDorpDownResponse response = BankDorpDownResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankVoucherSearchByNameResponse> getBankVoucherSearchByName(
      BankVoucherSearchByNameRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_BANK_VOUCHER_SEARCH, request.toJson());
      BankVoucherSearchByNameResponse response =
          BankVoucherSearchByNameResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationListResponse> getQuotationList(
      int pageNo, QuotationListApiRequest quotationListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_QUOTATION}/$pageNo-10",
          quotationListApiRequest.toJson());
      QuotationListResponse response = QuotationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AcurabathQuotationListResponse> getAcurabathQuotationList(
      int pageNo, QuotationListApiRequest quotationListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_QUOTATION}/$pageNo-10",
          quotationListApiRequest.toJson());
      AcurabathQuotationListResponse response =
          AcurabathQuotationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesBillListResponse> getSalesBillList(
      int pageNo, SalesBillListRequest quotationListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SALESBILL}/$pageNo-10",
          quotationListApiRequest.toJson());
      SalesBillListResponse response = SalesBillListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationListResponse> getQuotationListSearchByNumber(
      int pkID, SearchQuotationListByNumberRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUOTATION_SEARCH_BY_QUOTATION_NO +
              pkID.toString() +
              "/Fetch",
          request.toJson());
      QuotationListResponse response = QuotationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AcurabathQuotationListResponse>
      getAcurabathQuotationListSearchByNumber(
          int pkID, SearchQuotationListByNumberRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUOTATION_SEARCH_BY_QUOTATION_NO +
              pkID.toString() +
              "/Fetch",
          request.toJson());
      AcurabathQuotationListResponse response =
          AcurabathQuotationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SearchQuotationListResponse> getQuotationListSearchByName(
      SearchQuotationListByNameRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUOTATION_SEARCH_BY_NAME, request.toJson());
      SearchQuotationListResponse response =
          SearchQuotationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationPDFGenerateResponse> getQuotationPDFGenerate(
      QuotationPDFGenerateRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUOTATION_GENERATE_PDF, request.toJson());
      QuotationPDFGenerateResponse response =
          QuotationPDFGenerateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesOrderPDFGenerateResponse> getSalesOrderPDFGenerate(
      SalesOrderPDFGenerateRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_ORDER_GENERATE_PDF, request.toJson());
      SalesOrderPDFGenerateResponse response =
          SalesOrderPDFGenerateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesBillPDFGenerateResponse> getSalesBillPDFGenerate(
      SalesBillPDFGenerateRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_BILL_GENERATE_PDF, request.toJson());
      SalesBillPDFGenerateResponse response =
          SalesBillPDFGenerateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SearchSalesBillListResponse> getSalesBillListSearchByName(
      SearchSalesBillListByNameRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_BILL_SEARCH_BY_NAME, request.toJson());
      SearchSalesBillListResponse response =
          SearchSalesBillListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesBillListResponse> getSalesBillSearchDetailsAPI(
      int CustID, SalesBillSearchByIdRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_BILL_BY_ID + CustID.toString() + "/Fetch",
          request.toJson());
      SalesBillListResponse response = SalesBillListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

/*  Future<String> menu_rights_api(MenuRightsRequest menuRightsRequest) async {
    try {
      String jsonString = await apiClient.apiCallPost(
          ApiClient.END_POINT_MENU_RIGHTS, menuRightsRequest.toJson());
      print("MenuRightsResponse - $jsonString");
      // var list = json.decode(jsonString);
      return jsonString; //CustomerCategoryResponseFromJson(list);
      //  return LoginApiResponse.fromJson(list[0]);
      */ /* Future<CustomerCategoryResponse> itemsList = (await Future<CustomerCategoryResponse>.from(list.map((i) => LoginApiResponse.fromJson(i)))) as Future<CustomerCategoryResponse>;
      return itemsList;*/ /*
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }*/

  Future<MenuRightsResponse> menu_rights_api(MenuRightsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MENU_RIGHTS, request.toJson());
      MenuRightsResponse response = MenuRightsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesOrderListResponse> getSalesOrderList(
      int pageNo, SalesOrderListApiRequest salesOrderListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SALESORDER_PAGINATION}/$pageNo-10",
          salesOrderListApiRequest.toJson());
      SalesOrderListResponse response = SalesOrderListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesTargetListResponse> getSalesTargetList(
      int pageNo, SalaryTargetListRequest salaryTargetListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SALES_TARGET_PAGINATION}/$pageNo-10",
          salaryTargetListRequest.toJson());
      SalesTargetListResponse response = SalesTargetListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getSalesTargetDeleteApi(
      SalesTargetDeleteRequest salesTargetDeleteRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_TARGET_DELETE,
          salesTargetDeleteRequest.toJson());
      String response = json['Message'];

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesTargetAddUpdateResponse> getSalesTargetAddUpdateAPI(
      SalasTargetAddUpdateRequest salesTargetAddUpdateRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_TARGET_ADD_EDIT,
          salesTargetAddUpdateRequest.toJson());
      SalesTargetAddUpdateResponse response =
          SalesTargetAddUpdateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SOShipmentlistResponse> getSoShipmentListAPI(
      SOShipmentListRequest soShipmentListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      String ORderNo = soShipmentListRequest.OrderNo;
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SO_SHIPMENT_LIST}/$ORderNo",
          soShipmentListRequest.toJson());
      SOShipmentlistResponse response = SOShipmentlistResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuoShipmentlistResponse> getQuoShipmentListAPI(
      QuoShipmentListRequest soShipmentListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUO_SHIPMENT_LIST,
          soShipmentListRequest.toJson());
      QuoShipmentlistResponse response = QuoShipmentlistResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SOExportListResponse> getSOExportListAPI(
      SOExportListRequest soExportListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      String ORderNo = soExportListRequest.OrderNo;
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SO_EXPORT_LIST}/$ORderNo",
          soExportListRequest.toJson());
      SOExportListResponse response = SOExportListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SOShipmentSaveResponse> saveSoShipmentListAPI(
      SOShipmentSaveRequest soShipmentSaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      String ORderNo = soShipmentSaveRequest.OrderNo;
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SO_SHIPMENT_LIST}/$ORderNo/Save",
          soShipmentSaveRequest.toJson());
      SOShipmentSaveResponse response = SOShipmentSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SOShipmentSaveResponse> saveQuoShipmentListAPI(
      QUOShipmentSaveRequest soShipmentSaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUO_SHIPMENT_SAVE,
          soShipmentSaveRequest.toJson());
      SOShipmentSaveResponse response = SOShipmentSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SOExportSaveResponse> soExportSaveAPI(
      SOExportSaveRequest soShipmentSaveRequest, String OrderNo) async {
    //todo due to one api bug temporary adding following key
    try {
      //String ORderNo = soShipmentSaveRequest.OrderNo;
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SO_EXPORT_SAVE}$OrderNo/Save",
          soShipmentSaveRequest.toJson());
      SOExportSaveResponse response = SOExportSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> deleteSoShipmentListAPI(
      SOShipmentDeleteRequest soShipmentSaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      //String ORderNo = soShipmentSaveRequest.OrderNo;
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SO_SHIPMENT_LIST}/Delete",
          soShipmentSaveRequest.toJson());
      String response = json['Message'];

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> deleteQuoShipmentListAPI(
      QuoShipmentDeleteRequest soShipmentSaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      //String ORderNo = soShipmentSaveRequest.OrderNo;
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUO_SHIPMENT_DELETE,
          soShipmentSaveRequest.toJson());
      String response = json['Message'];

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SearchSalesOrderListResponse> getSalesOrderListSearchByName(
      SearchSalesOrderListByNameRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALESORDER_SEARCH_BY_NAME, request.toJson());
      SearchSalesOrderListResponse response =
          SearchSalesOrderListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesOrderListResponse> getSalesOrderListSearchByNumber(
      int pkID, SearchSalesOrderListByNumberRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUOTATION_SEARCH_BY_SALESORDER_NO +
              pkID.toString() +
              "/Fetch",
          request.toJson());
      SalesOrderListResponse response = SalesOrderListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ToDoListResponse> getToDoWidgetList(
      ToDoWidgetListApiRequest toDoListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TODO_WIDGET, toDoListApiRequest.toJson());
      ToDoListResponse response = ToDoListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ToDoListResponse> getToDoList(
      ToDoListApiRequest toDoListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TODO_LIST, toDoListApiRequest.toJson());
      ToDoListResponse response = ToDoListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupListResponse> getFollowupListbyStatus(
      SearchFollowupListByNameRequest searchFollowupListByNameRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_SEARCH_BY_STATUS,
          searchFollowupListByNameRequest.toJson());
      FollowupListResponse response = FollowupListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowerEmployeeListResponse> getFollowerEmployeeList(
      FollowerEmployeeListRequest followerEmployeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWER_EMPLOYEE_LIST,
          followerEmployeeListRequest.toJson());
      FollowerEmployeeListResponse response =
          FollowerEmployeeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryShareEmpListResponse> getInquiryShareEmpList(
      InquiryShareEmpListRequest inquiryShareEmpListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQUIRY_SHARED_EMP_LIST,
          inquiryShareEmpListRequest.toJson());
      InquiryShareEmpListResponse response =
          InquiryShareEmpListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ALL_EmployeeList_Response> getALLEmployeeList(
      ALLEmployeeNameRequest followerEmployeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ALL_EMPLOYEE_LIST,
          followerEmployeeListRequest.toJson());
      ALL_EmployeeList_Response response =
          ALL_EmployeeList_Response.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LogOutCountResponse> getLogoutCount(
      LogoutCountRequest logoutCountRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOGOUT_COUNT, logoutCountRequest.toJson());
      LogOutCountResponse response = LogOutCountResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DesignationApiResponse> designation_list_details(
      DesignationApiRequest designationApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_DESIGNATION_LIST, designationApiRequest.toJson());
      DesignationApiResponse designationApiResponse =
          DesignationApiResponse.fromJson(json);
      return designationApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  /* Future<CustomerAddEditApiResponse>customer_add_edit_details(CustomerAddEditApiRequest customerAddEditApiRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_ADD_EDIT+"0/Save", customerAddEditApiRequest.toJson(),showSuccessDialog: true);
      CustomerAddEditApiResponse customerAddEditApiResponse =
      CustomerAddEditApiResponse.fromJson(json);
      return customerAddEditApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }*/
  Future<CustomerAddEditApiResponse> customer_add_edit_details(
      CustomerAddEditApiRequest customerAddEditApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_ADD_EDIT +
              customerAddEditApiRequest.customerID +
              "/Save",
          customerAddEditApiRequest.toJson());
      CustomerAddEditApiResponse customerAddEditApiResponse =
          CustomerAddEditApiResponse.fromJson(json);
      return customerAddEditApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerContactSaveResponse> customerContactSave_details(
      List<ContactModel> _contactsList) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_CUSTOMER_CONTACT_SAVE, _contactsList,
              showSuccessDialog: true);
      CustomerContactSaveResponse customerAddEditApiResponse123 =
          CustomerContactSaveResponse.fromJson(json);
      return customerAddEditApiResponse123;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerIdToContactListResponse> getCustomerListFromCustomerID(
      CustomerIdToCustomerListRequest customerIdToCustomerListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_ID_TO_CONTACT_DETAILS,
          customerIdToCustomerListRequest.toJson());
      CustomerIdToContactListResponse customerIdToContactListResponse =
          CustomerIdToContactListResponse.fromJson(json);
      return customerIdToContactListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerIdToDeleteAllContactResponse> getCustomerIdToDeleteAllContact(
      int pkID,
      CustomerIdToDeleteAllContactRequest
          customerIdToCustomerListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_ID_TO_CONTACT_ALL_DELETE +
              pkID.toString() +
              "/DeleteByCustomer",
          customerIdToCustomerListRequest.toJson());
      CustomerIdToDeleteAllContactResponse customerIdToContactListResponse =
          CustomerIdToDeleteAllContactResponse.fromJson(json);
      return customerIdToContactListResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryProductSaveResponse> inquiryProductSaveDetails(
      List<InquiryProductModel> inquiryProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_INQUIRY_PRODUCT_SAVE, inquiryProductModel);
      InquiryProductSaveResponse inquiryProductSaveResponse =
          InquiryProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

/*  Future<InquiryProductSaveResponse> inquiryBluetoneProductSaveDetails(
      List<BlueToneProductModel> inquiryProductModel) async {
    try {
      Map<String, dynamic> json =
      await apiClient.apiCallPostforMultipleJSONArray(
          ApiClient.END_POINT_INQUIRY_PRODUCT_SAVE, inquiryProductModel);
      InquiryProductSaveResponse inquiryProductSaveResponse =
      InquiryProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }*/

  Future<PackingAssamblySaveResponse> packingAssamblySaveAPI(
      List<PackingProductAssamblyTable> inquiryProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_PACKING_ASSAMBLY_SAVE, inquiryProductModel);
      PackingAssamblySaveResponse inquiryProductSaveResponse =
          PackingAssamblySaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FinalCheckingSubDetailsSaveResponse> finalCheckingSubDetailsSaveAPI(
      List<FinalCheckingItems> inquiryProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_FINAL_CHECKING_SUB_DETAILS_SAVE,
              inquiryProductModel);
      FinalCheckingSubDetailsSaveResponse inquiryProductSaveResponse =
          FinalCheckingSubDetailsSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationProductSaveResponse> quotationProductSaveDetails(String QT_No,
      List<NewQuotationProductTable> quotationProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_QUOTATION_PRODUCT_SAVE,
              quotationProductModel);
      QuotationProductSaveResponse inquiryProductSaveResponse =
          QuotationProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationProductSaveResponse1> quotationProductSaveDetails1(
      String QT_No,
      List<NewQuotationProductTable1> quotationProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_QUOTATION_PRODUCT_SAVE,
              quotationProductModel);
      QuotationProductSaveResponse1 inquiryProductSaveResponse =
          QuotationProductSaveResponse1.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QTSpecSaveResponse> quotationProductSpecificationSaveDetails(
      List<QTSpecSaveRequest> quotationProductModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              "${ApiClient.END_POINT_QT_SPECIFICATION_SAVE}",
              quotationProductModel);
      QTSpecSaveResponse inquiryProductSaveResponse =
          QTSpecSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryShareResponse> inquiryShareSaveDetails(
      List<InquiryShareModel> inquiryShareModel) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_INQUIRY_SHARE, inquiryShareModel);
      InquiryShareResponse inquiryShareResponse =
          InquiryShareResponse.fromJson(json);
      return inquiryShareResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

/*
  Future<CustomerDeleteResponse> deleteCustomer(String pkID,CustomerDeleteRequest customerDeleteRequest) async {
    try {

      Map<String, dynamic> json = await apiClient.apiCallLoginUSerPost(
          ApiClient.END_POINT_CUSTOMER_ADD_EDIT+ pkID +"/Delete", customerDeleteRequest.toJson());
      CustomerDeleteResponse customerDeleteResponse =
      CustomerDeleteResponse.fromJson(json);
      return customerDeleteResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }*/
/*  Future<void> deleteCustomer(int id,CustomerDeleteRequest customerDeleteRequest) async {
    try {
      await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_ADD_EDIT}/${id}/Delete", customerDeleteRequest.toJson());
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }*/

  Future<FollowupTypeListResponse> getFollowupTypeList(
      FollowupTypeListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_TYPE_LIST, request.toJson());
      FollowupTypeListResponse response =
          FollowupTypeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryStatusListResponse> getFollowupInquiryStatusList(
      FollowupInquiryStatusTypeListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_TYPE_LIST, request.toJson());
      InquiryStatusListResponse response =
          InquiryStatusListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CloserReasonListResponse> getCloserReasonStatusList(
      CloserReasonTypeListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_TYPE_LIST, request.toJson());
      CloserReasonListResponse response =
          CloserReasonListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupHistoryListResponse> getFollowupHistoryList(
      FollowupHistoryListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_HISTORY_LIST, request.toJson());
      FollowupHistoryListResponse response =
          FollowupHistoryListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuickFollowupListResponse> getQuickFollowupListAPi(
      QuickFollowupListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUICK_FOLLOWUP_LIST, request.toJson());
      QuickFollowupListResponse response =
          QuickFollowupListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupInquiryNoListResponse> getInquiryNoStatusList(
      FollowerInquiryNoListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_INQUIRY_NO_LIST, request.toJson());
      FollowupInquiryNoListResponse response =
          FollowupInquiryNoListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupSaveSuccessResponse> getFollowupSaveStatus(
      int pkID, FollowupSaveApiRequest request) async {
    try {
      ///Followup/{pkID}/Save
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_SAVE + pkID.toString() + "/Save",
          request.toJson());
      FollowupSaveSuccessResponse response =
          FollowupSaveSuccessResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupSaveSuccessResponse> getQuickFollowupSaveStatus(
      int pkID, FollowupSaveApiRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUICK_FOLLOWUP_SAVE + pkID.toString() + "/Save",
          request.toJson());
      FollowupSaveSuccessResponse response =
          FollowupSaveSuccessResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExpsenseSaveResponse> getExpenseSave(
      int pkID, ExpenseSaveAPIRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_EXPENSE_SAVE + pkID.toString() + "/Save",
          request.toJson());
      ExpsenseSaveResponse response = ExpsenseSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExpenseDeleteImageResponse> getDeleteExpenseImage(
      int pkID, ExpenseDeleteImageRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_EXPENSE_DELETE_IMAGE +
              pkID.toString() +
              "/DeleteImageByExpenseID",
          request.toJson());
      ExpenseDeleteImageResponse response =
          ExpenseDeleteImageResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExpenseImageUploadServerAPIResponse> getExpenseImageUploadserer(
      ExpenseImageUploadServerAPIRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_EXPENSE_UPLOAD_SERVER +
              request.ExpenseID +
              "/ImageSave",
          request.toJson());
      ExpenseImageUploadServerAPIResponse response =
          ExpenseImageUploadServerAPIResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryDeleteResponse> deleteInquiry(
      int id, FollowupDeleteRequest followupDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_INQUIRY_DELETE}/${id}/Delete",
          followupDeleteRequest.toJson(),
          showSuccessDialog: true);
      InquiryDeleteResponse response = InquiryDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationDeleteResponse> deleteQuotation(
      int id, QuotationDeleteRequest quotationDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_DELETE_QUOTATION}/${id}/Delete",
          quotationDeleteRequest.toJson(),
          showSuccessDialog: true);
      QuotationDeleteResponse response = QuotationDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PackingCheckListDeleteResponse> deletePackingCheckList(
      int id, PackingCheckListDeleteRequest quotationDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_PackingChecklist_DELETE}/${id}/Del",
          quotationDeleteRequest.toJson(),
          showSuccessDialog: true);
      PackingCheckListDeleteResponse response =
          PackingCheckListDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationOtherChargesListResponse> getQuotationOtherChargeList(
      String id,
      QuotationOtherChargesListRequest quotationOtherChargesListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_DELETE_QUOTATION}/${id}/Charges",
          quotationOtherChargesListRequest.toJson());
      QuotationOtherChargesListResponse response =
          QuotationOtherChargesListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupDeleteResponse> deleteFollowup(
      int id, FollowupDeleteRequest followupDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_FOLLOWUP_DELETE}/${id}/Delete", followupDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_FOLLOWUP_DELETE}/${id}/Delete",
          followupDeleteRequest.toJson());
      FollowupDeleteResponse response = FollowupDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupDeleteResponse> deleteQuickFollowup(
      int id, FollowupDeleteRequest followupDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_FOLLOWUP_DELETE}/${id}/Delete", followupDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_FOLLOWUP_DELETE}/${id}/Delete",
          followupDeleteRequest.toJson(),
          showSuccessDialog: false);
      FollowupDeleteResponse response = FollowupDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerDeleteResponse> deleteCustomer(
      int id, CustomerDeleteRequest customerDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete",
          customerDeleteRequest.toJson(),
          showSuccessDialog: true);
      CustomerDeleteResponse response = CustomerDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerDeleteResponse> deleteExternalLead(
      int id, CustomerDeleteRequest customerDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_EXTERNAL_LEAD_SAVE_DETAILS}/${id}/Delete",
          customerDeleteRequest.toJson(),
          showSuccessDialog: true);
      CustomerDeleteResponse response = CustomerDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerDeleteResponse> deleteTeleCaller(
      int id, CustomerDeleteRequest customerDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_TELE_CALLER_PAGINATION}/${id}/Delete",
          customerDeleteRequest.toJson(),
          showSuccessDialog: true);
      CustomerDeleteResponse response = CustomerDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LeaveRequestDeleteResponse> deleteLeaveRequest(
      int id, FollowupDeleteRequest followupDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_LEAVE_REQUEST_DELETE}/${id}/Delete", followupDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_LEAVE_REQUEST_DELETE}/${id}/Delete",
          followupDeleteRequest.toJson(),
          showSuccessDialog: true);
      LeaveRequestDeleteResponse response =
          LeaveRequestDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DailyActivityDeleteResponse> deleteDailyActivity(
      int id, DailyActivityDeleteRequest customerDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_DAILY_ACTIVITY_DELETE}/${id}/Delete",
          customerDeleteRequest.toJson(),
          showSuccessDialog: true);
      DailyActivityDeleteResponse response =
          DailyActivityDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DailyActivitySaveResponse> saveDailyActivity(
      int id, DailyActivitySaveRequest dailyActivitySaveRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_DAILY_ACTIVITY_SAVE_DETAILS}/${id}/Save",
          dailyActivitySaveRequest.toJson());
      DailyActivitySaveResponse response =
          DailyActivitySaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TaskCategoryResponse> taskCategoryDetails(
      TaskCategoryListRequest taskCategoryListRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TASK_CATEGORY, taskCategoryListRequest.toJson());
      TaskCategoryResponse response = TaskCategoryResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ModulesDropDownListResponse> ModulesDropDownListApi(
      ModulesDropDownListRequest taskCategoryListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_DAILY_ACTIVITY_MODULE_DRP_DETAILS,
          taskCategoryListRequest.toJson());
      ModulesDropDownListResponse response =
          ModulesDropDownListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankVoucherDeleteResponse> getbankvoucherDelete(
      int id, BankVoucherDeleteRequest bankVoucherDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_BANK_VOUCHER_LIST_DETAILS}/${id}/Delete",
          bankVoucherDeleteRequest.toJson());
      BankVoucherDeleteResponse response =
          BankVoucherDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankVoucherDeleteResponse> getEmployeeDelete(
      int id, BankVoucherDeleteRequest bankVoucherDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_EMPLOYEE_DELETE_DETAILS}/${id}/Del",
          bankVoucherDeleteRequest.toJson(),
          showSuccessDialog: true);
      BankVoucherDeleteResponse response =
          BankVoucherDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankVoucherDeleteResponse> getLoanDelete(
      int id, BankVoucherDeleteRequest bankVoucherDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_LOAN_LIST_DETAILS}/${id}/Del",
          bankVoucherDeleteRequest.toJson());
      BankVoucherDeleteResponse response =
          BankVoucherDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankVoucherDeleteResponse> getMaintenanceDelete(
      int id, BankVoucherDeleteRequest bankVoucherDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_MAINTENANCE_LIST_DETAILS}/${id}/Delete",
          bankVoucherDeleteRequest.toJson());
      BankVoucherDeleteResponse response =
          BankVoucherDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankVoucherSaveResponse> getbankvoucherSave(
      int id, BankVoucherSaveRequest bankVoucherDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_BANK_VOUCHER_LIST_DETAILS}/${id}/Save",
          bankVoucherDeleteRequest.toJson());
      BankVoucherSaveResponse response = BankVoucherSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TransectionModeListResponse> getTransectionModeList(
      TransectionModeListRequest bankVoucherDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_TRANSECTION_MODE_LIST_DETAILS}",
          bankVoucherDeleteRequest.toJson());
      TransectionModeListResponse response =
          TransectionModeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AttendVisitSaveResponse> getAttendVisitSave(
      int pkId, AttendVisitSaveRequest bankVoucherDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_ATTEND_VISIT_SAVE_DETAILS}/$pkId/Save",
          bankVoucherDeleteRequest.toJson());
      AttendVisitSaveResponse response = AttendVisitSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ToDoWorkLogListResponse> toDoWorkLogListMethod(
      ToDoWorkLogListRequest toDoWorkLogListRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TO_DO_WORK_LOG, toDoWorkLogListRequest.toJson());
      ToDoWorkLogListResponse response = ToDoWorkLogListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ToDoDeleteResponse> todoDeleteAPI(
      int pkId, ToDoDeleteRequest toDoDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_TO_DO_DELETE}/$pkId/Delete",
          toDoDeleteRequest.toJson());
      ToDoDeleteResponse response = ToDoDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ToDoSaveHeaderResponse> todo_save_method(
      int pkID, ToDoHeaderSaveRequest toDoHeaderSaveRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TO_DO_SAVE + pkID.toString() + "/Save",
          toDoHeaderSaveRequest.toJson());
      ToDoSaveHeaderResponse response = ToDoSaveHeaderResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ToDoSaveSubDetailsResponse> todo_save_sub_method(
      int pkID, ToDoSaveSubDetailsRequest toDoHeaderSaveRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TO_DO_SAVE + pkID.toString() + "/Log",
          toDoHeaderSaveRequest.toJson());
      ToDoSaveSubDetailsResponse response =
          ToDoSaveSubDetailsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExpenseDeleteResponse> deleteExpense(
      int id, FollowupDeleteRequest followupDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_EXPENSE_DELETE}/${id}/Delete",
          followupDeleteRequest.toJson(),
          showSuccessDialog: true);
      ExpenseDeleteResponse response = ExpenseDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<Attendance_List_Response> getAttendanceList(
      AttendanceApiRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ATTENDANCE_LIST, request.toJson());
      Attendance_List_Response response =
          Attendance_List_Response.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AttendVisitListResponse> getAttenVisitList(
      int pageNo, AttendVisitListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_ATTEND_VISIT_DETAILS}/$pageNo-10",
          request.toJson());
      AttendVisitListResponse response = AttendVisitListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DolphinComplaintVisitListResponse> getDolphinComplaintVisitList(
      int pageNo, DolphinComplaintVisitListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_DOLPHIN_ATTEND_VISIT_DETAILS}/$pageNo-10",
          request.toJson());
      DolphinComplaintVisitListResponse response =
          DolphinComplaintVisitListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ComplaintNoListResponse> getComplaintNoList(
      ComplaintNoListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_COMPLAINT_NO_LIST_DETAILS, request.toJson());
      ComplaintNoListResponse response = ComplaintNoListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AttendanceEmployeeListResponse> attendanceEmployeeList(
      AttendanceEmployeeListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWER_EMPLOYEE_LIST, request.toJson());
      AttendanceEmployeeListResponse response =
          AttendanceEmployeeListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FetchImageListByExpensePKID_Response> fetchImageListbyExpensePKID(
      FetchImageListByExpensePKID_Request request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FETCH_IMAGE_LIST_BY_EXPENSE_PKID,
          request.toJson());
      FetchImageListByExpensePKID_Response response =
          FetchImageListByExpensePKID_Response.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AttendanceSaveResponse> attendanceSave(
      AttendanceSaveApiRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ATTENDANCE_SAVE, request.toJson());
      AttendanceSaveResponse response = AttendanceSaveResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AttendanceSaveResponse> DashBoardattendanceSave(
      AttendanceSaveApiRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ATTENDANCE_SAVE, request.toJson(),
          showSuccessDialog: false);
      AttendanceSaveResponse response = AttendanceSaveResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LeaveRequestListResponse> getLeaveRequestList(
      int pageNo, LeaveRequestListAPIRequest leaveRequestListAPIRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_LEAVE_REQUEST_PAGINATION}/$pageNo-10",
          leaveRequestListAPIRequest.toJson());
      LeaveRequestListResponse response =
          LeaveRequestListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupFilterListResponse> getFollowupFilterList(
    String filtername,
    FollowupFilterListRequest request,
  ) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_FILTER_PAGINATION +
              filtername +
              "/Filter",
          request.toJson());
      FollowupFilterListResponse response =
          FollowupFilterListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupFilterListResponse> getFollowupFilterListForAlmightyApi(
    String filtername,
    FollowupFilterListForAlmightyRequest request,
  ) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_FILTER_PAGINATION_FOR_ALMIGHTY +
              filtername +
              "/Filter",
          request.toJson());
      FollowupFilterListResponse response =
          FollowupFilterListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LeaveRequestTypeResponse> getLeaveRequestType(
      LeaveRequestTypeAPIRequest leaveRequestListAPIRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LEAVE_REQUEST_TYPE,
          leaveRequestListAPIRequest.toJson());
      LeaveRequestTypeResponse response =
          LeaveRequestTypeResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LeaveRequestSaveResponse> getLeaveRequestSave(
      int pkID, LeaveRequestSaveAPIRequest leaveRequestSaveAPIRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LEAVE_REQUEST_SAVE + pkID.toString() + "/Save",
          leaveRequestSaveAPIRequest.toJson(),
          showSuccessDialog: true);
      LeaveRequestSaveResponse response =
          LeaveRequestSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LeaveApprovalSaveResponse> getLeaveApprovalSave(
      int pkID, LeaveApprovalSaveAPIRequest leaveApprovalSaveAPIRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LEAVE_REQUEST_SAVE +
              pkID.toString() +
              "/ChangeApproval",
          leaveApprovalSaveAPIRequest.toJson(),
          showSuccessDialog: true);
      LeaveApprovalSaveResponse response =
          LeaveApprovalSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExpenseListResponse> getExpenseList(
      int pageNo, ExpenseListAPIRequest expenseListAPIRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_EXPENSE_PAGINATION_FILTER}/$pageNo-10000",
          expenseListAPIRequest.toJson());
      ExpenseListResponse response = ExpenseListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExpenseTypeResponse> getExpenseType(
      ExpenseTypeAPIRequest expenseTypeAPIRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_EXPENSE_TYPE, expenseTypeAPIRequest.toJson());
      ExpenseTypeResponse response = ExpenseTypeResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

/*  Future<ExpenseUploadImageResponse> getuploadImage(List<File> imagesfiles,
      ExpenseUploadImageAPIRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_EXPENSE_UPLOAD,request.toJson(),imageFilesToUpload: imagesfiles);

     // print("response - ${json}");

      ExpenseUploadImageResponse response =
      ExpenseUploadImageResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }*/

  Future<ExpenseUploadImageResponse> getuploadImage(
      File imagesfiles,
      ExpenseUploadImageAPIRequest
          expenseUploadImageAPIRequest /*String expenseID, String companyId, String loginUserId, String fileName, String type, String pkID,*/) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_EXPENSE_UPLOAD,
          /*{
        "ExpenseID": "$expenseID",
        "CompanyId":"$companyId",
        "LoginUserId":"$loginUserId",
        "fileName":"$fileName",
        "pkID":"$pkID",
        "Type":'$type',

      }*/
          expenseUploadImageAPIRequest.toJson(),
          imageFilesToUpload: [imagesfiles]);
      ExpenseUploadImageResponse response =
          ExpenseUploadImageResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<Telecaller_image_upload_response> getuploadImageTeleCaller(
      File imagesfiles,
      TeleCallerUploadImgApiRequest expenseUploadImageAPIRequest) async {
    try {
      Map<String, dynamic> jsons = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_TELECALLER_IMG_UPLOAD,
          expenseUploadImageAPIRequest.toJson(),
          imageFilesToUpload: [imagesfiles]);
      print(jsons);
      Telecaller_image_upload_response response =
          Telecaller_image_upload_response.fromJson(jsons);

      return response;
    } on ErrorResponseException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<FollowupImageUploadResponse> getFollowupuploadImage(
      File imagesfiles, FollowUpUploadImageAPIRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_FOLLOWUP_UPLOAD, request.toJson(),
          imageFilesToUpload: [imagesfiles]);

      // print("response - ${json}");

      FollowupImageUploadResponse response =
          FollowupImageUploadResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupInquiryByCustomerIDResponse> getFollowupInquiryByCustomerID(
      FollowerInquiryByCustomerIDRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_INQUIRY_BY_CUSTOMER_ID,
          request.toJson());

      // print("response - ${json}");

      FollowupInquiryByCustomerIDResponse response =
          FollowupInquiryByCustomerIDResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupDeleteImageResponse> getFollowupImageDeleteByPkID(
      int pkID, FollowupImageDeleteRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_IMAGE_DELETE_BY_PK_ID +
              pkID.toString() +
              "/DeleteImage",
          request.toJson(),
          showSuccessDialog: true);

      // print("response - ${json}");

      FollowupDeleteImageResponse response =
          FollowupDeleteImageResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TeleCallerImageDeleteResponse> getTeleCallerImageDeleteByPkID(
      int pkID, TeleCallerImageDeleteRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TELECALLER_IMAGE_DELETE_BY_PK_ID +
              pkID.toString() +
              "/DeleteImage",
          request.toJson(),
          showSuccessDialog: true);

      // print("response - ${json}");

      TeleCallerImageDeleteResponse response =
          TeleCallerImageDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExternalLeadListResponse> getExternalLeadList(
      int pageNo, ExternalLeadListRequest customerPaginationRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_EXTERNAL_LEAD_PAGINATION}/$pageNo-10",
          customerPaginationRequest.toJson());
      ExternalLeadListResponse response =
          ExternalLeadListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TeleCallerListResponse> getTeleCallerList(
      int pageNo, TeleCallerListRequest customerPaginationRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_TELE_CALLER_PAGINATION1}/$pageNo-10",
          customerPaginationRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print(
          "ToJSONRESPONSFG : " + customerPaginationRequest.toJson().toString());
      TeleCallerListResponse response = TeleCallerListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExternalLeadSearchResponseByName> externalLeadSearchByNamedetails(
      ExternalLeadSearchRequest talukaApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_EXTERNAL_LEAD_SEARCH_DETAILS,
          talukaApiRequest.toJson());
      ExternalLeadSearchResponseByName cityApiRespose =
          ExternalLeadSearchResponseByName.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TeleCallerSearchResponseByName> getTeleCallerSearchByNamedetails(
      TeleCallerSearchRequest talukaApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TELE_CALLER_SEARCH_DETAILS,
          talukaApiRequest.toJson());
      TeleCallerSearchResponseByName cityApiRespose =
          TeleCallerSearchResponseByName.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExternalLeadListResponse> externalLeadSearchByIDDetails(
      ExternalLeadSearchRequest talukaApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_EXTERNAL_LEAD_SEARCH_DETAILS,
          talukaApiRequest.toJson());
      ExternalLeadListResponse cityApiRespose =
          ExternalLeadListResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TeleCallerListResponse> getTeleCallerLeadSearchByIDDetails(
      TeleCallerSearchRequest talukaApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TELE_CALLER_SEARCH_DETAILS,
          talukaApiRequest.toJson());
      TeleCallerListResponse cityApiRespose =
          TeleCallerListResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExternalLeadSaveResponse> externalLeadSaveDetails(
      int pkID, ExternalLeadSaveRequest talukaApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_EXTERNAL_LEAD_PAGINATION}/$pkID/Save",
          talukaApiRequest.toJson());
      ExternalLeadSaveResponse cityApiRespose =
          ExternalLeadSaveResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExternalLeadSaveResponse> teleCallerSaveDetails(
      int pkID, TeleCallerSaveRequest talukaApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_TELE_CALLER_PAGINATION}/$pkID/Save",
          talukaApiRequest.toJson());
      ExternalLeadSaveResponse cityApiRespose =
          ExternalLeadSaveResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExternalLeadSaveResponse> new_teleCallerSaveDetails(
      int pkID, NewTeleCallerSaveRequest talukaApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_NEW_TELE_CALLER_SAVE}/$pkID/Save",
          talukaApiRequest.toJson());
      ExternalLeadSaveResponse cityApiRespose =
          ExternalLeadSaveResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PackingChecklistListResponse> PackingChecklistCall(
      int pageNo, PackingChecklistListRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_Packing_checklist_list}/$pageNo-10",
          request.toJson());
      PackingChecklistListResponse response =
          PackingChecklistListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FinalCheckingListResponse> FinalCheckingListCall(
      int pageNo, FinalCheckingListRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_Final_Checking_List}/$pageNo-10",
          request.toJson());
      FinalCheckingListResponse response =
          FinalCheckingListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SearchFinalCheckingLabelResponse> searchfinalcheckinglabel(
      SearchFinalCheckingRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FinalChecking_Search, request.toJson());
      SearchFinalCheckingLabelResponse response =
          SearchFinalCheckingLabelResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FinalCheckingListResponse> searchfinalchecking(
      SearchFinalCheckingRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FinalChecking_Search, request.toJson());
      FinalCheckingListResponse response =
          FinalCheckingListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PackingChecklistListResponse> searchpackingchecklist(
      SearchPackingChecklistRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PackingChecklist_Search, request.toJson());
      PackingChecklistListResponse response =
          PackingChecklistListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SearchPackingchecklistLabelResponse> searchpackingchecklistlabel(
      SearchPackingChecklistRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PackingChecklist_Search, request.toJson());
      SearchPackingchecklistLabelResponse response =
          SearchPackingchecklistLabelResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InstallationListResponse> InstallationListCall(
      int pageNo, InstallationListRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_Installation_List}/$pageNo-10",
          request.toJson());
      InstallationListResponse response =
          InstallationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InstallationListResponse> searchinstallation(
      SearchInstallationRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Installation_Search, request.toJson());
      InstallationListResponse response =
          InstallationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SearchInstallationLabelResponse> searchinstallationlabel(
      SearchInstallationRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Installation_Search, request.toJson());
      SearchInstallationLabelResponse response =
          SearchInstallationLabelResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InstallationDeleteRespose> deleteinstallation(
      int id, InstallationDeleteRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete",
          request.toJson(),
          showSuccessDialog: true);

      InstallationDeleteRespose response =
          InstallationDeleteRespose.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InstallationSearchCustomerResponse> installationcustomersearch(
      InstallationCustomerSearchRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_SEARCH, request.toJson());
      InstallationSearchCustomerResponse response =
          InstallationSearchCustomerResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InstallationCountryResponse> installationcontry(
      InstallationCountryRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Installation_country, request.toJson());
      InstallationCountryResponse response =
          InstallationCountryResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<StateResponse> installationstate(StateListRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_STATELIST, request.toJson());
      StateResponse response = StateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InstallationCityResponse> installationcity(
      CitySearchInstallationApiRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CITY_LIST, request.toJson());
      InstallationCityResponse response =
          InstallationCityResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerIdToOutwardnoResponse> idtooutwardno(
      InstallationCustomerIdToOutwardnoRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Id_To_Outward, request.toJson());
      CustomerIdToOutwardnoResponse response =
          CustomerIdToOutwardnoResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InstallationEmployeeResponse> installationemployee(
      InstallationEmployeeRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Installation_employee, request.toJson());
      InstallationEmployeeResponse response =
          InstallationEmployeeResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SaveInstallationResponse> saveinstallation(
      int id, SaveInstallationRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_Save_Installation_List}/$id/Save",
          request.toJson());
      SaveInstallationResponse response =
          SaveInstallationResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TypeOfWorkResponse> ProductionTypeofwork(
      TypeOfWorkRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Production_Typeofwork, request.toJson());
      TypeOfWorkResponse response = TypeOfWorkResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TypeOfWorkResponse> ProductionTypeofwork123() async {
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    print("djkjfsd" + _offlineCompanyData.details[0].pkId.toString());
    TypeOfWorkRequest request = TypeOfWorkRequest(
        pkID: "", CompanyId: _offlineCompanyData.details[0].pkId.toString());
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Production_Typeofwork, request.toJson());
      TypeOfWorkResponse response = TypeOfWorkResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductionActivityResponse> ProductionActivityListCall(
      ProductionActivityRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Production_Activity_List, request.toJson());
      ProductionActivityResponse response =
          ProductionActivityResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductMasterResponse> productmasterListAPi(
      int pageNo, ProductMasterListRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PRODUCT_MASTER_LIST_API +
              pageNo.toString() +
              "-10",
          request.toJson());
      ProductMasterResponse response = ProductMasterResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PackingListResponse> packinglist(
      ProductionPackingListRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_Production_packinglist, request.toJson());
      PackingListResponse response = PackingListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductionActivitySaveResponse> productionactivitysave(
      int id, SaveProductionActivityRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_Production_Save}/$id/Save", request.toJson());
      ProductionActivitySaveResponse response =
          ProductionActivitySaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductionActivityDeleteResponse> productionactivitydelete(
      int id, ProductionActivityDeleteRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_Production_Save}/$id/Delete",
          request.toJson());
      ProductionActivityDeleteResponse response =
          ProductionActivityDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TelecallerNewpaginationResponse> telecallernewlist(
      int pageNo, TeleCallerNewListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_TELE_CALLER_New_pagination}/$pageNo-10",
          request
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);

      TelecallerNewpaginationResponse response =
          TelecallerNewpaginationResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BankNameDropDownResponse> getBankDetailsAPI(
      BankNameDropDownRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_ORDER_BANK_DETIALS, request.toJson());
      BankNameDropDownResponse response =
          BankNameDropDownResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SaleBillEmailContentResponse> getEmailContentAPI(
      SalesBillEmailContentRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_BILL_EMAIL_CONTENT, request.toJson());
      SaleBillEmailContentResponse response =
          SaleBillEmailContentResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationEmailContentResponse> getQuotationEmailContentAPI(
      QuotationEmailContentRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_BILL_EMAIL_CONTENT, request.toJson());
      QuotationEmailContentResponse response =
          QuotationEmailContentResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesBill_INQ_QT_SO_NO_ListResponse> getINQ_QT_SO_NO_API(
      SaleBill_INQ_QT_SO_NO_ListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_BILL_INQ_QT_SO_NO_LIST_API,
          request.toJson());
      SalesBill_INQ_QT_SO_NO_ListResponse response =
          SalesBill_INQ_QT_SO_NO_ListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiNoToProductDetailsResponse> getProductDetailsFrom_No(
      MultiNoToProductDetailsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQ_QT_SO_NO_PRODUCT_LIST_API, request.toJson());
      MultiNoToProductDetailsResponse response =
          MultiNoToProductDetailsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiNoToProductDetailsResponse1> getProductDetailsFrom_No12(
      MultiNoToProductDetailsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQ_QT_SO_NO_PRODUCT_LIST_API, request.toJson());
      MultiNoToProductDetailsResponse1 response =
          MultiNoToProductDetailsResponse1.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiNoToProductDetailsResponse> getProductDetailsFrom_No1(
      MultiNoToProductDetailsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQ_QT_SO_NO_PRODUCT_LIST_API, request.toJson());
      MultiNoToProductDetailsResponse response =
          MultiNoToProductDetailsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  /****************************************Manage Accounts*****************************************/
  Future<MaterialInwardListResponse> materialInwardListAPI(
      int pageNo, MaterialInwardListRequest materialInwardListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_INWARD_LIST +
              "/" +
              pageNo.toString() +
              "-10",
          materialInwardListRequest.toJson());
      MaterialInwardListResponse response =
          MaterialInwardListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardListResponse> materialOutwardListAPI(
      int pageNo, MaterialOutwardListRequest materialOutwardListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_OUTWARD_LIST +
              "/" +
              pageNo.toString() +
              "-10",
          materialOutwardListRequest.toJson());
      MaterialOutwardListResponse response =
          MaterialOutwardListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  /* Future<String> getAPIUpdateTokenAPI(
      APITokenUpdateRequest apiTokenUpdateRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.API_TOKEN_UPDATE, apiTokenUpdateRequest.toJson());

      print("d456" + json.toString());
      return json.toString();
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }*/

  Future<FirebaseTokenResponse> getAPIUpdateTokenAPI(
      APITokenUpdateRequest apiTokenUpdateRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.API_TOKEN_UPDATE, apiTokenUpdateRequest.toJson());
      FirebaseTokenResponse response = FirebaseTokenResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<GetReportToTokenResponse> getreporttoTokenAPI(
      GetReportToTokenRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.API_GET_REPORT_TO_TOKEN_API, request.toJson());
      GetReportToTokenResponse response =
          GetReportToTokenResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerUploadDocumentResponse> getCustomerploadDocumentAPI(
      File imagesfiles, CustomerUploadDocumentApiRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostMultipart(
          ApiClient.API_UPLOAD_CUSTOMER_DOCUMENT, request.toJson(),
          imageFilesToUpload: [imagesfiles]);

      print("response - ${json}");

      CustomerUploadDocumentResponse response =
          CustomerUploadDocumentResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerFetchDocumentResponse> fetch_customer_document_API(
      CustomerFetchDocumentApiRequest customerFetchDocumentApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.API_FETCH_CUSTOMER_DOCUMENT,
          customerFetchDocumentApiRequest.toJson());
      CustomerFetchDocumentResponse designationApiResponse =
          CustomerFetchDocumentResponse.fromJson(json);
      return designationApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerDeleteDocumentResponse> delete_customer_document_API(
      String pkID,
      CustomerDeleteDocumentApiRequest customerFetchDocumentApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.API_DELETE_CUSTOMER_DOCUMENT + pkID + "/DeleteDocument",
          customerFetchDocumentApiRequest.toJson());
      CustomerDeleteDocumentResponse designationApiResponse =
          CustomerDeleteDocumentResponse.fromJson(json);
      return designationApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AccuraBathComplaintFollowupHistoryListResponse>
      getComplaintFollowupHistoryListAPI(
          AccuraBathComplaintFollowupHistoryListRequest
              complaintFollowupHistoryListResponse) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ACCURABATH_COMPLAINT_FOLLOWUP_HISTORY_LIST +
              complaintFollowupHistoryListResponse.pkID.toString() +
              "/FollowUplist",
          complaintFollowupHistoryListResponse.toJson());
      AccuraBathComplaintFollowupHistoryListResponse response =
          AccuraBathComplaintFollowupHistoryListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AccuraBathComplaintFollowupSaveResponse> getComplaintFollowupSaveAPI(
      int pkID,
      AccuraBathComplaintFollowupSaveRequest
          complaintFollowupSaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ACCURABATH_COMPLAINT_SAVE_FOLLOWUP,
          complaintFollowupSaveRequest.toJson());
      AccuraBathComplaintFollowupSaveResponse response =
          AccuraBathComplaintFollowupSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AccuraBathComplaintEmployeeListResponse>
      getComplaintEmployeeFollowerAPI(
          AccuraBathComplaintEmpFollowerListRequest
              complaintEmpFollowerListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ACCURABATH_COMPLAINT_EMPLOYEE_LIST,
          complaintEmpFollowerListRequest.toJson());
      AccuraBathComplaintEmployeeListResponse response =
          AccuraBathComplaintEmployeeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AccuraBathComplaintSaveResponse> getAccuraBathComplaintSave(
      int pkID, AccuraBathComplaintSaveRequest complaintSaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_ACURABATH_OMPLAINT_SAVE__DETAILS}/$pkID/Save",
          complaintSaveRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + complaintSaveRequest.toJson().toString());
      AccuraBathComplaintSaveResponse response =
          AccuraBathComplaintSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AccuraBathComplaintNoToDeleteImageResponse>
      getComplaintNoToDeleteImageAPI(
          String complaintNo,
          AccurabathComplaintImageDeleteRequest
              accurabathComplaintImageDeleteRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ACCURABATH_COMPLAINT_NO_DELETE_IMG +
              complaintNo +
              "/DeleteModuleDocs",
          accurabathComplaintImageDeleteRequest.toJson());
      AccuraBathComplaintNoToDeleteImageResponse response =
          AccuraBathComplaintNoToDeleteImageResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AccuraBathComplaintDeleteVideoResponse> getComplaintNoToDeleteVideoAPI(
      String complaintNo,
      AccurabathComplaintVideoDeleteRequest
          accurabathComplaintVideoDeleteRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ACCURABATH_COMPLAINT_NO_DELETE_VIDEO +
              complaintNo +
              "/DeleteVideoAttachments",
          accurabathComplaintVideoDeleteRequest.toJson());
      AccuraBathComplaintDeleteVideoResponse response =
          AccuraBathComplaintDeleteVideoResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AccuraBathComplaintImageUploadResponse>
      getAccuraBathComplaintuploadImage(File imagesfiles,
          AccuraBathComplaintUploadImageAPIRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostMultipart(
          ApiClient.END_ACCURABATH_POINT_COMPLAINT_UPLOAD, request.toJson(),
          imageFilesToUpload: [imagesfiles]);

      print("response - ${json}");

      AccuraBathComplaintImageUploadResponse response =
          AccuraBathComplaintImageUploadResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AccuraBathComplaintVideoUploadResponse>
      getAccuraBathComplaintuploadVideo(File imagesfiles,
          AccuraBathComplaintUploadVideoAPIRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostMultipart(
          ApiClient.END_ACCURABATH_POINT_COMPLAINT_UPLOAD_VIDEO,
          request.toJson(),
          imageFilesToUpload: [imagesfiles]);

      print("response - ${json}");

      AccuraBathComplaintVideoUploadResponse response =
          AccuraBathComplaintVideoUploadResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<RegionCodeResponse> getregionCodeAPI(RegionCodeRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_GET_REGION_CODE, request.toJson());
      RegionCodeResponse response = RegionCodeResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SaleOrderHeaderSaveResponse> getSalesOrderHeaderSaveAPI(
      int pkID, SaleOrderHeaderSaveRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_ORDER_HEADER_SAVE_REQUEST +
              "$pkID" +
              "/save",
          request.toJson());
      SaleOrderHeaderSaveResponse response =
          SaleOrderHeaderSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QucikComplaintListResponse> getQuickComplaintListAPI(
      QuickComplaintListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUICK_COMPLAINT_LIST_REQUEST, request.toJson());
      QucikComplaintListResponse response =
          QucikComplaintListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QucikComplaintSaveResponse> getQuickComplaintSaveAPI(
      int pkID, QuickComplaintSaveRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_QUICK_COMPLAINT_SAVE_REQUEST +
              "$pkID" +
              "/Save",
          request.toJson());
      QucikComplaintSaveResponse response =
          QucikComplaintSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PunchAttendenceSaveResponse> getPunchIN_API(
      File file, PunchAttendanceSaveRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      /*Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_PUNCH_ATTENDENCE_REQUEST}",
          employeeListRequest
              .toJson() );
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      PunchAttendenceSaveResponse response =
          PunchAttendenceSaveResponse.fromJson(json);*/

      Map<String, dynamic> json = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_PUNCH_ATTENDENCE_REQUEST,
          employeeListRequest.toJson(),
          imageFilesToUpload: [file],
          showSuccessDialog: true);

      print("response - ${json}");

      PunchAttendenceSaveResponse response =
          PunchAttendenceSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  /* Future<CustomerUploadDocumentResponse> getCustomerploadDocumentAPI(
      File imagesfiles, CustomerUploadDocumentApiRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostMultipart(
          ApiClient.API_UPLOAD_CUSTOMER_DOCUMENT, request.toJson(),
          imageFilesToUpload: [imagesfiles]);

      print("response - ${json}");

      CustomerUploadDocumentResponse response =
          CustomerUploadDocumentResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }*/

  Future<SaleOrderProductSaveResponse> salesOrderProductSaveDetails(
      List<SalesOrderProductRequest> arrSalesOrderProductList) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              "${ApiClient.END_POINT_SALES_ORDER_PRODUCT_SAVE}",
              arrSalesOrderProductList);
      SaleOrderProductSaveResponse inquiryProductSaveResponse =
          SaleOrderProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SaleOrderProductDeleteResponse> saleorder_productDelete(
      int pkID, SalesOrderAllProductDeleteRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SALES_ORDER_PRODUCT_DELETE + pkID.toString() + "/Detaildelete"}",
          employeeListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " + employeeListRequest.toJson().toString());
      SaleOrderProductDeleteResponse response =
          SaleOrderProductDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SaveEmailContentResponse> getSaveEmailContentAPI(
      SaveEmailContentRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SAVE_EMAIL_CONTENT, request.toJson());
      SaveEmailContentResponse response =
          SaveEmailContentResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TeleCallerFollowupSaveResponse> teleCallerFollowupSaveDetails(
      TeleCallerFollowupSaveRequest teleCallerFollowupSaveRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_TELE_CALLER_FOLLOWUP_SAVE}",
          teleCallerFollowupSaveRequest.toJson());
      TeleCallerFollowupSaveResponse cityApiRespose =
          TeleCallerFollowupSaveResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TeleCallerFollowupSaveResponse>
      teleCallerFollowupFromFollowupSaveDetails(int followuppkID,
          TeleCallerFollowupSaveRequest teleCallerFollowupSaveRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_TELE_CALLER_FOLLOWUP_FROM_FOLLOWUP_SAVE + followuppkID.toString() + "/Save"}",
          teleCallerFollowupSaveRequest.toJson());
      TeleCallerFollowupSaveResponse cityApiRespose =
          TeleCallerFollowupSaveResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupImageListResponse> followupImageListAPI(
      int followuppkID, FollowupImageListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_FOLLOWUP_IMG_LIST + followuppkID.toString() + "/ImageList"}",
          request.toJson());
      FollowupImageListResponse cityApiRespose =
          FollowupImageListResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<TeleCallerFollowupHestoryResponse> getTeleCallerFollowupHistoryList(
      TeleCallerFollowupHistoryRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TELE_CALLER_FOLLOWUP_HISTORY, request.toJson());
      TeleCallerFollowupHestoryResponse response =
          TeleCallerFollowupHestoryResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PunchWithoutAttendenceSaveResponse> getwithoutImageAttendanceSaveAPI(
      PunchWithoutImageAttendanceSaveRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_WITHOUT_IMAGE_SAVE_ATTENDANCE, request.toJson());
      PunchWithoutAttendenceSaveResponse response =
          PunchWithoutAttendenceSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ConstantResponse> getConstantAPI(
      String CompanyID, ConstantRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CONSTANT_MASTER + CompanyID, request.toJson());
      ConstantResponse response = ConstantResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<UserMenuRightsResponse> user_menurightsapi(
      String pkID, UserMenuRightsRequest userMenuRightsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_USER_MENU_RIGHTS + pkID + "/List",
          userMenuRightsRequest.toJson());
      UserMenuRightsResponse designationApiResponse =
          UserMenuRightsResponse.fromJson(json);
      return designationApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BulkAssignListResponse> getBulkAssignListAPI(
      BulkAssignListRequest userMenuRightsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_BULK_ASSIGN, userMenuRightsRequest.toJson());
      BulkAssignListResponse designationApiResponse =
          BulkAssignListResponse.fromJson(json);
      return designationApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductBrandResponse> productBrandListAPI(
      ProductBrandListRequest productBrandListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PRODUCT_BRAND_LIST,
          productBrandListRequest.toJson());
      ProductBrandResponse designationApiResponse =
          ProductBrandResponse.fromJson(json);
      return designationApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AssignToNotificationResponse> assignToNotificationAPI(
      AssignToNotificationRequest userMenuRightsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ASSIGN_TO_NOTIFICATION,
          userMenuRightsRequest.toJson());
      AssignToNotificationResponse designationApiResponse =
          AssignToNotificationResponse.fromJson(json);
      return designationApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SBHeaderSaveResponse> getSaleBillHeaderSaveCallAPI(
      int pkID, SBHeaderSaveRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SB_HEADER_SAVE + pkID.toString() + "/Save",
          request.toJson());
      SBHeaderSaveResponse response = SBHeaderSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SBProductSaveResponse> salesBillProductSaveDetails(
      String InvoiceNo, List<SBProductSaveRequest> arrSBProductList) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostforMultipleJSONArray(
          "${ApiClient.END_POINT_SALES_BILL_PRODUCT_SAVE + InvoiceNo + "/ProductSaveByProdId"}",
          arrSBProductList);

      SBProductSaveResponse inquiryProductSaveResponse =
          SBProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesOrderDeleteResponse> deleteSalesOrder(
      String id, SalesOrderDeleteRequest quotationDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_DELETE_SALES_ORDER}/${id}/delete",
          quotationDeleteRequest.toJson(),
          showSuccessDialog: false);
      SalesOrderDeleteResponse response =
          SalesOrderDeleteResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SOCurrencyListResponse> SOCurrencyListAPI(
      SOCurrencyListRequest quotationDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SO_CURRENCY_LIST}",
          quotationDeleteRequest.toJson(),
          showSuccessDialog: false);
      SOCurrencyListResponse response = SOCurrencyListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<HeaderToDetailsResponse> SalesBillHeaderIdToDetailsAPI(
      int headerpkID, HeaderToDetailsRequest quotationDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_SB_HEADERIDTOLIST + headerpkID.toString() + "/HeaderDetails"}",
          quotationDeleteRequest.toJson(),
          showSuccessDialog: false);
      HeaderToDetailsResponse response = HeaderToDetailsResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SBExportListResponse> getSBExportListAPI(
      SBExportListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SB_EXPORT_LIST, request.toJson());
      SBExportListResponse response = SBExportListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SBExportSaveResponse> sb_ExportSaveAPI(
      String returnInvoiceNo, SBExportSaveRequest request) async {
    try {
      request.InvoiceNo = returnInvoiceNo;
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SB_EXPORT_SAVE, request.toJson());
      SBExportSaveResponse response = SBExportSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SBDeleteResponse> getSBHeaderDeleteAPI(
      String pkID, SBDeleteRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SB_HEADER_DELETE + pkID.toString() + "/delete",
          request.toJson());
      SBDeleteResponse response = SBDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<BTCountryListResponse> bt_country_list_api(
      BTCountryListRequest userMenuRightsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_BT_CUSTOMER_COUNTRY,
          userMenuRightsRequest.toJson());
      BTCountryListResponse designationApiResponse =
          BTCountryListResponse.fromJson(json);
      return designationApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CityCodeToCustomerListResponse> cityCodetoCustomerListAPI(
      String CityCode,
      CityCodeToCustomerListRequest userMenuRightsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CITY_CODE_TO_CUSTOMER_LIST +
              CityCode +
              "/CustomerDetails",
          userMenuRightsRequest.toJson());
      CityCodeToCustomerListResponse designationApiResponse =
          CityCodeToCustomerListResponse.fromJson(json);
      return designationApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerHistoryListResponse> CustomerHistoryListAPI(
      CustomerHistoryListRequest userMenuRightsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_HISTORY_LIST,
          userMenuRightsRequest.toJson());
      CustomerHistoryListResponse designationApiResponse =
          CustomerHistoryListResponse.fromJson(json);
      return designationApiResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SizeListResponse> getSizeListFromProductID(
      SizeListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SIZED_LIST_FROM_PRODUCTID, request.toJson());
      SizeListResponse response = SizeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InquiryNoToFetchProductSizedListResponse>
      getproductSizedListfromInquiryNo(
          InquiryNoToFetchProductSizedListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQ_NO_TO_PRODUCT_SIZED_LIST, request.toJson());
      InquiryNoToFetchProductSizedListResponse response =
          InquiryNoToFetchProductSizedListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  //SizedListInsUpdateApiResponse

  Future<SizedListInsUpdateApiResponse> insert_update_sizedListAPI(
      SizedListInsUpdateApiRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SIZEDLIST_INS_UPDATE_API +
              request.ProductID +
              "/ProductSize-Save",
          request.toJson());
      SizedListInsUpdateApiResponse response =
          SizedListInsUpdateApiResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> multi_delete_sizedListAPI(
      SizedMultiDeleteApiRequest request, String inqNo) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SIZEDLIST_MULTI_DELETE_API +
              inqNo +
              "/MultiProductSizeDelete",
          request.toJson());
      String response = json.toString();

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<OfficeToDoListResponse> getOfficeTodoList(
      OfficeToListRequest toDoListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_OFFICE_TODO_LIST, toDoListApiRequest.toJson());
      OfficeToDoListResponse response = OfficeToDoListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<VkComplaintListResponse> vkComplaintListAPI(
      int PageNo, VkComplaintListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_VK_COMPLAIN_LIST + PageNo.toString() + "-10",
          request.toJson());
      VkComplaintListResponse response = VkComplaintListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<VkComplaintSaveResponse> vkComplaintSaveAPI(
      int pkID, VkComplaintSaveRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_VK_COMPLAIN_SAVE + pkID.toString() + "/Save",
          request.toJson());
      VkComplaintSaveResponse response = VkComplaintSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<VkComplainPkIDtoDetailsResponse> vkComplaintpkIDtoDetailsAPI(
      int pkID, VkComplaintpkIDtoDetailsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_VK_COMPLAIN_PK_ID_TO_DETAILS + pkID.toString(),
          request.toJson());
      VkComplainPkIDtoDetailsResponse response =
          VkComplainPkIDtoDetailsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<VkComplaintDeleteResponse> vkComplaintDeleteAPI(
      int pkID, VkComplaintDeleteRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_VK_COMPLAIN_DELETE + pkID.toString() + "/Delete",
          request.toJson());
      VkComplaintDeleteResponse response =
          VkComplaintDeleteResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<VkComplaintHistoryResponse> vkComplaintHistroyAPI(
      String pkID, VkComplaintHistoryRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_VK_COMPLAIN_HISTORY +
              pkID.toString() +
              "/History",
          request.toJson());
      VkComplaintHistoryResponse response =
          VkComplaintHistoryResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> followupCount(
      String status, FollowupCountRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_FOLLOWUP_IMG_LIST + status.toString() + "/Count"}",
          request.toJson());
      print("CountLogic" + "Count JSON " + json['TotalCount'].toString());
      String cityApiRespose = json['TotalCount'].toString();
      //FollowUpCountState.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getFollowupCountForAlmightyApi(
      String status, FollowupCountForAlmightyRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_FOLLOWUP_IMG_LIST_FOR_ALMIGHTY + status.toString() + "/Count"}",
          request.toJson());
      String response = json['TotalCount'].toString();
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> sales_bill_deleteAllProductAPI(
      String returnInvoiceNo, SbAllProductDeleteRequest request) async {
    try {
      request.InvoiceNo = returnInvoiceNo;
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SB_ALL_PRODUCT_DELETE +
              request.InvoiceNo +
              "/Detaildelete",
          request.tojson());

      String response = json['Message'];

      //String response = "Product Deleted SucessFully";

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FollowupPkIdDetailsResponse> followuppkIDtoDetailsAPI(
      FollowupPkIdDetailsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FOLLOWUP_PKID_TO_DETAILS, request.toJson());
      FollowupPkIdDetailsResponse response =
          FollowupPkIdDetailsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<FixedLedgerListResponse> getFixedLedgerList(
      FixedLedgerListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_FIXED_LEDGER_LIST, request.toJson());
      FixedLedgerListResponse response = FixedLedgerListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesOrderApprovalListResponse> getSalesOrderApprovalListAPI(
      SalesOrderApprovalListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_ORDER_APPROVAL_LIST, request.toJson());
      SalesOrderApprovalListResponse response =
          SalesOrderApprovalListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesOrderListResponse> getSalesOrderApprovalListForDashBoardAPI(
      SalesOrderApprovalListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_ORDER_APPROVAL_LIST, request.toJson());
      SalesOrderListResponse response = SalesOrderListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> salesOrderApprovalSaveAPI(
      SalesOrderApprovalSaveRequest salesOrderApprovalSaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      //String ORderNo = soShipmentSaveRequest.OrderNo;
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_ORDER_APPROVAL_SAVE,
          salesOrderApprovalSaveRequest.toJson());
      String response = json['details'];

      print("sdfksdf445fgg" +
          json.toString() +
          " MSG : " +
          json['details'].toString());

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesOrderApprovalStatusListResponse>
      getSalesOrderApprovalStatusListAPI(
          SalesOrderApprovalStatusListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_ORDER_APPROVAL_STATUS, request.toJson());
      SalesOrderApprovalStatusListResponse response =
          SalesOrderApprovalStatusListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesOrderApprovalStatusListResponse>
      getPurchaseOrderApprovalStatusListAPI(
          SalesOrderApprovalStatusListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PURCHASE_ORDER_APPROVAL_STATUS, request.toJson());
      SalesOrderApprovalStatusListResponse response =
          SalesOrderApprovalStatusListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesOrderListResponse> getSalesOrderApprovalStatusListForDashBoardAPI(
      SalesOrderApprovalStatusListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_ORDER_APPROVAL_STATUS, request.toJson());
      SalesOrderListResponse response = SalesOrderListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DashBoardCountResponse> getDashBoardCountAPI(
      DashBoardCountRequest dashBoardCountRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_DASHBOARD_COUNT, dashBoardCountRequest.toJson());
      DashBoardCountResponse response = DashBoardCountResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<RevisedQuotationResponse> getRevisedQuotationAPI(
      RevisedQuotationRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QT_REVISED_SAVE, request.toJson());
      RevisedQuotationResponse response =
          RevisedQuotationResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuotationListResponse> getQuotationPKIDToDetails(
      QuotationPkIdToDetailsRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QT_PK_ID_TO_DETAILS + request.pkID.toString(),
          request.toJson());
      QuotationListResponse response = QuotationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesOrderAddressDropDownResponse> getSOShipmentAddressDropdown(
      SalesOrderAddressDropDownRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SALES_ORDER_ADDRESS_DROPDOWN, request.toJson());
      SalesOrderAddressDropDownResponse response =
          SalesOrderAddressDropDownResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  /// Support Module For the mudra client

  Future<MudraComplaintListResponse> MaudraComplaintList(
      int pageNo, MudraComplaintListRequest mudraComplaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MUDRA_COMPLAINT_LIST,
          mudraComplaintListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print(
          "ToJSONRESPONSFG : " + mudraComplaintListRequest.toJson().toString());
      MudraComplaintListResponse response =
          MudraComplaintListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> MaudraComplaintDeleteAPI(
      MudraComplaintDeleteDeleteRequest
          mudraComplaintDeleteDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_MAYANK_MUDRA_COMPLAINT_DELETE,
          mudraComplaintDeleteDeleteRequest.toJson());
      // String response = json["Message"];
      String response = json['Message'];

      print("fdfdfsfd" + json.toString());

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MudraAssignToResponse> MudraAssignToListAPI(
      MudraAssignToRequest mudraAssignToRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_MAYANK_MUDRA_ASSIGN_TO_LIST,
          mudraAssignToRequest.toJson());
      MudraAssignToResponse response = MudraAssignToResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MudraProjectListResponse> MudraPrjectListAPI(
      MudraProjectListRequest mudraProjectListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_MAYANK_MUDRA_PROJECT_LIST,
          mudraProjectListRequest.toJson());
      MudraProjectListResponse response =
          MudraProjectListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MudraServiceListResponse> MudraServiceListAPI(
      MudraServiceListRequest mudraProjectListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_MAYANK_MUDRA_SERVICE_TAG_LIST,
          mudraProjectListRequest.toJson());
      MudraServiceListResponse response =
          MudraServiceListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MudraComplaintSaveResponse> MudraComlaintAddEditAPI(
      MudraComplaintSaveRequest mudraComplaintSaveRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_MAYANK_MUDRA_COMPLAINT_SAVE,
          mudraComplaintSaveRequest.toJson());
      // String response = json["Message"];
      //VehicleCameraSaveResponse

      MudraComplaintSaveResponse response =
          MudraComplaintSaveResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MudraHistoryListResponse> MudraComplaintHistoryMethod(
      MudraHistoryListRequest toDoWorkLogListRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_MAYANK_MUDRA_COMPLAINT_HISTORY_SAVE,
          toDoWorkLogListRequest.toJson());
      MudraHistoryListResponse response =
          MudraHistoryListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MudraAttendVisitListResponse> MaudraAttendVisitList(int pageNo,
      MudraAttendVisitListRequest mudraAttendVisitListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MUDRA_ATTEND_VISIT_LIST,
          mudraAttendVisitListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print("ToJSONRESPONSFG : " +
          mudraAttendVisitListRequest.toJson().toString());
      MudraAttendVisitListResponse response =
          MudraAttendVisitListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> MaudraAttendVisitDeleteAPI(
      MudraAttendVisitDeleteDeleteRequest
          mudraAttendVisitDeleteDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_MAYANK_MUDRA_ATTEND_VISIT_DELETE,
          mudraAttendVisitDeleteDeleteRequest.toJson());
      // String response = json["Message"];
      String response = json['Message'];

      print("fdfdfsfd" + json.toString());

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  //AttendVisit
  Future<MudraAttendVisitSaveResponse> MudraAttendVisitAddEditAPI(
      MudraAttendVisitSaveRequest mudraComplaintSaveRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_MAYANK_MUDRA_ATTEND_VISIT_SAVE,
          mudraComplaintSaveRequest.toJson());
      // String response = json["Message"];
      //VehicleCameraSaveResponse

      MudraAttendVisitSaveResponse response =
          MudraAttendVisitSaveResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  /// Bank Voucher

  Future<MayankBankVoucherListResponse> MayankBankVoucherList(int pageNo,
      MayankBankVoucherListRequest mayankBankVoucherListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MAYANK_BANK_VOUCHER_LIST,
          mayankBankVoucherListRequest.toJson());

      MayankBankVoucherListResponse response =
          MayankBankVoucherListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> MayankBankVoucherDeleteAPI(
      MayankBankVoucherDeleteRequest mayankBankVoucherDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_MAYANK_BANK_VOUCHER_DELETE,
          mayankBankVoucherDeleteRequest.toJson());
      // String response = json["Message"];
      String response = json['Message'];

      print("fdfdfsfd" + json.toString());

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MayankBankVoucherInqNoResponse> getBankVoucherModeList(
      MayankBankVoucherInqNoRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_BANK_NAME_MODE, request.toJson());
      MayankBankVoucherInqNoResponse response =
          MayankBankVoucherInqNoResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MayankBankVoucherAmountResponse> getBankVoucherAmountList(
      MayankBankVoucherAmountRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_BANK_NAME_AMOUNT, request.toJson());
      MayankBankVoucherAmountResponse response =
          MayankBankVoucherAmountResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MayankBankVoucherAddEditResponse> getbankvoucherSaveedit(
      MayankBankVoucherAddEditRequest bankVoucherDeleteRequest) async {
    try {
      /* await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_DELETE}/${id}/Delete", customerDeleteRequest.toJson());*/
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_BANK_VOUCHER_ADD_EDIT_DETAILS,
          bankVoucherDeleteRequest.toJson());
      MayankBankVoucherAddEditResponse response =
          MayankBankVoucherAddEditResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MayankBankVoucherDetailsListResponse> MayankBankVoucherDetailsList(
      int pageNo,
      MayankBankVoucherDetailsListRequest
          mayankBankVoucherDetailsListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MAYANK_BANK_VOUCHER__DETAILS_LIST,
          mayankBankVoucherDetailsListRequest.toJson());
      MayankBankVoucherDetailsListResponse response =
          MayankBankVoucherDetailsListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> MayankBankVoucherDeleteDetailsAPI(
      MayankBankVoucherDeleteDetailsRequest
          mayankBankVoucherDeleteDetailsRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_MAYANK_BANK_VOUCHER_DELETE_DETAILS,
          mayankBankVoucherDeleteDetailsRequest.toJson());
      // String response = json["Message"];
      String response = json['Message'];

      print("fdfdfsfd" + json.toString());

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MayankBankVoucherDetailsAddEditResponse>
      MayankBankVoucherAddEditDetailsAPI(
          MayankBankVoucherDetailsAddEditRequest
              vehicleMasterCheckListBodyAddEditRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_MAYANK_BANK_VOUCHER_ADD_EDIT_DETAILS,
          vehicleMasterCheckListBodyAddEditRequest.toJson());
      MayankBankVoucherDetailsAddEditResponse response =
          MayankBankVoucherDetailsAddEditResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MayankBankVoucherDetailsAddEditResponse>
      MayankBankVoucherAddEditDetailsAPI1(
          List<BankVoucherDetailsTable> _contactsList) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_MAYANK_BANK_VOUCHER_ADD_EDIT_DETAILS1,
              _contactsList);
      MayankBankVoucherDetailsAddEditResponse response =
          MayankBankVoucherDetailsAddEditResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PurchaseBillListResponse> PurchaseBillAPI(
      int pageNo, PurchaseBillListRequest purchaseBillListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PURCHASE_BILL_LIST,
          purchaseBillListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      PurchaseBillListResponse response =
          PurchaseBillListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getPurchaseBillDeleteApi(
      PurchaseBillDeleteDeleteRequest purchaseBillDeleteDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_PURCHASE_BILL_DELETE,
          purchaseBillDeleteDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PurchaseOrderListResponse> PurchaseOrderAPI(
      int pageNo, PurchaseOrderListRequest purchaseOrderListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PURCHASE_ORDER_LIST,
          purchaseOrderListRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      PurchaseOrderListResponse response =
          PurchaseOrderListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MyGetPunchingResponse> getMyGetPunchingAPI(
      int pkID, MyGetPunchingRequest myGetPunchingRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostMultipartBase64(
          ApiClient.END_POINT_DASHBOARD_DAILY_ATTENDANCE_MODEL +
              pkID.toString() +
              "/Save",
          myGetPunchingRequest.toJson());
      MyGetPunchingResponse response = MyGetPunchingResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SharvayaDailyActivityListResponse> SharvayaDailyActivity(int pageNo,
      SharvayaDailyActivityListRequest mayankBankVoucherListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SHARVAYA_DAILY_ACTIVITY_LIST,
          mayankBankVoucherListRequest.toJson());
      SharvayaDailyActivityListResponse response =
          SharvayaDailyActivityListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> SharvayaDailyActivityDeleteAPI(
      SharvayaDailyActivityDeleteRequest
          sharvayaDailyActivityDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_SHARVAYA_DAILY_ACTIVITY_DELETE,
          sharvayaDailyActivityDeleteRequest.toJson());
      // String response = json["Message"];
      String response = json['Message'];
      print("fdfdfsfd" + json.toString());
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SharvayaDailyActivitySaveResponse> SharvayaDailyActivitySaveAPI(
      SharvayaDailyActivitySaveRequest sharvayaDailyActivitySaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SHARVAYA_DAILY_ACTIVITY_SAVE,
          sharvayaDailyActivitySaveRequest.toJson());
      SharvayaDailyActivitySaveResponse response =
          SharvayaDailyActivitySaveResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MudraQuickSupportListResponse> QuickSupportList(int pageNo,
      MudraQuickSupportListRequest mudraComplaintListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MUDRA_QUICK_SUPPORT_LIST,
          mudraComplaintListRequest.toJson());
      print(
          "ToJSONRESPONSFG : " + mudraComplaintListRequest.toJson().toString());
      MudraQuickSupportListResponse response =
          MudraQuickSupportListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<HplFinishListResponse> getQuotationFinishListDetails(
      HplFinishListRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QT_FINISH_LIST, request.toJson());
      HplFinishListResponse response = HplFinishListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<HplThicknessListResponse> getQuotationThicknessListDetails(
      HplThicknessListRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QT_THICKNESS_LIST, request.toJson());
      HplThicknessListResponse response =
          HplThicknessListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<HplSizeListResponse> getQuotationSizeListDetails(
      HplSizeListRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QT_SIZE_LIST, request.toJson());
      HplSizeListResponse response = HplSizeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<HplGradeListResponse> getQuotationGradeListDetails(
      HplGradeListRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QT_GRADE_LIST, request.toJson());
      HplGradeListResponse response = HplGradeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<HplDesignListResponse> getQuotationDesignListDetails(
      HplDesignListRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QT_DESIGN_LIST, request.toJson());
      HplDesignListResponse response = HplDesignListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SoNoToProductResponse> getSoNotoProductList(
      SoNoToProductListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SoNO_TO_PRODUCT_LIST, request.toJson());
      SoNoToProductResponse response = SoNoToProductResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<WhatsAppApiResponse> WhatsAppApi(var request) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostForHttp("api/v1/sendMessage", request);

      print("ritu" + json.toString());
      WhatsAppApiResponse response = WhatsAppApiResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CampaignListResponse> getCampaignListDetails(
      CampaignListRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CAMPAIGN_LIST_DESIGN_LIST, request.toJson());
      CampaignListResponse response = CampaignListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CommonCompanyDetailsResponse> getCommonCompanyDetails(
      CommonCompanyDetailsRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_COMMON_COMPANY_DETAILS_DESIGN_LIST,
          request.toJson());
      CommonCompanyDetailsResponse response =
          CommonCompanyDetailsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ToDoModuleSharingListResponse> getTodoModuleSharingListAPI(
      ToDoModuleSharingListApiRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TO_DO_MODULE_SHARING_LIST, request.toJson());
      ToDoModuleSharingListResponse response =
          ToDoModuleSharingListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ToDoEmployeeListSharingResponse> GetEmployeeFromHeaderList(
      ToDoEmployeeListSharingRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MODULE_SHARING_FOR_EMPLOYEE_SHARING,
          request.toJson());
      ToDoEmployeeListSharingResponse response =
          ToDoEmployeeListSharingResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ToDoSaveHeaderResponse> todoTagEmployeeSaveJsonArrayAPI(
      List<ModuleSharingSaveRequest> arrSBProductList) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              "${ApiClient.END_POINT_TO_DO_MODULE_SHARING_SAVE}",
              arrSBProductList);

      ToDoSaveHeaderResponse inquiryProductSaveResponse =
          ToDoSaveHeaderResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiNoToProductDetailsFromInquiryResponse>
      getProductDetailsFromInquiry(
          MultiNoToProductDetailsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQ_QT_SO_NO_PRODUCT_LIST_API, request.toJson());
      MultiNoToProductDetailsFromInquiryResponse response =
          MultiNoToProductDetailsFromInquiryResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiNoToProductDetailsFromQuotationResponse>
      getProductDetailsFromQuotation(
          MultiNoToProductDetailsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQ_QT_SO_NO_PRODUCT_LIST_API, request.toJson());
      MultiNoToProductDetailsFromQuotationResponse response =
          MultiNoToProductDetailsFromQuotationResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiNoToProductDetailsFromSalesOrderResponse>
      getProductDetailsFromSalesOrder(
          MultiNoToProductDetailsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQ_QT_SO_NO_PRODUCT_LIST_API, request.toJson());
      MultiNoToProductDetailsFromSalesOrderResponse response =
          MultiNoToProductDetailsFromSalesOrderResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesBillProductDetailsListResponse> getSalesBillProductDetailsList(
      SalesBillProductDetailsListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SBNO_TO_PRODUCT_LIST, request.toJson());
      SalesBillProductDetailsListResponse response =
          SalesBillProductDetailsListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  /// reports

  Future<CustomerDetailsResponse> getCustomerReportsList(
      int pageNo, CustomerReportListRequest customerPaginationRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_PAGINATION}/$pageNo-10",
          customerPaginationRequest
              .toJson() /*jsontemparray: customerPaginationRequest.lstcontact*/);
      print(
          "ToJSONRESPONSFG : " + customerPaginationRequest.toJson().toString());
      CustomerDetailsResponse response = CustomerDetailsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  /// outward
  Future<MaterialOutwardListMainResponse> getMaterialOutwardList(int pageNo,
      MaterialOutwardListMainRequest materialOutwardListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_OUTWARD_DETAILS,
          materialOutwardListRequest.toJson());
      MaterialOutwardListMainResponse response =
          MaterialOutwardListMainResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getMaterialOutwardDelete(
      MaterialOutwardDeleteRequest materialOutwardDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_MATERIAL_OUTWARD_DELETE,
          materialOutwardDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardAddUpdateResponse> getMaterialOutwardAddEdit(
      MaterialOutwardAddUpdateRequest bankVoucherDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_OUTWARD_ADD_UPDATE,
          bankVoucherDeleteRequest.toJson());
      MaterialOutwardAddUpdateResponse response =
          MaterialOutwardAddUpdateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardExportListMainResponse> getMaterialOutwardExportListAPI(
      MaterialOutwardExportListMainRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_OUTWARD_EXPORT_LIST, request.toJson());
      MaterialOutwardExportListMainResponse response =
          MaterialOutwardExportListMainResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardExportAddUpdateResponse>
      getMaterialOutwardExportSaveAPI(String returnOutwardNo,
          MaterialOutwardExportSaveRequest request) async {
    try {
      request.OutwardNo = returnOutwardNo;
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_OUTWARD_EXPORT_SAVE, request.toJson());
      MaterialOutwardExportAddUpdateResponse response =
          MaterialOutwardExportAddUpdateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardPendingSalesOrderListResponse>
      getMaterialOutwardGetSoNoAPI(
          MaterialOutwardPendingSalesOrderListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_OUTWARD_GET_SO_NO, request.toJson());
      MaterialOutwardPendingSalesOrderListResponse response =
          MaterialOutwardPendingSalesOrderListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardPendingSalesOrderDetailsListResponse>
      getMaterialOutwardGetDetailsSoNoAPI(
          MaterialOutwardPendingSalesOrderDetailsListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_OUTWARD_GET_DETAILS_SO_NO,
          request.toJson());
      MaterialOutwardPendingSalesOrderDetailsListResponse response =
          MaterialOutwardPendingSalesOrderDetailsListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getMaterialOutwardDetailsDelete(
      MaterialOutwardDetailsDeleteRequest
          materialOutwardDetailsDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_MATERIAL_OUTWARD_DETAILS_DELETE,
          materialOutwardDetailsDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardDetailsAddUpdateResponseDetails>
      getMaterialOutwardDetailsAddUpdate(
          List<MaterialOutwardTable> request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_MATERIAL_OUTWARD_DETAILS_ADD_UPDATE, request);

      MaterialOutwardDetailsAddUpdateResponseDetails response =
          MaterialOutwardDetailsAddUpdateResponseDetails.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardDetailsListResponse> getMaterialOutwardDetailsList(
      MaterialOutwardDetailsListRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_OUTWARD_DETAILS_LIST, request.toJson());

      MaterialOutwardDetailsListResponse response =
          MaterialOutwardDetailsListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardPendingSalesOrderDetailsByFetchTypeListResponse>
      getMaterialOutwardGetDetailsOutwardNoByFetchTypeAPI(
          MaterialOutwardPendingSalesOrderByFetchTypeDetailsListRequest
              request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_OUTWARD_GET_DETAILS_O_NO_BY_FETCHTYPE,
          request.toJson());
      MaterialOutwardPendingSalesOrderDetailsByFetchTypeListResponse response =
          MaterialOutwardPendingSalesOrderDetailsByFetchTypeListResponse
              .fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardDocumentListResponse> InvoiceDocumentListAPI(
      MaterialOutwardModuleListRequest vehicleModuleListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INVOICE_DOCUMENT_LIST,
          vehicleModuleListRequest.toJson());
      // String response = json["Message"];
      MaterialOutwardDocumentListResponse response =
          MaterialOutwardDocumentListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InvoiceDocumentListResponse> toDoDocumentListAPI(
      InvoiceModuleListRequest vehicleModuleListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INVOICE_DOCUMENT_LIST,
          vehicleModuleListRequest.toJson());
      // String response = json["Message"];
      InvoiceDocumentListResponse response =
          InvoiceDocumentListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardUploadResponse> getinvoicedocumentuploadapi(
      File imagesfiles, MaterialOutwardDocumentUploadRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_INVOICE_DOCUMENT_UPLOAD, request.toJson(),
          imageFilesToUpload: [imagesfiles]);

      print("response - ${json}");

      MaterialOutwardUploadResponse response =
          MaterialOutwardUploadResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InvoiceUploadResponse> getTodoInvoicedocumentuploadapi(
      File imagesfiles, InvoiceDocumentUploadRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_INVOICE_DOCUMENT_UPLOAD, request.toJson(),
          imageFilesToUpload: [imagesfiles]);

      InvoiceUploadResponse response = InvoiceUploadResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardUploadResponse> getinvoicedocumentuploadapi1(
      File imagesfiles, MaterialOutwardDocumentUploadRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostMultipart(
          ApiClient.END_POINT_INVOICE_DOCUMENT_UPLOAD, request.toJson(),
          imageFilesToUpload: [imagesfiles]);

      print("response - ${json}");

      MaterialOutwardUploadResponse response =
          MaterialOutwardUploadResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialOutwardDocumentDeleteResponse> InvoiceDocumentDeleteAPI(
      MaterialOutwardDocumentDeleteRequest vehicleDocumentDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_INVOICE_DOCUMENT_DELETE,
          vehicleDocumentDeleteRequest.toJson());
      // String response = json["Message"];
      MaterialOutwardDocumentDeleteResponse vehicleDocumentDeleteResponse =
          MaterialOutwardDocumentDeleteResponse.fromJson(json);

      print("fdfdfsfd" + json.toString());

      return vehicleDocumentDeleteResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<InvoiceDocumentDeleteResponse> ToDoInvoiceDocumentDeleteAPI(
      InvoiceDocumentDeleteRequest vehicleDocumentDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_INVOICE_DOCUMENT_DELETE,
          vehicleDocumentDeleteRequest.toJson());
      // String response = json["Message"];
      InvoiceDocumentDeleteResponse vehicleDocumentDeleteResponse =
          InvoiceDocumentDeleteResponse.fromJson(json);

      print("fdfdfsfd" + json.toString());

      return vehicleDocumentDeleteResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ModuleAttachmentItemWiseDeleteResponse>
      moduleattachmentdeleteItemWiseAPI(
          ModuleAttachmentsItemWiseDeleteRequest
              multiSelectionCheckNoListNoRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MODULE_ATTACHMENT_ITEM_WISE_DELETE,
          multiSelectionCheckNoListNoRequest.toJson());

      // print("JSONARRAYRESPOVN" + json.toString());
      ModuleAttachmentItemWiseDeleteResponse companyDetailsResponse =
          ModuleAttachmentItemWiseDeleteResponse.fromJson(json);
      return companyDetailsResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getProductMasterDeleteAPI(
      ProductDeleteRequest mayankBankVoucherDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_PRODUCT_MASTER_DELETE,
          mayankBankVoucherDeleteRequest.toJson());

      String response = json['Message'];

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductMasterAddEditResponse> getProductAddUpdateAPi(
      ProductMasterAddEditRequest outWordNoListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_PRODUCT_MASTER_ADD_UPDATE,
          outWordNoListRequest.toJson());
      ProductMasterAddEditResponse cityApiRespose =
          ProductMasterAddEditResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductGroupDropDownListResponse> ProductGroupDropDownListAPi(
      ProductGroupDropDownListRequest outWordNoListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_PRODUCT_MASTER_GROUP_DETAILS,
          outWordNoListRequest.toJson());
      ProductGroupDropDownListResponse cityApiRespose =
          ProductGroupDropDownListResponse.fromJson(json);
      return cityApiRespose;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getMaintenanceDetailsDelete(
      MaintenanceDeleteRequest maintenanceDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_MAINTENANCE_DETAILS_DELETE,
          maintenanceDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaintenanceAddUpdateResponse> getMaintenanceAddEdit(
      MaintenanceAddEditRequest maintenanceAddEditRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MAINTENANCE_ADD_UPDATE,
          maintenanceAddEditRequest.toJson());
      MaintenanceAddUpdateResponse response =
          MaintenanceAddUpdateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaintenanceCheckListDRPResponse> getMaintenanceCheckListDRP(
      MaintenanceCheckListDRPRequest maintenanceCheckListDRPRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MAINTENANCE_CHECKLIST_DRP_LIST_DETAILS,
          maintenanceCheckListDRPRequest.toJson());

      MaintenanceCheckListDRPResponse response =
          MaintenanceCheckListDRPResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MasterMaintenanceCheckListResponse> getMasterMaintenanceCheckList(
      MasterMaintenanceCheckListRequest
          masterMaintenanceCheckListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MASTER_MAINTENANCE_CHECKLIST_LIST_DETAILS,
          masterMaintenanceCheckListRequest.toJson());

      MasterMaintenanceCheckListResponse response =
          MasterMaintenanceCheckListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MasterMaintenanceCheckListResponse1> getMasterMaintenanceCheckList1(
      MasterMaintenanceCheckListRequest
          masterMaintenanceCheckListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MASTER_MAINTENANCE_CHECKLIST_LIST_DETAILS,
          masterMaintenanceCheckListRequest.toJson());

      MasterMaintenanceCheckListResponse1 response =
          MasterMaintenanceCheckListResponse1.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaintenanceDetailsListResponse> getMaintenanceDetailsList(
      MaintenanceDetailsListRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MAINTENANCE_FOOTER_DETAILS_LIST,
          request.toJson());

      MaintenanceDetailsListResponse response =
          MaintenanceDetailsListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getMaintenanceDetailsDeleteApi(
      MaintenanceDetailsDeleteRequest maintenanceDetailsDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_MAINTENANCE_DETAILS_DELETE_API,
          maintenanceDetailsDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaintenanceDetailsAddUpdateResponse> getMaintenanceDetailsAddUpdate(
      List<MaintenanceProductModel> request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_MAINTENANCE_DETAILS_ADD_UPDATE, request);

      MaintenanceDetailsAddUpdateResponse response =
          MaintenanceDetailsAddUpdateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<RepairingListResponse> getRepairingListAPI(
      int pageNo, RepairingListRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_REPAIRING_LIST_DETAILS,
          employeeListRequest.toJson());

      RepairingListResponse response = RepairingListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getRepairingDetailsDelete(
      RepairingDeleteRequest repairingDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_REPAIRING_DELETE_API,
          repairingDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<RepairingAddUpdateResponse> getRepairingAddEditAPI(
      RepairingAddEditRequest repairingAddEditRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_REPAIRING_ADD_UPDATE,
          repairingAddEditRequest.toJson());
      RepairingAddUpdateResponse response =
          RepairingAddUpdateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getRepairingDetailsDeleteApi(
      RepairingDetailsDeleteRequest repairingDetailsDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_REPAIRING_DETAILS_DELETE_API,
          repairingDetailsDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<RepairingDetailsAddUpdateResponse> getRepairingDetailsAddUpdate(
      List<RepairingDetailsTable> request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_REPAIRING_DETAILS_ADD_UPDATE, request);

      RepairingDetailsAddUpdateResponse response =
          RepairingDetailsAddUpdateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<RepairingDetailsListResponse> getRepairingDetailsList(
      RepairingDetailsListRequest request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_REPAIRING_FOOTER_DETAILS_LIST, request.toJson());

      RepairingDetailsListResponse response =
          RepairingDetailsListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<RepairingLogListResponse> getRepairingLogListAPI(
      RepairingLogListRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_REPAIRING_LOG_LIST_DETAILS,
          employeeListRequest.toJson());

      RepairingLogListResponse response =
          RepairingLogListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialInwardListMeetResponse> materialInwardListMeet(int pageNo,
      MaterialInwardListRequestMeet materialInwardListRequestMeet) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_INWARD_LISTS,
          materialInwardListRequestMeet.toJson());
      MaterialInwardListMeetResponse response =
          MaterialInwardListMeetResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getMaterialInwardDelete(
      MaterialInwardDeleteRequest materialInwardDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_MATERIAL_INWARD_DELETE,
          materialInwardDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialInwardMasterSaveResponce> MaterialInwardetailssave(
      MaterialInwardMasterSaveRequest materialInwardMasterSaveRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_INWARD_ADD_UPDATE,
          materialInwardMasterSaveRequest.toJson());
      MaterialInwardMasterSaveResponce response =
          MaterialInwardMasterSaveResponce.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getMaterialInwardDetailsDelete(
      MaterialInwardDetailsDeleteRequest
          materialInwardDetailsDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_MATERIAL_INWARD_DETAILS_DELETE,
          materialInwardDetailsDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialInwardCustomerListResponce> getCustomerListApi(
      MaterialInwardCustomerListRequest
          materialInwardCustomerListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_CUSTOMER_PAGINATION_Meet,
          materialInwardCustomerListRequest.toJson());
      MaterialInwardCustomerListResponce response =
          MaterialInwardCustomerListResponce.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialInwardDetailListResponse> getMaterialInwardDetailsListApi(
      MaterialInwardDetailListRequest materialInwardDetailListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_INWARD_DETAILS_LIST,
          materialInwardDetailListRequest.toJson());
      MaterialInwardDetailListResponse response =
          MaterialInwardDetailListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialInwardDetailsAddUpdateResponseDetails>
      getMaterialInwardDetailsAddUpdate(
          List<MaterialInwardTable> request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_MATERIAL_INWARD_DETAILS_ADD_UPDATE, request);

      MaterialInwardDetailsAddUpdateResponseDetails response =
          MaterialInwardDetailsAddUpdateResponseDetails.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LocationListResponse> getLocationList(
      LocationListRequest locationListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOCATION_LIST_DETAILS,
          locationListRequest.toJson());
      LocationListResponse response = LocationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialInwardPendingPurchaseOrderListResponse>
      getMaterialInwardGetPoNoAPI(
          MIGetOrderNoFromTheCustomerIdRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_INWARD_GET_PO_NO, request.toJson());
      MaterialInwardPendingPurchaseOrderListResponse response =
          MaterialInwardPendingPurchaseOrderListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MIGetFetDetailByOrderNoListResponse> getMIGetFetDetailByOrderNoAPI(
      MIGetFetDetailByOrderNoListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_INWARD_GET_DETAILS_SO_NO,
          request.toJson());
      MIGetFetDetailByOrderNoListResponse response =
          MIGetFetDetailByOrderNoListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getPurchaseOrderDelete(
      PoHeaderDeleteRequest poHeaderDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_PO_DELETE, poHeaderDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<POApprovalListResponse> getPOApprovalListAPI(
      POApprovalRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PO_APPROVAL_LIST, request.toJson());
      POApprovalListResponse response = POApprovalListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getPOApprovalSaveAPI(
      POApprovalSaveRequest pOApprovalSaveRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_PO_APPROVAL_SAVE, pOApprovalSaveRequest.toJson());
      // String response = json["Message"];
      String response = json['Message'];

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PODrpListResponse> getPODrpListAPI(PODrpListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PO_DRP_LIST, request.toJson());
      PODrpListResponse response = PODrpListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  ///ServiceReport
  Future<ServiceReportListResponse> getServiceReportAPI(
      int pageNo, ServiceReportListRequest serviceReportListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SERVICE_REPORT_LIST,
          serviceReportListRequest.toJson());
      ServiceReportListResponse response =
          ServiceReportListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getServiceReportDeleteApi(
      ServiceReportDeleteRequest serviceReportDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_SERVICE_REPORT_DELETE,
          serviceReportDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ServiceReportAddUpdateResponse> getServiceReportAddUpdateApi(
      ServiceReportAddUpdateRequest serviceReportAddUpdateRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SERVICE_REPORT_ADD_UPDATE,
          serviceReportAddUpdateRequest.toJson());
      ServiceReportAddUpdateResponse response =
          ServiceReportAddUpdateResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MachineMasterListRequestResponse> getMachineTypeListApi(
      MachineMasterListRequest machineMasterListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MACHINE_MASTER_LIST_DETAILS,
          machineMasterListRequest.toJson());
      MachineMasterListRequestResponse response =
          MachineMasterListRequestResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ServiceReportDetailsListResponse> getServiceReportDetailsListApi(
      ServiceReportDetailsListRequest serviceReportDetailsListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SERVICE_REPORT_DETAILS_LIST,
          serviceReportDetailsListRequest.toJson());
      ServiceReportDetailsListResponse response =
          ServiceReportDetailsListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getServiceReportDetailsDelete(
      ServiceReportDetailsDeleteRequest
          serviceReportDetailsDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_SERVICE_REPORT_DETAILS_DELETE,
          serviceReportDetailsDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ServiceReportDetailsAddUpdateResponse>
      getServiceReportDetailsAddUpdateApi(List<WorkNotesTable> request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              ApiClient.END_POINT_SERVICE_REPORT_DETAILS_ADD_UPDATE, request);

      ServiceReportDetailsAddUpdateResponse response =
          ServiceReportDetailsAddUpdateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  ///ShortInvoice
  Future<ShortInvoiceListResponse> getShortInvoiceListAPI(
      int pageNo, ShortInvoiceListRequest shortInvoiceListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SHORT_INVOICE_LIST,
          shortInvoiceListRequest.toJson());
      ShortInvoiceListResponse response =
          ShortInvoiceListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getShortInvoiceDeleteApi(
      ShortInvoiceDeleteRequest shortInvoiceDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_SHORT_INVOICE_DELETE,
          shortInvoiceDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ShortInvoiceShipmentListResponse> getShortInvoiceShipmentListApi(
      ShortInvoiceShipmentListRequest shortInvoiceShipmentListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SHORT_INVOICE_SHIPMENT_LIST,
          shortInvoiceShipmentListRequest.toJson());
      ShortInvoiceShipmentListResponse response =
          ShortInvoiceShipmentListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ShortInvoiceExportListResponse> getShortInvoiceExportListApi(
      ShortInvoiceExportListRequest shortInvoiceExportListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SHORT_INVOICE_EXPORT_LIST,
          shortInvoiceExportListRequest.toJson());
      ShortInvoiceExportListResponse response =
          ShortInvoiceExportListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ShortInvoiceDetailsListResponse> getShortInvoiceDetailsListApi(
      ShortInvoiceDetailsListRequest shortInvoiceDetailsListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SHORT_INVOICE_DETAILS_LIST,
          shortInvoiceDetailsListRequest.toJson());
      ShortInvoiceDetailsListResponse response =
          ShortInvoiceDetailsListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ShortInvoiceAddUpdateResponse> getShortInvoiceAddUpdateApi(
      ShortInvoiceAddUpdateRequest shortInvoiceExportListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SHORT_INVOICE_ADD_UPDATE,
          shortInvoiceExportListRequest.toJson());
      ShortInvoiceAddUpdateResponse response =
          ShortInvoiceAddUpdateResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SaleOrderProductSaveResponse> getShortInvoiceProductAddUpdateApi(
      List<ShortInvoiceProductRequest> arrSalesOrderProductList) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              "${ApiClient.END_POINT_SHORT_INVOICE_PRODUCT_SAVE}",
              arrSalesOrderProductList);
      SaleOrderProductSaveResponse inquiryProductSaveResponse =
          SaleOrderProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SaleOrderProductSaveResponse> getShortInvoiceExportAddUpdateApi(
      ShortInvoiceExportSaveRequest arrSalesOrderProductList) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SHORT_INVOICE_EXPORT_SAVE,
          arrSalesOrderProductList.toJson());
      SaleOrderProductSaveResponse inquiryProductSaveResponse =
          SaleOrderProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SaleOrderProductSaveResponse> getShortInvoiceShipmentAddUpdateApi(
      ShortInvoiceShipmentSaveRequest arrSalesOrderProductList) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SHORT_INVOICE_SHIPMENT_SAVE,
          arrSalesOrderProductList.toJson());
      SaleOrderProductSaveResponse inquiryProductSaveResponse =
          SaleOrderProductSaveResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getShortInvoiceDetailsDeleteApi(
      ShortInvoiceDetailsListRequest shortInvoiceDetailsListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_SHORT_INVOICE_DETAILS_DELETE,
          shortInvoiceDetailsListRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ProductMasterResponse> getProductListAPi(
      ProductMasterListRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PRODUCT_MASTER_LIST_API + "1" + "-100000",
          request.toJson());
      ProductMasterResponse response = ProductMasterResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ShortInvoiceAssemblyLoadResponse> getShortInvoiceAssemblyLoadListAPi(
      ShortInvoiceAssemblyLoadRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SHORT_INVOICE_ASSEMBLY_LOAD_LIST_API,
          request.toJson());
      ShortInvoiceAssemblyLoadResponse response =
          ShortInvoiceAssemblyLoadResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PurchaseBillAddUpdateResponse> getPurchaseBillAddUpdateApi(
      PurchaseBillAddUpdateRequest shortInvoiceExportListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PURCHASE_BILL_ADD_UPDATE,
          shortInvoiceExportListRequest.toJson());
      PurchaseBillAddUpdateResponse response =
          PurchaseBillAddUpdateResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PurchaseBillDetailsListResponse> getPurchaseBillDetailsListApi(
      PurchaseBillDetailsListRequest shortInvoiceDetailsListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PURCHASE_BILL_DETAILS_LIST,
          shortInvoiceDetailsListRequest.toJson());
      PurchaseBillDetailsListResponse response =
          PurchaseBillDetailsListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getPurchaseBillDetailsDeleteApi(
      PurchaseBillDetailsListRequest shortInvoiceDetailsListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_PURCHASE_BILL_DETAILS_DELETE,
          shortInvoiceDetailsListRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PurchaseBillAddUpdateResponse> getPurchaseBillDetailsAddUpdateApi(
      List<PurchaseBillDetailsAddUpdateRequest>
          arrSalesOrderProductList) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              "${ApiClient.END_POINT_PURCHASE_BILL_DETAILS_SAVE}",
              arrSalesOrderProductList);
      PurchaseBillAddUpdateResponse inquiryProductSaveResponse =
          PurchaseBillAddUpdateResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PurchaseBillACResponse> getPurchaseBillACApi(
      PurchaseBillACRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PURCHASE_BILL_AC_API, request.toJson());
      PurchaseBillACResponse response = PurchaseBillACResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PurchaseBillTODResponse> getPurchaseBillTODApi(
      PurchaseBillTODRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PURCHASE_BILL_TOD_API, request.toJson());
      PurchaseBillTODResponse response = PurchaseBillTODResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiNoToProductDetailsFromPurchaseOrderResponse>
      getMultiNoToProductDetailsFromPurchaseOrderApi(
          MultiNoToProductDetailsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQ_QT_SO_NO_PRODUCT_LIST_API, request.toJson());
      MultiNoToProductDetailsFromPurchaseOrderResponse response =
          MultiNoToProductDetailsFromPurchaseOrderResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiNoToProductDetailsFromGRNResponse>
      getMultiNoToProductDetailsFromGrnApi(
          MultiNoToProductDetailsRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_INQ_QT_SO_NO_PRODUCT_LIST_API, request.toJson());
      MultiNoToProductDetailsFromGRNResponse response =
          MultiNoToProductDetailsFromGRNResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  /// PurchaseOrder

  Future<PurchaseOrderAddUpdateResponse> getPurchaseOrderAddUpdateApi(
      PurchaseOrderAddUpdateRequest shortInvoiceExportListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PURCHASE_ORDER_ADD_UPDATE,
          shortInvoiceExportListRequest.toJson());
      PurchaseOrderAddUpdateResponse response =
          PurchaseOrderAddUpdateResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PurchaseOrderDetailsListResponse> getPurchaseOrderDetailsListApi(
      PurchaseOrderDetailsListRequest shortInvoiceDetailsListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PURCHASE_ORDER_DETAILS_LIST,
          shortInvoiceDetailsListRequest.toJson());
      PurchaseOrderDetailsListResponse response =
          PurchaseOrderDetailsListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getPurchaseOrderDetailsDeleteApi(
      PurchaseOrderDetailsListRequest shortInvoiceDetailsListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_PURCHASE_ORDER_DETAILS_DELETE,
          shortInvoiceDetailsListRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PurchaseOrderAddUpdateResponse> getPurchaseOrderDetailsAddUpdateApi(
      List<PurchaseOrderDetailsAddUpdateRequest>
          arrSalesOrderProductList) async {
    try {
      Map<String, dynamic> json =
          await apiClient.apiCallPostforMultipleJSONArray(
              "${ApiClient.END_POINT_PURCHASE_ORDER_DETAILS_SAVE}",
              arrSalesOrderProductList);
      PurchaseOrderAddUpdateResponse inquiryProductSaveResponse =
          PurchaseOrderAddUpdateResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PurchaseOrderShipmentListResponse> getPurchaseOrderShipmentListApi(
      PurchaseOrderShipmentListRequest shortInvoiceShipmentListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PO_SHIPMENT_LIST,
          shortInvoiceShipmentListRequest.toJson());
      PurchaseOrderShipmentListResponse response =
          PurchaseOrderShipmentListResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PurchaseOrderAddUpdateResponse> getPurchaseOrderShipmentAddUpdateApi(
      PurchaseOrderShipmentSaveRequest arrSalesOrderProductList) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PO_SHIPMENT_SAVE,
          arrSalesOrderProductList.toJson());
      PurchaseOrderAddUpdateResponse inquiryProductSaveResponse =
          PurchaseOrderAddUpdateResponse.fromJson(json);
      return inquiryProductSaveResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PoFromTheIndentListResponse> getPOFromTheIndentNumberApi(
      PoFromTheIndentListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PENDING_INDENT_LIST, request.toJson());
      PoFromTheIndentListResponse response =
          PoFromTheIndentListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<POTankerListResponse> getPoTankerListApi(
      POTankerListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_TANKER_LIST, request.toJson());
      POTankerListResponse response = POTankerListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PODriverListResponse> getPoDriverListApi(
      PODriverListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_DRIVER_LIST, request.toJson());
      PODriverListResponse response = PODriverListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DashboardLocationListResponse> getLocationListAPI(
      DashboardLocationListRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOCATION_LIST, employeeListRequest.toJson());

      DashboardLocationListResponse response =
          DashboardLocationListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DashboardLocationLogListResponse> getLocationLogListAPI(
      DashboardLocationListRequest employeeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_LOCATION_LOG_LIST, employeeListRequest.toJson());

      DashboardLocationLogListResponse response =
          DashboardLocationLogListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PaySlipListResponse> getPaySlipListAPi(
      PaySlipListRequest request) async {
    try {
      /// API Client Class Here Declare Value
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PAY_SLIP_LIST_API, request.toJson());
      PaySlipListResponse response = PaySlipListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AttendanceHolidayApiResponse> getAttendanceHolidayApi(
      AttendanceHolidayApiRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ATTENDANCE_HOLIDAY_LIST, request.toJson());
      AttendanceHolidayApiResponse response =
          AttendanceHolidayApiResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<LeaveRequestListResponse> getAttendanceLeaveRequestList(
      LeaveRequestListAPIRequest leaveRequestListAPIRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_LEAVE_REQUEST_PAGINATION}/1-10000",
          leaveRequestListAPIRequest.toJson());
      LeaveRequestListResponse response =
          LeaveRequestListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<VisitorInfoListApiResponse> getVisitorInfoListApi(
      int pageNo, VisitorInfoListApiRequest visitorInfoListApiRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_VISITOR_INFO_LIST,
          visitorInfoListApiRequest.toJson());

      VisitorInfoListApiResponse response =
          VisitorInfoListApiResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getVisitorInfoDeleteAPI(
      VisitorInfoDeleteApiRequest visitorInfoDeleteApiRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_VISITOR_INFO_DELETE,
          visitorInfoDeleteApiRequest.toJson());
      String response = json['Message'];

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<VisitorInfoAddUpdateApiResponse> getVisitorInfoAddUpdateAPI(
    VisitorInfoAddUpdateApiRequest request, {
    File file,
    File file1,
  }) async {
    try {
      final Map<String, dynamic> requestJsonMap = request.toJson();

      final Map<String, dynamic> json = await apiClient.apiCallPostWithFile(
        ApiClient.END_POINT_VISITOR_INFO_ADD_UPDATE,
        requestJsonMap,
        file: file,
        file1: file1,
      );

      return VisitorInfoAddUpdateApiResponse.fromJson(json);
    } catch (e) {
      rethrow;
    }
  }

  Future<SOCustomerNearByPinCodeSummaryResponse>
      getSOCustomerNearByPinCodeSummaryApi(
          SOCustomerNearByPinCodeCommonRequest
              sOCustomerNearByPinCodeCommonRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SO_CUSTOMER_NEAR_BY_PIN_CODE_COMMON,
          sOCustomerNearByPinCodeCommonRequest.toJson());
      SOCustomerNearByPinCodeSummaryResponse
          sOCustomerNearByPinCodeSummaryResponse =
          SOCustomerNearByPinCodeSummaryResponse.fromJson(json);
      return sOCustomerNearByPinCodeSummaryResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SOCustomerNearByPinCodeDetailsResponse>
      getSOCustomerNearByPinCodeDetailsApi(
          SOCustomerNearByPinCodeCommonRequest
              sOCustomerNearByPinCodeCommonRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_SO_CUSTOMER_NEAR_BY_PIN_CODE_COMMON,
          sOCustomerNearByPinCodeCommonRequest.toJson());
      SOCustomerNearByPinCodeDetailsResponse
          sOCustomerNearByPinCodeSummaryResponse =
          SOCustomerNearByPinCodeDetailsResponse.fromJson(json);
      return sOCustomerNearByPinCodeSummaryResponse;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialIndentListResponse> getMaterialIndentListApi(
      int pageNo, MaterialIndentListRequest materialIndentListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MATERIAL_INDENT_LIST,
          materialIndentListRequest.toJson());

      MaterialIndentListResponse response =
          MaterialIndentListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MaterialIndentApprovalUpdateResponse>
      getMaterialIndentApprovalUpdateApi(
          MaterialIndentApprovalUpdateRequest
              materialIndentApprovalUpdateRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_MATERIAL_INDENT_APPROVAL_UPDATE}",
          materialIndentApprovalUpdateRequest.toJson(),
          showSuccessDialog: false);
      MaterialIndentApprovalUpdateResponse response =
          MaterialIndentApprovalUpdateResponse.fromJson(json);
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiExpenseListResponse> getMultiExpenseList(
      int pageNo, MultiExpenseListRequest multiExpenseListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MULTI_EXPENSE_LIST,
          multiExpenseListRequest.toJson());

      MultiExpenseListResponse response =
          MultiExpenseListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getMultiExpenseDeleteAPI(
      MultiExpenseDeleteRequest multiExpenseDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_MULTI_EXPENSE_DELETE,
          multiExpenseDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiExpenseAddUpdateResponse> getMultiExpenseAddUpdateApi(
      MultiExpenseAddUpdateRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MULTI_EXPENSE_ADD_UPDATE, request.toJson());
      MultiExpenseAddUpdateResponse response =
          MultiExpenseAddUpdateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultipleExpenseDetailsListResponse> getMultiExpenseDetailsListApi(
      MultiExpenseListRequest multiExpenseListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MULTI_EXPENSE_DETAILS_LIST,
          multiExpenseListRequest.toJson());

      MultipleExpenseDetailsListResponse response =
          MultipleExpenseDetailsListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<String> getMulExpenseDetailDeleteApi(
      MulExpenseDetailDeleteRequest mulExpenseDetailDeleteRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForMassage(
          ApiClient.END_POINT_MULTI_EXPENSE_DETAILS_DELETE,
          mulExpenseDetailDeleteRequest.toJson());
      String response = json['Message'];
      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MulExpenseDetailAddUpdateResponse> getMulExpenseDetailAddUpdate(
      List<MultipleExpenseTable> request) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPostForExpenseFormData(
          ApiClient.END_POINT_MULTI_EXPENSE_DETAILS_ADD_UPDATE, request);

      MulExpenseDetailAddUpdateResponse response =
          MulExpenseDetailAddUpdateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiExpenseTypeListResponse> getMultiExpenseTypeListApi(
      MultiExpenseTypeListRequest multiExpenseTypeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MULTI_EXPENSE_TYPE_LIST,
          multiExpenseTypeListRequest.toJson());

      MultiExpenseTypeListResponse response =
          MultiExpenseTypeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultiExpenseModeListResponse> getMultiExpenseModeListApi(
      MultiExpenseModeListRequest multiExpenseModeListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MULTI_EXPENSE_MODE_LIST,
          multiExpenseModeListRequest.toJson());

      MultiExpenseModeListResponse response =
          MultiExpenseModeListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CustomerDetailsResponse> getExpenseCustomerList(
      CustomerPaginationRequest customerPaginationRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          "${ApiClient.END_POINT_CUSTOMER_PAGINATION}/1-100000000",
          customerPaginationRequest.toJson());

      CustomerDetailsResponse response = CustomerDetailsResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<DebitNotesListResponse> getDebitNotesListApi(
      DebitCreditNotesListRequest debitCreditNotesListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_DBCR_NOTES_LIST,
          debitCreditNotesListRequest.toJson());

      DebitNotesListResponse response = DebitNotesListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<CreditNotesListResponse> getCreditNotesListApi(
      DebitCreditNotesListRequest debitCreditNotesListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_DBCR_NOTES_LIST,
          debitCreditNotesListRequest.toJson());

      CreditNotesListResponse response = CreditNotesListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<JournalVoucherListResponse> getJournalVoucherListApi(
      JournalVoucherMstAssetListRequest
          journalVoucherMstAssetListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_JOURNAL_VOUCHER_LIST,
          journalVoucherMstAssetListRequest.toJson());

      JournalVoucherListResponse response =
          JournalVoucherListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AssetIssueListResponse> getAssetIssueListApi(
      JournalVoucherMstAssetListRequest
          journalVoucherMstAssetListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ASSET_ISSUE_LIST,
          journalVoucherMstAssetListRequest.toJson());

      AssetIssueListResponse response = AssetIssueListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<PettyCashListResponse> getPettyCashListApi(
      PettyCashListRequest pettyCashListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_PETTY_CASH_LIST, pettyCashListRequest.toJson());

      PettyCashListResponse response = PettyCashListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<AssetReturnListResponse> getAssetReturnListApi(
      JournalVoucherMstAssetListRequest
          journalVoucherMstAssetListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_ASSET_RETURN_LIST,
          journalVoucherMstAssetListRequest.toJson());

      AssetReturnListResponse response = AssetReturnListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<OfficeRefTypeFromCustomerIDResponse> getOfficeRefTypeFromCustomerIDApi(
      OfficeRefTypeFromCustomerIDRequest
          officeRefTypeFromCustomerIDRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_OFFICE_REF_TYPE_FROM_CUSTOMER_ID_LIST,
          officeRefTypeFromCustomerIDRequest.toJson());

      OfficeRefTypeFromCustomerIDResponse response =
          OfficeRefTypeFromCustomerIDResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultipleExpenseApprovalListResponse> getMultipleExpenseApprovalListApi(
      MultiExpenseApprovalListRequest
          multipleExpenseApprovalListRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_OFFICE_EXPENSE_APPROVAL_LIST,
          multipleExpenseApprovalListRequest.toJson());

      MultipleExpenseApprovalListResponse response =
          MultipleExpenseApprovalListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<MultipleExpenseApprovalUpdateResponse>
      getMultipleExpenseApprovalUpdateApi(
          MultiExpenseApprovalUpdateRequest
              multiExpenseApprovalUpdateRequest) async {
    //todo due to one api bug temporary adding following key
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_OFFICE_EXPENSE_APPROVAL_UPDATE,
          multiExpenseApprovalUpdateRequest.toJson());

      MultipleExpenseApprovalUpdateResponse response =
          MultipleExpenseApprovalUpdateResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<SalesOrderApprovalStatusListResponse>
      getMultiExpenseApprovalStatusListAPI(
          SalesOrderApprovalStatusListRequest request) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_MULTIPLE_EXPENSE_APPROVAL_STATUS,
          request.toJson());
      SalesOrderApprovalStatusListResponse response =
          SalesOrderApprovalStatusListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<QuickFollowupReportListResponse> getQuickFollowupReportListAPI(
      QuickFollowupReportListRequest employeeListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_QUICK_FOLLOWUP_REPORT_LIST,
          employeeListRequest.toJson());

      QuickFollowupReportListResponse response =
          QuickFollowupReportListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExpenseTrackingListResponse> getExpenseTrackingList(
      ExpenseTrackingListRequest expenseTrackingListRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_EXPENSE_TRACKING_LIST,
          expenseTrackingListRequest.toJson());
      ExpenseTrackingListResponse response =
          ExpenseTrackingListResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }

  Future<ExpenseTrackingSaveResponse> getExpenseTrackingSave(
      ExpenseTrackingSaveRequest expenseTrackingSaveRequest) async {
    try {
      Map<String, dynamic> json = await apiClient.apiCallPost(
          ApiClient.END_POINT_EXPENSE_TRACKING_SAVE,
          expenseTrackingSaveRequest.toJson());
      ExpenseTrackingSaveResponse response =
          ExpenseTrackingSaveResponse.fromJson(json);

      return response;
    } on ErrorResponseException catch (e) {
      rethrow;
    }
  }
}
