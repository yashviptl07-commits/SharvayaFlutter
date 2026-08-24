/*
pkID:0
ListMode:Inward
PageNo:1
PageSize:100
TotalCount:
CompanyId:7291
*/

class MaterialInwardDetailListRequest {
  String InwardNo;
  String CompanyId;

  MaterialInwardDetailListRequest({
    this.InwardNo,
    this.CompanyId,
  });

  MaterialInwardDetailListRequest.fromJson(Map<String, dynamic> json) {
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