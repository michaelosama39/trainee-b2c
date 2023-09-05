import '../../../../../core/params/base_params.dart';

class CraeteFeedbackRequest extends BaseParams {
  CraeteFeedbackRequest({
    required this.description,
    required this.subject,
  });

  final String description;
  final String subject;

  factory CraeteFeedbackRequest.fromMap(Map<String, dynamic> json) =>
      CraeteFeedbackRequest(
        description: json["description"],
        subject: json["subject"],
      );

  Map<String, dynamic> toMap() => {
        "description": description,
        "subject": subject,
      };
}
