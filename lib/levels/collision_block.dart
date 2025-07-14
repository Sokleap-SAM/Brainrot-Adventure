import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  // with CollisionCallbacks {
  bool isPlatform;

  CollisionBlock({
    required Vector2 position,
    required Vector2 size,
    this.isPlatform = false,
  }) : super(position: position, size: size);

  // @override
  // Future<void> onLoad() async {
  //   // await super.onLoad();
  //   // add(
  //   //   RectangleHitbox(
  //   //     collisionType: isPlatform
  //   //         ? CollisionType.passive
  //   //         : CollisionType.active,
  //   //   )..debugMode = true,
  //   // );
  // debugMode = true;
  // }
}
