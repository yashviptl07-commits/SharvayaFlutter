/*
pkID
OutwardNo
OutwardDate
CustomerID
LocationID
ExporterRef
SupOrderRef
SupOrderDate
OtherRef
OrderNo
OrderStatus
ModeOfTransport
TransporterName
VehicleNo
LRNo
LRDate
DCNo
DCDate
DeliveryNote
Remarks
BasicAmt
SGSTAmt
CGSTAmt
IGSTAmt
ROffAmt
NetAmt
LoginUserID
CompanyId
*/

class MaterialOutwardAddUpdateRequest {
  String pkID;
  String OutwardNo;
  String OutwardDate;
  String CustomerID;
  String LocationID;
  String ExporterRef;
  String SupOrderRef;
  String SupOrderDate;
  String OtherRef;
  String OrderNo;
  String OrderStatus;
  String ModeOfTransport;
  String TransporterName;
  String VehicleNo;
  String LRNo;
  String LRDate;
  String DCNo;
  String DCDate;
  String DeliveryNote;
  String Remarks;
  String BasicAmt;
  String SGSTAmt;
  String CGSTAmt;
  String IGSTAmt;
  String ROffAmt;
  String NetAmt;
  String LoginUserID;
  String CompanyId;

  MaterialOutwardAddUpdateRequest({
      this.pkID,
      this.OutwardNo,
      this.OutwardDate,
      this.CustomerID,
      this.LocationID,
      this.ExporterRef,
      this.SupOrderRef,
      this.SupOrderDate,
      this.OtherRef,
      this.OrderNo,
      this.OrderStatus,
      this.ModeOfTransport,
      this.TransporterName,
      this.VehicleNo,
      this.LRNo,
      this.LRDate,
      this.DCNo,
      this.DCDate,
      this.DeliveryNote,
      this.Remarks,
      this.BasicAmt,
      this.SGSTAmt,
      this.CGSTAmt,
      this.IGSTAmt,
      this.ROffAmt,
      this.NetAmt,
      this.LoginUserID,
      this.CompanyId});


  MaterialOutwardAddUpdateRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    OutwardNo = json['OutwardNo'];
    OutwardDate = json['OutwardDate'];
    CustomerID = json['CustomerID'];
    LocationID = json['LocationID'];
    ExporterRef = json['ExporterRef'];
    SupOrderRef = json['SupOrderRef'];
    SupOrderDate = json['SupOrderDate'];
    OtherRef = json['OtherRef'];
    OrderNo = json['OrderNo'];
    OrderStatus = json['OrderStatus'];
    ModeOfTransport = json['ModeOfTransport'];
    TransporterName = json['TransporterName'];
    VehicleNo = json['VehicleNo'];
    LRNo = json['LRNo'];
    LRDate = json['LRDate'];
    DCNo = json['DCNo'];
    DCDate = json['DCDate'];
    DeliveryNote = json['DeliveryNote'];
    Remarks = json['Remarks'];
    BasicAmt = json['BasicAmt'];
    SGSTAmt = json['SGSTAmt'];
    CGSTAmt = json['CGSTAmt'];
    IGSTAmt = json['IGSTAmt'];
    ROffAmt = json['ROffAmt'];
    NetAmt = json['NetAmt'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['OutwardNo'] = this.OutwardNo;
    data['OutwardDate'] = this.OutwardDate;
    data['CustomerID'] = this.CustomerID;
    data['LocationID'] = this.LocationID;
    data['ExporterRef'] = this.ExporterRef;
    data['SupOrderRef'] = this.SupOrderRef;
    data['SupOrderDate'] = this.SupOrderDate;
    data['OtherRef'] = this.OtherRef;
    data['OrderNo'] = this.OrderNo;
    data['OrderStatus'] = this.OrderStatus;
    data['ModeOfTransport'] = this.ModeOfTransport;
    data['TransporterName'] = this.TransporterName;
    data['VehicleNo'] = this.VehicleNo;
    data['LRNo'] = this.LRNo;
    data['LRDate'] = this.LRDate;
    data['DCNo'] = this.DCNo;
    data['DCDate'] = this.DCDate;
    data['DeliveryNote'] = this.DeliveryNote;
    data['Remarks'] = this.Remarks;
    data['BasicAmt'] = this.BasicAmt;
    data['SGSTAmt'] = this.SGSTAmt;
    data['CGSTAmt'] = this.CGSTAmt;
    data['IGSTAmt'] = this.IGSTAmt;
    data['ROffAmt'] = this.ROffAmt;
    data['NetAmt'] = this.NetAmt;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
