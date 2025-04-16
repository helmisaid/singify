import 'dart:async';
import 'package:flutter/material.dart';
import 'package:singify/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    super.initState();
    
    // Set up the animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Rotation animation
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Radius animation for pulsing effect
    _radiusAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start the animation and loop it
    _animationController.repeat(reverse: true);
    
    // Navigate to login screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8b2cf5), // Lighter purple at top
              Color(0xFF5e00cc), // Darker purple at bottom
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            
            // Music note icon
            const Icon(
              Icons.music_note,
              size: 80,
              color: Colors.white,
            ),
            
            const SizedBox(height: 30),
            
            // App name
            const Text(
              'Singify',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Tagline
            const Text(
              'Your Lyrics Companion',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
            
            const Spacer(flex: 2),
            
            // Enhanced loading spinner with multiple animations
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer rotating circle
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    
                    // Middle pulsing circle
                    Transform.scale(
                      scale: _radiusAnimation.value,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withOpacity(0.6),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    
                    // Inner rotating circle (opposite direction)
                    RotationTransition(
                      turns: Tween<double>(begin: 0, end: -1).animate(_animationController),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    
                    // Center dot
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                );
              },
            ),
            
            const Spacer(flex: 2),
            
            // Version text
            const Text(
              'Version 1.0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
