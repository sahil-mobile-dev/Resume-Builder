import 'package:flutter/material.dart';
import '../models/resume_models.dart';

class AchievementsPage extends StatefulWidget {
  final PersonalDetails personalDetails;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AchievementsPage({
    super.key,
    required this.personalDetails,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // TextFormField(
                  //   initialValue: widget.personalDetails.achievements,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Achievements',
                  //     border: OutlineInputBorder(),
                  //     hintText:
                  //         'List your achievements, awards, and certifications',
                  //   ),
                  //   maxLines: 6,
                  //   onSaved: (value) =>
                  //       widget.personalDetails.achievements = value ?? '',
                  //   validator: (value) => value!.isEmpty ? 'Required' : null,
                  // ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Achievements saved')),
                        );
                        widget.onNext();
                      }
                    },
                    child: const Text('Next: Select Template'),
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
