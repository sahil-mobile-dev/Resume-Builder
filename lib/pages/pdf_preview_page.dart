import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import '../services/pdf_service.dart';
import '../models/resume_models.dart';

class PdfPreviewPage extends StatelessWidget {
  final PersonalDetails personalDetails;
  final List<EducationDetails> educationDetails;
  final List<WorkExperience> workExperiences;
  final List<Skill> skills;
  final ResumeTemplate template;

  const PdfPreviewPage({
    super.key,
    required this.personalDetails,
    required this.educationDetails,
    required this.workExperiences,
    required this.skills,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              try {
                final pdfFile = await PdfService.generateResume(
                  personalDetails: personalDetails,
                  educationDetails: educationDetails,
                  workExperiences: workExperiences,
                  skills: skills,
                  template: template,
                );
                final output = await getTemporaryDirectory();
                final file = File('${output.path}/resume.pdf');
                await file.writeAsBytes(await pdfFile.readAsBytes());
                await OpenFile.open(file.path);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error saving PDF: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<File>(
        future: PdfService.generateResume(
          personalDetails: personalDetails,
          educationDetails: educationDetails,
          workExperiences: workExperiences,
          skills: skills,
          template: template,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error generating PDF: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available'),
            );
          }

          return PdfPreview(
            build: (format) => snapshot.data!.readAsBytesSync(),
            canChangePageFormat: false,
            canChangeOrientation: false,
            allowPrinting: true,
            allowSharing: true,
            maxPageWidth: 700,
          );
        },
      ),
    );
  }
}
