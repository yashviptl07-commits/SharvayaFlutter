class PettyCashListResponse {
  List<PettyCashListResponseDetails> details;
  int totalCount;

  PettyCashListResponse({this.details, this.totalCount});

  PettyCashListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new PettyCashListResponseDetails.fromJson(v));
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

class PettyCashListResponseDetails {
  int rowNum;
  int pkID;
  String voucherNo;
  String voucherDate;
  int dBCustomerID;
  String dBCustomerName;
  int cRCustomerID;
  String cRCustomerName;
  double voucherAmount;
  String remarks;
  String dBC;
  String employeeName;
  String designation;
  String createdBy;

  PettyCashListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.voucherNo,
      this.voucherDate,
      this.dBCustomerID,
      this.dBCustomerName,
      this.cRCustomerID,
      this.cRCustomerName,
      this.voucherAmount,
      this.remarks,
      this.dBC,
      this.employeeName,
      this.designation,
      this.createdBy});

  PettyCashListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    voucherNo = json['VoucherNo'];
    voucherDate = json['VoucherDate'];
    dBCustomerID = json['DBCustomerID'];
    dBCustomerName = json['DBCustomerName'];
    cRCustomerID = json['CRCustomerID'];
    cRCustomerName = json['CRCustomerName'];
    voucherAmount = json['VoucherAmount'];
    remarks = json['Remarks'];
    dBC = json['DBC'];
    employeeName = json['EmployeeName'];
    designation = json['Designation'];
    createdBy = json['CreatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['VoucherNo'] = this.voucherNo;
    data['VoucherDate'] = this.voucherDate;
    data['DBCustomerID'] = this.dBCustomerID;
    data['DBCustomerName'] = this.dBCustomerName;
    data['CRCustomerID'] = this.cRCustomerID;
    data['CRCustomerName'] = this.cRCustomerName;
    data['VoucherAmount'] = this.voucherAmount;
    data['Remarks'] = this.remarks;
    data['DBC'] = this.dBC;
    data['EmployeeName'] = this.employeeName;
    data['Designation'] = this.designation;
    data['CreatedBy'] = this.createdBy;
    return data;
  }
}
