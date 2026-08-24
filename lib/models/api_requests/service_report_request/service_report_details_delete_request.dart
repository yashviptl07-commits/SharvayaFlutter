/*
OutwardNo:OT-JAN24-002
CompanyId:0*/
  class ServiceReportDetailsDeleteRequest {
  String ServiceNo;
  String CompanyId;

  ServiceReportDetailsDeleteRequest({this.ServiceNo, this.CompanyId});

  ServiceReportDetailsDeleteRequest.fromJson(Map<String, dynamic> json) {
    ServiceNo = json['ServiceNo'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ServiceNo'] = this.ServiceNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
