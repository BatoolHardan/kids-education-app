import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class JobsMatchingGame extends StatefulWidget {
  @override
  _JobsMatchingGameState createState() => _JobsMatchingGameState();
}

class _JobsMatchingGameState extends State<JobsMatchingGame> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _correctMatches = 0;
  int _wrongAttempts = 0;

  // بيانات المهن والأدوات
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
        name: 'السبورة',
        image: ' assets/images/المهن/أدوات المزارع.png',
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
    // أضيفي باقي المهن...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('مطابقة المهن')),
      body: Column(
        children: [
          // عرض المهن (أهداف السحب)
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _jobs.length,
              itemBuilder: (ctx, index) => _buildJobTarget(_jobs[index]),
            ),
          ),

          // عرض الأدوات (عناصر قابلة للسحب)
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _jobs.length,
              itemBuilder:
                  (ctx, index) => _buildDraggableTool(_jobs[index].tool),
            ),
          ),

          // عرض النتائج
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('المطابقات الصحيحة: $_correctMatches'),
                Text('الأخطاء: $_wrongAttempts'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTarget(JobItem job) {
    return DragTarget<ToolItem>(
      onAccept: (tool) {
        if (tool.name == job.tool.name) {
          setState(() {
            _correctMatches++;
            job.isMatched = true;
          });
          _audioPlayer.play(AssetSource(job.tool.sound));
          // إظهار تأثير النجاح
        } else {
          setState(() => _wrongAttempts++);
          // إظهار تأثير الخطأ
        }
      },
      builder: (ctx, candidateData, rejectedData) {
        return AnimatedContainer(
          decoration: BoxDecoration(
            border: Border.all(
              color: job.isMatched ? Colors.green : Colors.grey,
              width: job.isMatched ? 3 : 1,
            ),
          ),
          duration: Duration(milliseconds: 300),
          child: Stack(
            children: [
              Image.asset(job.image),
              if (job.isMatched)
                Positioned.fill(child: Image.asset(job.tool.image)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggableTool(ToolItem tool) {
    return Draggable<ToolItem>(
      data: tool,
      feedback: Material(
        child: Image.asset(tool.image, width: 100, height: 100),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: Image.asset(tool.image, width: 80, height: 80),
      ),
      child: Image.asset(tool.image, width: 80, height: 80),
    );
  }
}

class JobItem {
  final String name;
  final String image;
  final ToolItem tool;
  bool isMatched = false;

  JobItem({required this.name, required this.image, required this.tool});
}

class ToolItem {
  final String name;
  final String image;
  final String sound;

  ToolItem({required this.name, required this.image, required this.sound});
}
