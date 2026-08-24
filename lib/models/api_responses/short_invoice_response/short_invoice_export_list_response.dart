class ShortInvoiceExportListResponse {
  List<ShortInvoiceExportListResponseDetails> details;
  int totalCount;

  ShortInvoiceExportListResponse({this.details, this.totalCount});

  ShortInvoiceExportListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ShortInvoiceExportListResponseDetails.fromJson(v));
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

class ShortInvoiceExportListResponseDetails {
  int rowNum;
  int pkID;
  String invoiceNo;
  String preCarrBy;
  String preCarrRecPlace;
  String flightNo;
  String portOfLoading;
  String portOfDispatch;
  String portOfDestination;
  String marksNo;
  String packages;
  String packageType;
  String netWeight;
  String grossWeight;
  String freeOnBoard;
  int customerID;
  String customerName;
  String createdBy;
  String createdDate;
  String createdEmployeeName;
  int companyID;

  ShortInvoiceExportListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.invoiceNo,
      this.preCarrBy,
      this.preCarrRecPlace,
      this.flightNo,
      this.portOfLoading,
      this.portOfDispatch,
      this.portOfDestination,
      this.marksNo,
      this.packages,
      this.packageType,
      this.netWeight,
      this.grossWeight,
      this.freeOnBoard,
      this.customerID,
      this.customerName,
      this.createdBy,
      this.createdDate,
      this.createdEmployeeName,
      this.companyID});

  ShortInvoiceExportListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    invoiceNo = json['InvoiceNo'];
    preCarrBy = json['PreCarrBy'];
    preCarrRecPlace = json['PreCarrRecPlace'];
    flightNo = json['FlightNo'];
    portOfLoading = json['PortOfLoading'];
    portOfDispatch = json['PortOfDispatch'];
    portOfDestination = json['PortOfDestination'];
    marksNo = json['MarksNo'];
    packages = json['Packages'];
    packageType = json['PackageType'];
    netWeight = json['NetWeight'];
    grossWeight = json['GrossWeight'];
    freeOnBoard = json['FreeOnBoard'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    createdEmployeeName = json['CreatedEmployeeName'];
    companyID = json['CompanyID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.invoiceNo;
    data['PreCarrBy'] = this.preCarrBy;
    data['PreCarrRecPlace'] = this.preCarrRecPlace;
    data['FlightNo'] = this.flightNo;
    data['PortOfLoading'] = this.portOfLoading;
    data['PortOfDispatch'] = this.portOfDispatch;
    data['PortOfDestination'] = this.portOfDestination;
    data['MarksNo'] = this.marksNo;
    data['Packages'] = this.packages;
    data['PackageType'] = this.packageType;
    data['NetWeight'] = this.netWeight;
    data['GrossWeight'] = this.grossWeight;
    data['FreeOnBoard'] = this.freeOnBoard;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['CompanyID'] = this.companyID;
    return data;
  }
}
