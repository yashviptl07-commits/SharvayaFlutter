class ShortInvoiceProductRequest {
  String pkID;
  String InvoiceNo;
  String DocRefNo;
  int ProductID;
  String ProductSpecification;
  int LocationID;
  int TaxType;
  double UnitQty;
  double PendingQty;
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
  String ForOrderNo;
  double NetWT;
  double GrossWT;
  String BoxNo;
  String LoginUserID;
  int CompanyId;

  ShortInvoiceProductRequest({
    this.pkID,
    this.InvoiceNo,
    this.DocRefNo,
    this.ProductID,
    this.ProductSpecification,
    this.LocationID,
    this.TaxType,
    this.UnitQty,
    this.PendingQty,
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
    this.ForOrderNo,
    this.NetWT,
    this.GrossWT,
    this.BoxNo,
    this.LoginUserID,
    this.CompanyId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.InvoiceNo;
    data['DocRefNo'] = this.DocRefNo;
    data['ProductID'] = this.ProductID;
    data['ProductSpecification'] = this.ProductSpecification;
    data['LocationID'] = this.LocationID;
    data['TaxType'] = this.TaxType;
    data['UnitQty'] = this.UnitQty;
    data['PendingQty'] = this.PendingQty;
    data['Qty'] = this.Qty;
    data['Unit'] = this.Unit;
    data['Rate'] = this.Rate;
    data['DiscountPer'] = this.DiscountPer;
    data['DiscountAmt'] = this.DiscountAmt;
    data['NetRate'] = this.NetRate;
    data['Amount'] = this.Amount;
    data['SGSTPer'] = this.SGSTPer;
    data['SGSTAmt'] = this.SGSTAmt;
    data['CGSTPer'] = this.CGSTPer;
    data['CGSTAmt'] = this.CGSTAmt;
    data['IGSTPer'] = this.IGSTPer;
    data['IGSTAmt'] = this.IGSTAmt;
    data['AddTaxPer'] = this.AddTaxPer;
    data['AddTaxAmt'] = this.AddTaxAmt;
    data['NetAmt'] = this.NetAmt;
    data['HeaderDiscAmt'] = this.HeaderDiscAmt;
    data['ForOrderNo'] = this.ForOrderNo;
    data['NetWT'] = this.NetWT;
    data['GrossWT'] = this.GrossWT;
    data['BoxNo'] = this.BoxNo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
