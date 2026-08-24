/*
pkID:0
InwardNo:
InwardDate:
CustomerID:0
LocationID:1
BasicAmt:524
SGSTAmt:445
CGSTAmt:47
IGSTAmt:55
ROffAmt:77
NetAmt:44
ChallanNo:
InvoiceNo:
ModeOfTransport:
TransporterName:
VehicleNo:
LRNo:
LRDate:
TransportRemark:
ManuaLInwardNo:
ManuaLInwardDate:
LoginUserID:
CompanyId:7291
*/

class MaterialInwardMasterSaveRequest {
  String pkID;
  String InwardNo;
  String InwardDate;
  String CustomerID;
  String LocationID;
  String BasicAmt;
  String SGSTAmt;
  String CGSTAmt;
  String IGSTAmt;
  String ROffAmt;
  String NetAmt;
  String DiscountAmt;
  String ModeOfTransport;
  String TransporterName;
  String VehicleNo;
  String LRNo;
  String LRDate;
  String TransportRemark;
  String ManuaLInwardNo;
  String ManuaLInwardDate;
  String LoginUserID;
  String CompanyId;

  MaterialInwardMasterSaveRequest({
    this.pkID,
    this.InwardNo,
    this.InwardDate,
    this.CustomerID,
    this.LocationID,
    this.BasicAmt,
    this.SGSTAmt,
    this.CGSTAmt,
    this.IGSTAmt,
    this.ROffAmt,
    this.NetAmt,
    this.DiscountAmt,
    this.ModeOfTransport,
    this.TransporterName,
    this.VehicleNo,
    this.LRNo,
    this.LRDate,
    this.TransportRemark,
    this.ManuaLInwardNo,
    this.ManuaLInwardDate,
    this.LoginUserID,
    this.CompanyId,
  });

  MaterialInwardMasterSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    InwardNo = json['InwardNo'];
    InwardDate = json['InwardDate'];
    CustomerID = json['CustomerID'];
    LocationID = json['LocationID'];
    BasicAmt = json['BasicAmt'];
    SGSTAmt = json['SGSTAmt'];
    CGSTAmt = json['CGSTAmt'];
    IGSTAmt = json['IGSTAmt'];
    ROffAmt = json['ROffAmt'];
    NetAmt = json['NetAmt'];
    DiscountAmt = json['DiscountAmt'];
    ModeOfTransport = json['ModeOfTransport'];
    TransporterName = json['TransporterName'];
    VehicleNo = json['VehicleNo'];
    LRNo = json['LRNo'];
    LRDate = json['LRDate'];
    TransportRemark = json['TransportRemark'];
    ManuaLInwardNo = json['ManuaLInwardNo'];
    ManuaLInwardDate = json['ManuaLInwardDate'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['InwardNo'] = this.InwardNo;
    data['InwardDate'] = this.InwardDate;
    data['CustomerID'] = this.CustomerID;
    data['LocationID'] = this.LocationID;
    data['BasicAmt'] = this.BasicAmt;
    data['SGSTAmt'] = this.SGSTAmt;
    data['CGSTAmt'] = this.CGSTAmt;
    data['IGSTAmt'] = this.IGSTAmt;
    data['ROffAmt'] = this.ROffAmt;
    data['NetAmt'] = this.NetAmt;
    data['DiscountAmt'] = this.DiscountAmt;
    data['ModeOfTransport'] = this.ModeOfTransport;
    data['TransporterName'] = this.TransporterName;
    data['VehicleNo'] = this.VehicleNo;
    data['LRNo'] = this.LRNo;
    data['LRDate'] = this.LRDate;
    data['TransportRemark'] = this.TransportRemark;
    data['ManuaLInwardNo'] = this.ManuaLInwardNo;
    data['ManuaLInwardDate'] = this.ManuaLInwardDate;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
