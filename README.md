# Traktor 4 - Unia MOD

**Enhanced controller mapping and UI for Traktor Pro 4 S5/S8 controllers**

This mod extends the native Traktor Pro 4 experience with quality-of-life improvements and new features designed for S5/S8 hardware.

---

## What's Different from Stock Traktor?

### 🎛️ **New Controller Features**

**Browse Encoder enhancements:**
- **Shift + Turn** = Cycle through browser sort columns (not in stock Traktor)
- **Shift + Push** = Pre-listen to tracks without loading (not in stock Traktor)

**Loop Encoder additions:**
- In Browser Sorting mode, **Push** flips sort direction (ascending/descending)

**Cue Button with Active Cue:**
- **Hold Shift + Cue** = Store current position as Active Cue
- **Tap Shift + Cue** = Jump back to stored Active Cue
- *Standard Traktor only has one static cue point*

**Touch Strips dual mode:**
- Default = Pitch bend
- With Shift = Fast seek/scrub through track

**Full Settings Menu on Hardware:**
- **Shift + Back** opens complete Traktor settings on the S5/S8 screen
- Control Mix Recorder, adjust mappings, change display settings - all without touching your laptop
- *Stock Traktor requires laptop for most settings*

---

### 🎨 **UI Improvements**

**Enhanced Browser:**
- Sort column indicator visible on screen
- Path breadcrumbs showing current folder location
- Better text truncation and layout

**Improved Deck Header:**
- Always-visible BPM and Key
- Cleaner layout optimized for controller screen
- Better contrast in various lighting conditions

**Phase/Sync Display:**
- Compact phase meter under deck header
- Quick visual sync check

**Custom Pad FX Presets:**
- 64 customizable Pad FX slots (8 banks × 8 pads)
- Edit `qml/Settings/PadFXs.qml` to create your own effect combinations
- 8 factory presets included in Slot 1

---

## Installation

⚠️ **CRITICAL**: Merge files, do not replace folders!

1. **Backup** Traktor's qml folder:
   - **macOS**: `/Applications/Traktor Pro 4.app/Contents/Resources/qml`
   - **Windows**: `C:\Program Files\Native Instruments\Traktor Pro 4\Resources\qml`

2. **Copy and merge** this mod's `qml/` folder into Traktor's qml folder:
   - Copy each subfolder individually
   - Choose **"Merge"** when prompted (NOT "Replace folder")
   - This preserves Traktor's core files

3. **Import settings** (optional):
   - In Traktor: Preferences → Controller Manager → Import → `Settings.tsi`

4. **Restart Traktor** to load the mod

### Troubleshooting

**Controller not showing up?**
- You likely replaced instead of merged folders.
- Restore backup and merge properly.
- Remove `qml/CSI/qmldir` if it exists (should not be there).
- Verify `qml/CSI/S5/S5.qml` and `qml/CSI/S8/S8.qml` exist.

---

## Compatibility

- **Traktor Pro 4** only
- **S5/S8 controllers** (optimized specifically for these)

---

## Quick Reference

### Key Combinations

| Action | Controller | Command |
|--------|-----------|---------|
| Open Settings Menu | S5/S8 | **Shift + Back** (outside browser) |
| Browser Sort Column | S5/S8 | **Shift + Browse Turn** |
| Pre-listen Track | S5/S8 | **Shift + Browse Push** |
| Store Active Cue | S5/S8 | **Hold Shift + Cue** |
| Jump to Active Cue | S5/S8 | **Tap Shift + Cue** |
| Flip Sort Direction | S5/S8 | **Loop Encoder Push** (in sort mode) |
| Seek/Scrub | S5/S8 | **Shift + Touch Strip** |

### Pad FX Customization

Edit `qml/Settings/PadFXs.qml` to create your own effect chains:
- 64 total slots available (8 banks × 8 pads)
- Set name, color, routing, and 3 effects per slot
- Slot 1 has 8 factory presets as examples
- Valid colors, effects, and routing types are documented in the file

---

## File Structure

```
qml/
  CSI/S5/                # S5 controller mapping
  CSI/S8/                # S8 controller mapping  
  Screens/S8/Views/      # UI components (Browser, Deck, etc.)
  Defines/               # App property helpers
  Helpers/               # Utilities (LED maps, etc.)
  Settings/              # Settings menu content
Settings.tsi             # Controller preferences (reference)
```

---

**Made by the community, for the community** 🎧
