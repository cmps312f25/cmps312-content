import 'package:flutter/material.dart';

const double kChipHorizontalPadding = 18.0;
const double kChipVerticalPadding = 14.0;
const double kChipCornerRadius = 12.0;
const TextStyle kChipLabelStyle = TextStyle(fontWeight: FontWeight.w600);

class AnswerWordChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onRemove;
  const AnswerWordChip({
    super.key,
    required this.label,
    required this.color,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(kChipCornerRadius + 4),
      child: InkWell(
        onTap: onRemove,
        borderRadius: BorderRadius.circular(kChipCornerRadius + 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kChipHorizontalPadding,
            vertical: kChipVerticalPadding,
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class PoolWordChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const PoolWordChip({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      borderRadius: BorderRadius.circular(kChipCornerRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kChipCornerRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: kChipHorizontalPadding,
            vertical: kChipVerticalPadding,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(kChipCornerRadius),
          ),
          child: Text(label, style: kChipLabelStyle),
        ),
      ),
    );
  }
}

class BlankChip extends StatelessWidget {
  final double width;
  final Color borderColor;
  const BlankChip({super.key, required this.width, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: BoxConstraints(minHeight: kChipVerticalPadding * 2 + 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(kChipCornerRadius),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: kChipHorizontalPadding,
        vertical: kChipVerticalPadding - 6,
      ),
    );
  }
}

class AttemptBanner extends StatelessWidget {
  final bool success;
  final Color primary;
  const AttemptBanner({
    super.key,
    required this.success,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final color = success ? primary : Colors.redAccent;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(
            success ? Icons.check_circle : Icons.error_outline,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            success ? 'Great! That’s correct.' : 'Not quite. Try again.',
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool disabled;
  final String? caption;

  static const double _minActionWidth = 90.0;

  const MiniAction({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.disabled = false,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final color = disabled ? Colors.black26 : Colors.black54;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: _minActionWidth),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: disabled ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    if (caption != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        caption!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: color),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UnscrambleActionsBar extends StatelessWidget {
  const UnscrambleActionsBar({
    super.key,
    required this.wordsRemainingLabel,
    required this.onRestart,
    required this.onHint,
    required this.onShuffle,
    required this.hintCaption,
    required this.hintDisabled,
  });

  final String wordsRemainingLabel;
  final VoidCallback onRestart;
  final VoidCallback onHint;
  final VoidCallback onShuffle;
  final String hintCaption;
  final bool hintDisabled;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.grey.shade700,
      fontWeight: FontWeight.w600,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 360;
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wordsRemainingLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 10,
                runSpacing: 8,
                children: [
                  MiniAction(
                    icon: Icons.restart_alt,
                    label: 'Restart',
                    onTap: onRestart,
                  ),
                  MiniAction(
                    icon: Icons.lightbulb_outline,
                    label: 'Hint',
                    caption: hintCaption,
                    disabled: hintDisabled,
                    onTap: hintDisabled ? null : onHint,
                  ),
                  MiniAction(
                    icon: Icons.shuffle,
                    label: 'Shuffle',
                    onTap: onShuffle,
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: Text(
                wordsRemainingLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 10,
                runSpacing: 8,
                children: [
                  MiniAction(
                    icon: Icons.restart_alt,
                    label: 'Restart',
                    onTap: onRestart,
                  ),
                  MiniAction(
                    icon: Icons.lightbulb_outline,
                    label: 'Hint',
                    caption: hintCaption,
                    disabled: hintDisabled,
                    onTap: hintDisabled ? null : onHint,
                  ),
                  MiniAction(
                    icon: Icons.shuffle,
                    label: 'Shuffle',
                    onTap: onShuffle,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

double measureChipWidth(BuildContext context, String word) {
  final tp = TextPainter(
    text: TextSpan(text: word, style: kChipLabelStyle),
    textDirection: TextDirection.ltr,
  )..layout();
  return tp.width + (kChipHorizontalPadding * 2) + 2;
}
