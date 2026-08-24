class PurchaseOrderListResponse {
  List<PurchaseOrderListResponseDetails> details;
  int totalCount;

  PurchaseOrderListResponse({this.details, this.totalCount});

  PurchaseOrderListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new PurchaseOrderListResponseDetails.fromJson(v));
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

class PurchaseOrderListResponseDetails {
  int rowNum;
  int pkID;
  String orderNo;
  String orderDate;
  String quotationNo;
  String referenceDate;
  dynamic inquiryNo;
  String buyerRef;
  dynamic billNo;
  String emailHeader;
  String emailContent;
  int locationID;
  dynamic locationName;
  String patientName;
  String patientType;
  dynamic finalAmount;
  dynamic percentage;
  dynamic estimatedAmt;
  dynamic discountPer;
  String termsCondition;
  String approvalStatus;
  String deliveryNote;
  String docRefNoList;
  int customerID;
  String customerName;
  String address;
  String area;
  String pinCode;
  String city;
  String emailAddress;
  String contactNo1;
  String contactNo2;
  String invoiceNo;
  String invoiceDate;
  String lRNo;
  String lRDate;
  String ewayBillNo;
  String ewayBillDate;
  int employeeID;
  String employeeName;
  double basicAmt;
  dynamic discountAmt;
  dynamic taxAmt;
  dynamic sGSTAmt;
  dynamic cGSTAmt;
  dynamic iGSTAmt;
  double roffAmt;
  String orgCode;
  dynamic organizationName;
  dynamic chargeID1;
  dynamic chargeID2;
  dynamic chargeID3;
  dynamic chargeID4;
  dynamic chargeID5;
  String chargeName1;
  String chargeName2;
  String chargeName3;
  String chargeName4;
  String chargeName5;
  dynamic chargeAmt1;
  dynamic chargeAmt2;
  dynamic chargeAmt3;
  dynamic chargeAmt4;
  dynamic chargeAmt5;
  dynamic chargeBasicAmt1;
  dynamic chargeBasicAmt2;
  dynamic chargeBasicAmt3;
  dynamic chargeBasicAmt4;
  dynamic chargeBasicAmt5;
  dynamic chargeGSTAmt1;
  dynamic chargeGSTAmt2;
  dynamic chargeGSTAmt3;
  dynamic chargeGSTAmt4;
  dynamic chargeGSTAmt5;
  dynamic netAmt;
  dynamic advancePer;
  dynamic advanceAmt;
  String tankerNo;
  dynamic grossWeight;
  dynamic tareWeight;
  dynamic netWeight;
  String licenseNo;
  String driverDetails;
  String driverName;
  String drivingLicenseNo;
  String driverNumber;
  String conductorName;
  String modeOfPayment;
  String transporterName;
  String consigneeName;
  String consigneeAddress;
  String consigneeCity;
  String tripDistance;
  String refType;
  String refNo;
  String approvedDesignation;
  String currencyName;
  String currencySymbol;
  dynamic exchangeRate;
  String createdBy;
  String createdDate;
  dynamic updatedBy;
  String updatedDate;
  String approvedBy;
  String approvedDate;
  dynamic currencyShortName;
  String createdEmployeeName;
  String createdDesigCode;
  String createdDesignation;
  int createdID;
  int approvedID;
  String updatedEmployeeName;
  String approvedEmployeeName;
  int companyID;
  String authorizedSign;
  String employeeMobileNo;
  String employeeEmailAddress;
  String pOKindAttn;
  double orderAmount;
  dynamic projectName;
  dynamic projectArea;
  dynamic projectAddress;
  dynamic projectPincode;
  dynamic projectCity;
  dynamic projectState;
  dynamic projectCountry;
  dynamic stateCode;

  PurchaseOrderListResponseDetails({
    this.rowNum,
    this.pkID,
    this.orderNo,
    this.orderDate,
    this.quotationNo,
    this.referenceDate,
    this.inquiryNo,
    this.buyerRef,
    this.billNo,
    this.emailHeader,
    this.emailContent,
    this.locationID,
    this.locationName,
    this.patientName,
    this.patientType,
    this.finalAmount,
    this.percentage,
    this.estimatedAmt,
    this.discountPer,
    this.termsCondition,
    this.approvalStatus,
    this.deliveryNote,
    this.docRefNoList,
    this.customerID,
    this.customerName,
    this.address,
    this.area,
    this.pinCode,
    this.city,
    this.emailAddress,
    this.contactNo1,
    this.contactNo2,
    this.invoiceNo,
    this.invoiceDate,
    this.lRNo,
    this.lRDate,
    this.ewayBillNo,
    this.ewayBillDate,
    this.employeeID,
    this.employeeName,
    this.basicAmt,
    this.discountAmt,
    this.taxAmt,
    this.sGSTAmt,
    this.cGSTAmt,
    this.iGSTAmt,
    this.roffAmt,
    this.orgCode,
    this.organizationName,
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
    this.tankerNo,
    this.grossWeight,
    this.tareWeight,
    this.netWeight,
    this.licenseNo,
    this.driverDetails,
    this.driverName,
    this.drivingLicenseNo,
    this.driverNumber,
    this.conductorName,
    this.modeOfPayment,
    this.transporterName,
    this.consigneeName,
    this.consigneeAddress,
    this.consigneeCity,
    this.tripDistance,
    this.refType,
    this.refNo,
    this.approvedDesignation,
    this.currencyName,
    this.currencySymbol,
    this.exchangeRate,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.approvedBy,
    this.approvedDate,
    this.currencyShortName,
    this.createdEmployeeName,
    this.createdDesigCode,
    this.createdDesignation,
    this.createdID,
    this.approvedID,
    this.updatedEmployeeName,
    this.approvedEmployeeName,
    this.companyID,
    this.authorizedSign,
    this.employeeMobileNo,
    this.employeeEmailAddress,
    this.pOKindAttn,
    this.orderAmount,
    this.projectName,
    this.projectArea,
    this.projectAddress,
    this.projectPincode,
    this.projectCity,
    this.projectState,
    this.projectCountry,
    this.stateCode,
  });

  PurchaseOrderListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    orderNo = json['OrderNo'];
    orderDate = json['OrderDate'];
    quotationNo = json['QuotationNo'];
    referenceDate = json['ReferenceDate'];
    inquiryNo = json['InquiryNo'];
    buyerRef = json['BuyerRef'];
    billNo = json['BillNo'];
    emailHeader = json['EmailHeader'];
    emailContent = json['EmailContent'];
    locationID = json['LocationID'];
    locationName = json['LocationName'];
    patientName = json['PatientName'];
    patientType = json['PatientType'];
    finalAmount = json['FinalAmount'];
    percentage = json['Percentage'];
    estimatedAmt = json['EstimatedAmt'];
    discountPer = json['DiscountPer'];
    termsCondition = json['TermsCondition'];
    approvalStatus = json['ApprovalStatus'];
    deliveryNote = json['DeliveryNote'];
    docRefNoList = json['DocRefNoList'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    address = json['Address'];
    area = json['Area'];
    pinCode = json['PinCode'];
    city = json['City'];
    emailAddress = json['EmailAddress'];
    contactNo1 = json['ContactNo1'];
    contactNo2 = json['ContactNo2'];
    invoiceNo = json['InvoiceNo'];
    invoiceDate = json['InvoiceDate'];
    lRNo = json['LRNo'];
    lRDate = json['LRDate'];
    ewayBillNo = json['EwayBillNo'];
    ewayBillDate = json['EwayBillDate'];
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    basicAmt = json['BasicAmt'];
    discountAmt = json['DiscountAmt'];
    taxAmt = json['TaxAmt'];
    sGSTAmt = json['SGSTAmt'];
    cGSTAmt = json['CGSTAmt'];
    iGSTAmt = json['IGSTAmt'];
    roffAmt = json['RoffAmt'];
    orgCode = json['OrgCode'];
    organizationName = json['OrganizationName'];
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
    netAmt = json['NetAmt'];
    advancePer = json['AdvancePer'];
    advanceAmt = json['AdvanceAmt'];
    tankerNo = json['TankerNo'];
    grossWeight = json['Gross_Weight'];
    tareWeight = json['Tare_Weight'];
    netWeight = json['Net_Weight'];
    licenseNo = json['LicenseNo'];
    driverDetails = json['DriverDetails'];
    driverName = json['DriverName'];
    drivingLicenseNo = json['DrivingLicenseNo'];
    driverNumber = json['DriverNumber'];
    conductorName = json['ConductorName'];
    modeOfPayment = json['ModeOfPayment'];
    transporterName = json['TransporterName'];
    consigneeName = json['ConsigneeName'];
    consigneeAddress = json['ConsigneeAddress'];
    consigneeCity = json['ConsigneeCity'];
    tripDistance = json['TripDistance'];
    refType = json['RefType'];
    refNo = json['RefNo'];
    approvedDesignation = json['ApprovedDesignation'];
    currencyName = json['CurrencyName'];
    currencySymbol = json['CurrencySymbol'];
    exchangeRate = json['ExchangeRate'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    approvedBy = json['ApprovedBy'];
    approvedDate = json['ApprovedDate'];
    currencyShortName = json['CurrencyShortName'];
    createdEmployeeName = json['CreatedEmployeeName'];
    createdDesigCode = json['CreatedDesigCode'];
    createdDesignation = json['CreatedDesignation'];
    createdID = json['CreatedID'];
    approvedID = json['ApprovedID'];
    updatedEmployeeName = json['UpdatedEmployeeName'];
    approvedEmployeeName = json['ApprovedEmployeeName'];
    companyID = json['CompanyID'];
    authorizedSign = json['AuthorizedSign'];
    employeeMobileNo = json['EmployeeMobileNo'];
    employeeEmailAddress = json['EmployeeEmailAddress'];
    pOKindAttn = json['POKindAttn'];
    orderAmount = json['OrderAmount'];
    projectName = json['ProjectName'];
    projectArea = json['ProjectArea'];
    projectAddress = json['ProjectAddress'];
    projectPincode = json['ProjectPincode'];
    projectCity = json['ProjectCity'];
    projectState = json['ProjectState'];
    projectCountry = json['ProjectCountry'];
    stateCode = json['StateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['OrderNo'] = this.orderNo;
    data['OrderDate'] = this.orderDate;
    data['QuotationNo'] = this.quotationNo;
    data['ReferenceDate'] = this.referenceDate;
    data['InquiryNo'] = this.inquiryNo;
    data['BuyerRef'] = this.buyerRef;
    data['BillNo'] = this.billNo;
    data['EmailHeader'] = this.emailHeader;
    data['EmailContent'] = this.emailContent;
    data['LocationID'] = this.locationID;
    data['LocationName'] = this.locationName;
    data['PatientName'] = this.patientName;
    data['PatientType'] = this.patientType;
    data['FinalAmount'] = this.finalAmount;
    data['Percentage'] = this.percentage;
    data['EstimatedAmt'] = this.estimatedAmt;
    data['DiscountPer'] = this.discountPer;
    data['TermsCondition'] = this.termsCondition;
    data['ApprovalStatus'] = this.approvalStatus;
    data['DeliveryNote'] = this.deliveryNote;
    data['DocRefNoList'] = this.docRefNoList;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['Address'] = this.address;
    data['Area'] = this.area;
    data['PinCode'] = this.pinCode;
    data['City'] = this.city;
    data['EmailAddress'] = this.emailAddress;
    data['ContactNo1'] = this.contactNo1;
    data['ContactNo2'] = this.contactNo2;
    data['InvoiceNo'] = this.invoiceNo;
    data['InvoiceDate'] = this.invoiceDate;
    data['LRNo'] = this.lRNo;
    data['LRDate'] = this.lRDate;
    data['EwayBillNo'] = this.ewayBillNo;
    data['EwayBillDate'] = this.ewayBillDate;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['BasicAmt'] = this.basicAmt;
    data['DiscountAmt'] = this.discountAmt;
    data['TaxAmt'] = this.taxAmt;
    data['SGSTAmt'] = this.sGSTAmt;
    data['CGSTAmt'] = this.cGSTAmt;
    data['IGSTAmt'] = this.iGSTAmt;
    data['RoffAmt'] = this.roffAmt;
    data['OrgCode'] = this.orgCode;
    data['OrganizationName'] = this.organizationName;
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
    data['NetAmt'] = this.netAmt;
    data['AdvancePer'] = this.advancePer;
    data['AdvanceAmt'] = this.advanceAmt;
    data['TankerNo'] = this.tankerNo;
    data['Gross_Weight'] = this.grossWeight;
    data['Tare_Weight'] = this.tareWeight;
    data['Net_Weight'] = this.netWeight;
    data['LicenseNo'] = this.licenseNo;
    data['DriverDetails'] = this.driverDetails;
    data['DriverName'] = this.driverName;
    data['DrivingLicenseNo'] = this.drivingLicenseNo;
    data['DriverNumber'] = this.driverNumber;
    data['ConductorName'] = this.conductorName;
    data['ModeOfPayment'] = this.modeOfPayment;
    data['TransporterName'] = this.transporterName;
    data['ConsigneeName'] = this.consigneeName;
    data['ConsigneeAddress'] = this.consigneeAddress;
    data['ConsigneeCity'] = this.consigneeCity;
    data['TripDistance'] = this.tripDistance;
    data['RefType'] = this.refType;
    data['RefNo'] = this.refNo;
    data['ApprovedDesignation'] = this.approvedDesignation;
    data['CurrencyName'] = this.currencyName;
    data['CurrencySymbol'] = this.currencySymbol;
    data['ExchangeRate'] = this.exchangeRate;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['ApprovedBy'] = this.approvedBy;
    data['ApprovedDate'] = this.approvedDate;
    data['CurrencyShortName'] = this.currencyShortName;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['CreatedDesigCode'] = this.createdDesigCode;
    data['CreatedDesignation'] = this.createdDesignation;
    data['CreatedID'] = this.createdID;
    data['ApprovedID'] = this.approvedID;
    data['UpdatedEmployeeName'] = this.updatedEmployeeName;
    data['ApprovedEmployeeName'] = this.approvedEmployeeName;
    data['CompanyID'] = this.companyID;
    data['AuthorizedSign'] = this.authorizedSign;
    data['EmployeeMobileNo'] = this.employeeMobileNo;
    data['EmployeeEmailAddress'] = this.employeeEmailAddress;
    data['POKindAttn'] = this.pOKindAttn;
    data['OrderAmount'] = this.orderAmount;
    data['ProjectName'] = this.projectName;
    data['ProjectArea'] = this.projectArea;
    data['ProjectAddress'] = this.projectAddress;
    data['ProjectPincode'] = this.projectPincode;
    data['ProjectCity'] = this.projectCity;
    data['ProjectState'] = this.projectState;
    data['ProjectCountry'] = this.projectCountry;
    data['StateCode'] = this.stateCode;
    return data;
  }
}
