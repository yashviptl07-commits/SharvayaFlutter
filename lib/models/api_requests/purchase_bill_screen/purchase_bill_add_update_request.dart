class PurchaseBillAddUpdateRequest {
  String pkID;
  String InvoiceNo;
  String InvoiceDate;
  String FixedLedgerID;
  String CustomerID;
  String LocationID;
  String BankID;
  String TerminationOfDeliery;
  String TermsCondition;
  String BillNo;
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
  String ModeOfTransport;
  String TransporterName;
  String VehicleNo;
  String LRNo;
  String LRDate;
  String TransportRemark;
  String NetAmt;
  String ForCoustmerID;
  String CRDays;
  String DueDate;
  String CurrencyName;
  String CurrencySymbol;
  String ExchangeRate;
  String ProjectName;
  String LoginUserID;
  String CompanyId;

  PurchaseBillAddUpdateRequest({
    this.pkID,
    this.InvoiceNo,
    this.InvoiceDate,
    this.FixedLedgerID,
    this.CustomerID,
    this.LocationID,
    this.BankID,
    this.TerminationOfDeliery,
    this.TermsCondition,
    this.BillNo,
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
    this.ModeOfTransport,
    this.TransporterName,
    this.VehicleNo,
    this.LRNo,
    this.LRDate,
    this.TransportRemark,
    this.NetAmt,
    this.ForCoustmerID,
    this.CRDays,
    this.DueDate,
    this.CurrencyName,
    this.CurrencySymbol,
    this.ExchangeRate,
    this.ProjectName,
    this.LoginUserID,
    this.CompanyId,
  });

  PurchaseBillAddUpdateRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    InvoiceNo = json['InvoiceNo'];
    InvoiceDate = json['InvoiceDate'];
    FixedLedgerID = json['FixedLedgerID'];
    CustomerID = json['CustomerID'];
    LocationID = json['LocationID'];
    BankID = json['BankID'];
    TerminationOfDeliery = json['TerminationOfDeliery'];
    TermsCondition = json['TermsCondition'];
    BillNo = json['BillNo'];
    BasicAmt = json['BasicAmt'];
    DiscountPer = json['DiscountPer'];
    DiscountAmt = json['DiscountAmt'];
    SGSTAmt = json['SGSTAmt'];
    CGSTAmt = json['CGSTAmt'];
    IGSTAmt = json['IGSTAmt'];
    ROffAmt = json['ROffAmt'];
    ChargeID1 = json['ChargeID1'];
    ChargeAmt1 = json['ChargeAmt1'];
    ChargeBasicAmt1 = json['ChargeBasicAmt1'];
    ChargeGSTAmt1 = json['ChargeGSTAmt1'];
    ChargeID2 = json['ChargeID2'];
    ChargeAmt2 = json['ChargeAmt2'];
    ChargeBasicAmt2 = json['ChargeBasicAmt2'];
    ChargeGSTAmt2 = json['ChargeGSTAmt2'];
    ChargeID3 = json['ChargeID3'];
    ChargeAmt3 = json['ChargeAmt3'];
    ChargeBasicAmt3 = json['ChargeBasicAmt3'];
    ChargeGSTAmt3 = json['ChargeGSTAmt3'];
    ChargeID4 = json['ChargeID4'];
    ChargeAmt4 = json['ChargeAmt4'];
    ChargeBasicAmt4 = json['ChargeBasicAmt4'];
    ChargeGSTAmt4 = json['ChargeGSTAmt4'];
    ChargeID5 = json['ChargeID5'];
    ChargeAmt5 = json['ChargeAmt5'];
    ChargeBasicAmt5 = json['ChargeBasicAmt5'];
    ChargeGSTAmt5 = json['ChargeGSTAmt5'];
    ModeOfTransport = json['ModeOfTransport'];
    TransporterName = json['TransporterName'];
    VehicleNo = json['VehicleNo'];
    LRNo = json['LRNo'];
    LRDate = json['LRDate'];
    TransportRemark = json['TransportRemark'];
    NetAmt = json['NetAmt'];
    ForCoustmerID = json['ForCoustmerID'];
    CRDays = json['CRDays'];
    DueDate = json['DueDate'];
    CurrencyName = json['CurrencyName'];
    CurrencySymbol = json['CurrencySymbol'];
    ExchangeRate = json['ExchangeRate'];
    ProjectName = json['ProjectName'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pkID'] = pkID;
    data['InvoiceNo'] = InvoiceNo;
    data['InvoiceDate'] = InvoiceDate;
    data['FixedLedgerID'] = FixedLedgerID;
    data['CustomerID'] = CustomerID;
    data['LocationID'] = LocationID;
    data['BankID'] = BankID;
    data['TerminationOfDeliery'] = TerminationOfDeliery;
    data['TermsCondition'] = TermsCondition;
    data['BillNo'] = BillNo;
    data['BasicAmt'] = BasicAmt;
    data['DiscountPer'] = DiscountPer;
    data['DiscountAmt'] = DiscountAmt;
    data['SGSTAmt'] = SGSTAmt;
    data['CGSTAmt'] = CGSTAmt;
    data['IGSTAmt'] = IGSTAmt;
    data['ROffAmt'] = ROffAmt;
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
    data['ModeOfTransport'] = ModeOfTransport;
    data['TransporterName'] = TransporterName;
    data['VehicleNo'] = VehicleNo;
    data['LRNo'] = LRNo;
    data['LRDate'] = LRDate;
    data['TransportRemark'] = TransportRemark;
    data['NetAmt'] = NetAmt;
    data['ForCoustmerID'] = ForCoustmerID;
    data['CRDays'] = CRDays;
    data['DueDate'] = DueDate;
    data['CurrencyName'] = CurrencyName;
    data['CurrencySymbol'] = CurrencySymbol;
    data['ExchangeRate'] = ExchangeRate;
    data['ProjectName'] = ProjectName;
    data['LoginUserID'] = LoginUserID;
      data['CompanyId'] = CompanyId;
    return data;
  }
}
