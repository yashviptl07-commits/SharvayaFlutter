/*
OutwardNo:OT-JAN24-002
CompanyId:0*/
class MaterialOutwardDetailsDeleteRequest {
  String OutwardNo;
  String CompanyId;

  MaterialOutwardDetailsDeleteRequest({
    this.OutwardNo,
    this.CompanyId});


  MaterialOutwardDetailsDeleteRequest.fromJson(Map<String, dynamic> json) {
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