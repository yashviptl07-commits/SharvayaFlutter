/*
pkID
ProductName
ProductAlias
BrandID:1
ProductGroupID
ProductType
ActiveFlag
HSNCode
UnitPrice
TaxRate
TaxType
Unit
ProductSpecification
LoginUserID
CompanyId
*/

class ProductMasterAddEditRequest {
  String pkID;
  String ProductName;
  String ProductAlias;
  String BrandID;
  String ProductGroupID;
  String ProductType;
  String ActiveFlag;
  String HSNCode;
  String UnitPrice;
  String TaxRate;
  String TaxType;
  String Unit;
  String ProductSpecification;
  String LoginUserID;
  String CompanyId;

  ProductMasterAddEditRequest({
        this.pkID,
        this.ProductName,
        this.ProductAlias,
        this.BrandID,
        this.ProductGroupID,
        this.ProductType,
        this.ActiveFlag,
        this.HSNCode,
        this.UnitPrice,
        this.TaxRate,
        this.TaxType,
        this.Unit,
        this.ProductSpecification,
        this.LoginUserID,
        this.CompanyId,
      });

  ProductMasterAddEditRequest.fromJson(Map<String, dynamic> json) {
    pkID = json["pkID"];
    ProductName = json["ProductName"];
    ProductAlias = json["ProductAlias"];
    BrandID = json["BrandID"];
    ProductGroupID = json["ProductGroupID"];
    ProductType = json["ProductType"];
    ActiveFlag = json["ActiveFlag"];
    HSNCode = json["HSNCode"];
    UnitPrice = json["UnitPrice"];
    TaxRate = json["TaxRate"];
    TaxType = json["TaxType"];
    Unit = json["Unit"];
    ProductSpecification = json["ProductSpecification"];
    LoginUserID = json["LoginUserID"];
    CompanyId = json["CompanyId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["pkID"] = this.pkID;
    data["ProductName"] = this.ProductName;
    data["ProductAlias"] = this.ProductAlias;
    data["BrandID"] = this.BrandID;
    data["ProductGroupID"] = this.ProductGroupID;
    data["ProductType"] = this.ProductType;
    data["ActiveFlag"] = this.ActiveFlag;
    data["HSNCode"] = this.HSNCode;
    data["UnitPrice"] = this.UnitPrice;
    data["TaxRate"] = this.TaxRate;
    data["TaxType"] = this.TaxType;
    data["Unit"] = this.Unit;
    data["ProductSpecification"] = this.ProductSpecification;
    data["LoginUserID"] = this.LoginUserID;
    data["CompanyId"] = this.CompanyId;

    return data;
  }
}
