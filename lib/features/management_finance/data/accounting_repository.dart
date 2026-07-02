import 'dart:async';

class StudentFinance {
  final String studentId;
  final String name;
  final double totalFees;
  final double paidAmount;
  final int installmentsPaid; // Out of 5
  bool isBlocked;

  StudentFinance({
    required this.studentId,
    required this.name,
    required this.totalFees,
    required this.paidAmount,
    required this.installmentsPaid,
    this.isBlocked = false,
  });

  double get remainingBalance => totalFees - paidAmount;
  double get progressPercentage => installmentsPaid / 5;
}

class AccountingRepository {
  // Simulating fetching the financial records from the database
  Future<List<StudentFinance>> fetchStudentFinances() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      StudentFinance(studentId: 'S001', name: 'Ahmad Hassan', totalFees: 2500.0, paidAmount: 2500.0, installmentsPaid: 5, isBlocked: false),
      StudentFinance(studentId: 'S002', name: 'Shilan Azad', totalFees: 2500.0, paidAmount: 1500.0, installmentsPaid: 3, isBlocked: false),
      StudentFinance(studentId: 'S003', name: 'Rebwar Ali', totalFees: 2500.0, paidAmount: 0.0, installmentsPaid: 0, isBlocked: true), // Blocked due to non-payment
    ];
  }

  // Simulating an API call to block/unblock a student
  Future<bool> toggleStudentBlockStatus(String studentId, bool currentStatus) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, this sends a POST/PUT request to your PHP/MySQL backend
    return !currentStatus;
  }
}