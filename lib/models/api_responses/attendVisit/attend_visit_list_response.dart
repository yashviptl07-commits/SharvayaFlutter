class AttendVisitListResponse {
  List<AttendVisitDetails> details;
  int totalCount;

  AttendVisitListResponse({this.details, this.totalCount});

  AttendVisitListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new AttendVisitDetails.fromJson(v));
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

class AttendVisitDetails {
  int rowNum;
  int pkID;
  int visitID;
  String complaintNo;
  String complaintDate;
  String complaintStatus;
  int customerID;
  String customerName;
  String preferredDate;
  String preferredTimeFrom;
  String preferredTimeTo;
  String visitDate;
  String timeFrom;
  String timeTo;
  String visitType;
  String visitChargeType;
  double visitCharge;
  String visitNotes;
  int employeeID;
  String employeeName;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String complaintNotes;
  String timeIn;
  String timeOut;
  String latitudeIN;
  String latitudeOUT;
  String longitudeIN;
  String longitudeOUT;
  String locationAddressIN;
  String locationAddressOUT;
  String nextVisitDate;

  AttendVisitDetails({
    this.rowNum,
    this.pkID,
    this.complaintNo,
    this.complaintDate,
    this.complaintStatus,
    this.customerID,
    this.customerName,
    this.preferredDate,
    this.preferredTimeFrom,
    this.preferredTimeTo,
    this.visitDate,
    this.timeFrom,
    this.timeTo,
    this.visitType,
    this.visitChargeType,
    this.visitCharge,
    this.visitNotes,
    this.employeeID,
    this.employeeName,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.complaintNotes,
    this.timeIn,
    this.timeOut,
    this.latitudeIN,
    this.latitudeOUT,
    this.longitudeIN,
    this.longitudeOUT,
    this.locationAddressIN,
    this.locationAddressOUT,
    this.nextVisitDate,
  });

  AttendVisitDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    visitID = json['VisitID'] == null ? 0 : json['VisitID'];
    complaintNo = json['ComplaintNo'] == null ? "" : json['ComplaintNo'];
    complaintDate = json['ComplaintDate'] == null ? "" : json['ComplaintDate'];
    complaintStatus =
        json['ComplaintStatus'] == null ? "" : json['ComplaintStatus'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    preferredDate = json['PreferredDate'] == null ? "" : json['PreferredDate'];
    preferredTimeFrom =
        json['PreferredTimeFrom'] == null ? "" : json['PreferredTimeFrom'];
    preferredTimeTo =
        json['PreferredTimeTo'] == null ? "" : json['PreferredTimeTo'];
    visitDate = json['VisitDate'] == null ? "" : json['VisitDate'];
    timeFrom = json['TimeFrom'] == null ? "" : json['TimeFrom'];
    timeTo = json['TimeTo'] == null ? "" : json['TimeTo'];
    visitType = json['VisitType'] == null ? "" : json['VisitType'];
    visitChargeType =
        json['VisitChargeType'] == null ? "" : json['VisitChargeType'];
    visitCharge = json['VisitCharge'] == null ? 0.00 : json['VisitCharge'];
    visitNotes = json['VisitNotes'] == null ? "" : json['VisitNotes'];
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    updatedBy = json['UpdatedBy'] == null ? "" : json['UpdatedBy'];
    updatedDate = json['UpdatedDate'] == null ? "" : json['UpdatedDate'];
    complaintNotes =
        json['ComplaintNotes'] == null ? "" : json['ComplaintNotes'];
    timeIn = json['TimeIn'] == null ? "" : json['TimeIn'];
    timeOut = json['TimeOut'] == null ? "" : json['TimeOut'];
    latitudeIN = json['Latitude_IN'] == null ? "" : json['Latitude_IN'];
    latitudeOUT = json['Latitude_OUT'] == null ? "" : json['Latitude_OUT'];
    longitudeIN = json['Longitude_IN'] == null ? "" : json['Longitude_IN'];
    longitudeOUT = json['Longitude_OUT'] == null ? "" : json['Longitude_OUT'];
    locationAddressIN =
        json['LocationAddress_IN'] == null ? "" : json['LocationAddress_IN'];
    locationAddressOUT =
        json['LocationAddress_OUT'] == null ? "" : json['LocationAddress_OUT'];
    nextVisitDate = json['NextVisitDate'] == null ? "" : json['NextVisitDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['VisitID'] = this.visitID;
    data['ComplaintNo'] = this.complaintNo;
    data['ComplaintDate'] = this.complaintDate;
    data['ComplaintStatus'] = this.complaintStatus;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['PreferredDate'] = this.preferredDate;
    data['PreferredTimeFrom'] = this.preferredTimeFrom;
    data['PreferredTimeTo'] = this.preferredTimeTo;
    data['VisitDate'] = this.visitDate;
    data['TimeFrom'] = this.timeFrom;
    data['TimeTo'] = this.timeTo;
    data['VisitType'] = this.visitType;
    data['VisitChargeType'] = this.visitChargeType;
    data['VisitCharge'] = this.visitCharge;
    data['VisitNotes'] = this.visitNotes;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['ComplaintNotes'] = this.complaintNotes;
    data['TimeIn'] = this.timeIn;
    data['TimeOut'] = this.timeOut;
    data['Latitude_IN'] = this.latitudeIN;
    data['Latitude_OUT'] = this.latitudeOUT;
    data['Longitude_IN'] = this.longitudeIN;
    data['Longitude_OUT'] = this.longitudeOUT;
    data['LocationAddress_IN'] = this.locationAddressIN;
    data['LocationAddress_OUT'] = this.locationAddressOUT;
    data['NextVisitDate'] = this.nextVisitDate;
    return data;
  }
}
