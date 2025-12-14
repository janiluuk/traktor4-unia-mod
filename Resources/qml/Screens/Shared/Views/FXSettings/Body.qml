import CSI 1.0
import QtQuick 2.12
import Qt5Compat.GraphicalEffects

import "../../../../Helpers/Utils.js" as Utils

Item {
    id: fxSelectBody
    property int unit: 1  // default to 1 to prevent invalid paths
    property int activeTab: 0  // default to 0 to prevent invalid paths
    
    // Properties that should be passed from parent
    property string propertiesPath: "mapping.state"
    property var fxSettingsTab
    property var topFXUnit
    property var bottomFXUnit
    property var fxMode
    property var fxType
    property var fxRouting
    property var fxSnapshotStore
    property var fxSnapshotLoad

    anchors.fill: parent
    anchors.margins: 5
    anchors.bottomMargin: 10
    clip: true

    //onVisibleChanged: { updateFxSelection() }

    readonly property int delegateHeight: 27
    readonly property int macroEffectChar: 0x00B6

    AppProperty { id: patternPlayerEnabled; path: "app.traktor.settings.pro.plus.pattern_player" }
    
    // Only create AppProperty path when unit and activeTab are valid (>= 1 for unit, >= 0 for activeTab)
    // Use a safe default path (fx unit 1, select 1) when values aren't ready to prevent crashes
    property string fxSelectListPath: (unit >= 1 && activeTab >= 0) ? ("app.traktor.fx." + unit + ".select." + Math.max(1, activeTab)) : "app.traktor.fx.1.select.1"
    AppProperty { 
        id: fxSelectList
        path: fxSelectListPath
        onValueChanged: {
            // Only update if we have a valid path and the list exists
            if (unit >= 1 && activeTab >= 0 && fxList && fxSelectList.value !== undefined && fxSelectList.value >= 0) {
                fxList.currentIndex = fxSelectList.value
            }
        }
    }
    // fxUnit is computed from topFXUnit/bottomFXUnit based on the active tab
    // Use a function to compute it when needed, not as a binding to avoid loops
    function getFxUnit() {
        if (!fxSettingsTab || !fxSettingsTab.value) return null
        return (fxSettingsTab.value <= 4) ? topFXUnit : bottomFXUnit
    }
    // Use a property that updates only when fxSettingsTab changes, not when fxUnit properties change
    property var fxUnit: getFxUnit()
    onFxSettingsTabChanged: {
        fxUnit = getFxUnit()
    }

    //FX Settings View
    Item {
        id: fxSettings
        function getInitialIndex() {
            if (!buttons || buttons.length === 0) return 0;
            const filtered = buttons.filter(button => button.box && !button.hide).sort((a,b) => a.column - b.column || a.row - b.row);
            return filtered.length > 0 ? computeIndex(filtered[0], 3) : 0;
        }
        property int currentIndex: getInitialIndex()

        readonly property variant buttons: [
            ({
                column: 1,
                row: 1,
                text: (fxSettingsTab && fxSettingsTab.value) ? (fxSettingsTab.value <= 4 ? "Top FX Unit" : "Bottom FX Unit") : "FX Unit",
            }),
            ({
                column: 1,
                row: 2,
                text: "Unit 1",
                description: "",
                box: true,
                radio: true,
                active: (fxUnit && fxUnit.value) == 1,
                action: () => { fxUnit.value = 1 }
            }),
            ({
                column: 1,
                row: 3,
                text: "Unit 2",
                description: "",
                box: true,
                radio: true,
                active: (fxUnit && fxUnit.value) == 2,
                action: () => { fxUnit.value = 2 }
            }),
            ({
                column: 1,
                row: 4,
                text: "Unit 3",
                description: "",
                box: true,
                radio: true,
                active: (fxUnit && fxUnit.value) == 3,
                action: () => { if (fxMode && fxMode.value == FxMode.FourFxUnits && fxUnit) fxUnit.value = 3 }
            }),
            ({
                column: 1,
                row: 5,
                text: "Unit 4",
                description: "",
                box: true,
                radio: true,
                active: (fxUnit && fxUnit.value) == 4,
                action: () => { if (fxMode && fxMode.value == FxMode.FourFxUnits && fxUnit) fxUnit.value = 4 }
            }),
            ({
                column: 1,
                row: 6,
                text: "Disabled",
                description: "",
                box: true,
                radio: true,
                active: (fxUnit && fxUnit.value) == 0,
                action: () => { if (fxUnit) fxUnit.value = 0 },
                hide: (fxSettingsTab && fxSettingsTab.value) ? (fxSettingsTab.value <= 4) : false
            }),
            ({
                column: 2,
                row: 1,
                text: "Type",
            }),
            ({
                column: 2,
                row: 2,
                text: "Single",
                description: "Set FX Unit as a Single Effect Unit",
                box: true,
                radio: true,
                active: (fxType && fxType.value) == FxType.Single,
                action: () => { fxType.value = FxType.Single }
            }),
            ({
                column: 2,
                row: 3,
                text: "Group",
                description: "Set FX Unit as a Group Effect Unit",
                box: true,
                radio: true,
                active: (fxType && fxType.value) == FxType.Group,
                action: () => { fxType.value = FxType.Group }
            }),
            ({
                column: 2,
                row: 4,
                text: "Pattern Player",
                description: "Set FX Unit as a Pattern Player Unit",
                box: true,
                radio: true,
                active: (fxType && fxType.value) == FxType.PatternPlayer,
                action: () => { fxType.value = FxType.PatternPlayer }
            }),
            ({
                column: 2,
                row: 5,
                text: "FX Units",
            }),
            ({
                column: 2,
                row: 6,
                text: "2 FX Units",
                description: "Only 2 FX Units will be visible (all 4 are usable with HW)",
                box: true,
                radio: true,
                active: (fxMode && fxMode.value) == FxMode.TwoFxUnits,
                action: () => { fxMode.value = FxMode.TwoFxUnits }
            }),
            ({
                column: 2,
                row: 7,
                text: "4 FX Units",
                description: "All 4 FX Units will be visible (and usable with HW)",
                box: true,
                radio: true,
                active: (fxMode && fxMode.value) == FxMode.FourFxUnits,
                action: () => { fxMode.value = FxMode.FourFxUnits }
            }),
            ({
                column: 3,
                row: 1,
                text: "Routing",
            }),
            ({
                column: 3,
                row: 2,
                text: "Insert",
                description: "Applied to the input signal of the channel",
                box: true,
                radio: true,
                active: (fxRouting && fxRouting.value) == FxRouting.Insert,
                action: () => { fxRouting.value = FxRouting.Insert }
            }),
            ({
                column: 3,
                row: 3,
                text: "Post Fader",
                description: "Applied to the output signal of the channel",
                box: true,
                radio: true,
                active: (fxRouting && fxRouting.value) == FxRouting.PostFader,
                action: () => { fxRouting.value = FxRouting.PostFader }
            }),
            ({
                column: 3,
                row: 4,
                text: "Send",
                description: "For external mixing only!",
                box: true,
                radio: true,
                active: (fxRouting && fxRouting.value) == FxRouting.Send,
                action: () => { fxRouting.value = FxRouting.Send }
            }),
            ({
                column: 3,
                row: 5,
                text: "Snapshot",
            }),
            ({
                column: 3,
                row: 6,
                text: "Save",
                description: "Take a snapshot of the current state of the unit",
                box: true,
                radio: false,
                active: (fxSnapshotStore && fxSnapshotStore.value) == true,
                action: () => { fxSnapshotStore.value = true }
            }),
            ({
                column: 3,
                row: 7,
                text: "Load",
                description: "Load a snapshot of a previously saved state of the unit",
                box: true,
                radio: false,
                active: (fxSnapshotLoad && fxSnapshotLoad.value) == true,
                action: () => { fxSnapshotLoad.value = true }
            }),
        ]

        anchors.fill: parent
        visible: activeTab == 0

        Grid {
            id: grid
            columns: 3
            rows: 7
            columnSpacing: fxSelectBody.width * 0.05
            rowSpacing: 5
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -10

            Repeater {
                model: parent.columns*parent.rows

                // Button field
                Rectangle {
                    property int column: index%grid.columns
                    property int row: Math.trunc(index/grid.columns)
                    property variant button: getButton(column, row, fxSettings.buttons)
                    property bool selected: fxSettings.currentIndex == index

                    width: fxSelectBody.width * 0.85/3
                    height: fxSelectBody.height * 0.1
                    color: button && button.box ? colors.colorGrey16 : "transparent"
                    border.width: 1
                    opacity: button && !button.hide ? 1 : 0
                    border.color: selected ? fxUnitColor : "transparent" //button.box ? (selected ? fxUnitColor : colors.colorGrey32) : "transparent"

                    Text {
                        anchors.horizontalCenter: button && !button.box ? parent.horizontalCenter : undefined
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: button && !button.box ? parent.height*0.25 : 0
                        x: 9
                        font.pixelSize: fonts.middleFontSize
                        text: button && button.text || ""
                        color: button && !button.box ? fxUnitColor : (selected ? fxUnitColor : colors.colorFontFxHeader)
                    }

                    // Radio button
                    Rectangle {
                        visible: button && button.radio ? true : false
                        width: 8
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -1
                        anchors.right: parent.right
                        anchors.rightMargin: 9
                        radius: 4
                        border.width: 1
                        border.color: selected ? fxUnitColor : colors.colorGrey72
                        color: button && button.active ? fxUnitColor : "transparent"
                    }
                }
            }
        }
    }

    // Settings Description Text
    Text{
        property variant button: getButtonWithIndex(fxSettings.currentIndex, fxSettings.buttons)
        id: preference_descriptor
        font.family: "Pragmatica"
        font.pixelSize: fonts.middleFontSize
        anchors.bottom: parent.bottom
        anchors.topMargin: 230
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        color: fxUnitColor
        text: button.description
        visible: activeTab == 0 && button.description
    }


    //FX List View
    ListView {
        id: fxList
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 33
        height: 189
        clip: true

        /*
        // INFO: Awaiting for the Traktor team to support Pattern Player kit selection...
        visible: activeTab != 0
        model: fxType.value != FxType.PatternPlayer ? fxSelectList.valuesDescription : patterPlayer.valuesDescription
        */
        visible: activeTab != 0 && (fxType && fxType.value != FxType.PatternPlayer)
        model: fxSelectList.valuesDescription

        delegate:
            Item {
            id: contactDelegate
            anchors.left: parent ? parent.left : undefined
            anchors.right: parent ? parent.right : undefined
            height: delegateHeight // item (= line) height
            width: parent ? parent.width : 0

            property bool isCurrentItem: ListView.isCurrentItem
            readonly property bool isMacroFx: (modelData.charCodeAt(0) == macroEffectChar)
            Image {
                id: macroIcon
                source: "../../Images/Fx_Multi_Icon_Large.png"
                fillMode: Image.PreserveAspectCrop
                width: sourceSize.width
                height: sourceSize.height
                anchors.right: fxName.left
                anchors.top: parent.top
                anchors.rightMargin: 5
                anchors.topMargin: 5
                visible: false
                smooth: false
            }
            ColorOverlay {
                anchors.fill: macroIcon
                source: macroIcon
                color: fxSelectList.description == modelData ? fxUnitColor : (isCurrentItem ? colors.colorWhite : colors.colorGrey56)
                visible: isMacroFx
            }

            //FX Name
            Text {
                id: fxName
                anchors.centerIn: parent

                anchors.horizontalCenterOffset: isMacroFx ? 10 : 0
                font.pixelSize: fonts.largeFontSize
                font.capitalization: Font.AllUppercase
                color: fxSelectList.description == modelData ? fxUnitColor : (isCurrentItem ? colors.colorWhite : colors.colorFontsListFx)
                text: isMacroFx? modelData.substr(1) : modelData
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// SETTINGS NAVIGATION
//------------------------------------------------------------------------------------------------------------------

    property int preNavMenuValue: 0
    MappingProperty { id: settingsNavigation; path: propertiesPath + ".fxSettingsNavigation"
        onValueChanged: {
            const delta = settingsNavigation.value - preNavMenuValue
            preNavMenuValue = settingsNavigation.value
            if (activeTab == 0) {
                const count = fxSettings.buttons.filter(button => button.box && !button.hide).length
                fxSettings.currentIndex = getNextIndex(fxSettings.currentIndex, delta, fxSettings.buttons)
            }
            else {
                const index = fxList.currentIndex + delta
                fxList.currentIndex = Utils.clamp(index, 0, fxList.count-1)
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// SETTINGS SELECTION
//------------------------------------------------------------------------------------------------------------------

    MappingProperty { id: settingsPush; path: propertiesPath + ".fxSettingsPush"
        onValueChanged: {
            if (activeTab == 0) {
                /*
                if (fxSettings.buttons[fxSettings.currentIndex].action) {
                    console.log("It has a function")
                    return fxSettings.buttons[fxSettings.currentIndex].action
                }
                */
                if (fxSettings.currentIndex == 3 && fxUnit) fxUnit.value = 1
                else if (fxSettings.currentIndex == 6 && fxUnit) fxUnit.value = 2
                else if (fxSettings.currentIndex == 9 && fxMode && fxMode.value == FxMode.FourFxUnits && fxUnit) fxUnit.value = 3
                else if (fxSettings.currentIndex == 12 && fxMode && fxMode.value == FxMode.FourFxUnits && fxUnit) fxUnit.value = 4
                else if (fxSettings.currentIndex == 15 && fxSettingsTab && fxSettingsTab.value > 4 && fxUnit) fxUnit.value = 0

                else if (fxSettings.currentIndex == 4 && fxType) fxType.value = FxType.Single
                else if (fxSettings.currentIndex == 7 && fxType) fxType.value = FxType.Group
                else if (fxSettings.currentIndex == 10 && patternPlayerEnabled.value && fxType) fxType.value = FxType.PatternPlayer

                else if (fxSettings.currentIndex == 16 && fxMode) fxMode.value = FxMode.TwoFxUnits
                else if (fxSettings.currentIndex == 19 && fxMode) fxMode.value = FxMode.FourFxUnits

                else if (fxSettings.currentIndex == 5 && fxRouting) fxRouting.value = FxRouting.Insert
                else if (fxSettings.currentIndex == 8 && fxRouting) fxRouting.value = FxRouting.PostFader
                else if (fxSettings.currentIndex == 11 && fxRouting) fxRouting.value = FxRouting.Send

                else if (fxSettings.currentIndex == 17 && fxSnapshotStore) fxSnapshotStore.value = true
                else if (fxSettings.currentIndex == 20 && fxSnapshotLoad) fxSnapshotLoad.value = true
            }
            else {
                if (fxType && fxType.value != FxType.PatternPlayer && fxSelectList) fxSelectList.value = fxList.currentIndex
                // TODO TP-17057 we prevent fx selection if pattern player is selected...
                // INFO: Awaiting for the Traktor team to support Pattern Player kit selection...
                //else

                //Auto close FX Select overlay when selecting an effect of the list
                //screenOverlay.value = Overlay.none
            }
        }
    }

//------------------------------------------------------------------------------------------------------------------
// HELPER FUNCTIONS
//------------------------------------------------------------------------------------------------------------------

    function getButton(column, row, buttons) {
        return buttons.find(button => button.column == column+1 && button.row == row+1)
    }

    function getButtonWithIndex(current, buttons) {
        const columns = 3;
        const column = (current % columns)
        const row = Math.trunc(current / columns)

        return getButton(column, row, buttons)
    }

    function getNextIndex(current, delta, buttons) {
        const columns = 3;
        const column = (current % columns)
        const row = Math.trunc(current / columns)

        const boxes = buttons.filter(button => button.box && !button.hide).sort((a,b) => a.column - b.column || a.row - b.row)
        if (boxes.length === 0) return 0;
        
        const min = 0 //calculateIndex(boxes[0], columns)
        const max = boxes.length - 1 //calculateIndex(boxes[-1], columns)

        let active = boxes.findIndex(button => button.column == column+1 && button.row == row+1)
        if (active < 0) active = 0; // fallback if not found
        active = Utils.clamp(active, min, max)
        let next = active + delta // < min || active + delta +1 > boxes.length ? (active+delta) % boxes.length : active+delta;
        next = next < min ? max - (-next-1 + min) : next > max ? min + (next-1 - max) : next;
        next = Utils.clamp(next, min, max); // ensure next is in bounds
        return computeIndex(boxes[next], columns)
    }

    function computeIndex(box, columns){
        if (!box) return 0; // safety check
        return (box.row-1)*columns + box.column - 1
    }

    function updateFxSelection() {
        if (fxSelect.value) {
            //preNavMenuValue = fxSelect.value //fxList.currentIndex
            fxList.currentIndex = Utils.clamp(fxSelect.value, 0, fxList.count-1)
        }
    }
}
