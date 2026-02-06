import 'package:flutter/material.dart';
import 'package:alerts/database_helper.dart';

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  final List<DiagnosticItem> _items = [];
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isChecking = true;
      _items.clear();
    });

    // 1. Test SQLite
    await _checkDatabase();

    // 2. Test Admin User
    await _checkAdminUser();

    setState(() => _isChecking = false);
  }

  Future<void> _checkDatabase() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table'"
      );

      _addItem(
        '✅ Base de données SQLite',
        'Connectée - ${tables.length} tables',
        Colors.green,
      );
    } catch (e) {
      _addItem(
        '❌ Base de données SQLite',
        'Erreur: $e',
        Colors.red,
      );
    }
  }

  Future<void> _checkAdminUser() async {
    try {
      final admin = await DatabaseHelper.instance.getUserByPhone('admin');

      if (admin != null) {
        _addItem(
          '✅ Utilisateur Admin',
          'Trouvé: ${admin.fullName}',
          Colors.green,
        );
      } else {
        _addItem(
          '⚠️ Utilisateur Admin',
          'Non trouvé',
          Colors.orange,
        );
      }
    } catch (e) {
      _addItem(
        '❌ Utilisateur Admin',
        'Erreur: $e',
        Colors.red,
      );
    }
  }

  void _addItem(String title, String subtitle, Color color) {
    if (mounted) {
      setState(() {
        _items.add(DiagnosticItem(
          title: title,
          subtitle: subtitle,
          color: color,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostic de l\'Application'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _runDiagnostics,
          ),
        ],
      ),
      body: _isChecking
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Vérification en cours...'),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.circle,
                  color: item.color,
                  size: 20,
                ),
              ),
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item.subtitle),
            ),
          );
        },
      ),
    );
  }
}

class DiagnosticItem {
  final String title;
  final String subtitle;
  final Color color;

  DiagnosticItem({
    required this.title,
    required this.subtitle,
    required this.color,
  });
}