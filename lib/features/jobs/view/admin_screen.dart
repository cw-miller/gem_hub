import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:job_market/features/jobs/viewmodels/job_viewmodel.dart';
import 'package:job_market/features/marketplace/viewmodels/marketplace_viewmodel.dart';
import 'package:job_market/data/datasources/local/database_helper.dart';
import 'package:job_market/features/auth/viewmodels/auth_viewmodel.dart';

class AdminJobReviewScreen extends ConsumerStatefulWidget {
  const AdminJobReviewScreen({super.key});

  @override
  ConsumerState<AdminJobReviewScreen> createState() =>
      _AdminJobReviewScreenState();
}

class _AdminJobReviewScreenState
    extends ConsumerState<AdminJobReviewScreen> {
  final Color primaryGreen = const Color(0xFF10C971);
  final Color primaryYellow = const Color(0xFFFDB913);
  final Color bgColor = const Color(0xFFF8F9FA);
  final Color textColor = const Color(0xFF111827);
  final Color greyText = const Color(0xFF6B7280);

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to log out of the admin panel?',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: greyText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext); // close dialog

                // ✅ Optional: clear auth state
                // ref.read(authViewModelProvider.notifier).logout();

                // ✅ GoRouter navigation
                context.go('/login');
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingJobsState = ref.watch(pendingJobsViewModelProvider);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAdminHeader(context),
            _buildSearchBar(),
            _buildCategories(),
            _buildSectionHeader(
              'Pending Job Post Listings',
              Icons.hourglass_empty,
            ),
            Expanded(
              child: pendingJobsState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFDB913),
                  ),
                ),
                error: (error, stack) =>
                    Center(child: Text('Error: $error')),
                data: (pendingJobs) {
                  if (pendingJobs.isEmpty) {
                    return const Center(
                      child: Text(
                        'All caught up! No pending jobs.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: pendingJobs.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final job = pendingJobs[index];

                      // return JobPostReviewCard(
                      //   title: job.title,
                      //   companyInfo: job.companyInfo,
                      //   salary: job.salary,
                      //   tags: job.tags.split(','),
                      //   logoColor: Color(job.logoColor),

                      //   onAccept: () async {
                      //     await ref
                      //         .read(
                      //             pendingJobsViewModelProvider.notifier)
                      //         .updateJobStatus(
                      //             job.id!, 'approved');

                      //     ref.invalidate(
                      //         marketplaceViewModelProvider);

                      //     await DatabaseHelper().addNotification(
                      //       job.employerId,
                      //       "Job Approved! ✅",
                      //       "Your job '${job.title}' is now live.",
                      //     );

                      //     if (mounted) {
                      //       ScaffoldMessenger.of(context)
                      //           .showSnackBar(
                      //         SnackBar(
                      //           content:
                      //               Text('Accepted: ${job.title}'),
                      //           backgroundColor: primaryGreen,
                      //         ),
                      //       );
                      //     }
                      //   },

                      //   onReject: () async {
                      //     await ref
                      //         .read(
                      //             pendingJobsViewModelProvider.notifier)
                      //         .updateJobStatus(
                      //             job.id!, 'rejected');

                      //     await DatabaseHelper().addNotification(
                      //       job.employerId,
                      //       "Job Update ⚠️",
                      //       "Your job '${job.title}' was not approved.",
                      //     );

                      //     if (mounted) {
                      //       ScaffoldMessenger.of(context)
                      //           .showSnackBar(
                      //         SnackBar(
                      //           content:
                      //               Text('Rejected: ${job.title}'),
                      //           backgroundColor:
                      //               const Color(0xFFEF4444),
                      //         ),
                      //       );
                      //     }
                      //   },
                      // );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: primaryYellow,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/150?img=33'),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Admin - Job Post Review',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() => const SizedBox();
  Widget _buildCategories() => const SizedBox();

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }
}