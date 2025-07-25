// models/publication_model.dart

class Publication {
  String? id;
  String title;
  String? journal;
  String? conference;
  String yearOfPublication;
  String format;
  String identifierType; // ISBN, ISSN, DOI, etc.
  String identifier; // The actual number/link
  String? proofFilePath;
  String? publicationLink;
  DateTime createdAt;
  DateTime updatedAt;

  Publication({
    this.id,
    required this.title,
    this.journal,
    this.conference,
    required this.yearOfPublication,
    required this.format,
    required this.identifierType,
    required this.identifier,
    this.proofFilePath,
    this.publicationLink,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'journal': journal,
      'conference': conference,
      'yearOfPublication': yearOfPublication,
      'format': format,
      'identifierType': identifierType,
      'identifier': identifier,
      'proofFilePath': proofFilePath,
      'publicationLink': publicationLink,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Map (database retrieval)
  factory Publication.fromMap(Map<String, dynamic> map) {
    return Publication(
      id: map['id'],
      title: map['title'] ?? '',
      journal: map['journal'],
      conference: map['conference'],
      yearOfPublication: map['yearOfPublication'] ?? '',
      format: map['format'] ?? '',
      identifierType: map['identifierType'] ?? '',
      identifier: map['identifier'] ?? '',
      proofFilePath: map['proofFilePath'],
      publicationLink: map['publicationLink'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Copy with method for updates
  Publication copyWith({
    String? id,
    String? title,
    String? journal,
    String? conference,
    String? yearOfPublication,
    String? format,
    String? identifierType,
    String? identifier,
    String? proofFilePath,
    String? publicationLink,
    DateTime? updatedAt,
  }) {
    return Publication(
      id: id ?? this.id,
      title: title ?? this.title,
      journal: journal ?? this.journal,
      conference: conference ?? this.conference,
      yearOfPublication: yearOfPublication ?? this.yearOfPublication,
      format: format ?? this.format,
      identifierType: identifierType ?? this.identifierType,
      identifier: identifier ?? this.identifier,
      proofFilePath: proofFilePath ?? this.proofFilePath,
      publicationLink: publicationLink ?? this.publicationLink,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Publication{id: $id, title: $title, format: $format, year: $yearOfPublication}';
  }
}