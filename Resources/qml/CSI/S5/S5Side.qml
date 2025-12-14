import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../Common/LegacyControllers"
import "../../Helpers/LED.js" as LED

Module {
    id: side
    property bool useMIDIControls: false
    property int topDeckId: 1  // Set by parent (S5.qml)
    property int bottomDeckId: 3  // Set by parent (S5.qml)
    property string surface: "hw.side"
    property string settingsPath: "mapping.settings.left"
    property string propertiesPath: "mapping.state.left"
    property bool onlyFocusedDeck: false  // Set by parent (S5.qml)
    property bool stemResetOnLoad: true  // Set by parent (S5.qml)
    property bool stemSelectorModeHold: false  // Set by parent (S5.qml)
    readonly property real bright: 1.0

    // Note: screenView alias is defined after the MappingPropertyDescriptor to avoid forward reference
    // Will be set up after screenView MappingPropertyDescriptor is defined

    //Master clock
    AppProperty { id: masterId; path: "app.traktor.masterclock.source_id" } //-1: MasterClock, 0: Deck A, 1: Deck B, 2: Deck C, 3: Deck D
    
    //Hold timer (shared setting from parent)
    MappingProperty { id: holdTimer; path: "mapping.settings.holdTimer" }

//------------------------------------------------------------------------------------------------------------------
// PREFERENCES PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    //FXs Control Assignment
    MappingPropertyDescriptor { id: topFXUnit; path: settingsPath + ".topFXUnit"; type: MappingPropertyDescriptor.Integer; min: 1; max: 4 }
    MappingPropertyDescriptor { id: bottomFXUnit; path: settingsPath + ".bottomFXUnit"; type: MappingPropertyDescriptor.Integer; min: 0; max: 4; onValueChanged: { if (typeof updateFooterPage === 'function') updateFooterPage(); if (value != 0) padFXsUnit.value = value } }
    MappingPropertyDescriptor { id: padFXsUnit; path: settingsPath + ".padFXsUnit"; type: MappingPropertyDescriptor.Integer; min: 1; max: 4 }
    MappingPropertyDescriptor { id: padFXsBank; path: propertiesPath + ".padFXsBank"; type: MappingPropertyDescriptor.Integer; value: 1; min: 1; max: 8 }

    //Preferences Navigation Properties
    MappingPropertyDescriptor { id: fxSettingsNavigation; path: propertiesPath + ".fxSettingsNavigation"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: fxSettingsPush; path: propertiesPath + ".fxSettingsPush"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: fxSettingsTab; path: propertiesPath + ".fxSettings_tab"; type: MappingPropertyDescriptor.Integer; value: 1; min: 1; max: 8 }
    MappingPropertyDescriptor { id: preferencesNavigation; path: propertiesPath + ".preferencesNavigation"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: preferencesPush; path: propertiesPath + ".preferencesPush"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: preferencesBack; path: propertiesPath + ".preferencesBack"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: backBright; path: propertiesPath + ".backBright"; type: MappingPropertyDescriptor.Boolean; value: false }

    //Integer Editor State Properties
    MappingPropertyDescriptor { id: integerEditor; path: propertiesPath + ".integer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: nudgeSensivityEditor; path: propertiesPath + ".nudgeSensivity_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: scratchSensivityEditor; path: propertiesPath + ".scratchSensivity_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: onBrightnessEditor; path: propertiesPath + ".onBrightness_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: dimmedBrightnessEditor; path: propertiesPath + ".dimmedBrightness_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: vinylBreakDurationInBeatsEditor; path: propertiesPath + ".vinylBreakDurationInBeats_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: vinylBreakDurationInSecondsEditor; path: propertiesPath + ".vinylBreakDurationInSeconds_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: waveformOffsetEditor; path: propertiesPath + ".waveformOffset_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: beatsxPhraseEditor; path: propertiesPath + ".beatsxPhrase_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: browserRowsEditor; path: propertiesPath + ".browserRows_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: waveformColorEditor; path: propertiesPath + ".waveformColor_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: gridModeEditor; path: propertiesPath + ".gridMode_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: beatCounterModeEditor; path: propertiesPath + ".beatCounterMode_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: perfectTempoMatchLimitEditor; path: propertiesPath + ".perfectTempoMatchLimit_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: regularTempoMatchLimitEditor; path: propertiesPath + ".regularTempoMatchLimit_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: browserTimerEditor; path: propertiesPath + ".browserTimer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: overlayTimerEditor; path: propertiesPath + ".overlayTimer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: mixerFXTimerEditor; path: propertiesPath + ".mixerFXTimer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: hotcueTypeTimerEditor; path: propertiesPath + ".hotcueTypeTimer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: sideButtonsTimerEditor; path: propertiesPath + ".sideButtonsTimer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: holdTimerEditor; path: propertiesPath + ".holdTimer_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: stepBpmEditor; path: propertiesPath + ".stepBpm_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: stepShiftBpmEditor; path: propertiesPath + ".stepShiftBpm_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: stepTempoEditor; path: propertiesPath + ".stepTempo_editor"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: stepShiftTempoEditor; path: propertiesPath + ".stepShiftTempo_editor"; type: MappingPropertyDescriptor.Boolean; value: false }

    //S8/D2 properties --> keep this to avoid the softtakrover faders to appear on the S5 Screen
    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.show_faders"; type: MappingPropertyDescriptor.Boolean; value: false }

    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.1.active"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.1.input"; type: MappingPropertyDescriptor.Float; value: 0.0 }
    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.1.output"; type: MappingPropertyDescriptor.Float; value: 0.0 }

    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.2.active"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.2.input"; type: MappingPropertyDescriptor.Float; value: 0.0 }
    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.2.output"; type: MappingPropertyDescriptor.Float; value: 0.0 }

    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.3.active"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.3.input"; type: MappingPropertyDescriptor.Float; value: 0.0 }
    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.3.output"; type: MappingPropertyDescriptor.Float; value: 0.0 }

    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.4.active"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.4.input"; type: MappingPropertyDescriptor.Float; value: 0.0 }
    MappingPropertyDescriptor { path: propertiesPath + ".softtakeover.faders.4.output"; type: MappingPropertyDescriptor.Float; value: 0.0 }

    // Shift - must be defined early for hardware recognition
    property alias shift: shiftProp.value
    MappingPropertyDescriptor { id: shiftProp; path: propertiesPath + ".shift"; type: MappingPropertyDescriptor.Boolean; value: false }
    Wire { from: "%surface%.shift"; to: DirectPropertyAdapter { path: propertiesPath + ".shift" } }

