class SalesOrderApprovalListResponse {
  List<SalesOrderApprovalListResponseDetails> details;
  int totalCount;

  SalesOrderApprovalListResponse({this.details, this.totalCount});

  SalesOrderApprovalListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SalesOrderApprovalListResponseDetails.fromJson(v));
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

class SalesOrderApprovalListResponseDetails {
  // int rowNum;
  int pkID;
  String orderNo;
  String orderDate;
  // String quotationNo;
  // String inquiryNo;
  // String billNo;
  // String referenceNo;
  // String referenceDate;
  // String patientName;
  // String patientType;
  // double finalAmount;
  // double percentage;
  // double estimatedAmt;
  // String termsCondition;
  // String deliveryTerms;
  // String paymentTerms;
  String approvalStatus;
  int customerID;
  String customerName;
  //String address;
  //String area;
  //String pinCode;
  //String city;
  //String emailAddress;
  //String contactNo1;
  //String contactNo2;
  //int employeeID;
  //String employeeName;
  //double basicAmt;
  //double discountAmt;
  //double taxAmt;
  //double sGSTAmt;
  //double cGSTAmt;
  //double iGSTAmt;
  //double roffAmt;
  //int chargeID1;
  //int chargeID2;
  //int chargeID3;
  //int chargeID4;
  //int chargeID5;
  //String chargeName1;
  //String chargeName2;
  //String chargeName3;
  //String chargeName4;
  //String chargeName5;
  //double chargeAmt1;
  //double chargeAmt2;
  //double chargeAmt3;
  //double chargeAmt4;
  //double chargeAmt5;
  //double chargeBasicAmt1;
  //double chargeBasicAmt2;
  //double chargeBasicAmt3;
  //double chargeBasicAmt4;
  //double chargeBasicAmt5;
  //double chargeGSTAmt1;
  //double chargeGSTAmt2;
  //double chargeGSTAmt3;
  //double chargeGSTAmt4;
  //double chargeGSTAmt5;
  //double netAmt;
  //double advancePer;
  //double advanceAmt;
  //String currencyName;
  //String currencySymbol;
  //double exchangeRate;
  //String createdBy;
  //String createdDate;
  //String updatedBy;
  //String updatedDate;
  //String approvedBy;
  //String approvedDate;
  String createdEmployeeName;
  //String updatedEmployeeName;
  //int companyID;
  //double orderAmount;

  SalesOrderApprovalListResponseDetails(
      {/*this.rowNum,*/
      this.pkID,
      this.orderNo,
      this.orderDate,
      /* this.quotationNo,
        this.inquiryNo,
        this.billNo,
        this.referenceNo,
        this.referenceDate,
        this.patientName,
        this.patientType,
        this.finalAmount,
        this.percentage,
        this.estimatedAmt,
        this.termsCondition,
        this.deliveryTerms,
        this.paymentTerms,*/
      this.approvalStatus,
      this.customerID,
      this.customerName,
      /*this.address,
        this.area,
        this.pinCode,
        this.city,
        this.emailAddress,
        this.contactNo1,
        this.contactNo2,
        this.employeeID,
        this.employeeName,
        this.basicAmt,
        this.discountAmt,
        this.taxAmt,
        this.sGSTAmt,
        this.cGSTAmt,
        this.iGSTAmt,
        this.roffAmt,
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
        this.netAmt,
        this.advancePer,
        this.advanceAmt,
        this.currencyName,
        this.currencySymbol,
        this.exchangeRate,
        this.createdBy,
        this.createdDate,
        this.updatedBy,
        this.updatedDate,
        this.approvedBy,
        this.approvedDate,
        this.createdEmployeeName,
        this.updatedEmployeeName,
        this.companyID,
        this.orderAmount*/
      this.createdEmployeeName});

