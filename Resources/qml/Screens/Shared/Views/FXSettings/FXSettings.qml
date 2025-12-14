import CSI 1.0
import QtQuick 2.12

import '../../Overlays'

FullscreenOverlay {
    id: fxSettings

    anchors.fill: parent
    //onVisibleChanged: { body.updateFxSelection() }

    property string propertiesPath: ""
    property var topFXUnit: null
    property var bottomFXUnit: null

    // Define MappingProperty first before using it
    MappingProperty { id: fxSettingsTab; path: propertiesPath +  ".fxSettings_tab" }
    MappingProperty { id: hasFXFooter; path: propertiesPath + ".hasFXFooter" }

    // Initialize unit with safe defaults - use 1 if values aren't ready
    property int unit: (fxSettingsTab && fxSettingsTab.value) ? 
        (fxSettingsTab.value <= 4 ? (topFXUnit && topFXUnit.value ? topFXUnit.value : 1) : (bottomFXUnit && bottomFXUnit.value ? bottomFXUnit.value : 1)) : 1
    property int activeTab: (fxSettingsTab && fxSettingsTab.value) ? ((fxSettingsTab.value-1) % 4) : 0 //-1 to "fix the 4 % 4 = 0 issue". Otherwise, on Group FX units, when the active tab is the third FX, it wouldn't be detected
    
    // Define AppProperty paths with safe defaults
    property string fxUnitPath: "app.traktor.fx." + unit
    AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units"; onValueChanged: { if (fxType) updateActiveTab() } }
    AppProperty { id: fxRouting; path: fxUnitPath + ".routing" }
    AppProperty { id: fxType; path: fxUnitPath + ".type"; onValueChanged: { updateActiveTab() } }
    AppProperty { id: fxSelect; path: fxUnitPath + ".select." + Math.max(1, activeTab); onValueChanged: { if (body) body.updateFxSelection() } }
    AppProperty { id: fxSnapshotStore; path: fxUnitPath + ".store" }
    AppProperty { id: fxSnapshotLoad; path: fxUnitPath + ".load" }
    
    property color fxUnitColor: (fxType && fxType.value != FxType.PatternPlayer) ? colors.orange : colors.fxPatternPlayer

    Tabs {
        id: header
        unit: (topFXUnit && topFXUnit.value) ? topFXUnit.value : 1
        activeTab: parent.activeTab
        focused: (fxSettingsTab && fxSettingsTab.value) ? (fxSettingsTab.value <= 4) : false
        anchors.top: parent.top
    }

    Tabs {
        id: bottom
        unit: (bottomFXUnit && bottomFXUnit.value) ? bottomFXUnit.value : 1
        activeTab: parent.activeTab
        focused: (fxSettingsTab && fxSettingsTab.value) ? (fxSettingsTab.value > 4) : false
        anchors.bottom: parent.bottom
    }

    Body {
        id: body
        unit: parent.unit
        activeTab: parent.activeTab
        propertiesPath: propertiesPath
        fxSettingsTab: fxSettingsTab
        topFXUnit: topFXUnit
        bottomFXUnit: bottomFXUnit
        fxMode: fxMode
        fxType: fxType
        fxRouting: fxRouting
        fxSnapshotStore: fxSnapshotStore
        fxSnapshotLoad: fxSnapshotLoad
    }

    function updateActiveTab() {
        if (!fxType || !fxMode || !fxSettingsTab) return;
        if (fxType.value == FxType.Single && activeTab >= 2) {
            if (fxSettingsTab.value <= 4) {
                fxSettingsTab.value = 2
            }
            else {
                fxSettingsTab.value = 6
            }
        }
        if (fxMode.value == FxMode.TwoFxUnits && unit > 2) {
            if (fxSettingsTab.value <= 4) {
                fxSettingsTab.value = 1
            }
            else {
                fxSettingsTab.value = 5
            }
        }
    }
}
