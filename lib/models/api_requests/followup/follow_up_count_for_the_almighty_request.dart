class FollowupCountForAlmightyRequest {
  String CompanyId;
  String LoginUserID;
  String FollowupStatus;
  String SearchKey;

  FollowupCountForAlmightyRequest(
      {this.CompanyId, this.LoginUserID, this.FollowupStatus, this.SearchKey});

  FollowupCountForAlmightyRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    FollowupStatus = json['FollowupStatus'];
    SearchKey = json['SearchKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;
    data['FollowupStatus'] = this.FollowupStatus;
    data['SearchKey'] = this.SearchKey;

    return data;
  }
}
