/*
pkID
InquiryNo
ContractType
SerialKey
StartDate
EndDate
CustomerID
EmployeeID
ContactPerson
IMEINo
Remarks
ContactNumber
ContractFooter
ContractTNC
Warranty
LoginUserID
CompanyId
*/

class MaintenanceAddEditRequest {
  String pkID;
  String InquiryNo;
  String ContractType;
  String SerialKey;
  String StartDate;
  String EndDate;
  String CustomerID;
  String EmployeeID;
  String ContactPerson;
  String IMEINo;
  String Remarks;
  String ContactNumber;
  String ContractFooter;
  String ContractTNC;
  String Warranty;
  String LoginUserID;
  String CompanyId;

  MaintenanceAddEditRequest({this.pkID, this.InquiryNo, this.ContractType,
      this.SerialKey, this.StartDate, this.EndDate, this.CustomerID,
      this.EmployeeID, this.ContactPerson, this.IMEINo, this.Remarks,
      this.ContactNumber, this.ContractFooter, this.ContractTNC, this.Warranty,
      this.LoginUserID, this.CompanyId});

  MaintenanceAddEditRequest.fromJson(Map<String, dynamic> json) {
    pkID = json["pkID"];
    InquiryNo = json["InquiryNo"];
    ContractType = json["ContractType"];
    SerialKey = json["SerialKey"];
    StartDate = json["StartDate"];
    EndDate = json["EndDate"];
    CustomerID = json["CustomerID"];
    EmployeeID = json["EmployeeID"];
    ContactPerson = json["ContactPerson"];
    IMEINo = json["IMEINo"];
    Remarks = json["Remarks"];
    ContactNumber = json["ContactNumber"];
    ContractFooter = json["ContractFooter"];
    ContractTNC = json["ContractTNC"];
    Warranty = json["Warranty"];
    LoginUserID = json["LoginUserID"];
    CompanyId = json["CompanyId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["pkID"] = this.pkID;
    data["InquiryNo"] = this.InquiryNo;
    data["ContractType"] = this.ContractType;
    data["SerialKey"] = this.SerialKey;
    data["StartDate"] = this.StartDate;
    data["EndDate"] = this.EndDate;
    data["CustomerID"] = this.CustomerID;
    data["EmployeeID"] = this.EmployeeID;
    data["ContactPerson"] = this.ContactPerson;
    data["IMEINo"] = this.IMEINo;
    data["Remarks"] = this.Remarks;
    data["ContactNumber"] = this.ContactNumber;
    data["ContractFooter"] = this.ContractFooter;
    data["ContractTNC"] = this.ContractTNC;
    data["Warranty"] = this.Warranty;
    data["LoginUserID"] = this.LoginUserID;
    data["CompanyId"] = this.CompanyId;

    return data;
  }
}
