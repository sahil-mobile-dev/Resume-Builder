import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';
import '../services/pdf_service.dart';
import '../models/resume_models.dart';
import '../pages/template_selection_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGenerating = false;
  PersonalDetails? _personalDetails;
  List<EducationDetails> _educationDetails = [];
  List<WorkExperience> _workExperiences = [];
  List<Skill> _skills = [];
  ResumeTemplate _selectedTemplate = ResumeTemplate.modern;

  void _showTemplateSelection() {
    if (_personalDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in your personal details first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => TemplateSelectionPage(
        selectedTemplate: _selectedTemplate,
        onTemplateSelected: (template) {
          setState(() {
            _selectedTemplate = template;
          });
        },
        personalDetails: _personalDetails!,
        educationDetails: _educationDetails,
        workExperiences: _workExperiences,
        skills: _skills,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: _showTemplateSelection,
          ),
        ],
      ),
      body: _isGenerating
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Your existing form widgets here
                ],
              ),
            ),
    );
  }

  Future<void> _generatePdf() async {
    try {
      setState(() {
        _isGenerating = true;
      });

      final pdfFile = await PdfService.generateResume(
        personalDetails: _personalDetails!,
        educationDetails: _educationDetails,
        workExperiences: _workExperiences,
        skills: _skills,
        template: _selectedTemplate,
      );

      if (!mounted) return;

      setState(() {
        _isGenerating = false;
      });

      // Show PDF preview in a dialog
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Resume Preview',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: PdfPreview(
                    build: (format) => pdfFile.readAsBytesSync(),
                    canChangePageFormat: false,
                    canChangeOrientation: false,
                    allowPrinting: true,
                    allowSharing: true,
                    maxPageWidth: 700,
                    actions: [
                      PdfPreviewAction(
                        icon: const Icon(Icons.download),
                        onPressed: (context, build, format) async {
                          final output = await getTemporaryDirectory();
                          final file = File('${output.path}/resume.pdf');
                          await file.writeAsBytes(await build(format));
                          await OpenFile.open(file.path);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isGenerating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
