import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/content_model.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/share_service.dart';

class SuryaNamaskarScreen extends StatefulWidget {
  final ContentModel pillar;
  final Color color;
  final IconData icon;

  const SuryaNamaskarScreen({
    super.key,
    required this.pillar,
    required this.color,
    required this.icon,
  });

  @override
  State<SuryaNamaskarScreen> createState() => _SuryaNamaskarScreenState();
}

class _SuryaNamaskarScreenState extends State<SuryaNamaskarScreen> {
  List<Map<String, String>> _steps = [];
  int _currentIndex = 0;
  bool _isXpClaimed = false;
  String _userId = 'guest_123';
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _parseSteps();
    _loadStatus();
  }

  void _parseSteps() {
    final content = widget.pillar.content ?? '[]';
    try {
      final List<dynamic> data = jsonDecode(content);
      _steps = data.map((e) => {
        'step': e['step'] ?? '',
        'mantra': e['mantra'] ?? '',
        'meaning': e['meaning'] ?? '',
      }).cast<Map<String, String>>().toList();
    } catch (e) {
      // JSON না থাকলে ডিফল্ট ডেটা
      _steps = [
        {'step': 'প্রাণামাসন', 'mantra': 'ওঁ মিত্রায় নমঃ', 'meaning': 'মিত্রের প্রতি শ্রদ্ধা - বন্ধুত্ব ও স্নেহের প্রতীক'},
        {'step': 'হস্ত উত্তানাসন', 'mantra': 'ওঁ রবয়ে নমঃ', 'meaning': 'সূর্যের প্রতি শ্রদ্ধা - যে আলো ও জীবন দান করেন'},
        {'step': 'পদহস্তাসন', 'mantra': 'ওঁ সূর্যায় নমঃ', 'meaning': 'সূর্য দেবতার প্রতি শ্রদ্ধা - সকল জীবনের উৎস'},
        {'step': 'অশ্ব সঞ্চালনাসন', 'mantra': 'ওঁ ভানবে নমঃ', 'meaning': 'আলোর প্রতি শ্রদ্ধা - জ্ঞান ও প্রজ্ঞার প্রতীক'},
        {'step': 'দণ্ডাসন', 'mantra': 'ওঁ খগায় নমঃ', 'meaning': 'আকাশের প্রতি শ্রদ্ধা - যা সীমাহীন ও মুক্ত'},
        {'step': 'অষ্টাঙ্গ নমস্কার', 'mantra': 'ওঁ পূষ্ণে নমঃ', 'meaning': 'পুষ্টির প্রতি শ্রদ্ধা - যা জীবনকে ধারণ করে'},
        {'step': 'ভুজঙ্গাসন', 'mantra': 'ওঁ হিরণ্যগর্ভায় নমঃ', 'meaning': 'ব্রহ্মাণ্ডের প্রতি শ্রদ্ধা - যা সৃষ্টির উৎস'},
        {'step': 'অধোমুখ শ্বানাসন', 'mantra': 'ওঁ মারিচয়ে নমঃ', 'meaning': 'আলোর রশ্মির প্রতি শ্রদ্ধা - যা অন্ধকার দূর করে'},
        {'step': 'অশ্ব সঞ্চালনাসন', 'mantra': 'ওঁ আদিত্যায় নমঃ', 'meaning': 'আদিত্যের প্রতি শ্রদ্ধা - যা ব্রহ্মাণ্ডের জনক'},
        {'step': 'পদহস্তাসন', 'mantra': 'ওঁ সাবিত্রে নমঃ', 'meaning': 'সূর্যের প্রতি শ্রদ্ধা - যা জীবন দান করে'},
        {'step': 'হস্ত উত্তানাসন', 'mantra': 'ওঁ অর্কায় নমঃ', 'meaning': 'শক্তির প্রতি শ্রদ্ধা - যা কর্মচঞ্চল'},
        {'step': 'প্রাণামাসন', 'mantra': 'ওঁ ভাস্করায় নমঃ', 'meaning': 'আলোর প্রতি শ্রদ্ধা - যা জগৎকে আলোকিত করে'},
      ];
    }
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final key = '${_userId}_surya_$today';
    setState(() {
      _isXpClaimed = prefs.getBool(key) ?? false;
    });
  }

  Future<void> _claimXP() async {
    if (_isXpClaimed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ আজকে ইতিমধ্যে এক্সপি পেয়েছেন!'), backgroundColor: Colors.orange),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final key = '${_userId}_surya_$today';
    await prefs.setBool(key, true);

    Navigator.pop(context, {'xp': 5});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎉 +৫ এক্সপি পেয়েছেন!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    // 🔥 প্রতিটি স্লাইডের জন্য আলাদা ছবি (Unsplash থেকে)
    final List<String> imageUrls = [
      'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1607962837359-5e7e89f86776?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1607962837359-5e7e89f86776?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1607962837359-5e7e89f86776?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pillar.title ?? 'সূর্য নমস্কার'),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ShareService.sharePillar(
                title: widget.pillar.title ?? 'সূর্য নমস্কার',
                subtitle: widget.pillar.contentType,
                content: 'আজ সূর্য নমস্কার করেছি! 🧘',
                id: widget.pillar.id ?? 'surya',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 📸 স্লাইড শো
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _steps.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final step = _steps[index];
                final imageUrl = imageUrls[index % imageUrls.length];
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ছবি
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: widget.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: widget.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.image,
                                size: 60,
                                color: widget.color,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      // ধাপের নাম
                      Text(
                        '🧘 ${step['step'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // মন্ত্র
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          step['mantra'] ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: widget.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // অর্থ
                      Text(
                        step['meaning'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // প্রগ্রেস ইন্ডিকেটর
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_steps.length, (i) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == i ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == i
                                  ? widget.color
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // নেভিগেশন বাটন
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _currentIndex > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                if (_currentIndex == _steps.length - 1)
                  ElevatedButton.icon(
                    onPressed: _isXpClaimed ? null : _claimXP,
                    icon: const Icon(Icons.check_circle),
                    label: Text(
                      _isXpClaimed
                          ? '✅ সম্পন্ন হয়েছে'
                          : '🎉 +৫ এক্সপি দাবি করুন',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  )
                else
                  Text(
                    '${_currentIndex + 1}/${_steps.length}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                IconButton(
                  onPressed: _currentIndex < _steps.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
