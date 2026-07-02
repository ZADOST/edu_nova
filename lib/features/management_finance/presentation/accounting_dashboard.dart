import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/db/local_auth_db.dart';
import '../../../core/widgets/glass_container.dart';
import '../data/accounting_repository.dart';
import 'widgets/financial_glass_card.dart';

class AccountingDashboard extends StatefulWidget {
  const AccountingDashboard({super.key});

  @override
  State<AccountingDashboard> createState() => _AccountingDashboardState();
}

class _AccountingDashboardState extends State<AccountingDashboard> {
  final AccountingRepository _repository = AccountingRepository();
  List<StudentFinance> _finances = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _repository.fetchStudentFinances();
      setState(() {
        _finances = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleBlockStatus(int index) async {
    final student = _finances[index];
    final newStatus = await _repository.toggleStudentBlockStatus(student.studentId, student.isBlocked);
    
    setState(() {
      _finances[index].isBlocked = newStatus;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newStatus ? '${student.name} has been BLOCKED' : '${student.name} is now ACTIVE'),
          backgroundColor: newStatus ? Colors.redAccent : AppTheme.deepTeal,
        ),
      );
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final authDb = LocalAuthDb(prefs);
    await authDb.clearSession();
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    double totalCollected = _finances.fold(0, (sum, item) => sum + item.paidAmount);
    double totalExpected = _finances.fold(0, (sum, item) => sum + item.totalFees);

    return Scaffold(
      backgroundColor: AppTheme.darkCharcoal,
      appBar: AppBar(
        title: const Text('Finance & Accounting'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.mintGlow),
            onPressed: () => _handleLogout(context),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.mintGlow))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // High-level Revenue Overview
                  GlassContainer(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Semester Revenue', style: TextStyle(color: AppTheme.mintGlow, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('\$${totalCollected.toStringAsFixed(0)}', style: const TextStyle(color: AppTheme.pureWhite, fontSize: 36, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: totalExpected > 0 ? totalCollected / totalExpected : 0,
                          backgroundColor: AppTheme.darkCharcoal,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.mintGlow),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        Text('Target: \$${totalExpected.toStringAsFixed(0)}', style: TextStyle(color: AppTheme.pureWhite.withOpacity(0.6), fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text('Student Installment Status', style: TextStyle(color: AppTheme.pureWhite, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  // Dynamic List of Student Financial Cards
                  ...List.generate(_finances.length, (index) {
                    return FinancialGlassCard(
                      financeRecord: _finances[index],
                      onToggleBlock: () => _toggleBlockStatus(index),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}