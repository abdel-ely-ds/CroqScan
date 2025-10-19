/// Accessibility helpers for WCAG AA compliance
///
/// This file provides helpers to make widgets accessible with minimal code changes.
/// All interactive elements should use these wrappers.
library;

import 'package:flutter/material.dart';

/// Wraps a button widget with accessibility labels
///
/// Usage:
/// ```dart
/// AccessibleButton(
///   label: 'Scanner',
///   hint: 'Ouvre le scanner de code-barres',
///   child: Icon(Icons.scanner),
///   onTap: () => ...,
/// )
/// ```
class AccessibleButton extends StatelessWidget {
  final String label;
  final String? hint;
  final Widget child;
  final VoidCallback? onTap;
  final bool selected;
  final bool excludeSemantics;

  const AccessibleButton({
    super.key,
    required this.label,
    this.hint,
    required this.child,
    this.onTap,
    this.selected = false,
    this.excludeSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      hint: hint,
      selected: selected,
      excludeSemantics: excludeSemantics,
      child: GestureDetector(onTap: onTap, child: child),
    );
  }
}

/// Wraps an image with accessibility label
///
/// Usage:
/// ```dart
/// AccessibleImage(
///   label: 'Photo de produit pour [nom]',
///   child: Image.network(url),
/// )
/// ```
class AccessibleImage extends StatelessWidget {
  final String label;
  final Widget child;

  const AccessibleImage({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: label,
      child: ExcludeSemantics(child: child),
    );
  }
}

/// Wraps a text field with accessibility label and hint
class AccessibleTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final Widget child;

  const AccessibleTextField({
    super.key,
    required this.label,
    this.hint,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(textField: true, label: label, hint: hint, child: child);
  }
}

/// Validates that a widget has minimum touch target size (48x48 dp)
///
/// Usage:
/// ```dart
/// MinimumTouchTarget(
///   child: Icon(Icons.favorite, size: 20),
/// )
/// ```
class MinimumTouchTarget extends StatelessWidget {
  final Widget child;
  final double minSize;

  const MinimumTouchTarget({
    super.key,
    required this.child,
    this.minSize = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
      child: child,
    );
  }
}

/// Makes a container semantically focusable with label
class AccessibleContainer extends StatelessWidget {
  final String label;
  final String? hint;
  final Widget child;
  final VoidCallback? onTap;

  const AccessibleContainer({
    super.key,
    required this.label,
    this.hint,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      focusable: true,
      child: GestureDetector(onTap: onTap, child: child),
    );
  }
}
