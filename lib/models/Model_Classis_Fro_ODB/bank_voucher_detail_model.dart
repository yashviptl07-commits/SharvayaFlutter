/*   pkID          :,
     ParentID      :10094,
     InvoiceNo     : "INV-2324-0008",
     Amount        : 1600.00,
     LoginUserID   : "admin",
     CompanyId     : 4132*/

class BankVoucherDetailsTable {
  int id;
  String pkID;
  String ParentID;
  String InvoiceNo;
  String Amount;
  String LoginUserID;
  String CompanyId;

  BankVoucherDetailsTable(this.pkID, this.ParentID, this.InvoiceNo, this.Amount,
      this.LoginUserID, this.CompanyId,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pkID'] = this.pkID;
    data['ParentID'] = this.ParentID;
    data['InvoiceNo'] = this.InvoiceNo;
    data['Amount'] = this.Amount;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }

  @override
  String toString() {
    return 'BankVoucherDetailsTable{id: $id, pkID: $pkID, ParentID: $ParentID, InvoiceNo: $InvoiceNo, Amount: $Amount, LoginUserID: $LoginUserID, CompanyId: $CompanyId}';
  }
}
