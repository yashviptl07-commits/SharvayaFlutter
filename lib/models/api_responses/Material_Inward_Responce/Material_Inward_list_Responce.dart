class MaterialInwardListMeetResponse {
  List<MaterialInwardListMeetResponseDetails> details;
  int totalCount;

  MaterialInwardListMeetResponse({this.details, this.totalCount});

  MaterialInwardListMeetResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MaterialInwardListMeetResponseDetails.fromJson(v));
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

class MaterialInwardListMeetResponseDetails {
  int rowNum;
  int pkID;
  String inwardNo;
  String inwardDate;
  String manualInwardDate;
  String docRefNoList;
  int customerID;
  String customerName;
  int locationID;
  String locationName;
  String address;
  String area;
  String pinCode;
  String city;
  String emailAddress;
  String contactNo1;
  String contactNo2;
  String invoiceNo;
  String challanNo;
  double basicAmt;
  double discountAmt;
  double taxAmt;
  double rOffAmt;
  double netAmt;
  double sGSTAmt;
  double cGSTAmt;
  double iGSTAmt;
  String modeOfTransport;
  String transporterName;
  String vehicleNo;
  String lRNo;
  String lRDate;
  String transportRemark;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String createdEmployeeName;
  String updatedEmployeeName;
  double basicAmount;
  double taxAmount;
  double inwardAmount;
  String manuaLInwardNo;
  int stateCode;

  MaterialInwardListMeetResponseDetails(
      {this.rowNum,
      this.pkID,
      this.inwardNo,
      this.inwardDate,
      this.manualInwardDate,
      this.docRefNoList,
      this.customerID,
      this.customerName,
      this.locationID,
      this.locationName,
      this.address,
      this.area,
      this.pinCode,
      this.city,
      this.emailAddress,
      this.contactNo1,
      this.contactNo2,
      this.invoiceNo,
      this.challanNo,
      this.basicAmt,
      this.discountAmt,
      this.taxAmt,
      this.rOffAmt,
      this.netAmt,
      this.sGSTAmt,
      this.cGSTAmt,
      this.iGSTAmt,
      this.modeOfTransport,
      this.transporterName,
      this.vehicleNo,
      this.lRNo,
      this.lRDate,
      this.transportRemark,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.createdEmployeeName,
      this.updatedEmployeeName,
      this.basicAmount,
      this.taxAmount,
      this.inwardAmount,
      this.manuaLInwardNo,
      this.stateCode,
      });

  MaterialInwardListMeetResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    inwardNo = json['InwardNo'];
    inwardDate = json['InwardDate'];
    manualInwardDate = json['ManualInwardDate'];
    docRefNoList = json['DocRefNoList'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    locationID = json['LocationID'];
    locationName = json['LocationName'];
    address = json['Address'];
    area = json['Area'];
    pinCode = json['PinCode'];
    city = json['City'];
    emailAddress = json['EmailAddress'];
    contactNo1 = json['ContactNo1'];
    contactNo2 = json['ContactNo2'];
    invoiceNo = json['InvoiceNo'];
    challanNo = json['ChallanNo'];
    basicAmt = json['BasicAmt'];
    discountAmt = json['DiscountAmt'];
    taxAmt = json['TaxAmt'];
    rOffAmt = json['ROffAmt'];
    netAmt = json['NetAmt'];
    sGSTAmt = json['SGSTAmt'];
    cGSTAmt = json['CGSTAmt'];
    iGSTAmt = json['IGSTAmt'];
    modeOfTransport = json['ModeOfTransport'];
    transporterName = json['TransporterName'];
    vehicleNo = json['VehicleNo'];
    lRNo = json['LRNo'];
    lRDate = json['LRDate'];
    transportRemark = json['TransportRemark'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    createdEmployeeName = json['CreatedEmployeeName'];
    updatedEmployeeName = json['UpdatedEmployeeName'];
    basicAmount = json['BasicAmount'];
    taxAmount = json['TaxAmount'];
    inwardAmount = json['InwardAmount'];
    manuaLInwardNo = json['ManuaLInwardNo'];
    stateCode = json['StateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InwardNo'] = this.inwardNo;
    data['InwardDate'] = this.inwardDate;
    data['ManualInwardDate'] = this.manualInwardDate;
    data['DocRefNoList'] = this.docRefNoList;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['LocationID'] = this.locationID;
    data['LocationName'] = this.locationName;
    data['Address'] = this.address;
    data['Area'] = this.area;
    data['PinCode'] = this.pinCode;
    data['City'] = this.city;
    data['EmailAddress'] = this.emailAddress;
    data['ContactNo1'] = this.contactNo1;
    data['ContactNo2'] = this.contactNo2;
    data['InvoiceNo'] = this.invoiceNo;
    data['ChallanNo'] = this.challanNo;
    data['BasicAmt'] = this.basicAmt;
    data['DiscountAmt'] = this.discountAmt;
    data['TaxAmt'] = this.taxAmt;
    data['ROffAmt'] = this.rOffAmt;
    data['NetAmt'] = this.netAmt;
    data['SGSTAmt'] = this.sGSTAmt;
    data['CGSTAmt'] = this.cGSTAmt;
    data['IGSTAmt'] = this.iGSTAmt;
    data['ModeOfTransport'] = this.modeOfTransport;
    data['TransporterName'] = this.transporterName;
    data['VehicleNo'] = this.vehicleNo;
    data['LRNo'] = this.lRNo;
    data['LRDate'] = this.lRDate;
    data['TransportRemark'] = this.transportRemark;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['UpdatedEmployeeName'] = this.updatedEmployeeName;
    data['BasicAmount'] = this.basicAmount;
    data['TaxAmount'] = this.taxAmount;
    data['InwardAmount'] = this.inwardAmount;
    data['ManuaLInwardNo'] = this.manuaLInwardNo;
    data['StateCode'] = this.stateCode;
    return data;
  }
}