//------------------------------------------------------------------------------------------------------------------
// SCREEN VIEW (defined early for S5Deck components, handler is safe)
//------------------------------------------------------------------------------------------------------------------

    MappingPropertyDescriptor { id: screenViewProp; path: propertiesPath + ".screen_view"; type: MappingPropertyDescriptor.Integer; value: ScreenView.deck } //deck: 0, browser: 1, screen settings: 2
    
    // Define alias after screenViewProp is defined
    property alias screenView: screenViewProp

    //Pads focus Properties (defined early for S5Deck components)
    property bool padsModeReady: false
    MappingPropertyDescriptor { id: activePadsMode; path: propertiesPath + ".pads_mode"; type: MappingPropertyDescriptor.Integer; value: PadsMode.disabled; 
        onValueChanged: {
            if (padsModeReady) updatePads()
        }
    }

    // updateFooterPage function moved earlier (see above)
    function updateFooterPage() {
        if (!footerDeck().validateFooterPage(footerPage.value)) {
            footerDeck().defaultFooterPage()
        }
    }
    
    // Initialize focusedDeckId and unfocusedDeckId with safe defaults - will be updated in Component.onCompleted
    property int focusedDeckId: topDeckId
    property int unfocusedDeckId: bottomDeckId

//------------------------------------------------------------------------------------------------------------------
// DECKS INITIALIZATION
//------------------------------------------------------------------------------------------------------------------

    function initializeModule() {
        // Update remixId and footerId first, before accessing decks
        remixId = getRemixId();
        footerId = getFooterId();
        
        var focused = focusedDeck();
        var unfocused = unfocusedDeck();
        var footer = footerDeck();
        if (focused) {
            focused.padsMode = focused.defaultPadsMode();
            // Set padsModeReady before changing activePadsMode to allow updatePads to run
            padsModeReady = true
            activePadsMode.value = focused.padsMode;
        }
        if (unfocused) {
            unfocused.padsMode = unfocused.defaultPadsMode();
        }
        if (footer) {
            footer.defaultFooterPage();
        }

        if (!topFXUnit.value) topFXUnit.value = topDeckId;
        if (!bottomFXUnit.value) bottomFXUnit.value = 0;
        if (!padFXsUnit.value) padFXsUnit.value = bottomDeckId;
    }

    S5Deck {
        id: deckA
        name: "deckA"
        active: (topDeckFocused && topDeckFocused.value !== undefined) ? ((topDeckId == 1 && topDeckFocused.value) || (bottomDeckId == 1 && !topDeckFocused.value)) : (topDeckId == 1)
        deckId: 1
        surface: side.surface
        settingsPath: side.settingsPath
        propertiesPath: side.propertiesPath
        footerId: side.footerId
        remixId: side.remixId
        activePadsMode: side.activePadsMode
        screenView: side.screenView
        updateFooterPage: side.updateFooterPage
    }

    S5Deck {
        id: deckB
        name: "deckB"
        active: (topDeckFocused && topDeckFocused.value !== undefined) ? ((topDeckId == 2 && topDeckFocused.value) || (bottomDeckId == 2 && !topDeckFocused.value)) : (topDeckId == 2)
        deckId: 2
        surface: side.surface
        settingsPath: side.settingsPath
        propertiesPath: side.propertiesPath
        footerId: side.footerId
        remixId: side.remixId
        activePadsMode: side.activePadsMode
        screenView: side.screenView
        updateFooterPage: side.updateFooterPage
    }

    S5Deck {
        id: deckC
        name: "deckC"
        active: (topDeckFocused && topDeckFocused.value !== undefined) ? ((topDeckId == 3 && topDeckFocused.value) || (bottomDeckId == 3 && !topDeckFocused.value)) : (topDeckId == 3)
        deckId: 3
        surface: side.surface
        settingsPath: side.settingsPath
        propertiesPath: side.propertiesPath
        footerId: side.footerId
        remixId: side.remixId
        activePadsMode: side.activePadsMode
        screenView: side.screenView
        updateFooterPage: side.updateFooterPage
    }

    S5Deck {
        id: deckD
        name: "deckD"
        active: (topDeckFocused && topDeckFocused.value !== undefined) ? ((topDeckId == 4 && topDeckFocused.value) || (bottomDeckId == 4 && !topDeckFocused.value)) : (topDeckId == 4)
        deckId: 4
        surface: side.surface
        settingsPath: side.settingsPath
        propertiesPath: side.propertiesPath
        footerId: side.footerId
        remixId: side.remixId
        activePadsMode: side.activePadsMode
        screenView: side.screenView
        updateFooterPage: side.updateFooterPage
    }

