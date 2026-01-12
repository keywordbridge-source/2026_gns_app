import 'package:flutter/material.dart';

// shadcn 스타일 버튼 컴포넌트
class ShadcnButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ShadcnButtonVariant variant;
  final ShadcnButtonSize size;

  const ShadcnButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ShadcnButtonVariant.defaultVariant,
    this.size = ShadcnButtonSize.defaultSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color backgroundColor;
    Color foregroundColor;
    
    switch (variant) {
      case ShadcnButtonVariant.defaultVariant:
        backgroundColor = theme.colorScheme.primary;
        foregroundColor = theme.colorScheme.onPrimary;
        break;
      case ShadcnButtonVariant.destructive:
        backgroundColor = Colors.red;
        foregroundColor = Colors.white;
        break;
      case ShadcnButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = theme.colorScheme.primary;
        break;
      case ShadcnButtonVariant.secondary:
        backgroundColor = theme.colorScheme.secondary;
        foregroundColor = theme.colorScheme.onSecondary;
        break;
      case ShadcnButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = theme.colorScheme.primary;
        break;
      case ShadcnButtonVariant.link:
        backgroundColor = Colors.transparent;
        foregroundColor = theme.colorScheme.primary;
        break;
    }

    double height;
    double fontSize;
    EdgeInsets padding;

    switch (size) {
      case ShadcnButtonSize.defaultSize:
        height = 40;
        fontSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        break;
      case ShadcnButtonSize.sm:
        height = 36;
        fontSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
        break;
      case ShadcnButtonSize.lg:
        height = 44;
        fontSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 10);
        break;
      case ShadcnButtonSize.icon:
        height = 40;
        fontSize = 14;
        padding = const EdgeInsets.all(8);
        break;
    }

    Widget button;
    
    if (variant == ShadcnButtonVariant.outline) {
      button = OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          padding: padding,
          minimumSize: Size(0, height),
          side: BorderSide(color: foregroundColor),
        ),
        child: Text(text, style: TextStyle(fontSize: fontSize)),
      );
    } else if (variant == ShadcnButtonVariant.ghost || variant == ShadcnButtonVariant.link) {
      button = TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
          padding: padding,
          minimumSize: Size(0, height),
        ),
        child: Text(text, style: TextStyle(fontSize: fontSize)),
      );
    } else {
      button = ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: padding,
          minimumSize: Size(0, height),
          elevation: variant == ShadcnButtonVariant.defaultVariant ? 2 : 0,
        ),
        child: Text(text, style: TextStyle(fontSize: fontSize)),
      );
    }

    return button;
  }
}

enum ShadcnButtonVariant {
  defaultVariant,
  destructive,
  outline,
  secondary,
  ghost,
  link,
}

enum ShadcnButtonSize {
  defaultSize,
  sm,
  lg,
  icon,
}
