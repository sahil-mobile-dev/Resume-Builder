import 'package:flutter/material.dart';
import '../models/resume_models.dart';

class EducationDetailsPage extends StatefulWidget {
  final List<EducationDetails> educationDetails;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const EducationDetailsPage({
    super.key,
    required this.educationDetails,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<EducationDetailsPage> createState() => _EducationDetailsPageState();
}

class _EducationDetailsPageState extends State<EducationDetailsPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
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
    _controller.dispose();
    super.dispose();
  }

  void _addEducation() {
    setState(() {
      widget.educationDetails.add(EducationDetails());
    });
  }

  void _removeEducation(int index) {
    setState(() {
      widget.educationDetails.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Details'),
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
                                  'Education History',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _addEducation,
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: theme.colorScheme.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            ...widget.educationDetails.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final education = entry.value;
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
                                              'Education ${index + 1}',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _removeEducation(index),
                                              icon: const Icon(
                                                  Icons.delete_outline),
                                              color: theme.colorScheme.error,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          initialValue: education.institution,
                                          decoration: const InputDecoration(
                                            labelText: 'Institution',
                                            prefixIcon: Icon(Icons.school),
                                          ),
                                          onSaved: (value) => education
                                              .institution = value ?? '',
                                          validator: (value) =>
                                              value?.isEmpty ?? true
                                                  ? 'Required'
                                                  : null,
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          initialValue: education.degree,
                                          decoration: const InputDecoration(
                                            labelText: 'Degree',
                                            prefixIcon:
                                                Icon(Icons.workspace_premium),
                                          ),
                                          onSaved: (value) =>
                                              education.degree = value ?? '',
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
                                                initialValue: education.year,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Year',
                                                  prefixIcon: Icon(
                                                      Icons.calendar_today),
                                                ),
                                                onSaved: (value) => education
                                                    .year = value ?? '',
                                                validator: (value) =>
                                                    value?.isEmpty ?? true
                                                        ? 'Required'
                                                        : null,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: TextFormField(
                                                initialValue: education.gpa,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'GPA (Optional)',
                                                  prefixIcon: Icon(Icons.grade),
                                                ),
                                                onSaved: (value) =>
                                                    education.gpa = value,
                                              ),
                                            ),
                                          ],
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
