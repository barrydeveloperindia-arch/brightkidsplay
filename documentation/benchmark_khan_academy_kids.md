# Benchmark: Khan Academy Kids Asset Breakdown 🕵️‍♂️

To build a true competitor, we must understand the "Gold Standard" assets used by *Khan Academy Kids*.

## 1. The Cast (Characters) vs Bright Kids
Khan Academy Kids relies on a **Team** of distinct personalities, whereas we are starting with a single **Guide**.

| Khan Kids Asset | Description | Bright Kids Equivalent | Notes |
| :--- | :--- | :--- | :--- |
| **Kodi Bear** | The main guide. Green hoodie. Encouraging, soft voice. | **Guide Lion/Bear** | Our mascot needs to match Kodi's warmth. |
| **Reya Red Panda** | The "energetic" friend. Often used for upbeat games. | *None (Phase 2)* | We should consider a 2nd character later. |
| **Peck the Bird** | The "logic/math" specialist. Small and precise. | *None* | Good for explaining UI elements. |
| **Sandy the Dingo** | The "arts/colors" specialist. | *None* | Good for creative tools. |
| **Ollo the Elephant**| The gentle giant. Often background support. | *None* | - |

**Insight**: Their cast allows them to switch "Vibes" per activity. We must make our single Mascot versatile (Active/Calm modes).

## 2. Visual Style Comparison
| Feature | Khan Kids Style | Our Goal Style |
| :--- | :--- | :--- |
| **Art Technique** | **Vector + Watercolor Texture**. Looks like a storybook. | **Vibrant 3D/2.5D**. High contrast, "Juicy" UI. |
| **Outlines** | Colored outlines (not black). Soft feel. | Crisp edges (Rive). Modern feel. |
| **Backgrounds** | Pastel colors. Simple shapes. Low noise. | "Sunny Valley". Richer depth (Parallax). |
| **UI Buttons** | Large, wobbly, organic shapes. | Rounded Rectangle, polished, tactile. |

## 3. The "Secret Sauce" (Audio) 🎵
Khan Kids feels alive because of its **Adaptive Audio**.

1.  **Instructional VO**: "Touch the *red* circle." (Clear, slow).
2.  **Feedback VO**: "Oops! Try again!" vs "Amazing!" (Recorded with variation, not robotic).
3.  **Music Layers**: The music fades lower when characters speak (Audio Ducking).
    *   *Our Goal*: Implement `AudioPlayers` ducking in Phase 5.

## 4. Asset Quantity Estimate (The Gap)
| Asset Category | Khan Kids (Est.) | Bright Kids (MVP) |
| :--- | :--- | :--- |
| **Unique Animations** | 200+ per character | 5-10 (Idle, Talk, Win, Lose, Hint) |
| **Voice Lines** | 5,000+ words | 50 essential phrases |
| **Books** | 100+ Original Titles | 5 Mock Titles (Scalable) |
| **Songs** | 50+ Super Simple Songs | 1 Looping BGM |

## Conclusion
To compete, we don't need *more* assets right now, we need **High Quality** core assets.
- If our one Mascot feels as alive as Kodi, we win.
- If our Map feels more dynamic (Parallax) than their menu, we win.
