class NewQuotationProductTable1 {
  int id;
  String QuotationNo;
  String ProductSpecification;
  int ProductID;
  String ProductName;
  String Unit;
  double Quantity;
  double UnitRate;
  double DiscountPercent;
  double DiscountAmt;
  double NetRate;
  double Amount;
  double TaxRate;
  double TaxAmount;
  double NetAmount;
  double CGSTPer;
  double SGSTPer;
  double IGSTPer;
  double CGSTAmt;
  double SGSTAmt;
  double IGSTAmt;
  int StateCode;
  int TaxType;
  int pkID;
  String LoginUserID;
  String CompanyId;
  int BundleId;
  double HeaderDiscAmt;
  String AdditionalDiscAmt;
  String ProfitAmount;
  String SubsidyApplicable;
  String Flag;
  String OthRef1;
  String OthRef2;
  String OthRef3;
  String DocRefNo;
  String FinishProductID;
  String UnitQty;
  String UnitWidth;
  String UnitHeight;
  String BasicPrice;
  String HAPer;
  String HARate;
  String HAAmt;

  String MarginPer;
  String MarginAmt;

  String GradeID;
  String SizeID;
  String FinishID;
  String ThicknessID;
  String DesignID;

  NewQuotationProductTable1({
    this.id,
    this.QuotationNo,
    this.ProductSpecification,
    this.ProductID,
    this.ProductName,
    this.Unit,
    this.Quantity,
    this.UnitRate,
    this.DiscountPercent,
    this.DiscountAmt,
    this.NetRate,
    this.Amount,
    this.TaxRate,
    this.TaxAmount,
    this.NetAmount,
    this.CGSTPer,
    this.SGSTPer,
    this.IGSTPer,
    this.CGSTAmt,
    this.SGSTAmt,
    this.IGSTAmt,
    this.StateCode,
    this.TaxType,
    this.pkID,
    this.LoginUserID,
    this.CompanyId,
    this.BundleId,
    this.HeaderDiscAmt,
    this.AdditionalDiscAmt,
    this.ProfitAmount,
    this.SubsidyApplicable,
    this.Flag,
    this.OthRef1,
    this.OthRef2,
    this.OthRef3,
    this.DocRefNo,
    this.FinishProductID,
    this.UnitQty,
    this.UnitWidth,
    this.UnitHeight,
    this.BasicPrice,
    this.HAPer,
    this.HARate,
    this.HAAmt,
    this.MarginPer,
    this.MarginAmt,
    this.GradeID,
    this.SizeID,
    this.FinishID,
    this.ThicknessID,
    this.DesignID,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuotationNo'] = this.QuotationNo;
    data['pkID'] = this.pkID;
    data['ProductID'] = this.ProductID;
    data['Quantity'] = this.Quantity;
    data['Unit'] = this.Unit;
    data['UnitRate'] = this.UnitRate;
    data['DiscountPercent'] = this.DiscountPercent;
    data['NetRate'] = this.NetRate;
    data['Amount'] = this.Amount;
    data['TaxAmount'] = this.TaxAmount;
    data['NetAmount'] = this.NetAmount;
    data['LoginUserID'] = this.LoginUserID;
    data['TaxRate'] = this.TaxRate;
    data['BundleId'] = this.BundleId;
    data['DiscountAmt'] = this.DiscountAmt;
    data['SGSTPer'] = this.SGSTPer;
    data['SGSTAmt'] = this.SGSTAmt;
    data['CGSTPer'] = this.CGSTPer;
    data['CGSTAmt'] = this.CGSTAmt;
    data['IGSTPer'] = this.IGSTPer;
    data['IGSTAmt'] = this.IGSTAmt;
    data['TaxType'] = this.TaxType;
    data['HeaderDiscAmt'] = this.HeaderDiscAmt;
    data['CompanyId'] = this.CompanyId;
    data['ProductSpecification'] = this.ProductSpecification;
    data['ProductName'] = this.ProductName;
    data['StateCode'] = this.StateCode;
    data['AdditionalDiscAmt'] = this.AdditionalDiscAmt;
    data['ProfitAmount'] = this.ProfitAmount;
    data['SubsidyApplicable'] = this.SubsidyApplicable;
    data['Flag'] = this.Flag;
    data['OthRef1'] = this.OthRef1;
    data['OthRef2'] = this.OthRef2;
    data['OthRef3'] = this.OthRef3;
    data['DocRefNo'] = this.DocRefNo;
    data['FinishProductID'] = this.FinishProductID;
    data['UnitQty'] = this.UnitQty;
    data['UnitWidth'] = this.UnitWidth;
    data['UnitHeight'] = this.UnitHeight;
    data['BasicPrice'] = this.BasicPrice;
    data['HAPer'] = this.HAPer;
    data['HARate'] = this.HARate;
    data['HAAmt'] = this.HAAmt;
    data['GradeID'] = this.GradeID;
    data['SizeID'] = this.SizeID;
    data['FinishID'] = this.FinishID;
    data['ThicknessID'] = this.ThicknessID;
    data['DesignID'] = this.DesignID;

    return data;
  }
}
