class PODrpListResponse {
  List<Details> details;
  int totalCount;

  PODrpListResponse({this.details, this.totalCount});

  PODrpListResponse.fromJson(Map<String, dynamic> json) {
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
  String orderNo;
  String orderDate;

  Details({this.pkID, this.orderNo, this.orderDate});

  Details.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    orderNo = json['OrderNo'];
    orderDate = json['OrderDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['OrderNo'] = this.orderNo;
    data['OrderDate'] = this.orderDate;
    return data;
  }
}