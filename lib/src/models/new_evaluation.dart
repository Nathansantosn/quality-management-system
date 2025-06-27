class Evaluation {
  String id;
  String note;
  String description;
  String systemId;
  String criterionId;
  String subCriterionId;
  String questionId;

  Evaluation({
    required this.id,
    required this.note,
    required this.description,
    required this.systemId,
    required this.criterionId,
    required this.subCriterionId,
    required this.questionId,
  });

  Evaluation.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      note = map['note'],
      description = map['description'],
      systemId = map['systemId'],
      criterionId = map['criterionId'],
      subCriterionId = map['subCriterionId'],
      questionId = map['questionId'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'description': description,
      'systemId': systemId,
      'criterionId': criterionId,
      'subCriterionId': subCriterionId,
      'questionId': questionId,
    };
  }
}
