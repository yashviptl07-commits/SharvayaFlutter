class MyGetPunchingResponse {
  List<MyGetPunchingResponseDetails> details;
  int totalCount;

  MyGetPunchingResponse({this.details, this.totalCount});

  MyGetPunchingResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MyGetPunchingResponseDetails.fromJson(v));
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

class MyGetPunchingResponseDetails {
  /*int column1;
  String column2;*/
  String column1;
  MyGetPunchingResponseDetails({this.column1});

  MyGetPunchingResponseDetails.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    return data;
  }
}
