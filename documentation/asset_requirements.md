# Bright Kids: Asset Requirements Manifest 🎨

To achieve the "High Fidelity" look of *Khan Academy Kids*, we need the original source assets listed below.

## 1. 🦁 Mascot (Rive Animations)
The guide character (Bear/Lion) that lives in the corner and guides the child.
*File Format: `.riv` (Rive State Machine)*

| Animation Name | State Machine Trigger | Description |
| :--- | :--- | :--- |
| `guide_idle` | `Idle` | Gentle breathing, looking around, blinking. (Loop) |
| `guide_talk` | `Talk` | Mouth moving, hand gestures (pointing). (Bool/Trigger) |
| `guide_cheer` | `Success` | Jumping up, throwing confetti, clapping. (Trigger) |
| `guide_sad` | `Fail` | Head down, sympathetic look. (Trigger) |
| `guide_pointing_right`| `Hint` | Pointing to the content area. |

## 2. 🌍 World Map (Parallax Layers)
The scrolling "Sunny Valley" background. Needs to be seamless horizontally.
*File Format: `.png` or `.webp` (High Res)*

| Layer Name | Dimensions | Description |
| :--- | :--- | :--- |
| `map_sky_bg.png` | 1920x1080 | Static sky gradient (Blue to Sunset). |
| `map_clouds_mid.png` | 3840x500 | Fluffy white clouds with transparency. (Parallax Speed: Slow) |
| `map_ground_back.png`| 3840x600 | Distant hills, trees, mountains. (Parallax Speed: Medium) |
| `map_ground_front.png`| 3840x400 | The path, grass, flowers. (Parallax Speed: Fast) |
| `map_node_locked.png` | 200x200 | Greyed out circle/stone. |
| `map_node_active.png` | 200x200 | Bright glowing circle/star. |
| `map_node_done.png` | 200x200 | Gold star or checkmark. |

## 3. 📱 UI & HUD Elements
Buttons and frames that feel tactile and "juicy".
*File Format: `.png` (scale: 3x)*

| Asset Name | Description |
| :--- | :--- |
| `btn_back_arrow.png` | Large, rounded back button (Green/Orange). |
| `btn_home.png` | House icon for returning to map. |
| `btn_library_tab.png`| Book icon for tab bar. |
| `btn_map_tab.png` | Map icon for tab bar. |
| `frame_content.png` | A rounded border to frame videos/games. |
| `splash_logo.png` | Main App Logo for splash screen. |

## 4. 📚 Library Content Thumbnails
Mock content for the grid.
*File Format: `.jpg` (Card ratio)*

| Category | Filenames | Context |
| :--- | :--- | :--- |
| **Books** | `thumb_book_1.jpg`, `thumb_book_2.jpg` | "The Red Apple", "Counting to 10" |
| **Videos** | `thumb_video_math.jpg`, `thumb_video_abc.jpg` | "Learn ABCs", "Math is Fun" |
| **Games** | `thumb_game_logic.jpg`, `thumb_game_color.jpg`| "Shape Sorter", "Color Mixer" |

## 5. 🎵 Audio & SFX
Sound design is 50% of the magic.
*File Format: `.mp3` (BGM) / `.wav` (SFX)*

| Filename | Type | Usage |
| :--- | :--- | :--- |
| `bgm_sunny_valley.mp3` | BGM | Gentle, acoustic guitar/piano. Looping. |
| `bgm_activity_calm.mp3` | BGM | Quiet focus music for reading. |
| `sfx_pop.wav` | SFX | Button press, bubble pop. |
| `sfx_success_harp.wav` | SFX | Level complete (Magic harp run). |
| `sfx_wrong_buzz.wav` | SFX | Gentle "try again" sound. |
| `vo_welcome.mp3` | Voice | "Hi! Welcome to Bright Kids!" |
| `vo_good_job.mp3` | Voice | "You did it!" |
