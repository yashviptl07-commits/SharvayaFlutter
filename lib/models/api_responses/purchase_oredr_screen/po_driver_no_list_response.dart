class PODriverListResponse {
  List<PODriverListResponseDetails> details;
  int totalCount;

  PODriverListResponse({this.details, this.totalCount});

  PODriverListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new PODriverListResponseDetails.fromJson(v));
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

class PODriverListResponseDetails {
  int pkID;
  String employeeName;
  String mobileNo;

  PODriverListResponseDetails({
    this.pkID,
    this.employeeName,
    this.mobileNo,
  });

  PODriverListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    employeeName = json['EmployeeName'];
    mobileNo = json['MobileNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['EmployeeName'] = this.employeeName;
    data['MobileNo'] = this.mobileNo;
    return data;
  }
}
