import 'package:flutter/material.dart';
import '../models/resume_models.dart';
import 'personal_details_page.dart';
import 'education_details_page.dart';
import 'work_experience_page.dart';
import 'template_selection_page.dart';

class SectionSelectionPage extends StatefulWidget {
  final PersonalDetails personalDetails;
  final List<EducationDetails> educationDetails;
  final List<WorkExperience> workExperiences;
  final List<Skill> skills;
  final Function() onGeneratePdf;

  const SectionSelectionPage({
    super.key,
    required this.personalDetails,
    required this.educationDetails,
    required this.workExperiences,
    required this.skills,
    required this.onGeneratePdf,
  });

  @override
  State<SectionSelectionPage> createState() => _SectionSelectionPageState();
}

class _SectionSelectionPageState extends State<SectionSelectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  ResumeTemplate selectedTemplate = ResumeTemplate.modern;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToTemplateSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplateSelectionPage(
          selectedTemplate: selectedTemplate,
          onTemplateSelected: (template) {
            setState(() {
              selectedTemplate = template;
            });
          },
          personalDetails: widget.personalDetails,
          educationDetails: widget.educationDetails,
          workExperiences: widget.workExperiences,
          skills: widget.skills,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Sections'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.background,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete Your Resume',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fill in all sections to create a professional resume',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionCard(
                    context,
                    'Personal Details',
                    'Add your contact information and professional summary',
                    Icons.person,
                    widget.personalDetails.fullName.isNotEmpty,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalDetailsPage(
                            personalDetails: widget.personalDetails,
                            onNext: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    context,
                    'Education',
                    'Add your educational background and qualifications',
                    Icons.school,
                    widget.educationDetails.isNotEmpty,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EducationDetailsPage(
                            educationDetails: widget.educationDetails,
                            onNext: () => Navigator.pop(context),
                            onBack: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    context,
                    'Work Experience & Skills',
                    'Add your work history and technical skills',
                    Icons.work,
                    widget.workExperiences.isNotEmpty ||
                        widget.skills.isNotEmpty,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkExperiencePage(
                            workExperiences: widget.workExperiences,
                            skills: widget.skills,
                            onNext: () => Navigator.pop(context),
                            onBack: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    context,
                    'Choose Resume Format',
                    'Select a template for your resume',
                    Icons.format_list_bulleted,
                    true, // Assuming this section is always available
                    _navigateToTemplateSelection,
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: widget.onGeneratePdf,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Generate PDF'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    bool isCompleted,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Hero(
      tag: title,
      child: Card(
        elevation: isCompleted ? 4 : 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isCompleted
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.1),
                        theme.colorScheme.secondary.withOpacity(0.1),
                      ],
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : theme.colorScheme.onBackground.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: isCompleted
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onBackground.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onBackground,
                              ),
                            ),
                          ),
                          if (isCompleted)
                            Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