  SalesOrderApprovalListResponseDetails.fromJson(Map<String, dynamic> json) {
    //rowNum = json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    orderNo = json['OrderNo'] == null ? "" : json['OrderNo'];
    orderDate = json['OrderDate'] == null ? "" : json['OrderDate'];
    // quotationNo = json['QuotationNo']==null?"":json['QuotationNo'];
    // inquiryNo = json['InquiryNo'];
    // billNo = json['BillNo'];
    // referenceNo = json['ReferenceNo'];
    // referenceDate = json['ReferenceDate'];
    // patientName = json['PatientName'];
    // patientType = json['PatientType'];
    // finalAmount = json['FinalAmount'];
    // percentage = json['Percentage'];
    // estimatedAmt = json['EstimatedAmt'];
    // termsCondition = json['TermsCondition'];
    // deliveryTerms = json['DeliveryTerms'];
    // paymentTerms = json['PaymentTerms'];
    approvalStatus =
        json['ApprovalStatus'] == null || json['ApprovalStatus'] == ""
            ? "Pending"
            : json['ApprovalStatus'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    //  address = json['Address'];
    //  area = json['Area'];
    //  pinCode = json['PinCode'];
    //  city = json['City'];
    //  emailAddress = json['EmailAddress'];
    //  contactNo1 = json['ContactNo1'];
    //  contactNo2 = json['ContactNo2'];
    //  employeeID = json['EmployeeID'];
    //  employeeName = json['EmployeeName'];
    //  basicAmt = json['BasicAmt'];
    //  discountAmt = json['DiscountAmt'];
    //  taxAmt = json['TaxAmt'];
    //  sGSTAmt = json['SGSTAmt'];
    //  cGSTAmt = json['CGSTAmt'];
    //  iGSTAmt = json['IGSTAmt'];
    //  roffAmt = json['RoffAmt'];
    //  chargeID1 = json['ChargeID1'];
    //  chargeID2 = json['ChargeID2'];
    //  chargeID3 = json['ChargeID3'];
    //  chargeID4 = json['ChargeID4'];
    //  chargeID5 = json['ChargeID5'];
    //  chargeName1 = json['ChargeName1'];
    //  chargeName2 = json['ChargeName2'];
    //  chargeName3 = json['ChargeName3'];
    //  chargeName4 = json['ChargeName4'];
    //  chargeName5 = json['ChargeName5'];
    //  chargeAmt1 = json['ChargeAmt1'];
    //  chargeAmt2 = json['ChargeAmt2'];
    //  chargeAmt3 = json['ChargeAmt3'];
    //  chargeAmt4 = json['ChargeAmt4'];
    //  chargeAmt5 = json['ChargeAmt5'];
    //  chargeBasicAmt1 = json['ChargeBasicAmt1'];
    //  chargeBasicAmt2 = json['ChargeBasicAmt2'];
    //  chargeBasicAmt3 = json['ChargeBasicAmt3'];
    //  chargeBasicAmt4 = json['ChargeBasicAmt4'];
    //  chargeBasicAmt5 = json['ChargeBasicAmt5'];
    //  chargeGSTAmt1 = json['ChargeGSTAmt1'];
    //  chargeGSTAmt2 = json['ChargeGSTAmt2'];
    //  chargeGSTAmt3 = json['ChargeGSTAmt3'];
    //  chargeGSTAmt4 = json['ChargeGSTAmt4'];
    //  chargeGSTAmt5 = json['ChargeGSTAmt5'];
    //  netAmt = json['NetAmt'];
    //  advancePer = json['AdvancePer'];
    //  advanceAmt = json['AdvanceAmt'];
    //  currencyName = json['CurrencyName'];
    //  currencySymbol = json['CurrencySymbol'];
    //  exchangeRate = json['ExchangeRate'];
    //  createdBy = json['CreatedBy'];
    //  createdDate = json['CreatedDate'];
    //  updatedBy = json['UpdatedBy'];
    //  updatedDate = json['UpdatedDate'];
    //  approvedBy = json['ApprovedBy'];
    //  approvedDate = json['ApprovedDate'];
    createdEmployeeName = json['CreatedEmployeeName'];
    //  updatedEmployeeName = json['UpdatedEmployeeName'];
    //  companyID = json['CompanyID'];
    //  orderAmount = json['OrderAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['OrderNo'] = this.orderNo;
    data['OrderDate'] = this.orderDate;
    // data['QuotationNo'] = this.quotationNo;
    // data['InquiryNo'] = this.inquiryNo;
    // data['BillNo'] = this.billNo;
    // data['ReferenceNo'] = this.referenceNo;
    // data['ReferenceDate'] = this.referenceDate;
    // data['PatientName'] = this.patientName;
    // data['PatientType'] = this.patientType;
    // data['FinalAmount'] = this.finalAmount;
    // data['Percentage'] = this.percentage;
    // data['EstimatedAmt'] = this.estimatedAmt;
    // data['TermsCondition'] = this.termsCondition;
    // data['DeliveryTerms'] = this.deliveryTerms;
    // data['PaymentTerms'] = this.paymentTerms;
    data['ApprovalStatus'] = this.approvalStatus;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    //  data['Address'] = this.address;
    //  data['Area'] = this.area;
    //  data['PinCode'] = this.pinCode;
    //  data['City'] = this.city;
    //  data['EmailAddress'] = this.emailAddress;
    //  data['ContactNo1'] = this.contactNo1;
    //  data['ContactNo2'] = this.contactNo2;
    //  data['EmployeeID'] = this.employeeID;
    //  data['EmployeeName'] = this.employeeName;
    //  data['BasicAmt'] = this.basicAmt;
    //  data['DiscountAmt'] = this.discountAmt;
    //  data['TaxAmt'] = this.taxAmt;
    //  data['SGSTAmt'] = this.sGSTAmt;
    //  data['CGSTAmt'] = this.cGSTAmt;
    //  data['IGSTAmt'] = this.iGSTAmt;
    //  data['RoffAmt'] = this.roffAmt;
    //  data['ChargeID1'] = this.chargeID1;
    //  data['ChargeID2'] = this.chargeID2;
    //  data['ChargeID3'] = this.chargeID3;
    //  data['ChargeID4'] = this.chargeID4;
    //  data['ChargeID5'] = this.chargeID5;
    //  data['ChargeName1'] = this.chargeName1;
    //  data['ChargeName2'] = this.chargeName2;
    //  data['ChargeName3'] = this.chargeName3;
    //  data['ChargeName4'] = this.chargeName4;
    //  data['ChargeName5'] = this.chargeName5;
    //  data['ChargeAmt1'] = this.chargeAmt1;
    //  data['ChargeAmt2'] = this.chargeAmt2;
    //  data['ChargeAmt3'] = this.chargeAmt3;
    //  data['ChargeAmt4'] = this.chargeAmt4;
    //  data['ChargeAmt5'] = this.chargeAmt5;
    //  data['ChargeBasicAmt1'] = this.chargeBasicAmt1;
    //  data['ChargeBasicAmt2'] = this.chargeBasicAmt2;
    //  data['ChargeBasicAmt3'] = this.chargeBasicAmt3;
    //  data['ChargeBasicAmt4'] = this.chargeBasicAmt4;
    //  data['ChargeBasicAmt5'] = this.chargeBasicAmt5;
    //  data['ChargeGSTAmt1'] = this.chargeGSTAmt1;
    //  data['ChargeGSTAmt2'] = this.chargeGSTAmt2;
    //  data['ChargeGSTAmt3'] = this.chargeGSTAmt3;
    //  data['ChargeGSTAmt4'] = this.chargeGSTAmt4;
    //  data['ChargeGSTAmt5'] = this.chargeGSTAmt5;
    //  data['NetAmt'] = this.netAmt;
    //  data['AdvancePer'] = this.advancePer;
    //  data['AdvanceAmt'] = this.advanceAmt;
    //  data['CurrencyName'] = this.currencyName;
    //  data['CurrencySymbol'] = this.currencySymbol;
    //  data['ExchangeRate'] = this.exchangeRate;
    //  data['CreatedBy'] = this.createdBy;
    //  data['CreatedDate'] = this.createdDate;
    //  data['UpdatedBy'] = this.updatedBy;
    //  data['UpdatedDate'] = this.updatedDate;
    //  data['ApprovedBy'] = this.approvedBy;
    //  data['ApprovedDate'] = this.approvedDate;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    //  data['UpdatedEmployeeName'] = this.updatedEmployeeName;
    //  data['CompanyID'] = this.companyID;
    //  data['OrderAmount'] = this.orderAmount;
    return data;
  }
}
