class AttachedFile {
  final String name;
  final String path;
  final int size;
  final String type;
  final DateTime uploadedAt;

  AttachedFile({
    required this.name,
    required this.path,
    required this.size,
    required this.type,
    required this.uploadedAt,
  });

  // Factory constructor for creating AttachedFile from JSON
  factory AttachedFile.fromJson(Map<String, dynamic> json) {
    return AttachedFile(
      name: json['name'],
      path: json['path'],
      size: json['size'],
      type: json['type'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }

  // Method to convert AttachedFile to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'size': size,
      'type': type,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }

  // Get file size in human readable format
  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class AuditItem {
  final int id;
  final String description;
  bool isCompleted;
  String comments;
  List<AttachedFile> attachedFiles;
  DateTime evaluationPeriod;
  final String userId; // Which user this audit item belongs to

  AuditItem({
    required this.id,
    required this.description,
    required this.isCompleted,
    required this.comments,
    required this.attachedFiles,
    required this.evaluationPeriod,
    required this.userId,
  });

  // Factory constructor for creating AuditItem from JSON
  factory AuditItem.fromJson(Map<String, dynamic> json) {
    return AuditItem(
      id: json['id'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      comments: json['comments'],
      attachedFiles: (json['attachedFiles'] as List)
          .map((file) => AttachedFile.fromJson(file))
          .toList(),
      evaluationPeriod: DateTime.parse(json['evaluationPeriod']),
      userId: json['userId'],
    );
  }

  // Method to convert AuditItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'isCompleted': isCompleted,
      'comments': comments,
      'attachedFiles': attachedFiles.map((file) => file.toJson()).toList(),
      'evaluationPeriod': evaluationPeriod.toIso8601String(),
      'userId': userId,
    };
  }

  // Create a copy of this AuditItem with updated fields
  AuditItem copyWith({
    int? id,
    String? description,
    bool? isCompleted,
    String? comments,
    List<AttachedFile>? attachedFiles,
    DateTime? evaluationPeriod,
    String? userId,
  }) {
    return AuditItem(
      id: id ?? this.id,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      comments: comments ?? this.comments,
      attachedFiles: attachedFiles ?? this.attachedFiles,
      evaluationPeriod: evaluationPeriod ?? this.evaluationPeriod,
      userId: userId ?? this.userId,
    );
  }
} 