/*
ApprovalStatus:Approved
LoginUserID:admin
Month:0
Year:2024
PageNo:1
PageSize:11
CompanyId:7291
*/
class PODrpListRequest {
  String ApprovalStatus;
  String LoginUserID;
  String Month;
  String Year;
  String CustomerID;
  String ProductID;
  String CompanyId;

  PODrpListRequest({this.ApprovalStatus, this.LoginUserID,
    this.Month, this.Year, this.CustomerID, this.ProductID, this.CompanyId});

  PODrpListRequest.fromJson(Map<String, dynamic> json) {
    ApprovalStatus = json['ApprovalStatus'];
    LoginUserID = json['LoginUserID'];
    Month = json['Month'];
    Year = json['Year'];
    CustomerID = json['CustomerID'];
    ProductID = json['ProductID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ApprovalStatus'] = this.ApprovalStatus;
    data['LoginUserID'] = this.LoginUserID;
    data['Month'] = this.Month;
    data['Year'] = this.Year;
    data['CustomerID'] = this.CustomerID;
    data['ProductID'] = this.ProductID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
