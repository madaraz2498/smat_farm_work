import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_farm/theme/app_theme.dart';

class AdminStatsGrid extends StatelessWidget {
  const AdminStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم LayoutBuilder لتحديد عدد الكروت في السطر بناءً على المساحة
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return Wrap(
          spacing: 16, // المسافة الأفقية بين الكروت
          runSpacing: 16, // المسافة الرأسية عند النزول لسطر جديد
          children: [
            _StatCard(
              title: "Total Analyses",
              value: "8,456",
              badge: "+23%",
              subtitle: "this month",
              isMobile: isMobile,
              svgPath: 'assets/images/icons/total analyses.svg',
            ),
            _StatCard(
              title: "Total Users",
              value: "1,247",
              badge: "+12%",
              subtitle: "registered",
              isMobile: isMobile,
              svgPath: 'assets/images/icons/total users.svg',
            ),

            _StatCard(
              title: "AI Services",
              value: "6 / 6",
              badge: "All Online",
              subtitle: "active",
              isMobile: isMobile,
              svgPath: 'assets/images/icons/ai services.svg',
            ),
            _StatCard(
              title: "Most Used",
              value: "Plant Disease",
              badge: "Top",
              subtitle: "Detection",
              isMobile: isMobile,
              svgPath: 'assets/images/icons/most used.svg',
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value, badge, subtitle;
  final bool isMobile;
  final String svgPath;

  const _StatCard({
    required this.title,
    required this.value,
    required this.badge,
    required this.subtitle,
    required this.isMobile,
    required this.svgPath,
  });

  @override
  Widget build(BuildContext context) {
    // حساب العرض بحيث يظهر كارتين في الصف في الموبايل أو 4 في الشاشة الواسعة
    double cardWidth = isMobile
        ? (MediaQuery.of(context).size.width - 64) / 2
        : (MediaQuery.of(context).size.width / 4) - 32;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset( svgPath ,width: 40,height: 40,),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF53B175).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Color(0xFF53B175), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
            overflow: TextOverflow.ellipsis,
          ),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة بيانات تجريبية بناءً على التصميم اللي بعته
    final List<Map<String, String>> activities = [
      {
        'user': 'John Farmer',
        'action': 'Used Plant Disease Detection',
        'time': '2 minutes ago'
      },
      {
        'user': 'Sarah Miller',
        'action': 'Completed Soil Analysis',
        'time': '15 minutes ago'
      },
      {
        'user': 'Mike Johnson',
        'action': 'Requested Crop Recommendation',
        'time': '1 hour ago'
      },
      {
        'user': 'Emma Wilson',
        'action': 'Used Animal Weight Estimation',
        'time': '2 hours ago'
      },
      {
        'user': 'David Brown',
        'action': 'Analyzed Fruit Quality',
        'time': '3 hours ago'
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent System Activity",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1C1E),
            ),
          ),
          const SizedBox(height: 16),
          // إنشاء القائمة بناءً على البيانات
          ListView.separated(
            shrinkWrap: true, // مهم جداً عشان يشتغل جوه Column
            physics: const NeverScrollableScrollPhysics(), // السكرول هيكون للصفحة كلها
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
            itemBuilder: (context, index) {
              final item = activities[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    // أيقونة المستخدم (Avatar)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF53B175).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF53B175),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // تفاصيل النشاط
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['user']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            item['action']!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // الوقت
                    Text(
                      item['time']!,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}