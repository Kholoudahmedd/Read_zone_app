import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:simple_waveform_progressbar/simple_waveform_progressbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AudioBookDetails extends StatefulWidget {
  final String title;
  final int? id;
  final String author;
  final String image;
  final String? audioUrl; // إضافة رابط الصوت
  final List<Map<String, String>>? chapters; // إضافة فصول الكتاب

  const AudioBookDetails({
    super.key,
    required this.id,
    required this.title,
    required this.author,
    required this.image,
    this.audioUrl,
    this.chapters,
  });

  @override
  State<AudioBookDetails> createState() => _AudioBookDetailsState();
}

class _AudioBookDetailsState extends State<AudioBookDetails> {
  bool _isExpanded = false;
  bool _isPlaying = false;
  double _currentProgress = 0.0;
  double _totalDuration = 3600.0; // المدة الإجمالية بالثواني (ساعة واحدة)
  int _currentChapterIndex = 0;

  List<Map<String, String>> get chapters {
    // إذا كانت الفصول معطاة نستخدمها، وإلا نستخدم الفصول الافتراضية
    return widget.chapters ??
        [
          {'title': 'Chapter 01 - ${widget.title}', 'duration': '20 minutes'},
          {'title': 'Chapter 02 - ${widget.title}', 'duration': '25 minutes'},
          {'title': 'Chapter 03 - ${widget.title}', 'duration': '18 minutes'},
        ];
  }

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentlyPlayed = prefs.getStringList('recentlyPlayed') ?? [];

    for (var item in recentlyPlayed) {
      Map<String, dynamic> book = json.decode(item);
      if (book['title'] == widget.title && book['author'] == widget.author) {
        setState(() {
          _currentChapterIndex = book['currentChapter'] ?? 0;
          _currentProgress = book['progress'] ?? 0.0;
        });
        break;
      }
    }
  }

  Future<void> _addToRecentlyPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentlyPlayed = prefs.getStringList('recentlyPlayed') ?? [];

    final bookData = {
      'title': widget.title,
      'author': widget.author,
      'image': widget.image,
      'type': 'audio',
      'lastPlayed': DateTime.now().toString(),
      'currentChapter': _currentChapterIndex,
      'progress': _currentProgress,
    };

    // إزالة الكتاب إذا كان موجوداً مسبقاً
    recentlyPlayed.removeWhere((item) {
      Map<String, dynamic> book = json.decode(item);
      return book['title'] == widget.title && book['author'] == widget.author;
    });

    // إضافة الكتاب في بداية القائمة
    recentlyPlayed.insert(0, json.encode(bookData));

    // تحديد عدد العناصر المحفوظة (10 عناصر كحد أقصى)
    if (recentlyPlayed.length > 10) {
      recentlyPlayed = recentlyPlayed.sublist(0, 10);
    }

    await prefs.setStringList('recentlyPlayed', recentlyPlayed);
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _addToRecentlyPlayed();
        _startProgressTimer();
      } else {
        _saveCurrentProgress();
      }
    });
  }

  void _startProgressTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isPlaying && mounted) {
        setState(() {
          _currentProgress =
              (_currentProgress + (1 / _totalDuration)).clamp(0.0, 1.0);
          if (_currentProgress >= 1.0) {
            _isPlaying = false;
            _saveCurrentProgress();
          } else {
            _startProgressTimer();
          }
        });
      }
    });
  }

  Future<void> _saveCurrentProgress() async {
    await _addToRecentlyPlayed();
  }

  void _seekForward() {
    setState(() {
      _currentProgress =
          (_currentProgress + (10 / _totalDuration)).clamp(0.0, 1.0);
      _saveCurrentProgress();
    });
  }

  void _seekBackward() {
    setState(() {
      _currentProgress =
          (_currentProgress - (10 / _totalDuration)).clamp(0.0, 1.0);
      _saveCurrentProgress();
    });
  }

  String _formatDuration(double progress) {
    int totalSeconds = (progress * _totalDuration).toInt();
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _playChapter(int index) {
    setState(() {
      _currentChapterIndex = index;
      _currentProgress = 0.0;
      _isPlaying = true;
      _addToRecentlyPlayed();
      _startProgressTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getTextColor2(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Visibility(
                visible: !_isExpanded,
                child: Stack(
                  children: [
                    Container(
                      color: getitemColor(context),
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 45),
                      Text(
                        'Chapter - ${_currentChapterIndex + 1}',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: getRedColor(context),
                          shadows: const [
                            Shadow(color: Colors.blueGrey, blurRadius: 3)
                          ],
                        ),
                      ),
                      Text(
                        widget.title,
                        style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(color: Colors.blueGrey, blurRadius: 5)
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        widget.author,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(color: Colors.blueGrey, blurRadius: 5)
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _formatDuration(_currentProgress),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 250,
                            height: 40,
                            child: Center(
                              child: WaveformProgressbar(
                                progress: _currentProgress,
                                color: const Color.fromARGB(122, 0, 0, 0),
                                progressColor: getRedColor(context),
                                onTap: (progress) {
                                  setState(() {
                                    _currentProgress = progress;
                                    _saveCurrentProgress();
                                  });
                                },
                              ),
                            ),
                          ),
                          Text(
                            _formatDuration(1.0),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: 390,
                        height: 70,
                        decoration: BoxDecoration(
                          color: getitemColor(context),
                          borderRadius: BorderRadius.circular(59),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Iconsax.music_library_2,
                                  color: getTextColor2(context), size: 30),
                            ),
                            IconButton(
                              onPressed: _seekBackward,
                              icon: Icon(Iconsax.backward_10_seconds,
                                  color: getTextColor2(context), size: 30),
                            ),
                            IconButton(
                              onPressed: _togglePlayPause,
                              icon: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: getRedColor(context),
                                  borderRadius: BorderRadius.circular(59),
                                ),
                                child: Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _seekForward,
                              icon: Icon(Iconsax.forward_10_seconds,
                                  color: getTextColor2(context), size: 30),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Iconsax.repeate_one,
                                  color: getTextColor2(context), size: 30),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: !_isExpanded,
            child: Positioned(
              right: 20,
              left: 20,
              child: widget.image.startsWith('http')
                  ? Image.network(
                      widget.image,
                      height: MediaQuery.of(context).size.height * 0.45,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      widget.image,
                      height: MediaQuery.of(context).size.height * 0.45,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isExpanded ? 400 : 76,
              decoration: BoxDecoration(
                color: getGreenColor(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            'CHAPTERS',
                            style: GoogleFonts.afacad(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: getGreyColor(context),
                            ),
                          ),
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: getGreyColor(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isExpanded)
                    Expanded(
                      child: ListView.builder(
                        itemCount: chapters.length,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                              onTap: () => _playChapter(index),
                              splashColor: Colors.white.withOpacity(0.2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        index == _currentChapterIndex &&
                                                _isPlaying
                                            ? Icons.pause_circle_outline
                                            : Icons.play_circle_outline,
                                        color: getRedColor(context),
                                        size: 30,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: 300,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              chapters[index]['title']!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight: index ==
                                                        _currentChapterIndex
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              chapters[index]['duration']!,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (index == _currentChapterIndex)
                                    Text(
                                      '${(_currentProgress * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                          color: getRedColor(context),
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.clip),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
