class CreditNotesListResponse {
  List<CreditNotesListResponseDetails> details;
  int totalCount;

  CreditNotesListResponse({this.details, this.totalCount});

  CreditNotesListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CreditNotesListResponseDetails.fromJson(v));
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

class CreditNotesListResponseDetails {
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
  int dBStateID;
  int cRStateID;
  String employeeName;
  String designation;
  String createdBy;
  double basicAmt;
  double discountAmt;
  double sGSTAmt;
  double cGSTAmt;
  double iGSTAmt;
  double rOffAmt;
  String chargeName1;
  int chargeID1;
  double chargeAmt1;
  double chargeBasicAmt1;
  double chargeGSTAmt1;
  String chargeName2;
  int chargeID2;
  double chargeAmt2;
  double chargeBasicAmt2;
  double chargeGSTAmt2;
  String chargeName3;
  int chargeID3;
  double chargeAmt3;
  double chargeBasicAmt3;
  double chargeGSTAmt3;
  String chargeName4;
  int chargeID4;
  double chargeAmt4;
  double chargeBasicAmt4;
  double chargeGSTAmt4;
  String chargeName5;
  int chargeID5;
  double chargeAmt5;
  double chargeBasicAmt5;
  double chargeGSTAmt5;
  double netAmt;

  String invoiceNo;
  String invoiceDate;
  int bankID;
  String bankName;
  String branchName;
  String bankAccountNo;
  String bankIFSC;
  String bankSWIFT;
  String bankAccountName;
  String deliveryNote;
  String deliveryNoteDate;
  String termsOfPayment;
  String dispatchDocNo;
  String vehicleNo;
  String dispatchThrough;

