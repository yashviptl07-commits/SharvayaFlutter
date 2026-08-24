/*
pkID:0
ActivityDate:2023-09-12
LoginUserID:admin
EmployeeID:47
PageNo:1
PageSize:10
CompanyId:4132*/
class SharvayaDailyActivityListRequest {
  int pkID;
  String ActivityDate;
  String LoginUserID;
  String EmployeeID;
  int PageNo;
  int PageSize;
  int CompanyId;

  SharvayaDailyActivityListRequest(
      {this.pkID,
      this.ActivityDate,
      this.LoginUserID,
      this.EmployeeID,
      this.PageNo,
      this.PageSize,
      this.CompanyId});

  SharvayaDailyActivityListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ActivityDate = json['ActivityDate'];
    LoginUserID = json['LoginUserID'];
    EmployeeID = json['EmployeeID'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ActivityDate'] = this.ActivityDate;
    data['LoginUserID'] = this.LoginUserID;
    data['EmployeeID'] = this.EmployeeID;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
