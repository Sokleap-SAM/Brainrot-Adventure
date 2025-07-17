import 'package:flame/components.dart'; // Make sure this is imported if your game class extends FlameGame

// Assuming your main game class is MyGame and it extends FlameGame.
// If your main game class is named something else (e.g., BrainrotAdventureGame),
// replace `FlameGame` with that actual name in `HasGameRef<YourGameClass>`.
class StaticBackground extends SpriteComponent {
  // <-- ADDED THIS MIXIN
  final String imagePath;

  StaticBackground({
    required this.imagePath,
    super.size, // Optional constructor parameter to set initial size
  }) : super(
         position: Vector2.zero(),
         priority: -10, // Ensure it's rendered behind everything else
       );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(imagePath);

    return super.onLoad();
  }
}
