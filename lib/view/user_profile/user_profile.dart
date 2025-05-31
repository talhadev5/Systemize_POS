import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_bloc.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_event.dart';
import 'package:systemize_pos/bloc/auth_%20bloc/login_bloc/login_state.dart';
import 'package:systemize_pos/bloc/profile_bloc/profile_bloc.dart';
import 'package:systemize_pos/bloc/profile_bloc/profile_event.dart';
import 'package:systemize_pos/configs/color/color.dart';
import 'package:systemize_pos/configs/routes/routes_name.dart';
import 'package:systemize_pos/configs/widgets/custom_loader.dart';
import 'package:systemize_pos/configs/widgets/custom_sankbar.dart';
import 'package:systemize_pos/data/models/users/user_model.dart';
import 'package:systemize_pos/utils/app_url.dart';
import 'package:systemize_pos/utils/extensions/string_extension.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(LoadInitialData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.loggedOut) {
          // Navigate after logout success
          Navigator.pushReplacementNamed(context, RoutesName.login);
        } else if (state.loginStatus == LoginStatus.error) {
          // Show error message
          CustomSnackbar.show(
            context: context,
            message: state.message ?? 'Logout failed',
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state.userModel == null) {
            return const Center(child: Text("No user data found"));
          }

          final user = state.userModel!.userDetails;

          return Scaffold(
            body: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProfileBloc>().add(RefreshUserProfile());
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      _buildProfileHeader(user!),
                      const SizedBox(height: 20),
                      // const Divider(height: 0),
                      _buildOptionTile(
                        context,
                        "Order List",
                        Icons.shopping_bag,
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.orderList);
                        },
                      ),
                      const Divider(height: 0),
                      _buildOptionTile(
                        context,
                        "Check Status",
                        Icons.link,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesName.webSocketStatus,
                          );
                        },
                      ),
                      const Divider(height: 0),
                      _buildOptionTile(
                        context,
                        "WebSocket Connect",
                        Icons.wifi,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesName.webSocketSetting,
                          );
                        },
                      ),
                      const Divider(height: 0),
                      _buildLogoutTile(context),
                      // const Divider(height: 0),
                    ],
                  ),
                ),
                if (state.loginStatus == LoginStatus.loading) CustomLoader(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserDetails user) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: "$filesBaseUrl${user.userImage ?? ''}",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => DefultLoader(),
                errorWidget:
                    (context, url, error) => const Icon(Icons.person, size: 40),
              ),
            ),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name.toString().capitalizeEachWord(),
                  style: TextStyle(
                    color: AppColors.customBlackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email ?? 'jone@gmail.com',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.customThemeLightColor),
            ),
            child: Text(
              user.userRole.toString().capitalizeEachWord(),
              style: TextStyle(
                color: AppColors.customBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: AppColors.customThemeColor),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.navigate_next),
      onTap: onTap,
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        'Logout',
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                content: const Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(foregroundColor: Colors.grey),
                    child: const Text('Cancel'),
                  ),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.customThemeColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          context.read<LoginBloc>().add(LogoutEvent());
                          if (state.loginStatus == LoginStatus.loggedOut) {
                            Navigator.pushReplacementNamed(
                              context,
                              RoutesName.login,
                            );
                          }
                        },
                        child: const Text('Log Out'),
                      );
                    },
                  ),
                ],
              ),
        );
      },
    );
  }
}
