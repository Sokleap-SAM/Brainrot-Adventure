import 'package:flutter/material.dart';
import 'package:brainrot_adventure/brainrot_adventure.dart';

class LevelGuideOverlay extends StatefulWidget {
  final BrainrotAdventure game;
  final List<Map<String, String>> guideData;

  const LevelGuideOverlay({
    super.key,
    required this.game,
    required this.guideData,
  });

  @override
  State<LevelGuideOverlay> createState() => _LevelGuideOverlayState();
}

class _LevelGuideOverlayState extends State<LevelGuideOverlay> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
        ),
        width: 600,
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: widget.guideData.map((data) {
                  return GuidePage(
                    title: data['title']!,
                    content: data['content']!,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalPages, (index) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white60,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (_currentPage < widget.guideData.length - 1)
          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            child: const Text('Next', style: TextStyle(fontSize: 24)),
          ),
        ElevatedButton(
          onPressed: () {
            widget.game.overlays.remove('LevelGuideOverlay');
            widget.game.resumeEngine();
            widget.game.startTimer();
          },
          child: const Text('Skip', style: TextStyle(fontSize: 24)),
        ),
      ],
    );
  }
}

class GuidePage extends StatelessWidget {
  final String title;
  final String content;

  const GuidePage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }
}
