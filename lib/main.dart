import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'calculator_engine.dart';
import 'graph_widget.dart';
import 'app_theme.dart';
import 'basic_calculator.dart';
import 'scientific_calculator.dart';
import 'graph_calculator.dart';
import 'responsive_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const GraphicCalculatorApp());
}

class GraphicCalculatorApp extends StatefulWidget {
  const GraphicCalculatorApp({super.key});

  @override
  State<GraphicCalculatorApp> createState() => _GraphicCalculatorAppState();
}

class _GraphicCalculatorAppState extends State<GraphicCalculatorApp> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Графический калькулятор',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: CalculatorScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: (isDark) {
          setState(() {
            _isDarkMode = isDark;
          });
        },
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const CalculatorScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.onThemeChanged(!isDark),
            tooltip: isDark ? 'Светлая тема' : 'Темная тема',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Обычный'),
            Tab(text: 'Инженерный'),
            Tab(text: 'График'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BasicCalculator(isDarkMode: isDark),
          ScientificCalculator(isDarkMode: isDark),
          GraphCalculator(isDarkMode: isDark),
        ],
      ),
    );
  }
}
