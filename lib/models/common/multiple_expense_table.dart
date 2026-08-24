import 'dart:io';

class MultipleExpenseTable {
  int id;
  String pkID;
  String RefpkID;
  String ExpenseTypeId;
  String Amount;
  String Remarks;
  String ToLocation;
  String FromLocation;
  File Voucher;
  String ExpenseDateDetail;
  String LoginUserID;
  String CompanyId;
  String ExpenseTypeName;

  MultipleExpenseTable(
      this.pkID,
      this.RefpkID,
      this.ExpenseTypeId,
      this.Amount,
      this.Remarks,
      this.ToLocation,
      this.FromLocation,
      this.Voucher,
      this.ExpenseDateDetail,
      this.LoginUserID,
      this.CompanyId,
      this.ExpenseTypeName,
      {this.id});

  /// Convert to JSON/Map for SQLite
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "pkID": pkID,
      "RefpkID": RefpkID,
      "ExpenseTypeId": ExpenseTypeId,
      "Amount": Amount,
      "Remarks": Remarks,
      "ToLocation": ToLocation,
      "FromLocation": FromLocation,
      "Voucher": Voucher?.path, // store path only
      "ExpenseDateDetail": ExpenseDateDetail,
      "LoginUserID": LoginUserID,
      "CompanyId": CompanyId,
      "ExpenseTypeName": ExpenseTypeName,
    };
  }

  /// Create object from DB Map
  factory MultipleExpenseTable.fromJson(Map<String, dynamic> json) {
    return MultipleExpenseTable(
      json["pkID"] ?? "",
      json["RefpkID"] ?? "",
      json["ExpenseTypeId"] ?? "",
      json["Amount"] ?? "",
      json["Remarks"] ?? "",
      json["ToLocation"] ?? "",
      json["FromLocation"] ?? "",
      json["Voucher"] != null && json["Voucher"].toString().isNotEmpty
          ? File(json["Voucher"])
          : null,
      json["ExpenseDateDetail"] ?? "",
      json["LoginUserID"] ?? "",
      json["CompanyId"] ?? "",
      json["ExpenseTypeName"] ?? "",
      id: json["id"],
    );
  }

  @override
  String toString() {
    return 'MultipleExpenseTable{id: $id, pkID: $pkID, RefpkID: $RefpkID, ExpenseTypeId: $ExpenseTypeId, Amount: $Amount, Remarks: $Remarks, ToLocation: $ToLocation, FromLocation: $FromLocation, Voucher: $Voucher, ExpenseDateDetail: $ExpenseDateDetail, LoginUserID: $LoginUserID, CompanyId: $CompanyId, ExpenseTypeName: $ExpenseTypeName}';
  }
}
