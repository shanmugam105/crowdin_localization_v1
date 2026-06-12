import 'dart:ui';
// This is the commits
import 'package:crowdin_localization_v1/app_images.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'gauge_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  double _page = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _page = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showFinalImage = (_page > 3 && _page < 4);
    double finalImageScale = (_page - 3).clamp(0, 1);
    int finalImageId = (finalImageScale * 10).round() + 1;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            children: [
              ScreenOne(progress: _page),
              ScreenTwo(progress: _page - 1),
              ScreenThree(progress: _page - 2),
              ScreenFour(progress: _page - 3),
              ScreenFive(progress: _page - 4),
            ],
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: showFinalImage
                ? Transform.scale(
                    key: const ValueKey('finalImage'),
                    scale: finalImageScale,
                    child: Image.asset(
                      'assets/onboarding_v1/animate_$finalImageId.png',
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                : const SizedBox.shrink(), // fades out smoothly when hidden
          ),
        ],
      ),
    );
  }
}

class ScreenOne extends StatelessWidget {
  final double progress;
  const ScreenOne({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    double opacity = (1 - progress.clamp(0, 1));
    return Container(
      color: Colors.white,
      child: Opacity(
        opacity: opacity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.weightLossCard),
            const Text(
              'Congratulations, you did it',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                'You\'ve taken the most pivotal step for yourself and your future health',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0x99000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenTwo extends StatelessWidget {
  final double progress;
  const ScreenTwo({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Clamp progress between 0–1 for safe math
    final double p = progress.clamp(0, 1);

    // Helper to interpolate positions
    Offset lerpOffset(Offset start, Offset end) => Offset(
      lerpDouble(start.dx, end.dx, p)!,
      lerpDouble(start.dy, end.dy, p)!,
    );

    final center = Offset(size.width / 2 - 40, size.height / 2 - 40);

    // Define starting positions at edges
    final positions = [
      const Offset(-80, 200),
      Offset(size.width - 80, 200),
      Offset(-80, size.height - 300),
      Offset(size.width - 67.5, size.height - 300),
      Offset(size.width / 2 - 80, 0),
      Offset(size.width / 2 - 40, size.height - 80),
    ];

    return Opacity(
      opacity: 1 - p,
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // Animated images around edges → move toward center
            for (int i = 0; i < positions.length; i++)
              Positioned(
                left: lerpOffset(positions[i], center).dx,
                top: lerpOffset(positions[i], center).dy,
                child: Transform.rotate(
                  angle: sin(progress + i) * 0.4,
                  child: Image.asset(
                    'assets/onboarding_v1/animate_item_${i + 1}.png',
                    width: 135,
                    height: 175,
                  ),
                ),
              ),
            // Center text
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'You are now officially a Blume member',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenThree extends StatefulWidget {
  final double progress;
  const ScreenThree({super.key, required this.progress});

  @override
  State<ScreenThree> createState() => _ScreenThreeState();
}

class _ScreenThreeState extends State<ScreenThree> {
  var percent = 0.0;

  @override
  void initState() {
    super.initState();
    _animatePercentage();
  }

  void _animatePercentage() {
    if (mounted) {
      setState(() {
        percent += 0.038;
        Future.delayed(Duration(milliseconds: 100), () {
          if (percent <= 0.5) _animatePercentage();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double opacity = (1 - widget.progress.clamp(0, 1));
    return Container(
      color: Colors.white,
      child: Transform.scale(
        scale: 1 - widget.progress.abs(),
        child: Opacity(
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProgressGaugeCard(progress: percent, weight: 85),
                Text(
                  'We are with you at every step of your journey. Anytime. \nEvery time.',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    percent = 0;
    super.dispose();
  }
}

class ScreenFour extends StatelessWidget {
  final double progress;
  const ScreenFour({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    double opacity = (1 - progress.abs().clamp(0, 1));
    return Transform.scale(
      scale: opacity,
      child: Opacity(
        opacity: opacity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Personalized health care in every realm, seamlessly within your reach',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenFive extends StatefulWidget {
  final double progress;

  const ScreenFive({super.key, required this.progress});

  @override
  State<ScreenFive> createState() => _ScreenFiveState();
}

class _ScreenFiveState extends State<ScreenFive>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Controls fade + slide when Explore is tapped
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.5),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onExploreTap() {
    _controller.forward();
    print('Next');
  }

  @override
  Widget build(BuildContext context) {
    // Text drop-in animation based on progress
    final double translateY = (1 - widget.progress) * -100;

    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff1B9033), Color(0xff082A0F)],
            ),
          ),
        ),

        // Center text with progress animation
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Let\'s unlock the app',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Once you have received your treatment, you will be able to start your program. In the meantime, let\'s explore the app.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Explore Button
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: _onExploreTap,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text(
                        'Explore the app',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// class ScreenFive extends StatelessWidget {
//   final double progress;

//   const ScreenFive({super.key, required this.progress});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xff1B9033), // Purple
//                 Color(0xff082A0F), // Blue
//               ],
//             ),
//           ),
//         ),
//         // Animate this widget translate from top to original postion
//         SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               InkWell(
//                 onTap: () {
//                   print('Next');
//                 },
//                 child: Container(
//                   height: 48,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Explore the app',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Animate this widget move to bottom with fade animation on Explore button tap
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             spacing: 12,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Let\'s unlock the app',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 'Once you have received your treatment, you will be able to start your program. In the mean time, let\'s explore the app',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
