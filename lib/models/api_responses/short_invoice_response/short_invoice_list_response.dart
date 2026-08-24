class ShortInvoiceListResponse {
  List<ShortInvoiceListResponseDetails> details;
  int totalCount;

  ShortInvoiceListResponse({this.details, this.totalCount});

  ShortInvoiceListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ShortInvoiceListResponseDetails.fromJson(v));
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

class ShortInvoiceListResponseDetails {
  int rowNum;
  int pkID;
  String invoiceNo;
  String invoiceDate;
  double basicAmt;
  double discountAmt;
  double taxAmt;
  double rOffAmt;
  double netAmt;
  double cGSTAmt;
  double sGSTAmt;
  double iGSTAmt;
  int cRDays;
  String dueDate;
  String inquiryNo;
  String orderNo;
  String orderDate;
  String quotationNo;
  String complaintNo;
  String refType;
  dynamic sOpkID;
  String projectName;
  String marksNo;
  String referenceNo;
  String refNo;
  String supplierRef;
  String supplierRefDate;
  String otherRef;
  bool eWayFlag;
  String patientName;
  String patientType;
  double amount;
  double percentage;
  double estimatedAmt;
  String emailContent;
  String emailSubject;
  double discountPer;
  int fixedLedgerID;
  String fixedLedgerName;
  String docRefNoListDate;
  String docRefNoList;
  int customerID;
  String customerName;
  String gSTNO;
  int bankID;
  int locationID;
  String locationName;
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
  String terminationOfDelieryName;
  int terminationOfDelieryCity;
  String terminationOfDelieryCityName;
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
  String deliveryNote;
  String deliveryDate;
  String lRNo;
  String dispatchDocNo;
  String lRDate;
  String ewayBillNo;
  String modeOfPayment;
  String transportRemark;
  String commRemark;
  String deliverTo;
  String address;
  String area;
  String pinCode;
  String city;
  String emailAddress;
  String state;
  String currencyName;
  String currencySymbol;
  double exchangeRate;
  String termsCondition;
  String currencyShortName;
  String challanDate;
  String challanNo;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String projectArea;
  String projectAddress;
  String projectPincode;
  String projectCity;
  String projectState;
  String projectCountry;
  int createdID;
  String createdEmployeeName;
  String createdEmployeeMobile;
  String updatedEmployeeName;
  int companyID;
  double billAmount;
  String extraRemark;
  String prodDescription;
  int stateCode;

  ShortInvoiceListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.invoiceNo,
      this.invoiceDate,
      this.basicAmt,
      this.discountAmt,
      this.taxAmt,
      this.rOffAmt,
      this.netAmt,
      this.cGSTAmt,
      this.sGSTAmt,
      this.iGSTAmt,
      this.cRDays,
      this.dueDate,
      this.inquiryNo,
      this.orderNo,
      this.orderDate,
      this.quotationNo,
      this.complaintNo,
      this.refType,
      this.sOpkID,
      this.projectName,
      this.marksNo,
      this.referenceNo,
      this.refNo,
      this.supplierRef,
      this.supplierRefDate,
      this.otherRef,
      this.eWayFlag,
      this.patientName,
      this.patientType,
      this.amount,
      this.percentage,
      this.estimatedAmt,
      this.emailContent,
      this.emailSubject,
      this.discountPer,
      this.fixedLedgerID,
      this.fixedLedgerName,
      this.docRefNoListDate,
      this.docRefNoList,
      this.customerID,
      this.customerName,
      this.gSTNO,
      this.bankID,
      this.locationID,
      this.locationName,
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
      this.terminationOfDelieryName,
      this.terminationOfDelieryCity,
      this.terminationOfDelieryCityName,
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
      this.deliveryNote,
      this.deliveryDate,
      this.lRNo,
      this.dispatchDocNo,
      this.lRDate,
      this.ewayBillNo,
      this.modeOfPayment,
      this.transportRemark,
      this.commRemark,
      this.deliverTo,
      this.address,
      this.area,
      this.pinCode,
      this.city,
      this.emailAddress,
      this.state,
      this.currencyName,
      this.currencySymbol,
      this.exchangeRate,
      this.termsCondition,
      this.currencyShortName,
      this.challanDate,
      this.challanNo,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.projectArea,
      this.projectAddress,
      this.projectPincode,
      this.projectCity,
      this.projectState,
      this.projectCountry,
      this.createdID,
      this.createdEmployeeName,
      this.createdEmployeeMobile,
      this.updatedEmployeeName,
      this.companyID,
      this.billAmount,
      this.extraRemark,
      this.prodDescription,
      this.stateCode,
      });

  ShortInvoiceListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    invoiceNo = json['InvoiceNo'];
    invoiceDate = json['InvoiceDate'];
    basicAmt = json['BasicAmt'];
    discountAmt = json['DiscountAmt'];
    taxAmt = json['TaxAmt'];
    rOffAmt = json['ROffAmt'];
    netAmt = json['NetAmt'];
    cGSTAmt = json['CGSTAmt'];
    sGSTAmt = json['SGSTAmt'];
    iGSTAmt = json['IGSTAmt'];
    cRDays = json['CRDays'];
    dueDate = json['DueDate'];
    inquiryNo = json['InquiryNo'];
    orderNo = json['OrderNo'];
    orderDate = json['OrderDate'];
    quotationNo = json['QuotationNo'];
    complaintNo = json['ComplaintNo'];
    refType = json['RefType'];
    sOpkID = json['SOpkID'];
    projectName = json['ProjectName'];
    marksNo = json['MarksNo'];
    referenceNo = json['ReferenceNo'];
    refNo = json['RefNo'];
    supplierRef = json['SupplierRef'];
    supplierRefDate = json['SupplierRefDate'];
    otherRef = json['OtherRef'];
    eWayFlag = json['EWayFlag'];
    patientName = json['PatientName'];
    patientType = json['PatientType'];
    amount = json['Amount'];
    percentage = json['Percentage'];
    estimatedAmt = json['EstimatedAmt'];
    emailContent = json['EmailContent'];
    emailSubject = json['EmailSubject'];
    discountPer = json['DiscountPer'];
    fixedLedgerID = json['FixedLedgerID'];
    fixedLedgerName = json['FixedLedgerName'];
    docRefNoListDate = json['DocRefNoListDate'];
    docRefNoList = json['DocRefNoList'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    gSTNO = json['GSTNO'];
    bankID = json['BankID'];
    locationID = json['LocationID'];
    locationName = json['LocationName'];
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
    terminationOfDelieryName = json['TerminationOfDelieryName'];
    terminationOfDelieryCity = json['TerminationOfDelieryCity'];
    terminationOfDelieryCityName = json['TerminationOfDelieryCityName'];
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
    deliveryNote = json['DeliveryNote'];
    deliveryDate = json['DeliveryDate'];
    lRNo = json['LRNo'];
    dispatchDocNo = json['DispatchDocNo'];
    lRDate = json['LRDate'];
    ewayBillNo = json['EwayBillNo'];
    modeOfPayment = json['ModeOfPayment'];
    transportRemark = json['TransportRemark'];
    commRemark = json['CommRemark'];
    deliverTo = json['DeliverTo'];
    address = json['Address'];
    area = json['Area'];
    pinCode = json['PinCode'];
    city = json['City'];
    emailAddress = json['EmailAddress'];
    state = json['State'];
    currencyName = json['CurrencyName'];
    currencySymbol = json['CurrencySymbol'];
    exchangeRate = json['ExchangeRate'];
    termsCondition = json['TermsCondition'];
    currencyShortName = json['CurrencyShortName'];
    challanDate = json['ChallanDate'];
    challanNo = json['ChallanNo'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    projectArea = json['ProjectArea'];
    projectAddress = json['ProjectAddress'];
    projectPincode = json['ProjectPincode'];
    projectCity = json['ProjectCity'];
    projectState = json['ProjectState'];
    projectCountry = json['ProjectCountry'];
    createdID = json['CreatedID'];
    createdEmployeeName = json['CreatedEmployeeName'];
    createdEmployeeMobile = json['CreatedEmployeeMobile'];
    updatedEmployeeName = json['UpdatedEmployeeName'];
    companyID = json['CompanyID'];
    billAmount = json['BillAmount'];
    extraRemark = json['ExtraRemark'];
    prodDescription = json['ProdDescription'];
    stateCode = json['StateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.invoiceNo;
    data['InvoiceDate'] = this.invoiceDate;
    data['BasicAmt'] = this.basicAmt;
    data['DiscountAmt'] = this.discountAmt;
    data['TaxAmt'] = this.taxAmt;
    data['ROffAmt'] = this.rOffAmt;
    data['NetAmt'] = this.netAmt;
    data['CGSTAmt'] = this.cGSTAmt;
    data['SGSTAmt'] = this.sGSTAmt;
    data['IGSTAmt'] = this.iGSTAmt;
    data['CRDays'] = this.cRDays;
    data['DueDate'] = this.dueDate;
    data['InquiryNo'] = this.inquiryNo;
    data['OrderNo'] = this.orderNo;
    data['OrderDate'] = this.orderDate;
    data['QuotationNo'] = this.quotationNo;
    data['ComplaintNo'] = this.complaintNo;
    data['RefType'] = this.refType;
    data['SOpkID'] = this.sOpkID;
    data['ProjectName'] = this.projectName;
    data['MarksNo'] = this.marksNo;
    data['ReferenceNo'] = this.referenceNo;
    data['RefNo'] = this.refNo;
    data['SupplierRef'] = this.supplierRef;
    data['SupplierRefDate'] = this.supplierRefDate;
    data['OtherRef'] = this.otherRef;
    data['EWayFlag'] = this.eWayFlag;
    data['PatientName'] = this.patientName;
    data['PatientType'] = this.patientType;
    data['Amount'] = this.amount;
    data['Percentage'] = this.percentage;
    data['EstimatedAmt'] = this.estimatedAmt;
    data['EmailContent'] = this.emailContent;
    data['EmailSubject'] = this.emailSubject;
    data['DiscountPer'] = this.discountPer;
    data['FixedLedgerID'] = this.fixedLedgerID;
    data['FixedLedgerName'] = this.fixedLedgerName;
    data['DocRefNoListDate'] = this.docRefNoListDate;
    data['DocRefNoList'] = this.docRefNoList;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['GSTNO'] = this.gSTNO;
    data['BankID'] = this.bankID;
    data['LocationID'] = this.locationID;
    data['LocationName'] = this.locationName;
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
    data['TerminationOfDelieryName'] = this.terminationOfDelieryName;
    data['TerminationOfDelieryCity'] = this.terminationOfDelieryCity;
    data['TerminationOfDelieryCityName'] = this.terminationOfDelieryCityName;
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
    data['DeliveryNote'] = this.deliveryNote;
    data['DeliveryDate'] = this.deliveryDate;
    data['LRNo'] = this.lRNo;
    data['DispatchDocNo'] = this.dispatchDocNo;
    data['LRDate'] = this.lRDate;
    data['EwayBillNo'] = this.ewayBillNo;
    data['ModeOfPayment'] = this.modeOfPayment;
    data['TransportRemark'] = this.transportRemark;
    data['CommRemark'] = this.commRemark;
    data['DeliverTo'] = this.deliverTo;
    data['Address'] = this.address;
    data['Area'] = this.area;
    data['PinCode'] = this.pinCode;
    data['City'] = this.city;
    data['EmailAddress'] = this.emailAddress;
    data['State'] = this.state;
    data['CurrencyName'] = this.currencyName;
    data['CurrencySymbol'] = this.currencySymbol;
    data['ExchangeRate'] = this.exchangeRate;
    data['TermsCondition'] = this.termsCondition;
    data['CurrencyShortName'] = this.currencyShortName;
    data['ChallanDate'] = this.challanDate;
    data['ChallanNo'] = this.challanNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['ProjectArea'] = this.projectArea;
    data['ProjectAddress'] = this.projectAddress;
    data['ProjectPincode'] = this.projectPincode;
    data['ProjectCity'] = this.projectCity;
    data['ProjectState'] = this.projectState;
    data['ProjectCountry'] = this.projectCountry;
    data['CreatedID'] = this.createdID;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['CreatedEmployeeMobile'] = this.createdEmployeeMobile;
    data['UpdatedEmployeeName'] = this.updatedEmployeeName;
    data['CompanyID'] = this.companyID;
    data['BillAmount'] = this.billAmount;
    data['ExtraRemark'] = this.extraRemark;
    data['ProdDescription'] = this.prodDescription;
    data['StateCode'] = this.stateCode;
    return data;
  }
}
