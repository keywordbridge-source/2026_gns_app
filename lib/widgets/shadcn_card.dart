import 'package:flutter/material.dart';

// shadcn 스타일 카드 컴포넌트
class ShadcnCard extends StatelessWidget {
  final Widget? header;
  final Widget? title;
  final Widget? description;
  final Widget child;
  final EdgeInsets? padding;

  const ShadcnCard({
    super.key,
    this.header,
    this.title,
    this.description,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null) ...[
              header!,
              const SizedBox(height: 12),
            ],
            if (title != null) ...[
              DefaultTextStyle(
                style: theme.textTheme.titleLarge ?? const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                child: title!,
              ),
              if (description != null) ...[
                const SizedBox(height: 4),
                DefaultTextStyle(
                  style: theme.textTheme.bodyMedium ?? const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  child: description!,
                ),
              ],
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
