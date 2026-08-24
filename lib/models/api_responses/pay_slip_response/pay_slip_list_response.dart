class PaySlipListResponse {
  List<PaySlipListResponseDetails> details;
  int totalCount;

  PaySlipListResponse({this.details, this.totalCount});

  PaySlipListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new PaySlipListResponseDetails.fromJson(v));
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

class PaySlipListResponseDetails {
  dynamic rowNum;
  dynamic pkID;
  dynamic employeeID;
  dynamic employeeName;
  dynamic payDate;
  dynamic wDays;
  dynamic pDays;
  dynamic lDays;
  dynamic hDays;
  dynamic oDays;
  dynamic salaryMonth;
  dynamic mobileNo;
  dynamic landline;
  dynamic emailAddress;
  dynamic basicPer;
  dynamic shiftCode;
  dynamic shiftName;
  dynamic minHrsFullDay;
  dynamic minHrsHalfDay;
  dynamic desigCode;
  dynamic designation;
  dynamic gender;
  dynamic halfDayCount;
  dynamic halfDayDeduction;
  dynamic orgCode;
  dynamic orgName;
  dynamic reportTo;
  dynamic reportToEmployeeName;
  dynamic fixedSalary;
  dynamic basic;
  dynamic hra;
  dynamic dA;
  dynamic conveyance;
  dynamic medical;
  dynamic special;
  dynamic overTime;
  dynamic totalIncome;
  dynamic incentive;
  dynamic incentiveRemarks;
  dynamic pF;
  dynamic eSI;
  dynamic pT;
  dynamic tDS;
  dynamic loan;
  dynamic totalDeduct;
  dynamic netSalary;
  dynamic upad;
  dynamic loanAmt;
  dynamic worklogCount;
  dynamic lateComingCount;

  PaySlipListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.employeeID,
      this.employeeName,
      this.payDate,
      this.wDays,
      this.pDays,
      this.lDays,
      this.hDays,
      this.oDays,
      this.salaryMonth,
      this.mobileNo,
      this.landline,
      this.emailAddress,
      this.basicPer,
      this.shiftCode,
      this.shiftName,
      this.minHrsFullDay,
      this.minHrsHalfDay,
      this.desigCode,
      this.designation,
      this.gender,
      this.halfDayCount,
      this.halfDayDeduction,
      this.orgCode,
      this.orgName,
      this.reportTo,
      this.reportToEmployeeName,
      this.fixedSalary,
      this.basic,
      this.hra,
      this.dA,
      this.conveyance,
      this.medical,
      this.special,
      this.overTime,
      this.totalIncome,
      this.incentive,
      this.incentiveRemarks,
      this.pF,
      this.eSI,
      this.pT,
      this.tDS,
      this.loan,
      this.totalDeduct,
      this.netSalary,
      this.upad,
      this.loanAmt,
      this.worklogCount,
      this.lateComingCount});

  PaySlipListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    payDate = json['PayDate'];
    wDays = json['WDays'];
    pDays = json['PDays'];
    lDays = json['LDays'];
    hDays = json['HDays'];
    oDays = json['ODays'];
    salaryMonth = json['SalaryMonth'];
    mobileNo = json['MobileNo'];
    landline = json['Landline'];
    emailAddress = json['EmailAddress'];
    basicPer = json['BasicPer'];
    shiftCode = json['ShiftCode'];
    shiftName = json['ShiftName'];
    minHrsFullDay = json['MinHrsFullDay'];
    minHrsHalfDay = json['MinHrsHalfDay'];
    desigCode = json['DesigCode'];
    designation = json['Designation'];
    gender = json['Gender'];
    halfDayCount = json['HalfDayCount'];
    halfDayDeduction = json['HalfDayDeduction'];
    orgCode = json['OrgCode'];
    orgName = json['OrgName'];
    reportTo = json['ReportTo'];
    reportToEmployeeName = json['ReportToEmployeeName'];
    fixedSalary = json['FixedSalary'];
    basic = json['Basic'];
    hra = json['Hra'];
    dA = json['DA'];
    conveyance = json['Conveyance'];
    medical = json['Medical'];
    special = json['Special'];
    overTime = json['OverTime'];
    totalIncome = json['Total_Income'];
    incentive = json['Incentive'];
    incentiveRemarks = json['IncentiveRemarks'];
    pF = json['PF'];
    eSI = json['ESI'];
    pT = json['PT'];
    tDS = json['TDS'];
    loan = json['Loan'];
    totalDeduct = json['Total_Deduct'];
    netSalary = json['NetSalary'];
    upad = json['Upad'];
    loanAmt = json['LoanAmt'];
    worklogCount = json['WorklogCount'];
    lateComingCount = json['LateComingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['PayDate'] = this.payDate;
    data['WDays'] = this.wDays;
    data['PDays'] = this.pDays;
    data['LDays'] = this.lDays;
    data['HDays'] = this.hDays;
    data['ODays'] = this.oDays;
    data['SalaryMonth'] = this.salaryMonth;
    data['MobileNo'] = this.mobileNo;
    data['Landline'] = this.landline;
    data['EmailAddress'] = this.emailAddress;
    data['BasicPer'] = this.basicPer;
    data['ShiftCode'] = this.shiftCode;
    data['ShiftName'] = this.shiftName;
    data['MinHrsFullDay'] = this.minHrsFullDay;
    data['MinHrsHalfDay'] = this.minHrsHalfDay;
    data['DesigCode'] = this.desigCode;
    data['Designation'] = this.designation;
    data['Gender'] = this.gender;
    data['HalfDayCount'] = this.halfDayCount;
    data['HalfDayDeduction'] = this.halfDayDeduction;
    data['OrgCode'] = this.orgCode;
    data['OrgName'] = this.orgName;
    data['ReportTo'] = this.reportTo;
    data['ReportToEmployeeName'] = this.reportToEmployeeName;
    data['FixedSalary'] = this.fixedSalary;
    data['Basic'] = this.basic;
    data['Hra'] = this.hra;
    data['DA'] = this.dA;
    data['Conveyance'] = this.conveyance;
    data['Medical'] = this.medical;
    data['Special'] = this.special;
    data['OverTime'] = this.overTime;
    data['Total_Income'] = this.totalIncome;
    data['Incentive'] = this.incentive;
    data['IncentiveRemarks'] = this.incentiveRemarks;
    data['PF'] = this.pF;
    data['ESI'] = this.eSI;
    data['PT'] = this.pT;
    data['TDS'] = this.tDS;
    data['Loan'] = this.loan;
    data['Total_Deduct'] = this.totalDeduct;
    data['NetSalary'] = this.netSalary;
    data['Upad'] = this.upad;
    data['LoanAmt'] = this.loanAmt;
    data['WorklogCount'] = this.worklogCount;
    data['LateComingCount'] = this.lateComingCount;
    return data;
  }
}
