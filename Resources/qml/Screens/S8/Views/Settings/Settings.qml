import CSI 1.0
import QtQuick 2.12
import Qt5Compat.GraphicalEffects

import '../../../Shared/Overlays'
import '../../../Shared/Widgets' as Widgets

FullscreenOverlay {
    id: settings

    anchors.fill: parent
    clip: true

    readonly property bool isTraktorS5: screen.flavor == ScreenFlavor.S5
    readonly property bool isTraktorS8: screen.flavor == ScreenFlavor.S8
    readonly property bool isTraktorD2: screen.flavor == ScreenFlavor.D2

//------------------------------------------------------------------------------------------------------------------
// UNIA MOD
//------------------------------------------------------------------------------------------------------------------

    Text{
        id: header
        font.family: "Pragmatica"
        font.pixelSize: 22
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        color: colors.cyan
        text: "UNIA MOD " + version.beta
    }

//------------------------------------------------------------------------------------------------------------------
// RECORDING STATUS (Main Menu)
//------------------------------------------------------------------------------------------------------------------

    AppProperty { id: mixRecorderRecording; path: "app.traktor.mix_recorder.recording" }
    AppProperty { id: mixRecorderTime; path: "app.traktor.mix_recorder.recording_time" }
    AppProperty { id: broadcastEnabled; path: "app.traktor.broadcast.enabled" }

    function formatRecordingTime(ms) {
        var totalMs = Number(ms);
        if (isNaN(totalMs) || totalMs < 0) return "00:00";
        var totalSeconds = Math.floor(totalMs / 1000);
        var hours = Math.floor(totalSeconds / 3600);
        var minutes = Math.floor((totalSeconds % 3600) / 60);
        var seconds = totalSeconds % 60;
        var minutesStr = (minutes < 10 ? "0" : "") + minutes;
        var secondsStr = (seconds < 10 ? "0" : "") + seconds;
        if (hours > 0) {
            var hoursStr = (hours < 10 ? "0" : "") + hours;
            return hoursStr + ":" + minutesStr + ":" + secondsStr;
        }
        return minutesStr + ":" + secondsStr;
    }

    // Recording Status Widget
    Rectangle {
        id: recordingWidget
        anchors.top: parent.top
        anchors.topMargin: 52
        anchors.right: parent.right
        anchors.rightMargin: 15
        width: 200
        height: 50
        color: colors.colorGrey16
        border.width: 1
        border.color: mixRecorderRecording.value ? colors.cyan : colors.colorGrey32
        visible: firstIndex == 0
        clip: true

        Column {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                font.pixelSize: 12
                color: colors.colorFontFxHeader
                text: "RECORDING"
            }

            Text {
                font.pixelSize: 14
                font.bold: true
                color: mixRecorderRecording.value ? colors.cyan : colors.colorFontsListFx
                text: mixRecorderRecording.value ? "ON" : "OFF"
            }

            Text {
                font.pixelSize: 11
                color: colors.colorFontsListFx
                text: formatRecordingTime(mixRecorderTime.value)
            }
        }

        // Toggle button indicator
        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            width: 60
            height: 30
            color: mixRecorderRecording.value ? colors.cyan : colors.colorGrey32
            border.width: 1
            border.color: colors.colorGrey64

            Text {
                anchors.centerIn: parent
                font.pixelSize: 11
                font.bold: true
                color: mixRecorderRecording.value ? "black" : colors.colorWhite
                text: mixRecorderRecording.value ? "STOP" : "START"
            }
        }
    }


