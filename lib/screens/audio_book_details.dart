import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:simple_waveform_progressbar/simple_waveform_progressbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class AudioBookDetails extends StatefulWidget {
  final String title;
  final String identifier;
  final String creator;
  final String coverUrl;
  final String? streamUrl;

  const AudioBookDetails({
    super.key,
    required this.identifier,
    required this.title,
    required this.creator,
    required this.coverUrl,
    this.streamUrl,
  });

  @override
  State<AudioBookDetails> createState() => _AudioBookDetailsState();
}

class _AudioBookDetailsState extends State<AudioBookDetails> {
  bool _isExpanded = false;
  bool _isPlaying = false;
  double _currentProgress = 0.0;
  double _totalDuration = 1.0;
  bool _isAudioLoading = true;

  late AudioPlayer _audioPlayer;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();
    _fetchBookDetails();
    _simulateAudioLoading();
  }

  Future<void> _simulateAudioLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isAudioLoading = false;
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() {
        _totalDuration = duration.inSeconds.toDouble();
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() {
        _currentProgress =
            _totalDuration == 0 ? 0.0 : position.inSeconds / _totalDuration;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _currentProgress = 1.0;
      });
      _saveCurrentProgress();
    });
  }

  Future<void> _fetchBookDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://myfirstapi.runasp.net/api/AudioBooks/${widget.identifier}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final streamUrl = data['streamUrl'] ?? widget.streamUrl;

        if (streamUrl != null && streamUrl.isNotEmpty) {
          try {
            await _audioPlayer.setSource(UrlSource(streamUrl));
            await _audioPlayer.play(UrlSource(streamUrl));
            await Future.delayed(const Duration(milliseconds: 100));
            await _audioPlayer.pause();
            await _audioPlayer.seek(Duration.zero);
            if (!mounted) return;
            setState(() {
              _isInitialized = true;
            });
          } catch (e) {
            print('Error playing audio: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Failed to play audio. Please try again later.')),
              );
            }
          }
        }

        List<Map<String, String>> generatedChapters = [
          {'title': 'Chapter 01 - ${widget.title}', 'duration': '20 minutes'},
          {'title': 'Chapter 02 - ${widget.title}', 'duration': '25 minutes'},
          {'title': 'Chapter 03 - ${widget.title}', 'duration': '18 minutes'},
        ];

        if (!mounted) return;
        setState(() {
        });
      } else {
        throw Exception('Failed to load book details');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
      });
    }
  }

  Future<String?> _getToken() async {
    final box = GetStorage();
    final token = box.read('token');
    print('🟢 Token from GetStorage: $token');
    return token;
  }

  Future<void> _addToRecentlyPlayed() async {
    try {
      final token = await _getToken();
      print('🟢 Token: $token'); // تحقق من وجود التوكن

      final response = await http.post(
        Uri.parse(
            'https://myfirstapi.runasp.net/api/userlibrary/audiobooks/recent/add'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'identifier': widget.identifier,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Recently played saved successfully');
      } else {
        print(
            '❌ فشل في تسجيل التشغيل: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending recently played: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    if (!_isInitialized) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loading audio, please wait...')),
        );
      }
      return;
    }

    if (_isPlaying) {
      await _audioPlayer.pause();
      await _saveCurrentProgress();
    } else {
      await _audioPlayer
          .seek(Duration(seconds: (_currentProgress * _totalDuration).toInt()));
      await _audioPlayer.resume();
      await _addToRecentlyPlayed();
    }
  }

  Future<void> _seekForward() async {
    if (!_isInitialized) return;

    final newPosition =
        (_currentProgress * _totalDuration + 10).clamp(0.0, _totalDuration);
    await _audioPlayer.seek(Duration(seconds: newPosition.toInt()));
    await _saveCurrentProgress();
  }

  Future<void> _seekBackward() async {
    if (!_isInitialized) return;

    final newPosition =
        (_currentProgress * _totalDuration - 10).clamp(0.0, _totalDuration);
    await _audioPlayer.seek(Duration(seconds: newPosition.toInt()));
    await _saveCurrentProgress();
  }

  Future<void> _saveCurrentProgress() async {
    await _addToRecentlyPlayed();
  }

  String _formatDuration(double progress) {
    int totalSeconds = (progress * _totalDuration).toInt();
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isAudioLoading || !_isInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: getRedColor(context),
            strokeWidth: 5,
          ),
        ),
      );
    }

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
        body: Stack(children: [
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
                      const SizedBox(height: 55),
                      // Text(
                      //   'Chapter - ${_currentChapterIndex + 1}',
                      //   style: GoogleFonts.inter(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //     color: getRedColor(context),
                      //     shadows: const [
                      //       Shadow(color: Colors.blueGrey, blurRadius: 3)
                      //     ],
                      //   ),
                      // ),
                      Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
                        widget.creator,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
                                onTap: (progress) async {
                                  if (!_isInitialized) return;

                                  setState(() {
                                    _currentProgress = progress;
                                  });
                                  await _audioPlayer.seek(
                                    Duration(
                                        seconds: (progress * _totalDuration)
                                            .toInt()),
                                  );
                                  await _saveCurrentProgress();
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
                            // IconButton(
                            //   onPressed: () {},
                            //   icon: Icon(Iconsax.music_library_2,
                            //       color: getTextColor2(context), size: 30),
                            // ),
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
                            // IconButton(
                            //   onPressed: () {},
                            //   icon: Icon(Iconsax.repeate_one,
                            //       color: getTextColor2(context), size: 30),
                            // ),
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
              child: widget.coverUrl.startsWith('http')
                  ? Image.network(
                      widget.coverUrl,
                      height: MediaQuery.of(context).size.height * 0.45,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      widget.coverUrl,
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
              height: _isExpanded ? 300 : 76,
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
                            'DESCRIPTION',
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
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          '''"${widget.title}" is an engaging audiobook offering immersive storytelling and rich narration. Dive into this audio journey anytime and enjoy seamless playback as you discover its chapters and themes. Perfect for listeners on the go or those seeking a relaxing experience.''',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: getTextColor2(context),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ]));
  }
}
