class MayankBankVoucherListResponse {
  List<MayankBankVoucherListDetails> details;
  int totalCount;

  MayankBankVoucherListResponse({this.details, this.totalCount});

  MayankBankVoucherListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MayankBankVoucherListDetails.fromJson(v));
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

class MayankBankVoucherListDetails {
  int rowNum;
  int pkID;
  String voucherType;
  String recPay;
  String voucherNo;
  String voucherDate;
  int accountID;
  String accountName;
  int customerID;
  String customerName;
  int employeeID;
  String employeeName;
  String transType;
  int transModeID;
  String transModeName;
  String transID;
  String transDate;
  int tDSAccountID;
  String tDSAccountName;
  dynamic tDSAmount;
  dynamic voucherAmount;
  String bankName;
  String remark;
  int terminationOfDelivery;
  String rDURD;
  double sGSTPer;
  double sGSTAmt;
  double cGSTPer;
  double cGSTAmt;
  double iGSTPer;
  double iGSTAmt;
  double taxPer;
  double basicAmt;
  double gSTAmt;
  double netAmt;
  String invoiceNo;

  MayankBankVoucherListDetails(
      {this.rowNum,
      this.pkID,
      this.voucherType,
      this.recPay,
      this.voucherNo,
      this.voucherDate,
      this.accountID,
      this.accountName,
      this.customerID,
      this.customerName,
      this.employeeID,
      this.employeeName,
      this.transType,
      this.transModeID,
      this.transModeName,
      this.transID,
      this.transDate,
      this.tDSAccountID,
      this.tDSAccountName,
      this.tDSAmount,
      this.voucherAmount,
      this.bankName,
      this.remark,
      this.terminationOfDelivery,
      this.rDURD,
      this.sGSTPer,
      this.sGSTAmt,
      this.cGSTPer,
      this.cGSTAmt,
      this.iGSTPer,
      this.iGSTAmt,
      this.taxPer,
      this.basicAmt,
      this.gSTAmt,
      this.netAmt,
      this.invoiceNo});

  MayankBankVoucherListDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    voucherType = json['VoucherType'] == null ? "" : json['VoucherType'];
    recPay = json['RecPay'] == null ? "" : json['RecPay'];
    voucherNo = json['VoucherNo'] == null ? "" : json['VoucherNo'];
    voucherDate = json['VoucherDate'] == null ? "" : json['VoucherDate'];
    accountID = json['AccountID'] == null ? 0 : json['AccountID'];
    accountName = json['AccountName'] == null ? "" : json['AccountName'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    transType = json['TransType'] == null ? "" : json['TransType'];
    transModeID = json['TransModeID'] == null ? 0 : json['TransModeID'];
    transModeName = json['TransModeName'] == null ? "" : json['TransModeName'];
    transID = json['TransID'] == null ? "" : json['TransID'];
    transDate = json['TransDate'] == null ? "" : json['TransDate'];
    tDSAccountID = json['TDSAccountID'] == null ? 0 : json['TDSAccountID'];
    tDSAccountName =
        json['TDSAccountName'] == null ? "" : json['TDSAccountName'];
    tDSAmount = json['TDSAmount'] == null ? 0.00 : json['TDSAmount'];
    voucherAmount =
        json['VoucherAmount'] == null ? 0.00 : json['VoucherAmount'];
    bankName = json['BankName'] == null ? "" : json['BankName'];
    remark = json['Remark'] == null ? "" : json['Remark'];
    terminationOfDelivery = json['TerminationOfDelivery'] == null
        ? 0
        : json['TerminationOfDelivery'];
    rDURD = json['RDURD'] == null ? "" : json['RDURD'];
    sGSTPer = json['SGSTPer'] == null ? 0.00 : json['SGSTPer'];
    sGSTAmt = json['SGSTAmt'] == null ? 0.00 : json['SGSTAmt'];
    cGSTPer = json['CGSTPer'] == null ? 0.00 : json['CGSTPer'];
    cGSTAmt = json['CGSTAmt'] == null ? 0.00 : json['CGSTAmt'];
    iGSTPer = json['IGSTPer'] == null ? 0.00 : json['IGSTPer'];
    iGSTAmt = json['IGSTAmt'] == null ? 0.00 : json['IGSTAmt'];
    taxPer = json['TaxPer'] == null ? 0.00 : json['TaxPer'];
    basicAmt = json['BasicAmt'] == null ? 0.00 : json['BasicAmt'];
    gSTAmt = json['GSTAmt'] == null ? 0.00 : json['GSTAmt'];
    netAmt = json['NetAmt'] == null ? 0.00 : json['NetAmt'];
    invoiceNo = json['InvoiceNo'] == null ? "" : json['InvoiceNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['VoucherType'] = this.voucherType;
    data['RecPay'] = this.recPay;
    data['VoucherNo'] = this.voucherNo;
    data['VoucherDate'] = this.voucherDate;
    data['AccountID'] = this.accountID;
    data['AccountName'] = this.accountName;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['TransType'] = this.transType;
    data['TransModeID'] = this.transModeID;
    data['TransModeName'] = this.transModeName;
    data['TransID'] = this.transID;
    data['TransDate'] = this.transDate;
    data['TDSAccountID'] = this.tDSAccountID;
    data['TDSAccountName'] = this.tDSAccountName;
    data['TDSAmount'] = this.tDSAmount;
    data['VoucherAmount'] = this.voucherAmount;
    data['BankName'] = this.bankName;
    data['Remark'] = this.remark;
    data['TerminationOfDelivery'] = this.terminationOfDelivery;
    data['RDURD'] = this.rDURD;
    data['SGSTPer'] = this.sGSTPer;
    data['SGSTAmt'] = this.sGSTAmt;
    data['CGSTPer'] = this.cGSTPer;
    data['CGSTAmt'] = this.cGSTAmt;
    data['IGSTPer'] = this.iGSTPer;
    data['IGSTAmt'] = this.iGSTAmt;
    data['TaxPer'] = this.taxPer;
    data['BasicAmt'] = this.basicAmt;
    data['GSTAmt'] = this.gSTAmt;
    data['NetAmt'] = this.netAmt;
    data['InvoiceNo'] = this.invoiceNo;
    return data;
  }
}
