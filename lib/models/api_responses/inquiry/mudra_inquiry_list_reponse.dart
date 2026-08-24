import 'package:soleoserp/models/common/all_name_id_list.dart';

class InquiryListResponse1 {
  List<InquiryDetails1> details;
  int totalCount;

  InquiryListResponse1({this.details, this.totalCount});

  InquiryListResponse1.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new InquiryDetails1.fromJson(v));
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

class InquiryDetails1 {
  int rowNum;
  int pkID;
  String inquiryNo;
  String inquiryDate;
  String referenceName;
  String inquirySourceID;
  String inquirySourceName;
  int customerID;
  String customerName;
  String contactNo;
  String emailAddress;
  String followupNotes;
  String followupDate;
  String meetingNotes;
  int closureReasonID;
  String closureReason;
  int inquiryStatusID;
  String inquiryStatus;
  int followupTypeID;
  String priority;
  String preferredTime;
  String followupType;
  double totalAmount;
  String employeeName;
  String designation;
  String createdBy;
  String createdDate;
  dynamic leadDate;
  String lastFollowupDate;
  String lastNextFollowupDate;

  List<ALL_Name_ID> qtList = [];

  InquiryDetails1(
      {this.rowNum,
      this.pkID,
      this.inquiryNo,
      this.inquiryDate,
      this.referenceName,
      this.inquirySourceID,
      this.inquirySourceName,
      this.customerID,
      this.customerName,
      this.contactNo,
      this.emailAddress,
      this.followupNotes,
      this.followupDate,
      this.meetingNotes,
      this.closureReasonID,
      this.closureReason,
      this.inquiryStatusID,
      this.inquiryStatus,
      this.followupTypeID,
      this.priority,
      this.preferredTime,
      this.followupType,
      this.totalAmount,
      this.employeeName,
      this.designation,
      this.createdBy,
      this.createdDate,
      this.leadDate,
      this.lastFollowupDate,
      this.lastNextFollowupDate,
      this.qtList});

  InquiryDetails1.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    inquiryNo = json['InquiryNo'] == null ? "" : json['InquiryNo'];
    inquiryDate = json['InquiryDate'] == null ? "" : json['InquiryDate'];
    referenceName = json['ReferenceName'] == null ? "" : json['ReferenceName'];
    inquirySourceID =
        json['InquirySourceID'] == null ? "" : json['InquirySourceID'];
    inquirySourceName =
        json['InquirySourceName'] == null ? "" : json['InquirySourceName'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    contactNo = json['ContactNo'] == null ? "" : json['ContactNo'];
    emailAddress = json['EmailAddress'] == null ? "" : json['EmailAddress'];
    followupNotes = json['FollowupNotes'] == null ? "" : json['FollowupNotes'];
    followupDate = json['FollowupDate'] == null ? "" : json['FollowupDate'];
    meetingNotes = json['MeetingNotes'] == null ? "" : json['MeetingNotes'];
    closureReasonID =
        json['ClosureReasonID'] == null ? 0 : json['ClosureReasonID'];
    closureReason = json['ClosureReason'] == null ? "" : json['ClosureReason'];
    inquiryStatusID =
        json['InquiryStatusID'] == null ? 0 : json['InquiryStatusID'];
    inquiryStatus = json['InquiryStatus'] == null ? "" : json['InquiryStatus'];
    followupTypeID =
        json['FollowupTypeID'] == null ? 0 : json['FollowupTypeID'];
    priority = json['Priority'] == null ? "" : json['Priority'];
    preferredTime = json['PreferredTime'] == null ? "" : json['PreferredTime'];
    followupType = json['FollowupType'] == null ? "" : json['FollowupType'];
    totalAmount = json['TotalAmount'] == null ? 0.00 : json['TotalAmount'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    designation = json['Designation'] == null ? "" : json['Designation'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    leadDate = json['LeadDate'] == null ? dynamic : json['LeadDate'];
    lastFollowupDate =
        json['LastFollowupDate'] == null ? "" : json['LastFollowupDate'];
    lastNextFollowupDate = json['LastNextFollowupDate'] == null
        ? ""
        : json['LastNextFollowupDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InquiryNo'] = this.inquiryNo;
    data['InquiryDate'] = this.inquiryDate;
    data['ReferenceName'] = this.referenceName;
    data['InquirySourceID'] = this.inquirySourceID;
    data['InquirySourceName'] = this.inquirySourceName;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['ContactNo'] = this.contactNo;
    data['EmailAddress'] = this.emailAddress;
    data['FollowupNotes'] = this.followupNotes;
    data['FollowupDate'] = this.followupDate;
    data['MeetingNotes'] = this.meetingNotes;
    data['ClosureReasonID'] = this.closureReasonID;
    data['ClosureReason'] = this.closureReason;
    data['InquiryStatusID'] = this.inquiryStatusID;
    data['InquiryStatus'] = this.inquiryStatus;
    data['FollowupTypeID'] = this.followupTypeID;
    data['Priority'] = this.priority;
    data['PreferredTime'] = this.preferredTime;
    data['FollowupType'] = this.followupType;
    data['TotalAmount'] = this.totalAmount;
    data['EmployeeName'] = this.employeeName;
    data['Designation'] = this.designation;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['LeadDate'] = this.leadDate;
    data['LastFollowupDate'] = this.lastFollowupDate;
    data['LastNextFollowupDate'] = this.lastNextFollowupDate;
    return data;
  }
}
