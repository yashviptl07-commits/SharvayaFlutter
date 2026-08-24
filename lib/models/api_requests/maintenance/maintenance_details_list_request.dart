/*
OutwardNo:OT-APR24-013
CompanyId:0*/
class MaintenanceDetailsListRequest {
  String InquiryNo;
  String CompanyId;

  MaintenanceDetailsListRequest({
    this.InquiryNo,
    this.CompanyId});


  MaintenanceDetailsListRequest.fromJson(Map<String, dynamic> json) {
    InquiryNo = json['InquiryNo'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InquiryNo'] = this.InquiryNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}