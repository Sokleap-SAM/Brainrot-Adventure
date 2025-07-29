import 'package:flame/components.dart';

class StaticBackground extends SpriteComponent {
  final String imagePath;

  StaticBackground({required this.imagePath, super.size})
    : super(position: Vector2.zero(), priority: -10);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(imagePath);

    return super.onLoad();
  }
}
