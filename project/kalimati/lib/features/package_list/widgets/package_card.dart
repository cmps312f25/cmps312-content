import 'package:flutter/material.dart';
import 'package:kalimati/core/entities/learning_package.dart';
import 'package:kalimati/features/package_list/widgets/info_badge.dart';
import 'package:kalimati/core/entities/user.dart';

class PackageCard extends StatelessWidget {
  final LearningPackage package;
  final Color primaryGreen;
  final Color textBlack;
  final User? user;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onFlashcards;
  final VoidCallback? onUnscramble;
  final VoidCallback? onMatching;

  const PackageCard({
    super.key,
    required this.package,
    required this.primaryGreen,
    required this.textBlack,
    this.user,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onFlashcards,
    this.onUnscramble,
    this.onMatching,
  });

  bool get isAuthor {
    if (user == null) return false;
    final authorValue = (package.author).trim().toLowerCase();
    final emailValue = (user!.email).trim().toLowerCase();
    final idValue = (user!.id).trim().toLowerCase();
    return authorValue == emailValue || authorValue == idValue;
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.green.shade700;
      case 'intermediate':
        return Colors.orange.shade700;
      case 'advanced':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[localDate.month - 1]} ${localDate.day}, ${localDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final levelColor = _getLevelColor(package.level);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(16),
                  bottom: Radius.zero,
                ),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: isMobile
                      ? _mobileContent(levelColor)
                      : _stackedContent(levelColor),
                ),
              ),
              _buildGameIcons(),
            ],
          ),
          if (isAuthor) _buildAuthorActions(),
        ],
      ),
    );
  }

  Widget _mobileContent(Color levelColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(60),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Text(
                  package.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textBlack,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                package.description,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    InfoBadge(
                      icon: Icons.star_rounded,
                      label: package.level,
                      backgroundColor: levelColor.withValues(alpha: 0.15),
                      textColor: levelColor,
                      iconColor: levelColor,
                    ),
                    const SizedBox(width: 6),
                    InfoBadge(
                      icon: Icons.library_books,
                      label: "${package.words.length} Words",
                      backgroundColor: primaryGreen.withValues(alpha: 0.1),
                      textColor: primaryGreen,
                      iconColor: primaryGreen,
                    ),
                  ],
                ),
              ),
              if (!isAuthor && package.author.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'By ${package.author}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.tag, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      'v${package.version}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.update, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(package.lastUpdateDate),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _stackedContent(Color levelColor) {
    final screenWidth =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .physicalSize
            .width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    double maxWidth = screenWidth >= 1200 ? 380 : 320;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: _buildImage(80)),
            const SizedBox(height: 8),
            Text(
              package.title,

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textBlack,

                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              package.description,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoBadge(
                  icon: Icons.star_rounded,
                  label: package.level,
                  backgroundColor: levelColor.withValues(alpha: 0.15),
                  textColor: levelColor,
                  iconColor: levelColor,
                ),
                const SizedBox(width: 8),
                InfoBadge(
                  icon: Icons.library_books,
                  label: "${package.words.length} Words",
                  backgroundColor: primaryGreen.withValues(alpha: 0.1),
                  textColor: primaryGreen,
                  iconColor: primaryGreen,
                ),
              ],
            ),
            if (!isAuthor && package.author.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'By ${package.author}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.tag, size: 12, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    'v${package.version}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.update, size: 12, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(package.lastUpdateDate),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          package.iconUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Icon(
            Icons.image_not_supported_rounded,
            size: size * 0.5,
            color: primaryGreen.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildGameIcons() {
    return Container(
      decoration: BoxDecoration(
        color: primaryGreen.withValues(alpha: 0.05),
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _GameIconButton(
            icon: Icons.style_outlined,
            label: 'Flash Cards',
            color: primaryGreen,
            onPressed: onFlashcards,
          ),
          _GameIconButton(
            icon: Icons.swap_vert_outlined,
            label: 'Unscramble',
            color: primaryGreen,
            onPressed: onUnscramble,
          ),
          _GameIconButton(
            icon: Icons.link_outlined,
            label: 'Matching',
            color: primaryGreen,
            onPressed: onMatching,
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorActions() {
    return Positioned(
      top: 4,
      right: 4,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            tooltip: 'Edit',
            color: Colors.blueGrey,
            onPressed: onEdit,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            tooltip: 'Delete',
            color: Colors.redAccent,
            onPressed: onDelete,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const _GameIconButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
