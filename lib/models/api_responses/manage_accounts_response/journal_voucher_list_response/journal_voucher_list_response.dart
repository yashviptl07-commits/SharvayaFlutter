class JournalVoucherListResponse {
  List<JournalVoucherListResponseDetails> details;
  int totalCount;

  JournalVoucherListResponse({this.details, this.totalCount});

  JournalVoucherListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new JournalVoucherListResponseDetails.fromJson(v));
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

class JournalVoucherListResponseDetails {
  int rowNum;
  int pkID;
  String voucherNo;
  String voucherDate;
  double voucherAmount;
  String dBC;
  String remarks;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String createdEmployeeName;
  String updatedEmployeeName;

  JournalVoucherListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.voucherNo,
      this.voucherDate,
      this.voucherAmount,
      this.dBC,
      this.remarks,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.createdEmployeeName,
      this.updatedEmployeeName});

  JournalVoucherListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    voucherNo = json['VoucherNo'];
    voucherDate = json['VoucherDate'];
    voucherAmount = json['VoucherAmount'];
    dBC = json['DBC'];
    remarks = json['Remarks'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    createdEmployeeName = json['CreatedEmployeeName'];
    updatedEmployeeName = json['UpdatedEmployeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['VoucherNo'] = this.voucherNo;
    data['VoucherDate'] = this.voucherDate;
    data['VoucherAmount'] = this.voucherAmount;
    data['DBC'] = this.dBC;
    data['Remarks'] = this.remarks;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['UpdatedEmployeeName'] = this.updatedEmployeeName;
    return data;
  }
}
