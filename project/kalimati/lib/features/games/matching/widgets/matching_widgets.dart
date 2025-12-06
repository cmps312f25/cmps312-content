import 'package:flutter/material.dart';

class FeedbackBanner extends StatelessWidget {
  const FeedbackBanner({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final Color color = text.startsWith('✅')
        ? const Color(0xFF2E7D32)
        : text.startsWith('❌')
        ? Colors.redAccent
        : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(
            text.startsWith('✅')
                ? Icons.check_circle
                : text.startsWith('❌')
                ? Icons.error_outline
                : Icons.info_outline,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class ScoreBar extends StatelessWidget {
  const ScoreBar({
    super.key,
    required this.score,
    required this.attempts,
    required this.seconds,
  });

  final int score;
  final int attempts;
  final int seconds;

  String _formatSeconds(int secs) {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _labelValue('SCORE', '$score'),
          _labelValue('ATTEMPTS', '$attempts'),
          _labelValue('TIME', _formatSeconds(seconds)),
        ],
      ),
    );
  }

  Widget _labelValue(String label, String value) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black45,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
    ],
  );
}

class ListSection<T> extends StatelessWidget {
  const ListSection({
    super.key,
    required this.title,
    required this.items,
    required this.isSelected,
    required this.isMatched,
    required this.labelOf,
    required this.onTap,
    required this.onLongPress,
  });

  final String title;
  final List<T> items;
  final bool Function(int index) isSelected;
  final bool Function(T item) isMatched;
  final String Function(T item) labelOf;
  final void Function(int index) onTap;
  final void Function(int index) onLongPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final item = items[index];
              final selected = isSelected(index);
              final matched = isMatched(item);

              Color border = Colors.black12;
              Color? fill;
              if (matched) {
                border = Colors.green;
                fill = Colors.green.shade50;
              } else if (selected) {
                border = Colors.blue;
                fill = Colors.blue.shade50;
              }

              return GestureDetector(
                onTap: () => onTap(index),
                onLongPress: () => onLongPress(index),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: fill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border, width: 1.5),
                  ),
                  child: Text(
                    labelOf(item),
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
