import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_market/features/gem_market/provider/gem_list_provider.dart';
import 'package:job_market/features/gem_market/viewmodel/gem_evaluate_viewmodel.dart';
import 'package:job_market/features/inventory/view/add_new_gemstone_inventory.dart';
import 'package:job_market/shared/widgets/app_header.dart';

class GemEvaluateScreen extends ConsumerWidget {
  const GemEvaluateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gemsAsync = ref.watch(gemListProvider);
    final evaluateNotifier = ref.read(gemEvaluateViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddNewGemstoneScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Gem'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => GoRouter.of(context).go('/profile'),
                      tooltip: 'Back to Profile',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Gem Evaluation',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const AppHeader(),
            Expanded(
              child: gemsAsync.when(
                data: (gems) {
                  if (gems.isEmpty) {
                    return const _EmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(gemListProvider);
                      await ref.watch(gemListProvider.future);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      itemCount: gems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final gem = gems[index];
                        return _GemCard(
                          gem: gem,
                          onDelete: () async {
                            final confirmed = await _showDeleteDialog(context);

                            // 1. Debugging prints (keep these if you're still troubleshooting)
                            print('Confirmed: $confirmed');
                            print('Gem ID: ${gem.gemId}');

                            // 2. Early exit
                            if (confirmed != true || gem.gemId == null) return;

                            // 3. Perform the delete
                            final success = await evaluateNotifier.deleteGem(
                              gem.gemId!,
                            );

                            print('success: $success');

                            // 4. CRITICAL: Check if the widget is still "alive" before using context
                            if (!context.mounted) return;

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gem removed successfully'),
                                ),
                              );
                              // Optional: Navigate back after success
                              // context.pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Unable to remove gem. Please try again.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Unable to load gems: $error',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Gem?'),
        content: const Text(
          'Are you sure you want to remove this gem from the evaluation list?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _GemCard extends StatelessWidget {
  final dynamic gem;
  final VoidCallback onDelete;

  const _GemCard({required this.gem, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = gem.imageUrl as String?;
    final statusColor = _statusColor(gem.status);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(24),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.dividerColor.withOpacity(0.35)),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: 74,
                  height: 74,
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildPlaceholder(theme),
                        )
                      : _buildPlaceholder(theme),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gem.name as String? ?? 'Untitled Gem',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${gem.carat ?? 0} ct • ${gem.variety ?? 'Unknown variety'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _statusLabel(gem.status),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (gem.price != null)
                          Text(
                            '\u007F${(gem.price as double).toStringAsFixed(0)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(dynamic status) {
    final name = status.toString().toLowerCase();
    if (name.contains('approved')) return const Color(0xFF10B981);
    if (name.contains('rejected')) return const Color(0xFFEF4444);
    return const Color(0xFFF59E0B);
  }

  String _statusLabel(dynamic status) {
    final name = status.toString().split('.').last;
    return name.toUpperCase();
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceVariant,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 28,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_mode_outlined,
              size: 68,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
            const SizedBox(height: 22),
            Text(
              'No gems available for evaluation yet.',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Add a gem to start evaluating prices, status, and market fit.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
