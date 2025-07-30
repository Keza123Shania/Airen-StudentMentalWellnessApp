class MeditationExercise {
  final String id;
  final String title;
  final String description;
  final int duration; // in minutes
  final String category;
  final String imageUrl;
  final List<String> steps;

  MeditationExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.category,
    required this.imageUrl,
    required this.steps,
  });

  factory MeditationExercise.fromJson(Map<String, dynamic> json) {
    return MeditationExercise(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      steps: List<String>.from(json['steps']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'category': category,
      'imageUrl': imageUrl,
      'steps': steps,
    };
  }
}
