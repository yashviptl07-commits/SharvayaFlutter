class MaintenanceProductModel {
  int id;
  String pkID;
  String InquiryNo;
  String ProductID;
  String ProductName;
  String UnitPrice;
  String TaxRate;
  String Quantity;
  String TotalAmount;
  String StartDate;
  String EndDate;
  String OrderNo;
  String SerialKey;
  String ContractMonth;
  String LoginUserID;
  String CompanyId;

  MaintenanceProductModel(
      this.pkID,
      this.InquiryNo,
      this.ProductID,
      this.ProductName,
      this.UnitPrice,
      this.TaxRate,
      this.Quantity,
      this.TotalAmount,
      this.StartDate,
      this.EndDate,
      this.OrderNo,
      this.SerialKey,
      this.ContractMonth,
      this.LoginUserID,
      this.CompanyId,
      {this.id}
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["pkID"] = this.pkID;
    data["InquiryNo"] = this.InquiryNo;
    data["ProductID"] = this.ProductID;
    data["ProductName"] = this.ProductName;
    data["UnitPrice"] = this.UnitPrice;
    data["TaxRate"] = this.TaxRate;
    data["Quantity"] = this.Quantity;
    data["TotalAmount"] = this.TotalAmount;
    data["StartDate"] = this.StartDate;
    data["EndDate"] = this.EndDate;
    data["OrderNo"] = this.OrderNo;
    data["SerialKey"] = this.SerialKey;
    data["ContractMonth"] = this.ContractMonth;
    data["LoginUserID"] = this.LoginUserID;
    data["CompanyId"] = this.CompanyId;

    return data;
  }

  @override
  String toString() {
    return 'MaintenanceProductModel{id: $id, pkID: $pkID, InquiryNo: $InquiryNo, ProductID: $ProductID, ProductName: $ProductName, UnitPrice: $UnitPrice, TaxRate: $TaxRate, Quantity: $Quantity, TotalAmount: $TotalAmount, StartDate: $StartDate, EndDate: $EndDate, OrderNo: $OrderNo, SerialKey: $SerialKey, ContractMonth: $ContractMonth, LoginUserID: $LoginUserID, CompanyId: $CompanyId}';
  }

}