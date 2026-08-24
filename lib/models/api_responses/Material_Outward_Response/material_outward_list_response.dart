class MaterialOutwardListMainResponse {
  List<MaterialOutwardListMainResponseDetails> details;
  int totalCount;

  MaterialOutwardListMainResponse({this.details, this.totalCount});

  MaterialOutwardListMainResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MaterialOutwardListMainResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class MaterialOutwardListMainResponseDetails {
  int rowNum;
  int pkID;
  String outwardNo;
  String outwardDate;
  String orderNo;
  String orderStatus;
  String exporterRef;
  String supOrderRef;
  String supOrderDate;
  String otherRef;
  String referenceNo;
  String docRefNoList;
  int customerID;
  String customerName;
  int locationID;
  String address;
  String area;
  String pinCode;
  String city;
  String emailAddress;
  String contactNo1;
  String contactNo2;
  double basicAmt;
  double sGSTAmt;
  double cGSTAmt;
  double iGSTAmt;
  double rOffAmt;
  double netAmt;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String createdEmployeeName;
  String updatedEmployeeName;
  double basicAmount;
  double taxAmount;
  double outwardAmount;
  String modeOfTransport;
  String transporterName;
  String vehicleNo;
  String lRNo;
  String lRDate;
  String dCNo;
  String dCDate;
  String deliveryNote;
  String remarks;
  String manualOutwardNo;
  String accApprovedBy;
  String accApprovalStatus;
  String accApprovedDate;
  String salesApprovedBy;
  String salesApprovalStatus;
  String salesApprovedDate;
  String dispatchApprovedBy;
  String dispatchApprovalStatus;
  String dispatchApprovedDate;
  int stateCode;

  MaterialOutwardListMainResponseDetails({
    this.rowNum,
    this.pkID,
    this.outwardNo,
    this.outwardDate,
    this.orderNo,
    this.orderStatus,
    this.exporterRef,
    this.supOrderRef,
    this.supOrderDate,
    this.otherRef,
    this.referenceNo,
    this.docRefNoList,
    this.customerID,
    this.customerName,
    this.locationID,
    this.address,
    this.area,
    this.pinCode,
    this.city,
    this.emailAddress,
    this.contactNo1,
    this.contactNo2,
    this.basicAmt,
    this.sGSTAmt,
    this.cGSTAmt,
    this.iGSTAmt,
    this.rOffAmt,
    this.netAmt,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.createdEmployeeName,
    this.updatedEmployeeName,
    this.basicAmount,
    this.taxAmount,
    this.outwardAmount,
    this.modeOfTransport,
    this.transporterName,
    this.vehicleNo,
    this.lRNo,
    this.lRDate,
    this.dCNo,
    this.dCDate,
    this.deliveryNote,
    this.remarks,
    this.manualOutwardNo,
    this.accApprovedBy,
    this.accApprovalStatus,
    this.accApprovedDate,
    this.salesApprovedBy,
    this.salesApprovalStatus,
    this.salesApprovedDate,
    this.dispatchApprovedBy,
    this.dispatchApprovalStatus,
    this.dispatchApprovedDate,
    this.stateCode,
  });

  MaterialOutwardListMainResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    outwardNo = json['OutwardNo'];
    outwardDate = json['OutwardDate'];
    orderNo = json['OrderNo'];
    orderStatus = json['OrderStatus'];
    exporterRef = json['ExporterRef'];
    supOrderRef = json['SupOrderRef'];
    supOrderDate = json['SupOrderDate'];
    otherRef = json['OtherRef'];
    referenceNo = json['ReferenceNo'];
    docRefNoList = json['DocRefNoList'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    locationID = json['LocationID'];
    address = json['Address'];
    area = json['Area'];
    pinCode = json['PinCode'];
    city = json['City'];
    emailAddress = json['EmailAddress'];
    contactNo1 = json['ContactNo1'];
    contactNo2 = json['ContactNo2'];
    basicAmt = json['BasicAmt'];
    sGSTAmt = json['SGSTAmt'];
    cGSTAmt = json['CGSTAmt'];
    iGSTAmt = json['IGSTAmt'];
    rOffAmt = json['ROffAmt'];
    netAmt = json['NetAmt'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    createdEmployeeName = json['CreatedEmployeeName'];
    updatedEmployeeName = json['UpdatedEmployeeName'];
    basicAmount = json['BasicAmount'];
    taxAmount = json['TaxAmount'];
    outwardAmount = json['OutwardAmount'];
    modeOfTransport = json['ModeOfTransport'];
    transporterName = json['TransporterName'];
    vehicleNo = json['VehicleNo'];
    lRNo = json['LRNo'];
    lRDate = json['LRDate'];
    dCNo = json['DCNo'];
    dCDate = json['DCDate'];
    deliveryNote = json['DeliveryNote'];
    remarks = json['Remarks'];
    manualOutwardNo = json['ManualOutwardNo'];
    accApprovedBy = json['AccApprovedBy'];
    accApprovalStatus = json['AccApprovalStatus'];
    accApprovedDate = json['AccApprovedDate'];
    salesApprovedBy = json['SalesApprovedBy'];
    salesApprovalStatus = json['SalesApprovalStatus'];
    salesApprovedDate = json['SalesApprovedDate'];
    dispatchApprovedBy = json['DispatchApprovedBy'];
    dispatchApprovalStatus = json['DispatchApprovalStatus'];
    dispatchApprovedDate = json['DispatchApprovedDate'];
    stateCode = json['StateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['OutwardNo'] = this.outwardNo;
    data['OutwardDate'] = this.outwardDate;
    data['OrderNo'] = this.orderNo;
    data['OrderStatus'] = this.orderStatus;
    data['ExporterRef'] = this.exporterRef;
    data['SupOrderRef'] = this.supOrderRef;
    data['SupOrderDate'] = this.supOrderDate;
    data['OtherRef'] = this.otherRef;
    data['ReferenceNo'] = this.referenceNo;
    data['DocRefNoList'] = this.docRefNoList;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['LocationID'] = this.locationID;
    data['Address'] = this.address;
    data['Area'] = this.area;
    data['PinCode'] = this.pinCode;
    data['City'] = this.city;
    data['EmailAddress'] = this.emailAddress;
    data['ContactNo1'] = this.contactNo1;
    data['ContactNo2'] = this.contactNo2;
    data['BasicAmt'] = this.basicAmt;
    data['SGSTAmt'] = this.sGSTAmt;
    data['CGSTAmt'] = this.cGSTAmt;
    data['IGSTAmt'] = this.iGSTAmt;
    data['ROffAmt'] = this.rOffAmt;
    data['NetAmt'] = this.netAmt;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['UpdatedEmployeeName'] = this.updatedEmployeeName;
    data['BasicAmount'] = this.basicAmount;
    data['TaxAmount'] = this.taxAmount;
    data['OutwardAmount'] = this.outwardAmount;
    data['ModeOfTransport'] = this.modeOfTransport;
    data['TransporterName'] = this.transporterName;
    data['VehicleNo'] = this.vehicleNo;
    data['LRNo'] = this.lRNo;
    data['LRDate'] = this.lRDate;
    data['DCNo'] = this.dCNo;
    data['DCDate'] = this.dCDate;
    data['DeliveryNote'] = this.deliveryNote;
    data['Remarks'] = this.remarks;
    data['ManualOutwardNo'] = this.manualOutwardNo;
    data['AccApprovedBy'] = this.accApprovedBy;
    data['AccApprovalStatus'] = this.accApprovalStatus;
    data['AccApprovedDate'] = this.accApprovedDate;
    data['SalesApprovedBy'] = this.salesApprovedBy;
    data['SalesApprovalStatus'] = this.salesApprovalStatus;
    data['SalesApprovedDate'] = this.salesApprovedDate;
    data['DispatchApprovedBy'] = this.dispatchApprovedBy;
    data['DispatchApprovalStatus'] = this.dispatchApprovalStatus;
    data['DispatchApprovedDate'] = this.dispatchApprovedDate;
    data['StateCode'] = this.stateCode;
    return data;
  }
}
