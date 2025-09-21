import 'package:flutter/material.dart';
import '../models/resume_models.dart';

class PersonalDetailsPage extends StatefulWidget {
  final PersonalDetails personalDetails;
  final VoidCallback onNext;

  const PersonalDetailsPage({
    super.key,
    required this.personalDetails,
    required this.onNext,
  });

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage>
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Details'),
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
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Information',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          initialValue: widget.personalDetails.fullName,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          onSaved: (value) =>
                              widget.personalDetails.fullName = value ?? '',
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: widget.personalDetails.email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) =>
                              widget.personalDetails.email = value ?? '',
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: widget.personalDetails.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          onSaved: (value) =>
                              widget.personalDetails.phone = value ?? '',
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: widget.personalDetails.address,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          onSaved: (value) =>
                              widget.personalDetails.address = value ?? '',
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Professional Links',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          initialValue: widget.personalDetails.linkedIn,
                          decoration: const InputDecoration(
                            labelText: 'LinkedIn Profile',
                            prefixIcon: Icon(Icons.link),
                          ),
                          onSaved: (value) =>
                              widget.personalDetails.linkedIn = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: widget.personalDetails.github,
                          decoration: const InputDecoration(
                            labelText: 'GitHub Profile',
                            prefixIcon: Icon(Icons.code),
                          ),
                          onSaved: (value) =>
                              widget.personalDetails.github = value ?? '',
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: widget.personalDetails.portfolio,
                          decoration: const InputDecoration(
                            labelText: 'Portfolio Website',
                            prefixIcon: Icon(Icons.web),
                          ),
                          onSaved: (value) =>
                              widget.personalDetails.portfolio = value ?? '',
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Professional Summary',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          initialValue:
                              widget.personalDetails.professionalSummary,
                          decoration: const InputDecoration(
                            labelText: 'Summary',
                            alignLabelWithHint: true,
                          ),
                          maxLines: 5,
                          onSaved: (value) => widget.personalDetails
                              .professionalSummary = value ?? '',
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                        ),
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
            ),
          ),
        ),
      ),
    );
  }
}
