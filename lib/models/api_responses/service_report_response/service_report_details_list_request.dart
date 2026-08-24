class ServiceReportDetailsListResponse {
  List<Details> details;
  int totalCount;

  ServiceReportDetailsListResponse({this.details, this.totalCount});

  ServiceReportDetailsListResponse.fromJson(Map<String, dynamic> json) {
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
  int pkID;
  int srNo;
  String serviceNo;
  String workNotes;

  Details({this.pkID, this.srNo, this.serviceNo, this.workNotes});

  Details.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    srNo = json['SrNo'];
    serviceNo = json['ServiceNo'];
    workNotes = json['WorkNotes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SrNo'] = this.srNo;
    data['ServiceNo'] = this.serviceNo;
    data['WorkNotes'] = this.workNotes;
    return data;
  }
}
