# Traktor Pro 4 — S5 Optimized QML Pack (2025 rewrite)

A refactored QML bundle for **Native Instruments Traktor Pro 4** that preserves a proven S5 performance workflow while cleaning the codebase, tightening compatibility, and upgrading the UI to modern level.

---

## What’s inside

### Controller features (S5)
- **Browse Encoder upgrades**  
  Turn = list navigation · **Shift+Turn** = cycle sort column · **Push** = load to focused deck · **Shift+Push** = pre-listen.
- **Loop Encoder ergonomics**  
  Turn = loop size step · **Push** = set in/out · **Shift** = fine step.
- **Touch Strips, performance-first**
  Default = pitch bend · **Shift** = seek (fast, precise scrubbing).
- **Cue drops without leaving the deck**
  Hold **Shift + Cue** to store the current track position as the Active Cue; tap **Shift + Cue** to keep the standard restart.
- **Pads with clear layer logic**
  Hotcues / Loops as primary layers; alternate layers on **Shift**. LEDs colored by cue type for instant recognition.

### On-controller menu (S5/S8)
- **Toggle:** Hold **Shift** and press **Back** to open/close the on-screen Settings menu when you’re not in the Browser.
- **Navigation:** Browse encoder turn = move selection · **Push** = enter/confirm · **Back** = go up a level.
- **Contents:**
  - Traktor Settings
  - S5/S8 Controller Settings (touch controls, touchstrip, LEDs, MIDI/Stem options)
  - Map Settings (buttons, encoders, pads, faders)
  - Display Settings (general, browser, track/stem deck, remix deck)
  - Other Settings (timers, fixes, mods, import/export)

### On-device screens (S5 via S8 views)
- **Deck HUD clarity**  
  Compact header shows **Title → Artist → BPM → Key → Phase**, with predictable truncation so the important data stays visible.
- **Browser quality-of-life**  
  Custom **Header/Footer** expose active sort, column hints, and path breadcrumbs directly on the device—less laptop peeking.
- **Minimal ↔ Performance HUD**  
  Toggleable overlay density to match dark clubs or info-rich prep sessions.

### Under-the-hood improvements
- **Compatibility shim**  
  `Defines/AppPaths.qml` centralizes AppProperty paths so future NI renames require a single edit.
- **Import hygiene**  
  QML imports normalized to **QtQuick 2.0** where possible for TP4 stability.

---

## Fixes & polish

- Normalized S5 wiring across decks: consistent browse/loop/strip behavior on A–D.
- Aligned LED color mapping for hotcues and states; reduces ambiguous pad feedback.
- Restores enhanced S8 screen components (used by S5) trimmed in stock TP4 builds.

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

## Controller behavior (S5 quick sheet)

- **Browse Encoder**:  
  Turn = navigate · **Shift+Turn** = sort column · **Push** = load · **Shift+Push** = pre-listen  
- **Loop Encoder**:  
  Turn = size · **Push** = loop in/out · **Shift** = fine step  
- **Touch Strips**:
  Default = bend · **Shift** = seek
- **Cue (Shift)**:
  Tap = restart from beginning; **Hold** = store a new Active Cue at the current playhead
- **Pads**:
  Primary = Hotcues/Loops · Alternate layers on **Shift** · LED colors reflect cue types

### Pad FX presets
- **Slot 1 (factory-populated):** Echo Fade · Echo Multi · Techno Phil · Space Toys · Echo Fade* (sweep) · Echo Multi* (macro) · Filter Pulse* · Electro Flyby*.
- **Create your own:** Edit `qml/Settings/PadFXs.qml` → populate the blank PadFX slots (2.1–8.8) with a `name`, `color`, `routing`, three `effect` slots, and initial `drywet`/`knob`/`button` values. Use the supported color list, routing types, and effect names documented at the top of the file as the source of truth. Save and reload Traktor to pick up changes.

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

