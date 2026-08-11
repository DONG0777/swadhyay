import 'package:flutter/material.dart';
import '../services/content_service.dart';
import '../models/content_model.dart';
import '../screens/pillar_detail_screen.dart';
import '../generated/l10n/app_localizations.dart';

class DailyPillarsWidget extends StatefulWidget {
  const DailyPillarsWidget({super.key});

  @override
  State<DailyPillarsWidget> createState() => _DailyPillarsWidgetState();
}

class _DailyPillarsWidgetState extends State<DailyPillarsWidget> {
  final ContentService _service = ContentService();
  List<ContentModel> _pillars = [];
  bool _isLoading = true;
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _loadPillars();
      _isFirstLoad = false;
    }
  }

  Future<void> _loadPillars() async {
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    try {
      // 🔥 সব পিলার লোড করুন (শ্লোক, উক্তি, বই, সূর্য নমস্কার, নাগরিক কর্তব্য)
      final data = await _service.getPillars(languageCode: lang);
      setState(() {
        _pillars = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('❌ Pillars load error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_pillars.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '📭 কোনো পিলার পাওয়া যায়নি। অ্যাডমিন প্যানেলে যোগ করুন।',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '🌸 ${local.challenge}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF6B00)),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: _pillars.length,
          itemBuilder: (context, index) {
            final pillar = _pillars[index];
            return _PillarCard(pillar: pillar);
          },
        ),
      ],
    );
  }
}

class _PillarCard extends StatelessWidget {
  final ContentModel pillar;

  const _PillarCard({required this.pillar});

  @override
  Widget build(BuildContext context) {
    // content_type অনুযায়ী আইকন ও রং নির্ধারণ
    IconData iconData;
    Color color;
    switch (pillar.contentType) {
      case 'shloka':
        iconData = Icons.auto_awesome;
        color = Colors.orange;
        break;
      case 'quote':
        iconData = Icons.format_quote;
        color = Colors.teal;
        break;
      case 'book':
        iconData = Icons.book;
        color = Colors.brown;
        break;
      case 'surya':
        iconData = Icons.self_improvement;
        color = Colors.redAccent;
        break;
      case 'duty':
        iconData = Icons.gavel;
        color = Colors.blue;
        break;
      default:
        iconData = Icons.star;
        color = Colors.deepPurple;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PillarDetailScreen(
                pillar: pillar,
                color: color,
                icon: iconData,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                iconData,
                size: 32,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(height: 12),
              Text(
                pillar.title ?? pillar.contentType,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                pillar.content?.substring(0, 30) ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
