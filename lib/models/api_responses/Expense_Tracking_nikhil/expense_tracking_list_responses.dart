class ExpenseTrackingListResponse {
  List<ExpenseTrackingListDetails> details;
  int totalCount;

  ExpenseTrackingListResponse({this.details, this.totalCount});

  ExpenseTrackingListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ExpenseTrackingListDetails.fromJson(v));
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

class ExpenseTrackingListDetails {
  int rowNum;
  int pKID;
  String tripID;
  int employeeID;
  int companyID;
  String loginUserID;
  String startTime;
  String endTime;
  String startLatitude;
  String startLongitude;
  String endLatitude;
  String endLongitude;
  String totalDistanceKm;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String isDeleted;
  String vehicleType;

  ExpenseTrackingListDetails(
      {this.rowNum,
      this.pKID,
      this.tripID,
      this.employeeID,
      this.companyID,
      this.loginUserID,
      this.startTime,
      this.endTime,
      this.startLatitude,
      this.startLongitude,
      this.endLatitude,
      this.endLongitude,
      this.totalDistanceKm,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.isDeleted,
      this.vehicleType});

  ExpenseTrackingListDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pKID = json['pKID'] == null ? 0 : json['pKID'];
    tripID = json['TripID'] == null ? "" : json['TripID'].toString();
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    companyID = json['CompanyID'] == null ? 0 : json['CompanyID'];
    loginUserID =
        json['LoginUserID'] == null ? "" : json['LoginUserID'].toString();
    startTime = json['StartTime'] == null ? "" : json['StartTime'].toString();
    endTime = json['EndTime'] == null ? "" : json['EndTime'].toString();
    startLatitude =
        json['StartLatitude'] == null ? "" : json['StartLatitude'].toString();
    startLongitude =
        json['StartLongitude'] == null ? "" : json['StartLongitude'].toString();
    endLatitude =
        json['EndLatitude'] == null ? "" : json['EndLatitude'].toString();
    endLongitude =
        json['EndLongitude'] == null ? "" : json['EndLongitude'].toString();
    totalDistanceKm = json['TotalDistanceKm'] == null
        ? ""
        : json['TotalDistanceKm'].toString();
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'].toString();
    createdDate =
        json['CreatedDate'] == null ? "" : json['CreatedDate'].toString();
    updatedBy = json['UpdatedBy'] == null ? "" : json['UpdatedBy'].toString();
    updatedDate =
        json['UpdatedDate'] == null ? "" : json['UpdatedDate'].toString();
    isDeleted = json['IsDeleted'] == null ? "" : json['IsDeleted'].toString();
    vehicleType =
        json['VehicleType'] == null ? "" : json['VehicleType'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pKID'] = this.pKID;
    data['TripID'] = this.tripID;
    data['EmployeeID'] = this.employeeID;
    data['CompanyID'] = this.companyID;
    data['LoginUserID'] = this.loginUserID;
    data['StartTime'] = this.startTime;
    data['EndTime'] = this.endTime;
    data['StartLatitude'] = this.startLatitude;
    data['StartLongitude'] = this.startLongitude;
    data['EndLatitude'] = this.endLatitude;
    data['EndLongitude'] = this.endLongitude;
    data['TotalDistanceKm'] = this.totalDistanceKm;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['IsDeleted'] = this.isDeleted;
    data['VehicleType'] = this.vehicleType;
    return data;
  }
}
