class SalasTargetAddUpdateRequest {
  String pkID;
  String EmployeeID;
  String FromDate;
  String ToDate;
  String TargetAmount;
  String BrandID;
  String ProductGroupID;
  String ProductID;
  String CustomerID;
  String IncentivePer;
  String IncentiveAmt;
  String LoginUserID;
  String TargetType;
  String Amount;
  String CompanyId;

  SalasTargetAddUpdateRequest({
    this.pkID,
    this.EmployeeID,
    this.FromDate,
    this.ToDate,
    this.TargetAmount,
    this.BrandID,
    this.ProductGroupID,
    this.ProductID,
    this.CustomerID,
    this.IncentivePer,
    this.IncentiveAmt,
    this.LoginUserID,
    this.TargetType,
    this.Amount,
    this.CompanyId,
  });

  SalasTargetAddUpdateRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    EmployeeID = json['EmployeeID'];
    FromDate = json['FromDate'];
    ToDate = json['ToDate'];
    TargetAmount = json['TargetAmount'];
    BrandID = json['BrandID'];
    ProductGroupID = json['ProductGroupID'];
    ProductID = json['ProductID'];
    CustomerID = json['CustomerID'];
    IncentivePer = json['IncentivePer'];
    IncentiveAmt = json['IncentiveAmt'];
    LoginUserID = json['LoginUserID'];
    TargetType = json['TargetType'];
    Amount = json['Amount'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['EmployeeID'] = this.EmployeeID;
    data['FromDate'] = this.FromDate;
    data['ToDate'] = this.ToDate;
    data['TargetAmount'] = this.TargetAmount;
    data['BrandID'] = this.BrandID;
    data['ProductGroupID'] = this.ProductGroupID;
    data['ProductID'] = this.ProductID;
    data['CustomerID'] = this.CustomerID;
    data['IncentivePer'] = this.IncentivePer;
    data['IncentiveAmt'] = this.IncentiveAmt;
    data['LoginUserID'] = this.LoginUserID;
    data['TargetType'] = this.TargetType;
    data['Amount'] = this.Amount;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
