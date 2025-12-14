import CSI 1.0
import QtQuick 2.12

import "../../Defines"
import "../../Helpers/LED.js" as LED

Module {
    id: module
    property bool active: true
    property int deckId: 1 //1-4
    property string surface: "path"

    // Ensure deckId is always valid (1-4)
    property int safeDeckId: (deckId >= 1 && deckId <= 4) ? deckId : 1

    //Freeze Slice PopUp + Freeze/Effects Mode
    ButtonScriptAdapter {
        name: "FreezeButton"
        brightness: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.value == PadsMode.freeze && typeof freezeButton !== 'undefined' && freezeButton && freezeButton.value == 0) || (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.value == PadsMode.effects && typeof freezeButton !== 'undefined' && freezeButton && freezeButton.value == 1)
        color: LED.legacy(safeDeckId)
        onPress: {
            if (typeof holdFreeze_countdown !== 'undefined' && holdFreeze_countdown) holdFreeze_countdown.restart()
        }
        onRelease: {
            if (typeof holdFreeze_countdown !== 'undefined' && holdFreeze_countdown && holdFreeze_countdown.running) {
                var shiftValue = (typeof shift !== 'undefined' && shift && shift.value) ? true : false
                var freezeButtonValue = (typeof freezeButton !== 'undefined' && freezeButton) ? freezeButton.value : 0
                var hasDeckProps = (typeof hasDeckProperties !== 'undefined' && hasDeckProperties) ? hasDeckProperties : false
                if (hasDeckProps && typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.value != PadsMode.freeze && !shiftValue && freezeButtonValue == 0) {
                    activePadsMode.value = PadsMode.freeze
                }
                else if (hasDeckProps && typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.value == PadsMode.freeze && !shiftValue && freezeButtonValue == 0) {
                    if (typeof deck !== 'undefined' && deck && typeof deck.defaultPadsMode === 'function') {
                        var defaultMode = deck.defaultPadsMode()
                        if (defaultMode !== undefined && activePadsMode) activePadsMode.value = defaultMode
                    }
                }
                else if (!shiftValue && freezeButtonValue == 1 && typeof activePadsMode !== 'undefined' && activePadsMode) {
                    activePadsMode.value = PadsMode.effects
                }
            }
            if (typeof holdFreeze_countdown !== 'undefined' && holdFreeze_countdown) holdFreeze_countdown.stop()
            if (typeof holdFreeze !== 'undefined' && holdFreeze) holdFreeze.value = false
        }
    }
    Timer { id: holdFreeze_countdown; interval: (typeof holdTimer !== 'undefined' && holdTimer) ? holdTimer.value : 1000
        onTriggered: {
            if (typeof hasDeckProperties !== 'undefined' && hasDeckProperties && typeof holdFreeze !== 'undefined' && holdFreeze) holdFreeze.value = true
        }
    }

    //Remix Capture Source + Remix/Legacy Remix Mode
    ButtonScriptAdapter {
        name: "RemixButton"
        brightness: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.value == PadsMode.legacyRemix && typeof legacyRemixMode !== 'undefined' && legacyRemixMode && legacyRemixMode.value) || (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.value == PadsMode.remix && (typeof legacyRemixMode === 'undefined' || !legacyRemixMode || !legacyRemixMode.value))
        color: LED.legacy(safeDeckId)
        onPress: {
            if (typeof holdRemix_countdown !== 'undefined' && holdRemix_countdown) holdRemix_countdown.restart()
        }
        onRelease: {
            if (typeof holdRemix_countdown !== 'undefined' && holdRemix_countdown && holdRemix_countdown.running) {
                var legacyRemixValue = (typeof legacyRemixMode !== 'undefined' && legacyRemixMode) ? legacyRemixMode.value : false
                if (typeof activePadsMode !== 'undefined' && activePadsMode) {
                    if ((legacyRemixValue && activePadsMode.value != PadsMode.legacyRemix) || (!legacyRemixValue && activePadsMode.value == PadsMode.remix)) {
                        activePadsMode.value = PadsMode.legacyRemix
                    }
                    else if ((!legacyRemixValue && activePadsMode.value != PadsMode.remix) || (legacyRemixValue && activePadsMode.value == PadsMode.legacyRemix)) {
                        activePadsMode.value = PadsMode.remix
                    }
                }
            }
            if (typeof holdRemix_countdown !== 'undefined' && holdRemix_countdown) holdRemix_countdown.stop()
            if (typeof holdRemix !== 'undefined' && holdRemix) holdRemix.value = false
        }
    }
    Timer { id: holdRemix_countdown; interval: (typeof holdTimer !== 'undefined' && holdTimer) ? holdTimer.value : 1000
        onTriggered: {
            var remixControlledValue = (typeof remixControlled !== 'undefined' && remixControlled) ? remixControlled : false
            var hasRemixProps = (typeof hasRemixProperties !== 'undefined' && hasRemixProperties) ? hasRemixProperties : false
            if (remixControlledValue && hasRemixProps && typeof holdRemix !== 'undefined' && holdRemix) holdRemix.value = true
        }
    }

    WiresGroup {
        enabled: (typeof directThru === 'undefined' || !directThru || !directThru.value)

        //Pads Mode
        WiresGroup {
            enabled: (typeof deck !== 'undefined' && deck && deck.active)

            //Hotcue Mode
            Wire { from: "%surface%.hotcue"; to: SetPropertyAdapter { path: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) ? activePadsMode.path : ""; value: PadsMode.hotcues; color: LED.legacy(safeDeckId) } enabled: (typeof hasTrackProperties !== 'undefined' && hasTrackProperties) && (typeof shift === 'undefined' || !shift || !shift.value) && (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) }
            Wire { from: "%surface%.hotcue"; to: SetPropertyAdapter { path: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) ? activePadsMode.path : ""; value: PadsMode.tonePlay; color: LED.legacy(safeDeckId) } enabled: (typeof hasTrackProperties !== 'undefined' && hasTrackProperties) && (typeof shift !== 'undefined' && shift && shift.value) && (typeof shiftHotcueButton !== 'undefined' && shiftHotcueButton && shiftHotcueButton.value == 3) && (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) }

            //Loop Modes
            Wire { from: "%surface%.hotcue"; to: SetPropertyAdapter { path: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) ? activePadsMode.path : ""; value: PadsMode.loop; color: LED.legacy(safeDeckId) } enabled: (typeof hasDeckProperties !== 'undefined' && hasDeckProperties) && (typeof shift !== 'undefined' && shift && shift.value) && (typeof shiftHotcueButton !== 'undefined' && shiftHotcueButton && shiftHotcueButton.value == 0) && (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) }
            Wire { from: "%surface%.hotcue"; to: SetPropertyAdapter { path: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) ? activePadsMode.path : ""; value: PadsMode.advancedLoop; color: LED.legacy(safeDeckId) } enabled: (typeof hasDeckProperties !== 'undefined' && hasDeckProperties) && (typeof shift !== 'undefined' && shift && shift.value) && (typeof shiftHotcueButton !== 'undefined' && shiftHotcueButton && shiftHotcueButton.value == 1) && (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) }
            Wire { from: "%surface%.hotcue"; to: SetPropertyAdapter { path: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) ? activePadsMode.path : ""; value: PadsMode.loopRoll; color: LED.legacy(safeDeckId) } enabled: (typeof hasDeckProperties !== 'undefined' && hasDeckProperties) && (typeof shift !== 'undefined' && shift && shift.value) && (typeof shiftHotcueButton !== 'undefined' && shiftHotcueButton && shiftHotcueButton.value == 2) && (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) }

            //Freeze Button
            Wire { from: "%surface%.freeze"; to: "FreezeButton"; enabled: (typeof shift === 'undefined' || !shift || !shift.value) && ((typeof hasDeckProperties !== 'undefined' && hasDeckProperties) && (typeof padsMode !== 'undefined' && padsMode && padsMode.value != PadsMode.freeze) && (typeof freezeButton !== 'undefined' && freezeButton && freezeButton.value == 0)) || ((typeof hasDeckProperties !== 'undefined' && hasDeckProperties) && (typeof padsMode !== 'undefined' && padsMode && padsMode.value == PadsMode.freeze) && (typeof freezeButton !== 'undefined' && freezeButton && freezeButton.value == 0)) || (typeof freezeButton !== 'undefined' && freezeButton && freezeButton.value == 1) }
            WiresGroup {
                enabled: typeof shift !== 'undefined' && shift && shift.value
                Wire { from: "%surface%.freeze"; to: SetPropertyAdapter { path: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) ? activePadsMode.path : ""; value: PadsMode.freeze; output: false } enabled: (typeof hasDeckProperties !== 'undefined' && hasDeckProperties) && (typeof padsMode !== 'undefined' && padsMode && padsMode.value != PadsMode.freeze) && (typeof shiftFreezeButton !== 'undefined' && shiftFreezeButton && shiftFreezeButton.value == 0) && (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) }
                Wire { from: "%surface%.freeze"; to: SetPropertyAdapter { path: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) ? activePadsMode.path : ""; value: (typeof defaultPadsMode === 'function') ? defaultPadsMode() : PadsMode.disabled; output: false } enabled: (typeof hasDeckProperties !== 'undefined' && hasDeckProperties) && (typeof padsMode !== 'undefined' && padsMode && padsMode.value == PadsMode.freeze) && (typeof shiftFreezeButton !== 'undefined' && shiftFreezeButton && shiftFreezeButton.value == 0) && (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) && (typeof defaultPadsMode === 'function') }
                Wire { from: "%surface%.freeze"; to: ButtonScriptAdapter { brightness: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.value == PadsMode.freeze) ? true : false; color: LED.legacy(safeDeckId) } enabled: (typeof hasDeckProperties !== 'undefined' && hasDeckProperties) && (typeof shiftFreezeButton !== 'undefined' && shiftFreezeButton && shiftFreezeButton.value == 0) }
                Wire { from: "%surface%.freeze"; to: SetPropertyAdapter { path: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) ? activePadsMode.path : ""; value: PadsMode.effects; color: LED.legacy(safeDeckId) } enabled: (typeof shiftFreezeButton !== 'undefined' && shiftFreezeButton && shiftFreezeButton.value == 1) && (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) }
            }

            //Sequencer Mode
            Wire { from: "%surface%.remix"; to: SetPropertyAdapter { path: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) ? activePadsMode.path : ""; value: PadsMode.sequencer; color: LED.legacy(safeDeckId) } enabled: (typeof shift !== 'undefined' && shift && shift.value) && (typeof hasRemixProperties !== 'undefined' && hasRemixProperties) && (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) }
        }
        WiresGroup {
            enabled: (typeof deck !== 'undefined' && deck && deck.footerControlled)

            //Remix Mode (even if deck is in DirectThru and the other one is a Remix Deck, it's best to disable it and to control it from its own deck)
            Wire { from: "%surface%.remix"; to: "RemixButton"; enabled: (typeof shift === 'undefined' || !shift || !shift.value) && (typeof hasRemixProperties !== 'undefined' && hasRemixProperties) }
            Wire { from: "%surface%.remix"; to: SetPropertyAdapter { path: (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) ? activePadsMode.path : ""; value: PadsMode.stems; color: LED.legacy(safeDeckId) } enabled: (typeof hasStemProperties !== 'undefined' && hasStemProperties) && (typeof activePadsMode !== 'undefined' && activePadsMode && activePadsMode.path) }
        }
    }
}
