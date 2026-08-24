class MudraAssignToResponse {
  List<Details> details;
  int totalCount;

  MudraAssignToResponse({this.details, this.totalCount});

  MudraAssignToResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
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

class Details {
  int rowNum;
  int pkID;
  String employeeName;
  String cardNo;
  String mobileNo;
  String landline;
  String emailAddress;
  String emailPassword;
  String gender;
  int workingHours;
  int shiftCode;
  String shiftName;
  String basicPer;
  String desigCode;
  String designation;
  String employeeImage;
  String orgCode;
  String orgName;
  dynamic empCode;
  int reportTo;
  String reportToEmployeeName;
  dynamic fixedSalary;
  dynamic fixedBasic;
  dynamic fixedHRA;
  dynamic fixedConv;
  dynamic fixedDA;
  dynamic fixedSpecial;
  String birthDate;
  String confirmationDate;
  String joinDate;
  dynamic releaseDate;
  String authorizedSign;
  String drivingLicenseNo;
  String passportNo;
  String aadharCardNo;
  String pANCardNo;
  dynamic pFCalculation;
  dynamic pTCalculation;
  dynamic eSICalculation;
  String eSignaturePath;
  String bankName;
  String bankBranch;
  String bankAccountNo;
  String bankIFSC;

  Details(
      {this.rowNum,
      this.pkID,
      this.employeeName,
      this.cardNo,
      this.mobileNo,
      this.landline,
      this.emailAddress,
      this.emailPassword,
      this.gender,
      this.workingHours,
      this.shiftCode,
      this.shiftName,
      this.basicPer,
      this.desigCode,
      this.designation,
      this.employeeImage,
      this.orgCode,
      this.orgName,
      this.empCode,
      this.reportTo,
      this.reportToEmployeeName,
      this.fixedSalary,
      this.fixedBasic,
      this.fixedHRA,
      this.fixedConv,
      this.fixedDA,
      this.fixedSpecial,
      this.birthDate,
      this.confirmationDate,
      this.joinDate,
      this.releaseDate,
      this.authorizedSign,
      this.drivingLicenseNo,
      this.passportNo,
      this.aadharCardNo,
      this.pANCardNo,
      this.pFCalculation,
      this.pTCalculation,
      this.eSICalculation,
      this.eSignaturePath,
      this.bankName,
      this.bankBranch,
      this.bankAccountNo,
      this.bankIFSC});

  Details.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    employeeName = json['EmployeeName'];
    cardNo = json['CardNo'];
    mobileNo = json['MobileNo'];
    landline = json['Landline'];
    emailAddress = json['EmailAddress'];
    emailPassword = json['EmailPassword'];
    gender = json['Gender'];
    workingHours = json['WorkingHours'];
    shiftCode = json['ShiftCode'];
    shiftName = json['ShiftName'];
    basicPer = json['BasicPer'];
    desigCode = json['DesigCode'];
    designation = json['Designation'];
    employeeImage = json['EmployeeImage'];
    orgCode = json['OrgCode'];
    orgName = json['OrgName'];
    empCode = json['EmpCode'];
    reportTo = json['ReportTo'];
    reportToEmployeeName = json['ReportToEmployeeName'];
    fixedSalary = json['FixedSalary'];
    fixedBasic = json['FixedBasic'];
    fixedHRA = json['FixedHRA'];
    fixedConv = json['FixedConv'];
    fixedDA = json['FixedDA'];
    fixedSpecial = json['FixedSpecial'];
    birthDate = json['BirthDate'];
    confirmationDate = json['ConfirmationDate'];
    joinDate = json['JoinDate'];
    releaseDate = json['ReleaseDate'];
    authorizedSign = json['AuthorizedSign'];
    drivingLicenseNo = json['DrivingLicenseNo'];
    passportNo = json['PassportNo'];
    aadharCardNo = json['AadharCardNo'];
    pANCardNo = json['PANCardNo'];
    pFCalculation = json['PF_Calculation'];
    pTCalculation = json['PT_Calculation'];
    eSICalculation = json['ESI_Calculation'];
    eSignaturePath = json['eSignaturePath'];
    bankName = json['BankName'];
    bankBranch = json['BankBranch'];
    bankAccountNo = json['BankAccountNo'];
    bankIFSC = json['BankIFSC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['EmployeeName'] = this.employeeName;
    data['CardNo'] = this.cardNo;
    data['MobileNo'] = this.mobileNo;
    data['Landline'] = this.landline;
    data['EmailAddress'] = this.emailAddress;
    data['EmailPassword'] = this.emailPassword;
    data['Gender'] = this.gender;
    data['WorkingHours'] = this.workingHours;
    data['ShiftCode'] = this.shiftCode;
    data['ShiftName'] = this.shiftName;
    data['BasicPer'] = this.basicPer;
    data['DesigCode'] = this.desigCode;
    data['Designation'] = this.designation;
    data['EmployeeImage'] = this.employeeImage;
    data['OrgCode'] = this.orgCode;
    data['OrgName'] = this.orgName;
    data['EmpCode'] = this.empCode;
    data['ReportTo'] = this.reportTo;
    data['ReportToEmployeeName'] = this.reportToEmployeeName;
    data['FixedSalary'] = this.fixedSalary;
    data['FixedBasic'] = this.fixedBasic;
    data['FixedHRA'] = this.fixedHRA;
    data['FixedConv'] = this.fixedConv;
    data['FixedDA'] = this.fixedDA;
    data['FixedSpecial'] = this.fixedSpecial;
    data['BirthDate'] = this.birthDate;
    data['ConfirmationDate'] = this.confirmationDate;
    data['JoinDate'] = this.joinDate;
    data['ReleaseDate'] = this.releaseDate;
    data['AuthorizedSign'] = this.authorizedSign;
    data['DrivingLicenseNo'] = this.drivingLicenseNo;
    data['PassportNo'] = this.passportNo;
    data['AadharCardNo'] = this.aadharCardNo;
    data['PANCardNo'] = this.pANCardNo;
    data['PF_Calculation'] = this.pFCalculation;
    data['PT_Calculation'] = this.pTCalculation;
    data['ESI_Calculation'] = this.eSICalculation;
    data['eSignaturePath'] = this.eSignaturePath;
    data['BankName'] = this.bankName;
    data['BankBranch'] = this.bankBranch;
    data['BankAccountNo'] = this.bankAccountNo;
    data['BankIFSC'] = this.bankIFSC;
    return data;
  }
}
