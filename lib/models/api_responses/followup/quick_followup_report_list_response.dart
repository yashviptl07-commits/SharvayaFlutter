class QuickFollowupReportListResponse {
  List<QuickFollowupReportListResponseDetails> details;
  int totalCount;

  QuickFollowupReportListResponse({this.details, this.totalCount});

  QuickFollowupReportListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new QuickFollowupReportListResponseDetails.fromJson(v));
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

class QuickFollowupReportListResponseDetails {
  int employeeID;
  String employeeName;
  int customerID;
  String customerName;
  String inquiryNo;
  String followupDate;
  String nextFollowupDate;
  String meetingNotes;
  String latitudeIN;
  String longitudeIN;
  String latitudeOUT;
  String longitudeOUT;
  String locationAddressIN;
  String locationAddressOUT;

  QuickFollowupReportListResponseDetails(
      {this.employeeID,
      this.employeeName,
      this.customerID,
      this.customerName,
      this.inquiryNo,
      this.followupDate,
      this.nextFollowupDate,
      this.meetingNotes,
      this.latitudeIN,
      this.longitudeIN,
      this.latitudeOUT,
      this.longitudeOUT,
      this.locationAddressIN,
      this.locationAddressOUT});

  QuickFollowupReportListResponseDetails.fromJson(Map<String, dynamic> json) {
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    inquiryNo = json['InquiryNo'];
    followupDate = json['FollowupDate'];
    nextFollowupDate = json['NextFollowupDate'];
    meetingNotes = json['MeetingNotes'];
    latitudeIN = json['Latitude_IN'];
    longitudeIN = json['Longitude_IN'];
    latitudeOUT = json['Latitude_OUT'];
    longitudeOUT = json['Longitude_OUT'];
    locationAddressIN = json['LocationAddress_IN'];
    locationAddressOUT = json['LocationAddress_OUT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['InquiryNo'] = this.inquiryNo;
    data['FollowupDate'] = this.followupDate;
    data['NextFollowupDate'] = this.nextFollowupDate;
    data['MeetingNotes'] = this.meetingNotes;
    data['Latitude_IN'] = this.latitudeIN;
    data['Longitude_IN'] = this.longitudeIN;
    data['Latitude_OUT'] = this.latitudeOUT;
    data['Longitude_OUT'] = this.longitudeOUT;
    data['LocationAddress_IN'] = this.locationAddressIN;
    data['LocationAddress_OUT'] = this.locationAddressOUT;
    return data;
  }
}
