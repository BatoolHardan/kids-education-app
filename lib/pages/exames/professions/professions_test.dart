import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pro5/animations/result_page.dart';
import 'package:pro5/animations/sound_play.dart';

class JobsMatchingGame extends StatefulWidget {
  const JobsMatchingGame({super.key});

  @override
  State<JobsMatchingGame> createState() => _JobsMatchingGameState();
}

class _JobsMatchingGameState extends State<JobsMatchingGame>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentIndex = 0;
  int _correctMatches = 0;
  int _wrongAttempts = 0;

  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late List<ToolItem> _allTools;
  late Animation<Offset> _jumpAnim;
  final int _toolIndex = 0;
  final List<JobItem> _jobs = [
    JobItem(
      name: 'الطّباخ',
      image: 'assets/images/المهن/الطباخ.png',
      tool: ToolItem(
        name: 'الخبز',
        image: 'assets/images/المهن/الخبز.png',
        sound: 'sounds/doctor_tool.mp3',
      ),
    ),
    JobItem(
      name: 'المُزارع',
      image: 'assets/images/المهن/المزارع.png',
      tool: ToolItem(
        name: 'المعول',
        image: 'assets/images/المهن/أدوات المزارع.png',
        sound: 'sounds/teacher_tool.mp3',
      ),
    ),
    JobItem(
      name: 'الشرطي',
      image: 'assets/images/المهن/شرطي (2).png',
      tool: ToolItem(
        name: 'إشارة المرور',
        image: 'assets/images/المهن/اشارة المرور.png',
        sound: 'sounds/teacher_tool.mp3',
      ),
    ),
    JobItem(
      name: 'قبطان',
      image: 'assets/images/المهن/قبطان.png',
      tool: ToolItem(
        name: 'عجلة القارب',
        image: 'assets/images/المهن/عجلة القارب.png',
        sound: 'sounds/teacher_tool.mp3',
      ),
    ),
    JobItem(
      name: 'معلم',
      image: 'assets/images/المهن/معلمة.png',
      tool: ToolItem(
        name: 'السبورة',
        image: 'assets/images/المهن/سبورة.png',
        sound: 'sounds/teacher_tool.mp3',
      ),
    ),
    JobItem(
      name: ' النجار',
      image: 'assets/images/المهن/النجار.png',
      tool: ToolItem(
        name: 'المطرقة',
        image: 'assets/images/المهن/مطرقة.png',
        sound: 'sounds/teacher_tool.mp3',
      ),
    ),
    JobItem(
      name: 'الممرض',
      image: 'assets/images/المهن/ممرضة.png',
      tool: ToolItem(
        name: 'الإبرة',
        image: 'assets/images/المهن/ابرة.png',
        sound: 'sounds/teacher_tool.mp3',
      ),
    ),
    JobItem(
      name: 'الميكانيكي',
      image: 'assets/images/المهن/الميكانيكي.png',
      tool: ToolItem(
        name: 'المفك',
        image: 'assets/images/المهن/المفك.png',
        sound: 'sounds/teacher_tool.mp3',
      ),
    ),
    JobItem(
      name: 'رجل الإطفاء',
      image: 'assets/images/المهن/الاطفائي.png',
      tool: ToolItem(
        name: 'مِطْفَأَةُ الحَرِيقِ',
        image: 'assets/images/المهن/مطفأة الحريق.png',
        sound: 'sounds/doctor_tool.mp3',
      ),
    ),
    // باقي المهن بنفس الطريقة مع تصحيح المسارات
  ];
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticInOut),
    );
    _jumpAnim = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, -0.1), // يقفز لفوق
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // اجمع الأدوات وخلطهم مرة ببداية اللعبة
    _allTools = _jobs.map((j) => j.tool).toList()..shuffle();
    _showNextTool();
  }

  void _showNextTool() {
    if (_currentIndex >= _jobs.length) return;

    final correctTool = _jobs[_currentIndex].tool;

    // اختار 2 أداة عشوائية من باقي الأدوات
    final otherTools =
        _jobs
            .map((j) => j.tool)
            .where((t) => t.name != correctTool.name)
            .toList()
          ..shuffle();

    setState(() {
      _allTools = [correctTool, otherTools[0], otherTools[1]]..shuffle();
    });

    // بعد 5 ثواني يبدل الأدوات إذا الطفل ما جرّب
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) _showNextTool();
    });
  }

  void _handleMatch(JobItem job, ToolItem tool) async {
    if (tool.name == job.tool.name) {
      setState(() {
        _correctMatches++;
      });

      SoundManager.playRandomCorrectSound();

      _animController.forward().then((_) {
        _animController.reverse();
      });

      if (_currentIndex < _jobs.length - 1) {
        setState(() {
          _currentIndex++;
          _allTools = _generateToolsForCurrentJob();
        });
        _showNextTool();
      } else {
        // انتقل فورًا بدون انتظار الصوت أو الانيميشن
        Future.delayed(Duration(milliseconds: 300), () {
          Get.to(
            () => ResultScreen(
              animationPath: 'assets/animations/fly baloon slowly.json',
              congratsImagePath: 'assets/rewards/مشاركة رائعة.png',
              onRestart: _restartGame,
            ),
          );
        });
      }
    } else {
      setState(() => _wrongAttempts++);
      SoundManager.playRandomWrongSound();
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 10),
              Text('هذه الأداة للمهنة الخطأ!'),
            ],
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // دالة لإعادة اللعبة
  void _restartGame() {
    setState(() {
      _currentIndex = 0;
      _correctMatches = 0;
      _wrongAttempts = 0;
      _allTools = _generateToolsForCurrentJob();
      _showNextTool();
    });
  }

  // مثال لتوليد أدوات جديدة: صح + 2 عشوائية
  List<ToolItem> _generateToolsForCurrentJob() {
    final correctTool = _jobs[_currentIndex].tool;
    final otherTools =
        _jobs
            .map((j) => j.tool)
            .where((t) => t.name != correctTool.name)
            .toList()
          ..shuffle();
    return [correctTool, otherTools[0], otherTools[1]]..shuffle();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentJob = _jobs[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('مطابقة المهن', style: TextStyle(fontFamily: 'Ghayaty')),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _correctMatches / _jobs.length,
            backgroundColor: Colors.deepPurple[100],
            valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
          ),
          Expanded(
            child: Center(
              child: DragTarget<ToolItem>(
                onAcceptWithDetails:
                    (details) => _handleMatch(currentJob, details.data),
                builder: (ctx, candidate, rejected) {
                  return SlideTransition(
                    position: _jumpAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(currentJob.image, height: 250),
                          SizedBox(height: 12),
                          Text(
                            currentJob.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: "Ghayaty",
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 160,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.deepPurple[50],
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _allTools.length,
              itemBuilder: (ctx, index) => _buildToolCard(_allTools[index]),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Chip(
                  label: Text(
                    'المطابقات: $_correctMatches',
                    style: TextStyle(fontFamily: 'Ghayaty'),
                  ),
                  backgroundColor: Colors.green[100],
                ),
                Chip(
                  label: Text(
                    'الأخطاء: $_wrongAttempts',
                    style: TextStyle(fontFamily: 'Ghayaty'),
                  ),
                  backgroundColor: Colors.red[100],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(ToolItem tool) {
    return Draggable<ToolItem>(
      data: tool, // ⚡ استخدم الأداة الحالية من _allTools
      feedback: _ToolWidget(tool, isDragging: true),
      child: _ToolWidget(tool, isDragging: true),
    );
  }
}

class _ToolWidget extends StatefulWidget {
  final ToolItem tool;
  final bool isDragging;
  const _ToolWidget(this.tool, {this.isDragging = false});

  @override
  State<_ToolWidget> createState() => _ToolWidgetState();
}

class _ToolWidgetState extends State<_ToolWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _offsetAnim = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.05), // تهز لفوق شوي
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnim,
      child: Container(
        width: 100,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.isDragging ? Colors.deepPurple[50] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            if (!widget.isDragging)
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(widget.tool.image, width: 50),
            SizedBox(height: 8),
            Text(
              widget.tool.name,
              style: TextStyle(
                fontFamily: 'Ghayaty',
                color: widget.isDragging ? Colors.deepPurple : Colors.black,
                fontSize: widget.isDragging ? 14 : 12, // فرق بسيط فقط
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobItem {
  final String name;
  final String image;
  final ToolItem tool;

  JobItem({required this.name, required this.image, required this.tool});
}

class ToolItem {
  final String name;
  final String image;
  final String sound;

  ToolItem({required this.name, required this.image, required this.sound});
}
