import CSI 1.0
import QtQuick 2.12
import Traktor.Gui 1.0 as Traktor

Item {
  id: fxsBox

  height: !onlyTwo && showMixerFX ? (fxSize*3 + spacing*2) + 1 : (fxSize*2 + spacing) + 1
  width: fxSize*2 + spacing

  property int fxSize: 14
  property int fxRadius: 0
  property int spacing: 2

  property bool onlyTwo: false
  property bool showMixerFX: false

  AppProperty { id: fx1Type; path: "app.traktor.fx.1.type" }
  AppProperty { id: fx2Type; path: "app.traktor.fx.2.type" }
  AppProperty { id: fx3Type; path: "app.traktor.fx.3.type" }
  AppProperty { id: fx4Type; path: "app.traktor.fx.4.type" }
  property color fx1UnitColor: fx1Type.value != FxType.PatternPlayer ? colors.orange : colors.fxPatternPlayer
  property color fx2UnitColor: fx2Type.value != FxType.PatternPlayer ? colors.orange : colors.fxPatternPlayer
  property color fx3UnitColor: fx3Type.value != FxType.PatternPlayer ? colors.orange : colors.fxPatternPlayer
  property color fx4UnitColor: fx4Type.value != FxType.PatternPlayer ? colors.orange : colors.fxPatternPlayer

  //TODO: Use Grid Layout instead?

  //FX 1 (or 3 shifted)
  Rectangle {
    anchors.top: parent.top
    anchors.left: parent.left
    width: fxSize
    height:	fxSize
    radius:	fxRadius
    color: onlyTwo && shift && fxMode.value == FxMode.FourFxUnits ? (fx3Enabled.value ? fx3UnitColor : colors.colorGrey72) : (fx1Enabled.value ? fx1UnitColor : colors.colorGrey72)

    //Behavior on opacity { NumberAnimation { duration: speed } }

    Text {
        anchors.fill: parent
        anchors.topMargin: 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: onlyTwo && shift && fxMode.value == FxMode.FourFxUnits ? "3" : "1"
        font.pixelSize: fonts.scale(fxSize-3)
        color: "black"
    }
  }

  //FX 2
  Rectangle {
    anchors.top: parent.top
    anchors.right: parent.right
    width: fxSize
    height:	fxSize
    radius:	fxRadius
    color:  onlyTwo && shift && fxMode.value == FxMode.FourFxUnits ? (fx4Enabled.value ? fx4UnitColor : colors.colorGrey72) : (fx2Enabled.value ? fx2UnitColor : colors.colorGrey72)

    //Behavior on opacity { NumberAnimation { duration: speed } }

    Text {
        anchors.fill: parent
        anchors.topMargin: 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: onlyTwo && shift && fxMode.value == FxMode.FourFxUnits ? "4" : "2"
        font.pixelSize: fonts.scale(fxSize-3)
        color: "black"
    }
  }

  //FX 3
  Rectangle {
    anchors.top: parent.top
    anchors.topMargin: fxSize + spacing
    anchors.left: parent.left
    width: fxSize
    height:	fxSize
    radius:	fxRadius
    color: fx3Enabled.value ? fx3UnitColor : colors.colorGrey72
    visible: !onlyTwo && fxMode.value == FxMode.FourFxUnits

    //Behavior on opacity { NumberAnimation { duration: speed } }
    Text {
        anchors.fill:	parent
        anchors.topMargin: 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: "3"
        font.pixelSize: fonts.scale(fxSize-3)
        color: "black"
    }
  }

  //FX 4
  Rectangle {
    anchors.top: parent.top
    anchors.topMargin: fxSize + spacing
    anchors.right: parent.right
    width: fxSize
    height:	fxSize
    radius:	fxRadius
    color: fx4Enabled.value ? fx4UnitColor : colors.colorGrey72
    visible: !onlyTwo && fxMode.value == FxMode.FourFxUnits

    //Behavior on opacity { NumberAnimation { duration: speed } }

    Text {
        anchors.fill: parent
        anchors.topMargin: 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: "4"
        font.pixelSize: fonts.scale(fxSize-3)
        color: "black"
    }
  }

  //FX Text
  Text {
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter

    text: "FX"
    font.pixelSize: fonts.scale(fxSize-3)
    font.family: "Pragmatica"
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: colors.colorGrey72
    visible: !showMixerFX && (onlyTwo || fxMode.value == FxMode.TwoFxUnits)
  }

  //MixerFX Text
  Text {
    id: mixerfx_indicator
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter

    text: mixerFXLabels[mixerFX.value]
    font.family: "Pragmatica MediumTT"
    font.pixelSize: fonts.scale(fxSize-1)
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
    color: mixerFXOn.value ? colors.mixerFXColors[mixerFX.value] : colors.colorGrey72
    visible: showMixerFX

    Behavior on visible { NumberAnimation { duration: speed } }
  }
}