//------------------------------------------------------------------------------------------------------------------
// SETTINGS
//------------------------------------------------------------------------------------------------------------------

    property int firstIndex: firstSettingsList.selectedIndex ? firstSettingsList.selectedIndex : 0
    property int secondIndex: secondSettingsList.selectedIndex ? secondSettingsList.selectedIndex : 0
    property int thirdIndex: thirdSettingsList.selectedIndex ? thirdSettingsList.selectedIndex : 0

    //First Column Setting List
    ListView {
        id: firstSettingsList
        anchors.top: parent.top
        anchors.topMargin: 52
        anchors.left: parent.left
        anchors.leftMargin: 15
        height: 120
        width: 140
        clip: true

        property int selectedIndex: 0

        model: ["Traktor Settings", isTraktorS5  ? "Controller Setup (S5)" : (isTraktorS8 ? "Controller Setup (S8)" : "Controller Setup (D2)"), "Deck Controls", "Screens & Browser", "Workflow & Safety"]
        delegate:
            Item {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 20
            width: parent.width
            property bool isCurrentItem: ListView.isCurrentItem

            Text {
                id: firstColumnText
                anchors.left: parent.left
                font.pixelSize: 15
                //font.capitalization: Font.AllUppercase
                color: firstIndex == model.index+1 ? colors.cyan : (isCurrentItem ? colors.colorWhite : colors.colorFontsListFx)
                text: modelData
            }

            Component.onCompleted: {
                z = -1
            }
        }
    }

    //Second Column Setting List
    ListView {
        id: secondSettingsList
        anchors.top: parent.top
        anchors.topMargin: 52
        anchors.left: parent.left
        anchors.leftMargin: 170
        height: 120
        width: 140
        visible: firstIndex != 0
        clip: true

        property int selectedIndex: 0

        readonly property variant traktorNames: ["Transport", "Mix Recorder"]
        readonly property variant s8Names: ["Touch & Browsing", "Touchstrip", "LED Brightness", "MIDI Mode"]
        readonly property variant s5Names: ["Touch & Browsing", "Touchstrip", "LED Brightness", "Stem & Slot Select"]
        readonly property variant mapNames: ["Play / Pause", "Cue", "Sync Options", "Browse & Tempo Encoder", isTraktorS5 ? "Loop Encoder" : "FX Select Button", isTraktorS5 ? "Hotcue Button" : "Loop Button", "Freeze / Pad FX", "Pads & Slot Select", isTraktorD2 ? "D2 Deck Buttons" : "Fader Start" ]
        readonly property variant displayNames: ["Screen Layout", "Browser View", "Deck View", "Remix View"]
        readonly property variant otherNames: ["Overlay Timers", "Safety Fixes", "Mods & Shortcuts"]

        function secondSettingsListNames(index){
            if (index == 1) return traktorNames
            else if (index == 2 && isTraktorS5) return s5Names
            else if (index == 2 && !isTraktorS5) return s8Names
            else if (index == 3) return mapNames
            else if (index == 4) return displayNames
            else if (index == 5) return otherNames
        }

        model: secondSettingsListNames(firstIndex)
        delegate:
            Item {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 20
            width: parent.width
            property bool isCurrentItem: ListView.isCurrentItem

            Text {
                id: secondColumnText
                anchors.left: parent.left
                font.pixelSize: 15
                color: secondIndex == model.index+1 ? colors.cyan : (isCurrentItem ? colors.colorWhite : colors.colorFontsListFx)
                text: modelData
            }

            Component.onCompleted: {
                z = -1
            }
        }
    }

    //Third Column Setting List
    ListView {
        id: thirdSettingsList
        anchors.top: parent.top
        anchors.topMargin: 52
        anchors.left: parent.left
        anchors.leftMargin: 325
        height: 120
        width: 140
        visible: secondIndex != 0
        clip: true

        property int selectedIndex: 0

        //Traktor Settings
        readonly property variant transportNames: ["Sync Mode"]
        readonly property variant mixRecorderNames: ["Start/Stop Mix Recording", "Broadcast Stream", "Recording Timer"]

        //Controller Settings
        readonly property variant s8TouchControlsNames: ["Browser on Touch", "Top FX Overlay", "Performance Overlay"]
        readonly property variant s5TouchControlsNames: ["Browser on Touch", "Top FX Overlay"]
        readonly property variant touchstripNames: ["Nudge Sensitivity", "Scratch Sensitivity", "Touchstrip Mode"]
        readonly property variant ledsNames: ["Brightness"]
        readonly property variant midiNames: ["MIDI Controls"]
        readonly property variant stemNames: ["Stem Slot Select", "Stem Reset on Load"]

        //Map Settings
        readonly property variant playNames: ["Play Action", "Shift + Play", "Play LED", "Vinyl Break Settings"]
        readonly property variant cueNames: ["Cue Action","Shift + Cue", "Cue LED"]
        readonly property variant syncNames: ["Key Sync Options"]
        readonly property variant browseEncoderNames: ["Shift + Browse Push", "Browse Encoder Mode", "Shift + Browse Mode", "BPM Step Size", "Tempo Step Size"]
        readonly property variant fxSelectNames: ["FX Select", "Shift + FX Select"] //S8/D2 Only
        readonly property variant loopEncoderNames: ["Loop Encoder", "Shift + Loop Encoder"] //S5 Only
        readonly property variant loopNames: ["Loop Button", "Shift + Loop Button"] //S8/D2 Only
        readonly property variant hotcueNames: ["Shift + Hotcue"] //S5 Only
        readonly property variant freezeNames: ["Freeze Button", "Shift + Freeze Button"]
        readonly property variant padsNames: ["Slot Selector Mode", "Hotcue Play Mode", "Hotcue Colors"]
        readonly property variant fadersNames: ["Fader Start"]
        readonly property variant d2Names: ["D2 Deck Buttons"]

        //Display Settings
        readonly property variant deckGeneralNames: ["Theme", "Panels", "Bright Mode", "Top Left Corner"]
        readonly property variant browserNames: ["Related Screens", "Related Browsers", "Browser on Touch", "Rows in Browser", "Displayed Info", "Previously Played", "BPM Match Guides", "Key Match Guides", "Colored Keys", "Footer Info"]
        readonly property variant trackNames: ["Waveform Options", "Grid Options", "Stripe Options", "Performance Panel", "Beat Counter Settings", "Beat/Phase Widget", "Key Options"]
        readonly property variant remixNames: ["Volume Fader", "Filter Fader", "Slot Indicators"]

        //Other Settings
        readonly property variant timersNames: ["Browser View", "BPM/Key Overlay", "Mixer FX Overlay", "HotcueType Overlay", "Side Buttons Overlay"]
        readonly property variant fixesNames: ["BPM Controls", "Hotcue Triggering"]
        readonly property variant modsNames: ["Only focused controls", "Beatmatch Practice", "Autoenable Flux", "AutoZoom Edit Mode", "Shift Mode", "Back to Top"]
        readonly property variant modsNamesD2: ["Only focused controls", "Beatmatch Practice", "Autoenable Flux", "AutoZoom Edit Mode", "Back to Top"]

        function thirdSettingsListNames(firstIndex, secondIndex){
            if (firstIndex == 1) { //Traktor Settings
                if (secondIndex == 1) return transportNames
                else if (secondIndex == 2) return mixRecorderNames
            }
            else if (firstIndex == 2) { //Controller Settings
                if (secondIndex == 1) return isTraktorS5 ? s5TouchControlsNames : s8TouchControlsNames
                else if (secondIndex == 2) return touchstripNames
                else if (secondIndex == 3) return ledsNames
                else if (secondIndex == 4) return isTraktorS5 ? stemNames : midiNames
            }
            else if (firstIndex == 3) { //Map Settings
                if (secondIndex == 1) return playNames
                else if (secondIndex == 2) return cueNames
                else if (secondIndex == 3) return syncNames
                else if (secondIndex == 4) return browseEncoderNames
                else if (secondIndex == 5) return isTraktorS5 ? loopEncoderNames : fxSelectNames
                else if (secondIndex == 6) return isTraktorS5 ? hotcueNames : loopNames
                else if (secondIndex == 7) return freezeNames
                else if (secondIndex == 8) return padsNames
                else if (secondIndex == 9 && !isTraktorD2) return fadersNames
                else if (secondIndex == 9 && isTraktorD2) return d2Names
            }
            else if (firstIndex == 4) { //Display Settings
                if (secondIndex == 1) return deckGeneralNames
                else if (secondIndex == 2) return browserNames
                else if (secondIndex == 3) return trackNames
                else if (secondIndex == 4) return remixNames
            }
            else if (firstIndex == 5) { //Other Settings
                if (secondIndex == 1) return timersNames
                else if (secondIndex == 2) return fixesNames
                else if (secondIndex == 3) return isTraktorD2 ? modsNamesD2 : modsNames
            }
        }

        model: thirdSettingsListNames(firstIndex, secondIndex)
        delegate:
            Item {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 20 //delegateHeight // item (= line) height
            width: parent.width
            property bool isCurrentItem: ListView.isCurrentItem

            Text {
                id: thirdColumnText
                anchors.left: parent.left
                font.pixelSize: 15
                color: thirdIndex == model.index+1 ? colors.cyan : (isCurrentItem ? colors.colorWhite : colors.colorFontsListFx)
                text: modelData
            }

            Component.onCompleted: {
                z = -1
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// Divider
//------------------------------------------------------------------------------------------------------------------

    Text{
        id: divider
        font.family: "Pragmatica"
        font.pixelSize: 15
        anchors.top: parent.top
        anchors.topMargin: 175
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        color: colors.cyan
        text: "*********************************************************"
    }

//------------------------------------------------------------------------------------------------------------------
// SETTINGS GRID
//------------------------------------------------------------------------------------------------------------------

    SettingsGrid {
        id: settingsGrid
        anchors.fill: parent
        anchors.topMargin: 190
    }

    /*
    //Properties Description Text
    Text{
        id: preference_descriptor
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.left: parent.left
        anchors.right: parent.right
        color: colors.cyan
        visible: thirdIndex != 0

        text: settingsGrid.updateSettings(firstIndex, secondIndex, thirdIndex, 3, settingsGrid.currentIndex)
        font.family: "Pragmatica"
        font.pixelSize: fonts.middleFontSize
        horizontalAlignment: Text.AlignHCenter
    }
    */

    //Properties Description Text
    Widgets.ScrollingText {
        id: scrollingSettingsText
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        height: 20
        textTopMargin: -1
        textFontSize: fonts.middleFontSize
        textColor: colors.cyan
        containerColor: "transparent"
        marqueeText: (settingsGrid.updateSettings(firstIndex, secondIndex, thirdIndex, 3, settingsGrid.currentIndex) == undefined) ? "" : settingsGrid.updateSettings(firstIndex, secondIndex, thirdIndex, 3, settingsGrid.currentIndex)
        doScroll: true
        centered: true
        visible: thirdIndex != 0
    }

    //------------------------------------------------------------------------------------------------------------------
    // SETTINGS NAVIGATION
    //------------------------------------------------------------------------------------------------------------------

    property int prePreferencesNavMenuValue: 0
    MappingProperty { id: settingsNavigation; path: propertiesPath + ".preferencesNavigation";
        onValueChanged: {
            var delta = settingsNavigation.value - prePreferencesNavMenuValue;
            prePreferencesNavMenuValue = settingsNavigation.value;

            if (firstIndex == 0) {
                var index = firstSettingsList.currentIndex + delta
                firstSettingsList.currentIndex = utils.clamp(index, 0, firstSettingsList.count-1)
            }
            else {
                if (secondIndex == 0) {
                    var index = secondSettingsList.currentIndex + delta
                    secondSettingsList.currentIndex = utils.clamp(index, 0, secondSettingsList.count-1)
                }
                else {
                    if (thirdIndex == 0) {
                        var index = thirdSettingsList.currentIndex + delta
                        thirdSettingsList.currentIndex = utils.clamp(index, 0, thirdSettingsList.count-1)
                    }
                    /*
                    else if (integerEditor.value) {
                        settingsGrid.updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)
                    }
                    */
                }
            }
        }
    }

    MappingProperty { id: integerEditor; path: propertiesPath + ".integer_editor" }
    MappingProperty { id: backBright; path: propertiesPath + ".backBright" }
    MappingProperty { id: settingsBack; path: propertiesPath + ".preferencesBack";
        onValueChanged: {
            if (thirdIndex != 0 && integerEditor.value == false) {thirdIndex = 0; settingsGrid.currentIndex = 0}
            else if (secondIndex != 0 && thirdIndex == 0) secondIndex = 0;
            else if (firstIndex != 0 && secondIndex == 0) {firstIndex = 0; backBright.value = false}
        }
    }

    MappingProperty { id: settingsPush; path: propertiesPath + ".preferencesPush";
        onValueChanged: {
            if (firstIndex == 0 && settingsPush.value) {
                // Toggle recording when push button is pressed on main menu
                mixRecorderRecording.value = !mixRecorderRecording.value
                // Also allow normal navigation
                firstIndex = firstSettingsList.currentIndex+1; backBright.value = true
            }
            else if (firstIndex == 0) {firstIndex = firstSettingsList.currentIndex+1; backBright.value = true}
            else if (secondIndex == 0) secondIndex = secondSettingsList.currentIndex+1;
            else if (thirdIndex == 0) {thirdIndex = thirdSettingsList.currentIndex+1; settingsGrid.updateSettings(firstIndex, secondIndex, thirdIndex, 0, 0)}
            else {
                settingsGrid.updateSettingsParameters(firstIndex, secondIndex, thirdIndex)
            }
        }
    }
}
