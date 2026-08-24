/*
OutwardNo:OT-JAN24-002
CompanyId:0*/
class MaterialInwardDetailsDeleteRequest {
  String InwardNo;
  String CompanyId;

  MaterialInwardDetailsDeleteRequest({
    this.InwardNo,
    this.CompanyId});


  MaterialInwardDetailsDeleteRequest.fromJson(Map<String, dynamic> json) {
    InwardNo = json['InwardNo'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InwardNo'] = this.InwardNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}