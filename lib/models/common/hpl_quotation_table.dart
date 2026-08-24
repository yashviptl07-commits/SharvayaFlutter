class QuotationTable1 {
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
  int TaxType;
  double CGSTPer;
  double SGSTPer;
  double IGSTPer;
  double CGSTAmt;
  double SGSTAmt;
  double IGSTAmt;
  int StateCode;
  int pkID;
  String LoginUserID;
  String CompanyId;
  int BundleId;
  double HeaderDiscAmt;
  int Finish;
  String FinishName;
  int Thickness;
  String ThicknessName;
  int Size;

  String SizeName;
  int Grade;
  String GradeName;
  int Design;
  String DesignName;

  //TaxType INTEGER, CGSTPer DOUBLE, SGSTPer DOUBLE, IGSTPer DOUBLE, CGSTAmt DOUBLE, SGSTAmt DOUBLE, IGSTAmt DOUBLE, StateCode INTEGER, pkID INTEGER, LoginUserID TEXT, CompanyId TEXT , BundleId INTEGER ,HeaderDiscAmt DOUBLE , Finish INTEGER ,FinishName TEXT ,Thickness INTEGER ,ThicknessName TEXT ,Size INTEGER ,SizeName TEXT ,Grade INTEGER ,GradeName TEXT ,Design INTEGER ,DesignName TEXT

  QuotationTable1(
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
      this.TaxType,
      this.CGSTPer,
      this.SGSTPer,
      this.IGSTPer,
      this.CGSTAmt,
      this.SGSTAmt,
      this.IGSTAmt,
      this.StateCode,
      this.pkID,
      this.LoginUserID,
      this.CompanyId,
      this.BundleId,
      this.HeaderDiscAmt,
      this.Finish,
      this.FinishName,
      this.Thickness,
      this.ThicknessName,
      this.Size,
      this.SizeName,
      this.Grade,
      this.GradeName,
      this.Design,
      this.DesignName,
      {this.id});

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
    data['Finish'] = this.Finish;
    data['FinishName'] = this.FinishName;
    data['Thickness'] = this.Thickness;
    data['ThicknessName'] = this.ThicknessName;
    data['Size'] = this.Size;
    data['SizeName'] = this.SizeName;
    data['Grade'] = this.Grade;
    data['GradeName'] = this.GradeName;
    data['Design'] = this.Design;
    data['DesignName'] = this.DesignName;

    return data;
  }

  @override
  String toString() {
    return 'QuotationTable1{id: $id, QuotationNo: $QuotationNo, ProductSpecification: $ProductSpecification, ProductID: $ProductID, ProductName: $ProductName, Unit: $Unit, Quantity: $Quantity, UnitRate: $UnitRate, DiscountPercent: $DiscountPercent, DiscountAmt: $DiscountAmt, NetRate: $NetRate, Amount: $Amount, TaxRate: $TaxRate, TaxAmount: $TaxAmount, NetAmount: $NetAmount, TaxType: $TaxType, CGSTPer: $CGSTPer, SGSTPer: $SGSTPer, IGSTPer: $IGSTPer, CGSTAmt: $CGSTAmt, SGSTAmt: $SGSTAmt, IGSTAmt: $IGSTAmt, StateCode: $StateCode, pkID: $pkID, LoginUserID: $LoginUserID, CompanyId: $CompanyId, BundleId: $BundleId, HeaderDiscAmt: $HeaderDiscAmt, Finish: $Finish, FinishName: $FinishName, Thickness: $Thickness, ThicknessName: $ThicknessName, Size: $Size, SizeName: $SizeName, Grade: $Grade, GradeName: $GradeName, Design: $Design, DesignName: $DesignName}';
  }

/* @override
  String toString() {
    return 'QuotationTable{id: $id, QuotationNo:$QuotationNo, Specification : $Specification , ProductID: $ProductID, ProductName: $ProductName, Unit: $Unit, Quantity: $Quantity, UnitRate: $UnitRate, Disc: $Disc, NetRate: $NetRate, Amount: $Amount, TaxPer: $TaxPer, TaxAmount: $TaxAmount, NetAmount: $NetAmount, IsTaxType: $IsTaxType}';
  }
*/
}
