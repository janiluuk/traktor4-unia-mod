# Pro MOD for Traktor Pro 4.0+ with S5 / S8 controller

---
Rewritten UI which brings lot of new features, usability enhancements to S5 / S8 controllers.

## What’s inside

### Controller features (S5)

| Control | Primary | With Shift | Extra notes |
| --- | --- | --- | --- |
| **Browse Encoder** | Turn = list navigation · **Push** = load to focused deck | **Turn** = cycle sort column · **Push** = pre-listen | Works in Browser Sorting mode for column changes. |
| **Loop Encoder** | Turn = loop size step · **Push** = set in/out | Fine loop sizing | In Browser Sorting mode, **Push** flips sort direction without changing the active column. |
| **Touch Strips** | Pitch bend | Seek (fast, precise scrubbing) | Performance-first feel—scrub or bend without menu diving. |
| **Cue button** | Tap = restart from beginning | Hold = store current position as the Active Cue | Tap **Shift + Cue** later to jump back to the saved start point. |
| **Pads** | Hotcues / Loops as primary layers | Alternate layers | LED colors mirror cue types for instant recognition. |

### On-controller menu (S5/S8)
- **Toggle:** Hold **Shift** and press **Back** to open/close the on-screen Settings menu when you’re not in the Browser.
- **Navigation:** Browse encoder turn = move selection · **Push** = enter/confirm · **Back** = go up a level.
- **Contents:**
  - Traktor Settings
  - S5/S8 Controller Settings (touch controls, touchstrip, LEDs, MIDI/Stem options)
  - Map Settings (buttons, encoders, pads, faders)
  - Display Settings (general, browser, track/stem deck, remix deck)
  - Other Settings (timers, fixes, mods, import/export, Mix Recorder control with elapsed time)

- **Open the on-controller Settings menu**
  1. Hold **Shift** and press **Back** while you are on a deck or FX view (not in the Browser).
  2. Turn the Browse Encoder to move, press it to enter/confirm, and press **Back** again to exit a section.
  3. Repeat **Shift + Back** to close the menu and return to the deck view.

- **Start or stop the Mix Recorder from the controller**
  1. Open the Settings menu and navigate to **Other Settings → Recording → Mix Recorder**.
  2. Press the Browse Encoder on **Start Recording** (or **Stop Recording**). The second line shows the elapsed time for the current take so you can monitor length without looking at the laptop.
  3. Exit with **Back**; recording continues until you stop it from this entry or in Traktor’s UI.

- **Set an Active Cue from the controller**
  1. Play or pause the track where you want the cue.
  2. Hold **Shift** and press **Cue** for a moment—Traktor stores that playhead position as the new Active Cue.
  3. Tap **Shift + Cue** (without holding) any time to jump back to that saved start point.

- **Flip browser sort direction**
  1. Enter Browser Sorting mode (Shift + Browse turn) to pick a column.
  2. Press the **Loop Encoder** once to toggle between ascending and descending without changing the chosen column.

- **Create custom Pad FX presets**
  1. Open `qml/Settings/PadFXs.qml` and scroll past the prefilled Slot 1 examples.
  2. For any empty slot (2.1–8.8), add a `name`, choose a pad `color`, set `routing` and three `effect` blocks with `drywet`/`knob`/`button` values.
  3. Use the valid colors, routings, and effect names listed at the top of `PadFXs.qml`, save the file, and reload Traktor to see your pads.

### Pad FX presets
- **Slot 1 (factory-populated):** Echo Fade · Echo Multi · Techno Phil · Space Toys · Echo Fade* (sweep) · Echo Multi* (macro) · Filter Pulse* · Electro Flyby*.
- **Create your own:** Edit `qml/Settings/PadFXs.qml` → populate the blank PadFX slots (2.1–8.8) with a `name`, `color`, `routing`, three `effect` slots, and initial `drywet`/`knob`/`button` values. Use the supported color list, routing types, and effect names documented at the top of the file as the source of truth. Save and reload Traktor to pick up changes.

---

## UI mods at a glance

- **Deck Header**: tighter layout, persistent BPM/Key, predictable truncation.  
- **Browser**: on-screen sort indicator, column legend, path breadcrumbs.  
- **Phase/Sync bar**: compact drift check under the header.  
- **Theme-friendly**: legible in bright booths and dark rooms.

---

## Installation

1. Back up the existing Traktor QML folder: `Resources/qml`.  
2. Copy this package’s `qml/` into the TP4 installation:

   **macOS**  
   `/Applications/Traktor Pro 4.app/Contents/Resources/qml`

   **Windows**  
   `C:\Program Files\Native Instruments\Traktor Pro 4\Resources\qml`

3. Restart Traktor Pro 4.

> A `Settings.tsi` snapshot is included for reference (no overwrite required).

---

## Compatibility

- Built for **Traktor Pro 4**.
- Bundle trimmed to **S5/S8** mappings and screens only (other device templates removed).
- S5 uses S8 screen components; all bindings routed through `Defines/AppPaths.qml` to cushion NI property name changes.
- QML imports favor **QtQuick 2.0** to avoid version-pin issues in TP4.

---

## File map

```
qml/
  CSI/S5/                # S5 mapping modules (encoders, pads, side, mixer, deck)
  CSI/S8/                # S8 mapping modules
  Screens/S8/Views/...   # Deck & Browser UI used by S5/S8 screens
  Defines/AppPaths.qml   # Centralized app property path helpers
  Helpers/               # Utilities (LED maps, helpers)
  Settings/              # QML settings panes (menu content)
  Assets/                # Fonts, images
README.md
Settings.tsi             # Preferences snapshot (reference)
```

---

## Roadmap (optional add-ons)

- Single-gesture HUD toggle (bindable) for Minimal/Performance.  
- Daylight/Club theme presets that flip multiple visual settings at once.  
- Per-deck role profiles (e.g., A/B track, C/D stems) with automatic HUD & pad-layer tweaks.

---

