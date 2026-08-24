class AttendanceHolidayApiRequest {
  String pkID;
  String SearchKey;
  String PageNo;
  String PageSize;
  String CompanyId;
  String LoginUserID;

  AttendanceHolidayApiRequest(
      {this.pkID,
      this.SearchKey,
      this.PageNo,
      this.PageSize,
      this.CompanyId,
      this.LoginUserID});

  AttendanceHolidayApiRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
