/*

TaskStatus:Todays
Month:0
Year:2023
OwnerShip:initiate
OwnerShipName:Hiral Panchal
LoginUserID:Hiral
CompanyId:4132
  */

class ToDoWidgetListApiRequest {
  String TaskStatus;
  String Month;
  String Year;
  String OwnerShip;
  String OwnerShipName;
  String LoginUserID;
  String CompanyId;

  ToDoWidgetListApiRequest(
      {this.TaskStatus,
      this.Month,
      this.Year,
      this.OwnerShip,
      this.OwnerShipName,
      this.LoginUserID,
      this.CompanyId});

  ToDoWidgetListApiRequest.fromJson(Map<String, dynamic> json) {
    TaskStatus = json['TaskStatus'];
    Month = json['Month'];
    Year = json['Year'];
    OwnerShip = json['OwnerShip'];
    OwnerShipName = json['OwnerShipName'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TaskStatus'] = this.TaskStatus;
    data['Month'] = "";
    data['Year'] = "";
    data['OwnerShip'] = this.OwnerShip;
    data['OwnerShipName'] = this.OwnerShipName;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
