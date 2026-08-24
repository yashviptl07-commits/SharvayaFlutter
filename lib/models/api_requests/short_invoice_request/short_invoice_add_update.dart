class ShortInvoiceAddUpdateRequest {
  String pkID;
  String InvoiceNo;
  String InvoiceDate;
  String FixedLedgerID;
  String CustomerID;
  String LocationID;
  String BankID;
  String TerminationOfDeliery;
  String TerminationOfDelieryCity;
  String TermsCondition;
  String InquiryNo;
  String OrderNo;
  String QuotationNo;
  String ComplaintNo;
  String RefType;
  String SupplierRef;
  String SupplierRefDate;
  String EmailSubject;
  String EmailContent;
  String ProjectName;
  String OtherRef;
  String PatientName;
  String PatientType;
  String Amount;
  String Percentage;
  String EstimatedAmt;
  String BasicAmt;
  String DiscountPer;
  String DiscountAmt;
  String SGSTAmt;
  String CGSTAmt;
  String IGSTAmt;
  String ROffAmt;
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
  String CRDays;
  String DueDate;
  String NetAmt;
  String ModeOfTransport;
  String TransporterName;
  String DeliverTo;
  String VehicleNo;
  String LRNo;
  String DeliveryNote;
  String DeliveryDate;
  String DispatchDocNo;
  String LRDate;
  String EwayBillNo;
  String ModeOfPayment;
  String TransportRemark;
  String CommRemark;
  String ExtraRemark;
  String ProdDescription;
  String CurrencyName;
  String CurrencySymbol;
  String ExchangeRate;
  String ChallanDate;
  String ChallanNo;
  String LoginUserID;
  String CompanyId;

  ShortInvoiceAddUpdateRequest({
    this.pkID,
    this.InvoiceNo,
    this.InvoiceDate,
    this.FixedLedgerID,
    this.CustomerID,
    this.LocationID,
    this.BankID,
    this.TerminationOfDeliery,
    this.TerminationOfDelieryCity,
    this.TermsCondition,
    this.InquiryNo,
    this.OrderNo,
    this.QuotationNo,
    this.ComplaintNo,
    this.RefType,
    this.SupplierRef,
    this.SupplierRefDate,
    this.EmailSubject,
    this.EmailContent,
    this.ProjectName,
    this.OtherRef,
    this.PatientName,
    this.PatientType,
    this.Amount,
    this.Percentage,
    this.EstimatedAmt,
    this.BasicAmt,
    this.DiscountPer,
    this.DiscountAmt,
    this.SGSTAmt,
    this.CGSTAmt,
    this.IGSTAmt,
    this.ROffAmt,
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
    this.CRDays,
    this.DueDate,
    this.NetAmt,
    this.ModeOfTransport,
    this.TransporterName,
    this.DeliverTo,
    this.VehicleNo,
    this.LRNo,
    this.DeliveryNote,
    this.DeliveryDate,
    this.DispatchDocNo,
    this.LRDate,
    this.EwayBillNo,
    this.ModeOfPayment,
    this.TransportRemark,
    this.CommRemark,
    this.ExtraRemark,
    this.ProdDescription,
    this.CurrencyName,
    this.CurrencySymbol,
    this.ExchangeRate,
    this.ChallanDate,
    this.ChallanNo,
    this.LoginUserID,
    this.CompanyId,
  });

  /// Factory constructor to create from JSON map
  factory ShortInvoiceAddUpdateRequest.fromJson(Map<String, dynamic> json) {
    return ShortInvoiceAddUpdateRequest(
      pkID: json['pkID'] ?? '',
      InvoiceNo: json['InvoiceNo'] ?? '',
      InvoiceDate: json['InvoiceDate'],
      FixedLedgerID: json['FixedLedgerID'] ?? '0',
      CustomerID: json['CustomerID'] ?? '0',
      LocationID: json['LocationID'] ?? '0',
      BankID: json['BankID'] ?? '0',
      TerminationOfDeliery: json['TerminationOfDeliery'] ?? '',
      TerminationOfDelieryCity: json['TerminationOfDelieryCity'] ?? '',
      TermsCondition: json['TermsCondition'] ?? '',
      InquiryNo: json['InquiryNo'] ?? '',
      OrderNo: json['OrderNo'] ?? '',
      QuotationNo: json['QuotationNo'] ?? '',
      ComplaintNo: json['ComplaintNo'] ?? '',
      RefType: json['RefType'] ?? '',
      SupplierRef: json['SupplierRef'] ?? '',
      SupplierRefDate: json['SupplierRefDate'],
      EmailSubject: json['EmailSubject'] ?? '',
      EmailContent: json['EmailContent'] ?? '',
      ProjectName: json['ProjectName'] ?? '',
      OtherRef: json['OtherRef'] ?? '',
      PatientName: json['PatientName'] ?? '',
      PatientType: json['PatientType'] ?? '',
      Amount: json['Amount'] ?? '0.00',
      Percentage: json['Percentage'] ?? '',
      EstimatedAmt: json['EstimatedAmt'] ?? '0.00',
      BasicAmt: json['BasicAmt'] ?? '0.00',
      DiscountPer: json['DiscountPer'] ?? '0.00',
      DiscountAmt: json['DiscountAmt'] ?? '0.00',
      SGSTAmt: json['SGSTAmt'] ?? '0.00',
      CGSTAmt: json['CGSTAmt'] ?? '0.00',
      IGSTAmt: json['IGSTAmt'] ?? '0.00',
      ROffAmt: json['ROffAmt'] ?? '0.00',
      ChargeID1: json['ChargeID1'] ?? '0',
      ChargeAmt1: json['ChargeAmt1'] ?? '0.00',
      ChargeBasicAmt1: json['ChargeBasicAmt1'] ?? '0.00',
      ChargeGSTAmt1: json['ChargeGSTAmt1'] ?? '0.00',
      ChargeID2: json['ChargeID2'] ?? '0',
      ChargeAmt2: json['ChargeAmt2'] ?? '0.00',
      ChargeBasicAmt2: json['ChargeBasicAmt2'] ?? '0.00',
      ChargeGSTAmt2: json['ChargeGSTAmt2'] ?? '0.00',
      ChargeID3: json['ChargeID3'] ?? '0',
      ChargeAmt3: json['ChargeAmt3'] ?? '0.00',
      ChargeBasicAmt3: json['ChargeBasicAmt3'] ?? '0.00',
      ChargeGSTAmt3: json['ChargeGSTAmt3'] ?? '0.00',
      ChargeID4: json['ChargeID4'] ?? '0',
      ChargeAmt4: json['ChargeAmt4'] ?? '0.00',
      ChargeBasicAmt4: json['ChargeBasicAmt4'] ?? '0.00',
      ChargeGSTAmt4: json['ChargeGSTAmt4'] ?? '0.00',
      ChargeID5: json['ChargeID5'] ?? '0',
      ChargeAmt5: json['ChargeAmt5'] ?? '0.00',
      ChargeBasicAmt5: json['ChargeBasicAmt5'] ?? '0.00',
      ChargeGSTAmt5: json['ChargeGSTAmt5'] ?? '0.00',
      CRDays: json['CRDays'] ?? '',
      DueDate: json['DueDate'],
      NetAmt: json['NetAmt'] ?? '0.00',
      ModeOfTransport: json['ModeOfTransport'] ?? '',
      TransporterName: json['TransporterName'] ?? '',
      DeliverTo: json['DeliverTo'] ?? '',
      VehicleNo: json['VehicleNo'] ?? '',
      LRNo: json['LRNo'] ?? '',
      DeliveryNote: json['DeliveryNote'] ?? '',
      DeliveryDate: json['DeliveryDate'],
      DispatchDocNo: json['DispatchDocNo'] ?? '',
      LRDate: json['LRDate'],
      EwayBillNo: json['EwayBillNo'] ?? '',
      ModeOfPayment: json['ModeOfPayment'] ?? '',
      TransportRemark: json['TransportRemark'] ?? '',
      CommRemark: json['CommRemark'] ?? '',
      ExtraRemark: json['ExtraRemark'] ?? '',
      ProdDescription: json['ProdDescription'] ?? '',
      CurrencyName: json['CurrencyName'] ?? '',
      CurrencySymbol: json['CurrencySymbol'] ?? '',
      ExchangeRate: json['ExchangeRate'] ?? '',
      ChallanDate: json['ChallanDate'],
      ChallanNo: json['ChallanNo'] ?? '',
      LoginUserID: json['LoginUserID'] ?? '',
      CompanyId: json['CompanyId'] ?? '',
    );
  }

  /// Convert this model to JSON map
  Map<String, dynamic> toJson() {
    return {
      'pkID': pkID,
      'InvoiceNo': InvoiceNo,
      'InvoiceDate': InvoiceDate,
      'FixedLedgerID': FixedLedgerID,
      'CustomerID': CustomerID,
      'LocationID': LocationID,
      'BankID': BankID,
      'TerminationOfDeliery': TerminationOfDeliery,
      'TerminationOfDelieryCity': TerminationOfDelieryCity,
      'TermsCondition': TermsCondition,
      'InquiryNo': InquiryNo,
      'OrderNo': OrderNo,
      'QuotationNo': QuotationNo,
      'ComplaintNo': ComplaintNo,
      'RefType': RefType,
      'SupplierRef': SupplierRef,
      'SupplierRefDate': SupplierRefDate,
      'EmailSubject': EmailSubject,
      'EmailContent': EmailContent,
      'ProjectName': ProjectName,
      'OtherRef': OtherRef,
      'PatientName': PatientName,
      'PatientType': PatientType,
      'Amount': Amount,
      'Percentage': Percentage,
      'EstimatedAmt': EstimatedAmt,
      'BasicAmt': BasicAmt,
      'DiscountPer': DiscountPer,
      'DiscountAmt': DiscountAmt,
      'SGSTAmt': SGSTAmt,
      'CGSTAmt': CGSTAmt,
      'IGSTAmt': IGSTAmt,
      'ROffAmt': ROffAmt,
      'ChargeID1': ChargeID1,
      'ChargeAmt1': ChargeAmt1,
      'ChargeBasicAmt1': ChargeBasicAmt1,
      'ChargeGSTAmt1': ChargeGSTAmt1,
      'ChargeID2': ChargeID2,
      'ChargeAmt2': ChargeAmt2,
      'ChargeBasicAmt2': ChargeBasicAmt2,
      'ChargeGSTAmt2': ChargeGSTAmt2,
      'ChargeID3': ChargeID3,
      'ChargeAmt3': ChargeAmt3,
      'ChargeBasicAmt3': ChargeBasicAmt3,
      'ChargeGSTAmt3': ChargeGSTAmt3,
      'ChargeID4': ChargeID4,
      'ChargeAmt4': ChargeAmt4,
      'ChargeBasicAmt4': ChargeBasicAmt4,
      'ChargeGSTAmt4': ChargeGSTAmt4,
      'ChargeID5': ChargeID5,
      'ChargeAmt5': ChargeAmt5,
      'ChargeBasicAmt5': ChargeBasicAmt5,
      'ChargeGSTAmt5': ChargeGSTAmt5,
      'CRDays': CRDays,
      'DueDate': DueDate,
      'NetAmt': NetAmt,
      'ModeOfTransport': ModeOfTransport,
      'TransporterName': TransporterName,
      'DeliverTo': DeliverTo,
      'VehicleNo': VehicleNo,
      'LRNo': LRNo,
      'DeliveryNote': DeliveryNote,
      'DeliveryDate': DeliveryDate,
      'DispatchDocNo': DispatchDocNo,
      'LRDate': LRDate,
      'EwayBillNo': EwayBillNo,
      'ModeOfPayment': ModeOfPayment,
      'TransportRemark': TransportRemark,
      'CommRemark': CommRemark,
      'ExtraRemark': ExtraRemark,
      'ProdDescription': ProdDescription,
      'CurrencyName': CurrencyName,
      'CurrencySymbol': CurrencySymbol,
      'ExchangeRate': ExchangeRate,
      'ChallanDate': ChallanDate,
      'ChallanNo': ChallanNo,
      'LoginUserID': LoginUserID,
      'CompanyId': CompanyId,
    };
  }
}