//------------------------------------------------------------------------------------------------------------------
// DECK FOCUS
//------------------------------------------------------------------------------------------------------------------

    //Focus
    MappingPropertyDescriptor { 
        id: topDeckFocused
        path: propertiesPath + ".top_deck_focus"
        type: MappingPropertyDescriptor.Boolean
        value: true
        onValueChanged: {
            // Update focusedDeckId and unfocusedDeckId
            focusedDeckId = topDeckFocused.value ? topDeckId : bottomDeckId
            unfocusedDeckId = !topDeckFocused.value ? topDeckId : bottomDeckId
            
            if (screenViewProp && screenViewProp.value == ScreenView.deck) {
                if (screenOverlay) screenOverlay.value = Overlay.none
            }
            if (editMode && editMode.value != EditMode.disabled) {
                editMode.value = EditMode.disabled
            }
            var focused = focusedDeck();
            var unfocused = unfocusedDeck();
            if (focused && unfocused && !((activePadsMode.value == PadsMode.remix || activePadsMode.value == PadsMode.legacyRemix) && focused.validatePadsMode(unfocused.padsMode) && focused.deckType != unfocused.deckType)) {
                activePadsMode.value = focused.padsMode
            }
            if (padsModeReady) updatePads()
        }
    }
    property alias deckFocus: topDeckFocused.value
    
    Component.onCompleted: {
        // Initialize focusedDeckId and unfocusedDeckId after topDeckFocused is ready
        focusedDeckId = topDeckFocused.value ? topDeckId : bottomDeckId
        unfocusedDeckId = !topDeckFocused.value ? topDeckId : bottomDeckId
    }

    
    // Helper function to safely get remixId
    function getRemixId() {
        var focused = focusedDeck();
        var unfocused = unfocusedDeck();
        if (!focused || !unfocused) return focusedDeckId;
        return ((focused.hasRemixProperties || !unfocused.hasRemixProperties) || onlyFocusedDeck) ? focusedDeckId : unfocusedDeckId;
    }
    
    // Helper function to safely get footerId
    function getFooterId() {
        var focused = focusedDeck();
        var unfocused = unfocusedDeck();
        if (!focused || !unfocused) return focusedDeckId;
        return ((focused.hasBottomControls || !unfocused.hasBottomControls) || onlyFocusedDeck) ? focusedDeckId : unfocusedDeckId;
    }
    
    // Initialize with safe defaults - these are updated in initializeModule()
    property int remixId: topDeckId
    property int footerId: topDeckId

    function master() { 
        // Use safe masterDeckId: if masterId is -1, use 1 as fallback
        var safeMasterDeckId = (masterId.value >= 0) ? (masterId.value + 1) : 1;
        return deck(safeMasterDeckId);
    }
    function focusedDeck() { return deck(focusedDeckId) }
    function unfocusedDeck() { return deck(unfocusedDeckId) }
    function remixDeck() { return deck(remixId) }
    function footerDeck() { return deck(footerId) }

    function deck(id) {
        // Ensure id is valid (1-4) to prevent returning undefined
        if (id < 1 || id > 4) return deckA; // fallback to deckA
        switch (id) {
            case 1: return deckA
            case 2: return deckB
            case 3: return deckC
            case 4: return deckD
            default: return deckA
        }
    }

    //Deck button
    Wire { from: "%surface%.deck"; to: "deckButton" }
    MappingPropertyDescriptor { id: holdDeck; path: propertiesPath + ".holdDeck"; type: MappingPropertyDescriptor.Boolean; value: false }
    ButtonScriptAdapter {
        name: "deckButton"
        brightness: bright
        color: LED.legacy(focusedDeckId)
        onPress: {
            holdDeck_countdown.restart()
        }
        onRelease: {
            if (holdDeck_countdown.running) {
                if (shift && screenViewProp && screenViewProp.value == ScreenView.deck) screenViewProp.value = ScreenView.fxSettings
                else if (screenViewProp && screenViewProp.value == ScreenView.fxSettings) screenViewProp.value = ScreenView.deck
                else topDeckFocused.value = !topDeckFocused.value
            }
            holdDeck_countdown.stop()
            holdDeck.value = false
        }
    }
    Timer { id: holdDeck_countdown; interval: holdTimer.value
        onTriggered: {
            holdDeck.value = true
        }
    }

    //Pads focus Properties (moved earlier, see above)

    function updatePads() {
        var focused = focusedDeck();
        var remix = remixDeck();
        if (!focused) return;
        
        if (focused.validatePadsMode(activePadsMode.value)) {
            focused.padsMode = activePadsMode.value
            focused.enablePads = true
            disablePads(focusedDeckId)
        }
        else if (remix && remix.validatePadsMode(activePadsMode.value) && (activePadsMode.value == PadsMode.legacyRemix || activePadsMode.value == PadsMode.remix)) {
            remix.padsMode = activePadsMode.value
            remix.enablePads = true
            disablePads(remixId)
            if (focused.defaultPadsMode() != PadsMode.disabled) {
                focused.padsMode = focused.defaultPadsMode()
            }
        }
        else if (focused.validatePadsMode(focused.defaultPadsMode())) {
            activePadsMode.value = focused.defaultPadsMode()
            focused.enablePads = true
            disablePads(focusedDeckId)
        }
        else {
            disablePads(0)
            activePadsMode.value = PadsMode.disabled
        }
    }

    function disablePads(focusId) {
        if (focusId != 1) deckA.enablePads = false
        if (focusId != 2) deckB.enablePads = false
        if (focusId != 3) deckC.enablePads = false
        if (focusId != 4) deckD.enablePads = false
    }

