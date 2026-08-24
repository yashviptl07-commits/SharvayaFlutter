class PurchaseOrderDetailsAddUpdateRequest {
  int pkID;
  String OrderNo;
  int ProductID;
  String ProductSpecification;
  int TaxType;
  double Quantity;
  String Unit;
  double UnitRate;
  double DiscountPercent;
  double NetRate;
  double Amount;
  double TaxRate;
  double TaxAmount;
  double NetAmount;
  String DeliveryDate;
  double DiscountAmt;
  double SGSTPer;
  double SGSTAmt;
  double CGSTPer;
  double CGSTAmt;
  double IGSTPer;
  double IGSTAmt;
  double HeaderDiscAmt;
  String IndentNo;
  String LoginUserID;
  String CompanyId;

  PurchaseOrderDetailsAddUpdateRequest({
    this.pkID,
    this.OrderNo,
    this.ProductID,
    this.ProductSpecification,
    this.TaxType,
    this.Quantity,
    this.Unit,
    this.UnitRate,
    this.DiscountPercent,
    this.NetRate,
    this.Amount,
    this.TaxRate,
    this.TaxAmount,
    this.NetAmount,
    this.DeliveryDate,
    this.DiscountAmt,
    this.SGSTPer,
    this.SGSTAmt,
    this.CGSTPer,
    this.CGSTAmt,
    this.IGSTPer,
    this.IGSTAmt,
    this.HeaderDiscAmt,
    this.IndentNo,
    this.LoginUserID,
    this.CompanyId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pkID'] = pkID;
    data['OrderNo'] = OrderNo;
    data['ProductID'] = ProductID;
    data['ProductSpecification'] = ProductSpecification;
    data['TaxType'] = TaxType;
    data['Quantity'] = Quantity;
    data['Unit'] = Unit;
    data['UnitRate'] = UnitRate;
    data['DiscountPercent'] = DiscountPercent;
    data['NetRate'] = NetRate;
    data['Amount'] = Amount;
    data['TaxRate'] = TaxRate;
    data['TaxAmount'] = TaxAmount;
    data['NetAmount'] = NetAmount;
    data['DeliveryDate'] = DeliveryDate;
    data['DiscountAmt'] = DiscountAmt;
    data['SGSTPer'] = SGSTPer;
    data['SGSTAmt'] = SGSTAmt;
    data['CGSTPer'] = CGSTPer;
    data['CGSTAmt'] = CGSTAmt;
    data['IGSTPer'] = IGSTPer;
    data['IGSTAmt'] = IGSTAmt;
    data['HeaderDiscAmt'] = HeaderDiscAmt;
    data['IndentNo'] = IndentNo;
    data['LoginUserID'] = LoginUserID;
    data['CompanyId'] = CompanyId;
    return data;
  }
}
