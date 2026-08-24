class FollowupFilterListForAlmightyRequest {
  String CompanyId;
  String LoginUserID;
  int PageNo;
  int PageSize;
  String SearchKey;

  FollowupFilterListForAlmightyRequest(
      {this.CompanyId,
      this.LoginUserID,
      this.PageNo,
      this.PageSize,
      this.SearchKey});

  FollowupFilterListForAlmightyRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    SearchKey = json['SearchKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['SearchKey'] = this.SearchKey;

    return data;
  }
}
