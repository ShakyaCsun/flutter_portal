import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_portal/src/portal_link.dart';

class PortalTheater extends SingleChildRenderObjectWidget {
  const PortalTheater({
    super.key,
    required this.debugName,
    required PortalLink portalLink,
    required Widget super.child,
  }) : _portalLink = portalLink;

  // ignore: diagnostic_describe_all_properties
  final String? debugName;
  final PortalLink _portalLink;

  @override
  RenderPortalTheater createRenderObject(BuildContext context) {
    return RenderPortalTheater(debugName, _portalLink);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderPortalTheater renderObject,
  ) {
    renderObject
      ..debugName = debugName
      ..portalLink = _portalLink;
  }
}

class RenderPortalTheater extends RenderProxyBox {
  RenderPortalTheater(this.debugName, this._portalLink) {
    _portalLink.theater = this;
  }

  String? debugName;

  PortalLink _portalLink;

  PortalLink get portalLink => _portalLink;

  set portalLink(PortalLink value) {
    if (_portalLink != value) {
      assert(
        value.theater == null,
        'portalLink already assigned to another portal',
      );
      _portalLink.theater = null;
      _portalLink = value;
      value.theater = this;
    }
  }

  @override
  void markNeedsLayout() {
    for (final overlay in portalLink.overlays) {
      overlay.overlay.markNeedsLayout();
    }
    super.markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    for (var i = portalLink.overlays.length - 1; i >= 0; i--) {
      final overlay = portalLink.overlays.elementAt(i);
      context.paintChild(overlay.overlay, offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final overlay in portalLink.overlays) {
      // See #42, #59, #64 for details
      if (overlay.overlay.hitTest(result, position: position)) {
        return true;
      }
    }

    return super.hitTestChildren(result, position: position);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('debugName', debugName));
    properties.add(
      DiagnosticsProperty<PortalLink>('portalLink', portalLink),
    );
  }
}