  CreditNotesListResponseDetails(
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
      this.dBStateID,
      this.cRStateID,
      this.employeeName,
      this.designation,
      this.createdBy,
      this.basicAmt,
      this.discountAmt,
      this.sGSTAmt,
      this.cGSTAmt,
      this.iGSTAmt,
      this.rOffAmt,
      this.chargeName1,
      this.chargeID1,
      this.chargeAmt1,
      this.chargeBasicAmt1,
      this.chargeGSTAmt1,
      this.chargeName2,
      this.chargeID2,
      this.chargeAmt2,
      this.chargeBasicAmt2,
      this.chargeGSTAmt2,
      this.chargeName3,
      this.chargeID3,
      this.chargeAmt3,
      this.chargeBasicAmt3,
      this.chargeGSTAmt3,
      this.chargeName4,
      this.chargeID4,
      this.chargeAmt4,
      this.chargeBasicAmt4,
      this.chargeGSTAmt4,
      this.chargeName5,
      this.chargeID5,
      this.chargeAmt5,
      this.chargeBasicAmt5,
      this.chargeGSTAmt5,
      this.netAmt,
      this.invoiceNo,
      this.invoiceDate,
      this.bankID,
      this.bankName,
      this.branchName,
      this.bankAccountNo,
      this.bankIFSC,
      this.bankSWIFT,
      this.bankAccountName,
      this.deliveryNote,
      this.deliveryNoteDate,
      this.termsOfPayment,
      this.dispatchDocNo,
      this.vehicleNo,
      this.dispatchThrough});

  CreditNotesListResponseDetails.fromJson(Map<String, dynamic> json) {
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
    dBStateID = json['DBStateID'];
    cRStateID = json['CRStateID'];
    employeeName = json['EmployeeName'];
    designation = json['Designation'];
    createdBy = json['CreatedBy'];
    basicAmt = json['BasicAmt'];
    discountAmt = json['DiscountAmt'];
    sGSTAmt = json['SGSTAmt'];
    cGSTAmt = json['CGSTAmt'];
    iGSTAmt = json['IGSTAmt'];
    rOffAmt = json['ROffAmt'];
    chargeName1 = json['ChargeName1'];
    chargeID1 = json['ChargeID1'];
    chargeAmt1 = json['ChargeAmt1'];
    chargeBasicAmt1 = json['ChargeBasicAmt1'];
    chargeGSTAmt1 = json['ChargeGSTAmt1'];
    chargeName2 = json['ChargeName2'];
    chargeID2 = json['ChargeID2'];
    chargeAmt2 = json['ChargeAmt2'];
    chargeBasicAmt2 = json['ChargeBasicAmt2'];
    chargeGSTAmt2 = json['ChargeGSTAmt2'];
    chargeName3 = json['ChargeName3'];
    chargeID3 = json['ChargeID3'];
    chargeAmt3 = json['ChargeAmt3'];
    chargeBasicAmt3 = json['ChargeBasicAmt3'];
    chargeGSTAmt3 = json['ChargeGSTAmt3'];
    chargeName4 = json['ChargeName4'];
    chargeID4 = json['ChargeID4'];
    chargeAmt4 = json['ChargeAmt4'];
    chargeBasicAmt4 = json['ChargeBasicAmt4'];
    chargeGSTAmt4 = json['ChargeGSTAmt4'];
    chargeName5 = json['ChargeName5'];
    chargeID5 = json['ChargeID5'];
    chargeAmt5 = json['ChargeAmt5'];
    chargeBasicAmt5 = json['ChargeBasicAmt5'];
    chargeGSTAmt5 = json['ChargeGSTAmt5'];
    netAmt = json['NetAmt'];
    invoiceNo = json['InvoiceNo'];
    invoiceDate = json['InvoiceDate'];
    bankID = json['BankID'];
    bankName = json['BankName'];
    branchName = json['BranchName'];
    bankAccountNo = json['BankAccountNo'];
    bankIFSC = json['BankIFSC'];
    bankSWIFT = json['BankSWIFT'];
    bankAccountName = json['BankAccountName'];
    deliveryNote = json['DeliveryNote'];
    deliveryNoteDate = json['DeliveryNoteDate'];
    termsOfPayment = json['TermsOfPayment'];
    dispatchDocNo = json['DispatchDocNo'];
    vehicleNo = json['VehicleNo'];
    dispatchThrough = json['DispatchThrough'];
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
    data['DBStateID'] = this.dBStateID;
    data['CRStateID'] = this.cRStateID;
    data['EmployeeName'] = this.employeeName;
    data['Designation'] = this.designation;
    data['CreatedBy'] = this.createdBy;
    data['BasicAmt'] = this.basicAmt;
    data['DiscountAmt'] = this.discountAmt;
    data['SGSTAmt'] = this.sGSTAmt;
    data['CGSTAmt'] = this.cGSTAmt;
    data['IGSTAmt'] = this.iGSTAmt;
    data['ROffAmt'] = this.rOffAmt;
    data['ChargeName1'] = this.chargeName1;
    data['ChargeID1'] = this.chargeID1;
    data['ChargeAmt1'] = this.chargeAmt1;
    data['ChargeBasicAmt1'] = this.chargeBasicAmt1;
    data['ChargeGSTAmt1'] = this.chargeGSTAmt1;
    data['ChargeName2'] = this.chargeName2;
    data['ChargeID2'] = this.chargeID2;
    data['ChargeAmt2'] = this.chargeAmt2;
    data['ChargeBasicAmt2'] = this.chargeBasicAmt2;
    data['ChargeGSTAmt2'] = this.chargeGSTAmt2;
    data['ChargeName3'] = this.chargeName3;
    data['ChargeID3'] = this.chargeID3;
    data['ChargeAmt3'] = this.chargeAmt3;
    data['ChargeBasicAmt3'] = this.chargeBasicAmt3;
    data['ChargeGSTAmt3'] = this.chargeGSTAmt3;
    data['ChargeName4'] = this.chargeName4;
    data['ChargeID4'] = this.chargeID4;
    data['ChargeAmt4'] = this.chargeAmt4;
    data['ChargeBasicAmt4'] = this.chargeBasicAmt4;
    data['ChargeGSTAmt4'] = this.chargeGSTAmt4;
    data['ChargeName5'] = this.chargeName5;
    data['ChargeID5'] = this.chargeID5;
    data['ChargeAmt5'] = this.chargeAmt5;
    data['ChargeBasicAmt5'] = this.chargeBasicAmt5;
    data['ChargeGSTAmt5'] = this.chargeGSTAmt5;
    data['NetAmt'] = this.netAmt;
    data['InvoiceNo'] = this.invoiceNo;
    data['InvoiceDate'] = this.invoiceDate;
    data['BankID'] = this.bankID;
    data['BankName'] = this.bankName;
    data['BranchName'] = this.branchName;
    data['BankAccountNo'] = this.bankAccountNo;
    data['BankIFSC'] = this.bankIFSC;
    data['BankSWIFT'] = this.bankSWIFT;
    data['BankAccountName'] = this.bankAccountName;
    data['DeliveryNote'] = this.deliveryNote;
    data['DeliveryNoteDate'] = this.deliveryNoteDate;
    data['TermsOfPayment'] = this.termsOfPayment;
    data['DispatchDocNo'] = this.dispatchDocNo;
    data['VehicleNo'] = this.vehicleNo;
    data['DispatchThrough'] = this.dispatchThrough;
    return data;
  }
}
