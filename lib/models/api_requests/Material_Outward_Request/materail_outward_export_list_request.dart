/*
OutwardNo:OT-APR24-013
LoginUserID:admin
CompanyId:0*/
class MaterialOutwardExportListMainRequest {
  String OutwardNo;
  String LoginUserID;
  String CompanyId;

  MaterialOutwardExportListMainRequest(
      {this.OutwardNo, this.LoginUserID, this.CompanyId});

  MaterialOutwardExportListMainRequest.fromJson(Map<String, dynamic> json) {
    OutwardNo = json['OutwardNo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OutwardNo'] = this.OutwardNo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
