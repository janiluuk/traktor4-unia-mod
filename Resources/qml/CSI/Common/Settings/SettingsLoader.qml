import CSI 1.0
import QtQuick 2.12

import "../../../Defines"

Module {
    id: settingsloader

    // Traktor root path
    AppProperty { id: root; path: "app.traktor.settings.paths.root" }
    MappingPropertyDescriptor { id: osType; path: "mapping.state.osType"; type: MappingPropertyDescriptor.Integer; value: 0 }

    //HeaderText Settings
    MappingPropertyDescriptor { id: displayTopLeft; path: "mapping.state.displayTopLeft"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: displayTopMid; path: "mapping.state.displayTopMid"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: displayTopRight; path: "mapping.state.displayTopRight"; type: MappingPropertyDescriptor.Integer; value: 0 }

    MappingPropertyDescriptor { id: displayMidLeft; path: "mapping.state.displayMidLeft"; type: MappingPropertyDescriptor.Integer; value: 5 }
    MappingPropertyDescriptor { id: displayMidMid; path: "mapping.state.displayMidMid"; type: MappingPropertyDescriptor.Integer; value: 2 }
    MappingPropertyDescriptor { id: displayMidRight; path: "mapping.state.displayMidRight"; type: MappingPropertyDescriptor.Integer; value: 0 }

    MappingPropertyDescriptor { id: displayBottomLeft; path: "mapping.state.displayBottomLeft"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: displayBottomMid; path: "mapping.state.displayBottomMid"; type: MappingPropertyDescriptor.Integer; value: 6 }
    MappingPropertyDescriptor { id: displayBottomRight; path: "mapping.state.displayBottomRight"; type: MappingPropertyDescriptor.Integer; value: 7 }

    //MixerFX Settings
    MappingPropertyDescriptor { id: mixerFXAssigned1; path: "mapping.state.mixerFXAssigned1"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: mixerFXAssigned2; path: "mapping.state.mixerFXAssigned2"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: mixerFXAssigned3; path: "mapping.state.mixerFXAssigned3"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: mixerFXAssigned4; path: "mapping.state.mixerFXAssigned4"; type: MappingPropertyDescriptor.Integer; value: 0 }

    //KeyNotation Settings
    MappingPropertyDescriptor { id: keyNotationDisplayed; path: "mapping.state.keyNotationDisplayed"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: keyNotationExported; path: "mapping.state.keyNotationExported"; type: MappingPropertyDescriptor.Integer; value: 0 }
    MappingPropertyDescriptor { id: keyNotationExportedByPass; path: "mapping.state.keyNotationExportedByPass"; type: MappingPropertyDescriptor.Integer; value: 0 }

    // Example of Traktor's macOS settings file path - Users:nickmoon:Documents:Native Instruments:Traktor 3.6:
    // Example of Traktor's Windows settings file path - C:\Users\Nick\Documents\Native Instruments\Traktor 3.6\

    function readTraktorSettings() {
        let filePath = root.value;

        // Windows
        if (/^[a-zA-Z]:[\\\/](?:[a-zA-Z0-9]+[\\\/])*/.test(filePath)) {
            osType.value = 2;
            filePath = `file:///${filePath.replace(/\\/g,"/")}/Traktor Settings.tsi`;
        }

        // macOS
        else {
            osType.value = 1;
            filePath = filePath.replace(/:/g, "/");
            if (!filePath.startsWith("/")) filePath = `file:///Volumes/${filePath}`
            filePath = `${filePath}/Traktor Settings.tsi`
        }

        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            // https://developer.mozilla.org/es/docs/Web/API/XMLHttpRequest
            // https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/readyState
            // https://code.qt.io/cgit/qt/qtdeclarative.git/tree/examples/qml/xmlhttprequest/methods.js?h=6.3
            switch(request.readyState) {
                case XMLHttpRequest.UNSENT: //UNINITIALIZED
                    console.log("Awaiting for the XML HTTP send request...")
                    return;
                case XMLHttpRequest.OPENED: //LOADING
                    console.log("Loading Traktor Settings.tsi file...")
                    return;
                case XMLHttpRequest.HEADERS_RECEIVED: //LOADED
                    console.log("Traktor Settings.tsi file has been loaded!")
                    console.log("### File Info ###")
                    // console.log(request.getAllResponseHeaders());
                    console.log("Last modified: " + request.getResponseHeader ("Last-Modified"));
                    return;
                case XMLHttpRequest.LOADING: //INTERACTIVE
                    console.log("Processing Traktor Settings.tsi file...")
                    return;
                case XMLHttpRequest.DONE: //COMPLETED
                    console.log("Traktor Settings.tsi file has been processed!")
                    // extractSettings(request.responseText)
                    assignTraktorSettings(request.responseText);
                    return;
                default:
                    console.log("An error occured while loading Traktor Settings.tsi file...")
                    return;
            }
        }
        request.open("GET", filePath, true); // only async supported
        request.send();
    }

    function extractSettings(xml) {
        // Regex:. <Entry Name="Setting Name" Type="1" Value="Setting Value"></Entry>
        const regex = /<Entry Name="(?<name>[\w\.]+)" Type="(?<type>\d+)" Value="(?<value>[^"]+|)"><\/Entry>$/gm
        return regex.match(xml)
    }

    function extractSetting(xml, name) {
        const regex = new RegExp(`<Entry Name="(?<name>${name.replace(/\./g, "\\\.")})" Type="(?<type>\\d+)" Value="(?<value>[^"]+|)"><\/Entry>$`, "gm")
        const result = regex.exec(xml)
        // console.log(result.groups)
        // INFO: Named capturing groups are only supported with JS ECMAScript 2018 and after... So we build our own response
        // console.log(result)
        return result ? {
            name,
            type: result[2],
            value: result[3]
        } : undefined;
    }

    function assignSetting(xml, name, prop) {
        const setting = extractSetting(xml, name)
        if (setting && setting.value) prop.value = setting.value
        // console.log(name + ": " + (setting && setting.value ? setting.value : undefined))
    }

    //Extract different Traktor settings from TraktorSettings.tsi XML
    function assignTraktorSettings(xml) {
        //Track Deck layout
        assignSetting(xml, "Fileinfo.Top.Left", displayTopLeft)
        assignSetting(xml, "Fileinfo.Top.Mid",  displayTopMid)
        assignSetting(xml, "Fileinfo.Top.Right", displayTopRight)

        assignSetting(xml, "Fileinfo.Mid.Left", displayMidLeft)
        assignSetting(xml, "Fileinfo.Mid.Mid", displayMidMid)
        assignSetting(xml, "Fileinfo.Mid.Right", displayMidRight)

        assignSetting(xml, "Fileinfo.Bottom.Left", displayBottomLeft)
        assignSetting(xml, "Fileinfo.Bottom.Mid", displayBottomMid)
        assignSetting(xml, "Fileinfo.Bottom.Right", displayBottomRight)

        //Mixer FX Names
        assignSetting(xml, "Audio.ChannelFX.1.Type", mixerFXAssigned1)
        assignSetting(xml, "Audio.ChannelFX.2.Type", mixerFXAssigned2)
        assignSetting(xml, "Audio.ChannelFX.3.Type", mixerFXAssigned3)
        assignSetting(xml, "Audio.ChannelFX.4.Type", mixerFXAssigned4)

        // Key Notation
        assignSetting(xml, "Browser.KeyNotation.Displayed", keyNotationDisplayed)
        assignSetting(xml, "Browser.KeyNotation.Exported", keyNotationExported)
        assignSetting(xml, "Browser.KeyNotation.Exported.ByPass", keyNotationExportedByPass)
    }
}


