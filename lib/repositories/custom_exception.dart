class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }

  String getUserFriendlyMessage() {
    return "Something went wrong. Please try again.";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");

  @override
  String getUserFriendlyMessage() {
    final msg = _message?.toString()?.toLowerCase() ?? "";
    if (msg.contains("no internet") || msg.contains("socketexception")) {
      return "No internet connection. Please check your internet connection and try again.";
    } else if (msg.contains("low internet") ||
        msg.contains("time out") ||
        msg.contains("timeout")) {
      return "The request took too long. Please check your internet connection and try again.";
    }
    return "We're unable to connect to the server right now. Please try again later.";
  }
}

class BadRequestException extends CustomException {
  
  BadRequestException([message]) : super(message, "");

  @override
  String getUserFriendlyMessage() => "Something went wrong. Please try again.";
}

class NotFoundException extends CustomException {
  NotFoundException([message]) : super(message, "");

  @override
  String getUserFriendlyMessage() => "No data found.";
}

class ServerErrorException extends CustomException {
  ServerErrorException([message]) : super(message, "");

  @override
  String getUserFriendlyMessage() =>
      "We're unable to connect to the server right now. Please try again later.";
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "");

  @override
  String getUserFriendlyMessage() =>
      "Your session has expired. Please log in again.";
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");

  @override
  String getUserFriendlyMessage() => "Please check your input and try again.";
}

class SuccessWithPopupException extends CustomException {
  SuccessWithPopupException([String message]) : super(message, "Success: ");

  @override
  String getUserFriendlyMessage() => _message?.toString() ?? "Success";
}
