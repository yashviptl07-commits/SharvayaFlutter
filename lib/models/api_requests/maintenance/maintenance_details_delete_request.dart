/*
OutwardNo:OT-JAN24-002
CompanyId:0*/
class MaintenanceDetailsDeleteRequest {
  String InquiryNo;
  String CompanyId;

  MaintenanceDetailsDeleteRequest({this.InquiryNo, this.CompanyId});

  MaintenanceDetailsDeleteRequest.fromJson(Map<String, dynamic> json) {
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
