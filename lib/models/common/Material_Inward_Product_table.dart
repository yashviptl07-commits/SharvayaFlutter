
/*
RowNum
pkID
InwardNo
InwardDate
DateCode
CustomerID
CustomerName
ProductID
ProductName
ProductNameLong
ProductSpecification
Quantity
Unit
UnitRate
DiscountPercent
NetRate": 1.000,
Amount": 1200.000,
TaxRate": 18.00,
TaxAmount": 216.000,
NetAmount": 1416.000,
CGSTPer": 9.000,
CGSTAmt": 108.000,
SGSTPer": 9.000,
SGSTAmt": 108.000,
IGSTPer": 0.000,
IGSTAmt": 0.000,
OrderNo": "",
IndentNo": ""
*/

class MaterialInwardTable {
  int id;
  String RowNum;
  String pkID;
  String LoginUserID;
  String CompanyId;
  String InwardNo;
  String InwardDate;
  String DateCode;
  String CustomerID;
  String CustomerName;
  String ProductID;
  String ProductName;
  String ProductNameLong;
  String ProductSpecification;
  String Quantity;
  String Unit;
  String UnitRate;
  String DiscountPercent;
  String DiscountAmt;
  String NetRate;
  String Amount;
  String TaxType;
  String TaxRate;
  String TaxAmount;
  String NetAmount;
  String CGSTPer;
  String CGSTAmt;
  String SGSTPer;
  String SGSTAmt;
  String IGSTPer;
  String IGSTAmt;
  String OrderNo;
  String StateCode;
  String LocationID;
  String SampleQuantity;

  MaterialInwardTable(
      this.RowNum,
      this.pkID,
      this.LoginUserID,
      this.CompanyId,
      this.InwardNo,
      this.InwardDate,
      this.DateCode,
      this.CustomerID,
      this.CustomerName,
      this.ProductID,
      this.ProductName,
      this.ProductNameLong,
      this.ProductSpecification,
      this.Quantity,
      this.Unit,
      this.UnitRate,
      this.DiscountPercent,
      this.DiscountAmt,
      this.NetRate,
      this.Amount,
      this.TaxType,
      this.TaxRate,
      this.TaxAmount,
      this.NetAmount,
      this.CGSTPer,
      this.CGSTAmt,
      this.SGSTPer,
      this.SGSTAmt,
      this.IGSTPer,
      this.IGSTAmt,
      this.OrderNo,
      this.StateCode,
      this.LocationID,
      this.SampleQuantity,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.RowNum;
    data['pkID'] = this.pkID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    data['InwardNo'] = this.InwardNo;
    data['InwardDate'] = this.InwardDate;
    data['DateCode'] = this.DateCode;
    data['CustomerID'] = this.CustomerID;
    data['CustomerName'] = this.CustomerName;
    data['ProductID'] = this.ProductID;
    data['ProductName'] = this.ProductName;
    data['ProductNameLong'] = this.ProductNameLong;
    data['ProductSpecification'] = this.ProductSpecification;
    data['Quantity'] = this.Quantity;
    data['Unit'] = this.Unit;
    data['UnitRate'] = this.UnitRate;
    data['DiscountPercent'] = this.DiscountPercent;
    data['DiscountAmt'] = this.DiscountAmt;
    data['NetRate'] = this.NetRate;
    data['Amount'] = this.Amount;
    data['TaxType'] = this.TaxType;
    data['TaxRate'] = this.TaxRate;
    data['TaxAmount'] = this.TaxAmount;
    data['NetAmount'] = this.NetAmount;
    data['CGSTPer'] = this.CGSTPer;
    data['CGSTAmt'] = this.CGSTAmt;
    data['SGSTPer'] = this.SGSTPer;
    data['SGSTAmt'] = this.SGSTAmt;
    data['IGSTPer'] = this.IGSTPer;
    data['IGSTAmt'] = this.IGSTAmt;
    data['OrderNo'] = this.OrderNo;
    data['StateCode'] = this.StateCode;
    data['LocationID'] = this.LocationID;
    data['SampleQuantity'] = this.SampleQuantity;

    return data;
  }

  @override
  String toString() {
    return 'MaterialInwardTable{id: $id, RowNum: $RowNum, pkID: $pkID, LoginUserID: $LoginUserID, CompanyId: $CompanyId, InwardNo: $InwardNo, InwardDate: $InwardDate, DateCode: $DateCode, CustomerID: $CustomerID, CustomerName: $CustomerName, ProductID: $ProductID, ProductName: $ProductName, ProductNameLong: $ProductNameLong, ProductSpecification: $ProductSpecification, Quantity: $Quantity, Unit: $Unit, UnitRate: $UnitRate, DiscountPercent: $DiscountPercent, DiscountAmt: $DiscountAmt, NetRate: $NetRate, Amount: $Amount, TaxType: $TaxType, TaxRate: $TaxRate, TaxAmount: $TaxAmount, NetAmount: $NetAmount, CGSTPer: $CGSTPer, CGSTAmt: $CGSTAmt, SGSTPer: $SGSTPer, SGSTAmt: $SGSTAmt, IGSTPer: $IGSTPer, IGSTAmt: $IGSTAmt, OrderNo: $OrderNo, StateCode: $StateCode, LocationID: $LocationID, SampleQuantity: $SampleQuantity}';
  }

}
