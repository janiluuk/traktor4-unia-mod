# ![alt text](/logo.svg) Traktor 4 - Unia MOD

# UNIA MOD – Traktor Pro 4 on steroids!

UNIA MOD is an advanced controller and screen mod for **Traktor Pro 4**

It extends Native Instruments’ CSI/QML layer with richer screens, deeper pad modes, and smarter overlays for the supported controllers, without requiring custom mappings or weird MIDI hacks.

**The core idea**: Control your entire DJ workflow directly from your controller—**no laptop interaction needed**. Advanced controls that are complex in the native version become simple and accessible right on your device.


## 🎯 Key Features at a Glance

### 📱 Enhanced Screens & Themes
- **Multiple visual themes** for S4 MK3, S5, and S8 (Original, OriginalPro, UNIA, CDJ-style layouts)
- **Improved deck displays** with detailed BPM, key, pitch, loop, sync, and quantize info
- **CDJ-inspired layouts** (CDJ2000NXS2, CDJ3000, Denon Prime styles)
- **Customizable deck headers** with 34 different information fields

### 🎛️ Smart Overlays
- **On-screen controls** for tempo, quantize, slice size, cue type, mixer FX, swing, and more
- **Browser enhancements** with sorting, warnings, and load protection
- **Context-aware displays** that eliminate laptop dependency—DJ with your laptop closed
- **Configurable overlay timers** for each overlay type
- **Simplified advanced controls**: Features that require diving into menus in native Traktor are now instantly accessible

### 🎹 Advanced Pad Modes
- **Hotcues Mode** with extended banks and better feedback
- **Loop Modes** (standard, advanced, loop roll)
- **Stems Mode** for individual track element control
- **Remix Modes** for sample and remix deck control
- **Creative modes**: Tone Play, Freeze, Sequencer
- **Pad FX** with customizable effect banks

### 🎚️ Extensive Customization
- **100+ configurable settings** accessible from controller
- **SHIFT button combinations** for quick access to alternate functions
- **Customizable button behaviors** (Play, Cue, Sync, Browse, etc.)
- **Adjustable encoder modes** with per-controller configuration
- **Haptic feedback controls** (S4 MK3)

### 🎧 DJ-Friendly Features
- **Beatgrid editing** directly from controller
- **Key sync** and musical key workflows
- **Beatmatch practice mode** (hide BPM)
- **Fader start** capability
- **Mix recording & broadcast** controls from controller
- **Safety features** to prevent accidental triggers

### 🎮 Supported Hardware
- **Native Instruments**: S4 MK3, S5, S8, S2 MK3, S3, D2
- **Pioneer DJ**: CDJ-3000, XDJ-700, XDJ-1000MK2 (via CSI)

---

## 📚 Table of Contents