//------------------------------------------------------------------------------------------------------------------
// SCREEN INITIALIZATION
//------------------------------------------------------------------------------------------------------------------

    KontrolScreen {
        id: screen
        name: "screen"
        flavor: ScreenFlavor.S5
        side: topDeckId == 1 ? ScreenSide.Left : ScreenSide.Right
        settingsPath: side.settingsPath
        propertiesPath: side.propertiesPath
    }
    Wire { from: "screen.output"; to: "%surface%.display" }
    Wire { from: "screen.screen_view_state"; to: DirectPropertyAdapter { path: propertiesPath + ".screen_view"; input: false } }
    
    MappingPropertyDescriptor { id: screenIsSingleDeck; path: propertiesPath + ".screenIsSingleDeck"; type: MappingPropertyDescriptor.Boolean; value: true }

    //Browser View
    MappingPropertyDescriptor { id: browserIsContentList; path: propertiesPath + ".browser.is_content_list"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: browserIsTemporary; path: propertiesPath + ".browser.is_temporary"; type: MappingPropertyDescriptor.Boolean; value: false;
        onValueChanged: {
            if (screenView.value == ScreenView.deck) {
                screenView.value = ScreenView.browser
            }
            else if (screenView.value == ScreenView.browser && browserIsTemporary.value) {
                browserLeaveTimer.stop()
            }
            else if (screenView.value == ScreenView.browser && !browserIsTemporary.value) {
                browserLeaveTimer.restart()
            }
        }
    }
    Timer { id: browserLeaveTimer; interval: browserTimer.value;
        onTriggered: {
            if (screenView.value == ScreenView.browser && showBrowserOnTouch.value && !browserIsTemporary.value) {
                screenView.value = ScreenView.deck
            }
        }
    }

    //Browser navigation - use explicit load command to ensure correct deck
    AppProperty { id: loadSelected; path: "app.traktor.decks." + safeFocusedDeckId + ".load.selected" }
    MappingProperty { id: browserEnterNode; path: propertiesPath + ".browserEnterNode" }
    
    WiresGroup {
        enabled: screenView.value == ScreenView.browser
        Wire { from: "%surface%.browse.push"; to: ButtonScriptAdapter { 
            onPress: { 
                // Set browser enter node for navigation
                browserEnterNode.value = true;
                // Explicitly load to the focused deck for this side (ensures correct deck)
                loadSelected.value = true;
            }
        } enabled: screenOverlay.value == Overlay.none }
        Wire { from: "%surface%.back"; to: "screen.exit_browser_node" }
        Wire { from: "%surface%.browse.turn"; to: "screen.scroll_browser_row"; enabled: !shift }
        Wire { from: "%surface%.browse.turn"; to: "screen.scroll_browser_page"; enabled: shift }
        Wire { from: "%surface%.encoder"; to: "screen.browser_sorting"; enabled: browserIsContentList.value && ((!shift && loopEncoderInBrowser.value == 0) || (shift && shiftLoopEncoderInBrowser.value == 0)) }
    }

