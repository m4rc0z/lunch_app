import 'package:flutter/foundation.dart';

class Course with ChangeNotifier {
  final String id;
  final int course;
  final String description;

  Course({
    @required this.id,
    @required this.course,
    @required this.description,
  });

}
