class DashboardLocationListResponse {
  List<DashboardLocationListResponseDetails> details;
  int totalCount;

  DashboardLocationListResponse({this.details, this.totalCount});

  DashboardLocationListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new DashboardLocationListResponseDetails.fromJson(v));
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

class DashboardLocationListResponseDetails {
  int pkID;
  String latitude;
  String longitude;
  String logDateTime;
  String deviceName;
  int employeeID;
  String employeeName;
  String createdBy;
  String createdDate;

  DashboardLocationListResponseDetails(
      {this.pkID,
      this.latitude,
      this.longitude,
      this.logDateTime,
      this.deviceName,
      this.employeeID,
      this.employeeName,
      this.createdBy,
      this.createdDate});

  DashboardLocationListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    logDateTime = json['LogDateTime'];
    deviceName = json['DeviceName'];
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['LogDateTime'] = this.logDateTime;
    data['DeviceName'] = this.deviceName;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
