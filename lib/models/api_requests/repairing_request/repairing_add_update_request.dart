/*
pkID
RepairingNo
RepairingDate
CustomerID
PrimaryMobileNo
AlternateMobileNo
ProductID
IMEINo
DeliveryDate
AccessPattern
AccessPin
ProblemNotes
RepairingNotes
EmployeeID
Amount
LoginUserID
ContractFooter
RepairingStage
AssignTo
CompanyId
*/

class RepairingAddEditRequest {
  String pkID;
  String RepairingNo;
  String RepairingDate;
  String CustomerID;
  String PrimaryMobileNo;
  String AlternateMobileNo;
  String ProductID;
  String IMEINo;
  String DeliveryDate;
  String AccessPattern;
  String AccessPin;
  String ProblemNotes;
  String RepairingNotes;
  String EmployeeID;
  String Amount;
  String LoginUserID;
  String ContractFooter;
  String RepairingStage;
  String AssignTo;
  String CompanyId;

  RepairingAddEditRequest({this.pkID, this.RepairingNo, this.RepairingDate,
      this.CustomerID, this.PrimaryMobileNo, this.AlternateMobileNo,
      this.ProductID, this.IMEINo, this.DeliveryDate, this.AccessPattern,
      this.AccessPin, this.ProblemNotes, this.RepairingNotes, this.EmployeeID,
      this.Amount, this.LoginUserID, this.ContractFooter, this.RepairingStage,
      this.AssignTo, this.CompanyId});

  RepairingAddEditRequest.fromJson(Map<String, dynamic> json) {
    pkID = json["pkID"];
    RepairingNo = json["RepairingNo"];
    RepairingDate = json["RepairingDate"];
    CustomerID = json["CustomerID"];
    PrimaryMobileNo = json["PrimaryMobileNo"];
    AlternateMobileNo = json["AlternateMobileNo"];
    ProductID = json["ProductID"];
    IMEINo = json["IMEINo"];
    DeliveryDate = json["DeliveryDate"];
    AccessPattern = json["AccessPattern"];
    AccessPin = json["AccessPin"];
    ProblemNotes = json["ProblemNotes"];
    RepairingNotes = json["RepairingNotes"];
    EmployeeID = json["EmployeeID"];
    Amount = json["Amount"];
    LoginUserID = json["LoginUserID"];
    ContractFooter = json["ContractFooter"];
    RepairingStage = json["RepairingStage"];
    AssignTo = json["AssignTo"];
    CompanyId = json["CompanyId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["pkID"] = this.pkID;
    data["RepairingNo"] = this.RepairingNo;
    data["RepairingDate"] = this.RepairingDate;
    data["CustomerID"] = this.CustomerID;
    data["PrimaryMobileNo"] = this.PrimaryMobileNo;
    data["AlternateMobileNo"] = this.AlternateMobileNo;
    data["ProductID"] = this.ProductID;
    data["IMEINo"] = this.IMEINo;
    data["DeliveryDate"] = this.DeliveryDate;
    data["AccessPattern"] = this.AccessPattern;
    data["AccessPin"] = this.AccessPin;
    data["ProblemNotes"] = this.ProblemNotes;
    data["RepairingNotes"] = this.RepairingNotes;
    data["EmployeeID"] = this.EmployeeID;
    data["Amount"] = this.Amount;
    data["LoginUserID"] = this.LoginUserID;
    data["ContractFooter"] = this.ContractFooter;
    data["RepairingStage"] = this.RepairingStage;
    data["AssignTo"] = this.AssignTo;
    data["CompanyId"] = this.CompanyId;

    return data;
  }
}
