import 'package:flutter/material.dart';
import '../models/resume_models.dart';
import 'pdf_preview_page.dart';

class TemplateSelectionPage extends StatefulWidget {
  final ResumeTemplate selectedTemplate;
  final Function(ResumeTemplate) onTemplateSelected;
  final PersonalDetails personalDetails;
  final List<EducationDetails> educationDetails;
  final List<WorkExperience> workExperiences;
  final List<Skill> skills;

  const TemplateSelectionPage({
    super.key,
    required this.selectedTemplate,
    required this.onTemplateSelected,
    required this.personalDetails,
    required this.educationDetails,
    required this.workExperiences,
    required this.skills,
  });

  @override
  State<TemplateSelectionPage> createState() => _TemplateSelectionPageState();
}

class _TemplateSelectionPageState extends State<TemplateSelectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late ResumeTemplate _selectedTemplate;

  @override
  void initState() {
    super.initState();
    _selectedTemplate = widget.selectedTemplate;
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

  String _getTemplateDescription(ResumeTemplate template) {
    switch (template) {
      case ResumeTemplate.modern:
        return 'Clean and contemporary design with teal accents';
      case ResumeTemplate.classic:
        return 'Traditional layout with clear sections';
      case ResumeTemplate.minimal:
        return 'Simple and elegant design with centered layout';
      case ResumeTemplate.professional:
        return 'Two-column layout with emphasis on content';
      case ResumeTemplate.creative:
        return 'Bold and artistic design with unique typography';
      case ResumeTemplate.executive:
        return 'Sophisticated design with emphasis on experience';
      case ResumeTemplate.technical:
        return 'Focused on technical skills and projects';
      case ResumeTemplate.academic:
        return 'Formal layout suitable for academic positions';
      case ResumeTemplate.startup:
        return 'Modern and dynamic design for startup culture';
      case ResumeTemplate.corporate:
        return 'Professional design with corporate aesthetics';
    }
  }

  IconData _getTemplateIcon(ResumeTemplate template) {
    switch (template) {
      case ResumeTemplate.modern:
        return Icons.style;
      case ResumeTemplate.classic:
        return Icons.format_list_bulleted;
      case ResumeTemplate.minimal:
        return Icons.dashboard;
      case ResumeTemplate.professional:
        return Icons.work;
      case ResumeTemplate.creative:
        return Icons.brush;
      case ResumeTemplate.executive:
        return Icons.business;
      case ResumeTemplate.technical:
        return Icons.code;
      case ResumeTemplate.academic:
        return Icons.school;
      case ResumeTemplate.startup:
        return Icons.rocket_launch;
      case ResumeTemplate.corporate:
        return Icons.account_balance;
    }
  }

  void _previewTemplate(ResumeTemplate template) {
    setState(() {
      _selectedTemplate = template;
    });
    widget.onTemplateSelected(template);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewPage(
          personalDetails: widget.personalDetails,
          educationDetails: widget.educationDetails,
          workExperiences: widget.workExperiences,
          skills: widget.skills,
          template: template,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a Template"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfPreviewPage(
                      personalDetails: widget.personalDetails,
                      educationDetails: widget.educationDetails,
                      workExperiences: widget.workExperiences,
                      skills: widget.skills,
                      template: _selectedTemplate,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.preview))
        ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: ResumeTemplate.values.length,
                    itemBuilder: (context, index) {
                      final template = ResumeTemplate.values[index];
                      final isSelected = template == _selectedTemplate;
                      return Card(
                        elevation: isSelected ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: isSelected
                              ? BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                )
                              : BorderSide.none,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedTemplate = template;
                            });
                            widget.onTemplateSelected(template);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _getTemplateIcon(template),
                                      color: theme.colorScheme.primary,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        template
                                            .toString()
                                            .split('.')
                                            .last
                                            .toUpperCase(),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: theme.colorScheme.primary,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        _getTemplateIcon(template),
                                        size: 48,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _getTemplateDescription(template),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
