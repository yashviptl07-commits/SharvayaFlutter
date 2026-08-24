import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageFullScreenWrapperWidget extends StatelessWidget {
  final Widget child;
  final bool dark;

  const ImageFullScreenWrapperWidget({
    Key key,
    this.child,
    this.dark = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            barrierColor: dark ? Colors.black : Colors.white,
            pageBuilder: (BuildContext context, _, __) {
              return FullScreenPage(
                child: child,
                dark: dark,
              );
            },
          ),
        );
      },
      child: child,
    );
  }
}

class FullScreenPage extends StatefulWidget {
  final Widget child;
  final bool dark;

  const FullScreenPage({
    Key key,
    this.child,
    this.dark = true,
  }) : super(key: key);

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    _setupSystemUI();
  }

  void _setupSystemUI() {
    final brightness = widget.dark ? Brightness.light : Brightness.dark;
    final color = widget.dark ? Colors.black12 : Colors.white70;

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color,
      statusBarColor: color,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      systemNavigationBarDividerColor: color,
      systemNavigationBarIconBrightness: brightness,
    ));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
    _transformationController.dispose();
    super.dispose();
  }

  void _setScale(double scale) {
    setState(() {
      _currentScale = scale.clamp(0.5, 5.0);
      _transformationController.value = Matrix4.identity()
        ..scale(_currentScale);
    });
  }

  void _zoomIn() => _setScale(_currentScale + 0.75);
  void _zoomOut() => _setScale(_currentScale - 0.75);
  void _resetZoom() => _setScale(1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          // Interactive Image Viewer
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _transformationController,
              panEnabled: true,
              minScale: 0.5,
              maxScale: 5.0,
              boundaryMargin: const EdgeInsets.all(80),
              child: Center(
                child: widget.child,
              ),
            ),
          ),
          // Back Button - Top Left
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Material(
                  color: widget.dark ? Colors.black54 : Colors.white70,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.dark ? Colors.black54 : Colors.white70,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: widget.dark ? Colors.white : Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Zoom Controls - Bottom Right
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildZoomButton(Icons.add, _zoomIn),
                      const Divider(
                          height: 1, thickness: 1, color: Colors.white24),
                      _buildZoomButton(Icons.remove, _zoomOut),
                      const Divider(
                          height: 1, thickness: 1, color: Colors.white24),
                      _buildZoomButton(Icons.center_focus_strong, _resetZoom),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
