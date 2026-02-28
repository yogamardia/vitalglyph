import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalglyph/core/router/app_router.dart';
import 'package:vitalglyph/data/services/widget_service.dart';
import 'package:vitalglyph/domain/entities/profile.dart';
import 'package:vitalglyph/injection.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_bloc.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_event.dart';
import 'package:vitalglyph/presentation/blocs/profile/profile_state.dart';
import 'package:vitalglyph/presentation/widgets/profile_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfilesWatchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical ID'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan Medical ID',
            onPressed: () => context.push(AppRouter.scanner),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push(AppRouter.settings),
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            final widget = sl<WidgetService>();
            if (state.profiles.isNotEmpty) {
              widget.updateWithProfile(state.profiles.first);
            } else {
              widget.clearWidget();
            }
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<ProfileBloc>()
                          .add(const ProfilesWatchStarted()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final profiles =
              state is ProfileLoaded ? state.profiles : <Profile>[];

          if (profiles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.medical_information_outlined,
                      size: 72,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No profiles yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add a profile to store medical information\nfor yourself or a family member.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              return ProfileCard(
                profile: profiles[index],
                onDelete: () => context
                    .read<ProfileBloc>()
                    .add(ProfileDeleteRequested(profiles[index].id)),
                onShowQr: () => context.push(
                  AppRouter.qrDisplay,
                  extra: profiles[index],
                ),
                onEdit: () => context.push(
                  AppRouter.profileEdit,
                  extra: profiles[index],
                ),
                onEmergencyCard: () => context.push(
                  AppRouter.emergencyCard,
                  extra: profiles[index],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRouter.profileNew),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Add Profile'),
      ),
    );
  }
}
