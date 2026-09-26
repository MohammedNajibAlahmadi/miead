import 'package:flutter/material.dart';

class FridayScreen extends StatelessWidget {
  const FridayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طُقوس الجُمعَة')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF006A4E), Color(0xFF1B5E20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.mosque_outlined, color: Colors.white70, size: 40),
                const SizedBox(height: 16),
                const Text(
                  'جُمعتكم مباركة وطيّبة',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'في هذا اليوم الفضيل، تتنزل الرحمات، وتعج المساجد بالدعوات.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('مهام الجمعة الأساسية', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.menu_book),
              title: Text('قراءة سورة الكهف'),
              subtitle: Text('نورٌ ما بين الجمعتين'),
              trailing: Icon(Icons.check_circle_outline),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.favorite),
              title: Text('الصلاة على النبي ﷺ'),
              subtitle: Text('الإكثار من الصلاة والسلام على رسول الله'),
              trailing: Icon(Icons.check_circle_outline),
            ),
          ),
          const SizedBox(height: 24),
          Text('السنن والآداب الإسلامية', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFD4AF37), width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('السواك والطيب (العطر)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFD4AF37))),
                  const SizedBox(height: 8),
                  const Text('من أعظم السنن يوم الجمعة استخدام السواك لتطهير الفم، والتطيب بأزكى الروائح كالعود والمسك قبل الخروج للمسجد، إحياءً لهدي النبي ﷺ وتوقيراً لهذا اليوم الفضيل.'),
                  const SizedBox(height: 12),
                  // Placeholder for image: 
                  // Image.asset('assets/images/friday/islamic_friday_heritage.webp', height: 120, width: double.infinity, fit: BoxFit.cover),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFD4AF37), width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الزي الإسلامي (الثوب والشال)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFD4AF37))),
                  const SizedBox(height: 8),
                  const Text('لبس أحسن الثياب كالثوب الأبيض العتيق والشال، استشعاراً للقاء الله في صلاة الجماعة، ولإظهار الفرحة والسكينة.'),
                  const SizedBox(height: 12),
                  // Placeholder for image: 
                  // Image.asset('assets/images/friday/islamic_friday_clothes.webp', height: 120, width: double.infinity, fit: BoxFit.cover),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
