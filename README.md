# ![alt text](/logo.svg) Traktor 4 - Unia MOD

# UNIA MOD – Traktor Pro 4 on steroids!

UNIA MOD is an advanced controller and screen mod for **Traktor Pro 4**

It extends Native Instruments’ CSI/QML layer with richer screens, deeper pad modes, and smarter overlays for the supported controllers, without requiring custom mappings or weird MIDI hacks.

---

## 1. What you get

### 1.1 Screen layouts & themes

For **S4 MK3** and **S8** screens, UNIA MOD adds multiple visual “skins” and extra info layers:

- **S4 MK3 themes**
  - `Original` – Close to NI’s stock layout, but enhanced.
  - `OriginalPro` – More detailed deck data and visual cues.
  - `UNIA` – Optimised for performance info and at-a-glance readability.

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
- Consistent overlays system shared between S4 MK3 and S8.

---

### 1.2 Overlays & quick controls

UNIA MOD adds a rich overlay system for both S4 MK3 and S8:

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

- S5 / S2 MK3 / S3 / D2  
  → Unified performance pads, improved transport/mixer logic, and better deck handling.

- CDJ / XDJ
  → CSI-based integration tuned to behave more like “club CDJs” inside Traktor.

---

## 2. Requirements & compatibility

- **Host application:** Traktor Pro 4 (current Qt 6-based builds).
- **Platform:** macOS and Windows should both work, but this port is primarily tested on macOS.
- **Controllers:** Any of the devices listed above.
  They still appear as normal NI devices in Traktor.

Always keep a backup of your original Traktor app and preferences.

---

## 3. Installation (safe method)

The recommended way is to run UNIA MOD from a **copy** of the Traktor app.

### 3.1 Make a copy of Traktor Pro 4

On macOS:

1. Go to `Applications/Native Instruments/`.
2. Duplicate `Traktor Pro 4.app`, e.g. rename the copy to:
   - `Traktor Pro 4 UNIA.app`  
   or
   - `Traktor Pro 4 copy.app`

We’ll only patch the *copy*, never the original.

---

## 4. Recording & Broadcast

### 4.1 Prepare Traktor's Mix Recorder
- In Traktor Pro 4, open **Preferences → Mix Recorder** and set the source to what you want to capture (e.g. **Internal/Master** for the full mix).
- Pick your destination folder and filename format; if you leave it default, Traktor writes into its **Mix Recordings** directory.
- If you plan to stream, fill in your broadcast server settings in the same panel.

### 4.2 Control recording from the controllers
- On S4 MK3 or S8/S5/D2, open the on-device **Settings** overlay.
- Navigate to **Recording & System → Mix Recorder**.
- Select **Start/Stop Recording** to toggle capturing; the entry highlights when recording and the elapsed timer shows how long the take has been running.
- Use **Broadcast** to start or stop live streaming using Traktor's broadcast settings (it won’t change your server details).
- Check **Elapsed Time** to monitor progress without looking at the laptop.

### 4.3 Tips
- Start a new take for each set to keep files manageable.
- If the timer does not move, arm the Mix Recorder in Traktor and confirm the source points to your master/booth signal.
- Recording and streaming can run together; make sure you have disk space and network access before enabling both.
