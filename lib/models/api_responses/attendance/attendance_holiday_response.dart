class AttendanceHolidayApiResponse {
  List<Details> details;
  int totalCount;

  AttendanceHolidayApiResponse({this.details, this.totalCount});

  AttendanceHolidayApiResponse.fromJson(Map<String, dynamic> json) {
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
  int holidayYear;
  String holidayDate;
  String holidayType;
  String holidayName;
  String holidayDescription;
  String imageURL;

  Details(
      {this.rowNum,
      this.pkID,
      this.holidayYear,
      this.holidayDate,
      this.holidayType,
      this.holidayName,
      this.holidayDescription,
      this.imageURL});

  Details.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    holidayYear = json['Holiday_Year'] == null ? 0 : json['Holiday_Year'];
    holidayDate = json['Holiday_Date'] == null ? "" : json['Holiday_Date'];
    holidayType = json['Holiday_Type'] == null ? "" : json['Holiday_Type'];
    holidayName = json['Holiday_Name'] == null ? "" : json['Holiday_Name'];
    holidayDescription =
        json['Holiday_Description'] == null ? "" : json['Holiday_Description'];
    imageURL = json['ImageURL'] == null ? "" : json['ImageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['Holiday_Year'] = this.holidayYear;
    data['Holiday_Date'] = this.holidayDate;
    data['Holiday_Type'] = this.holidayType;
    data['Holiday_Name'] = this.holidayName;
    data['Holiday_Description'] = this.holidayDescription;
    data['ImageURL'] = this.imageURL;
    return data;
  }
}
