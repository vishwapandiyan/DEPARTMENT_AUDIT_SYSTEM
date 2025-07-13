import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/user.dart';
import '../models/dummy_data.dart';
import '../models/audit_item.dart';
import '../theme/app_theme.dart';
import '../widgets/summary_card.dart';
import '../widgets/chart_card.dart';

class DashboardScreen extends StatefulWidget {
  final User user;

  const DashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<AuditItem> _auditItems;
  late Map<String, dynamic> _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (widget.user.isHoD) {
      _auditItems = DummyData.getAllAuditItems();
      _stats = DummyData.getDepartmentStats();
    } else {
      _auditItems = DummyData.getAuditItemsForUser(widget.user.id);
      _stats = _calculateUserStats(_auditItems);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Map<String, dynamic> _calculateUserStats(List<AuditItem> items) {
    int totalItems = items.length;
    int completedItems = items.where((item) => item.isCompleted).length;
    int pendingItems = totalItems - completedItems;

    return {
      'totalItems': totalItems,
      'completedItems': completedItems,
      'pendingItems': pendingItems,
      'completionRate': totalItems > 0 ? (completedItems / totalItems * 100).round() : 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.pureWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.chartLine,
                    color: AppTheme.pureWhite,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${widget.user.name.split(' ').first}!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.user.isHoD 
                            ? 'Department overview and analytics'
                            : 'Your audit progress and summary',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Summary Cards
          _buildSummaryCards(),

          const SizedBox(height: 24),

          // Charts Section
          if (widget.user.isHoD) ...[
            _buildHoDCharts(),
          ] else ...[
            _buildStaffCharts(),
          ],

          const SizedBox(height: 24),

          // Recent Activity
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          // Desktop: 4 cards in a row
          return _buildSummaryCardsRow(4);
        } else if (constraints.maxWidth > 800) {
          // Tablet: 2 cards in a row
          return _buildSummaryCardsRow(2);
        } else {
          // Mobile: 1 card in a row
          return _buildSummaryCardsRow(1);
        }
      },
    );
  }

  Widget _buildSummaryCardsRow(int cardsPerRow) {
    List<Widget> cards = [];

    if (widget.user.isHoD) {
      // HoD Cards
      cards = [
        SummaryCard(
          title: 'Total Audit Items',
          value: _stats['totalItems'].toString(),
          icon: FontAwesomeIcons.clipboardList,
          color: AppTheme.primaryBlue,
          subtitle: 'Across all staff',
        ),
        SummaryCard(
          title: 'Completed Items',
          value: _stats['completedItems'].toString(),
          icon: FontAwesomeIcons.circleCheck,
          color: AppTheme.success,
          subtitle: '${_stats['completionRate']}% completion rate',
        ),
        SummaryCard(
          title: 'Pending Items',
          value: _stats['pendingItems'].toString(),
          icon: FontAwesomeIcons.clock,
          color: AppTheme.warning,
          subtitle: 'Requires attention',
        ),
        SummaryCard(
          title: 'Staff Members',
          value: DummyData.users.where((u) => u.isStaff).length.toString(),
          icon: FontAwesomeIcons.users,
          color: AppTheme.primaryBlue,
          subtitle: 'Active staff',
        ),
      ];
    } else {
      // Staff Cards
      cards = [
        SummaryCard(
          title: 'Total Audit Items',
          value: '41',
          icon: FontAwesomeIcons.clipboardList,
          color: AppTheme.primaryBlue,
          subtitle: 'Your audit criteria',
        ),
        SummaryCard(
          title: 'Completed Items',
          value: _stats['completedItems'].toString(),
          icon: FontAwesomeIcons.circleCheck,
          color: AppTheme.success,
          subtitle: '${_stats['completionRate']}% completion rate',
        ),
        SummaryCard(
          title: 'Pending Items',
          value: _stats['pendingItems'].toString(),
          icon: FontAwesomeIcons.clock,
          color: AppTheme.warning,
          subtitle: 'Requires attention',
        ),
      ];
    }

    if (cardsPerRow == 1) {
      return Column(
        children: cards.map((card) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: card,
        )).toList(),
      );
    } else {
      List<Widget> rows = [];
      for (int i = 0; i < cards.length; i += cardsPerRow) {
        List<Widget> rowCards = cards.sublist(i, i + cardsPerRow > cards.length ? cards.length : i + cardsPerRow);
        rows.add(
          Row(
            children: rowCards.map((card) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: card,
              ),
            )).toList(),
          ),
        );
        if (i + cardsPerRow < cards.length) {
          rows.add(const SizedBox(height: 16));
        }
      }
      return Column(children: rows);
    }
  }

  Widget _buildHoDCharts() {
    return Row(
      children: [
        Expanded(
          child: ChartCard(
            title: 'Completion Overview',
            child: SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: AppTheme.success,
                      value: _stats['completedItems'].toDouble(),
                      title: 'Completed\n${_stats['completedItems']}',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.pureWhite,
                      ),
                      radius: 60,
                    ),
                    PieChartSectionData(
                      color: AppTheme.warning,
                      value: _stats['pendingItems'].toDouble(),
                      title: 'Pending\n${_stats['pendingItems']}',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.pureWhite,
                      ),
                      radius: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ChartCard(
            title: 'Staff Completion Rates',
            child: SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 41,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final staffUsers = DummyData.users.where((u) => u.isStaff).toList();
                          if (value.toInt() < staffUsers.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                staffUsers[value.toInt()].name.split(' ').first,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.textLight,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.textLight,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: _buildBarGroups(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaffCharts() {
    return ChartCard(
      title: 'Your Progress',
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 40,
            sections: [
              PieChartSectionData(
                color: AppTheme.success,
                value: _stats['completedItems'].toDouble(),
                title: 'Completed\n${_stats['completedItems']}',
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.pureWhite,
                ),
                radius: 60,
              ),
              PieChartSectionData(
                color: AppTheme.warning,
                value: _stats['pendingItems'].toDouble(),
                title: 'Pending\n${_stats['pendingItems']}',
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.pureWhite,
                ),
                radius: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    List<BarChartGroupData> groups = [];
    final staffUsers = DummyData.users.where((u) => u.isStaff).toList();
    
    for (int i = 0; i < staffUsers.length; i++) {
      final user = staffUsers[i];
      final userItems = DummyData.getAuditItemsForUser(user.id);
      final completedCount = userItems.where((item) => item.isCompleted).length;
      
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: completedCount.toDouble(),
              color: AppTheme.primaryBlue,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }
    
    return groups;
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.history,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Activity Items
          ...List.generate(5, (index) {
            final recentItems = _auditItems
                .where((item) => item.isCompleted)
                .toList()
                ..sort((a, b) => b.evaluationPeriod.compareTo(a.evaluationPeriod));
            
            if (index >= recentItems.length) {
              return const SizedBox.shrink();
            }
            
            final item = recentItems[index];
            final timeAgo = _getTimeAgo(item.evaluationPeriod);
            
            return Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.success,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppTheme.pureWhite,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.description,
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Completed $timeAgo',
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).where((widget) => widget != const SizedBox.shrink()).toList(),
          
          if (_auditItems.where((item) => item.isCompleted).isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'No recent activity',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
} 