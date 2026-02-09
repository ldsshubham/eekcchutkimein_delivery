import 'package:flutter/material.dart';

class SlideToStartButton extends StatefulWidget {
  final VoidCallback onSlideComplete;
  final String textTitle;

  const SlideToStartButton({
    super.key,
    required this.onSlideComplete,
    required this.textTitle,
  });

  @override
  State<SlideToStartButton> createState() => _SlideToStartButtonState();
}

class _SlideToStartButtonState extends State<SlideToStartButton> {
  double dragPosition = 0;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width - 64;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              widget.textTitle,
              style: TextStyle(
                color: Colors.green.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  dragPosition += details.delta.dx;
                  if (dragPosition < 0) dragPosition = 0;
                  if (dragPosition > maxWidth - 56) {
                    dragPosition = maxWidth - 56;
                  }
                });
              },
              onHorizontalDragEnd: (_) {
                if (dragPosition >= maxWidth - 70) {
                  widget.onSlideComplete();
                  // Reset position so it's ready if the user returns to this screen
                  setState(() => dragPosition = 0);
                } else {
                  setState(() => dragPosition = 0);
                }
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
