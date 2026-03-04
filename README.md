# 🎮 Brainrot Adventure

A 2D platformer game built with Flutter and Flame engine. Navigate through challenging levels, collect items, avoid enemies, and reach the portal to advance to the next map in current level.

---

## 📘 Team Members

-   **SAM Sokleap** - Developer
-   **Tat Chansereyvong** - Developer

---

## 🎯 Game Features

- **8 Progressive Levels** with increasing difficulty
- **Multiple Enemy Types**: Chubby Buck Tooth, Two Skulled Bird, Acid Lion, Nuclear Eagle
- **Interactive Elements**: Chests with collectibles, portals, flags, and traps
- **Player Mechanics**: Walk, jump, crouch, and platform traversal
- **Audio & Video**: Background music, sound effects, and ending scenes
- **Settings Menu**: Adjust music and sound effects volume
- **Save System**: Progress automatically saved using Hive database

---

## 🛠️ How to Set Up the Project

### Prerequisites
Make sure you have: 
1. Flutter SDK version: 3.8.1 or above
2. A compatible IDE (like VS Code) installed
3. Desktop development with C++ in VS Microsoft.

### Installation Steps

1. **Clone the repository & navigate to project folder:**
   ```bash
   git clone https://github.com/Sokleap-SAM/Brainrot-Adventure.git
   cd Brainrot-Adventure
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter setup:**
   ```bash
   flutter doctor
   ```
   Fix any issues reported by Flutter Doctor.

4. **Clean and rebuild (if needed):**
   ```bash
   flutter clean
   flutter pub get
   ```

### How to Run

1. You need to select what device to run (window or chrome)
2. You have to set your own moveSpeed, gravity, jumpForce, and terminalVelocity in `player.dart` based on your device performance (default is suitable for 60 FPS)
3. You can click on run or debug at `main.dart` file to start.

---

## ✅ How to Play

### Controls

| Key | Action |
|-----|--------|
| **A** | Move Left |
| **D** | Move Right |
| **Space** | Jump |
| **S** | Crouch |

### Objective

1. **Collect Items**: Find and collect all required summer items hidden in chests throughout the level
2. **Reach the Flag**: Touch the flag when you've collected all required items
3. **Complete the Level**: Enter the portal to advance to the next map

### Tips

- **Chests**: Some chests contain valuable items, others may be empty or contain traps
- **Enemies**: Each enemy type has unique behaviors - learn their patterns to avoid damage
- **Health**: Keep an eye on your health bar at the top of the screen
- **Multi-Map Levels**: Some levels have multiple connected maps - find all portals
- **Time Bonus**: Complete levels faster for higher scores

---

## 📝 License

This project is for educational purposes.

---

## 🐛 Known Issues

- Full screen mode is not supported on desktop platforms (Flutter/Flame limitation)
- Audio players may show threading warnings on Windows (does not affect gameplay)

---

**Supported Platforms:**
- Windows Desktop (Recommend)✅
- Web (Chrome) ✅
