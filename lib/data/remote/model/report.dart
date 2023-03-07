import 'package:equatable/equatable.dart';

class FeedReportModel extends Equatable {
  final String title;
  final String? description;
  final List<FeedReportModel>? options;

  const FeedReportModel({
    required this.title,
    this.description = '',
    this.options=const[],
  });

  @override
  List<Object?> get props => [title, description, options];
}
