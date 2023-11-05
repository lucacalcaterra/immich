import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/shared/models/store.dart';
import 'package:immich_mobile/shared/models/user.dart';
import 'package:immich_mobile/shared/ui/transparent_image.dart';

// ignore: must_be_immutable
class UserCircleAvatar extends ConsumerWidget {
  final User user;
  double radius;
  double size;

  UserCircleAvatar({
    super.key,
    this.radius = 22,
    this.size = 44,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final profileImageUrl =
        '${Store.get(StoreKey.serverEndpoint)}/user/profile-image/${user.id}?d=${Random().nextInt(1024)}';
    return CircleAvatar(
      backgroundColor: user.avatarColor.toColor(isDarkTheme),
      radius: radius,
      child: user.profileImagePath.isEmpty
          ? Text(
              user.firstName[0].toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    isDarkTheme && user.avatarColor == AvatarColorEnum.primary
                        ? Colors.black
                        : Colors.white,
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                cacheKey: user.profileImagePath,
                width: size,
                height: size,
                placeholder: (_, __) => Image.memory(kTransparentImage),
                imageUrl: profileImageUrl,
                httpHeaders: {
                  "Authorization": "Bearer ${Store.get(StoreKey.accessToken)}",
                },
                fadeInDuration: const Duration(milliseconds: 300),
                errorWidget: (context, error, stackTrace) =>
                    Image.memory(kTransparentImage),
              ),
            ),
    );
  }
}
