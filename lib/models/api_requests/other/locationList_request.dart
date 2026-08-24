/*
pkID:0
LogDate:2024-07-02
EmployeeID:47
LoginUserID:admin
CompanyId:9284*/
class DashboardLocationListRequest {
  String EmployeeID;
  int CompanyId;
  String pkID;
  String LogDate;
  String LoginUserID;

  DashboardLocationListRequest(
      {this.EmployeeID,
      this.CompanyId,
      this.pkID,
      this.LogDate,
      this.LoginUserID});

  DashboardLocationListRequest.fromJson(Map<String, dynamic> json) {
    EmployeeID = json['EmployeeID'];
    CompanyId = json['CompanyId'];
    pkID = json['pkID'];
    LogDate = json['LogDate'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeID'] = this.EmployeeID;
    data['CompanyId'] = this.CompanyId;
    data['pkID'] = this.pkID;
    data['LogDate'] = this.LogDate;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
