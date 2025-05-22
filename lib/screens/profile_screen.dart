import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singify/widgets/nav_item.dart';
import 'package:singify/services/auth/auth_service.dart';
import 'package:singify/services/auth/auth_impl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentIndex = 3;

  final AuthService _authService = AuthServiceImpl();
  Future<Map<String, dynamic>?>? _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _authService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Standardized App Bar with consistent height and padding
            Container(
              color: Colors.white,
              height: 60, // Fixed height for consistency
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8b2cf5),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.grey),
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Divider for visual separation
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[200],
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Profile Picture (Dynamic from PocketBase)
                    FutureBuilder<Map<String, dynamic>?>(
                      future: _userDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError || snapshot.data == null) {
                          // Fallback to a placeholder image if data is unavailable
                          return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              image: const DecorationImage(
                                image: NetworkImage(
                                    'https://via.placeholder.com/120'), // Placeholder
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          final userData = snapshot.data!;
                          // Assuming the avatar is stored as a file reference in PocketBase
                          final avatarUrl = userData['avatar'] != null
                              ? 'http://127.0.0.1:8090/api/files/users/${userData['id']}/${userData['avatar']}'
                              : 'https://via.placeholder.com/120'; // Fallback if no avatar

                          return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(avatarUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Name
                    FutureBuilder<Map<String, dynamic>?>(
                      future: _userDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError || snapshot.data == null) {
                          return const Text(
                            'Error loading profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        } else {
                          final userData = snapshot.data!;
                          final name = userData['name'] ??
                              'Unknown User'; // Ganti 'name' dengan field yang sesuai dari PocketBase
                          return Text(
                            name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 4),

                    // Username
                    const Text(
                      '@sarahwilson',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatColumn('247', 'Following'),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey[300],
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        _buildStatColumn('12.4K', 'Followers'),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey[300],
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        _buildStatColumn('892', 'Favorites'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Divider(height: 1, thickness: 1, color: Colors.grey[200]),

                    const SizedBox(height: 16),

                    // Stats Cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // This Month Card
                          Expanded(
                            child: _buildStatsCard(
                              icon: Icons.music_note,
                              iconColor: const Color(0xFF8b2cf5),
                              title: 'This Month',
                              value: '127',
                              subtitle: 'Songs Played',
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Total Time Card
                          Expanded(
                            child: _buildStatsCard(
                              icon: Icons.access_time,
                              iconColor: const Color(0xFF8b2cf5),
                              title: 'Total Time',
                              value: '48h',
                              subtitle: 'Listening Time',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Recent Activity Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Activity',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Activity Items
                          _buildActivityItem(
                            icon: Icons.favorite,
                            iconColor: Colors.red,
                            iconBgColor: Colors.red.withOpacity(0.1),
                            title: 'Liked "Anti-Hero" by Taylor Swift',
                            time: '2 hours ago',
                          ),
                          const SizedBox(height: 16),

                          _buildActivityItem(
                            icon: Icons.person_add,
                            iconColor: const Color(0xFF8b2cf5),
                            iconBgColor:
                                const Color(0xFF8b2cf5).withOpacity(0.1),
                            title: 'Started following The Weeknd',
                            time: '5 hours ago',
                          ),
                          const SizedBox(height: 16),

                          _buildActivityItem(
                            icon: Icons.share,
                            iconColor: Colors.blue,
                            iconBgColor: Colors.blue.withOpacity(0.1),
                            title: 'Shared "Shape of You" by Ed Sheeran',
                            time: '1 day ago',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NavItem(
                      icon: Icons.home,
                      label: 'Home',
                      isSelected: _currentIndex == 0,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                    ),
                    NavItem(
                      icon: Icons.explore,
                      label: 'Explore',
                      isSelected: _currentIndex == 1,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pushNamed(context, '/search');
                      },
                    ),
                    NavItem(
                      icon: Icons.favorite,
                      label: 'Favorite',
                      isSelected: _currentIndex == 2,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pushNamed(
                          context,
                          '/favorites',
                          arguments: {'showFullScreen': true},
                        );
                      },
                    ),
                    NavItem(
                      icon: Icons.person,
                      label: 'Profile',
                      isSelected: _currentIndex == 3,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        // Already on profile screen
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
