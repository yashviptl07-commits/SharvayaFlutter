/*
pkID:0
ActivityDate:2023-09-12
TaskCategoryID:2
CustomerID:31417
TaskDescription:TaskDescription
EstHours:1.00
TaskDuration:0.45
ToDOID:0
LoginUserID:admin
CompanyId:4132*/

class SharvayaDailyActivitySaveRequest {
  String pkID;
  String ActivityDate;
  String TaskCategoryID;
  String CustomerID;
  String TaskDescription;
  String EstHours;
  String TaskDuration;
  String ToDOID;
  String LoginUserID;
  String CompanyId;
  String ModuleID;

  SharvayaDailyActivitySaveRequest(
      {this.pkID,
      this.ActivityDate,
      this.TaskCategoryID,
      this.CustomerID,
      this.TaskDescription,
      this.EstHours,
      this.TaskDuration,
      this.ToDOID,
      this.LoginUserID,
      this.ModuleID,
      this.CompanyId});

  SharvayaDailyActivitySaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ActivityDate = json['ActivityDate'];
    TaskCategoryID = json['TaskCategoryID'];
    CustomerID = json['CustomerID'];
    TaskDescription = json['TaskDescription'];
    EstHours = json['EstHours'];
    TaskDuration = json['TaskDuration'];
    ToDOID = json['ToDOID'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
    ModuleID = json['ModuleID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ActivityDate'] = this.ActivityDate;
    data['TaskCategoryID'] = this.TaskCategoryID;
    data['CustomerID'] = this.CustomerID;
    data['TaskDescription'] = this.TaskDescription;
    data['EstHours'] = this.EstHours;
    data['TaskDuration'] = this.TaskDuration;
    data['ToDOID'] = this.ToDOID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    data['ModuleID'] = this.ModuleID;

    return data;
  }
}
