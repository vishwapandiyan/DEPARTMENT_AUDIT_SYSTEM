import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/user.dart';
import '../models/audit_item.dart';
import '../models/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/chart_card.dart';

class ReportsScreen extends StatefulWidget {
  final User user;

  const ReportsScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<AuditItem> _auditItems = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  String _selectedPeriod = 'all'; // all, this_month, last_month, this_quarter

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

  void _exportPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF export functionality will be implemented with backend integration'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _exportExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Excel export functionality will be implemented with backend integration'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
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
          // Header
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
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.chartBar,
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
                            'Audit Reports & Analytics',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.textDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.user.isHoD 
                                ? 'Department-wide analytics and insights'
                                : 'Your personal audit analytics',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Export Buttons
                    OutlinedButton.icon(
                      onPressed: _exportPDF,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Export PDF'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _exportExcel,
                      icon: const Icon(Icons.table_chart),
                      label: const Text('Export Excel'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Period Filter
                Row(
                  children: [
                    const Text(
                      'Period:',
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _selectedPeriod,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All Time')),
                        DropdownMenuItem(value: 'this_month', child: Text('This Month')),
                        DropdownMenuItem(value: 'last_month', child: Text('Last Month')),
                        DropdownMenuItem(value: 'this_quarter', child: Text('This Quarter')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPeriod = value ?? 'all';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Main Charts
          if (widget.user.isHoD) ...[
            // HoD Charts
            _buildHoDCharts(),
          ] else ...[
            // Staff Charts
            _buildStaffCharts(),
          ],

          const SizedBox(height: 24),

          // Trend Analysis
          _buildTrendAnalysis(),

          const SizedBox(height: 24),

          // Summary Statistics
          _buildSummaryStatistics(),
        ],
      ),
    );
  }

  Widget _buildHoDCharts() {
    return Column(
      children: [
        // Top Row Charts
        Row(
          children: [
            Expanded(
              child: ChartCard(
                title: 'Department Completion Overview',
                child: SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 60,
                      sections: [
                        PieChartSectionData(
                          color: AppTheme.success,
                          value: _stats['completedItems'].toDouble(),
                          title: 'Completed\n${_stats['completedItems']}',
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.pureWhite,
                          ),
                          radius: 80,
                        ),
                        PieChartSectionData(
                          color: AppTheme.warning,
                          value: _stats['pendingItems'].toDouble(),
                          title: 'Pending\n${_stats['pendingItems']}',
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.pureWhite,
                          ),
                          radius: 80,
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
                title: 'Staff Performance Comparison',
                child: SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 41,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: AppTheme.primaryBlue,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final staffUsers = DummyData.users.where((u) => u.isStaff).toList();
                            if (groupIndex < staffUsers.length) {
                              return BarTooltipItem(
                                '${staffUsers[groupIndex].name}\n${rod.toY.toInt()} completed',
                                const TextStyle(color: AppTheme.pureWhite),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
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
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        horizontalInterval: 10,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppTheme.lightGrey,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      barGroups: _buildBarGroups(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Department Progress by Category
        ChartCard(
          title: 'Progress by Audit Category',
          child: SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.lightGrey,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const categories = ['Student', 'Academic', 'Faculty', 'Admin', 'Research'];
                        if (value.toInt() < categories.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              categories[value.toInt()],
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
                          '${value.toInt()}%',
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
                minX: 0,
                maxX: 4,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 75),
                      const FlSpot(1, 60),
                      const FlSpot(2, 80),
                      const FlSpot(3, 55),
                      const FlSpot(4, 70),
                    ],
                    isCurved: true,
                    color: AppTheme.primaryBlue,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaffCharts() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ChartCard(
                title: 'Your Progress',
                child: SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 50,
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
                title: 'Completion Rate',
                child: Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_stats['completionRate']}%',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Completion Rate',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: _stats['completionRate'] / 100,
                          backgroundColor: AppTheme.lightGrey,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrendAnalysis() {
    return ChartCard(
      title: 'Completion Trend Over Time',
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 5,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: AppTheme.lightGrey,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                    if (value.toInt() < months.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          months[value.toInt()],
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
            minX: 0,
            maxX: 5,
            minY: 0,
            maxY: 30,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 5),
                  const FlSpot(1, 12),
                  const FlSpot(2, 18),
                  const FlSpot(3, 22),
                  const FlSpot(4, 25),
                  const FlSpot(5, 28),
                ],
                isCurved: true,
                color: AppTheme.success,
                barWidth: 3,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.success.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryStatistics() {
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
                Icons.summarize,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Summary Statistics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Statistics Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3,
            children: [
              _buildStatItem(
                'Total Items',
                _stats['totalItems'].toString(),
                Icons.list_alt,
                AppTheme.primaryBlue,
              ),
              _buildStatItem(
                'Completed',
                _stats['completedItems'].toString(),
                Icons.check_circle,
                AppTheme.success,
              ),
              _buildStatItem(
                'Pending',
                _stats['pendingItems'].toString(),
                Icons.pending,
                AppTheme.warning,
              ),
              _buildStatItem(
                'Completion Rate',
                '${_stats['completionRate']}%',
                Icons.trending_up,
                AppTheme.primaryBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
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
} 