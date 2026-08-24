class PurchaseBillTable {
  int id;
  String InvoiceNo;
  String ProductSpecification;
  int ProductID;
  String ProductName;
  String Unit;
  double Qty;
  double Rate;
  double DiscountPer;
  double DiscountAmt;
  double NetRate;
  double Amount;
  double AddTaxPer;
  double AddTaxAmt;
  double NetAmt;
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
  double HeaderDiscAmt;
  int LocationID;
  String OrderNo;

  PurchaseBillTable(
      this.pkID,
      this.InvoiceNo,
      this.OrderNo,
      this.ProductID,
      this.ProductName,
      this.ProductSpecification,
      this.LocationID,
      this.TaxType,
      this.Qty,
      this.Rate,
      this.DiscountPer,
      this.DiscountAmt,
      this.NetRate,
      this.Amount,
      this.CGSTPer,
      this.SGSTPer,
      this.IGSTPer,
      this.CGSTAmt,
      this.SGSTAmt,
      this.IGSTAmt,
      this.AddTaxPer,
      this.AddTaxAmt,
      this.NetAmt,
      this.HeaderDiscAmt,
      this.Unit,
      this.StateCode,
      this.LoginUserID,
      this.CompanyId,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['InvoiceNo'] = InvoiceNo;
    data['pkID'] = pkID;
    data['ProductID'] = ProductID;
    data['ProductName'] = ProductName;
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
    data['CGSTPer'] = CGSTPer;
    data['SGSTPer'] = SGSTPer;
    data['IGSTPer'] = IGSTPer;
    data['CGSTAmt'] = CGSTAmt;
    data['SGSTAmt'] = SGSTAmt;
    data['IGSTAmt'] = IGSTAmt;
    data['AddTaxPer'] = AddTaxPer;
    data['AddTaxAmt'] = AddTaxAmt;
    data['NetAmt'] = NetAmt;
    data['HeaderDiscAmt'] = HeaderDiscAmt;
    data['OrderNo'] = OrderNo;
    data['LoginUserID'] = LoginUserID;
    data['CompanyId'] = CompanyId;
    data['StateCode'] = StateCode;
    return data;
  }

  @override
  String toString() {
    return 'ShortInvoiceTable{id: $id, InvoiceNo: $InvoiceNo, ProductSpecification: $ProductSpecification, ProductID: $ProductID, ProductName: $ProductName, Unit: $Unit, Qty: $Qty, Rate: $Rate, DiscountPer: $DiscountPer, DiscountAmt: $DiscountAmt, NetRate: $NetRate, Amount: $Amount, AddTaxPer: $AddTaxPer, AddTaxAmt: $AddTaxAmt, NetAmt: $NetAmt, CGSTPer: $CGSTPer, SGSTPer: $SGSTPer, IGSTPer: $IGSTPer, CGSTAmt: $CGSTAmt, SGSTAmt: $SGSTAmt, IGSTAmt: $IGSTAmt, StateCode: $StateCode, TaxType: $TaxType, pkID: $pkID, LoginUserID: $LoginUserID, CompanyId: $CompanyId, HeaderDiscAmt: $HeaderDiscAmt, LocationID: $LocationID, OrderNo: $OrderNo}';
  }
}
