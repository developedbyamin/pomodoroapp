import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({super.key, required this.iconPath, required this.text, required this.onPressed});

  final String iconPath;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.transparent,
            border: Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Image.asset(iconPath, width: 32, height: 32, color: Colors.white),
          ),
        ),
        Text(
          text,
          style: textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
