/*
pkID                       :          10094
VoucherType                :   Bank
RecPay                     :Receivable
VoucherNo                  :V-JUL23-002
VoucherDate                :2023-07-31
AccountID                  :141853
CustomerID                 :141852
TDSAccountID               :0
TransType                  :acc
TransModeID                :2
TransID                    :A8S9D489SA
EmployeeID                 :0
TransDate                  :2023-07-31
TDSAmount                  :0
VoucherAmount              :1800.00
BankName                   :Kotak Mahindra Bank
Remark                     :1ST PAYMENT RECVD
RDURD                      :
BasicAmt                   :1800.00
NetAmt                     :1800.00
SGSTPer                    :0.00
SGSTAmt                    :0.00
CGSTPer                    :0.00
CGSTAmt                    :0.00
IGSTPer                    :0.00
IGSTAmt                    :0.00
LoginUserID                :admin
CompanyId                  :4132
TerminationOfDelivery      :0*/

class MayankBankVoucherAddEditRequest {
  String pkID;
  String VoucherType;
  String RecPay;
  String VoucherNo;
  String VoucherDate;
  String AccountID;
  String CustomerID;
  String TDSAccountID;
  String TransType;
  String TransModeID;
  String TransID;
  String EmployeeID;
  String TransDate;
  String TDSAmount;
  String VoucherAmount;
  String BankName;
  String Remark;
  String RDURD;
  String BasicAmt;
  String NetAmt;
  String SGSTPer;
  String SGSTAmt;
  String CGSTPer;
  String CGSTAmt;
  String IGSTPer;
  String IGSTAmt;
  String LoginUserID;
  String CompanyId;
  String TerminationOfDelivery;

  MayankBankVoucherAddEditRequest(
      {this.pkID,
      this.VoucherType,
      this.RecPay,
      this.VoucherNo,
      this.VoucherDate,
      this.AccountID,
      this.CustomerID,
      this.TDSAccountID,
      this.TransType,
      this.TransModeID,
      this.TransID,
      this.EmployeeID,
      this.TransDate,
      this.TDSAmount,
      this.VoucherAmount,
      this.BankName,
      this.Remark,
      this.RDURD,
      this.BasicAmt,
      this.NetAmt,
      this.SGSTPer,
      this.SGSTAmt,
      this.CGSTPer,
      this.CGSTAmt,
      this.IGSTPer,
      this.IGSTAmt,
      this.LoginUserID,
      this.CompanyId,
      this.TerminationOfDelivery});

  MayankBankVoucherAddEditRequest.fromJson(Map<String, dynamic> json) {
    pkID = json["pkID"];
    VoucherType = json["VoucherType"];
    RecPay = json["RecPay"];
    VoucherNo = json["VoucherNo"];
    VoucherDate = json["VoucherDate"];
    AccountID = json["AccountID"];
    CustomerID = json["CustomerID"];
    TDSAccountID = json["TDSAccountID"];
    TransType = json["TransType"];
    TransModeID = json["TransModeID"];
    TransID = json["TransID"];
    EmployeeID = json["EmployeeID"];
    TransDate = json["TransDate"];
    TDSAmount = json["TDSAmount"];
    VoucherAmount = json["VoucherAmount"];
    BankName = json["BankName"];
    Remark = json["Remark"];
    RDURD = json["RDURD"];
    BasicAmt = json["BasicAmt"];
    NetAmt = json["NetAmt"];
    SGSTPer = json["SGSTPer"];
    SGSTAmt = json["SGSTAmt"];
    CGSTPer = json["CGSTPer"];
    CGSTAmt = json["CGSTAmt"];
    IGSTPer = json["IGSTPer"];
    IGSTAmt = json["IGSTAmt"];
    LoginUserID = json["LoginUserID"];
    CompanyId = json["CompanyId"];
    TerminationOfDelivery = json["TerminationOfDelivery"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["pkID"] = this.pkID;
    data["VoucherType"] = this.VoucherType;
    data["RecPay"] = this.RecPay;
    data["VoucherNo"] = this.VoucherNo;
    data["VoucherDate"] = this.VoucherDate;
    data["AccountID"] = this.AccountID;
    data["CustomerID"] = this.CustomerID;
    data["TDSAccountID"] = this.TDSAccountID;
    data["TransType"] = this.TransType;
    data["TransModeID"] = this.TransModeID;
    data["TransID"] = this.TransID;
    data["EmployeeID"] = this.EmployeeID;
    data["TransDate"] = this.TransDate;
    data["TDSAmount"] = this.TDSAmount;
    data["VoucherAmount"] = this.VoucherAmount;
    data["BankName"] = this.BankName;
    data["Remark"] = this.Remark;
    data["RDURD"] = this.RDURD;
    data["BasicAmt"] = this.BasicAmt;
    data["NetAmt"] = this.NetAmt;
    data["SGSTPer"] = this.SGSTPer;
    data["SGSTAmt"] = this.SGSTAmt;
    data["CGSTPer"] = this.CGSTPer;
    data["CGSTAmt"] = this.CGSTAmt;
    data["IGSTPer"] = this.IGSTPer;
    data["IGSTAmt"] = this.IGSTAmt;
    data["LoginUserID"] = this.LoginUserID;
    data["CompanyId"] = this.CompanyId;
    data["TerminationOfDelivery"] = this.TerminationOfDelivery;

    return data;
  }
}
