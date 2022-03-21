import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/providers/navigation_provider.dart';
import 'package:insta_clone/services/profile_service.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/utils/view_profile.dart';
import 'package:insta_clone/widgets/cached_circle_avatar.dart';
import 'package:insta_clone/widgets/follow_or_edit_button.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<NavigationProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        _provider.updateIndex(0);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Search for users"),
        ),
        body: const _SearchResults(),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: spacing / 2,
          vertical: spacing,
        ),
        child: StreamBuilder<List<UserModel>>(
          stream: ProfileService().allUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No users found"),
              );
            }

            return Column(
              children: snapshot.data!.map((user) {
                return ListTile(
                  onTap: () => viewProfile(user.id),
                  leading: CachedCircleAvatar(
                    imageUrl: user.avatar,
                    scale: 2.5,
                  ),
                  title: Text(
                    user.username,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: FollowOrEditButton(user: user),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
