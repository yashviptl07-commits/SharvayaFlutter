class CustomerHistoryListResponse {
  List<CustomerHistoryListResponseDetails> details;
  int totalCount;
  CustomerHistoryListResponse({this.details, this.totalCount});
  CustomerHistoryListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CustomerHistoryListResponseDetails.fromJson(v));
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
class CustomerHistoryListResponseDetails {
  dynamic customerID;
  String customerName;
  String inquiryNo;
  String followupDate;
  String preferredTime;
  String nextFollowupDate;
  String meetingNotes;
  String contactNo1;
  String followupType;
  String employeeName;
  String createdDate;
  String createdBy;

  CustomerHistoryListResponseDetails(
      {this.customerID,
        this.customerName,
        this.inquiryNo,
        this.followupDate,
        this.preferredTime,
        this.nextFollowupDate,
        this.meetingNotes,
        this.contactNo1,
        this.followupType,
        this.employeeName,
        this.createdDate,
        this.createdBy});
  CustomerHistoryListResponseDetails.fromJson(Map<String, dynamic> json) {
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    inquiryNo = json['InquiryNo'] == null ? "" : json['InquiryNo'];
    followupDate = json['FollowupDate'] == null ? "" : json['FollowupDate'];
    preferredTime = json['PreferredTime'] == null ? "" : json['PreferredTime'];
    nextFollowupDate =
    json['NextFollowupDate'] == null ? "" : json['NextFollowupDate'];
    meetingNotes = json['MeetingNotes'] == null ? "" : json['MeetingNotes'];
    contactNo1 = json['ContactNo1'] == null ? "" : json['ContactNo1'];
    followupType = json['FollowupType'] == null ? "" : json['FollowupType'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['InquiryNo'] = this.inquiryNo;
    data['FollowupDate'] = this.followupDate;
    data['PreferredTime'] = this.preferredTime;
    data['NextFollowupDate'] = this.nextFollowupDate;
    data['MeetingNotes'] = this.meetingNotes;
    data['ContactNo1'] = this.contactNo1;
    data['FollowupType'] = this.followupType;
    data['EmployeeName'] = this.employeeName;
    data['CreatedDate'] = this.createdDate;
    data['CreatedBy'] = this.createdBy;
    return data;
  }
}