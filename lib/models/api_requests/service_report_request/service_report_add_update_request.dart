class ServiceReportAddUpdateRequest {
  String pkID;
  String ServiceNo;
  String ServiceDate;
  String CustomerID;
  String MachineID;
  String MachineModelNo;
  String OperationType;
  String OperationTypeMachine;
  String EngineerNotes;
  String CustomerNotes;
  String MachinePerformance;
  String ConveyanceCharge;
  String TravellingCharge;
  String ComponentsCharge;
  String ServiceCharge;
  String ServiceRating;
  String LoginUserID;
  String CompanyId;

  ServiceReportAddUpdateRequest({
    this.pkID,
    this.ServiceNo,
    this.ServiceDate,
    this.CustomerID,
    this.MachineID,
    this.MachineModelNo,
    this.OperationType,
    this.OperationTypeMachine,
    this.EngineerNotes,
    this.CustomerNotes,
    this.MachinePerformance,
    this.ConveyanceCharge,
    this.TravellingCharge,
    this.ComponentsCharge,
    this.ServiceCharge,
    this.ServiceRating,
    this.LoginUserID,
    this.CompanyId,
  });

  ServiceReportAddUpdateRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ServiceNo = json['ServiceNo'];
    ServiceDate = json['ServiceDate'];
    CustomerID = json['CustomerID'];
    MachineID = json['MachineID'];
    MachineModelNo = json['MachineModelNo'];
    OperationType = json['OperationType'];
    OperationTypeMachine = json['OperationTypeMachine'];
    EngineerNotes = json['EngineerNotes'];
    CustomerNotes = json['CustomerNotes'];
    MachinePerformance = json['MachinePerformance'];
    ConveyanceCharge = json['ConveyanceCharge'];
    TravellingCharge = json['TravellingCharge'];
    ComponentsCharge = json['ComponentsCharge'];
    ServiceCharge = json['ServiceCharge'];
    ServiceRating = json['ServiceRating'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pkID'] = this.pkID;
    data['ServiceNo'] = this.ServiceNo;
    data['ServiceDate'] = this.ServiceDate;
    data['CustomerID'] = this.CustomerID;
    data['MachineID'] = this.MachineID;
    data['MachineModelNo'] = this.MachineModelNo;
    data['OperationType'] = this.OperationType;
    data['OperationTypeMachine'] = this.OperationTypeMachine;
    data['EngineerNotes'] = this.EngineerNotes;
    data['CustomerNotes'] = this.CustomerNotes;
    data['MachinePerformance'] = this.MachinePerformance;
    data['ConveyanceCharge'] = this.ConveyanceCharge;
    data['TravellingCharge'] = this.TravellingCharge;
    data['ComponentsCharge'] = this.ComponentsCharge;
    data['ServiceCharge'] = this.ServiceCharge;
    data['ServiceRating'] = this.ServiceRating;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
