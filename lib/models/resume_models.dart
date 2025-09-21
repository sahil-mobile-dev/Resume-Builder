import 'package:objectbox/objectbox.dart';

@Entity()
class PersonalDetails {
  int id = 0;
  String fullName;
  String email;
  String phone;
  String address;
  String linkedIn;
  String github;
  String portfolio;
  String professionalSummary;

  PersonalDetails({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.linkedIn = '',
    this.github = '',
    this.portfolio = '',
    this.professionalSummary = '',
  });
}

@Entity()
class EducationDetails {
  int id = 0;
  String institution;
  String degree;
  String year;
  String? gpa;

  EducationDetails({
    this.institution = '',
    this.degree = '',
    this.year = '',
    this.gpa,
  });
}

@Entity()
class WorkExperience {
  int id = 0;
  String company;
  String position;
  String startDate;
  String endDate;
  String description;
  String projectLink;

  WorkExperience({
    this.company = '',
    this.position = '',
    this.startDate = '',
    this.endDate = '',
    this.description = '',
    this.projectLink = '',
  });
}

enum SkillLevel { beginner, intermediate, advanced, expert }

@Entity()
class Skill {
  int id = 0;
  String name;
  int proficiency;
  String level;

  Skill({
    this.name = '',
    this.proficiency = 0,
    this.level = 'intermediate',
  });

  SkillLevel get skillLevel => SkillLevel.values.firstWhere(
        (e) => e.toString().split('.').last == level,
        orElse: () => SkillLevel.intermediate,
      );

  set skillLevel(SkillLevel value) {
    level = value.toString().split('.').last;
  }
}

enum ResumeTemplate {
  modern, // Clean and contemporary design with teal accents
  classic, // Traditional layout with clear sections
  minimal, // Simple and elegant design with centered layout
  professional, // Two-column layout with emphasis on content
  creative, // Bold and artistic design with unique typography
  executive, // Sophisticated design with emphasis on experience
  technical, // Focused on technical skills and projects
  academic, // Formal layout suitable for academic positions
  startup, // Modern and dynamic design for startup culture
  corporate // Professional design with corporate aesthetics
}
