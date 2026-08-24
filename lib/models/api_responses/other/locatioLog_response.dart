class DashboardLocationLogListResponse {
  List<DashboardLocationLogListResponseDetails> details;
  int totalCount;

  DashboardLocationLogListResponse({this.details, this.totalCount});

  DashboardLocationLogListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new DashboardLocationLogListResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class DashboardLocationLogListResponseDetails {
  int pkID;
  String locationOff;
  String internetOff;
  String logDateTime;
  String deviceName;
  int employeeID;
  String message;
  String employeeName;
  String createdBy;
  String createdDate;

  DashboardLocationLogListResponseDetails(
      {this.pkID,
      this.locationOff,
      this.internetOff,
      this.logDateTime,
      this.deviceName,
      this.employeeID,
      this.message,
      this.employeeName,
      this.createdBy,
      this.createdDate});

  DashboardLocationLogListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    locationOff = json['LocationOff'];
    internetOff = json['InternetOff'];
    logDateTime = json['LogDateTime'];
    deviceName = json['DeviceName'];
    employeeID = json['EmployeeID'];
    message = json['Message'];
    employeeName = json['EmployeeName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['LocationOff'] = this.locationOff;
    data['InternetOff'] = this.internetOff;
    data['LogDateTime'] = this.logDateTime;
    data['DeviceName'] = this.deviceName;
    data['EmployeeID'] = this.employeeID;
    data['Message'] = this.message;
    data['EmployeeName'] = this.employeeName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
