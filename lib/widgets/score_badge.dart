import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ScoreBadge extends StatelessWidget {
  final int score;
  final double size;

  const ScoreBadge({super.key, required this.score, this.size = 80});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getScoreColor(score);
    final label = AppColors.getScoreLabel(score);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: size * 0.35,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '/100',
            style: TextStyle(
              fontSize: size * 0.15,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          if (size > 60)
            Text(
              label,
              style: TextStyle(
                fontSize: size * 0.12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
