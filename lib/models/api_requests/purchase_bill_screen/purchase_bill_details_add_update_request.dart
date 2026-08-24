class PurchaseBillDetailsAddUpdateRequest {
  int pkID;
  String InvoiceNo;
  int ProductID;
  String ProductSpecification;
  int LocationID;
  int TaxType;
  double Qty;
  String Unit;
  double Rate;
  double DiscountPer;
  double DiscountAmt;
  double NetRate;
  double Amount;
  double SGSTPer;
  double SGSTAmt;
  double CGSTPer;
  double CGSTAmt;
  double IGSTPer;
  double IGSTAmt;
  double AddTaxPer;
  double AddTaxAmt;
  double NetAmt;
  double HeaderDiscAmt;
  String OrderNo;
  String LoginUserID;
  int CompanyId;

  PurchaseBillDetailsAddUpdateRequest({
    this.pkID,
    this.InvoiceNo,
    this.ProductID,
    this.ProductSpecification,
    this.LocationID,
    this.TaxType,
    this.Qty,
    this.Unit,
    this.Rate,
    this.DiscountPer,
    this.DiscountAmt,
    this.NetRate,
    this.Amount,
    this.SGSTPer,
    this.SGSTAmt,
    this.CGSTPer,
    this.CGSTAmt,
    this.IGSTPer,
    this.IGSTAmt,
    this.AddTaxPer,
    this.AddTaxAmt,
    this.NetAmt,
    this.HeaderDiscAmt,
    this.OrderNo,
    this.LoginUserID,
    this.CompanyId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pkID'] = pkID;
    data['InvoiceNo'] = InvoiceNo;
    data['ProductID'] = ProductID;
    data['ProductSpecification'] = ProductSpecification;
    data['LocationID'] = LocationID;
    data['TaxType'] = TaxType;
    data['Qty'] = Qty;
    data['Unit'] = Unit;
    data['Rate'] = Rate;
    data['DiscountPer'] = DiscountPer;
    data['DiscountAmt'] = DiscountAmt;
    data['NetRate'] = NetRate;
    data['Amount'] = Amount;
    data['SGSTPer'] = SGSTPer;
    data['SGSTAmt'] = SGSTAmt;
    data['CGSTPer'] = CGSTPer;
    data['CGSTAmt'] = CGSTAmt;
    data['IGSTPer'] = IGSTPer;
    data['IGSTAmt'] = IGSTAmt;
    data['AddTaxPer'] = AddTaxPer;
    data['AddTaxAmt'] = AddTaxAmt;
    data['NetAmt'] = NetAmt;
    data['HeaderDiscAmt'] = HeaderDiscAmt;
    data['OrderNo'] = OrderNo;
    data['LoginUserID'] = LoginUserID;
    data['CompanyId'] = CompanyId;
    return data;
  }
}
