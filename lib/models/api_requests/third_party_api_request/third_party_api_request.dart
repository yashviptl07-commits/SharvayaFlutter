/*
key:61e375ba6332421aa2d6bad01c447892
to:918488861994
message:Message From API Controller*/

class WhatsAppApiRequest {
  String key;
  String to;
  String message;

  WhatsAppApiRequest({this.key, this.to, this.message});

  WhatsAppApiRequest.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    to = json['To'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['To'] = this.to;
    data['Message'] = this.message;

    return data;
  }
}
