class LeaveRequestTypeResponse {
  List<LeaveTypeDetails> details;
  int totalCount;

  LeaveRequestTypeResponse({this.details, this.totalCount});

  LeaveRequestTypeResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details =  [];
      json['details'].forEach((v) {
        details.add(new LeaveTypeDetails.fromJson(v));
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

class LeaveTypeDetails {
  int rowNum;
  int pkID;
  String description;
  String category;
  String leaveCode;
  String payrollStatus;

  LeaveTypeDetails(
      {this.rowNum,
        this.pkID,
        this.description,
        this.category,
        this.leaveCode,
        this.payrollStatus});

  LeaveTypeDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum']==null?0:json['RowNum'];
    pkID = json['pkID']==null?0:json['pkID'];
    description = json['Description']==null?"":json['Description'];
    category = json['Category']==null?"":json['Category'];
    leaveCode = json['LeaveCode']==null?"":json['LeaveCode'];
    payrollStatus = json['PayrollStatus']==null?"":json['PayrollStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['Description'] = this.description;
    data['Category'] = this.category;
    data['LeaveCode'] = this.leaveCode;
    data['PayrollStatus'] = this.payrollStatus;
    return data;
  }
}