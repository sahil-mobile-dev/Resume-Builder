import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:google_fonts/google_fonts.dart';
import 'objectbox.g.dart';
import 'models/resume_models.dart';
import 'pages/section_selection_page.dart';
import 'pages/template_selection_page.dart';
import 'services/pdf_service.dart';

void main() {
  runApp(const ResumeBuilderApp());
}

class ResumeBuilderApp extends StatelessWidget {
  const ResumeBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resume Builder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Deep Indigo
          primary: const Color(0xFF1A237E),
          secondary: const Color(0xFF00BFA5), // Teal
          tertiary: const Color(0xFFFF6D00), // Deep Orange
          background: const Color(0xFFF5F5F5),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF1A237E),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late Box<PersonalDetails> personalDetailsBox;
  late Box<EducationDetails> educationDetailsBox;
  late Box<WorkExperience> workExperiencesBox;
  late Box<Skill> skillsBox;
  late Store store;

  final PersonalDetails personalDetails = PersonalDetails();
  final List<EducationDetails> educationDetails = [];
  final List<WorkExperience> workExperiences = [];
  final List<Skill> skills = [];
  ResumeTemplate selectedTemplate = ResumeTemplate.modern;

  @override
  void initState() {
    super.initState();
    _initObjectBox();
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

  Future<void> _initObjectBox() async {
    final dir = await getApplicationDocumentsDirectory();
    store = await openStore(directory: dir.path);
    personalDetailsBox = store.box<PersonalDetails>();
    educationDetailsBox = store.box<EducationDetails>();
    workExperiencesBox = store.box<WorkExperience>();
    skillsBox = store.box<Skill>();
    _loadData();
  }

  Future<void> _loadData() async {
    final personalDetailsList = personalDetailsBox.getAll();
    if (personalDetailsList.isNotEmpty) {
      setState(() {
        personalDetails.fullName = personalDetailsList.first.fullName;
        personalDetails.email = personalDetailsList.first.email;
        personalDetails.phone = personalDetailsList.first.phone;
        personalDetails.address = personalDetailsList.first.address;
        personalDetails.professionalSummary =
            personalDetailsList.first.professionalSummary;
        personalDetails.linkedIn = personalDetailsList.first.linkedIn;
        personalDetails.github = personalDetailsList.first.github;
        personalDetails.portfolio = personalDetailsList.first.portfolio;
        // personalDetails. = personalDetailsList.first.achievements;
      });
    }

    setState(() {
      educationDetails.addAll(educationDetailsBox.getAll());
      workExperiences.addAll(workExperiencesBox.getAll());
      skills.addAll(skillsBox.getAll());
    });
  }

  Future<void> _saveData() async {
    await personalDetailsBox.put(personalDetails);
    await educationDetailsBox.putMany(educationDetails);
    await workExperiencesBox.putMany(workExperiences);
    await skillsBox.putMany(skills);
  }

  void _navigateToSectionSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SectionSelectionPage(
          personalDetails: personalDetails,
          educationDetails: educationDetails,
          workExperiences: workExperiences,
          skills: skills,
          onGeneratePdf: _previewResume,
        ),
      ),
    );
  }

  void _startNewResume() {
    setState(() {
      personalDetails.fullName = '';
      personalDetails.email = '';
      personalDetails.phone = '';
      personalDetails.address = '';
      personalDetails.professionalSummary = '';
      personalDetails.linkedIn = '';
      personalDetails.github = '';
      personalDetails.portfolio = '';
      // personalDetails.achievements = '';
      educationDetails.clear();
      workExperiences.clear();
      skills.clear();
    });
    _navigateToSectionSelection();
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
          personalDetails: personalDetails,
          educationDetails: educationDetails,
          workExperiences: workExperiences,
          skills: skills,
        ),
      ),
    );
  }

  Future<void> _previewResume() async {
    await _saveData();
    final file = await PdfService.generateResume(
      personalDetails: personalDetails,
      educationDetails: educationDetails,
      workExperiences: workExperiences,
      skills: skills,
      template: selectedTemplate,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resume preview generated successfully!')),
      );
      OpenFile.open(file.path);
    }
  }

  Future<void> _generatePdf() async {
    await _saveData();
    final file = await PdfService.generateResume(
      personalDetails: personalDetails,
      educationDetails: educationDetails,
      workExperiences: workExperiences,
      skills: skills,
      template: selectedTemplate,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resume PDF generated successfully!')),
      );
      OpenFile.open(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasExistingResume = personalDetails.fullName.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Builder'),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasExistingResume) ...[
                      Text(
                        'Welcome Back!',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Continue editing your resume for ${personalDetails.fullName}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Current Template: ${selectedTemplate.toString().split('.').last}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _navigateToSectionSelection,
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Resume'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: _startNewResume,
                        icon: const Icon(Icons.add),
                        label: const Text('Create New Resume'),
                      ),
                    ] else ...[
                      Text(
                        'Create Your Professional Resume',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start building your resume by selecting a section',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _navigateToSectionSelection,
                        icon: const Icon(Icons.add),
                        label: const Text('Create New Resume'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
