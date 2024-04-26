import 'package:flutter/material.dart';

class OriginPageSettings extends RouteSettings {
  /// is this page at first of routes history
  final bool isInitialPage;

  const OriginPageSettings({
    String? name,
    Object? arguments,
    this.isInitialPage = false,
  }) : super(name: name, arguments: arguments);

  /// Creates a copy of this route settings object with the given fields
  /// replaced with the new values.
  @override
  RouteSettings copyWith({
    String? name,
    Object? arguments,
  }) {
    return OriginPageSettings(
        name: name ?? this.name,
        arguments: arguments ?? this.arguments,
        isInitialPage: isInitialPage);
  }
}
