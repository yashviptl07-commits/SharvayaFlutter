class ServiceReportListResponse {
  List<ServiceReportListResponseDetails> details;
  int totalCount;

  ServiceReportListResponse({this.details, this.totalCount});

  ServiceReportListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ServiceReportListResponseDetails.fromJson(v));
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

class ServiceReportListResponseDetails {
  int rowNum;
  int pkID;
  String serviceNo;
  String serviceDate;
  int customerID;
  String customerName;
  String machineModelNo;
  int machineID;
  String machineName;
  String operationType;
  String operationTypeMachine;
  String engineerNotes;
  String customerNotes;
  String machinePerformance;
  double conveyanceCharge;
  double travellingCharge;
  double componentsCharge;
  double serviceCharge;
  double totalCharges;
  String serviceRating;
  String createdBy;
  String createdDate;

  ServiceReportListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.serviceNo,
      this.serviceDate,
      this.customerID,
      this.customerName,
      this.machineModelNo,
      this.machineID,
      this.machineName,
      this.operationType,
      this.operationTypeMachine,
      this.engineerNotes,
      this.customerNotes,
      this.machinePerformance,
      this.conveyanceCharge,
      this.travellingCharge,
      this.componentsCharge,
      this.serviceCharge,
      this.totalCharges,
      this.serviceRating,
      this.createdBy,
      this.createdDate});

  ServiceReportListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    serviceNo = json['ServiceNo'];
    serviceDate = json['ServiceDate'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    machineModelNo = json['MachineModelNo'];
    machineID = json['MachineID'];
    machineName = json['MachineName'];
    operationType = json['OperationType'];
    operationTypeMachine = json['OperationTypeMachine'];
    engineerNotes = json['EngineerNotes'];
    customerNotes = json['CustomerNotes'];
    machinePerformance = json['MachinePerformance'];
    conveyanceCharge = json['ConveyanceCharge'];
    travellingCharge = json['TravellingCharge'];
    componentsCharge = json['ComponentsCharge'];
    serviceCharge = json['ServiceCharge'];
    totalCharges = json['TotalCharges'];
    serviceRating = json['ServiceRating'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ServiceNo'] = this.serviceNo;
    data['ServiceDate'] = this.serviceDate;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['MachineModelNo'] = this.machineModelNo;
    data['MachineID'] = this.machineID;
    data['MachineName'] = this.machineName;
    data['OperationType'] = this.operationType;
    data['OperationTypeMachine'] = this.operationTypeMachine;
    data['EngineerNotes'] = this.engineerNotes;
    data['CustomerNotes'] = this.customerNotes;
    data['MachinePerformance'] = this.machinePerformance;
    data['ConveyanceCharge'] = this.conveyanceCharge;
    data['TravellingCharge'] = this.travellingCharge;
    data['ComponentsCharge'] = this.componentsCharge;
    data['ServiceCharge'] = this.serviceCharge;
    data['TotalCharges'] = this.totalCharges;
    data['ServiceRating'] = this.serviceRating;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
