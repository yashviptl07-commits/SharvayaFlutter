class ExpenseTrackingSaveRequest {
  String pKID;
  String TripID;
  String EmployeeID;
  String CompanyID;
  String LoginUserID;
  String StartTime;
  String EndTime;
  String StartLatitude;
  String StartLongitude;
  String EndLatitude;
  String EndLongitude;
  String TotalDistanceKm;
  String CreatedBy;
  String UpdatedBy;
  String IsDeleted;

  ExpenseTrackingSaveRequest(
      {this.pKID,
      this.TripID,
      this.EmployeeID,
      this.CompanyID,
      this.LoginUserID,
      this.StartTime,
      this.EndTime,
      this.StartLatitude,
      this.StartLongitude,
      this.EndLatitude,
      this.EndLongitude,
      this.TotalDistanceKm,
      this.CreatedBy,
      this.UpdatedBy,
      this.IsDeleted});

  ExpenseTrackingSaveRequest.fromJson(Map<String, dynamic> json) {
    pKID = json['pKID'];
    TripID = json['TripID'];
    EmployeeID = json['EmployeeID'];
    CompanyID = json['CompanyID'];
    LoginUserID = json['LoginUserID'];
    StartTime = json['StartTime'];
    EndTime = json['EndTime'];
    StartLatitude = json['StartLatitude'];
    StartLongitude = json['StartLongitude'];
    EndLatitude = json['EndLatitude'];
    EndLongitude = json['EndLongitude'];
    TotalDistanceKm = json['TotalDistanceKm'];
    CreatedBy = json['CreatedBy'];
    UpdatedBy = json['UpdatedBy'];
    IsDeleted = json['IsDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pKID'] = this.pKID;
    data['TripID'] = this.TripID;
    data['EmployeeID'] = this.EmployeeID;
    data['CompanyID'] = this.CompanyID;
    data['LoginUserID'] = this.LoginUserID;
    data['StartTime'] = this.StartTime;
    data['EndTime'] = this.EndTime;
    data['StartLatitude'] = this.StartLatitude;
    data['StartLongitude'] = this.StartLongitude;
    data['EndLatitude'] = this.EndLatitude;
    data['EndLongitude'] = this.EndLongitude;
    data['TotalDistanceKm'] = this.TotalDistanceKm;
    data['CreatedBy'] = this.CreatedBy;
    data['UpdatedBy'] = this.UpdatedBy;
    data['IsDeleted'] = this.IsDeleted;
    return data;
  }
}
