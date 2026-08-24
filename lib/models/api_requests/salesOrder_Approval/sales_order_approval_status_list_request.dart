/*pkID:0
StatusCategory:SOApproval
PageNo:1
PageSize:100
CompanyId:4132*/

class SalesOrderApprovalStatusListRequest {
  String pkID;
  String StatusCategory;
  String PageNo;
  String PageSize;
  String CompanyId;


  SalesOrderApprovalStatusListRequest({ this.pkID,this.StatusCategory,
    this.PageNo, this.PageSize, this.CompanyId});


  SalesOrderApprovalStatusListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    StatusCategory = json['StatusCategory'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['StatusCategory'] = this.StatusCategory;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}