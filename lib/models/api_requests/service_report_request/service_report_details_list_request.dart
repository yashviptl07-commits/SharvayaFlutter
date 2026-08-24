class ServiceReportDetailsListRequest {
  String ServiceNo;
  String CompanyId;

  ServiceReportDetailsListRequest({
    this.ServiceNo,
    this.CompanyId,
  });

  ServiceReportDetailsListRequest.fromJson(Map<String, dynamic> json) {
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
