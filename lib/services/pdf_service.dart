import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/resume_models.dart';

class PdfService {
  static Future<File> generateResume({
    required PersonalDetails personalDetails,
    required List<EducationDetails> educationDetails,
    required List<WorkExperience> workExperiences,
    required List<Skill> skills,
    required ResumeTemplate template,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.poppinsRegular();
    final boldFont = await PdfGoogleFonts.poppinsBold();
    final theme = _getTemplateTheme(template);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: _getPageTheme(template),
        build: (context) => [
          _buildHeader(personalDetails, theme, font, boldFont),
          _buildContent(
            personalDetails,
            educationDetails,
            workExperiences,
            skills,
            template,
            theme,
            font,
            boldFont,
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/resume.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static _TemplateTheme _getTemplateTheme(ResumeTemplate template) {
    switch (template) {
      case ResumeTemplate.modern:
        return _TemplateTheme(
          primaryColor: PdfColor.fromHex('#00BFA5'),
          secondaryColor: PdfColor.fromHex('#1A237E'),
          backgroundColor: PdfColor.fromHex('#FFFFFF'),
          textColor: PdfColor.fromHex('#333333'),
        );
      case ResumeTemplate.classic:
        return _TemplateTheme(
          primaryColor: PdfColor.fromHex('#1A237E'),
          secondaryColor: PdfColor.fromHex('#424242'),
          backgroundColor: PdfColor.fromHex('#FFFFFF'),
          textColor: PdfColor.fromHex('#000000'),
        );
      case ResumeTemplate.minimal:
        return _TemplateTheme(
          primaryColor: PdfColor.fromHex('#424242'),
          secondaryColor: PdfColor.fromHex('#757575'),
          backgroundColor: PdfColor.fromHex('#FFFFFF'),
          textColor: PdfColor.fromHex('#212121'),
        );
      case ResumeTemplate.professional:
        return _TemplateTheme(
          primaryColor: PdfColor.fromHex('#1976D2'),
          secondaryColor: PdfColor.fromHex('#0D47A1'),
          backgroundColor: PdfColor.fromHex('#FFFFFF'),
          textColor: PdfColor.fromHex('#212121'),
        );
      case ResumeTemplate.creative:
        return _TemplateTheme(
          primaryColor: PdfColor.fromHex('#FF6D00'),
          secondaryColor: PdfColor.fromHex('#E65100'),
          backgroundColor: PdfColor.fromHex('#FFFFFF'),
          textColor: PdfColor.fromHex('#212121'),
        );
      case ResumeTemplate.executive:
        return _TemplateTheme(
          primaryColor: PdfColor.fromHex('#1A237E'),
          secondaryColor: PdfColor.fromHex('#0D47A1'),
          backgroundColor: PdfColor.fromHex('#FFFFFF'),
          textColor: PdfColor.fromHex('#212121'),
        );
      case ResumeTemplate.technical:
        return _TemplateTheme(
          primaryColor: PdfColor.fromHex('#00BFA5'),
          secondaryColor: PdfColor.fromHex('#00897B'),
          backgroundColor: PdfColor.fromHex('#FFFFFF'),
          textColor: PdfColor.fromHex('#212121'),
        );
      case ResumeTemplate.academic:
        return _TemplateTheme(
          primaryColor: PdfColor.fromHex('#1A237E'),
          secondaryColor: PdfColor.fromHex('#0D47A1'),
          backgroundColor: PdfColor.fromHex('#FFFFFF'),
          textColor: PdfColor.fromHex('#212121'),
        );
      case ResumeTemplate.startup:
        return _TemplateTheme(
          primaryColor: PdfColor.fromHex('#FF6D00'),
          secondaryColor: PdfColor.fromHex('#E65100'),
          backgroundColor: PdfColor.fromHex('#FFFFFF'),
          textColor: PdfColor.fromHex('#212121'),
        );
      case ResumeTemplate.corporate:
        return _TemplateTheme(
          primaryColor: PdfColor.fromHex('#1A237E'),
          secondaryColor: PdfColor.fromHex('#0D47A1'),
          backgroundColor: PdfColor.fromHex('#FFFFFF'),
          textColor: PdfColor.fromHex('#212121'),
        );
    }
  }

  static pw.PageTheme _getPageTheme(ResumeTemplate template) {
    switch (template) {
      case ResumeTemplate.modern:
        return pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        );
      case ResumeTemplate.classic:
        return pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          theme: pw.ThemeData.withFont(
            base: pw.Font.times(),
            bold: pw.Font.timesBold(),
          ),
        );
      case ResumeTemplate.minimal:
        return pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(48),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        );
      default:
        return pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        );
    }
  }

