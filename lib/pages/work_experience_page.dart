import 'package:flutter/material.dart';
import '../models/resume_models.dart';

class WorkExperiencePage extends StatefulWidget {
  final List<WorkExperience> workExperiences;
  final List<Skill> skills;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const WorkExperiencePage({
    super.key,
    required this.workExperiences,
    required this.skills,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<WorkExperiencePage> createState() => _WorkExperiencePageState();
}

class _WorkExperiencePageState extends State<WorkExperiencePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _skillFormKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillController = TextEditingController();
  String _skillLevel = 'Intermediate';
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    _companyController.dispose();
    _positionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    _skillController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _addExperience() {
    setState(() {
      widget.workExperiences.add(WorkExperience());
    });
  }

  void _removeExperience(int index) {
    setState(() {
      widget.workExperiences.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Experience'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
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
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Work History',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _addExperience,
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: theme.colorScheme.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            ...widget.workExperiences.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final experience = entry.value;
                                return Card(
                                  elevation: 1,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Experience ${index + 1}',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _removeExperience(index),
                                              icon: const Icon(
                                                  Icons.delete_outline),
                                              color: theme.colorScheme.error,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          initialValue: experience.company,
                                          decoration: const InputDecoration(
                                            labelText: 'Company',
                                            prefixIcon: Icon(Icons.business),
                                          ),
                                          onSaved: (value) =>
                                              experience.company = value ?? '',
                                          validator: (value) =>
                                              value?.isEmpty ?? true
                                                  ? 'Required'
                                                  : null,
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          initialValue: experience.position,
                                          decoration: const InputDecoration(
                                            labelText: 'Position',
                                            prefixIcon: Icon(Icons.work),
                                          ),
                                          onSaved: (value) =>
                                              experience.position = value ?? '',
                                          validator: (value) =>
                                              value?.isEmpty ?? true
                                                  ? 'Required'
                                                  : null,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                initialValue:
                                                    experience.startDate,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Start Date',
                                                  prefixIcon: Icon(
                                                      Icons.calendar_today),
                                                ),
                                                onSaved: (value) => experience
                                                    .startDate = value ?? '',
                                                validator: (value) =>
                                                    value?.isEmpty ?? true
                                                        ? 'Required'
                                                        : null,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: TextFormField(
                                                initialValue:
                                                    experience.endDate,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'End Date',
                                                  prefixIcon: Icon(
                                                      Icons.calendar_today),
                                                ),
                                                onSaved: (value) => experience
                                                    .endDate = value ?? '',
                                                validator: (value) =>
                                                    value?.isEmpty ?? true
                                                        ? 'Required'
                                                        : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          initialValue: experience.description,
                                          decoration: const InputDecoration(
                                            labelText: 'Description',
                                            alignLabelWithHint: true,
                                            prefixIcon: Icon(Icons.description),
                                          ),
                                          maxLines: 3,
                                          onSaved: (value) => experience
                                              .description = value ?? '',
                                          validator: (value) =>
                                              value?.isEmpty ?? true
                                                  ? 'Required'
                                                  : null,
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          initialValue: experience.projectLink,
                                          decoration: const InputDecoration(
                                            labelText:
                                                'Project Link (Optional)',
                                            prefixIcon: Icon(Icons.link),
                                          ),
                                          onSaved: (value) => experience
                                              .projectLink = value ?? '',
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            const SizedBox(height: 32),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    widget.onNext();
                                  }
                                },
                                icon: const Icon(Icons.save),
                                label: const Text('Save & Continue'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
}
