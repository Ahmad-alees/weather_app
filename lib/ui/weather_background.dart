import 'package:flutter/material.dart';
import 'package:weather_app/domain/weather_condition.dart';

class WeatherBackground extends StatelessWidget {
  const WeatherBackground({
    required this.condition,
    required this.child,
    super.key,
  });
  final WeatherCondition condition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = switch (condition) {
      WeatherCondition.sunny => const [Color(0xFF2B8CE6), Color(0xFF4BA3EE)],
      WeatherCondition.partlyCloudy => const [
        Color(0xFF3F7FC0),
        Color(0xFF6A9FD0),
      ],
      WeatherCondition.cloudy ||
      WeatherCondition.other => const [Color(0xFF566F88), Color(0xFF6F8AA4)],
      WeatherCondition.rainy => const [Color(0xFF3A5063), Color(0xFF4F687C)],
      WeatherCondition.snow => const [Color(0xFF5A7A98), Color(0xFF7D9AB5)],
      WeatherCondition.fog => const [Color(0xFF667684), Color(0xFF7F909D)],
      WeatherCondition.storm => const [Color(0xFF2C3B4F), Color(0xFF44566B)],
      _ => const [Color(0xFF0B1736), Color(0xFF25396B)],
    };
    final night = condition.name.startsWith('night');
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          if (condition == WeatherCondition.sunny ||
              condition == WeatherCondition.partlyCloudy)
            const Positioned(
              top: 42,
              left: 26,
              child: _Orb(color: Color(0xFFFFD36B), size: 74),
            ),
          if (night)
            const Positioned(
              top: 52,
              left: 30,
              child: _Orb(color: Color(0xFFFFF0B6), size: 30),
            ),
          if (condition == WeatherCondition.cloudy ||
              condition == WeatherCondition.partlyCloudy ||
              condition == WeatherCondition.fog ||
              night)
            const _CloudBands(),
          if (condition == WeatherCondition.rainy ||
              condition == WeatherCondition.nightRain ||
              condition == WeatherCondition.storm ||
              condition == WeatherCondition.nightStorm)
            const _Rain(),
          if (condition == WeatherCondition.snow ||
              condition == WeatherCondition.nightSnow)
            const _Snow(),
          child,
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.color, required this.size});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(color: color.withValues(alpha: .35), blurRadius: 32),
      ],
    ),
  );
}

class _CloudBands extends StatelessWidget {
  const _CloudBands();
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: List.generate(4, (index) {
          return Positioned(
            top: 130.0 + index * 116,
            left: index.isEven ? -45 : 120,
            child: Container(
              width: 270,
              height: 66,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .06),
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Rain extends StatelessWidget {
  const _Rain();
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: List.generate(
          28,
          (i) => Positioned(
            left: (i * 41 % 420).toDouble(),
            top: (i * 89 % 760).toDouble(),
            child: Transform.rotate(
              angle: .35,
              child: Container(
                width: 1,
                height: 23,
                color: Colors.white.withValues(alpha: .35),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Snow extends StatelessWidget {
  const _Snow();
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: List.generate(24, (i) {
          return Positioned(
            left: (i * 53 % 390).toDouble(),
            top: (i * 97 % 760).toDouble(),
            child: Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}
