class PurchaseBillListResponse {
  List<PurchaseBillListResponseDetails> details;
  int totalCount;

  PurchaseBillListResponse({this.details, this.totalCount});

  PurchaseBillListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new PurchaseBillListResponseDetails.fromJson(v));
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

class PurchaseBillListResponseDetails {
  int rowNum;
  int pkID;
  String invoiceNo;
  String invoiceDate;
  int bankID;
  double basicAmt;
  double discountAmt;
  double taxAmt;
  double rOffAmt;
  double netAmt;
  String billNo;
  double sGSTAmt;
  double cGSTAmt;
  double iGSTAmt;
  int fixedLedgerID;
  String fixedLedgerName;
  int cRDays;
  String dueDate;
  String docRefNoList;
  int customerID;
  String customerName;
  String gSTNO;
  int locationID;
  String projectName;
  String bankName;
  String branchName;
  String bankAccountName;
  String bankAccountNo;
  String bankIFSC;
  String bankSWIFT;
  int chargeID1;
  int chargeID2;
  int chargeID3;
  int chargeID4;
  int chargeID5;
  double discountPer;
  String chargeName1;
  String chargeName2;
  String chargeName3;
  String chargeName4;
  String chargeName5;
  double chargeAmt1;
  double chargeAmt2;
  double chargeAmt3;
  double chargeAmt4;
  double chargeAmt5;
  int terminationOfDeliery;
  String termsCondition;
  double chargeBasicAmt1;
  double chargeBasicAmt2;
  double chargeBasicAmt3;
  double chargeBasicAmt4;
  double chargeBasicAmt5;
  double chargeGSTAmt1;
  double chargeGSTAmt2;
  double chargeGSTAmt3;
  double chargeGSTAmt4;
  double chargeGSTAmt5;
  String modeOfTransport;
  String transporterName;
  String vehicleNo;
  String lRNo;
  String lRDate;
  String transportRemark;
  String currencyName;
  String currencySymbol;
  double exchangeRate;
  String currencyShortName;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String createdEmployeeName;
  String updatedEmployeeName;
  int companyID;
  String forCoustmerID;
  double billAmount;
  int stateCode;

  PurchaseBillListResponseDetails({
    this.rowNum,
    this.pkID,
    this.invoiceNo,
    this.invoiceDate,
    this.bankID,
    this.basicAmt,
    this.discountAmt,
    this.taxAmt,
    this.rOffAmt,
    this.netAmt,
    this.billNo,
    this.sGSTAmt,
    this.cGSTAmt,
    this.iGSTAmt,
    this.fixedLedgerID,
    this.fixedLedgerName,
    this.cRDays,
    this.dueDate,
    this.docRefNoList,
    this.customerID,
    this.customerName,
    this.gSTNO,
    this.locationID,
    this.projectName,
    this.bankName,
    this.branchName,
    this.bankAccountName,
    this.bankAccountNo,
    this.bankIFSC,
    this.bankSWIFT,
    this.chargeID1,
    this.chargeID2,
    this.chargeID3,
    this.chargeID4,
    this.chargeID5,
    this.discountPer,
    this.chargeName1,
    this.chargeName2,
    this.chargeName3,
    this.chargeName4,
    this.chargeName5,
    this.chargeAmt1,
    this.chargeAmt2,
    this.chargeAmt3,
    this.chargeAmt4,
    this.chargeAmt5,
    this.terminationOfDeliery,
    this.termsCondition,
    this.chargeBasicAmt1,
    this.chargeBasicAmt2,
    this.chargeBasicAmt3,
    this.chargeBasicAmt4,
    this.chargeBasicAmt5,
    this.chargeGSTAmt1,
    this.chargeGSTAmt2,
    this.chargeGSTAmt3,
    this.chargeGSTAmt4,
    this.chargeGSTAmt5,
    this.modeOfTransport,
    this.transporterName,
    this.vehicleNo,
    this.lRNo,
    this.lRDate,
    this.transportRemark,
    this.currencyName,
    this.currencySymbol,
    this.exchangeRate,
    this.currencyShortName,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.createdEmployeeName,
    this.updatedEmployeeName,
    this.companyID,
    this.forCoustmerID,
    this.billAmount,
    this.stateCode,
  });

  PurchaseBillListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    invoiceNo = json['InvoiceNo'];
    invoiceDate = json['InvoiceDate'];
    bankID = json['BankID'];
    basicAmt = json['BasicAmt'];
    discountAmt = json['DiscountAmt'];
    taxAmt = json['TaxAmt'];
    rOffAmt = json['ROffAmt'];
    netAmt = json['NetAmt'];
    billNo = json['BillNo'];
    sGSTAmt = json['SGSTAmt'];
    cGSTAmt = json['CGSTAmt'];
    iGSTAmt = json['IGSTAmt'];
    fixedLedgerID = json['FixedLedgerID'];
    fixedLedgerName = json['FixedLedgerName'];
    cRDays = json['CRDays'];
    dueDate = json['DueDate'];
    docRefNoList = json['DocRefNoList'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    gSTNO = json['GSTNO'];
    locationID = json['LocationID'];
    projectName = json['ProjectName'];
    bankName = json['BankName'];
    branchName = json['BranchName'];
    bankAccountName = json['BankAccountName'];
    bankAccountNo = json['BankAccountNo'];
    bankIFSC = json['BankIFSC'];
    bankSWIFT = json['BankSWIFT'];
    chargeID1 = json['ChargeID1'];
    chargeID2 = json['ChargeID2'];
    chargeID3 = json['ChargeID3'];
    chargeID4 = json['ChargeID4'];
    chargeID5 = json['ChargeID5'];
    discountPer = json['DiscountPer'];
    chargeName1 = json['ChargeName1'];
    chargeName2 = json['ChargeName2'];
    chargeName3 = json['ChargeName3'];
    chargeName4 = json['ChargeName4'];
    chargeName5 = json['ChargeName5'];
    chargeAmt1 = json['ChargeAmt1'];
    chargeAmt2 = json['ChargeAmt2'];
    chargeAmt3 = json['ChargeAmt3'];
    chargeAmt4 = json['ChargeAmt4'];
    chargeAmt5 = json['ChargeAmt5'];
    terminationOfDeliery = json['TerminationOfDeliery'];
    termsCondition = json['TermsCondition'];
    chargeBasicAmt1 = json['ChargeBasicAmt1'];
    chargeBasicAmt2 = json['ChargeBasicAmt2'];
    chargeBasicAmt3 = json['ChargeBasicAmt3'];
    chargeBasicAmt4 = json['ChargeBasicAmt4'];
    chargeBasicAmt5 = json['ChargeBasicAmt5'];
    chargeGSTAmt1 = json['ChargeGSTAmt1'];
    chargeGSTAmt2 = json['ChargeGSTAmt2'];
    chargeGSTAmt3 = json['ChargeGSTAmt3'];
    chargeGSTAmt4 = json['ChargeGSTAmt4'];
    chargeGSTAmt5 = json['ChargeGSTAmt5'];
    modeOfTransport = json['ModeOfTransport'];
    transporterName = json['TransporterName'];
    vehicleNo = json['VehicleNo'];
    lRNo = json['LRNo'];
    lRDate = json['LRDate'];
    transportRemark = json['TransportRemark'];
    currencyName = json['CurrencyName'];
    currencySymbol = json['CurrencySymbol'];
    exchangeRate = json['ExchangeRate'];
    currencyShortName = json['CurrencyShortName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    createdEmployeeName = json['CreatedEmployeeName'];
    updatedEmployeeName = json['UpdatedEmployeeName'];
    companyID = json['CompanyID'];
    forCoustmerID = json['ForCoustmerID'];
    billAmount = json['BillAmount'];
    stateCode = json['StateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.invoiceNo;
    data['InvoiceDate'] = this.invoiceDate;
    data['BankID'] = this.bankID;
    data['BasicAmt'] = this.basicAmt;
    data['DiscountAmt'] = this.discountAmt;
    data['TaxAmt'] = this.taxAmt;
    data['ROffAmt'] = this.rOffAmt;
    data['NetAmt'] = this.netAmt;
    data['BillNo'] = this.billNo;
    data['SGSTAmt'] = this.sGSTAmt;
    data['CGSTAmt'] = this.cGSTAmt;
    data['IGSTAmt'] = this.iGSTAmt;
    data['FixedLedgerID'] = this.fixedLedgerID;
    data['FixedLedgerName'] = this.fixedLedgerName;
    data['CRDays'] = this.cRDays;
    data['DueDate'] = this.dueDate;
    data['DocRefNoList'] = this.docRefNoList;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['GSTNO'] = this.gSTNO;
    data['LocationID'] = this.locationID;
    data['ProjectName'] = this.projectName;
    data['BankName'] = this.bankName;
    data['BranchName'] = this.branchName;
    data['BankAccountName'] = this.bankAccountName;
    data['BankAccountNo'] = this.bankAccountNo;
    data['BankIFSC'] = this.bankIFSC;
    data['BankSWIFT'] = this.bankSWIFT;
    data['ChargeID1'] = this.chargeID1;
    data['ChargeID2'] = this.chargeID2;
    data['ChargeID3'] = this.chargeID3;
    data['ChargeID4'] = this.chargeID4;
    data['ChargeID5'] = this.chargeID5;
    data['DiscountPer'] = this.discountPer;
    data['ChargeName1'] = this.chargeName1;
    data['ChargeName2'] = this.chargeName2;
    data['ChargeName3'] = this.chargeName3;
    data['ChargeName4'] = this.chargeName4;
    data['ChargeName5'] = this.chargeName5;
    data['ChargeAmt1'] = this.chargeAmt1;
    data['ChargeAmt2'] = this.chargeAmt2;
    data['ChargeAmt3'] = this.chargeAmt3;
    data['ChargeAmt4'] = this.chargeAmt4;
    data['ChargeAmt5'] = this.chargeAmt5;
    data['TerminationOfDeliery'] = this.terminationOfDeliery;
    data['TermsCondition'] = this.termsCondition;
    data['ChargeBasicAmt1'] = this.chargeBasicAmt1;
    data['ChargeBasicAmt2'] = this.chargeBasicAmt2;
    data['ChargeBasicAmt3'] = this.chargeBasicAmt3;
    data['ChargeBasicAmt4'] = this.chargeBasicAmt4;
    data['ChargeBasicAmt5'] = this.chargeBasicAmt5;
    data['ChargeGSTAmt1'] = this.chargeGSTAmt1;
    data['ChargeGSTAmt2'] = this.chargeGSTAmt2;
    data['ChargeGSTAmt3'] = this.chargeGSTAmt3;
    data['ChargeGSTAmt4'] = this.chargeGSTAmt4;
    data['ChargeGSTAmt5'] = this.chargeGSTAmt5;
    data['ModeOfTransport'] = this.modeOfTransport;
    data['TransporterName'] = this.transporterName;
    data['VehicleNo'] = this.vehicleNo;
    data['LRNo'] = this.lRNo;
    data['LRDate'] = this.lRDate;
    data['TransportRemark'] = this.transportRemark;
    data['CurrencyName'] = this.currencyName;
    data['CurrencySymbol'] = this.currencySymbol;
    data['ExchangeRate'] = this.exchangeRate;
    data['CurrencyShortName'] = this.currencyShortName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['UpdatedEmployeeName'] = this.updatedEmployeeName;
    data['CompanyID'] = this.companyID;
    data['ForCoustmerID'] = this.forCoustmerID;
    data['BillAmount'] = this.billAmount;
    data['StateCode'] = this.stateCode;
    return data;
  }
}