//------------------------------------------------------------------------------------------------------------------
// EDIT GRID VIEW PROPERTIES
//------------------------------------------------------------------------------------------------------------------

    property double preEditZoom: 0
    property bool preEditIsSingleDeck: true
    MappingPropertyDescriptor { id: editMode; path: propertiesPath + ".edit_mode"; type: MappingPropertyDescriptor.Integer; value: EditMode.disabled;
        onValueChanged: {
            if (editMode.value == EditMode.full) {
                screenOverlay.value = Overlay.none
                preEditIsSingleDeck = screenIsSingleDeck.value
                screenIsSingleDeck.value = true
            }
            else {
                screenIsSingleDeck.value = preEditIsSingleDeck
                if (zoomedEditView.value) zoomedEditView.value = false
            }
            focusedDeck().updateAdvancedPanelView()
        }
    }

    // Use safe path: ensure focusedDeckId is valid (1-4) to prevent invalid paths
    property int safeFocusedDeckId: (focusedDeckId >= 1 && focusedDeckId <= 4) ? focusedDeckId : topDeckId
    AppProperty { id: waveformZoom; path: "app.traktor.decks." + safeFocusedDeckId + ".track.waveform_zoom" }
    MappingPropertyDescriptor { id: zoomedEditView; path: propertiesPath + ".beatgrid.zoomed_view"; type: MappingPropertyDescriptor.Boolean; value: false
        onValueChanged: {
            if (zoomedEditView.value) {
                preEditZoom = waveformZoom.value
                if (editMode.value == EditMode.full && autoZoomTPwaveform.value) {
                    waveformZoom.value = 1.00
                }
            }
            else {
                waveformZoom.value = preEditZoom
            }
        }
    }
    MappingPropertyDescriptor { path: propertiesPath + ".beatgrid.position"; type: MappingPropertyDescriptor.Float; value: 0.0 }
    MappingPropertyDescriptor { path: propertiesPath + ".beatgrid.scan_beats_offset"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: scanDirection; path: propertiesPath + ".beatgrid.scan_direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: scanUpdater; path: propertiesPath + ".beatgrid.scan_updater"; type: MappingPropertyDescriptor.Boolean; value: false }
    MappingPropertyDescriptor { id: encoderScanMode; path: propertiesPath + ".encoderScanMode"; type: MappingPropertyDescriptor.Boolean; value: false } //S5 Only

//------------------------------------------------------------------------------------------------------------------
// CENTER OVERLAY
//------------------------------------------------------------------------------------------------------------------

    MappingPropertyDescriptor { id: screenOverlay; path: propertiesPath + ".overlay"; type: MappingPropertyDescriptor.Integer; value: Overlay.none;
        onValueChanged: {
            //Restart timeout count for autoclosing overlays
            if (screenOverlay.value == Overlay.bpm || screenOverlay.value == Overlay.key || screenOverlay.value == Overlay.quantize || screenOverlay.value == Overlay.swing) {
                overlay_countdown.restart();
            }
            //Restart timeout count for shorter autoclosing overlays
            if (screenOverlay.value == Overlay.mixerfx) {
                mixerfx_overlay_countdown.restart();
            }
            //Restart timeout count for shorter autoclosing overlays
            if (screenOverlay.value == Overlay.hotcueType) {
                hotcueType_overlay_countdown.restart();
            }
            else { selectedHotcue.value = 0 }
        }
    }

    //Generic overlays
    Timer { id: overlay_countdown; interval: overlayTimer.value;
        onTriggered: {
            if (screenOverlay.value == Overlay.bpm || screenOverlay.value == Overlay.key || screenOverlay.value == Overlay.quantize || screenOverlay.value == Overlay.swing) {
                screenOverlay.value = Overlay.none
            }
        }
    }
    Wire {
        enabled: screenOverlay.value == Overlay.bpm || screenOverlay.value == Overlay.key || screenOverlay.value == Overlay.quantize || screenOverlay.value == Overlay.swing
        from: Or {
            inputs:
            [
            "%surface%.browse.push",
            "%surface%.browse.touch",
            "%surface%.browse.is_turned",
            "%surface%.back",
            "%surface%.shift",
            //"s5.mixer.tempo"
            ]
        }
        to: ButtonScriptAdapter { onPress: overlay_countdown.stop(); onRelease: overlay_countdown.restart() }
    }

    //HotcueType overlay
    MappingPropertyDescriptor { id: selectedHotcue; path: propertiesPath + ".selectedHotcue"; type: MappingPropertyDescriptor.Integer; value: 0; onValueChanged: { if (selectedHotcue.value != 0) screenOverlay.value = Overlay.hotcueType } }
    MappingPropertyDescriptor { id: hotcueModifier; path: propertiesPath + ".hotcueModifier"; type: MappingPropertyDescriptor.Boolean; value: false }
    Wire { from: "%surface%.hotcue"; to: HoldPropertyAdapter { path: hotcueModifier.path; output: false } enabled: activePadsMode.value == PadsMode.hotcues }
    Timer { id: hotcueType_overlay_countdown; interval: hotcueTypeTimer.value;
        onTriggered: {
            if (screenOverlay.value == Overlay.hotcueType) {
                screenOverlay.value = Overlay.none
            }
        }
    }
    Wire {
        enabled: screenOverlay.value == Overlay.hotcueType
        from: Or {
            inputs:
            [
            "%surface%.browse.push",
            "%surface%.browse.touch",
            "%surface%.browse.is_turned",
            "%surface%.back",
            "%surface%.hotcue"
            ]
        }
        to: ButtonScriptAdapter { onPress: hotcueType_overlay_countdown.stop(); onRelease: hotcueType_overlay_countdown.restart() }
    }

    //MixerFX overlay
    Timer { id: mixerfx_overlay_countdown; interval: mixerFXTimer.value;
        onTriggered: {
            if (screenOverlay.value == Overlay.mixerfx) {
                screenOverlay.value = Overlay.none
            }
        }
    }
    Wire {
        enabled: screenOverlay.value == Overlay.mixerfx
        from: Or {
            inputs:
            [
            "%surface%.browse.push",
            "%surface%.browse.touch",
            "%surface%.browse.is_turned",
            "%surface%.back",
            "%surface%.shift",
            //"s5.mixer.tempo"
            ]
        }
        to: ButtonScriptAdapter { onPress: mixerfx_overlay_countdown.stop(); onRelease: mixerfx_overlay_countdown.restart() }
    }

    //BPM overlay
    // Use safe masterDeckId: if masterId is -1, use 1 as fallback
    // Removed property safeMasterDeckId to avoid accessing masterId.value during initialization
    AppProperty { id: isSyncEnabled; path: "app.traktor.decks." + safeFocusedDeckId + ".sync.enabled" }
    AppProperty { path: "app.traktor.masterclock.tempo";
        onValueChanged: {
            var safeMasterDeckId = (masterId && masterId.value >= 0) ? (masterId.value + 1) : 1
            if (screenOverlay && screenOverlay.value == Overlay.bpm && (isSyncEnabled.value || safeMasterDeckId == safeFocusedDeckId)){
                overlay_countdown.restart();
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// FOOTER OVERLAY
//------------------------------------------------------------------------------------------------------------------

    MappingPropertyDescriptor { id: footerPage; path: propertiesPath + ".footer_page"; type: MappingPropertyDescriptor.Integer; value: FooterPage.empty;
        onValueChanged: {
            if (footerPage.value != FooterPage.slot1 && footerPage.value != FooterPage.slot2 && footerPage.value != FooterPage.slot3 && footerPage.value != FooterPage.slot4 && footerPage.value != FooterPage.slots) {
                previousFooterPage.value = footerPage.value
            }
        }
    }
    MappingPropertyDescriptor { id: previousFooterPage; path: propertiesPath + ".previousFooter_page"; type: MappingPropertyDescriptor.Integer; value: FooterPage.empty }
    // Define useMIDIControls as a property (defaults to false, not used in S5)
    property bool useMIDIControls: false
    
    AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }
    MappingPropertyDescriptor { id: hasFXFooter; path: propertiesPath + ".hasFXFooter"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { updateFooterPage() } }
    MappingPropertyDescriptor { id: footerHasContent; path: propertiesPath + ".footerHasContent"; type: MappingPropertyDescriptor.Boolean; value: false; onValueChanged: { updateFooterPage() } }
    MappingPropertyDescriptor { id: footerHasContentToSwitch; path: propertiesPath + ".footerHasContentToSwitch"; type: MappingPropertyDescriptor.Boolean; value: false }
    
    // Update these properties after initialization
    Component.onCompleted: {
        // Update hasFXFooter
        hasFXFooter.value = bottomFXUnit.value == 1 || bottomFXUnit.value == 2 || (bottomFXUnit.value == 3 && fxMode.value == FxMode.FourFxUnits) || (bottomFXUnit.value == 4 && fxMode.value == FxMode.FourFxUnits)
        
        // Update footerHasContent and footerHasContentToSwitch
        var footer = footerDeck()
        footerHasContent.value = useMIDIControls || hasFXFooter.value || (footer && footer.hasBottomControls)
        footerHasContentToSwitch.value = (useMIDIControls && hasFXFooter.value) || (footer && footer.hasBottomControls)
    }
    
    // Update when dependencies change
    Connections {
        target: bottomFXUnit
        function onValueChanged() {
            hasFXFooter.value = bottomFXUnit.value == 1 || bottomFXUnit.value == 2 || (bottomFXUnit.value == 3 && fxMode.value == FxMode.FourFxUnits) || (bottomFXUnit.value == 4 && fxMode.value == FxMode.FourFxUnits)
            var footer = footerDeck()
            footerHasContent.value = useMIDIControls || hasFXFooter.value || (footer && footer.hasBottomControls)
            footerHasContentToSwitch.value = (useMIDIControls && hasFXFooter.value) || (footer && footer.hasBottomControls)
        }
    }
    
    Connections {
        target: fxMode
        function onValueChanged() {
            hasFXFooter.value = bottomFXUnit.value == 1 || bottomFXUnit.value == 2 || (bottomFXUnit.value == 3 && fxMode.value == FxMode.FourFxUnits) || (bottomFXUnit.value == 4 && fxMode.value == FxMode.FourFxUnits)
            var footer = footerDeck()
            footerHasContent.value = useMIDIControls || hasFXFooter.value || (footer && footer.hasBottomControls)
            footerHasContentToSwitch.value = (useMIDIControls && hasFXFooter.value) || (footer && footer.hasBottomControls)
        }
    }
    property bool useMIDI: useMIDIControls

    onUseMIDIChanged: {
        updateFooterPage()
    }

    // updateFooterPage function moved earlier (see above)

/*
    //Bottom overlay should pop-up when Slot Parameters are being modified (S5 ONLY)
    WiresGroup {
        enabled: encoderMode.value == encoderSlotMode;
        Wire { from: DirectPropertyAdapter{ path: propertiesPath + ".slot_selector_mode.any" } to: "BottomInfoOverlay.input.boolean_value" }
        Wire { from: "BottomInfoOverlay.output"; to: DirectPropertyAdapter{ path: propertiesPath + ".bottom_info_show" } }
    }
*/

//------------------------------------------------------------------------------------------------------------------
// FX CONTROLS
//------------------------------------------------------------------------------------------------------------------

    FXControls {
        name: "topFX"
        active: !shift || bottomFXUnit.value == 0
        surface: side.surface
        unit: topFXUnit.value
        focusedPanel: "top"
    }
    FXControls {
        name: "bottomFX"
        active: shift && bottomFXUnit.value != 0
        surface: side.surface
        unit: bottomFXUnit.value
        focusedPanel: "bottom"
    }
}
