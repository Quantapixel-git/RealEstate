import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(home: AlertDialogDemo()));
}

class AlertDialogDemo extends StatelessWidget {
  const AlertDialogDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDialogButton(context, "Show Approval Required", true),
            SizedBox(height: 20),
            _buildDialogButton(context, "Show Profile Approved", false),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogButton(
      BuildContext context, String title, bool isApprovalRequired) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => _buildCustomDialog(context, isApprovalRequired),
        );
      },
      child: Text(title,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
    );
  }

  Widget _buildCustomDialog(BuildContext context, bool isApprovalRequired) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(isApprovalRequired),
            const SizedBox(height: 10),
            Text(
              isApprovalRequired ? "Approval Required" : "Profile Approved",
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              isApprovalRequired
                  ? "Your profile is under admin approval. It will be executed as soon as the approver validates the action."
                  : "Congratulations! Your profile has been successfully reviewed and approved. You now have full access to all features and services.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            _buildActionButton(context, isApprovalRequired),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(bool isApprovalRequired) {
    return Icon(
      isApprovalRequired
          ? Icons.watch_later_outlined
          : Icons.check_circle_outline,
      color: Colors.orange,
      size: 60,
    );
  }

  Widget _buildActionButton(BuildContext context, bool isApprovalRequired) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(
          isApprovalRequired ? "I Understand" : "Continue",
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