1. [What you get](#1-what-you-get) - Detailed feature breakdown
2. [Controller Button Combinations & Shortcuts](#2-controller-button-combinations--shortcuts) - Quick reference guide
3. [Configurable Settings Reference](#3-configurable-settings-reference) - Complete settings documentation
4. [Requirements & Compatibility](#4-requirements--compatibility)
5. [Installation](#5-installation-safe-method)
6. [Recording & Broadcast](#6-recording--broadcast)

---

## 1. What you get


### 1.1 Screen layouts & themes

For **S4 MK3**, **S5**, and **S8** screens, UNIA MOD adds multiple visual “skins” and extra info layers:

- **S4 MK3 themes**
  - `Original` – Close to NI’s stock layout, but enhanced.
  - `OriginalPro` – More detailed deck data and visual cues.
  - `UNIA` – Optimised for performance info and at-a-glance readability.

- **S5 themes**
  - Enhanced displays with improved deck info and overlays
  - Optimized for standalone operation without laptop
  - Full browser and settings access directly on the controller screens

- **S8 themes**
  - `Traktor` – Enhanced stock-style screen.
  - `UNIA` / `UNIA MOD` – Performance-focused layouts.
  - `CDJ2000NXS2` style – CDJ-like deck layout and waveforms.
  - `CDJ3000` style – Modern CDJ-inspired layout.
  - `Prime` style – Denon Prime-inspired deck visual.

Common features across themes:

- Detailed deck info: BPM, key, pitch, loop, quantize, sync status, deck mode.
- Waveform and remix/stems views with extra overlays.
- Improved browser layouts and warnings (load protection, missing files, etc.).
- Consistent overlays system shared between S4 MK3, S5, and S8.

---

### 1.2 Overlays & quick controls

UNIA MOD adds a rich overlay system for S4 MK3, S5, and S8:

**Center overlays** (on-screen popups):

- `TempoAdjust` – Fine tempo controls in an overlay.
- `QuantizeSizeAdjust` – Change quantize size without diving into software.
- `SliceSize` – Control slicer size visually.
- `CueType` – Change cue type directly from the screen.
- `MixerFX` – Quick access to mixer FX assignment and status.
- `SwingAdjust` – Groove/swing adjustment.
- `BrowserSorting` – Browser sorting overlay.
- `BrowserWarnings` – Warnings for missing files / load protection.
- `RemixCaptureSource` – Capture routing overlays.

**Side overlays**:

- Scrollbars & button areas for remix decks and browser.
- Side status overlays for context (active deck, layer, etc.).

These overlays aim to reduce round-trips to the laptop and give you more “CDJ-style” autonomy.

#### Beatgrid shortcuts (controller)
- **S8**: `CAPTURE` sets a beat marker at the playhead; `SHIFT + CAPTURE` deletes the nearest beat marker.
- **S4 MK3**: In Grid/Edit mode with the grid unlocked, press the **Loop Move** encoder to drop a beat marker; `SHIFT + Loop Move` removes the nearest beat marker.

#### Menu navigation helpers
- In controller **Settings → Other → Mods**, toggle **Invert Menu Ordering** to flip list navigation direction.
- In the same menu, select **Back to Top** to jump straight to the first menu column.

---

### 1.3 Pad modes & performance engines

UNIA MOD replaces or extends the pad layers for supported controllers with a unified pad engine under `CSI/Common/PadsModes`:

Available pad modes (varies slightly per controller):

- **HotcuesMode** – Extended hotcue banks with better visual feedback.
- **LoopMode / AdvancedLoopMode** – Loop in/out, move, and resize with more control.
- **LoopRollMode** – Classic loop roll pads synced to the grid.
- **RemixMode / LegacyRemixMode / S4RemixMode** – Sample and remix deck control.
- **StemsMode** – Stems-focused pad mode (mute, solo, FX send).
- **TonePlayMode** – Cue-based “tone play” with pitch-shifted cue triggering.
- **FreezeMode** – Freeze segments and play them across the pads.
- **SequencerMode** – Step-sequencer style playback.
- **PadFX / PadFXUnit / PadFXsMode** – Pad-driven FX banks and macros.

Pad FXs and modes are further configurable through the `Preferences/PadFXs` UI.

---

### 1.4 Preferences & helpers

UNIA MOD adds:

- **UNIA preferences pages** in the controller screens:
  - Configure pad FX sets.
  - Adjust overlay behaviour.
  - Tune screen and pad behaviour beyond stock options.

- **Helpers & utilities**:
  - LED helpers (`Helpers/LED.js`) for consistent LED behaviour.
  - Key sync / scale helpers for better musical key workflows.
  - Shared `Defines` for loop sizes, move sizes, jump sizes, overlay definitions, etc.

---

### 1.5 Supported hardware

UNIA MOD currently extends/overrides CSI mappings and/or screens for:

- **Native Instruments**
  - Traktor Kontrol **S4 MK3**
  - Traktor Kontrol **S5**
  - Traktor Kontrol **S8**
  - Traktor Kontrol **S2 MK3**
  - Traktor Kontrol **S3**
  - Traktor Kontrol **D2**

- **Pioneer / CDJ-style (via CSI)**
  - **CDJ-3000**
  - **XDJ-700**
  - **XDJ-1000MK2**

What each device gets:

- S4 MK3 / S8  
  → New screen themes, overlays, and pad engines.

- **S5** (primary focus)  
  → Enhanced screen displays, unified performance pads, improved transport/mixer logic, better deck handling, and simplified access to advanced controls—designed for laptop-free operation.

- S2 MK3 / S3 / D2  
  → Unified performance pads, improved transport/mixer logic, and better deck handling.

- CDJ / XDJ
  → CSI-based integration tuned to behave more like “club CDJs” inside Traktor.

---

## 2. Controller Button Combinations & Shortcuts

UNIA MOD extends the default button behavior with many customizable combinations, especially using **SHIFT** + button/encoder.

### 2.1 S4 MK3 Button Combinations

#### Transport Buttons

| Button | Normal Press | SHIFT + Press (configurable) |
|--------|-------------|------------------------------|
| **PLAY** | Play/Pause | • Timecode mode (default)<br>• Vinyl Break |
| **CUE** | Cue point | • Cue (default)<br>• Cup (Cue + Play)<br>• Restart track<br>• Smart CUE + CUP |
| **SYNC** | Sync tempo | • Tempo Lock (default)<br>• Key Lock (preserve pitch)<br>• Key Lock (reset to 0) |

#### Encoders

| Encoder | Normal Mode | SHIFT + Mode (configurable) |
|---------|-------------|------------------------------|
| **Browse Encoder** | Browse library | • Coarse BPM adjust<br>• Fine BPM adjust<br>• Controller Zoom<br>• TP3 Zoom (default) |
| **Loop Size Encoder** | Adjust loop size | Configurable action |
| **Loop Move Encoder** (in Edit mode) | Move loop | **Press**: Set beat marker<br>**SHIFT + Press**: Delete nearest beat marker |

#### Pad Mode Buttons

| Button | Normal Press | SHIFT + Press (configurable) |
|--------|-------------|------------------------------|
| **HOTCUES** | Hotcue mode | • Loop mode (default)<br>• Advanced Loop mode<br>• Loop Roll mode<br>• Tone Play mode |
| **STEMS** | Stems mode (default) or Effects | • Stems mode<br>• Effects mode (PadFX) |

### 2.2 S8 Button Combinations

#### Beatgrid Editing
- **CAPTURE**: Set beat marker at playhead
- **SHIFT + CAPTURE**: Delete nearest beat marker

#### Browser & Navigation
- Browse encoder works similar to S4 MK3 with configurable SHIFT modes

### 2.3 S5 Button Combinations

The **S5** is designed for laptop-free DJing with simplified access to advanced controls:

#### Transport & Control
- **PLAY/CUE/SYNC**: Same configurable SHIFT combinations as S4 MK3
- **Browse Encoder**: Full library navigation and configurable SHIFT modes for BPM/Zoom
- **Loop Encoder**: Quick loop size adjustment with SHIFT for alternate functions

#### Performance Pads
- **Extended pad modes**: Hotcues, Loops, Stems, Remix, and more
- **SHIFT + Pad Mode buttons**: Quick access to alternate performance modes
- **Simplified FX control**: Pad-based FX easier to use than native mappings

#### Screen Display
- **On-screen overlays** for tempo, quantize, FX, and more—no laptop needed
- **Context-aware displays** show the info you need when you need it

### 2.4 Universal Shortcuts (All Controllers)

#### Settings Navigation
- **Invert Menu Ordering**: Flip list navigation direction (in Settings → Other → Mods)
- **Back to Top**: Jump to first menu column (in Settings → Other → Mods)

#### Browser
- **SHIFT + Browse Push**: Configurable action (varies by settings)
- Touch-enabled browser navigation on supported controllers

#### Deck Controls
- **Fader Start**: Enable/disable track starting when crossfader moves
- **Beatmatch Practice**: Hide BPM to practice beatmatching by ear

---

## 3. Configurable Settings Reference

UNIA MOD provides extensive customization through the on-controller Settings menu. Here's a comprehensive reference of all available settings:

### 3.1 Traktor Settings

#### Transport

| Setting | Options | Description |
|---------|---------|-------------|
| **Sync Mode** | Various modes | Configure how the sync button behaves in Traktor |

#### Mix Recorder

| Setting | Options | Description |
|---------|---------|-------------|
| **Start/Stop Mix Recording** | Toggle | Start or stop recording your mix from the controller |
| **Broadcast Stream** | Toggle | Start or stop live streaming (requires broadcast server setup in Traktor preferences) |
| **Recording Timer** | Display | Shows elapsed recording time |

---

### 3.2 Controller Setup (S4 MK3)

#### Transport

| Setting | Options | Description |
|---------|---------|-------------|
| **Tempo Faders** | Various modes | Configure tempo fader behavior and range |

#### Haptic Drive

| Setting | Options | Description |
|---------|---------|-------------|
| **Nudge Ticks** | Multiple levels | Adjust the intensity of haptic feedback when nudging |
| **Jogwheel Tension** | Multiple levels | Change the resistance feel of the jogwheels |
| **Haptic Hotcues** | On/Off | Enable/disable haptic feedback when triggering hotcues |

#### TT Mode (Turntable Mode)

| Setting | Options | Description |
|---------|---------|-------------|
| **Base Speed** | 33⅓ / 45 RPM | Set the turntable emulation speed |

#### LED Brightness

| Setting | Options | Description |
|---------|---------|-------------|
| **Brightness** | 0-100% | Overall LED brightness level |
| **Deck LEDs** | Various modes | Control LED behavior for deck indicators |

---

### 3.3 Deck Controls

#### Play / Pause

| Setting | Options | Description |
|---------|---------|-------------|
| **Play Action** | Various modes | What happens when you press Play |
| **Shift + Play** | • Timecode<br>• Vinyl Break | Action when pressing SHIFT + Play |
| **Play LED** | Various modes | How the Play button LED behaves |
| **Vinyl Break Settings** | Speed/curve options | Customize the vinyl brake effect |

#### Cue

| Setting | Options | Description |
|---------|---------|-------------|
| **Cue Action** | • Cue<br>• Cup<br>• Restart<br>• Smart | Default cue button behavior |
| **Shift + Cue** | • Cue<br>• Cup<br>• Restart<br>• Smart | Action when pressing SHIFT + Cue |
| **Cue LED** | Various modes | How the Cue button LED behaves |

#### Sync Options

| Setting | Options | Description |
|---------|---------|-------------|
| **Key Sync Options** | Various modes | Configure musical key synchronization behavior |

#### Browse Encoder

| Setting | Options | Description |
|---------|---------|-------------|
| **Shift + Browse Push** | Various actions | What happens when you push the browse encoder while holding SHIFT |
| **Browse Encoder Mode** | • Browse<br>• BPM Coarse<br>• BPM Fine<br>• Zoom | Normal browse encoder behavior |
| **Shift + Browse Mode** | • BPM Coarse<br>• BPM Fine<br>• Controller Zoom<br>• TP3 Zoom | Browse encoder behavior when holding SHIFT |

#### Loop Size Encoder

| Setting | Options | Description |
|---------|---------|-------------|
| **Shift + Loop Size Push** | Various actions | Action when pushing loop size encoder with SHIFT |

#### Hotcues Button

| Setting | Options | Description |
|---------|---------|-------------|
| **Shift + Hotcues** | • Loop Mode<br>• Advanced Loop<br>• Loop Roll<br>• Tone Play | Pad mode activated when pressing SHIFT + Hotcues |

#### Stems Button

| Setting | Options | Description |
|---------|---------|-------------|
| **Stems** | • Stems Mode<br>• Effects | Default Stems button behavior |
| **Shift + Stems** | • Stems Mode<br>• Effects | Action when pressing SHIFT + Stems |

#### Pads & Slot Select

| Setting | Options | Description |
|---------|---------|-------------|
| **Slot Selector Mode** | Various modes | How the slot selector buttons work |
| **Hotcue Play Mode** | Various modes | Behavior when pressing hotcue pads |
| **Hotcue Colors** | Color schemes | Customize hotcue pad colors |

#### Fader Start

| Setting | Options | Description |
|---------|---------|-------------|
| **Fader Start** | On/Off | Enable track starting when moving crossfader |

---

### 3.4 Screens & Browser

#### Screen Layout

| Setting | Options | Description |
|---------|---------|-------------|
| **Theme** | • Original<br>• OriginalPro<br>• UNIA<br>• CDJ2000NXS2<br>• CDJ3000<br>• Prime | Choose visual theme for deck displays |
| **Bright Mode (beta)** | On/Off | High-contrast display mode |

#### Browser View

| Setting | Options | Description |
|---------|---------|-------------|
| **Browser In Screens** | On/Off | Show browser on controller screens |
| **Related Screens** | On/Off | Link browser view across screens |
| **Related Browsers** | On/Off | Synchronize browser selection |
| **Browser on Touch** | On/Off | Open browser when touching browse encoder |
| **Rows in Browser** | Number | How many browser rows to display |
| **Displayed Info** | Various fields | What track information to show in browser |
| **Previously Played** | On/Off | Highlight already played tracks |
| **BPM Match Guides** | On/Off | Show BPM compatibility indicators |
| **Key Match Guides** | On/Off | Show musical key compatibility indicators |
| **Colored Keys** | On/Off | Use color coding for musical keys |

#### Deck View

| Setting | Options | Description |
|---------|---------|-------------|
| **Waveform Options** | Various modes | Customize waveform display |
| **Grid Options** | Various modes | Beatgrid display settings |
| **Stripe Options** | Various modes | Waveform stripe appearance |
| **Performance Panel** | On/Off | Show/hide performance info panel |
| **Beat Counter Settings** | Various modes | Beat counter display options |
| **Beat/Phase Widget** | On/Off | Show beat phase indicator |
| **Key Options** | Various modes | Musical key display settings |

#### Remix View

| Setting | Options | Description |
|---------|---------|-------------|
| **Slot Indicators** | Various modes | How remix deck slots are displayed |
| **Filter Fader** | On/Off | Show filter fader for remix decks |
| **Volume Fader** | On/Off | Show volume fader for remix decks |

---

### 3.5 Workflow & Safety

#### Overlay Timers

| Setting | Options | Description |
|---------|---------|-------------|
| **Browser View** | Seconds | How long browser overlay stays visible |
| **BPM/Key Overlay** | Seconds | Duration for BPM/key adjustment overlay |
| **Mixer FX Overlay** | Seconds | Duration for mixer FX overlay |
| **HotcueType Overlay** | Seconds | Duration for hotcue type overlay |
| **Side Buttons Overlay** | Seconds | Duration for side button overlays |

#### Safety Fixes

| Setting | Options | Description |
|---------|---------|-------------|
| **Hotcue Triggering** | Various modes | Prevent accidental hotcue triggers |

#### Mods & Shortcuts

| Setting | Options | Description |
|---------|---------|-------------|
| **Only focused controls** | On/Off | Only active deck responds to controls |
| **Beatmatch Practice** | On/Off | Hide BPM to practice beatmatching by ear |
| **Autoenable Flux** | On/Off | Automatically enable flux mode when scratching |
| **AutoZoom Edit Mode** | On/Off | Auto-zoom waveform when entering edit mode |
| **Shift Mode** | Various modes | Configure SHIFT button behavior |
| **Invert Menu Ordering** | On/Off | Reverse direction of menu navigation |
| **Back to Top** | Action | Jump to first column in settings menu |

---

### 3.6 Preferences/Customization Files

For advanced users, additional customization is available by editing QML files:

#### Preferences.qml

Located at `Resources/qml/Preferences/Preferences.qml`, this file allows you to customize:

| Setting | Description | Values |
|---------|-------------|--------|
| **Custom Waveform Colors** | Low/Mid/High frequency colors | RGBA values (0-255, alpha 0.0-1.0) |
| **Deck Header Layout** | Track info display positions | See header field IDs (0-33) below |

**Deck Header Field IDs:**
```
0: title             1: artist            2: release
3: mix               4: remixer           5: genre
6: track length      7: comment           8: comment2
9: label            10: catNo            11: bitrate
12: gain            13: elapsed time     14: remaining time
15: beats           16: beats to cue     17: sync/master
18: original bpm    19: bpm              20: stable bpm
21: tempo           22: stable tempo     23: tempo range
24: original key    25: resulting key    26: original keyText
27: resulting keyText 28: remixBeats     29: remixQuantize
30: capture source  31: mixerFX          32: mixerFXshort
33: off
```

Example configuration in Preferences.qml:
```javascript
property int topLeftState: 0      // title
property int topMiddleState: 14   // remaining time
property int topRightState: 20    // stable bpm
```

---

## 4. Requirements & compatibility

- **Host application:** Traktor Pro 4 (current Qt 6-based builds).
- **Platform:** macOS and Windows should both work, but this port is primarily tested on macOS.
- **Controllers:** Any of the devices listed above.
  They still appear as normal NI devices in Traktor.

Always keep a backup of your original Traktor app and preferences.

---

## 5. Installation (safe method)

The recommended way is to run UNIA MOD from a **copy** of the Traktor app.

### 5.1 Make a copy of Traktor Pro 4

#### On macOS:

1. Go to `Applications/Native Instruments/`.
2. Duplicate `Traktor Pro 4.app`, e.g. rename the copy to:
   - `Traktor Pro 4 UNIA.app`  
   or
   - `Traktor Pro 4 copy.app`

#### On Windows:

1. Navigate to `C:\Program Files\Native Instruments\Traktor Pro 4\`
2. Copy the entire `Traktor Pro 4` folder
3. Rename the copy to `Traktor Pro 4 UNIA` or similar

### 5.2 Install UNIA MOD files

1. Download or clone this repository
2. Navigate to the `Resources` folder in the UNIA MOD repository
3. Copy the `Resources` folder contents to your Traktor copy:
   - **macOS**: Right-click `Traktor Pro 4 UNIA.app` → Show Package Contents → `Contents/Resources/`
   - **Windows**: `C:\Program Files\Native Instruments\Traktor Pro 4 UNIA\Resources\`
4. If prompted, choose to replace/merge existing files
5. Launch your modified Traktor copy

**Note**: Some files may be read-only. On Windows, you may need administrator privileges to copy files to Program Files.

We’ll only patch the *copy*, never the original.

---

## 6. Recording & Broadcast

### 6.1 Prepare Traktor's Mix Recorder
- In Traktor Pro 4, open **Preferences → Mix Recorder** and set the source to what you want to capture (e.g. **Internal/Master** for the full mix).
- Pick your destination folder and filename format; if you leave it default, Traktor writes into its **Mix Recordings** directory.
- If you plan to stream, fill in your broadcast server settings in the same panel.

### 6.2 Control recording from the controllers
- On S4 MK3 or S8/S5/D2, open the on-device **Settings** overlay.
- Navigate to **Recording & System → Mix Recorder**.
- Select **Start/Stop Recording** to toggle capturing; the entry highlights when recording and the elapsed timer shows how long the take has been running.
- Use **Broadcast** to start or stop live streaming using Traktor's broadcast settings (it won’t change your server details).
- Check **Elapsed Time** to monitor progress without looking at the laptop.

### 6.3 Tips
- Start a new take for each set to keep files manageable.
- If the timer does not move, arm the Mix Recorder in Traktor and confirm the source points to your master/booth signal.
- Recording and streaming can run together; make sure you have disk space and network access before enabling both.
