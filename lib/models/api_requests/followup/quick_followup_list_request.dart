class QuickFollowupListRequest {
  // String FollowupDate;
  String CompanyId;
  String FollowupStatus;
  String EmployeeID;
  String SearchKey;

  QuickFollowupListRequest(
      {/*this.FollowupDate,*/ this.CompanyId,
        this.FollowupStatus,
        this.EmployeeID,
        this.SearchKey
      });

  QuickFollowupListRequest.fromJson(Map<String, dynamic> json) {
    // FollowupDate = json['FollowupDate'];
    CompanyId = json['CompanyId'];
    FollowupStatus = json['FollowupStatus'];
    EmployeeID = json['EmployeeID'];

    SearchKey = json['SearchKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['FollowupDate'] = this.FollowupDate;
    data['CompanyId'] = this.CompanyId;
    data['FollowupStatus'] = this.FollowupStatus;
    data['EmployeeID'] = this.EmployeeID;
    data['SearchKey'] = this.SearchKey;

    return data;
  }
}
