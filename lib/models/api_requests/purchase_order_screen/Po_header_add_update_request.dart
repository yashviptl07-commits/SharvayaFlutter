class PurchaseOrderAddUpdateRequest {
  int pkID;
  String OrderNo;
  String OrderDate;
  String CustomerID;
  String QuotationNo;
  String ReferenceDate;
  String InquiryNo;
  String BuyerRef;
  String BillNo;
  String TermsCondition;
  String EmployeeID;
  String ApprovalStatus;
  String EmailHeader;
  String EmailContent;
  String ProjectName;
  String PatientName;
  String PatientType;
  String FinalAmount;
  String Percentage;
  String EstimatedAmt;
  String BasicAmt;
  String DiscountPer;
  String DiscountAmt;
  String SGSTAmt;
  String CGSTAmt;
  String IGSTAmt;
  String ROffAmt;
  String TankerNo;
  String Gross_Weight;
  String Tare_Weight;
  String Net_Weight;
  String LicenseNo;
  String DriverDetails;
  String DriverName;
  String DrivingLicenseNo;
  String DriverNumber;
  String ConductorName;
  String ModeOfPayment;
  String TransporterName;
  String ConsigneeName;
  String ConsigneeAddress;
  String ConsigneeCity;
  String TripDistance;
  String DeliveryNote;
  String ChargeID1;
  String ChargeAmt1;
  String ChargeBasicAmt1;
  String ChargeGSTAmt1;
  String ChargeID2;
  String ChargeAmt2;
  String ChargeBasicAmt2;
  String ChargeGSTAmt2;
  String ChargeID3;
  String ChargeAmt3;
  String ChargeBasicAmt3;
  String ChargeGSTAmt3;
  String ChargeID4;
  String ChargeAmt4;
  String ChargeBasicAmt4;
  String ChargeGSTAmt4;
  String ChargeID5;
  String ChargeAmt5;
  String ChargeBasicAmt5;
  String ChargeGSTAmt5;
  String ChargePer1;
  String ChargePer2;
  String ChargePer3;
  String ChargePer4;
  String ChargePer5;
  String NetAmt;
  String AdvancePer;
  String AdvanceAmt;
  String CurrencyName;
  String CurrencySymbol;
  String ExchangeRate;
  String InvoiceNo;
  String InvoiceDate;
  String LRNo;
  String LRDate;
  String EwayBillNo;
  String EwayBillDate;
  String POKindAttn;
  String OrgCode;
  String LoginUserID;
  String RefType;
  String CompanyId;

  PurchaseOrderAddUpdateRequest({
    this.pkID,
    this.OrderNo,
    this.OrderDate,
    this.CustomerID,
    this.QuotationNo,
    this.ReferenceDate,
    this.InquiryNo,
    this.BuyerRef,
    this.BillNo,
    this.TermsCondition,
    this.EmployeeID,
    this.ApprovalStatus,
    this.EmailHeader,
    this.EmailContent,
    this.ProjectName,
    this.PatientName,
    this.PatientType,
    this.FinalAmount,
    this.Percentage,
    this.EstimatedAmt,
    this.BasicAmt,
    this.DiscountPer,
    this.DiscountAmt,
    this.SGSTAmt,
    this.CGSTAmt,
    this.IGSTAmt,
    this.ROffAmt,
    this.TankerNo,
    this.Gross_Weight,
    this.Tare_Weight,
    this.Net_Weight,
    this.LicenseNo,
    this.DriverDetails,
    this.DriverName,
    this.DrivingLicenseNo,
    this.DriverNumber,
    this.ConductorName,
    this.ModeOfPayment,
    this.TransporterName,
    this.ConsigneeName,
    this.ConsigneeAddress,
    this.ConsigneeCity,
    this.TripDistance,
    this.DeliveryNote,
    this.ChargeID1,
    this.ChargeAmt1,
    this.ChargeBasicAmt1,
    this.ChargeGSTAmt1,
    this.ChargeID2,
    this.ChargeAmt2,
    this.ChargeBasicAmt2,
    this.ChargeGSTAmt2,
    this.ChargeID3,
    this.ChargeAmt3,
    this.ChargeBasicAmt3,
    this.ChargeGSTAmt3,
    this.ChargeID4,
    this.ChargeAmt4,
    this.ChargeBasicAmt4,
    this.ChargeGSTAmt4,
    this.ChargeID5,
    this.ChargeAmt5,
    this.ChargeBasicAmt5,
    this.ChargeGSTAmt5,
    this.ChargePer1,
    this.ChargePer2,
    this.ChargePer3,
    this.ChargePer4,
    this.ChargePer5,
    this.NetAmt,
    this.AdvancePer,
    this.AdvanceAmt,
    this.CurrencyName,
    this.CurrencySymbol,
    this.ExchangeRate,
    this.InvoiceNo,
    this.InvoiceDate,
    this.LRNo,
    this.LRDate,
    this.EwayBillNo,
    this.EwayBillDate,
    this.POKindAttn,
    this.OrgCode,
    this.LoginUserID,
    this.RefType,
    this.CompanyId,
  });

  factory PurchaseOrderAddUpdateRequest.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderAddUpdateRequest(
      pkID: int.parse(json['pkID'].toString()),
      OrderNo: json['OrderNo'] ?? '',
      OrderDate: json['OrderDate'] ?? '',
      CustomerID: json['CustomerID'].toString(),
      QuotationNo: json['QuotationNo'] ?? '',
      ReferenceDate: json['ReferenceDate'] ?? '',
      InquiryNo: json['InquiryNo'] ?? '',
      BuyerRef: json['BuyerRef'] ?? '',
      BillNo: json['BillNo'] ?? '',
      TermsCondition: json['TermsCondition'] ?? '',
      EmployeeID: json['EmployeeID'].toString(),
      ApprovalStatus: json['ApprovalStatus'] ?? '',
      EmailHeader: json['EmailHeader'] ?? '',
      EmailContent: json['EmailContent'] ?? '',
      ProjectName: json['ProjectName'] ?? '',
      PatientName: json['PatientName'] ?? '',
      PatientType: json['PatientType'] ?? '',
      FinalAmount: json['FinalAmount'].toString(),
      Percentage: json['Percentage'].toString(),
      EstimatedAmt: json['EstimatedAmt'].toString(),
      BasicAmt: json['BasicAmt'].toString(),
      DiscountPer: json['DiscountPer'].toString(),
      DiscountAmt: json['DiscountAmt'].toString(),
      SGSTAmt: json['SGSTAmt'],
      CGSTAmt: json['CGSTAmt'],
      IGSTAmt: json['IGSTAmt'],
      ROffAmt: json['ROffAmt'],
      TankerNo: json['TankerNo'] ?? '',
      Gross_Weight: json['Gross_Weight'],
      Tare_Weight: json['Tare_Weight'],
      Net_Weight: json['Net_Weight'],
      LicenseNo: json['LicenseNo'] ?? '',
      DriverDetails: json['DriverDetails'] ?? '',
      DriverName: json['DriverName'] ?? '',
      DrivingLicenseNo: json['DrivingLicenseNo'] ?? '',
      DriverNumber: json['DriverNumber'] ?? '',
      ConductorName: json['ConductorName'] ?? '',
      ModeOfPayment: json['ModeOfPayment'] ?? '',
      TransporterName: json['TransporterName'] ?? '',
      ConsigneeName: json['ConsigneeName'] ?? '',
      ConsigneeAddress: json['ConsigneeAddress'] ?? '',
      ConsigneeCity: json['ConsigneeCity'] ?? '',
      TripDistance: json['TripDistance'] ?? '',
      DeliveryNote: json['DeliveryNote'] ?? '',
      ChargeID1: json['ChargeID1'],
      ChargeAmt1: json['ChargeAmt1'],
      ChargeBasicAmt1: json['ChargeBasicAmt1'],
      ChargeGSTAmt1: json['ChargeGSTAmt1'],
      ChargeID2: json['ChargeID2'],
      ChargeAmt2: json['ChargeAmt2'],
      ChargeBasicAmt2: json['ChargeBasicAmt2'],
      ChargeGSTAmt2: json['ChargeGSTAmt2'],
      ChargeID3: json['ChargeID3'],
      ChargeAmt3: json['ChargeAmt3'],
      ChargeBasicAmt3: json['ChargeBasicAmt3'],
      ChargeGSTAmt3: json['ChargeGSTAmt3'],
      ChargeID4: json['ChargeID4'],
      ChargeAmt4: json['ChargeAmt4'],
      ChargeBasicAmt4: json['ChargeBasicAmt4'],
      ChargeGSTAmt4: json['ChargeGSTAmt4'],
      ChargeID5: json['ChargeID5'],
      ChargeAmt5: json['ChargeAmt5'],
      ChargeBasicAmt5: json['ChargeBasicAmt5'],
      ChargeGSTAmt5: json['ChargeGSTAmt5'],
      ChargePer1: json['ChargePer1'],
      ChargePer2: json['ChargePer2'],
      ChargePer3: json['ChargePer3'],
      ChargePer4: json['ChargePer4'],
      ChargePer5: json['ChargePer5'],
      NetAmt: json['NetAmt'],
      AdvancePer: json['AdvancePer'],
      AdvanceAmt: json['AdvanceAmt'],
      CurrencyName: json['CurrencyName'] ?? '',
      CurrencySymbol: json['CurrencySymbol'] ?? '',
      ExchangeRate: json['ExchangeRate'].toString(),
      InvoiceNo: json['InvoiceNo'] ?? '',
      InvoiceDate: json['InvoiceDate'] ?? '',
      LRNo: json['LRNo'] ?? '',
      LRDate: json['LRDate'] ?? '',
      EwayBillNo: json['EwayBillNo'] ?? '',
      EwayBillDate: json['EwayBillDate'] ?? '',
      POKindAttn: json['POKindAttn'] ?? '',
      OrgCode: json['OrgCode'] ?? '',
      LoginUserID: json['LoginUserID'] ?? '',
      RefType: json['RefType'] ?? '',
      CompanyId: json['CompanyId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pkID'] = pkID;
    data['OrderNo'] = OrderNo;
    data['OrderDate'] = OrderDate;
    data['CustomerID'] = CustomerID;
    data['QuotationNo'] = QuotationNo;
    data['ReferenceDate'] = ReferenceDate;
    data['InquiryNo'] = InquiryNo;
    data['BuyerRef'] = BuyerRef;
    data['BillNo'] = BillNo;
    data['TermsCondition'] = TermsCondition;
    data['EmployeeID'] = EmployeeID;
    data['ApprovalStatus'] = ApprovalStatus;
    data['EmailHeader'] = EmailHeader;
    data['EmailContent'] = EmailContent;
    data['ProjectName'] = ProjectName;
    data['PatientName'] = PatientName;
    data['PatientType'] = PatientType;
    data['FinalAmount'] = FinalAmount;
    data['Percentage'] = Percentage;
    data['EstimatedAmt'] = EstimatedAmt;
    data['BasicAmt'] = BasicAmt;
    data['DiscountPer'] = DiscountPer;
    data['DiscountAmt'] = DiscountAmt;
    data['SGSTAmt'] = SGSTAmt;
    data['CGSTAmt'] = CGSTAmt;
    data['IGSTAmt'] = IGSTAmt;
    data['ROffAmt'] = ROffAmt;
    data['TankerNo'] = TankerNo;
    data['Gross_Weight'] = Gross_Weight;
    data['Tare_Weight'] = Tare_Weight;
    data['Net_Weight'] = Net_Weight;
    data['LicenseNo'] = LicenseNo;
    data['DriverDetails'] = DriverDetails;
    data['DriverName'] = DriverName;
    data['DrivingLicenseNo'] = DrivingLicenseNo;
    data['DriverNumber'] = DriverNumber;
    data['ConductorName'] = ConductorName;
    data['ModeOfPayment'] = ModeOfPayment;
    data['TransporterName'] = TransporterName;
    data['ConsigneeName'] = ConsigneeName;
    data['ConsigneeAddress'] = ConsigneeAddress;
    data['ConsigneeCity'] = ConsigneeCity;
    data['TripDistance'] = TripDistance;
    data['DeliveryNote'] = DeliveryNote;
    data['ChargeID1'] = ChargeID1;
    data['ChargeAmt1'] = ChargeAmt1;
    data['ChargeBasicAmt1'] = ChargeBasicAmt1;
    data['ChargeGSTAmt1'] = ChargeGSTAmt1;
    data['ChargeID2'] = ChargeID2;
    data['ChargeAmt2'] = ChargeAmt2;
    data['ChargeBasicAmt2'] = ChargeBasicAmt2;
    data['ChargeGSTAmt2'] = ChargeGSTAmt2;
    data['ChargeID3'] = ChargeID3;
    data['ChargeAmt3'] = ChargeAmt3;
    data['ChargeBasicAmt3'] = ChargeBasicAmt3;
    data['ChargeGSTAmt3'] = ChargeGSTAmt3;
    data['ChargeID4'] = ChargeID4;
    data['ChargeAmt4'] = ChargeAmt4;
    data['ChargeBasicAmt4'] = ChargeBasicAmt4;
    data['ChargeGSTAmt4'] = ChargeGSTAmt4;
    data['ChargeID5'] = ChargeID5;
    data['ChargeAmt5'] = ChargeAmt5;
    data['ChargeBasicAmt5'] = ChargeBasicAmt5;
    data['ChargeGSTAmt5'] = ChargeGSTAmt5;
    data['ChargePer1'] = ChargePer1;
    data['ChargePer2'] = ChargePer2;
    data['ChargePer3'] = ChargePer3;
    data['ChargePer4'] = ChargePer4;
    data['ChargePer5'] = ChargePer5;
    data['NetAmt'] = NetAmt;
    data['AdvancePer'] = AdvancePer;
    data['AdvanceAmt'] = AdvanceAmt;
    data['CurrencyName'] = CurrencyName;
    data['CurrencySymbol'] = CurrencySymbol;
    data['ExchangeRate'] = ExchangeRate;
    data['InvoiceNo'] = InvoiceNo;
    data['InvoiceDate'] = InvoiceDate;
    data['LRNo'] = LRNo;
    data['LRDate'] = LRDate;
    data['EwayBillNo'] = EwayBillNo;
    data['EwayBillDate'] = EwayBillDate;
    data['POKindAttn'] = POKindAttn;
    data['OrgCode'] = OrgCode;
    data['LoginUserID'] = LoginUserID;
    data['RefType'] = RefType;
    data['CompanyId'] = CompanyId;

    return data;
  }
}
