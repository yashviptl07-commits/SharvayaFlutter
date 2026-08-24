/*
pkID
OutwardNo
ProductID
ProductName
Quantity
ProductSpecification
QuantityWeight
SerialNo
BoxNo
Unit
UnitRate
DiscountPercent
NetRate
Amount
TaxRate
TaxAmount
NetAmount
CreatedBy
CreatedDate
UpdatedBy
UpdatedDate
OrderNo
LocationID
IGSTPer
DiscountAmt
SGSTAmt
CGSTAmt
IGSTAmt
SampleQuantity
DateCode
TaxType
SGSTPer
CGSTPer
LoginUserID
CompanyId
*/

class MaterialOutwardTable {
  int id;
  int pkID;
  String OutwardNo;
  int ProductID;
  String ProductName;
  double Quantity;
  String ProductSpecification;
  double QuantityWeight;
  String SerialNo;
  String BoxNo;
  String Unit;
  double UnitRate;
  double DiscountPercent;
  double NetRate;
  double Amount;
  double TaxRate;
  double TaxAmount;
  double NetAmount;
  String OrderNo;
  int LocationID;
  double IGSTPer;
  double DiscountAmt;
  double SGSTAmt;
  double CGSTAmt;
  double IGSTAmt;
  double SampleQuantity;
  String DateCode;
  int TaxType;
  double SGSTPer;
  double CGSTPer;
  int StateCode;
  String LoginUserID;
  String CompanyId;

  MaterialOutwardTable(
      this.pkID,
      this.OutwardNo,
      this.ProductID,
      this.ProductName,
      this.Quantity,
      this.ProductSpecification,
      this.QuantityWeight,
      this.SerialNo,
      this.BoxNo,
      this.Unit,
      this.UnitRate,
      this.DiscountPercent,
      this.NetRate,
      this.Amount,
      this.TaxRate,
      this.TaxAmount,
      this.NetAmount,
      this.OrderNo,
      this.LocationID,
      this.IGSTPer,
      this.DiscountAmt,
      this.SGSTAmt,
      this.CGSTAmt,
      this.IGSTAmt,
      this.SampleQuantity,
      this.DateCode,
      this.TaxType,
      this.SGSTPer,
      this.CGSTPer,
      this.StateCode,
      this.LoginUserID,
      this.CompanyId,
      {this.id}
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['OutwardNo'] = this.OutwardNo;
    data['ProductID'] = this.ProductID;
    data['ProductName'] = this.ProductName;
    data['Quantity'] = this.Quantity;
    data['ProductSpecification'] = this.ProductSpecification;
    data['QuantityWeight'] = this.QuantityWeight;
    data['SerialNo'] = this.SerialNo;
    data['BoxNo'] = this.BoxNo;
    data['Unit'] = this.Unit;
    data['UnitRate'] = this.UnitRate;
    data['DiscountPercent'] = this.DiscountPercent;
    data['NetRate'] = this.NetRate;
    data['Amount'] = this.Amount;
    data['TaxRate'] = this.TaxRate;
    data['TaxAmount'] = this.TaxAmount;
    data['NetAmount'] = this.NetAmount;
    data['OrderNo'] = this.OrderNo;
    data['LocationID'] = this.LocationID;
    data['IGSTPer'] = this.IGSTPer;
    data['DiscountAmt'] = this.DiscountAmt;
    data['SGSTAmt'] = this.SGSTAmt;
    data['CGSTAmt'] = this.CGSTAmt;
    data['IGSTAmt'] = this.IGSTAmt;
    data['SampleQuantity'] = this.SampleQuantity;
    data['DateCode'] = this.DateCode;
    data['TaxType'] = this.TaxType;
    data['SGSTPer'] = this.SGSTPer;
    data['CGSTPer'] = this.CGSTPer;
    data['StateCode'] = this.StateCode;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }

  @override
  String toString() {
    return 'MaterialOutwardTable{id: $id, pkID: $pkID, OutwardNo: $OutwardNo, ProductID: $ProductID, ProductName: $ProductName, Quantity: $Quantity, ProductSpecification: $ProductSpecification, QuantityWeight: $QuantityWeight, SerialNo: $SerialNo, BoxNo: $BoxNo, Unit: $Unit, UnitRate: $UnitRate, DiscountPercent: $DiscountPercent, NetRate: $NetRate, Amount: $Amount, TaxRate: $TaxRate, TaxAmount: $TaxAmount, NetAmount: $NetAmount, OrderNo: $OrderNo, LocationID: $LocationID, IGSTPer: $IGSTPer, DiscountAmt: $DiscountAmt, SGSTAmt: $SGSTAmt, CGSTAmt: $CGSTAmt, IGSTAmt: $IGSTAmt, SampleQuantity: $SampleQuantity, DateCode: $DateCode, TaxType: $TaxType, SGSTPer: $SGSTPer, CGSTPer: $CGSTPer, StateCode: $StateCode, LoginUserID: $LoginUserID, CompanyId: $CompanyId}';
  }

}
