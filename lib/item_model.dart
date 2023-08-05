class Item {
  final String name;
  final String category;
  final String subject;
  final DateTime deadline;

  const Item({
    required this.name,
    required this.category,
    required this.subject,
    required this.deadline,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    final dateStr = properties['Deadline']?['date']?['start'];
    return Item(
      name: properties['Name']?['title']?[0]?['plain_text'] ?? '?',
      category: properties['Type']?['select']?['name'] ?? 'Any',
      subject: properties['Subject']?['multi_select']?[0]?['name'] ??
          'No subject given',
      deadline: dateStr != null ? DateTime.parse(dateStr) : DateTime.now(),
    );
  }
}
