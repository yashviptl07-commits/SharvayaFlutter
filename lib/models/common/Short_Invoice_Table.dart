class ShortInvoiceTable {
  int id;
  int pkID;
  String InvoiceNo;
  String DocRefNo;
  int ProductID;
  String ProductName;
  String ProductSpecification;
  int LocationID;
  int TaxType;
  double PendingQty;
  double UnitQty;
  double Qty;
  String Unit;
  double Rate;
  double DiscountPer;
  double DiscountAmt;
  double NetRate;
  double Amount;
  double CGSTPer;
  double SGSTPer;
  double IGSTPer;
  double CGSTAmt;
  double SGSTAmt;
  double IGSTAmt;
  double AddTaxPer;
  double AddTaxAmt;
  double NetAmt;
  double HeaderDiscAmt;
  String ForOrderNo;
  String NetWt;
  String BocNo;
  String GrossWt;
  int StateCode;
  String LoginUserID;
  String CompanyId;

  ShortInvoiceTable(
      this.pkID,
      this.InvoiceNo,
      this.DocRefNo,
      this.ProductID,
      this.ProductName,
      this.ProductSpecification,
      this.LocationID,
      this.TaxType,
      this.PendingQty,
      this.UnitQty,
      this.Qty,
      this.Unit,
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
      this.ForOrderNo,
      this.NetWt,
      this.BocNo,
      this.GrossWt,
      this.StateCode,
      this.LoginUserID,
      this.CompanyId,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["pkID"] = this.pkID;
    data["InvoiceNo"] = this.InvoiceNo;
    data["DocRefNo"] = this.DocRefNo;
    data["ProductID"] = this.ProductID;
    data["ProductName"] = this.ProductName;
    data["ProductSpecification"] = this.ProductSpecification;
    data["LocationID"] = this.LocationID;
    data["TaxType"] = this.TaxType;
    data["PendingQty"] = this.PendingQty;
    data["UnitQty"] = this.UnitQty;
    data["Qty"] = this.Qty;
    data["Unit"] = this.Unit;
    data["Rate"] = this.Rate;
    data["DiscountPer"] = this.DiscountPer;
    data["DiscountAmt"] = this.DiscountAmt;
    data["NetRate"] = this.NetRate;
    data["Amount"] = this.Amount;
    data["CGSTPer"] = this.CGSTPer;
    data["SGSTPer"] = this.SGSTPer;
    data["IGSTPer"] = this.IGSTPer;
    data["CGSTAmt"] = this.CGSTAmt;
    data["SGSTAmt"] = this.SGSTAmt;
    data["IGSTAmt"] = this.IGSTAmt;
    data["AddTaxPer"] = this.AddTaxPer;
    data["AddTaxAmt"] = this.AddTaxAmt;
    data["NetAmt"] = this.NetAmt;
    data["HeaderDiscAmt"] = this.HeaderDiscAmt;
    data["ForOrderNo"] = this.ForOrderNo;
    data["NetWt"] = this.NetWt;
    data["BocNo"] = this.BocNo;
    data["GrossWt"] = this.GrossWt;
    data["StateCode"] = this.StateCode;
    data["LoginUserID"] = this.LoginUserID;
    data["CompanyId"] = this.CompanyId;
    return data;
  }

  @override
  String toString() {
    return 'ShortInvoiceTable{id: $id, pkID: $pkID, InvoiceNo: $InvoiceNo, DocRefNo: $DocRefNo, ProductID: $ProductID, ProductName: $ProductName, ProductSpecification: $ProductSpecification, LocationID: $LocationID, TaxType: $TaxType, PendingQty: $PendingQty, UnitQty: $UnitQty, Qty: $Qty, Unit: $Unit, Rate: $Rate, DiscountPer: $DiscountPer, DiscountAmt: $DiscountAmt, NetRate: $NetRate, Amount: $Amount, CGSTPer: $CGSTPer, SGSTPer: $SGSTPer, IGSTPer: $IGSTPer, CGSTAmt: $CGSTAmt, SGSTAmt: $SGSTAmt, IGSTAmt: $IGSTAmt, AddTaxPer: $AddTaxPer, AddTaxAmt: $AddTaxAmt, NetAmt: $NetAmt, HeaderDiscAmt: $HeaderDiscAmt, ForOrderNo: $ForOrderNo, NetWt: $NetWt, BocNo: $BocNo, GrossWt: $GrossWt, StateCode: $StateCode, LoginUserID: $LoginUserID, CompanyId: $CompanyId}';
  }
}
