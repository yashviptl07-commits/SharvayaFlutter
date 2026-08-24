class WhatsAppApiResponse {
  String errorCode;
  String errorMessage;
  String data;

  WhatsAppApiResponse({this.errorCode, this.errorMessage, this.data});

  WhatsAppApiResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorMessage = json['ErrorMessage'];
    data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorMessage'] = this.errorMessage;
    data['Data'] = this.data;
    return data;
  }
}
