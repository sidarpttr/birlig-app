// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApiResponse {
  final String status;
  final dynamic data;
  final bool succes;
  final String? error;

  ApiResponse(
      {required this.status,
      required this.data,
      this.succes = true,
      this.error}) {
    if (!succes) {
      
    }
  }
}
