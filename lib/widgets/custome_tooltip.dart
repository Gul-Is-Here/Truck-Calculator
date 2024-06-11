// import 'package:flutter/material.dart';

// class CustomTooltip extends StatefulWidget {
//   final String message;
//   final Widget child;

//   const CustomTooltip({required this.message, required this.child, Key? key})
//       : super(key: key);

//   @override
//   _CustomTooltipState createState() => _CustomTooltipState();
// }

// class _CustomTooltipState extends State<CustomTooltip> {
//   OverlayEntry? _overlayEntry;

//   void _showTooltip() {
//     final overlay = Overlay.of(context);
//     final renderBox = context.findRenderObject() as RenderBox;
//     final position = renderBox.localToGlobal(Offset.zero);
//     final size = renderBox.size;

//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: position.dy + size.height + 5,
//         left: position.dx,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: Text(
//               widget.message,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );

//     overlay?.insert(_overlayEntry!);
//   }

//   void _hideTooltip() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         _showTooltip();
//         Future.delayed(const Duration(seconds: 2), () {
//           _hideTooltip();
//         });
//       },
//       child: widget.child,
//     );
//   }
// }