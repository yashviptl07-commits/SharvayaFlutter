/*
OutwardNo:OT-APR24-013
CompanyId:0*/
class MaterialOutwardDetailsListRequest {
  String OutwardNo;
  String CompanyId;

  MaterialOutwardDetailsListRequest({
    this.OutwardNo,
    this.CompanyId});


  MaterialOutwardDetailsListRequest.fromJson(Map<String, dynamic> json) {
    OutwardNo = json['OutwardNo'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OutwardNo'] = this.OutwardNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}