  static pw.Widget _buildHeader(
    PersonalDetails personalDetails,
    _TemplateTheme theme,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 20),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: theme.primaryColor,
            width: 2,
          ),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            personalDetails.fullName,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 24,
              color: theme.primaryColor,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            personalDetails.professionalSummary,
            style: pw.TextStyle(
              font: font,
              fontSize: 12,
              color: theme.textColor,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                personalDetails.email,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  color: theme.secondaryColor,
                ),
              ),
              pw.Text(
                personalDetails.phone,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  color: theme.secondaryColor,
                ),
              ),
              pw.Text(
                personalDetails.address,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  color: theme.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildContent(
    PersonalDetails personalDetails,
    List<EducationDetails> educationDetails,
    List<WorkExperience> workExperiences,
    List<Skill> skills,
    ResumeTemplate template,
    _TemplateTheme theme,
    pw.Font font,
    pw.Font boldFont,
  ) {
    switch (template) {
      case ResumeTemplate.modern:
        return _buildModernLayout(
          personalDetails,
          educationDetails,
          workExperiences,
          skills,
          theme,
          font,
          boldFont,
        );
      case ResumeTemplate.classic:
        return _buildClassicLayout(
          personalDetails,
          educationDetails,
          workExperiences,
          skills,
          theme,
          font,
          boldFont,
        );
      case ResumeTemplate.minimal:
        return _buildMinimalLayout(
          personalDetails,
          educationDetails,
          workExperiences,
          skills,
          theme,
          font,
          boldFont,
        );
      default:
        return _buildModernLayout(
          personalDetails,
          educationDetails,
          workExperiences,
          skills,
          theme,
          font,
          boldFont,
        );
    }
  }

  static pw.Widget _buildModernLayout(
    PersonalDetails personalDetails,
    List<EducationDetails> educationDetails,
    List<WorkExperience> workExperiences,
    List<Skill> skills,
    _TemplateTheme theme,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildSection(
                'Work Experience',
                workExperiences
                    .map((exp) => pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              exp.position,
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 14,
                                color: theme.primaryColor,
                              ),
                            ),
                            pw.Text(
                              exp.company,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 12,
                                color: theme.secondaryColor,
                              ),
                            ),
                            pw.Text(
                              '${exp.startDate} - ${exp.endDate}',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: theme.textColor,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              exp.description,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: theme.textColor,
                              ),
                            ),
                            pw.SizedBox(height: 8),
                          ],
                        ))
                    .toList(),
                theme,
                font,
                boldFont,
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Expanded(
          flex: 1,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildSection(
                'Education',
                educationDetails
                    .map((edu) => pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              edu.degree,
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 12,
                                color: theme.primaryColor,
                              ),
                            ),
                            pw.Text(
                              edu.institution,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: theme.secondaryColor,
                              ),
                            ),
                            pw.Text(
                              edu.year,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: theme.textColor,
                              ),
                            ),
                            if (edu.gpa != null && edu.gpa!.isNotEmpty)
                              pw.Text(
                                'GPA: ${edu.gpa}',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: theme.textColor,
                                ),
                              ),
                            pw.SizedBox(height: 8),
                          ],
                        ))
                    .toList(),
                theme,
                font,
                boldFont,
              ),
              _buildSection(
                'Skills',
                [
                  pw.Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: skills
                        .map((skill) => pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromHex('#F5F5F5'),
                                borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(4),
                                ),
                              ),
                              child: pw.Text(
                                skill.name,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
                theme,
                font,
                boldFont,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildClassicLayout(
    PersonalDetails personalDetails,
    List<EducationDetails> educationDetails,
    List<WorkExperience> workExperiences,
    List<Skill> skills,
    _TemplateTheme theme,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSection(
          'Work Experience',
          workExperiences
              .map((exp) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            exp.position,
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 14,
                              color: theme.primaryColor,
                            ),
                          ),
                          pw.Text(
                            '${exp.startDate} - ${exp.endDate}',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                              color: theme.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      pw.Text(
                        exp.company,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 12,
                          color: theme.secondaryColor,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        exp.description,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: theme.textColor,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                    ],
                  ))
              .toList(),
          theme,
          font,
          boldFont,
        ),
        _buildSection(
          'Education',
          educationDetails
              .map((edu) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            edu.degree,
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 12,
                              color: theme.primaryColor,
                            ),
                          ),
                          pw.Text(
                            edu.year,
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                              color: theme.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      pw.Text(
                        edu.institution,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: theme.secondaryColor,
                        ),
                      ),
                      if (edu.gpa != null && edu.gpa!.isNotEmpty)
                        pw.Text(
                          'GPA: ${edu.gpa}',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                            color: theme.textColor,
                          ),
                        ),
                      pw.SizedBox(height: 8),
                    ],
                  ))
              .toList(),
          theme,
          font,
          boldFont,
        ),
        _buildSection(
          'Skills',
          [
            pw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills
                  .map((skill) => pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: theme.primaryColor,
                            width: 1,
                          ),
                          borderRadius: const pw.BorderRadius.all(
                            pw.Radius.circular(4),
                          ),
                        ),
                        child: pw.Text(
                          skill.name,
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                            color: theme.primaryColor,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
          theme,
          font,
          boldFont,
        ),
      ],
    );
  }

  static pw.Widget _buildMinimalLayout(
    PersonalDetails personalDetails,
    List<EducationDetails> educationDetails,
    List<WorkExperience> workExperiences,
    List<Skill> skills,
    _TemplateTheme theme,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        _buildSection(
          'Work Experience',
          workExperiences
              .map((exp) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        exp.position,
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 14,
                          color: theme.primaryColor,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        exp.company,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 12,
                          color: theme.secondaryColor,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        '${exp.startDate} - ${exp.endDate}',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: theme.textColor,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        exp.description,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: theme.textColor,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 8),
                    ],
                  ))
              .toList(),
          theme,
          font,
          boldFont,
        ),
        _buildSection(
          'Education',
          educationDetails
              .map((edu) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        edu.degree,
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 12,
                          color: theme.primaryColor,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        edu.institution,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: theme.secondaryColor,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        edu.year,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: theme.textColor,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      if (edu.gpa != null && edu.gpa!.isNotEmpty)
                        pw.Text(
                          'GPA: ${edu.gpa}',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                            color: theme.textColor,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      pw.SizedBox(height: 8),
                    ],
                  ))
              .toList(),
          theme,
          font,
          boldFont,
        ),
        _buildSection(
          'Skills',
          [
            pw.Wrap(
              alignment: pw.WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: skills
                  .map((skill) => pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#F5F5F5'),
                          borderRadius: const pw.BorderRadius.all(
                            pw.Radius.circular(4),
                          ),
                        ),
                        child: pw.Text(
                          skill.name,
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                            color: theme.primaryColor,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
          theme,
          font,
          boldFont,
        ),
      ],
    );
  }

  static pw.Widget _buildSection(
    String title,
    List<pw.Widget> children,
    _TemplateTheme theme,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 8),
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(
                color: theme.primaryColor,
                width: 1,
              ),
            ),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 16,
              color: theme.primaryColor,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        ...children,
        pw.SizedBox(height: 16),
      ],
    );
  }
}

class _TemplateTheme {
  final PdfColor primaryColor;
  final PdfColor secondaryColor;
  final PdfColor backgroundColor;
  final PdfColor textColor;

  _TemplateTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.textColor,
  });
}
