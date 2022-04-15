class Student {
  String name;
  int age;
  Student({required this.name, required this.age});

  factory Student.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final age = json['age'] as int;
    return Student(name: name, age: age);
  }

  String get namee => name;
  int get agee => age;

  @override
  String toString() {
    return 'name : $name, age : $age';
  }
}
